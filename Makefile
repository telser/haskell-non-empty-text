all: setup build test lint

stack-yaml = stack.yaml stack-8.8.4.yaml stack-8.10.7.yaml

.PHONY: setup
setup:
# This will prefetch/build the required versions of ghc upfront
.for _stack-yaml in ${stack-yaml}
	stack --stack-yaml ${_stack-yaml} setup
.endfor
# Note: We don't actually need n versions of linting tools though, so only get ones with the default stack.yaml
	stack build hlint

.PHONY: build
build:
.for _stack-yaml in ${stack-yaml}
	stack --stack-yaml ${_stack-yaml} build --pedantic --test --no-run-tests --flag non-empty-text:ci
.endfor

.PHONY: test
test:
.for _stack-yaml in ${stack-yaml}
	stack --stack-yaml ${_stack-yaml} test --flag non-empty-text:ci
.endfor

.PHONY: lint
lint:
	stack exec hlint .
