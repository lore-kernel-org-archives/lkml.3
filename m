Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3LQUyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:54:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56168 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3LQUwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:52:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/10] tools lib traceevent: Get rid of die() in some string conversion functions
Date: Tue, 17 Dec 2013 17:52:11 -0300
Message-Id: <1387313531-14629-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387313531-14629-1-git-send-email-acme@infradead.org>
References: <1387313531-14629-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Those functions stringify filter arguments.

As caller of those functions handles NULL string properly, it seems that
it's enough to return NULL rather than calling die().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/878uvkgx9f.fsf@sejong.aot.lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/parse-filter.c | 67 +++++++++++--------------------------
 1 file changed, 19 insertions(+), 48 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 9303c55128db..e2842b926759 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1361,8 +1361,10 @@ enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
 		if (ret >= 0 && pevent->test_filters) {
 			char *test;
 			test = pevent_filter_make_string(filter, event->event->id);
-			printf(" '%s: %s'\n", event->event->name, test);
-			free(test);
+			if (test) {
+				printf(" '%s: %s'\n", event->event->name, test);
+				free(test);
+			}
 		}
 	}
 
@@ -2050,7 +2052,6 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 	int left_val = -1;
 	int right_val = -1;
 	int val;
-	int len;
 
 	switch (arg->op.type) {
 	case FILTER_OP_AND:
@@ -2097,11 +2098,7 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 				default:
 					break;
 				}
-				str = malloc_or_die(6);
-				if (val)
-					strcpy(str, "TRUE");
-				else
-					strcpy(str, "FALSE");
+				asprintf(&str, val ? "TRUE" : "FALSE");
 				break;
 			}
 		}
@@ -2119,10 +2116,7 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 			break;
 		}
 
-		len = strlen(left) + strlen(right) + strlen(op) + 10;
-		str = malloc_or_die(len);
-		snprintf(str, len, "(%s) %s (%s)",
-			 left, op, right);
+		asprintf(&str, "(%s) %s (%s)", left, op, right);
 		break;
 
 	case FILTER_OP_NOT:
@@ -2138,16 +2132,10 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 			right_val = 0;
 		if (right_val >= 0) {
 			/* just return the opposite */
-			str = malloc_or_die(6);
-			if (right_val)
-				strcpy(str, "FALSE");
-			else
-				strcpy(str, "TRUE");
+			asprintf(&str, right_val ? "FALSE" : "TRUE");
 			break;
 		}
-		len = strlen(right) + strlen(op) + 3;
-		str = malloc_or_die(len);
-		snprintf(str, len, "%s(%s)", op, right);
+		asprintf(&str, "%s(%s)", op, right);
 		break;
 
 	default:
@@ -2161,11 +2149,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 
 static char *val_to_str(struct event_filter *filter, struct filter_arg *arg)
 {
-	char *str;
-
-	str = malloc_or_die(30);
+	char *str = NULL;
 
-	snprintf(str, 30, "%lld", arg->value.val);
+	asprintf(&str, "%lld", arg->value.val);
 
 	return str;
 }
@@ -2181,7 +2167,6 @@ static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
 	char *rstr;
 	char *op;
 	char *str = NULL;
-	int len;
 
 	lstr = arg_to_str(filter, arg->exp.left);
 	rstr = arg_to_str(filter, arg->exp.right);
@@ -2220,12 +2205,11 @@ static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
 		op = "^";
 		break;
 	default:
-		die("oops in exp");
+		op = "[ERROR IN EXPRESSION TYPE]";
+		break;
 	}
 
-	len = strlen(op) + strlen(lstr) + strlen(rstr) + 4;
-	str = malloc_or_die(len);
-	snprintf(str, len, "%s %s %s", lstr, op, rstr);
+	asprintf(&str, "%s %s %s", lstr, op, rstr);
 out:
 	free(lstr);
 	free(rstr);
@@ -2239,7 +2223,6 @@ static char *num_to_str(struct event_filter *filter, struct filter_arg *arg)
 	char *rstr;
 	char *str = NULL;
 	char *op = NULL;
-	int len;
 
 	lstr = arg_to_str(filter, arg->num.left);
 	rstr = arg_to_str(filter, arg->num.right);
@@ -2270,10 +2253,7 @@ static char *num_to_str(struct event_filter *filter, struct filter_arg *arg)
 		if (!op)
 			op = "<=";
 
-		len = strlen(lstr) + strlen(op) + strlen(rstr) + 4;
-		str = malloc_or_die(len);
-		sprintf(str, "%s %s %s", lstr, op, rstr);
-
+		asprintf(&str, "%s %s %s", lstr, op, rstr);
 		break;
 
 	default:
@@ -2291,7 +2271,6 @@ static char *str_to_str(struct event_filter *filter, struct filter_arg *arg)
 {
 	char *str = NULL;
 	char *op = NULL;
-	int len;
 
 	switch (arg->str.type) {
 	case FILTER_CMP_MATCH:
@@ -2309,12 +2288,8 @@ static char *str_to_str(struct event_filter *filter, struct filter_arg *arg)
 		if (!op)
 			op = "!~";
 
-		len = strlen(arg->str.field->name) + strlen(op) +
-			strlen(arg->str.val) + 6;
-		str = malloc_or_die(len);
-		snprintf(str, len, "%s %s \"%s\"",
-			 arg->str.field->name,
-			 op, arg->str.val);
+		asprintf(&str, "%s %s \"%s\"",
+			 arg->str.field->name, op, arg->str.val);
 		break;
 
 	default:
@@ -2326,15 +2301,11 @@ static char *str_to_str(struct event_filter *filter, struct filter_arg *arg)
 
 static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
 {
-	char *str;
+	char *str = NULL;
 
 	switch (arg->type) {
 	case FILTER_ARG_BOOLEAN:
-		str = malloc_or_die(6);
-		if (arg->boolean.value)
-			strcpy(str, "TRUE");
-		else
-			strcpy(str, "FALSE");
+		asprintf(&str, arg->boolean.value ? "TRUE" : "FALSE");
 		return str;
 
 	case FILTER_ARG_OP:
@@ -2369,7 +2340,7 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
  *
  * Returns a string that displays the filter contents.
  *  This string must be freed with free(str).
- *  NULL is returned if no filter is found.
+ *  NULL is returned if no filter is found or allocation failed.
  */
 char *
 pevent_filter_make_string(struct event_filter *filter, int event_id)
-- 
1.8.1.4

