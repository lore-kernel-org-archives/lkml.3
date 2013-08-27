Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab3H0BW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:22:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3H0BHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 25/74] ftrace: Add check for NULL regs if ops has SAVE_REGS set
Date: Mon, 26 Aug 2013 18:08:23 -0700
Message-Id: <20130827010429.741891938@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 195a8afc7ac962f8da795549fe38e825f1372b0d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1416,12 +1416,22 @@ ftrace_hash_move(struct ftrace_ops *ops,
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
 
@@ -4188,7 +4198,7 @@ static inline void ftrace_startup_enable
 # define ftrace_shutdown_sysctl()	do { } while (0)
 
 static inline int
-ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip)
+ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
 {
 	return 1;
 }
@@ -4211,7 +4221,7 @@ ftrace_ops_control_func(unsigned long ip
 	do_for_each_ftrace_op(op, ftrace_control_list) {
 		if (!(op->flags & FTRACE_OPS_FL_STUB) &&
 		    !ftrace_function_local_disabled(op) &&
-		    ftrace_ops_test(op, ip))
+		    ftrace_ops_test(op, ip, regs))
 			op->func(ip, parent_ip, op, regs);
 	} while_for_each_ftrace_op(op);
 	trace_recursion_clear(TRACE_CONTROL_BIT);
@@ -4244,7 +4254,7 @@ __ftrace_ops_list_func(unsigned long ip,
 	 */
 	preempt_disable_notrace();
 	do_for_each_ftrace_op(op, ftrace_ops_list) {
-		if (ftrace_ops_test(op, ip))
+		if (ftrace_ops_test(op, ip, regs))
 			op->func(ip, parent_ip, op, regs);
 	} while_for_each_ftrace_op(op);
 	preempt_enable_notrace();


