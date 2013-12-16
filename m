Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3LPP2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:28:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47684 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab3LPP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:28:28 -0500
Date: Mon, 16 Dec 2013 07:28:10 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-2e4eb10d7e59df71ab649343b3f1bff9259da15d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1386833777-3790-4-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of malloc_or_die()
  allocate_arg()
Git-Commit-ID: 2e4eb10d7e59df71ab649343b3f1bff9259da15d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:28:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e4eb10d7e59df71ab649343b3f1bff9259da15d
Gitweb:     http://git.kernel.org/tip/2e4eb10d7e59df71ab649343b3f1bff9259da15d
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 12 Dec 2013 16:36:06 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:21 -0300

tools lib traceevent: Get rid of malloc_or_die() allocate_arg()

Also check return value and handle it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386833777-3790-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/parse-filter.c | 48 ++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 767de4f..ab9cefe 100644
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
@@ -369,6 +364,10 @@ create_arg_item(struct event_format *event, const char *token,
 	struct filter_arg *arg;
 
 	arg = allocate_arg();
+	if (arg == NULL) {
+		show_error(error_str, "failed to allocate filter arg");
+		return NULL;
+	}
 
 	switch (type) {
 
@@ -422,6 +421,9 @@ create_arg_op(enum filter_op_type btype)
 	struct filter_arg *arg;
 
 	arg = allocate_arg();
+	if (!arg)
+		return NULL;
+
 	arg->type = FILTER_ARG_OP;
 	arg->op.type = btype;
 
@@ -434,6 +436,9 @@ create_arg_exp(enum filter_exp_type etype)
 	struct filter_arg *arg;
 
 	arg = allocate_arg();
+	if (!arg)
+		return NULL;
+
 	arg->type = FILTER_ARG_EXP;
 	arg->op.type = etype;
 
@@ -446,6 +451,9 @@ create_arg_cmp(enum filter_exp_type etype)
 	struct filter_arg *arg;
 
 	arg = allocate_arg();
+	if (!arg)
+		return NULL;
+
 	/* Use NUM and change if necessary */
 	arg->type = FILTER_ARG_NUM;
 	arg->op.type = etype;
@@ -909,8 +917,10 @@ static struct filter_arg *collapse_tree(struct filter_arg *arg)
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
@@ -1057,6 +1067,8 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 			switch (op_type) {
 			case OP_BOOL:
 				arg = create_arg_op(btype);
+				if (arg == NULL)
+					goto fail_alloc;
 				if (current_op)
 					ret = add_left(arg, current_op);
 				else
@@ -1067,6 +1079,8 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 
 			case OP_NOT:
 				arg = create_arg_op(btype);
+				if (arg == NULL)
+					goto fail_alloc;
 				if (current_op)
 					ret = add_right(current_op, arg, error_str);
 				if (ret < 0)
@@ -1086,6 +1100,8 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 					arg = create_arg_exp(etype);
 				else
 					arg = create_arg_cmp(ctype);
+				if (arg == NULL)
+					goto fail_alloc;
 
 				if (current_op)
 					ret = add_right(current_op, arg, error_str);
@@ -1119,11 +1135,16 @@ process_filter(struct event_format *event, struct filter_arg **parg,
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
@@ -1154,6 +1175,10 @@ process_event(struct event_format *event, const char *filter_str,
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
@@ -1177,6 +1202,10 @@ static int filter_event(struct event_filter *filter,
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
@@ -1418,6 +1447,9 @@ static int copy_filter_type(struct event_filter *filter,
 	if (strcmp(str, "TRUE") == 0 || strcmp(str, "FALSE") == 0) {
 		/* Add trivial event */
 		arg = allocate_arg();
+		if (arg == NULL)
+			return -1;
+
 		arg->type = FILTER_ARG_BOOLEAN;
 		if (strcmp(str, "TRUE") == 0)
 			arg->boolean.value = 1;
