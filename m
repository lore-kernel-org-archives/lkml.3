Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaDXQNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:13:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:17474 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758359AbaDXQDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:03:21 -0400
Message-Id: <20140424160319.966124794@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:02:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 2/8] tracing: Move tracing_max_latency into trace_array
References: <20140424160232.271454710@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-Move-tracing_max_latency-into-trace_array.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In preparation for letting the latency tracers be used by instances,
remove the global tracing_max_latency variable and add a max_latency
field to the trace_array that the latency tracers will now use.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c              | 14 ++++++--------
 kernel/trace/trace.h              |  3 +--
 kernel/trace/trace_irqsoff.c      | 14 +++++++-------
 kernel/trace/trace_sched_wakeup.c | 12 ++++++------
 kernel/trace/trace_selftest.c     | 26 +++++++++++++-------------
 5 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fdd33aa..f5fc56b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -982,8 +982,6 @@ static arch_spinlock_t ftrace_max_lock =
 unsigned long __read_mostly	tracing_thresh;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-unsigned long __read_mostly	tracing_max_latency;
-
 /*
  * Copy the new maximum trace into the separate maximum-trace
  * structure. (this way the maximum trace is permanently saved,
@@ -1000,7 +998,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	max_buf->cpu = cpu;
 	max_buf->time_start = data->preempt_timestamp;
 
-	max_data->saved_latency = tracing_max_latency;
+	max_data->saved_latency = tr->max_latency;
 	max_data->critical_start = data->critical_start;
 	max_data->critical_end = data->critical_end;
 
@@ -6328,6 +6326,11 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 	trace_create_file("tracing_on", 0644, d_tracer,
 			  tr, &rb_simple_fops);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
+	trace_create_file("tracing_max_latency", 0644, d_tracer,
+			&tr->max_latency, &tracing_max_lat_fops);
+#endif
+
 	if (ftrace_create_function_files(tr, d_tracer))
 		WARN(1, "Could not allocate function filter files");
 
@@ -6353,11 +6356,6 @@ static __init int tracer_init_debugfs(void)
 
 	init_tracer_debugfs(&global_trace, d_tracer);
 
-#ifdef CONFIG_TRACER_MAX_TRACE
-	trace_create_file("tracing_max_latency", 0644, d_tracer,
-			&tracing_max_latency, &tracing_max_lat_fops);
-#endif
-
 	trace_create_file("tracing_thresh", 0644, d_tracer,
 			&tracing_thresh, &tracing_max_lat_fops);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index df5256b..644a8b5 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -190,6 +190,7 @@ struct trace_array {
 	 */
 	struct trace_buffer	max_buffer;
 	bool			allocated_snapshot;
+	unsigned long		max_latency;
 #endif
 	int			buffer_disabled;
 #ifdef CONFIG_FTRACE_SYSCALLS
@@ -599,8 +600,6 @@ extern unsigned long nsecs_to_usecs(unsigned long nsecs);
 extern unsigned long tracing_thresh;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-extern unsigned long tracing_max_latency;
-
 void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu);
 void update_max_tr_single(struct trace_array *tr,
 			  struct task_struct *tsk, int cpu);
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index b5cb047..40aa300 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -170,7 +170,7 @@ irqsoff_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 	for_each_possible_cpu(cpu)
 		per_cpu(tracing_cpu, cpu) = 0;
 
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 	tracing_reset_online_cpus(&irqsoff_trace->trace_buffer);
 
 	return start_irqsoff_tracer(irqsoff_trace, set);
@@ -297,13 +297,13 @@ static void irqsoff_print_header(struct seq_file *s)
 /*
  * Should this new latency be reported/recorded?
  */
-static int report_latency(cycle_t delta)
+static int report_latency(struct trace_array *tr, cycle_t delta)
 {
 	if (tracing_thresh) {
 		if (delta < tracing_thresh)
 			return 0;
 	} else {
-		if (delta <= tracing_max_latency)
+		if (delta <= tr->max_latency)
 			return 0;
 	}
 	return 1;
@@ -327,13 +327,13 @@ check_critical_timing(struct trace_array *tr,
 
 	pc = preempt_count();
 
-	if (!report_latency(delta))
+	if (!report_latency(tr, delta))
 		goto out;
 
 	raw_spin_lock_irqsave(&max_trace_lock, flags);
 
 	/* check if we are still the max latency */
-	if (!report_latency(delta))
+	if (!report_latency(tr, delta))
 		goto out_unlock;
 
 	__trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
@@ -346,7 +346,7 @@ check_critical_timing(struct trace_array *tr,
 	data->critical_end = parent_ip;
 
 	if (likely(!is_tracing_stopped())) {
-		tracing_max_latency = delta;
+		tr->max_latency = delta;
 		update_max_tr_single(tr, current, cpu);
 	}
 
@@ -605,7 +605,7 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, 1);
 
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 	irqsoff_trace = tr;
 	/* make sure that the tracer is visible */
 	smp_wmb();
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 4dd986d..41e0b8a 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -218,7 +218,7 @@ wakeup_set_flag(struct trace_array *tr, u32 old_flags, u32 bit, int set)
 	stop_func_tracer(tr, !set);
 
 	wakeup_reset(wakeup_trace);
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 
 	return start_func_tracer(tr, set);
 }
@@ -344,13 +344,13 @@ static void wakeup_print_header(struct seq_file *s)
 /*
  * Should this new latency be reported/recorded?
  */
-static int report_latency(cycle_t delta)
+static int report_latency(struct trace_array *tr, cycle_t delta)
 {
 	if (tracing_thresh) {
 		if (delta < tracing_thresh)
 			return 0;
 	} else {
-		if (delta <= tracing_max_latency)
+		if (delta <= tr->max_latency)
 			return 0;
 	}
 	return 1;
@@ -418,11 +418,11 @@ probe_wakeup_sched_switch(void *ignore,
 	T1 = ftrace_now(cpu);
 	delta = T1-T0;
 
-	if (!report_latency(delta))
+	if (!report_latency(wakeup_trace, delta))
 		goto out_unlock;
 
 	if (likely(!is_tracing_stopped())) {
-		tracing_max_latency = delta;
+		wakeup_trace->max_latency = delta;
 		update_max_tr(wakeup_trace, wakeup_task, wakeup_cpu);
 	}
 
@@ -609,7 +609,7 @@ static int __wakeup_tracer_init(struct trace_array *tr)
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, 1);
 
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 	wakeup_trace = tr;
 	ftrace_init_array_ops(tr, wakeup_tracer_call);
 	start_wakeup_tracer(tr);
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 519d04a..ac31858 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -807,7 +807,7 @@ out:
 int
 trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 {
-	unsigned long save_max = tracing_max_latency;
+	unsigned long save_max = tr->max_latency;
 	unsigned long count;
 	int ret;
 
@@ -819,7 +819,7 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 	}
 
 	/* reset the max latency */
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 	/* disable interrupts for a bit */
 	local_irq_disable();
 	udelay(100);
@@ -846,7 +846,7 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 		ret = -1;
 	}
 
-	tracing_max_latency = save_max;
+	tr->max_latency = save_max;
 
 	return ret;
 }
@@ -856,7 +856,7 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 int
 trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 {
-	unsigned long save_max = tracing_max_latency;
+	unsigned long save_max = tr->max_latency;
 	unsigned long count;
 	int ret;
 
@@ -881,7 +881,7 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 	}
 
 	/* reset the max latency */
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 	/* disable preemption for a bit */
 	preempt_disable();
 	udelay(100);
@@ -908,7 +908,7 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 		ret = -1;
 	}
 
-	tracing_max_latency = save_max;
+	tr->max_latency = save_max;
 
 	return ret;
 }
@@ -918,7 +918,7 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 int
 trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *tr)
 {
-	unsigned long save_max = tracing_max_latency;
+	unsigned long save_max = tr->max_latency;
 	unsigned long count;
 	int ret;
 
@@ -943,7 +943,7 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	}
 
 	/* reset the max latency */
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 
 	/* disable preemption and interrupts for a bit */
 	preempt_disable();
@@ -978,7 +978,7 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	}
 
 	/* do the test by disabling interrupts first this time */
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 	tracing_start();
 	trace->start(tr);
 
@@ -1009,7 +1009,7 @@ out:
 	tracing_start();
 out_no_start:
 	trace->reset(tr);
-	tracing_max_latency = save_max;
+	tr->max_latency = save_max;
 
 	return ret;
 }
@@ -1062,7 +1062,7 @@ static int trace_wakeup_test_thread(void *data)
 int
 trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 {
-	unsigned long save_max = tracing_max_latency;
+	unsigned long save_max = tr->max_latency;
 	struct task_struct *p;
 	struct completion is_ready;
 	unsigned long count;
@@ -1088,7 +1088,7 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	}
 
 	/* reset the max latency */
-	tracing_max_latency = 0;
+	tr->max_latency = 0;
 
 	while (p->on_rq) {
 		/*
@@ -1118,7 +1118,7 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	trace->reset(tr);
 	tracing_start();
 
-	tracing_max_latency = save_max;
+	tr->max_latency = save_max;
 
 	/* kill the thread */
 	kthread_stop(p);
-- 
1.8.5.3


