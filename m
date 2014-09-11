Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaIKOtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:49:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:38878 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752022AbaIKOtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:49:09 -0400
Message-Id: <20140911144907.751676637@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 11 Sep 2014 10:47:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 1/9] ftrace: Add separate function for non recursive callbacks
References: <20140911144744.907770249@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ftrace-Add-separate-function-for-non-recursive-callb.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of using the generic list function for callbacks that
are not recursive, call a new helper function from the mcount
trampoline called ftrace_ops_recur_func() that will do the recursion
checking for the callback.

This eliminates an indirection as well as will help in future code
that will use dynamically allocated trampolines.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5916a8e59e87..17b606362ab4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -113,6 +113,9 @@ ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 static struct ftrace_ops global_ops;
 static struct ftrace_ops control_ops;
 
+static void ftrace_ops_recurs_func(unsigned long ip, unsigned long parent_ip,
+				   struct ftrace_ops *op, struct pt_regs *regs);
+
 #if ARCH_SUPPORTS_FTRACE_OPS
 static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 				 struct ftrace_ops *op, struct pt_regs *regs);
@@ -258,11 +261,18 @@ static void update_ftrace_function(void)
 	if (ftrace_ops_list == &ftrace_list_end ||
 	    (ftrace_ops_list->next == &ftrace_list_end &&
 	     !(ftrace_ops_list->flags & FTRACE_OPS_FL_DYNAMIC) &&
-	     (ftrace_ops_list->flags & FTRACE_OPS_FL_RECURSION_SAFE) &&
 	     !FTRACE_FORCE_LIST_FUNC)) {
 		/* Set the ftrace_ops that the arch callback uses */
 		set_function_trace_op = ftrace_ops_list;
-		func = ftrace_ops_list->func;
+		/*
+		 * If the func handles its own recursion, call it directly.
+		 * Otherwise call the recursion protected function that
+		 * will call the ftrace ops function.
+		 */
+		if (ftrace_ops_list->flags & FTRACE_OPS_FL_RECURSION_SAFE)
+			func = ftrace_ops_list->func;
+		else
+			func = ftrace_ops_recurs_func;
 	} else {
 		/* Just use the default ftrace_ops */
 		set_function_trace_op = &ftrace_list_end;
@@ -4827,6 +4837,25 @@ static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip)
 }
 #endif
 
+/*
+ * If there's only one function registered but it does not support
+ * recursion, this function will be called by the mcount trampoline.
+ * This function will handle recursion protection.
+ */
+static void ftrace_ops_recurs_func(unsigned long ip, unsigned long parent_ip,
+				   struct ftrace_ops *op, struct pt_regs *regs)
+{
+	int bit;
+
+	bit = trace_test_and_set_recursion(TRACE_LIST_START, TRACE_LIST_MAX);
+	if (bit < 0)
+		return;
+
+	op->func(ip, parent_ip, op, regs);
+
+	trace_clear_recursion(bit);
+}
+
 static void clear_ftrace_swapper(void)
 {
 	struct task_struct *p;
-- 
2.0.1


