Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3GXPcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:32:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2237 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3GXP3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:29:19 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Tlrs1t-6B1YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=453Kd30X49IA:10 a=u4gv7utF6i1XELvmWBwA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130724152917.374206858@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 24 Jul 2013 11:27:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next-3.11][PATCH 8/9] ftrace: Add check for NULL regs if ops has SAVE_REGS set
References: <20130724152706.535638468@goodmis.org>
Content-Disposition: inline; filename=0008-ftrace-Add-check-for-NULL-regs-if-ops-has-SAVE_REGS-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If a ftrace ops is registered with the SAVE_REGS flag set, and there's
already a ops registered to one of its functions but without the
SAVE_REGS flag, there's a small race window where the SAVE_REGS ops gets
added to the list of callbacks to call for that function before the
callback trampoline gets set to save the regs.

The problem is, the function is not currently saving regs, which opens
a small race window where the ops that is expecting regs to be passed
to it, wont. This can cause a crash if the callback were to reference
the regs, as the SAVE_REGS guarantees that regs will be set.

To fix this, we add a check in the loop case where it checks if the ops
has the SAVE_REGS flag set, and if so, it will ignore it if regs is
not set.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 67708f4..8ce9eef 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1441,12 +1441,22 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
  * the hashes are freed with call_rcu_sched().
  */
 static int
-ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
+ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
 {
 	struct ftrace_hash *filter_hash;
 	struct ftrace_hash *notrace_hash;
 	int ret;
 
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+	/*
+	 * There's a small race when adding ops that the ftrace handler
+	 * that wants regs, may be called without them. We can not
+	 * allow that handler to be called if regs is NULL.
+	 */
+	if (regs == NULL && (ops->flags & FTRACE_OPS_FL_SAVE_REGS))
+		return 0;
+#endif
+
 	filter_hash = rcu_dereference_raw_notrace(ops->filter_hash);
 	notrace_hash = rcu_dereference_raw_notrace(ops->notrace_hash);
 
@@ -4218,7 +4228,7 @@ static inline void ftrace_startup_enable(int command) { }
 # define ftrace_shutdown_sysctl()	do { } while (0)
 
 static inline int
-ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
+ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
 {
 	return 1;
 }
@@ -4241,7 +4251,7 @@ ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip,
 	do_for_each_ftrace_op(op, ftrace_control_list) {
 		if (!(op->flags & FTRACE_OPS_FL_STUB) &&
 		    !ftrace_function_local_disabled(op) &&
-		    ftrace_ops_test(op, ip))
+		    ftrace_ops_test(op, ip, regs))
 			op->func(ip, parent_ip, op, regs);
 	} while_for_each_ftrace_op(op);
 	trace_recursion_clear(TRACE_CONTROL_BIT);
@@ -4274,7 +4284,7 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 	 */
 	preempt_disable_notrace();
 	do_for_each_ftrace_op(op, ftrace_ops_list) {
-		if (ftrace_ops_test(op, ip))
+		if (ftrace_ops_test(op, ip, regs))
 			op->func(ip, parent_ip, op, regs);
 	} while_for_each_ftrace_op(op);
 	preempt_enable_notrace();
-- 
1.7.10.4


