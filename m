Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab3B0RvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:51:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22754 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760474Ab3B0RuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:50:01 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=KUnWwQ3O9PwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=tiGYht-md58A:10 a=20KFwNOVAAAA:8 a=54GSLi-_bSQOV4Glv0QA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130227174958.524772053@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 27 Feb 2013 12:22:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Subject: [for-next][PATCH 5/8] tracing: Replace the static global per_cpu arrays with allocated
 per_cpu
References: <20130227172232.707306533@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-Replace-the-static-global-per_cpu-arrays-wit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The global and max-tr currently use static per_cpu arrays for the CPU data
descriptors. But in order to get new allocated trace_arrays, they need to
be allocated per_cpu arrays. Instead of using the static arrays, switch
the global and max-tr to use allocated data.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c                 |   92 ++++++++++++++++++++--------------
 kernel/trace/trace.h                 |    2 +-
 kernel/trace/trace_branch.c          |    6 ++-
 kernel/trace/trace_functions.c       |    4 +-
 kernel/trace/trace_functions_graph.c |    4 +-
 kernel/trace/trace_irqsoff.c         |    6 +--
 kernel/trace/trace_mmiotrace.c       |    4 +-
 kernel/trace/trace_sched_switch.c    |    4 +-
 kernel/trace/trace_sched_wakeup.c    |   14 +++---
 9 files changed, 77 insertions(+), 59 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3c18fd0..74bc123 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -191,8 +191,6 @@ static struct trace_array	global_trace;
 
 LIST_HEAD(ftrace_trace_arrays);
 
-static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
-
 int filter_current_check_discard(struct ring_buffer *buffer,
 				 struct ftrace_event_call *call, void *rec,
 				 struct ring_buffer_event *event)
@@ -227,8 +225,6 @@ cycle_t ftrace_now(int cpu)
  */
 static struct trace_array	max_tr;
 
-static DEFINE_PER_CPU(struct trace_array_cpu, max_tr_data);
-
 int tracing_is_enabled(void)
 {
 	return tracing_is_on();
@@ -666,13 +662,13 @@ unsigned long __read_mostly	tracing_max_latency;
 static void
 __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct trace_array_cpu *data = tr->data[cpu];
+	struct trace_array_cpu *data = per_cpu_ptr(tr->data, cpu);
 	struct trace_array_cpu *max_data;
 
 	max_tr.cpu = cpu;
 	max_tr.time_start = data->preempt_timestamp;
 
-	max_data = max_tr.data[cpu];
+	max_data = per_cpu_ptr(max_tr.data, cpu);
 	max_data->saved_latency = tracing_max_latency;
 	max_data->critical_start = data->critical_start;
 	max_data->critical_end = data->critical_end;
@@ -1983,7 +1979,7 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 	unsigned long entries = 0;
 	u64 ts;
 
-	tr->data[cpu]->skipped_entries = 0;
+	per_cpu_ptr(tr->data, cpu)->skipped_entries = 0;
 
 	buf_iter = trace_buffer_iter(iter, cpu);
 	if (!buf_iter)
@@ -2003,7 +1999,7 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 		ring_buffer_read(buf_iter, NULL);
 	}
 
-	tr->data[cpu]->skipped_entries = entries;
+	per_cpu_ptr(tr->data, cpu)->skipped_entries = entries;
 }
 
 /*
@@ -2098,8 +2094,8 @@ get_total_entries(struct trace_array *tr, unsigned long *total, unsigned long *e
 		 * entries for the trace and we need to ignore the
 		 * ones before the time stamp.
 		 */
-		if (tr->data[cpu]->skipped_entries) {
-			count -= tr->data[cpu]->skipped_entries;
+		if (per_cpu_ptr(tr->data, cpu)->skipped_entries) {
+			count -= per_cpu_ptr(tr->data, cpu)->skipped_entries;
 			/* total is the same as the entries */
 			*total += count;
 		} else
@@ -2156,7 +2152,7 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 {
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
 	struct trace_array *tr = iter->tr;
-	struct trace_array_cpu *data = tr->data[tr->cpu];
+	struct trace_array_cpu *data = per_cpu_ptr(tr->data, tr->cpu);
 	struct tracer *type = iter->trace;
 	unsigned long entries;
 	unsigned long total;
@@ -2226,7 +2222,7 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
 	if (cpumask_test_cpu(iter->cpu, iter->started))
 		return;
 
-	if (iter->tr->data[iter->cpu]->skipped_entries)
+	if (per_cpu_ptr(iter->tr->data, iter->cpu)->skipped_entries)
 		return;
 
 	cpumask_set_cpu(iter->cpu, iter->started);
@@ -2834,12 +2830,12 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 		 */
 		if (cpumask_test_cpu(cpu, tracing_cpumask) &&
 				!cpumask_test_cpu(cpu, tracing_cpumask_new)) {
-			atomic_inc(&tr->data[cpu]->disabled);
+			atomic_inc(&per_cpu_ptr(tr->data, cpu)->disabled);
 			ring_buffer_record_disable_cpu(tr->buffer, cpu);
 		}
 		if (!cpumask_test_cpu(cpu, tracing_cpumask) &&
 				cpumask_test_cpu(cpu, tracing_cpumask_new)) {
-			atomic_dec(&tr->data[cpu]->disabled);
+			atomic_dec(&per_cpu_ptr(tr->data, cpu)->disabled);
 			ring_buffer_record_enable_cpu(tr->buffer, cpu);
 		}
 	}
@@ -3129,7 +3125,7 @@ static void set_buffer_entries(struct trace_array *tr, unsigned long val)
 {
 	int cpu;
 	for_each_tracing_cpu(cpu)
-		tr->data[cpu]->entries = val;
+		per_cpu_ptr(tr->data, cpu)->entries = val;
 }
 
 /* resize @tr's buffer to the size of @size_tr's entries */
@@ -3141,17 +3137,18 @@ static int resize_buffer_duplicate_size(struct trace_array *tr,
 	if (cpu_id == RING_BUFFER_ALL_CPUS) {
 		for_each_tracing_cpu(cpu) {
 			ret = ring_buffer_resize(tr->buffer,
-					size_tr->data[cpu]->entries, cpu);
+				 per_cpu_ptr(size_tr->data, cpu)->entries, cpu);
 			if (ret < 0)
 				break;
-			tr->data[cpu]->entries = size_tr->data[cpu]->entries;
+			per_cpu_ptr(tr->data, cpu)->entries =
+				per_cpu_ptr(size_tr->data, cpu)->entries;
 		}
 	} else {
 		ret = ring_buffer_resize(tr->buffer,
-					size_tr->data[cpu_id]->entries, cpu_id);
+				 per_cpu_ptr(size_tr->data, cpu_id)->entries, cpu_id);
 		if (ret == 0)
-			tr->data[cpu_id]->entries =
-				size_tr->data[cpu_id]->entries;
+			per_cpu_ptr(tr->data, cpu_id)->entries =
+				per_cpu_ptr(size_tr->data, cpu_id)->entries;
 	}
 
 	return ret;
@@ -3208,13 +3205,13 @@ static int __tracing_resize_ring_buffer(struct trace_array *tr,
 	if (cpu == RING_BUFFER_ALL_CPUS)
 		set_buffer_entries(&max_tr, size);
 	else
-		max_tr.data[cpu]->entries = size;
+		per_cpu_ptr(max_tr.data, cpu)->entries = size;
 
  out:
 	if (cpu == RING_BUFFER_ALL_CPUS)
 		set_buffer_entries(tr, size);
 	else
-		tr->data[cpu]->entries = size;
+		per_cpu_ptr(tr->data, cpu)->entries = size;
 
 	return ret;
 }
@@ -3853,8 +3850,8 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
 		for_each_tracing_cpu(cpu) {
 			/* fill in the size from first enabled cpu */
 			if (size == 0)
-				size = tr->data[cpu]->entries;
-			if (size != tr->data[cpu]->entries) {
+				size = per_cpu_ptr(tr->data, cpu)->entries;
+			if (size != per_cpu_ptr(tr->data, cpu)->entries) {
 				buf_size_same = 0;
 				break;
 			}
@@ -3870,7 +3867,7 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
 		} else
 			r = sprintf(buf, "X\n");
 	} else
-		r = sprintf(buf, "%lu\n", tr->data[tc->cpu]->entries >> 10);
+		r = sprintf(buf, "%lu\n", per_cpu_ptr(tr->data, tc->cpu)->entries >> 10);
 
 	mutex_unlock(&trace_types_lock);
 
@@ -3917,7 +3914,7 @@ tracing_total_entries_read(struct file *filp, char __user *ubuf,
 
 	mutex_lock(&trace_types_lock);
 	for_each_tracing_cpu(cpu) {
-		size += tr->data[cpu]->entries >> 10;
+		size += per_cpu_ptr(tr->data, cpu)->entries >> 10;
 		if (!ring_buffer_expanded)
 			expanded_size += trace_buf_size >> 10;
 	}
@@ -4689,7 +4686,7 @@ static struct dentry *tracing_dentry_percpu(struct trace_array *tr, int cpu)
 static void
 tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 {
-	struct trace_array_cpu *data = tr->data[cpu];
+	struct trace_array_cpu *data = per_cpu_ptr(tr->data, cpu);
 	struct dentry *d_percpu = tracing_dentry_percpu(tr, cpu);
 	struct dentry *d_cpu;
 	char cpu_dir[30]; /* 30 characters should be more than enough */
@@ -5207,7 +5204,7 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 	trace_init_global_iter(&iter);
 
 	for_each_tracing_cpu(cpu) {
-		atomic_inc(&iter.tr->data[cpu]->disabled);
+		atomic_inc(&per_cpu_ptr(iter.tr->data, cpu)->disabled);
 	}
 
 	old_userobj = trace_flags & TRACE_ITER_SYM_USEROBJ;
@@ -5275,7 +5272,7 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 		trace_flags |= old_userobj;
 
 		for_each_tracing_cpu(cpu) {
-			atomic_dec(&iter.tr->data[cpu]->disabled);
+			atomic_dec(&per_cpu_ptr(iter.tr->data, cpu)->disabled);
 		}
 		tracing_on();
 	}
@@ -5331,11 +5328,31 @@ __init static int tracer_alloc_buffers(void)
 		WARN_ON(1);
 		goto out_free_cpumask;
 	}
+
+	global_trace.data = alloc_percpu(struct trace_array_cpu);
+
+	if (!global_trace.data) {
+		printk(KERN_ERR "tracer: failed to allocate percpu memory!\n");
+		WARN_ON(1);
+		goto out_free_cpumask;
+	}
+
+	for_each_tracing_cpu(i) {
+		memset(per_cpu_ptr(global_trace.data, i), 0, sizeof(struct trace_array_cpu));
+		per_cpu_ptr(global_trace.data, i)->trace_cpu.cpu = i;
+		per_cpu_ptr(global_trace.data, i)->trace_cpu.tr = &global_trace;
+	}
+
 	if (global_trace.buffer_disabled)
 		tracing_off();
 
-
 #ifdef CONFIG_TRACER_MAX_TRACE
+	max_tr.data = alloc_percpu(struct trace_array_cpu);
+	if (!max_tr.data) {
+		printk(KERN_ERR "tracer: failed to allocate percpu memory!\n");
+		WARN_ON(1);
+		goto out_free_cpumask;
+	}
 	max_tr.buffer = ring_buffer_alloc(1, rb_flags);
 	raw_spin_lock_init(&max_tr.start_lock);
 	if (!max_tr.buffer) {
@@ -5344,18 +5361,15 @@ __init static int tracer_alloc_buffers(void)
 		ring_buffer_free(global_trace.buffer);
 		goto out_free_cpumask;
 	}
-#endif
 
-	/* Allocate the first page for all buffers */
 	for_each_tracing_cpu(i) {
-		global_trace.data[i] = &per_cpu(global_trace_cpu, i);
-		global_trace.data[i]->trace_cpu.cpu = i;
-		global_trace.data[i]->trace_cpu.tr = &global_trace;
-		max_tr.data[i] = &per_cpu(max_tr_data, i);
-		max_tr.data[i]->trace_cpu.cpu = i;
-		max_tr.data[i]->trace_cpu.tr = &max_tr;
+		memset(per_cpu_ptr(max_tr.data, i), 0, sizeof(struct trace_array_cpu));
+		per_cpu_ptr(max_tr.data, i)->trace_cpu.cpu = i;
+		per_cpu_ptr(max_tr.data, i)->trace_cpu.tr = &max_tr;
 	}
+#endif
 
+	/* Allocate the first page for all buffers */
 	set_buffer_entries(&global_trace,
 			   ring_buffer_size(global_trace.buffer, 0));
 #ifdef CONFIG_TRACER_MAX_TRACE
@@ -5397,6 +5411,8 @@ __init static int tracer_alloc_buffers(void)
 	return 0;
 
 out_free_cpumask:
+	free_percpu(global_trace.data);
+	free_percpu(max_tr.data);
 	free_cpumask_var(tracing_cpumask);
 out_free_buffer_mask:
 	free_cpumask_var(tracing_buffer_mask);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 0499cce..38a60e6 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -186,7 +186,7 @@ struct trace_array {
 	struct list_head	systems;
 	struct list_head	events;
 	struct task_struct	*waiter;
-	struct trace_array_cpu	*data[NR_CPUS];
+	struct trace_array_cpu	*data;
 };
 
 enum {
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 95e9684..6dadbef 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -32,6 +32,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 {
 	struct ftrace_event_call *call = &event_branch;
 	struct trace_array *tr = branch_tracer;
+	struct trace_array_cpu *data;
 	struct ring_buffer_event *event;
 	struct trace_branch *entry;
 	struct ring_buffer *buffer;
@@ -51,7 +52,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
+	data = per_cpu_ptr(tr->data, cpu);
+	if (atomic_inc_return(&data->disabled) != 1)
 		goto out;
 
 	pc = preempt_count();
@@ -80,7 +82,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 		__buffer_unlock_commit(buffer, event);
 
  out:
-	atomic_dec(&tr->data[cpu]->disabled);
+	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
 }
 
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 6011525..9d73861 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -76,7 +76,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip,
 		goto out;
 
 	cpu = smp_processor_id();
-	data = tr->data[cpu];
+	data = per_cpu_ptr(tr->data, cpu);
 	if (!atomic_read(&data->disabled)) {
 		local_save_flags(flags);
 		trace_function(tr, ip, parent_ip, flags, pc);
@@ -107,7 +107,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
 	 */
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
+	data = per_cpu_ptr(tr->data, cpu);
 	disabled = atomic_inc_return(&data->disabled);
 
 	if (likely(disabled == 1)) {
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 39ada66..ca986d6 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -265,7 +265,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
+	data = per_cpu_ptr(tr->data, cpu);
 	disabled = atomic_inc_return(&data->disabled);
 	if (likely(disabled == 1)) {
 		pc = preempt_count();
@@ -350,7 +350,7 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
+	data = per_cpu_ptr(tr->data, cpu);
 	disabled = atomic_inc_return(&data->disabled);
 	if (likely(disabled == 1)) {
 		pc = preempt_count();
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 713a2ca..7137a0f 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -121,7 +121,7 @@ static int func_prolog_dec(struct trace_array *tr,
 	if (!irqs_disabled_flags(*flags))
 		return 0;
 
-	*data = tr->data[cpu];
+	*data = per_cpu_ptr(tr->data, cpu);
 	disabled = atomic_inc_return(&(*data)->disabled);
 
 	if (likely(disabled == 1))
@@ -380,7 +380,7 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
 	if (per_cpu(tracing_cpu, cpu))
 		return;
 
-	data = tr->data[cpu];
+	data = per_cpu_ptr(tr->data, cpu);
 
 	if (unlikely(!data) || atomic_read(&data->disabled))
 		return;
@@ -418,7 +418,7 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
 	if (!tracer_enabled)
 		return;
 
-	data = tr->data[cpu];
+	data = per_cpu_ptr(tr->data, cpu);
 
 	if (unlikely(!data) ||
 	    !data->critical_start || atomic_read(&data->disabled))
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index fd3c8aa..2472f6f 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -330,7 +330,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 void mmio_trace_rw(struct mmiotrace_rw *rw)
 {
 	struct trace_array *tr = mmio_trace_array;
-	struct trace_array_cpu *data = tr->data[smp_processor_id()];
+	struct trace_array_cpu *data = per_cpu_ptr(tr->data, smp_processor_id());
 	__trace_mmiotrace_rw(tr, data, rw);
 }
 
@@ -363,7 +363,7 @@ void mmio_trace_mapping(struct mmiotrace_map *map)
 	struct trace_array_cpu *data;
 
 	preempt_disable();
-	data = tr->data[smp_processor_id()];
+	data = per_cpu_ptr(tr->data, smp_processor_id());
 	__trace_mmiotrace_map(tr, data, map);
 	preempt_enable();
 }
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 3374c79..1ffe39a 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -69,7 +69,7 @@ probe_sched_switch(void *ignore, struct task_struct *prev, struct task_struct *n
 	pc = preempt_count();
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = ctx_trace->data[cpu];
+	data = per_cpu_ptr(ctx_trace->data, cpu);
 
 	if (likely(!atomic_read(&data->disabled)))
 		tracing_sched_switch_trace(ctx_trace, prev, next, flags, pc);
@@ -123,7 +123,7 @@ probe_sched_wakeup(void *ignore, struct task_struct *wakee, int success)
 	pc = preempt_count();
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = ctx_trace->data[cpu];
+	data = per_cpu_ptr(ctx_trace->data, cpu);
 
 	if (likely(!atomic_read(&data->disabled)))
 		tracing_sched_wakeup_trace(ctx_trace, wakee, current,
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 75aa97f..e6725c8 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -89,7 +89,7 @@ func_prolog_preempt_disable(struct trace_array *tr,
 	if (cpu != wakeup_current_cpu)
 		goto out_enable;
 
-	*data = tr->data[cpu];
+	*data = per_cpu_ptr(tr->data, cpu);
 	disabled = atomic_inc_return(&(*data)->disabled);
 	if (unlikely(disabled != 1))
 		goto out;
@@ -353,7 +353,7 @@ probe_wakeup_sched_switch(void *ignore,
 
 	/* disable local data, not wakeup_cpu data */
 	cpu = raw_smp_processor_id();
-	disabled = atomic_inc_return(&wakeup_trace->data[cpu]->disabled);
+	disabled = atomic_inc_return(&per_cpu_ptr(wakeup_trace->data, cpu)->disabled);
 	if (likely(disabled != 1))
 		goto out;
 
@@ -365,7 +365,7 @@ probe_wakeup_sched_switch(void *ignore,
 		goto out_unlock;
 
 	/* The task we are waiting for is waking up */
-	data = wakeup_trace->data[wakeup_cpu];
+	data = per_cpu_ptr(wakeup_trace->data, wakeup_cpu);
 
 	__trace_function(wakeup_trace, CALLER_ADDR0, CALLER_ADDR1, flags, pc);
 	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
@@ -387,7 +387,7 @@ out_unlock:
 	arch_spin_unlock(&wakeup_lock);
 	local_irq_restore(flags);
 out:
-	atomic_dec(&wakeup_trace->data[cpu]->disabled);
+	atomic_dec(&per_cpu_ptr(wakeup_trace->data, cpu)->disabled);
 }
 
 static void __wakeup_reset(struct trace_array *tr)
@@ -435,7 +435,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 		return;
 
 	pc = preempt_count();
-	disabled = atomic_inc_return(&wakeup_trace->data[cpu]->disabled);
+	disabled = atomic_inc_return(&per_cpu_ptr(wakeup_trace->data, cpu)->disabled);
 	if (unlikely(disabled != 1))
 		goto out;
 
@@ -458,7 +458,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 
 	local_save_flags(flags);
 
-	data = wakeup_trace->data[wakeup_cpu];
+	data = per_cpu_ptr(wakeup_trace->data, wakeup_cpu);
 	data->preempt_timestamp = ftrace_now(cpu);
 	tracing_sched_wakeup_trace(wakeup_trace, p, current, flags, pc);
 
@@ -472,7 +472,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 out_locked:
 	arch_spin_unlock(&wakeup_lock);
 out:
-	atomic_dec(&wakeup_trace->data[cpu]->disabled);
+	atomic_dec(&per_cpu_ptr(wakeup_trace->data, cpu)->disabled);
 }
 
 static void start_wakeup_tracer(struct trace_array *tr)
-- 
1.7.10.4


