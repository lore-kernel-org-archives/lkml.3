Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab3LLHgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:36:50 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63830 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3LLHgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:36:25 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-01-52a967761fe9
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 08/14] tools lib traceevent: Get rid of die() in reparent_op_arg()
Date: Thu, 12 Dec 2013 16:36:11 +0900
Message-Id: <1386833777-3790-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To do that, make the function returns the error code.  Also pass
error_str so that it can set proper error message when error occurred.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.h  |  5 +-
 tools/lib/traceevent/parse-filter.c | 94 +++++++++++++++++++++++--------------
 2 files changed, 64 insertions(+), 35 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 89e4dfd40db6..5e4392d8e2d4 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -364,7 +364,10 @@ enum pevent_flag {
 	_PE(ILLEGAL_LVALUE,	"illegal lvalue for string comparison"),      \
 	_PE(INVALID_REGEX,	"regex did not compute"),		      \
 	_PE(ILLEGAL_STRING_CMP,	"illegal comparison for string"), 	      \
-	_PE(ILLEGAL_INTEGER_CMP,"illegal comparison for integer")
+	_PE(ILLEGAL_INTEGER_CMP,"illegal comparison for integer"), 	      \
+	_PE(REPARENT_NOT_OP,	"cannot reparent other than OP"),	      \
+	_PE(REPARENT_FAILED,	"failed to reparent filter OP"),	      \
+	_PE(BAD_FILTER_ARG,	"bad arg in filter tree")
 
 #undef _PE
 #define _PE(__code, __str) PEVENT_ERRNO__ ## __code
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 774c3e4c1d9f..9b05892566e0 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -784,15 +784,18 @@ enum filter_vals {
 	FILTER_VAL_TRUE,
 };
 
-void reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
-		  struct filter_arg *arg)
+static enum pevent_errno
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
+		return PEVENT_ERRNO__REPARENT_NOT_OP;
+	}
 
 	/* Get the sibling */
 	if (old_child->op.right == arg) {
@@ -801,8 +804,10 @@ void reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
 	} else if (old_child->op.left == arg) {
 		ptr = &old_child->op.left;
 		other_child = old_child->op.right;
-	} else
-		die("Error in reparent op, find other child");
+	} else {
+		show_error(error_str, "Error in reparent op, find other child");
+		return PEVENT_ERRNO__REPARENT_FAILED;
+	}
 
 	/* Detach arg from old_child */
 	*ptr = NULL;
@@ -813,23 +818,29 @@ void reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
 		*parent = *arg;
 		/* Free arg without recussion */
 		free(arg);
-		return;
+		return 0;
 	}
 
 	if (parent->op.right == old_child)
 		ptr = &parent->op.right;
 	else if (parent->op.left == old_child)
 		ptr = &parent->op.left;
-	else
-		die("Error in reparent op");
+	else {
+		show_error(error_str, "Error in reparent op");
+		return PEVENT_ERRNO__REPARENT_FAILED;
+	}
+
 	*ptr = arg;
 
 	free_arg(old_child);
+	return 0;
 }
 
-enum filter_vals test_arg(struct filter_arg *parent, struct filter_arg *arg)
+/* Returns either filter_vals (success) or pevent_errno (failfure) */
+static int test_arg(struct filter_arg *parent, struct filter_arg *arg,
+		    char **error_str)
 {
-	enum filter_vals lval, rval;
+	int lval, rval;
 
 	switch (arg->type) {
 
@@ -844,63 +855,68 @@ enum filter_vals test_arg(struct filter_arg *parent, struct filter_arg *arg)
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
+			default:
+				return lval;
 			}
 		}
 
-		rval = test_arg(arg, arg->op.right);
+		rval = test_arg(arg, arg->op.right, error_str);
 		switch (rval) {
 		case FILTER_VAL_NORM:
+		default:
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
@@ -908,26 +924,27 @@ enum filter_vals test_arg(struct filter_arg *parent, struct filter_arg *arg)
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
+		return PEVENT_ERRNO__BAD_FILTER_ARG;
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
@@ -936,7 +953,16 @@ static struct filter_arg *collapse_tree(struct filter_arg *arg)
 		if (arg) {
 			arg->type = FILTER_ARG_BOOLEAN;
 			arg->boolean.value = ret == FILTER_VAL_TRUE;
+		} else {
+			show_error(error_str, "Failed to allocate filter arg");
 		}
+		break;
+
+	default:
+		/* test_arg() already set the error_str */
+		free_arg(arg);
+		arg = NULL;
+		break;
 	}
 
 	return arg;
@@ -1152,9 +1178,9 @@ process_filter(struct event_format *event, struct filter_arg **parg,
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

