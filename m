Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563Ab3LIFee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:34:34 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58135 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760259Ab3LIFeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:34:20 -0500
X-AuditID: 9c930197-b7bdbae000000e78-8e-52a55658926b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 14/14] tools lib traceevent: Get rid of die() in some string conversion funcitons
Date: Mon,  9 Dec 2013 14:34:11 +0900
Message-Id: <1386567251-22751-15-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those functions are for stringify filter arguments.  As caller of
those functions handles NULL string properly, it seems that it's
enough to return NULL rather than calling die().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 51 ++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 8a5b7a74b44e..ff95da94eee2 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -2108,7 +2108,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
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
@@ -2131,7 +2133,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 		}
 
 		len = strlen(left) + strlen(right) + strlen(op) + 10;
-		str = malloc_or_die(len);
+		str = malloc(len);
+		if (str == NULL)
+			break;
 		snprintf(str, len, "(%s) %s (%s)",
 			 left, op, right);
 		break;
@@ -2149,7 +2153,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
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
@@ -2157,8 +2163,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
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
@@ -2174,9 +2181,9 @@ static char *val_to_str(struct event_filter *filter, struct filter_arg *arg)
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
@@ -2231,12 +2238,13 @@ static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
 		op = "^";
 		break;
 	default:
-		die("oops in exp");
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
@@ -2282,9 +2290,9 @@ static char *num_to_str(struct event_filter *filter, struct filter_arg *arg)
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
@@ -2322,10 +2330,11 @@ static char *str_to_str(struct event_filter *filter, struct filter_arg *arg)
 
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
@@ -2341,7 +2350,9 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
 
 	switch (arg->type) {
 	case FILTER_ARG_BOOLEAN:
-		str = malloc_or_die(6);
+		str = malloc(6);
+		if (str == NULL)
+			return NULL;
 		if (arg->boolean.value)
 			strcpy(str, "TRUE");
 		else
@@ -2380,7 +2391,7 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
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

