#!/usr/bin/env bats

source ../lib/lib.sh


CLIENT_NAME="mytest"
mytest() {
	echo -e "NAME  PROP\nnginx-deployment-75675f5897-6dg9r  Running\nnginx-deployment-75675f5897-gstkw  Running"
}


@test "verifying the number of PODs with the lower-case syntax (exact number, plural)" {
	run verify "there are 2 pods named 'nginx'"
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -eq 2 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "Found 2 pods named nginx (as expected)." ]
}


@test "verifying the number of PODs with the lower-case syntax (exact number, singular)" {
	run verify "there is 1 pod named 'nginx-deployment-75675f5897-6dg9r'"
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -eq 2 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "Found 1 pod named nginx-deployment-75675f5897-6dg9r (as expected)." ]
}


@test "verifying the number of PODs with the lower-case syntax (exact number, singular mixed with plural)" {
	run verify "there are 1 pods named 'nginx-deployment-75675f5897-6dg9r'"
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -eq 2 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "Found 1 pods named nginx-deployment-75675f5897-6dg9r (as expected)." ]
}


@test "verifying the number of PODs with the lower-case syntax (exact number, 0 as singular)" {
	run verify "there is 0 pod named 'nginx-deployment-inexisting'"
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -eq 2 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "Found 0 pod named nginx-deployment-inexisting (as expected)." ]
}


@test "verifying the number of PODs with the lower-case syntax (exact number, 0 as plural)" {
	run verify "there are 0 pods named 'nginx-deployment-inexisting'"
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -eq 2 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "Found 0 pods named nginx-deployment-inexisting (as expected)." ]
}


@test "verifying the number of PODs with upper-case letters" {
	run verify "There are 2 PODS named 'nginx'"
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -eq 2 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "Found 2 pods named nginx (as expected)." ]
}


@test "verifying the syntax check (counting with invalid wording)" {
	run verify "There is 2 PODS named 'nginx'"
	[ "$status" -eq 2 ]
	[ ${#lines[@]} -eq 1 ]
	[ "${lines[0]}" = "Invalid expression: it does not respect the expected syntax." ]
}


@test "verifying the syntax check (counting with missing quotes)" {
	run verify "There are 2 PODS named nginx"
	[ "$status" -eq 2 ]
	[ ${#lines[@]} -eq 1 ]
	[ "${lines[0]}" = "Invalid expression: it does not respect the expected syntax." ]
}


@test "verifying the syntax check (empty query)" {
	run verify ""
	[ "$status" -eq 1 ]
	[ ${#lines[@]} -eq 1 ]
	[ "${lines[0]}" = "An empty expression was not expected." ]
}


@test "verifying the number of PODs with an invalid name" {
	run verify "There are 2 pods named 'nginx-inexisting'"
	[ "$status" -eq 3 ]
	[ ${#lines[@]} -eq 2 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "Found 0 pods named nginx-inexisting (instead of 2 expected)." ]
}


@test "verifying the number of PODs with a pattern name" {
	run verify "There are 2 pods named 'ngin.*'"
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -eq 2 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "Found 2 pods named ngin.* (as expected)." ]
}


@test "verifying the number of PODs with an invalid pattern name" {
	run verify "There are 2 pods named 'ngin.+x'"
	[ "$status" -eq 3 ]
	[ ${#lines[@]} -eq 2 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "Found 0 pods named ngin.+x (instead of 2 expected)." ]
}


@test "verifying the status of a POD with the lower-case syntax" {
	run verify "'status' is 'running' for pods named 'nginx'"
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -eq 3 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "nginx-deployment-75675f5897-6dg9r has the right value (running)." ]
	[ "${lines[2]}" = "nginx-deployment-75675f5897-gstkw has the right value (running)." ]
}


@test "verifying the status of a POD with a complex property" {
	run verify "'.status.phase' is 'running' for pods named 'nginx'"
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -eq 3 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "nginx-deployment-75675f5897-6dg9r has the right value (running)." ]
	[ "${lines[2]}" = "nginx-deployment-75675f5897-gstkw has the right value (running)." ]
}


@test "verifying the status of a POD with upper-case letters" {
	run verify "'status' is 'RUNNING' For pods named 'nginx'"
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -eq 3 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "nginx-deployment-75675f5897-6dg9r has the right value (running)." ]
	[ "${lines[2]}" = "nginx-deployment-75675f5897-gstkw has the right value (running)." ]
}


@test "verifying the syntax check (invalid wording)" {
	run verify "'status' is 'running' for all the pods named 'nginx'"
	[ "$status" -eq 2 ]
	[ ${#lines[@]} -eq 1 ]
	[ "${lines[0]}" = "Invalid expression: it does not respect the expected syntax." ]
}


@test "verifying the syntax check (missing quotes)" {
	run verify "status is 'running' for pods named 'nginx'"
	[ "$status" -eq 2 ]
	[ ${#lines[@]} -eq 1 ]
	[ "${lines[0]}" = "Invalid expression: it does not respect the expected syntax." ]
}


@test "verifying the status of a POD with the wrong value" {
	run verify "'status' is 'initializing' for pods named 'nginx'"
	[ "$status" -eq 3 ]
	[ ${#lines[@]} -eq 3 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "Current value for nginx-deployment-75675f5897-6dg9r is running..." ]
	[ "${lines[2]}" = "Current value for nginx-deployment-75675f5897-gstkw is running..." ]
}


@test "verifying the status of a POD with an invalid name" {
	run verify "'status' is 'running' for pods named 'nginx-something'"
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -eq 2 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "No resource of type 'pods' was found with the name 'nginx-something'." ]
}


@test "verifying the status of a POD with a pattern name" {
	run verify "'status' is 'running' for pods named 'ngin.*'"
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -eq 3 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "nginx-deployment-75675f5897-6dg9r has the right value (running)." ]
	[ "${lines[2]}" = "nginx-deployment-75675f5897-gstkw has the right value (running)." ]
}


@test "verifying the status of a POD with an invalid pattern name" {
	run verify "'status' is 'running' for pods named 'ngin.+x'"
	[ "$status" -eq 0 ]
	[ ${#lines[@]} -eq 2 ]
	[ "${lines[0]}" = "Valid expression. Verification in progress..." ]
	[ "${lines[1]}" = "No resource of type 'pods' was found with the name 'ngin.+x'." ]
}
