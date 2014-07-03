Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbaGCUYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:24:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:48678 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751357AbaGCUX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:23:28 -0400
Message-Id: <20140703202325.240729487@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 16:07:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [RFC][PATCH 3/3] ftrace/x86: Allow !CONFIG_PREEMPT dynamic ops to use allocated
 trampolines
References: <20140703200750.648550267@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-ftrace-x86-Allow-CONFIG_PREEMPT-dynamic-ops-to-use-a.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When the static ftrace_ops (like function tracer) enables tracing, and it
is the only callback that is referencing a function, a trampoline is
dynamically allocated to the function that calls the callback directly
instead of calling a loop function that iterates over all the registered
ftrace ops (if more than one ops is registered).

But when it comes to dynamically allocated ftrace_ops, where they may be
freed, on a CONFIG_PREEMPT kernel there's no way to know when it is safe
to free the trampoline. If a task was preempted while executing on the
trampoline, there's currently no way to know when it will be off that
trampoline.

But this is not true when it comes to !CONFIG_PREEMPT. The current method
of calling schedule_on_each_cpu() will force tasks off the trampoline,
becaues they can not schedule while on it (kernel preemption is not
configured). That means it is safe to free a dynamically allocated
ftrace ops trampoline when CONFIG_PREEMPT is not configured.

Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c |  8 ++++++++
 kernel/trace/ftrace.c    | 18 ++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 50de611d44b4..b718fe6f881a 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -874,6 +874,14 @@ void *arch_ftrace_trampoline_func(struct ftrace_ops *ops, struct dyn_ftrace *rec
 	return addr_from_call((void *)ops->trampoline + offset);
 }
 
+void arch_ftrace_trampoline_free(struct ftrace_ops *ops)
+{
+	if (!ops || !(ops->flags & FTRACE_OPS_FL_ALLOC_TRAMP))
+		return;
+
+	module_free(NULL, ops->trampoline);
+	ops->trampoline = NULL;
+}
 
 #endif /* CONFIG_X86_64 */
 #endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 66cbb3b7251d..a1202c6d57d2 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2281,6 +2281,10 @@ static void ftrace_run_update_code(int command)
 static ftrace_func_t saved_ftrace_func;
 static int ftrace_start_up;
 
+void __weak arch_ftrace_trampoline_free(struct ftrace_ops *ops)
+{
+}
+
 static void control_ops_free(struct ftrace_ops *ops)
 {
 	free_percpu(ops->disabled);
@@ -2391,6 +2395,8 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 	if (ops->flags & (FTRACE_OPS_FL_DYNAMIC | FTRACE_OPS_FL_CONTROL)) {
 		schedule_on_each_cpu(ftrace_sync);
 
+		arch_ftrace_trampoline_free(ops);
+
 		if (ops->flags & FTRACE_OPS_FL_CONTROL)
 			control_ops_free(ops);
 	}
@@ -4632,9 +4638,21 @@ void __weak arch_ftrace_update_trampoline(struct ftrace_ops *ops)
 
 static void ftrace_update_trampoline(struct ftrace_ops *ops)
 {
+
+/*
+ * Currently there's no safe way to free a trampoline when the kernel
+ * is configured with PREEMPT. That is because a task could be preempted
+ * when it jumped to the trampoline, it may be preempted for a long time
+ * depending on the system load, and currently there's no way to know
+ * when it will be off the trampoline. If the trampoline is freed
+ * too early, when the task runs again, it will be executing on freed
+ * memory and crash.
+ */
+#ifdef CONFIG_PREEMPT
 	/* Currently, only non dynamic ops can have a trampoline */
 	if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
 		return;
+#endif
 
 	arch_ftrace_update_trampoline(ops);
 }
-- 
2.0.0


