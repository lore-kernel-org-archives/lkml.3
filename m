Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaG2MdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:33:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbaG2Mc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:32:59 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v4 3/3] trace: Allow to call update_max_tr_single() from another CPU
Date: Tue, 29 Jul 2014 14:31:43 +0200
Message-Id: <1406637103-15435-4-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1406637103-15435-1-git-send-email-pmladek@suse.cz>
References: <1406637103-15435-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any CPU specific tracing buffer could get switched by

    echo 1 >/sys/kernel/debug/tracing/per_cpu/cpuN/snapshot

It triggers the following sequence of calls:

   + tracing_snapshot_write()
     + update_max_tr_single()
       + ring_buffer_swap_cpu()

We need to call ring_buffer_swap_cpu() with disabled interrupts because
it is done under "tr->max_lock" and it would cause races otherwise.
It also means that we need to call it from the right CPU but it is
not guaranteed by tracing_snapshot_write().

This patch solves the problem by renaming update_max_tr_single()
to update_max_tr_this_cpu(). It works with the current CPU instead
of the passed one. It can be called from check_critical_timing()
directly.

Also it introduces function with the original name update_max_tr_single()
that calls the CPU-specific one via smp_call_function_single().
It can be called from tracing_snapshot_write() but with enabled interrupts.
Otherwise, smp_call_function_single() would not work.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/trace/trace.c         | 60 ++++++++++++++++++++++++++++++++++++++------
 kernel/trace/trace.h         |  1 +
 kernel/trace/trace_irqsoff.c |  2 +-
 3 files changed, 54 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4caa814d41c3..a2dc83b98cc0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1017,22 +1017,29 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 }
 
 /**
- * update_max_tr_single - only copy one trace over, and reset the rest
+ * update_max_tr_this_cpu_single - copy trace for this CPU, and reset the rest
  * @tr - tracer
  * @tsk - task with the latency
- * @cpu - the cpu of the buffer to copy.
  *
- * Flip the trace of a single CPU buffer between the @tr and the max_tr.
+ * Flip the trace of this CPU buffer between the @tr and the max_tr.
+ *
+ * It is called on this CPU. Otherwise, ring_buffer_swap_cpu() would not work
+ * with disabled interrupts. They must be disabled to avoid a race under
+ * tr->max_lock and because this is used in irqsoff tracer that is sensitive
+ * about it.
  */
 void
-update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
+update_max_tr_this_cpu(struct trace_array *tr, struct task_struct *tsk)
 {
+	int cpu;
 	int ret;
 
 	if (tr->stop_count)
 		return;
 
 	WARN_ON_ONCE(!irqs_disabled());
+	cpu = smp_processor_id();
+
 	if (!tr->allocated_snapshot) {
 		/* Only the nop tracer should hit this when disabling */
 		WARN_ON_ONCE(tr->current_trace != &nop_trace);
@@ -1059,6 +1066,42 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	__update_max_tr(tr, tsk, cpu);
 	arch_spin_unlock(&tr->max_lock);
 }
+
+struct update_max_tr_info {
+	struct trace_array *tr;
+	struct task_struct *tsk;
+};
+
+static void update_max_tr_function_single(void *arg)
+{
+	struct update_max_tr_info *tr_info = arg;
+	struct trace_array *tr = tr_info->tr;
+	struct task_struct *tsk = tr_info->tsk;
+
+	update_max_tr_this_cpu(tr, tsk);
+}
+
+/**
+ * update_max_tr_this_cpu_single - only copy one trace over, and reset the rest
+ * @tr - tracer
+ * @tsk - task with the latency
+ * @cpu - the cpu of the buffer to copy.
+ *
+ * Flip the trace of a single CPU buffer between the @tr and the max_tr.
+ */
+void
+update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
+{
+	struct update_max_tr_info tr_info = {tr, tsk};
+
+
+	/*
+	 * The flip has to be done on the same CPU, see
+	 * update_max_tr_this_cpu() for more details.
+	 */
+	smp_call_function_single(cpu, update_max_tr_function_single,
+				 (void *)&tr_info, 1);
+}
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
 static int wait_on_pipe(struct trace_iterator *iter)
@@ -5057,13 +5100,14 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 			if (ret < 0)
 				break;
 		}
-		local_irq_disable();
 		/* Now, we're going to swap */
-		if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
+		if (iter->cpu_file == RING_BUFFER_ALL_CPUS) {
+			local_irq_disable();
 			update_max_tr(tr, current, smp_processor_id());
-		else
+			local_irq_enable();
+		} else {
 			update_max_tr_single(tr, current, iter->cpu_file);
-		local_irq_enable();
+		}
 		break;
 	default:
 		if (tr->allocated_snapshot) {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9258f5a815db..5aa876b9190e 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -616,6 +616,7 @@ extern unsigned long tracing_thresh;
 void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu);
 void update_max_tr_single(struct trace_array *tr,
 			  struct task_struct *tsk, int cpu);
+void update_max_tr_this_cpu(struct trace_array *tr, struct task_struct *tsk);
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
 #ifdef CONFIG_STACKTRACE
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 1d4eeb304583..90a28d5105e4 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -347,7 +347,7 @@ check_critical_timing(struct trace_array *tr,
 
 	if (likely(!is_tracing_stopped())) {
 		tr->max_latency = delta;
-		update_max_tr_single(tr, current, cpu);
+		update_max_tr_this_cpu(tr, current);
 	}
 
 	max_sequence++;
-- 
1.8.4

