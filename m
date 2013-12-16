Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3LPP3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:29:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47748 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3LPP3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:29:19 -0500
Date: Mon, 16 Dec 2013 07:28:57 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-7bb73553e2490ac6667387ee723e0faa61e9d999@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1386833777-3790-9-git-send-email-namhyung@kernel.org>
References: <1386833777-3790-9-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of die()
  in reparent_op_arg()
Git-Commit-ID: 7bb73553e2490ac6667387ee723e0faa61e9d999
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:29:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7bb73553e2490ac6667387ee723e0faa61e9d999
Gitweb:     http://git.kernel.org/tip/7bb73553e2490ac6667387ee723e0faa61e9d999
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 12 Dec 2013 16:36:11 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:22 -0300

tools lib traceevent: Get rid of die() in reparent_op_arg()

To do that, make the function returns the error code.  Also pass
error_str so that it can set proper error message when error occurred.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386833777-3790-9-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h  |  5 +-
 tools/lib/traceevent/parse-filter.c | 94 +++++++++++++++++++++++--------------
 2 files changed, 64 insertions(+), 35 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 89e4dfd..5e4392d 100644
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
index 774c3e4..9b05892 100644
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
 
