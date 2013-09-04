Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762925Ab3IDOmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:42:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22259 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762789Ab3IDOhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:37:04 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=p5YntF7KTRQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=P0A6PHofSPYA:10 a=VnNF1IyMAAAA:8 a=XkBj-IQaWrKBahX74fgA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130904143702.286461723@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 04 Sep 2013 10:36:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [for-next][PATCH 12/18] ftrace: Add infrastructure to stop RCU unsafe checker from checking
References: <20130904143552.456506259@goodmis.org>
Content-Disposition: inline; filename=0011-ftrace-Add-infrastructure-to-stop-RCU-unsafe-checker.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

This is a light weight way to keep the rcu checker from checking
RCU safety. It adds a ftrace_unsafe_rcu_checker_disable/enable()
that increments or decrements a counter respectively. When the
counter is set, the RCU unsafe checker callback does not run the
tests to see if RCU is safe or not. But the callback still gets called.
It just does not call rcu_read_(un)lock().

This is required by the graph tracer because the checks can cause
the graph tracer to live lock the system by its own calls. That is,
the graph tracer will still trace rcu and the rcu debugging, and this
will slow down the checker, which is still calling all other functions
(in interrupts and faults), which can cause the timer interrupt to
take oven a millisecond to complete, and it will then trigger once
it finishes, live locking the system.

It's also needed by the irqsoff tracer, because it may be called
in RCU unsafe regions and if its internal functions get traced
then the RCU unsafe checker may have some false positives.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h           |   12 +++++++++---
 kernel/trace/trace_functions.c |   22 ++++++++++++++++++++++
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e551316..58e4c37 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -760,9 +760,6 @@ static inline int ftrace_graph_addr(unsigned long addr)
 
 	return 0;
 }
-#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
-extern bool ftrace_rcu_unsafe(unsigned long addr);
-#endif
 #else
 static inline int ftrace_graph_addr(unsigned long addr)
 {
@@ -1061,4 +1058,13 @@ int perf_ftrace_event_register(struct ftrace_event_call *call,
 #define perf_ftrace_event_register NULL
 #endif
 
+#ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
+extern bool ftrace_rcu_unsafe(unsigned long addr);
+extern void ftrace_unsafe_rcu_checker_disable(void);
+extern void ftrace_unsafe_rcu_checker_enable(void);
+#else
+static inline void ftrace_unsafe_rcu_checker_disable(void) { }
+static inline void ftrace_unsafe_rcu_checker_enable(void) { }
+#endif
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 79641bb..9e6902a 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -560,12 +560,34 @@ static inline int init_func_cmd_traceon(void)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 #ifdef CONFIG_FTRACE_UNSAFE_RCU_CHECKER
+
 static DEFINE_PER_CPU(int, ftrace_rcu_running);
 
+static atomic_t ftrace_unsafe_rcu_disabled;
+
+void ftrace_unsafe_rcu_checker_disable(void)
+{
+	atomic_inc(&ftrace_unsafe_rcu_disabled);
+	/* Make sure the update is seen immediately */
+	smp_mb__after_atomic_inc();
+}
+
+void ftrace_unsafe_rcu_checker_enable(void)
+{
+	atomic_dec(&ftrace_unsafe_rcu_disabled);
+	/* Make sure the update is seen immediately */
+	smp_mb__after_atomic_dec();
+}
+
 static void
 ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
 		       struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
+	/* Make sure we see disabled or not first */
+	smp_rmb();
+	if (atomic_read(&ftrace_unsafe_rcu_disabled))
+		return;
+
 	preempt_disable_notrace();
 
 	if (this_cpu_read(ftrace_rcu_running))
-- 
1.7.10.4


