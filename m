Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaBUCzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:55:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:23983 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753197AbaBUCuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:04 -0500
Message-Id: <20140221025001.774885650@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 06/18] ftrace: Copy ops private to global_ops private
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0006-ftrace-Copy-ops-private-to-global_ops-private.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If global_ops function is being called directly, instead of the global_ops
list function, set the global_ops private to be the same as the ops private
that's being called directly.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cd7f76d..98ae4ed 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -244,7 +244,11 @@ static void control_ops_free(struct ftrace_ops *ops)
 
 static void update_global_ops(void)
 {
-	ftrace_func_t func;
+	ftrace_func_t func = ftrace_global_list_func;
+	void *private = NULL;
+
+	/* The list has its own recursion protection. */
+	global_ops.flags |= FTRACE_OPS_FL_RECURSION_SAFE;
 
 	/*
 	 * If there's only one function registered, then call that
@@ -254,23 +258,17 @@ static void update_global_ops(void)
 	if (ftrace_global_list == &ftrace_list_end ||
 	    ftrace_global_list->next == &ftrace_list_end) {
 		func = ftrace_global_list->func;
+		private = ftrace_global_list->private;
 		/*
 		 * As we are calling the function directly.
 		 * If it does not have recursion protection,
 		 * the function_trace_op needs to be updated
 		 * accordingly.
 		 */
-		if (ftrace_global_list->flags & FTRACE_OPS_FL_RECURSION_SAFE)
-			global_ops.flags |= FTRACE_OPS_FL_RECURSION_SAFE;
-		else
+		if (!(ftrace_global_list->flags & FTRACE_OPS_FL_RECURSION_SAFE))
 			global_ops.flags &= ~FTRACE_OPS_FL_RECURSION_SAFE;
-	} else {
-		func = ftrace_global_list_func;
-		/* The list has its own recursion protection. */
-		global_ops.flags |= FTRACE_OPS_FL_RECURSION_SAFE;
 	}
 
-
 	/* If we filter on pids, update to use the pid function */
 	if (!list_empty(&ftrace_pids)) {
 		set_ftrace_pid_function(func);
@@ -278,6 +276,7 @@ static void update_global_ops(void)
 	}
 
 	global_ops.func = func;
+	global_ops.private = private;
 }
 
 static void ftrace_sync(struct work_struct *work)
-- 
1.8.5.3


