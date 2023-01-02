
resource "aws_lambda_function" "lambda_count" {
  filename = "lambda_count.zip"
  function_name = "resume-counter"
  role = "arn:aws:iam::010681948958:role/count_role"
  handler       = "index.test"
  runtime = "python3.9"

  depends_on = [
    aws_dynamodb_table.visitorCount]

}

output "lambda_arn" {
  value = aws_lambda_function.lambda_count.invoke_arn
}

  
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_count.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.resume-count.id}/*/${aws_api_gateway_method.resume-count.http_method}${aws_api_gateway_resource.resume-count.path}"
}