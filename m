Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbaIKOwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:52:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:22696 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753114AbaIKOtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:49:11 -0400
Message-Id: <20140911144907.912469902@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 11 Sep 2014 10:47:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 2/9] ftrace: Add helper function ftrace_ops_get_func()
References: <20140911144744.907770249@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-ftrace-Add-helper-function-ftrace_ops_get_func.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add the helper function to what the mcount trampoline is to call
for a ftrace_ops function. This helper will be used by arch code
in the future to set up dynamic trampolines. But as this does the
same tests that are performed in choosing what function to call for
the default mcount trampoline, might as well use it to clean up
the existing code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |  2 ++
 kernel/trace/ftrace.c  | 47 +++++++++++++++++++++++++++++++++++------------
 2 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f0b0edbf55a9..ef37286547fc 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -56,6 +56,8 @@ struct ftrace_ops;
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
 			      struct ftrace_ops *op, struct pt_regs *regs);
 
+ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
+
 /*
  * FTRACE_OPS_FL_* bits denote the state of ftrace_ops struct and are
  * set in the flags member.
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 17b606362ab4..dabf734f909c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -259,20 +259,12 @@ static void update_ftrace_function(void)
 	 * then have the mcount trampoline call the function directly.
 	 */
 	if (ftrace_ops_list == &ftrace_list_end ||
-	    (ftrace_ops_list->next == &ftrace_list_end &&
-	     !(ftrace_ops_list->flags & FTRACE_OPS_FL_DYNAMIC) &&
-	     !FTRACE_FORCE_LIST_FUNC)) {
+	    (ftrace_ops_list->next == &ftrace_list_end)) {
+
 		/* Set the ftrace_ops that the arch callback uses */
 		set_function_trace_op = ftrace_ops_list;
-		/*
-		 * If the func handles its own recursion, call it directly.
-		 * Otherwise call the recursion protected function that
-		 * will call the ftrace ops function.
-		 */
-		if (ftrace_ops_list->flags & FTRACE_OPS_FL_RECURSION_SAFE)
-			func = ftrace_ops_list->func;
-		else
-			func = ftrace_ops_recurs_func;
+
+		func = ftrace_ops_get_func(ftrace_ops_list);
 	} else {
 		/* Just use the default ftrace_ops */
 		set_function_trace_op = &ftrace_list_end;
@@ -4856,6 +4848,37 @@ static void ftrace_ops_recurs_func(unsigned long ip, unsigned long parent_ip,
 	trace_clear_recursion(bit);
 }
 
+/**
+ * ftrace_ops_get_func - get the function a trampoline should call
+ * @ops: the ops to get the function for
+ *
+ * Normally the mcount trampoline will call the ops->func, but there
+ * are times that it should not. For example, if the ops does not
+ * have its own recursion protection, then it should call the
+ * ftrace_ops_recurs_func() instead.
+ *
+ * Returns the function that the trampoline should call for @ops.
+ */
+ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops)
+{
+	/*
+	 * If this is a dynamic ops or we force list func,
+	 * then it needs to call the list anyway.
+	 */
+	if (ops->flags & FTRACE_OPS_FL_DYNAMIC || FTRACE_FORCE_LIST_FUNC)
+		return ftrace_ops_list_func;
+
+	/*
+	 * If the func handles its own recursion, call it directly.
+	 * Otherwise call the recursion protected function that
+	 * will call the ftrace ops function.
+	 */
+	if (!(ops->flags & FTRACE_OPS_FL_RECURSION_SAFE))
+		return ftrace_ops_recurs_func;
+
+	return ops->func;
+}
+
 static void clear_ftrace_swapper(void)
 {
 	struct task_struct *p;
-- 
2.0.1


