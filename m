Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3LLHgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:36:42 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63830 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab3LLHgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:36:24 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-ef-52a96774107f
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/14] tools lib traceevent: Get rid of die() in add_right()
Date: Thu, 12 Dec 2013 16:36:09 +0900
Message-Id: <1386833777-3790-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor it to return appropriate pevent_errno value.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.h  |  8 +++++++-
 tools/lib/traceevent/parse-filter.c | 34 +++++++++++++++++++---------------
 2 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index abdfd3c606ed..89e4dfd40db6 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -358,7 +358,13 @@ enum pevent_flag {
 	_PE(OLD_FTRACE_ARG_FAILED,"failed to allocate field name for ftrace"),\
 	_PE(INVALID_ARG_TYPE,	"invalid argument type"),		      \
 	_PE(INVALID_EVENT_NAME,	"invalid event name"),			      \
-	_PE(EVENT_NOT_FOUND,	"No event found")
+	_PE(EVENT_NOT_FOUND,	"no event found"),			      \
+	_PE(SYNTAX_ERROR,	"syntax error"),			      \
+	_PE(ILLEGAL_RVALUE,	"illegal rvalue"),			      \
+	_PE(ILLEGAL_LVALUE,	"illegal lvalue for string comparison"),      \
+	_PE(INVALID_REGEX,	"regex did not compute"),		      \
+	_PE(ILLEGAL_STRING_CMP,	"illegal comparison for string"), 	      \
+	_PE(ILLEGAL_INTEGER_CMP,"illegal comparison for integer")
 
 #undef _PE
 #define _PE(__code, __str) PEVENT_ERRNO__ ## __code
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index a0ab040e8f71..c08ce594cabe 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -473,8 +473,8 @@ create_arg_cmp(enum filter_exp_type etype)
 	return arg;
 }
 
-static int add_right(struct filter_arg *op, struct filter_arg *arg,
-		     char **error_str)
+static enum pevent_errno
+add_right(struct filter_arg *op, struct filter_arg *arg, char **error_str)
 {
 	struct filter_arg *left;
 	char *str;
@@ -505,9 +505,8 @@ static int add_right(struct filter_arg *op, struct filter_arg *arg,
 		case FILTER_ARG_FIELD:
 			break;
 		default:
-			show_error(error_str,
-				   "Illegal rvalue");
-			return -1;
+			show_error(error_str, "Illegal rvalue");
+			return PEVENT_ERRNO__ILLEGAL_RVALUE;
 		}
 
 		/*
@@ -554,7 +553,7 @@ static int add_right(struct filter_arg *op, struct filter_arg *arg,
 			if (left->type != FILTER_ARG_FIELD) {
 				show_error(error_str,
 					   "Illegal lvalue for string comparison");
-				return -1;
+				return PEVENT_ERRNO__ILLEGAL_LVALUE;
 			}
 
 			/* Make sure this is a valid string compare */
@@ -573,25 +572,31 @@ static int add_right(struct filter_arg *op, struct filter_arg *arg,
 					show_error(error_str,
 						   "RegEx '%s' did not compute",
 						   str);
-					return -1;
+					return PEVENT_ERRNO__INVALID_REGEX;
 				}
 				break;
 			default:
 				show_error(error_str,
 					   "Illegal comparison for string");
-				return -1;
+				return PEVENT_ERRNO__ILLEGAL_STRING_CMP;
 			}
 
 			op->type = FILTER_ARG_STR;
 			op->str.type = op_type;
 			op->str.field = left->field.field;
 			op->str.val = strdup(str);
-			if (!op->str.val)
-				die("malloc string");
+			if (!op->str.val) {
+				show_error(error_str, "Failed to allocate string filter");
+				return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+			}
 			/*
 			 * Need a buffer to copy data for tests
 			 */
-			op->str.buffer = malloc_or_die(op->str.field->size + 1);
+			op->str.buffer = malloc(op->str.field->size + 1);
+			if (!op->str.buffer) {
+				show_error(error_str, "Failed to allocate string filter");
+				return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+			}
 			/* Null terminate this buffer */
 			op->str.buffer[op->str.field->size] = 0;
 
@@ -609,7 +614,7 @@ static int add_right(struct filter_arg *op, struct filter_arg *arg,
 			case FILTER_CMP_NOT_REGEX:
 				show_error(error_str,
 					   "Op not allowed with integers");
-				return -1;
+				return PEVENT_ERRNO__ILLEGAL_INTEGER_CMP;
 
 			default:
 				break;
@@ -629,9 +634,8 @@ static int add_right(struct filter_arg *op, struct filter_arg *arg,
 	return 0;
 
  out_fail:
-	show_error(error_str,
-		   "Syntax error");
-	return -1;
+	show_error(error_str, "Syntax error");
+	return PEVENT_ERRNO__SYNTAX_ERROR;
 }
 
 static struct filter_arg *
-- 
1.7.11.7

