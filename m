Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3LLHio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:38:44 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53469 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3LLHg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:36:27 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-17-52a9677700bd
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 13/14] tools lib traceevent: Get rid of die() in some string conversion funcitons
Date: Thu, 12 Dec 2013 16:36:16 +0900
Message-Id: <1386833777-3790-14-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those functions are for stringify filter arguments.  As caller of
those functions handles NULL string properly, it seems that it's
enough to return NULL rather than calling die().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 58 +++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 22 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 9303c55128db..32ab4396653c 100644
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
 
@@ -2097,7 +2099,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 				default:
 					break;
 				}
-				str = malloc_or_die(6);
+				str = malloc(6);
+				if (str == NULL)
+					break;
 				if (val)
 					strcpy(str, "TRUE");
 				else
@@ -2120,7 +2124,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 		}
 
 		len = strlen(left) + strlen(right) + strlen(op) + 10;
-		str = malloc_or_die(len);
+		str = malloc(len);
+		if (str == NULL)
+			break;
 		snprintf(str, len, "(%s) %s (%s)",
 			 left, op, right);
 		break;
@@ -2138,7 +2144,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 			right_val = 0;
 		if (right_val >= 0) {
 			/* just return the opposite */
-			str = malloc_or_die(6);
+			str = malloc(6);
+			if (str == NULL)
+				break;
 			if (right_val)
 				strcpy(str, "FALSE");
 			else
@@ -2146,8 +2154,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 			break;
 		}
 		len = strlen(right) + strlen(op) + 3;
-		str = malloc_or_die(len);
-		snprintf(str, len, "%s(%s)", op, right);
+		str = malloc(len);
+		if (str)
+			snprintf(str, len, "%s(%s)", op, right);
 		break;
 
 	default:
@@ -2163,9 +2172,9 @@ static char *val_to_str(struct event_filter *filter, struct filter_arg *arg)
 {
 	char *str;
 
-	str = malloc_or_die(30);
-
-	snprintf(str, 30, "%lld", arg->value.val);
+	str = malloc(30);
+	if (str)
+		snprintf(str, 30, "%lld", arg->value.val);
 
 	return str;
 }
@@ -2220,12 +2229,14 @@ static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
 		op = "^";
 		break;
 	default:
-		die("oops in exp");
+		op = "[ERROR IN EXPRESSION TYPE]";
+		break;
 	}
 
 	len = strlen(op) + strlen(lstr) + strlen(rstr) + 4;
-	str = malloc_or_die(len);
-	snprintf(str, len, "%s %s %s", lstr, op, rstr);
+	str = malloc(len);
+	if (str)
+		snprintf(str, len, "%s %s %s", lstr, op, rstr);
 out:
 	free(lstr);
 	free(rstr);
@@ -2271,9 +2282,9 @@ static char *num_to_str(struct event_filter *filter, struct filter_arg *arg)
 			op = "<=";
 
 		len = strlen(lstr) + strlen(op) + strlen(rstr) + 4;
-		str = malloc_or_die(len);
-		sprintf(str, "%s %s %s", lstr, op, rstr);
-
+		str = malloc(len);
+		if (str)
+			sprintf(str, "%s %s %s", lstr, op, rstr);
 		break;
 
 	default:
@@ -2311,10 +2322,11 @@ static char *str_to_str(struct event_filter *filter, struct filter_arg *arg)
 
 		len = strlen(arg->str.field->name) + strlen(op) +
 			strlen(arg->str.val) + 6;
-		str = malloc_or_die(len);
-		snprintf(str, len, "%s %s \"%s\"",
-			 arg->str.field->name,
-			 op, arg->str.val);
+		str = malloc(len);
+		if (str) {
+			snprintf(str, len, "%s %s \"%s\"",
+				 arg->str.field->name, op, arg->str.val);
+		}
 		break;
 
 	default:
@@ -2330,7 +2342,9 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
 
 	switch (arg->type) {
 	case FILTER_ARG_BOOLEAN:
-		str = malloc_or_die(6);
+		str = malloc(6);
+		if (str == NULL)
+			return NULL;
 		if (arg->boolean.value)
 			strcpy(str, "TRUE");
 		else
@@ -2369,7 +2383,7 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
  *
  * Returns a string that displays the filter contents.
  *  This string must be freed with free(str).
- *  NULL is returned if no filter is found.
+ *  NULL is returned if no filter is found or allocation failed.
  */
 char *
 pevent_filter_make_string(struct event_filter *filter, int event_id)
-- 
1.7.11.7

