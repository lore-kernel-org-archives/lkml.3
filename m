Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3LMPR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:17:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45232 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab3LMPMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:12:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/20] tools lib traceevent: Refactor process_filter()
Date: Fri, 13 Dec 2013 12:12:04 -0300
Message-Id: <1386947526-7118-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386947526-7118-1-git-send-email-acme@infradead.org>
References: <1386947526-7118-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

So that it can return a proper pevent_errno value.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386833777-3790-11-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h  |  6 +++-
 tools/lib/traceevent/parse-filter.c | 64 +++++++++++++++++++++----------------
 2 files changed, 42 insertions(+), 28 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 57b66aed8122..da942d59cc3a 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -368,7 +368,11 @@ enum pevent_flag {
 	_PE(REPARENT_NOT_OP,	"cannot reparent other than OP"),	      \
 	_PE(REPARENT_FAILED,	"failed to reparent filter OP"),	      \
 	_PE(BAD_FILTER_ARG,	"bad arg in filter tree"),		      \
-	_PE(UNEXPECTED_TYPE,	"unexpected type (not a value)")
+	_PE(UNEXPECTED_TYPE,	"unexpected type (not a value)"),	      \
+	_PE(ILLEGAL_TOKEN,	"illegal token"),			      \
+	_PE(INVALID_PAREN,	"open parenthesis cannot come here"), 	      \
+	_PE(UNBALANCED_PAREN,	"unbalanced number of parenthesis"),	      \
+	_PE(UNKNOWN_TOKEN,	"unknown token")
 
 #undef _PE
 #define _PE(__code, __str) PEVENT_ERRNO__ ## __code
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 8d71208f0131..5aa5012a17ee 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -937,9 +937,10 @@ static int test_arg(struct filter_arg *parent, struct filter_arg *arg,
 }
 
 /* Remove any unknown event fields */
-static struct filter_arg *collapse_tree(struct filter_arg *arg, char **error_str)
+static int collapse_tree(struct filter_arg *arg,
+			 struct filter_arg **arg_collapsed, char **error_str)
 {
-	enum filter_vals ret;
+	int ret;
 
 	ret = test_arg(arg, arg, error_str);
 	switch (ret) {
@@ -955,6 +956,7 @@ static struct filter_arg *collapse_tree(struct filter_arg *arg, char **error_str
 			arg->boolean.value = ret == FILTER_VAL_TRUE;
 		} else {
 			show_error(error_str, "Failed to allocate filter arg");
+			ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
 		}
 		break;
 
@@ -965,10 +967,11 @@ static struct filter_arg *collapse_tree(struct filter_arg *arg, char **error_str
 		break;
 	}
 
-	return arg;
+	*arg_collapsed = arg;
+	return ret;
 }
 
-static int
+static enum pevent_errno
 process_filter(struct event_format *event, struct filter_arg **parg,
 	       char **error_str, int not)
 {
@@ -982,7 +985,7 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 	enum filter_op_type btype;
 	enum filter_exp_type etype;
 	enum filter_cmp_type ctype;
-	int ret;
+	enum pevent_errno ret;
 
 	*parg = NULL;
 
@@ -1007,20 +1010,20 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 				if (not) {
 					arg = NULL;
 					if (current_op)
-						goto fail_print;
+						goto fail_syntax;
 					free(token);
 					*parg = current_exp;
 					return 0;
 				}
 			} else
-				goto fail_print;
+				goto fail_syntax;
 			arg = NULL;
 			break;
 
 		case EVENT_DELIM:
 			if (*token == ',') {
-				show_error(error_str,
-					   "Illegal token ','");
+				show_error(error_str, "Illegal token ','");
+				ret = PEVENT_ERRNO__ILLEGAL_TOKEN;
 				goto fail;
 			}
 
@@ -1028,19 +1031,23 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 				if (left_item) {
 					show_error(error_str,
 						   "Open paren can not come after item");
+					ret = PEVENT_ERRNO__INVALID_PAREN;
 					goto fail;
 				}
 				if (current_exp) {
 					show_error(error_str,
 						   "Open paren can not come after expression");
+					ret = PEVENT_ERRNO__INVALID_PAREN;
 					goto fail;
 				}
 
 				ret = process_filter(event, &arg, error_str, 0);
-				if (ret != 1) {
-					if (ret == 0)
+				if (ret != PEVENT_ERRNO__UNBALANCED_PAREN) {
+					if (ret == 0) {
 						show_error(error_str,
 							   "Unbalanced number of '('");
+						ret = PEVENT_ERRNO__UNBALANCED_PAREN;
+					}
 					goto fail;
 				}
 				ret = 0;
@@ -1048,7 +1055,7 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 				/* A not wants just one expression */
 				if (not) {
 					if (current_op)
-						goto fail_print;
+						goto fail_syntax;
 					*parg = arg;
 					return 0;
 				}
@@ -1063,19 +1070,19 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 
 			} else { /* ')' */
 				if (!current_op && !current_exp)
-					goto fail_print;
+					goto fail_syntax;
 
 				/* Make sure everything is finished at this level */
 				if (current_exp && !check_op_done(current_exp))
-					goto fail_print;
+					goto fail_syntax;
 				if (current_op && !check_op_done(current_op))
-					goto fail_print;
+					goto fail_syntax;
 
 				if (current_op)
 					*parg = current_op;
 				else
 					*parg = current_exp;
-				return 1;
+				return PEVENT_ERRNO__UNBALANCED_PAREN;
 			}
 			break;
 
@@ -1087,21 +1094,22 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 			case OP_BOOL:
 				/* Logic ops need a left expression */
 				if (!current_exp && !current_op)
-					goto fail_print;
+					goto fail_syntax;
 				/* fall through */
 			case OP_NOT:
 				/* logic only processes ops and exp */
 				if (left_item)
-					goto fail_print;
+					goto fail_syntax;
 				break;
 			case OP_EXP:
 			case OP_CMP:
 				if (!left_item)
-					goto fail_print;
+					goto fail_syntax;
 				break;
 			case OP_NONE:
 				show_error(error_str,
 					   "Unknown op token %s", token);
+				ret = PEVENT_ERRNO__UNKNOWN_TOKEN;
 				goto fail;
 			}
 
@@ -1152,7 +1160,7 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 				ret = add_left(arg, left_item);
 				if (ret < 0) {
 					arg = NULL;
-					goto fail_print;
+					goto fail_syntax;
 				}
 				current_exp = arg;
 				break;
@@ -1161,25 +1169,25 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 			}
 			arg = NULL;
 			if (ret < 0)
-				goto fail_print;
+				goto fail_syntax;
 			break;
 		case EVENT_NONE:
 			break;
 		case EVENT_ERROR:
 			goto fail_alloc;
 		default:
-			goto fail_print;
+			goto fail_syntax;
 		}
 	} while (type != EVENT_NONE);
 
 	if (!current_op && !current_exp)
-		goto fail_print;
+		goto fail_syntax;
 
 	if (!current_op)
 		current_op = current_exp;
 
-	current_op = collapse_tree(current_op, error_str);
-	if (current_op == NULL)
+	ret = collapse_tree(current_op, parg, error_str);
+	if (ret < 0)
 		goto fail;
 
 	*parg = current_op;
@@ -1188,15 +1196,17 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 
  fail_alloc:
 	show_error(error_str, "failed to allocate filter arg");
+	ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
 	goto fail;
- fail_print:
+ fail_syntax:
 	show_error(error_str, "Syntax error");
+	ret = PEVENT_ERRNO__SYNTAX_ERROR;
  fail:
 	free_arg(current_op);
 	free_arg(current_exp);
 	free_arg(arg);
 	free(token);
-	return -1;
+	return ret;
 }
 
 static int
-- 
1.8.1.4

