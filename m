Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741Ab3LIFhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:37:10 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51889 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab3LIFeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:34:16 -0500
X-AuditID: 9c930197-b7bdbae000000e78-62-52a556549cc1
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 04/14] tools lib traceevent: Get rid of malloc_or_die() allocate_arg()
Date: Mon,  9 Dec 2013 14:34:01 +0900
Message-Id: <1386567251-22751-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also check return value and handle it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 59 +++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 15 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 21d13a4f9a5f..35fac1fa376b 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -211,12 +211,7 @@ struct event_filter *pevent_filter_alloc(struct pevent *pevent)
 
 static struct filter_arg *allocate_arg(void)
 {
-	struct filter_arg *arg;
-
-	arg = malloc_or_die(sizeof(*arg));
-	memset(arg, 0, sizeof(*arg));
-
-	return arg;
+	return calloc(1, sizeof(struct filter_arg));
 }
 
 static void free_arg(struct filter_arg *arg)
@@ -359,6 +354,10 @@ create_arg_item(struct event_format *event, const char *token,
 	struct filter_arg *arg;
 
 	arg = allocate_arg();
+	if (arg == NULL) {
+		show_error(error_str, "failed to allocate filter arg");
+		return NULL;
+	}
 
 	switch (type) {
 
@@ -409,8 +408,10 @@ create_arg_op(enum filter_op_type btype)
 	struct filter_arg *arg;
 
 	arg = allocate_arg();
-	arg->type = FILTER_ARG_OP;
-	arg->op.type = btype;
+	if (arg) {
+		arg->type = FILTER_ARG_OP;
+		arg->op.type = btype;
+	}
 
 	return arg;
 }
@@ -421,8 +422,10 @@ create_arg_exp(enum filter_exp_type etype)
 	struct filter_arg *arg;
 
 	arg = allocate_arg();
-	arg->type = FILTER_ARG_EXP;
-	arg->op.type = etype;
+	if (arg) {
+		arg->type = FILTER_ARG_EXP;
+		arg->op.type = etype;
+	}
 
 	return arg;
 }
@@ -433,9 +436,11 @@ create_arg_cmp(enum filter_exp_type etype)
 	struct filter_arg *arg;
 
 	arg = allocate_arg();
-	/* Use NUM and change if necessary */
-	arg->type = FILTER_ARG_NUM;
-	arg->op.type = etype;
+	if (arg) {
+		/* Use NUM and change if necessary */
+		arg->type = FILTER_ARG_NUM;
+		arg->op.type = etype;
+	}
 
 	return arg;
 }
@@ -896,8 +901,10 @@ static struct filter_arg *collapse_tree(struct filter_arg *arg)
 	case FILTER_VAL_FALSE:
 		free_arg(arg);
 		arg = allocate_arg();
-		arg->type = FILTER_ARG_BOOLEAN;
-		arg->boolean.value = ret == FILTER_VAL_TRUE;
+		if (arg) {
+			arg->type = FILTER_ARG_BOOLEAN;
+			arg->boolean.value = ret == FILTER_VAL_TRUE;
+		}
 	}
 
 	return arg;
@@ -1044,6 +1051,8 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 			switch (op_type) {
 			case OP_BOOL:
 				arg = create_arg_op(btype);
+				if (arg == NULL)
+					goto fail_alloc;
 				if (current_op)
 					ret = add_left(arg, current_op);
 				else
@@ -1054,6 +1063,8 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 
 			case OP_NOT:
 				arg = create_arg_op(btype);
+				if (arg == NULL)
+					goto fail_alloc;
 				if (current_op)
 					ret = add_right(current_op, arg, error_str);
 				if (ret < 0)
@@ -1073,6 +1084,8 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 					arg = create_arg_exp(etype);
 				else
 					arg = create_arg_cmp(ctype);
+				if (arg == NULL)
+					goto fail_alloc;
 
 				if (current_op)
 					ret = add_right(current_op, arg, error_str);
@@ -1106,11 +1119,16 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 		current_op = current_exp;
 
 	current_op = collapse_tree(current_op);
+	if (current_op == NULL)
+		goto fail_alloc;
 
 	*parg = current_op;
 
 	return 0;
 
+ fail_alloc:
+	show_error(error_str, "failed to allocate filter arg");
+	goto fail;
  fail_print:
 	show_error(error_str, "Syntax error");
  fail:
@@ -1141,6 +1159,10 @@ process_event(struct event_format *event, const char *filter_str,
 	/* If parg is NULL, then make it into FALSE */
 	if (!*parg) {
 		*parg = allocate_arg();
+		if (*parg == NULL) {
+			show_error(error_str, "failed to allocate filter arg");
+			return -1;
+		}
 		(*parg)->type = FILTER_ARG_BOOLEAN;
 		(*parg)->boolean.value = FILTER_FALSE;
 	}
@@ -1164,6 +1186,10 @@ static int filter_event(struct event_filter *filter,
 	} else {
 		/* just add a TRUE arg */
 		arg = allocate_arg();
+		if (arg == NULL) {
+			show_error(error_str, "failed to allocate filter arg");
+			return -1;
+		}
 		arg->type = FILTER_ARG_BOOLEAN;
 		arg->boolean.value = FILTER_TRUE;
 	}
@@ -1399,6 +1425,9 @@ static int copy_filter_type(struct event_filter *filter,
 	if (strcmp(str, "TRUE") == 0 || strcmp(str, "FALSE") == 0) {
 		/* Add trivial event */
 		arg = allocate_arg();
+		if (arg == NULL)
+			return -1;
+
 		arg->type = FILTER_ARG_BOOLEAN;
 		if (strcmp(str, "TRUE") == 0)
 			arg->boolean.value = 1;
-- 
1.7.11.7

