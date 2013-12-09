Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630Ab3LIFfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:35:00 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61198 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3LIFeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:34:18 -0500
X-AuditID: 9c930197-b7bdbae000000e78-80-52a55657d175
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 10/14] tools lib traceevent: Get rid of die() in reparent_op_arg()
Date: Mon,  9 Dec 2013 14:34:07 +0900
Message-Id: <1386567251-22751-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To do that, add FILTER_VAL_ERROR to enum filter_vals and make the
function returns the error code.  Also pass error_str so that it can
set proper error message when error occurred.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c | 91 +++++++++++++++++++++++--------------
 1 file changed, 58 insertions(+), 33 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index a1ad609a860f..dabae52bbbcb 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -781,17 +781,21 @@ enum filter_vals {
 	FILTER_VAL_NORM,
 	FILTER_VAL_FALSE,
 	FILTER_VAL_TRUE,
+	FILTER_VAL_ERROR,
 };
 
-void reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
-		  struct filter_arg *arg)
+enum filter_vals
+reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
+		struct filter_arg *arg, char **error_str)
 {
 	struct filter_arg *other_child;
 	struct filter_arg **ptr;
 
 	if (parent->type != FILTER_ARG_OP &&
-	    arg->type != FILTER_ARG_OP)
-		die("can not reparent other than OP");
+	    arg->type != FILTER_ARG_OP) {
+		show_error(error_str, "can not reparent other than OP");
+		return FILTER_VAL_ERROR;
+	}
 
 	/* Get the sibling */
 	if (old_child->op.right == arg) {
@@ -800,8 +804,10 @@ void reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
 	} else if (old_child->op.left == arg) {
 		ptr = &old_child->op.left;
 		other_child = old_child->op.right;
-	} else
-		die("Error in reparent op, find other child");
+	} else {
+		show_error(error_str, "Error in reparent op, find other child");
+		return FILTER_VAL_ERROR;
+	}
 
 	/* Detach arg from old_child */
 	*ptr = NULL;
@@ -812,21 +818,25 @@ void reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
 		*parent = *arg;
 		/* Free arg without recussion */
 		free(arg);
-		return;
+		return FILTER_VAL_NORM;
 	}
 
 	if (parent->op.right == old_child)
 		ptr = &parent->op.right;
 	else if (parent->op.left == old_child)
 		ptr = &parent->op.left;
-	else
-		die("Error in reparent op");
+	else {
+		show_error(error_str, "Error in reparent op");
+		return FILTER_VAL_ERROR;
+	}
 	*ptr = arg;
 
 	free_arg(old_child);
+	return FILTER_VAL_NORM;
 }
 
-enum filter_vals test_arg(struct filter_arg *parent, struct filter_arg *arg)
+enum filter_vals test_arg(struct filter_arg *parent, struct filter_arg *arg,
+			  char **error_str)
 {
 	enum filter_vals lval, rval;
 
@@ -843,63 +853,68 @@ enum filter_vals test_arg(struct filter_arg *parent, struct filter_arg *arg)
 		return FILTER_VAL_NORM;
 
 	case FILTER_ARG_EXP:
-		lval = test_arg(arg, arg->exp.left);
+		lval = test_arg(arg, arg->exp.left, error_str);
 		if (lval != FILTER_VAL_NORM)
 			return lval;
-		rval = test_arg(arg, arg->exp.right);
+		rval = test_arg(arg, arg->exp.right, error_str);
 		if (rval != FILTER_VAL_NORM)
 			return rval;
 		return FILTER_VAL_NORM;
 
 	case FILTER_ARG_NUM:
-		lval = test_arg(arg, arg->num.left);
+		lval = test_arg(arg, arg->num.left, error_str);
 		if (lval != FILTER_VAL_NORM)
 			return lval;
-		rval = test_arg(arg, arg->num.right);
+		rval = test_arg(arg, arg->num.right, error_str);
 		if (rval != FILTER_VAL_NORM)
 			return rval;
 		return FILTER_VAL_NORM;
 
 	case FILTER_ARG_OP:
 		if (arg->op.type != FILTER_OP_NOT) {
-			lval = test_arg(arg, arg->op.left);
+			lval = test_arg(arg, arg->op.left, error_str);
 			switch (lval) {
 			case FILTER_VAL_NORM:
 				break;
 			case FILTER_VAL_TRUE:
 				if (arg->op.type == FILTER_OP_OR)
 					return FILTER_VAL_TRUE;
-				rval = test_arg(arg, arg->op.right);
+				rval = test_arg(arg, arg->op.right, error_str);
 				if (rval != FILTER_VAL_NORM)
 					return rval;
 
-				reparent_op_arg(parent, arg, arg->op.right);
-				return FILTER_VAL_NORM;
+				return reparent_op_arg(parent, arg, arg->op.right,
+						       error_str);
 
 			case FILTER_VAL_FALSE:
 				if (arg->op.type == FILTER_OP_AND)
 					return FILTER_VAL_FALSE;
-				rval = test_arg(arg, arg->op.right);
+				rval = test_arg(arg, arg->op.right, error_str);
 				if (rval != FILTER_VAL_NORM)
 					return rval;
 
-				reparent_op_arg(parent, arg, arg->op.right);
-				return FILTER_VAL_NORM;
+				return reparent_op_arg(parent, arg, arg->op.right,
+						       error_str);
+
+			case FILTER_VAL_ERROR:
+				return FILTER_VAL_ERROR;
 			}
 		}
 
-		rval = test_arg(arg, arg->op.right);
+		rval = test_arg(arg, arg->op.right, error_str);
 		switch (rval) {
 		case FILTER_VAL_NORM:
+		case FILTER_VAL_ERROR:
 			break;
+
 		case FILTER_VAL_TRUE:
 			if (arg->op.type == FILTER_OP_OR)
 				return FILTER_VAL_TRUE;
 			if (arg->op.type == FILTER_OP_NOT)
 				return FILTER_VAL_FALSE;
 
-			reparent_op_arg(parent, arg, arg->op.left);
-			return FILTER_VAL_NORM;
+			return reparent_op_arg(parent, arg, arg->op.left,
+					       error_str);
 
 		case FILTER_VAL_FALSE:
 			if (arg->op.type == FILTER_OP_AND)
@@ -907,26 +922,27 @@ enum filter_vals test_arg(struct filter_arg *parent, struct filter_arg *arg)
 			if (arg->op.type == FILTER_OP_NOT)
 				return FILTER_VAL_TRUE;
 
-			reparent_op_arg(parent, arg, arg->op.left);
-			return FILTER_VAL_NORM;
+			return reparent_op_arg(parent, arg, arg->op.left,
+					       error_str);
 		}
 
-		return FILTER_VAL_NORM;
+		return rval;
 	default:
-		die("bad arg in filter tree");
+		show_error(error_str, "bad arg in filter tree");
+		return FILTER_VAL_ERROR;
 	}
 	return FILTER_VAL_NORM;
 }
 
 /* Remove any unknown event fields */
-static struct filter_arg *collapse_tree(struct filter_arg *arg)
+static struct filter_arg *collapse_tree(struct filter_arg *arg, char **error_str)
 {
 	enum filter_vals ret;
 
-	ret = test_arg(arg, arg);
+	ret = test_arg(arg, arg, error_str);
 	switch (ret) {
 	case FILTER_VAL_NORM:
-		return arg;
+		break;
 
 	case FILTER_VAL_TRUE:
 	case FILTER_VAL_FALSE:
@@ -935,7 +951,16 @@ static struct filter_arg *collapse_tree(struct filter_arg *arg)
 		if (arg) {
 			arg->type = FILTER_ARG_BOOLEAN;
 			arg->boolean.value = ret == FILTER_VAL_TRUE;
+		} else {
+			show_error(error_str, "Failed to allocate filter arg");
 		}
+		break;
+
+	case FILTER_VAL_ERROR:
+		/* test_arg() already set the error_str */
+		free_arg(arg);
+		arg = NULL;
+		break;
 	}
 
 	return arg;
@@ -1151,9 +1176,9 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 	if (!current_op)
 		current_op = current_exp;
 
-	current_op = collapse_tree(current_op);
+	current_op = collapse_tree(current_op, error_str);
 	if (current_op == NULL)
-		goto fail_alloc;
+		goto fail;
 
 	*parg = current_op;
 
-- 
1.7.11.7

