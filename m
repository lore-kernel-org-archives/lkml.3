Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab3LPP3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:29:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47731 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab3LPP3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:29:04 -0500
Date: Mon, 16 Dec 2013 07:28:39 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-02d62d6d17b9b718be2878477cdcae95df0d5b4e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1386833777-3790-7-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of die()
  in add_right()
Git-Commit-ID: 02d62d6d17b9b718be2878477cdcae95df0d5b4e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:28:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02d62d6d17b9b718be2878477cdcae95df0d5b4e
Gitweb:     http://git.kernel.org/tip/02d62d6d17b9b718be2878477cdcae95df0d5b4e
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 12 Dec 2013 16:36:09 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:22 -0300

tools lib traceevent: Get rid of die() in add_right()

Refactor it to return appropriate pevent_errno value.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386833777-3790-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h  |  8 +++++++-
 tools/lib/traceevent/parse-filter.c | 34 +++++++++++++++++++---------------
 2 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index abdfd3c..89e4dfd 100644
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
index a0ab040..c08ce59 100644
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
