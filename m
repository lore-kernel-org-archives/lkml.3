Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643Ab3CHDH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760292Ab3CHDG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:56 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=GgjhSBraxPUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=yDEfAbdnXCoA:10 a=20KFwNOVAAAA:8 a=RqOAJGx8AAAA:8 a=pe9ZnZDf0x7dPP-xrncA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=qygXvpG7WVDGwZWy:21 a=7aFGTb3RwwYU8o3J:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030652.776608683@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 06/17] tracing: Consolidate max_tr into main trace_array structure
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Consolidate-max_tr-into-main-trace_array-str.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

Currently, the way the latency tracers and snapshot feature works
is to have a separate trace_array called "max_tr" that holds the
snapshot buffer. For latency tracers, this snapshot buffer is used
to swap the running buffer with this buffer to save the current max
latency.

The only items needed for the max_tr is really just a copy of the buffer
itself, the per_cpu data pointers, the time_start timestamp that states
when the max latency was triggered, and the cpu that the max latency
was triggered on. All other fields in trace_array are unused by the
max_tr, making the max_tr mostly bloat.

This change removes the max_tr completely, and adds a new structure
called trace_buffer, that holds the buffer pointer, the per_cpu data
pointers, the time_start timestamp, and the cpu where the latency occurred.

The trace_array, now has two trace_buffers, one for the normal trace and
one for the max trace or snapshot. By doing this, not only do we remove
the bloat from the max_trace but the instances of traces can now use
their own snapshot feature and not have just the top level global_trace have
the snapshot feature and latency tracers for itself.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h         |    2 +
 kernel/trace/blktrace.c              |    4 +-
 kernel/trace/trace.c                 |  484 +++++++++++++++++++---------------
 kernel/trace/trace.h                 |   35 ++-
 kernel/trace/trace_functions.c       |    8 +-
 kernel/trace/trace_functions_graph.c |   12 +-
 kernel/trace/trace_irqsoff.c         |   10 +-
 kernel/trace/trace_kdb.c             |    8 +-
 kernel/trace/trace_mmiotrace.c       |   12 +-
 kernel/trace/trace_output.c          |    2 +-
 kernel/trace/trace_sched_switch.c    |    8 +-
 kernel/trace/trace_sched_wakeup.c    |   16 +-
 kernel/trace/trace_selftest.c        |   42 +--
 kernel/trace/trace_syscalls.c        |    4 +-
 14 files changed, 363 insertions(+), 284 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index d696424..d84c4a5 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -8,6 +8,7 @@
 #include <linux/perf_event.h>
 
 struct trace_array;
+struct trace_buffer;
 struct tracer;
 struct dentry;
 
@@ -67,6 +68,7 @@ struct trace_entry {
 struct trace_iterator {
 	struct trace_array	*tr;
 	struct tracer		*trace;
+	struct trace_buffer	*trace_buffer;
 	void			*private;
 	int			cpu_file;
 	struct mutex		mutex;
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 71259e2..90a5505 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -72,7 +72,7 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 	bool blk_tracer = blk_tracer_enabled;
 
 	if (blk_tracer) {
-		buffer = blk_tr->buffer;
+		buffer = blk_tr->trace_buffer.buffer;
 		pc = preempt_count();
 		event = trace_buffer_lock_reserve(buffer, TRACE_BLK,
 						  sizeof(*t) + len,
@@ -218,7 +218,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	if (blk_tracer) {
 		tracing_record_cmdline(current);
 
-		buffer = blk_tr->buffer;
+		buffer = blk_tr->trace_buffer.buffer;
 		pc = preempt_count();
 		event = trace_buffer_lock_reserve(buffer, TRACE_BLK,
 						  sizeof(*t) + pdu_len,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d852165..cd15864 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -195,27 +195,15 @@ cycle_t ftrace_now(int cpu)
 	u64 ts;
 
 	/* Early boot up does not have a buffer yet */
-	if (!global_trace.buffer)
+	if (!global_trace.trace_buffer.buffer)
 		return trace_clock_local();
 
-	ts = ring_buffer_time_stamp(global_trace.buffer, cpu);
-	ring_buffer_normalize_time_stamp(global_trace.buffer, cpu, &ts);
+	ts = ring_buffer_time_stamp(global_trace.trace_buffer.buffer, cpu);
+	ring_buffer_normalize_time_stamp(global_trace.trace_buffer.buffer, cpu, &ts);
 
 	return ts;
 }
 
-/*
- * The max_tr is used to snapshot the global_trace when a maximum
- * latency is reached. Some tracers will use this to store a maximum
- * trace while it continues examining live traces.
- *
- * The buffers for the max_tr are set up the same as the global_trace.
- * When a snapshot is taken, the link list of the max_tr is swapped
- * with the link list of the global_trace and the buffers are reset for
- * the global_trace so the tracing can continue.
- */
-static struct trace_array	max_tr;
-
 int tracing_is_enabled(void)
 {
 	return tracing_is_on();
@@ -339,8 +327,8 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
  */
 void tracing_on(void)
 {
-	if (global_trace.buffer)
-		ring_buffer_record_on(global_trace.buffer);
+	if (global_trace.trace_buffer.buffer)
+		ring_buffer_record_on(global_trace.trace_buffer.buffer);
 	/*
 	 * This flag is only looked at when buffers haven't been
 	 * allocated yet. We don't really care about the race
@@ -361,8 +349,8 @@ EXPORT_SYMBOL_GPL(tracing_on);
  */
 void tracing_off(void)
 {
-	if (global_trace.buffer)
-		ring_buffer_record_off(global_trace.buffer);
+	if (global_trace.trace_buffer.buffer)
+		ring_buffer_record_off(global_trace.trace_buffer.buffer);
 	/*
 	 * This flag is only looked at when buffers haven't been
 	 * allocated yet. We don't really care about the race
@@ -378,8 +366,8 @@ EXPORT_SYMBOL_GPL(tracing_off);
  */
 int tracing_is_on(void)
 {
-	if (global_trace.buffer)
-		return ring_buffer_record_is_on(global_trace.buffer);
+	if (global_trace.trace_buffer.buffer)
+		return ring_buffer_record_is_on(global_trace.trace_buffer.buffer);
 	return !global_trace.buffer_disabled;
 }
 EXPORT_SYMBOL_GPL(tracing_is_on);
@@ -637,13 +625,14 @@ unsigned long __read_mostly	tracing_max_latency;
 static void
 __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct trace_array_cpu *data = per_cpu_ptr(tr->data, cpu);
-	struct trace_array_cpu *max_data;
+	struct trace_buffer *trace_buf = &tr->trace_buffer;
+	struct trace_buffer *max_buf = &tr->max_buffer;
+	struct trace_array_cpu *data = per_cpu_ptr(trace_buf->data, cpu);
+	struct trace_array_cpu *max_data = per_cpu_ptr(max_buf->data, cpu);
 
-	max_tr.cpu = cpu;
-	max_tr.time_start = data->preempt_timestamp;
+	max_buf->cpu = cpu;
+	max_buf->time_start = data->preempt_timestamp;
 
-	max_data = per_cpu_ptr(max_tr.data, cpu);
 	max_data->saved_latency = tracing_max_latency;
 	max_data->critical_start = data->critical_start;
 	max_data->critical_end = data->critical_end;
@@ -671,7 +660,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 void
 update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
-	struct ring_buffer *buf = tr->buffer;
+	struct ring_buffer *buf = tr->trace_buffer.buffer;
 
 	if (tr->stop_count)
 		return;
@@ -686,8 +675,8 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 
 	arch_spin_lock(&ftrace_max_lock);
 
-	tr->buffer = max_tr.buffer;
-	max_tr.buffer = buf;
+	tr->trace_buffer.buffer = tr->max_buffer.buffer;
+	tr->max_buffer.buffer = buf;
 
 	__update_max_tr(tr, tsk, cpu);
 	arch_spin_unlock(&ftrace_max_lock);
@@ -715,7 +704,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 
 	arch_spin_lock(&ftrace_max_lock);
 
-	ret = ring_buffer_swap_cpu(max_tr.buffer, tr->buffer, cpu);
+	ret = ring_buffer_swap_cpu(tr->max_buffer.buffer, tr->trace_buffer.buffer, cpu);
 
 	if (ret == -EBUSY) {
 		/*
@@ -724,7 +713,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 		 * the max trace buffer (no one writes directly to it)
 		 * and flag that it failed.
 		 */
-		trace_array_printk(&max_tr, _THIS_IP_,
+		trace_array_printk_buf(tr->max_buffer.buffer, _THIS_IP_,
 			"Failed to swap buffers due to commit in progress\n");
 	}
 
@@ -741,7 +730,7 @@ static void default_wait_pipe(struct trace_iterator *iter)
 	if (trace_buffer_iter(iter, iter->cpu_file))
 		return;
 
-	ring_buffer_wait(iter->tr->buffer, iter->cpu_file);
+	ring_buffer_wait(iter->trace_buffer->buffer, iter->cpu_file);
 }
 
 /**
@@ -802,17 +791,19 @@ int register_tracer(struct tracer *type)
 		 * internal tracing to verify that everything is in order.
 		 * If we fail, we do not register this tracer.
 		 */
-		tracing_reset_online_cpus(tr);
+		tracing_reset_online_cpus(&tr->trace_buffer);
 
 		tr->current_trace = type;
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 		if (type->use_max_tr) {
 			/* If we expanded the buffers, make sure the max is expanded too */
 			if (ring_buffer_expanded)
-				ring_buffer_resize(max_tr.buffer, trace_buf_size,
+				ring_buffer_resize(tr->max_buffer.buffer, trace_buf_size,
 						   RING_BUFFER_ALL_CPUS);
 			type->allocated_snapshot = true;
 		}
+#endif
 
 		/* the test is responsible for initializing and enabling */
 		pr_info("Testing tracer %s: ", type->name);
@@ -826,16 +817,18 @@ int register_tracer(struct tracer *type)
 			goto out;
 		}
 		/* Only reset on passing, to avoid touching corrupted buffers */
-		tracing_reset_online_cpus(tr);
+		tracing_reset_online_cpus(&tr->trace_buffer);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 		if (type->use_max_tr) {
 			type->allocated_snapshot = false;
 
 			/* Shrink the max buffer again */
 			if (ring_buffer_expanded)
-				ring_buffer_resize(max_tr.buffer, 1,
+				ring_buffer_resize(tr->max_buffer.buffer, 1,
 						   RING_BUFFER_ALL_CPUS);
 		}
+#endif
 
 		printk(KERN_CONT "PASSED\n");
 	}
@@ -869,9 +862,9 @@ int register_tracer(struct tracer *type)
 	return ret;
 }
 
-void tracing_reset(struct trace_array *tr, int cpu)
+void tracing_reset(struct trace_buffer *buf, int cpu)
 {
-	struct ring_buffer *buffer = tr->buffer;
+	struct ring_buffer *buffer = buf->buffer;
 
 	if (!buffer)
 		return;
@@ -885,9 +878,9 @@ void tracing_reset(struct trace_array *tr, int cpu)
 	ring_buffer_record_enable(buffer);
 }
 
-void tracing_reset_online_cpus(struct trace_array *tr)
+void tracing_reset_online_cpus(struct trace_buffer *buf)
 {
-	struct ring_buffer *buffer = tr->buffer;
+	struct ring_buffer *buffer = buf->buffer;
 	int cpu;
 
 	if (!buffer)
@@ -898,7 +891,7 @@ void tracing_reset_online_cpus(struct trace_array *tr)
 	/* Make sure all commits have finished */
 	synchronize_sched();
 
-	tr->time_start = ftrace_now(tr->cpu);
+	buf->time_start = ftrace_now(buf->cpu);
 
 	for_each_online_cpu(cpu)
 		ring_buffer_reset_cpu(buffer, cpu);
@@ -908,7 +901,7 @@ void tracing_reset_online_cpus(struct trace_array *tr)
 
 void tracing_reset_current(int cpu)
 {
-	tracing_reset(&global_trace, cpu);
+	tracing_reset(&global_trace.trace_buffer, cpu);
 }
 
 void tracing_reset_all_online_cpus(void)
@@ -917,7 +910,10 @@ void tracing_reset_all_online_cpus(void)
 
 	mutex_lock(&trace_types_lock);
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
-		tracing_reset_online_cpus(tr);
+		tracing_reset_online_cpus(&tr->trace_buffer);
+#ifdef CONFIG_TRACER_MAX_TRACE
+		tracing_reset_online_cpus(&tr->max_buffer);
+#endif
 	}
 	mutex_unlock(&trace_types_lock);
 }
@@ -987,13 +983,15 @@ void tracing_start(void)
 	/* Prevent the buffers from switching */
 	arch_spin_lock(&ftrace_max_lock);
 
-	buffer = global_trace.buffer;
+	buffer = global_trace.trace_buffer.buffer;
 	if (buffer)
 		ring_buffer_record_enable(buffer);
 
-	buffer = max_tr.buffer;
+#ifdef CONFIG_TRACER_MAX_TRACE
+	buffer = global_trace.max_buffer.buffer;
 	if (buffer)
 		ring_buffer_record_enable(buffer);
+#endif
 
 	arch_spin_unlock(&ftrace_max_lock);
 
@@ -1025,7 +1023,7 @@ static void tracing_start_tr(struct trace_array *tr)
 		goto out;
 	}
 
-	buffer = tr->buffer;
+	buffer = tr->trace_buffer.buffer;
 	if (buffer)
 		ring_buffer_record_enable(buffer);
 
@@ -1052,13 +1050,15 @@ void tracing_stop(void)
 	/* Prevent the buffers from switching */
 	arch_spin_lock(&ftrace_max_lock);
 
-	buffer = global_trace.buffer;
+	buffer = global_trace.trace_buffer.buffer;
 	if (buffer)
 		ring_buffer_record_disable(buffer);
 
-	buffer = max_tr.buffer;
+#ifdef CONFIG_TRACER_MAX_TRACE
+	buffer = global_trace.max_buffer.buffer;
 	if (buffer)
 		ring_buffer_record_disable(buffer);
+#endif
 
 	arch_spin_unlock(&ftrace_max_lock);
 
@@ -1079,7 +1079,7 @@ static void tracing_stop_tr(struct trace_array *tr)
 	if (tr->stop_count++)
 		goto out;
 
-	buffer = tr->buffer;
+	buffer = tr->trace_buffer.buffer;
 	if (buffer)
 		ring_buffer_record_disable(buffer);
 
@@ -1245,7 +1245,7 @@ trace_event_buffer_lock_reserve(struct ring_buffer **current_rb,
 			  int type, unsigned long len,
 			  unsigned long flags, int pc)
 {
-	*current_rb = ftrace_file->tr->buffer;
+	*current_rb = ftrace_file->tr->trace_buffer.buffer;
 	return trace_buffer_lock_reserve(*current_rb,
 					 type, len, flags, pc);
 }
@@ -1256,7 +1256,7 @@ trace_current_buffer_lock_reserve(struct ring_buffer **current_rb,
 				  int type, unsigned long len,
 				  unsigned long flags, int pc)
 {
-	*current_rb = global_trace.buffer;
+	*current_rb = global_trace.trace_buffer.buffer;
 	return trace_buffer_lock_reserve(*current_rb,
 					 type, len, flags, pc);
 }
@@ -1295,7 +1295,7 @@ trace_function(struct trace_array *tr,
 	       int pc)
 {
 	struct ftrace_event_call *call = &event_function;
-	struct ring_buffer *buffer = tr->buffer;
+	struct ring_buffer *buffer = tr->trace_buffer.buffer;
 	struct ring_buffer_event *event;
 	struct ftrace_entry *entry;
 
@@ -1436,7 +1436,7 @@ void ftrace_trace_stack(struct ring_buffer *buffer, unsigned long flags,
 void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
 		   int pc)
 {
-	__ftrace_trace_stack(tr->buffer, flags, skip, pc, NULL);
+	__ftrace_trace_stack(tr->trace_buffer.buffer, flags, skip, pc, NULL);
 }
 
 /**
@@ -1452,7 +1452,8 @@ void trace_dump_stack(void)
 	local_save_flags(flags);
 
 	/* skipping 3 traces, seems to get us at the caller of this function */
-	__ftrace_trace_stack(global_trace.buffer, flags, 3, preempt_count(), NULL);
+	__ftrace_trace_stack(global_trace.trace_buffer.buffer, flags, 3,
+			     preempt_count(), NULL);
 }
 
 static DEFINE_PER_CPU(int, user_stack_count);
@@ -1622,7 +1623,7 @@ void trace_printk_init_buffers(void)
 	 * directly here. If the global_trace.buffer is already
 	 * allocated here, then this was called by module code.
 	 */
-	if (global_trace.buffer)
+	if (global_trace.trace_buffer.buffer)
 		tracing_start_cmdline_record();
 }
 
@@ -1682,7 +1683,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 
 	local_save_flags(flags);
 	size = sizeof(*entry) + sizeof(u32) * len;
-	buffer = tr->buffer;
+	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_BPRINT, size,
 					  flags, pc);
 	if (!event)
@@ -1705,27 +1706,12 @@ out:
 }
 EXPORT_SYMBOL_GPL(trace_vbprintk);
 
-int trace_array_printk(struct trace_array *tr,
-		       unsigned long ip, const char *fmt, ...)
-{
-	int ret;
-	va_list ap;
-
-	if (!(trace_flags & TRACE_ITER_PRINTK))
-		return 0;
-
-	va_start(ap, fmt);
-	ret = trace_array_vprintk(tr, ip, fmt, ap);
-	va_end(ap);
-	return ret;
-}
-
-int trace_array_vprintk(struct trace_array *tr,
-			unsigned long ip, const char *fmt, va_list args)
+static int
+__trace_array_vprintk(struct ring_buffer *buffer,
+		      unsigned long ip, const char *fmt, va_list args)
 {
 	struct ftrace_event_call *call = &event_print;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
 	int len = 0, size, pc;
 	struct print_entry *entry;
 	unsigned long flags;
@@ -1753,7 +1739,6 @@ int trace_array_vprintk(struct trace_array *tr,
 
 	local_save_flags(flags);
 	size = sizeof(*entry) + len + 1;
-	buffer = tr->buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
 					  flags, pc);
 	if (!event)
@@ -1774,6 +1759,42 @@ int trace_array_vprintk(struct trace_array *tr,
 	return len;
 }
 
+int trace_array_vprintk(struct trace_array *tr,
+			unsigned long ip, const char *fmt, va_list args)
+{
+	return __trace_array_vprintk(tr->trace_buffer.buffer, ip, fmt, args);
+}
+
+int trace_array_printk(struct trace_array *tr,
+		       unsigned long ip, const char *fmt, ...)
+{
+	int ret;
+	va_list ap;
+
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
+	va_start(ap, fmt);
+	ret = trace_array_vprintk(tr, ip, fmt, ap);
+	va_end(ap);
+	return ret;
+}
+
+int trace_array_printk_buf(struct ring_buffer *buffer,
+			   unsigned long ip, const char *fmt, ...)
+{
+	int ret;
+	va_list ap;
+
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
+	va_start(ap, fmt);
+	ret = __trace_array_vprintk(buffer, ip, fmt, ap);
+	va_end(ap);
+	return ret;
+}
+
 int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 {
 	return trace_array_vprintk(&global_trace, ip, fmt, args);
@@ -1799,7 +1820,7 @@ peek_next_entry(struct trace_iterator *iter, int cpu, u64 *ts,
 	if (buf_iter)
 		event = ring_buffer_iter_peek(buf_iter, ts);
 	else
-		event = ring_buffer_peek(iter->tr->buffer, cpu, ts,
+		event = ring_buffer_peek(iter->trace_buffer->buffer, cpu, ts,
 					 lost_events);
 
 	if (event) {
@@ -1814,7 +1835,7 @@ static struct trace_entry *
 __find_next_entry(struct trace_iterator *iter, int *ent_cpu,
 		  unsigned long *missing_events, u64 *ent_ts)
 {
-	struct ring_buffer *buffer = iter->tr->buffer;
+	struct ring_buffer *buffer = iter->trace_buffer->buffer;
 	struct trace_entry *ent, *next = NULL;
 	unsigned long lost_events = 0, next_lost = 0;
 	int cpu_file = iter->cpu_file;
@@ -1891,7 +1912,7 @@ void *trace_find_next_entry_inc(struct trace_iterator *iter)
 
 static void trace_consume(struct trace_iterator *iter)
 {
-	ring_buffer_consume(iter->tr->buffer, iter->cpu, &iter->ts,
+	ring_buffer_consume(iter->trace_buffer->buffer, iter->cpu, &iter->ts,
 			    &iter->lost_events);
 }
 
@@ -1924,13 +1945,12 @@ static void *s_next(struct seq_file *m, void *v, loff_t *pos)
 
 void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 {
-	struct trace_array *tr = iter->tr;
 	struct ring_buffer_event *event;
 	struct ring_buffer_iter *buf_iter;
 	unsigned long entries = 0;
 	u64 ts;
 
-	per_cpu_ptr(tr->data, cpu)->skipped_entries = 0;
+	per_cpu_ptr(iter->trace_buffer->data, cpu)->skipped_entries = 0;
 
 	buf_iter = trace_buffer_iter(iter, cpu);
 	if (!buf_iter)
@@ -1944,13 +1964,13 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 	 * by the timestamp being before the start of the buffer.
 	 */
 	while ((event = ring_buffer_iter_peek(buf_iter, &ts))) {
-		if (ts >= iter->tr->time_start)
+		if (ts >= iter->trace_buffer->time_start)
 			break;
 		entries++;
 		ring_buffer_read(buf_iter, NULL);
 	}
 
-	per_cpu_ptr(tr->data, cpu)->skipped_entries = entries;
+	per_cpu_ptr(iter->trace_buffer->data, cpu)->skipped_entries = entries;
 }
 
 /*
@@ -1977,8 +1997,10 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 		*iter->trace = *tr->current_trace;
 	mutex_unlock(&trace_types_lock);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 	if (iter->snapshot && iter->trace->use_max_tr)
 		return ERR_PTR(-EBUSY);
+#endif
 
 	if (!iter->snapshot)
 		atomic_inc(&trace_record_cmdline_disabled);
@@ -2020,17 +2042,21 @@ static void s_stop(struct seq_file *m, void *p)
 {
 	struct trace_iterator *iter = m->private;
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 	if (iter->snapshot && iter->trace->use_max_tr)
 		return;
+#endif
 
 	if (!iter->snapshot)
 		atomic_dec(&trace_record_cmdline_disabled);
+
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 }
 
 static void
-get_total_entries(struct trace_array *tr, unsigned long *total, unsigned long *entries)
+get_total_entries(struct trace_buffer *buf,
+		  unsigned long *total, unsigned long *entries)
 {
 	unsigned long count;
 	int cpu;
@@ -2039,19 +2065,19 @@ get_total_entries(struct trace_array *tr, unsigned long *total, unsigned long *e
 	*entries = 0;
 
 	for_each_tracing_cpu(cpu) {
-		count = ring_buffer_entries_cpu(tr->buffer, cpu);
+		count = ring_buffer_entries_cpu(buf->buffer, cpu);
 		/*
 		 * If this buffer has skipped entries, then we hold all
 		 * entries for the trace and we need to ignore the
 		 * ones before the time stamp.
 		 */
-		if (per_cpu_ptr(tr->data, cpu)->skipped_entries) {
-			count -= per_cpu_ptr(tr->data, cpu)->skipped_entries;
+		if (per_cpu_ptr(buf->data, cpu)->skipped_entries) {
+			count -= per_cpu_ptr(buf->data, cpu)->skipped_entries;
 			/* total is the same as the entries */
 			*total += count;
 		} else
 			*total += count +
-				ring_buffer_overrun_cpu(tr->buffer, cpu);
+				ring_buffer_overrun_cpu(buf->buffer, cpu);
 		*entries += count;
 	}
 }
@@ -2068,27 +2094,27 @@ static void print_lat_help_header(struct seq_file *m)
 	seq_puts(m, "#     \\   /      |||||  \\    |   /           \n");
 }
 
-static void print_event_info(struct trace_array *tr, struct seq_file *m)
+static void print_event_info(struct trace_buffer *buf, struct seq_file *m)
 {
 	unsigned long total;
 	unsigned long entries;
 
-	get_total_entries(tr, &total, &entries);
+	get_total_entries(buf, &total, &entries);
 	seq_printf(m, "# entries-in-buffer/entries-written: %lu/%lu   #P:%d\n",
 		   entries, total, num_online_cpus());
 	seq_puts(m, "#\n");
 }
 
-static void print_func_help_header(struct trace_array *tr, struct seq_file *m)
+static void print_func_help_header(struct trace_buffer *buf, struct seq_file *m)
 {
-	print_event_info(tr, m);
+	print_event_info(buf, m);
 	seq_puts(m, "#           TASK-PID   CPU#      TIMESTAMP  FUNCTION\n");
 	seq_puts(m, "#              | |       |          |         |\n");
 }
 
-static void print_func_help_header_irq(struct trace_array *tr, struct seq_file *m)
+static void print_func_help_header_irq(struct trace_buffer *buf, struct seq_file *m)
 {
-	print_event_info(tr, m);
+	print_event_info(buf, m);
 	seq_puts(m, "#                              _-----=> irqs-off\n");
 	seq_puts(m, "#                             / _----=> need-resched\n");
 	seq_puts(m, "#                            | / _---=> hardirq/softirq\n");
@@ -2102,8 +2128,8 @@ void
 print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 {
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
-	struct trace_array *tr = iter->tr;
-	struct trace_array_cpu *data = per_cpu_ptr(tr->data, tr->cpu);
+	struct trace_buffer *buf = iter->trace_buffer;
+	struct trace_array_cpu *data = per_cpu_ptr(buf->data, buf->cpu);
 	struct tracer *type = iter->trace;
 	unsigned long entries;
 	unsigned long total;
@@ -2111,7 +2137,7 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 
 	name = type->name;
 
-	get_total_entries(tr, &total, &entries);
+	get_total_entries(buf, &total, &entries);
 
 	seq_printf(m, "# %s latency trace v1.1.5 on %s\n",
 		   name, UTS_RELEASE);
@@ -2122,7 +2148,7 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 		   nsecs_to_usecs(data->saved_latency),
 		   entries,
 		   total,
-		   tr->cpu,
+		   buf->cpu,
 #if defined(CONFIG_PREEMPT_NONE)
 		   "server",
 #elif defined(CONFIG_PREEMPT_VOLUNTARY)
@@ -2173,7 +2199,7 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
 	if (cpumask_test_cpu(iter->cpu, iter->started))
 		return;
 
-	if (per_cpu_ptr(iter->tr->data, iter->cpu)->skipped_entries)
+	if (per_cpu_ptr(iter->trace_buffer->data, iter->cpu)->skipped_entries)
 		return;
 
 	cpumask_set_cpu(iter->cpu, iter->started);
@@ -2303,7 +2329,7 @@ int trace_empty(struct trace_iterator *iter)
 			if (!ring_buffer_iter_empty(buf_iter))
 				return 0;
 		} else {
-			if (!ring_buffer_empty_cpu(iter->tr->buffer, cpu))
+			if (!ring_buffer_empty_cpu(iter->trace_buffer->buffer, cpu))
 				return 0;
 		}
 		return 1;
@@ -2315,7 +2341,7 @@ int trace_empty(struct trace_iterator *iter)
 			if (!ring_buffer_iter_empty(buf_iter))
 				return 0;
 		} else {
-			if (!ring_buffer_empty_cpu(iter->tr->buffer, cpu))
+			if (!ring_buffer_empty_cpu(iter->trace_buffer->buffer, cpu))
 				return 0;
 		}
 	}
@@ -2393,9 +2419,9 @@ void trace_default_header(struct seq_file *m)
 	} else {
 		if (!(trace_flags & TRACE_ITER_VERBOSE)) {
 			if (trace_flags & TRACE_ITER_IRQ_INFO)
-				print_func_help_header_irq(iter->tr, m);
+				print_func_help_header_irq(iter->trace_buffer, m);
 			else
-				print_func_help_header(iter->tr, m);
+				print_func_help_header(iter->trace_buffer, m);
 		}
 	}
 }
@@ -2514,11 +2540,15 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 	if (!zalloc_cpumask_var(&iter->started, GFP_KERNEL))
 		goto fail;
 
+	iter->tr = tr;
+
+#ifdef CONFIG_TRACER_MAX_TRACE
 	/* Currently only the top directory has a snapshot */
 	if (tr->current_trace->print_max || snapshot)
-		iter->tr = &max_tr;
+		iter->trace_buffer = &tr->max_buffer;
 	else
-		iter->tr = tr;
+#endif
+		iter->trace_buffer = &tr->trace_buffer;
 	iter->snapshot = snapshot;
 	iter->pos = -1;
 	mutex_init(&iter->mutex);
@@ -2529,7 +2559,7 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 		iter->trace->open(iter);
 
 	/* Annotate start of buffers if we had overruns */
-	if (ring_buffer_overruns(iter->tr->buffer))
+	if (ring_buffer_overruns(iter->trace_buffer->buffer))
 		iter->iter_flags |= TRACE_FILE_ANNOTATE;
 
 	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
@@ -2543,7 +2573,7 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 	if (iter->cpu_file == RING_BUFFER_ALL_CPUS) {
 		for_each_tracing_cpu(cpu) {
 			iter->buffer_iter[cpu] =
-				ring_buffer_read_prepare(iter->tr->buffer, cpu);
+				ring_buffer_read_prepare(iter->trace_buffer->buffer, cpu);
 		}
 		ring_buffer_read_prepare_sync();
 		for_each_tracing_cpu(cpu) {
@@ -2553,7 +2583,7 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 	} else {
 		cpu = iter->cpu_file;
 		iter->buffer_iter[cpu] =
-			ring_buffer_read_prepare(iter->tr->buffer, cpu);
+			ring_buffer_read_prepare(iter->trace_buffer->buffer, cpu);
 		ring_buffer_read_prepare_sync();
 		ring_buffer_read_start(iter->buffer_iter[cpu]);
 		tracing_iter_reset(iter, cpu);
@@ -2592,12 +2622,7 @@ static int tracing_release(struct inode *inode, struct file *file)
 		return 0;
 
 	iter = m->private;
-
-	/* Only the global tracer has a matching max_tr */
-	if (iter->tr == &max_tr)
-		tr = &global_trace;
-	else
-		tr = iter->tr;
+	tr = iter->tr;
 
 	mutex_lock(&trace_types_lock);
 	for_each_tracing_cpu(cpu) {
@@ -2633,9 +2658,9 @@ static int tracing_open(struct inode *inode, struct file *file)
 		struct trace_array *tr = tc->tr;
 
 		if (tc->cpu == RING_BUFFER_ALL_CPUS)
-			tracing_reset_online_cpus(tr);
+			tracing_reset_online_cpus(&tr->trace_buffer);
 		else
-			tracing_reset(tr, tc->cpu);
+			tracing_reset(&tr->trace_buffer, tc->cpu);
 	}
 
 	if (file->f_mode & FMODE_READ) {
@@ -2804,13 +2829,13 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 		 */
 		if (cpumask_test_cpu(cpu, tracing_cpumask) &&
 				!cpumask_test_cpu(cpu, tracing_cpumask_new)) {
-			atomic_inc(&per_cpu_ptr(tr->data, cpu)->disabled);
-			ring_buffer_record_disable_cpu(tr->buffer, cpu);
+			atomic_inc(&per_cpu_ptr(tr->trace_buffer.data, cpu)->disabled);
+			ring_buffer_record_disable_cpu(tr->trace_buffer.buffer, cpu);
 		}
 		if (!cpumask_test_cpu(cpu, tracing_cpumask) &&
 				cpumask_test_cpu(cpu, tracing_cpumask_new)) {
-			atomic_dec(&per_cpu_ptr(tr->data, cpu)->disabled);
-			ring_buffer_record_enable_cpu(tr->buffer, cpu);
+			atomic_dec(&per_cpu_ptr(tr->trace_buffer.data, cpu)->disabled);
+			ring_buffer_record_enable_cpu(tr->trace_buffer.buffer, cpu);
 		}
 	}
 	arch_spin_unlock(&ftrace_max_lock);
@@ -2915,7 +2940,7 @@ static void set_tracer_flags(unsigned int mask, int enabled)
 		trace_event_enable_cmd_record(enabled);
 
 	if (mask == TRACE_ITER_OVERWRITE)
-		ring_buffer_change_overwrite(global_trace.buffer, enabled);
+		ring_buffer_change_overwrite(global_trace.trace_buffer.buffer, enabled);
 
 	if (mask == TRACE_ITER_PRINTK)
 		trace_printk_start_stop_comm(enabled);
@@ -3091,42 +3116,44 @@ tracing_set_trace_read(struct file *filp, char __user *ubuf,
 
 int tracer_init(struct tracer *t, struct trace_array *tr)
 {
-	tracing_reset_online_cpus(tr);
+	tracing_reset_online_cpus(&tr->trace_buffer);
 	return t->init(tr);
 }
 
-static void set_buffer_entries(struct trace_array *tr, unsigned long val)
+static void set_buffer_entries(struct trace_buffer *buf, unsigned long val)
 {
 	int cpu;
 	for_each_tracing_cpu(cpu)
-		per_cpu_ptr(tr->data, cpu)->entries = val;
+		per_cpu_ptr(buf->data, cpu)->entries = val;
 }
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 /* resize @tr's buffer to the size of @size_tr's entries */
-static int resize_buffer_duplicate_size(struct trace_array *tr,
-					struct trace_array *size_tr, int cpu_id)
+static int resize_buffer_duplicate_size(struct trace_buffer *trace_buf,
+					struct trace_buffer *size_buf, int cpu_id)
 {
 	int cpu, ret = 0;
 
 	if (cpu_id == RING_BUFFER_ALL_CPUS) {
 		for_each_tracing_cpu(cpu) {
-			ret = ring_buffer_resize(tr->buffer,
-				 per_cpu_ptr(size_tr->data, cpu)->entries, cpu);
+			ret = ring_buffer_resize(trace_buf->buffer,
+				 per_cpu_ptr(size_buf->data, cpu)->entries, cpu);
 			if (ret < 0)
 				break;
-			per_cpu_ptr(tr->data, cpu)->entries =
-				per_cpu_ptr(size_tr->data, cpu)->entries;
+			per_cpu_ptr(trace_buf->data, cpu)->entries =
+				per_cpu_ptr(size_buf->data, cpu)->entries;
 		}
 	} else {
-		ret = ring_buffer_resize(tr->buffer,
-				 per_cpu_ptr(size_tr->data, cpu_id)->entries, cpu_id);
+		ret = ring_buffer_resize(trace_buf->buffer,
+				 per_cpu_ptr(size_buf->data, cpu_id)->entries, cpu_id);
 		if (ret == 0)
-			per_cpu_ptr(tr->data, cpu_id)->entries =
-				per_cpu_ptr(size_tr->data, cpu_id)->entries;
+			per_cpu_ptr(trace_buf->data, cpu_id)->entries =
+				per_cpu_ptr(size_buf->data, cpu_id)->entries;
 	}
 
 	return ret;
 }
+#endif /* CONFIG_TRACER_MAX_TRACE */
 
 static int __tracing_resize_ring_buffer(struct trace_array *tr,
 					unsigned long size, int cpu)
@@ -3141,20 +3168,22 @@ static int __tracing_resize_ring_buffer(struct trace_array *tr,
 	ring_buffer_expanded = 1;
 
 	/* May be called before buffers are initialized */
-	if (!tr->buffer)
+	if (!tr->trace_buffer.buffer)
 		return 0;
 
-	ret = ring_buffer_resize(tr->buffer, size, cpu);
+	ret = ring_buffer_resize(tr->trace_buffer.buffer, size, cpu);
 	if (ret < 0)
 		return ret;
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 	if (!(tr->flags & TRACE_ARRAY_FL_GLOBAL) ||
 	    !tr->current_trace->use_max_tr)
 		goto out;
 
-	ret = ring_buffer_resize(max_tr.buffer, size, cpu);
+	ret = ring_buffer_resize(tr->max_buffer.buffer, size, cpu);
 	if (ret < 0) {
-		int r = resize_buffer_duplicate_size(tr, tr, cpu);
+		int r = resize_buffer_duplicate_size(&tr->trace_buffer,
+						     &tr->trace_buffer, cpu);
 		if (r < 0) {
 			/*
 			 * AARGH! We are left with different
@@ -3177,15 +3206,17 @@ static int __tracing_resize_ring_buffer(struct trace_array *tr,
 	}
 
 	if (cpu == RING_BUFFER_ALL_CPUS)
-		set_buffer_entries(&max_tr, size);
+		set_buffer_entries(&tr->max_buffer, size);
 	else
-		per_cpu_ptr(max_tr.data, cpu)->entries = size;
+		per_cpu_ptr(tr->max_buffer.data, cpu)->entries = size;
 
  out:
+#endif /* CONFIG_TRACER_MAX_TRACE */
+
 	if (cpu == RING_BUFFER_ALL_CPUS)
-		set_buffer_entries(tr, size);
+		set_buffer_entries(&tr->trace_buffer, size);
 	else
-		per_cpu_ptr(tr->data, cpu)->entries = size;
+		per_cpu_ptr(tr->trace_buffer.data, cpu)->entries = size;
 
 	return ret;
 }
@@ -3252,7 +3283,9 @@ static int tracing_set_tracer(const char *buf)
 	static struct trace_option_dentry *topts;
 	struct trace_array *tr = &global_trace;
 	struct tracer *t;
+#ifdef CONFIG_TRACER_MAX_TRACE
 	bool had_max_tr;
+#endif
 	int ret = 0;
 
 	mutex_lock(&trace_types_lock);
@@ -3280,7 +3313,10 @@ static int tracing_set_tracer(const char *buf)
 	if (tr->current_trace->reset)
 		tr->current_trace->reset(tr);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 	had_max_tr = tr->current_trace->allocated_snapshot;
+
+	/* Current trace needs to be nop_trace before synchronize_sched */
 	tr->current_trace = &nop_trace;
 
 	if (had_max_tr && !t->use_max_tr) {
@@ -3297,22 +3333,28 @@ static int tracing_set_tracer(const char *buf)
 		 * The max_tr ring buffer has some state (e.g. ring->clock) and
 		 * we want preserve it.
 		 */
-		ring_buffer_resize(max_tr.buffer, 1, RING_BUFFER_ALL_CPUS);
-		set_buffer_entries(&max_tr, 1);
-		tracing_reset_online_cpus(&max_tr);
+		ring_buffer_resize(tr->max_buffer.buffer, 1, RING_BUFFER_ALL_CPUS);
+		set_buffer_entries(&tr->max_buffer, 1);
+		tracing_reset_online_cpus(&tr->max_buffer);
 		tr->current_trace->allocated_snapshot = false;
 	}
+#else
+	tr->current_trace = &nop_trace;
+#endif
 	destroy_trace_option_files(topts);
 
 	topts = create_trace_option_files(tr, t);
+
+#ifdef CONFIG_TRACER_MAX_TRACE
 	if (t->use_max_tr && !had_max_tr) {
 		/* we need to make per cpu buffer sizes equivalent */
-		ret = resize_buffer_duplicate_size(&max_tr, &global_trace,
+		ret = resize_buffer_duplicate_size(&tr->max_buffer, &tr->trace_buffer,
 						   RING_BUFFER_ALL_CPUS);
 		if (ret < 0)
 			goto out;
 		t->allocated_snapshot = true;
 	}
+#endif
 
 	if (t->init) {
 		ret = tracer_init(t, tr);
@@ -3439,6 +3481,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 
 	iter->cpu_file = tc->cpu;
 	iter->tr = tc->tr;
+	iter->trace_buffer = &tc->tr->trace_buffer;
 	mutex_init(&iter->mutex);
 	filp->private_data = iter;
 
@@ -3489,7 +3532,7 @@ trace_poll(struct trace_iterator *iter, struct file *filp, poll_table *poll_tabl
 		 */
 		return POLLIN | POLLRDNORM;
 	else
-		return ring_buffer_poll_wait(iter->tr->buffer, iter->cpu_file,
+		return ring_buffer_poll_wait(iter->trace_buffer->buffer, iter->cpu_file,
 					     filp, poll_table);
 }
 
@@ -3828,8 +3871,8 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
 		for_each_tracing_cpu(cpu) {
 			/* fill in the size from first enabled cpu */
 			if (size == 0)
-				size = per_cpu_ptr(tr->data, cpu)->entries;
-			if (size != per_cpu_ptr(tr->data, cpu)->entries) {
+				size = per_cpu_ptr(tr->trace_buffer.data, cpu)->entries;
+			if (size != per_cpu_ptr(tr->trace_buffer.data, cpu)->entries) {
 				buf_size_same = 0;
 				break;
 			}
@@ -3845,7 +3888,7 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
 		} else
 			r = sprintf(buf, "X\n");
 	} else
-		r = sprintf(buf, "%lu\n", per_cpu_ptr(tr->data, tc->cpu)->entries >> 10);
+		r = sprintf(buf, "%lu\n", per_cpu_ptr(tr->trace_buffer.data, tc->cpu)->entries >> 10);
 
 	mutex_unlock(&trace_types_lock);
 
@@ -3892,7 +3935,7 @@ tracing_total_entries_read(struct file *filp, char __user *ubuf,
 
 	mutex_lock(&trace_types_lock);
 	for_each_tracing_cpu(cpu) {
-		size += per_cpu_ptr(tr->data, cpu)->entries >> 10;
+		size += per_cpu_ptr(tr->trace_buffer.data, cpu)->entries >> 10;
 		if (!ring_buffer_expanded)
 			expanded_size += trace_buf_size >> 10;
 	}
@@ -3997,7 +4040,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 
 	local_save_flags(irq_flags);
 	size = sizeof(*entry) + cnt + 2; /* possible \n added */
-	buffer = global_trace.buffer;
+	buffer = global_trace.trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
 					  irq_flags, preempt_count());
 	if (!event) {
@@ -4082,16 +4125,19 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 
 	tr->clock_id = i;
 
-	ring_buffer_set_clock(tr->buffer, trace_clocks[i].func);
-	if (tr->flags & TRACE_ARRAY_FL_GLOBAL && max_tr.buffer)
-		ring_buffer_set_clock(max_tr.buffer, trace_clocks[i].func);
+	ring_buffer_set_clock(tr->trace_buffer.buffer, trace_clocks[i].func);
 
 	/*
 	 * New clock may not be consistent with the previous clock.
 	 * Reset the buffer so that it doesn't have incomparable timestamps.
 	 */
-	tracing_reset_online_cpus(&global_trace);
-	tracing_reset_online_cpus(&max_tr);
+	tracing_reset_online_cpus(&global_trace.trace_buffer);
+
+#ifdef CONFIG_TRACER_MAX_TRACE
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL && tr->max_buffer.buffer)
+		ring_buffer_set_clock(tr->max_buffer.buffer, trace_clocks[i].func);
+	tracing_reset_online_cpus(&global_trace.max_buffer);
+#endif
 
 	mutex_unlock(&trace_types_lock);
 
@@ -4131,6 +4177,7 @@ static int tracing_snapshot_open(struct inode *inode, struct file *file)
 			return -ENOMEM;
 		}
 		iter->tr = tc->tr;
+		iter->trace_buffer = &tc->tr->max_buffer;
 		m->private = iter;
 		file->private_data = m;
 	}
@@ -4167,18 +4214,18 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	case 0:
 		if (tr->current_trace->allocated_snapshot) {
 			/* free spare buffer */
-			ring_buffer_resize(max_tr.buffer, 1,
+			ring_buffer_resize(tr->max_buffer.buffer, 1,
 					   RING_BUFFER_ALL_CPUS);
-			set_buffer_entries(&max_tr, 1);
-			tracing_reset_online_cpus(&max_tr);
+			set_buffer_entries(&tr->max_buffer, 1);
+			tracing_reset_online_cpus(&tr->max_buffer);
 			tr->current_trace->allocated_snapshot = false;
 		}
 		break;
 	case 1:
 		if (!tr->current_trace->allocated_snapshot) {
 			/* allocate spare buffer */
-			ret = resize_buffer_duplicate_size(&max_tr,
-					&global_trace, RING_BUFFER_ALL_CPUS);
+			ret = resize_buffer_duplicate_size(&tr->max_buffer,
+					&tr->trace_buffer, RING_BUFFER_ALL_CPUS);
 			if (ret < 0)
 				break;
 			tr->current_trace->allocated_snapshot = true;
@@ -4191,7 +4238,7 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		break;
 	default:
 		if (tr->current_trace->allocated_snapshot)
-			tracing_reset_online_cpus(&max_tr);
+			tracing_reset_online_cpus(&tr->max_buffer);
 		break;
 	}
 
@@ -4309,6 +4356,7 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 	info->iter.tr		= tr;
 	info->iter.cpu_file	= tc->cpu;
 	info->iter.trace	= tr->current_trace;
+	info->iter.trace_buffer = &tr->trace_buffer;
 	info->spare		= NULL;
 	/* Force reading ring buffer for first read */
 	info->read		= (unsigned int)-1;
@@ -4340,7 +4388,8 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 		return 0;
 
 	if (!info->spare)
-		info->spare = ring_buffer_alloc_read_page(iter->tr->buffer, iter->cpu_file);
+		info->spare = ring_buffer_alloc_read_page(iter->trace_buffer->buffer,
+							  iter->cpu_file);
 	if (!info->spare)
 		return -ENOMEM;
 
@@ -4350,7 +4399,7 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 
  again:
 	trace_access_lock(iter->cpu_file);
-	ret = ring_buffer_read_page(iter->tr->buffer,
+	ret = ring_buffer_read_page(iter->trace_buffer->buffer,
 				    &info->spare,
 				    count,
 				    iter->cpu_file, 0);
@@ -4392,7 +4441,7 @@ static int tracing_buffers_release(struct inode *inode, struct file *file)
 	struct trace_iterator *iter = &info->iter;
 
 	if (info->spare)
-		ring_buffer_free_read_page(iter->tr->buffer, info->spare);
+		ring_buffer_free_read_page(iter->trace_buffer->buffer, info->spare);
 	kfree(info);
 
 	return 0;
@@ -4492,7 +4541,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 
  again:
 	trace_access_lock(iter->cpu_file);
-	entries = ring_buffer_entries_cpu(iter->tr->buffer, iter->cpu_file);
+	entries = ring_buffer_entries_cpu(iter->trace_buffer->buffer, iter->cpu_file);
 
 	for (i = 0; i < pipe->buffers && len && entries; i++, len -= PAGE_SIZE) {
 		struct page *page;
@@ -4503,7 +4552,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 			break;
 
 		ref->ref = 1;
-		ref->buffer = iter->tr->buffer;
+		ref->buffer = iter->trace_buffer->buffer;
 		ref->page = ring_buffer_alloc_read_page(ref->buffer, iter->cpu_file);
 		if (!ref->page) {
 			kfree(ref);
@@ -4535,7 +4584,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		spd.nr_pages++;
 		*ppos += PAGE_SIZE;
 
-		entries = ring_buffer_entries_cpu(iter->tr->buffer, iter->cpu_file);
+		entries = ring_buffer_entries_cpu(iter->trace_buffer->buffer, iter->cpu_file);
 	}
 
 	trace_access_unlock(iter->cpu_file);
@@ -4576,6 +4625,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 {
 	struct trace_cpu *tc = filp->private_data;
 	struct trace_array *tr = tc->tr;
+	struct trace_buffer *trace_buf = &tr->trace_buffer;
 	struct trace_seq *s;
 	unsigned long cnt;
 	unsigned long long t;
@@ -4588,41 +4638,41 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 
 	trace_seq_init(s);
 
-	cnt = ring_buffer_entries_cpu(tr->buffer, cpu);
+	cnt = ring_buffer_entries_cpu(trace_buf->buffer, cpu);
 	trace_seq_printf(s, "entries: %ld\n", cnt);
 
-	cnt = ring_buffer_overrun_cpu(tr->buffer, cpu);
+	cnt = ring_buffer_overrun_cpu(trace_buf->buffer, cpu);
 	trace_seq_printf(s, "overrun: %ld\n", cnt);
 
-	cnt = ring_buffer_commit_overrun_cpu(tr->buffer, cpu);
+	cnt = ring_buffer_commit_overrun_cpu(trace_buf->buffer, cpu);
 	trace_seq_printf(s, "commit overrun: %ld\n", cnt);
 
-	cnt = ring_buffer_bytes_cpu(tr->buffer, cpu);
+	cnt = ring_buffer_bytes_cpu(trace_buf->buffer, cpu);
 	trace_seq_printf(s, "bytes: %ld\n", cnt);
 
 	if (trace_clocks[trace_clock_id].in_ns) {
 		/* local or global for trace_clock */
-		t = ns2usecs(ring_buffer_oldest_event_ts(tr->buffer, cpu));
+		t = ns2usecs(ring_buffer_oldest_event_ts(trace_buf->buffer, cpu));
 		usec_rem = do_div(t, USEC_PER_SEC);
 		trace_seq_printf(s, "oldest event ts: %5llu.%06lu\n",
 								t, usec_rem);
 
-		t = ns2usecs(ring_buffer_time_stamp(tr->buffer, cpu));
+		t = ns2usecs(ring_buffer_time_stamp(trace_buf->buffer, cpu));
 		usec_rem = do_div(t, USEC_PER_SEC);
 		trace_seq_printf(s, "now ts: %5llu.%06lu\n", t, usec_rem);
 	} else {
 		/* counter or tsc mode for trace_clock */
 		trace_seq_printf(s, "oldest event ts: %llu\n",
-				ring_buffer_oldest_event_ts(tr->buffer, cpu));
+				ring_buffer_oldest_event_ts(trace_buf->buffer, cpu));
 
 		trace_seq_printf(s, "now ts: %llu\n",
-				ring_buffer_time_stamp(tr->buffer, cpu));
+				ring_buffer_time_stamp(trace_buf->buffer, cpu));
 	}
 
-	cnt = ring_buffer_dropped_events_cpu(tr->buffer, cpu);
+	cnt = ring_buffer_dropped_events_cpu(trace_buf->buffer, cpu);
 	trace_seq_printf(s, "dropped events: %ld\n", cnt);
 
-	cnt = ring_buffer_read_events_cpu(tr->buffer, cpu);
+	cnt = ring_buffer_read_events_cpu(trace_buf->buffer, cpu);
 	trace_seq_printf(s, "read events: %ld\n", cnt);
 
 	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
@@ -4725,7 +4775,7 @@ static struct dentry *tracing_dentry_percpu(struct trace_array *tr, int cpu)
 static void
 tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 {
-	struct trace_array_cpu *data = per_cpu_ptr(tr->data, cpu);
+	struct trace_array_cpu *data = per_cpu_ptr(tr->trace_buffer.data, cpu);
 	struct dentry *d_percpu = tracing_dentry_percpu(tr, cpu);
 	struct dentry *d_cpu;
 	char cpu_dir[30]; /* 30 characters should be more than enough */
@@ -5002,7 +5052,7 @@ rb_simple_read(struct file *filp, char __user *ubuf,
 	       size_t cnt, loff_t *ppos)
 {
 	struct trace_array *tr = filp->private_data;
-	struct ring_buffer *buffer = tr->buffer;
+	struct ring_buffer *buffer = tr->trace_buffer.buffer;
 	char buf[64];
 	int r;
 
@@ -5021,7 +5071,7 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
 {
 	struct trace_array *tr = filp->private_data;
-	struct ring_buffer *buffer = tr->buffer;
+	struct ring_buffer *buffer = tr->trace_buffer.buffer;
 	unsigned long val;
 	int ret;
 
@@ -5093,18 +5143,18 @@ static int new_instance_create(const char *name)
 
 	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
 
-	tr->buffer = ring_buffer_alloc(trace_buf_size, rb_flags);
-	if (!tr->buffer)
+	tr->trace_buffer.buffer = ring_buffer_alloc(trace_buf_size, rb_flags);
+	if (!tr->trace_buffer.buffer)
 		goto out_free_tr;
 
-	tr->data = alloc_percpu(struct trace_array_cpu);
-	if (!tr->data)
+	tr->trace_buffer.data = alloc_percpu(struct trace_array_cpu);
+	if (!tr->trace_buffer.data)
 		goto out_free_tr;
 
 	for_each_tracing_cpu(i) {
-		memset(per_cpu_ptr(tr->data, i), 0, sizeof(struct trace_array_cpu));
-		per_cpu_ptr(tr->data, i)->trace_cpu.cpu = i;
-		per_cpu_ptr(tr->data, i)->trace_cpu.tr = tr;
+		memset(per_cpu_ptr(tr->trace_buffer.data, i), 0, sizeof(struct trace_array_cpu));
+		per_cpu_ptr(tr->trace_buffer.data, i)->trace_cpu.cpu = i;
+		per_cpu_ptr(tr->trace_buffer.data, i)->trace_cpu.tr = tr;
 	}
 
 	/* Holder for file callbacks */
@@ -5128,8 +5178,8 @@ static int new_instance_create(const char *name)
 	return 0;
 
  out_free_tr:
-	if (tr->buffer)
-		ring_buffer_free(tr->buffer);
+	if (tr->trace_buffer.buffer)
+		ring_buffer_free(tr->trace_buffer.buffer);
 	kfree(tr->name);
 	kfree(tr);
 
@@ -5162,8 +5212,8 @@ static int instance_delete(const char *name)
 
 	event_trace_del_tracer(tr);
 	debugfs_remove_recursive(tr->dir);
-	free_percpu(tr->data);
-	ring_buffer_free(tr->buffer);
+	free_percpu(tr->trace_buffer.data);
+	ring_buffer_free(tr->trace_buffer.buffer);
 
 	kfree(tr->name);
 	kfree(tr);
@@ -5403,6 +5453,7 @@ void trace_init_global_iter(struct trace_iterator *iter)
 	iter->tr = &global_trace;
 	iter->trace = iter->tr->current_trace;
 	iter->cpu_file = RING_BUFFER_ALL_CPUS;
+	iter->trace_buffer = &global_trace.trace_buffer;
 }
 
 static void
@@ -5440,7 +5491,7 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 	trace_init_global_iter(&iter);
 
 	for_each_tracing_cpu(cpu) {
-		atomic_inc(&per_cpu_ptr(iter.tr->data, cpu)->disabled);
+		atomic_inc(&per_cpu_ptr(iter.tr->trace_buffer.data, cpu)->disabled);
 	}
 
 	old_userobj = trace_flags & TRACE_ITER_SYM_USEROBJ;
@@ -5508,7 +5559,7 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 		trace_flags |= old_userobj;
 
 		for_each_tracing_cpu(cpu) {
-			atomic_dec(&per_cpu_ptr(iter.tr->data, cpu)->disabled);
+			atomic_dec(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
 		}
 		tracing_on();
 	}
@@ -5558,58 +5609,59 @@ __init static int tracer_alloc_buffers(void)
 	raw_spin_lock_init(&global_trace.start_lock);
 
 	/* TODO: make the number of buffers hot pluggable with CPUS */
-	global_trace.buffer = ring_buffer_alloc(ring_buf_size, rb_flags);
-	if (!global_trace.buffer) {
+	global_trace.trace_buffer.buffer = ring_buffer_alloc(ring_buf_size, rb_flags);
+	if (!global_trace.trace_buffer.buffer) {
 		printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
 		WARN_ON(1);
 		goto out_free_cpumask;
 	}
 
-	global_trace.data = alloc_percpu(struct trace_array_cpu);
+	global_trace.trace_buffer.data = alloc_percpu(struct trace_array_cpu);
 
-	if (!global_trace.data) {
+	if (!global_trace.trace_buffer.data) {
 		printk(KERN_ERR "tracer: failed to allocate percpu memory!\n");
 		WARN_ON(1);
 		goto out_free_cpumask;
 	}
 
 	for_each_tracing_cpu(i) {
-		memset(per_cpu_ptr(global_trace.data, i), 0, sizeof(struct trace_array_cpu));
-		per_cpu_ptr(global_trace.data, i)->trace_cpu.cpu = i;
-		per_cpu_ptr(global_trace.data, i)->trace_cpu.tr = &global_trace;
+		memset(per_cpu_ptr(global_trace.trace_buffer.data, i), 0,
+		       sizeof(struct trace_array_cpu));
+		per_cpu_ptr(global_trace.trace_buffer.data, i)->trace_cpu.cpu = i;
+		per_cpu_ptr(global_trace.trace_buffer.data, i)->trace_cpu.tr = &global_trace;
 	}
 
 	if (global_trace.buffer_disabled)
 		tracing_off();
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-	max_tr.data = alloc_percpu(struct trace_array_cpu);
-	if (!max_tr.data) {
+	global_trace.max_buffer.data = alloc_percpu(struct trace_array_cpu);
+	if (!global_trace.max_buffer.data) {
 		printk(KERN_ERR "tracer: failed to allocate percpu memory!\n");
 		WARN_ON(1);
 		goto out_free_cpumask;
 	}
-	max_tr.buffer = ring_buffer_alloc(1, rb_flags);
-	raw_spin_lock_init(&max_tr.start_lock);
-	if (!max_tr.buffer) {
+	global_trace.max_buffer.buffer = ring_buffer_alloc(1, rb_flags);
+	if (!global_trace.max_buffer.buffer) {
 		printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
 		WARN_ON(1);
-		ring_buffer_free(global_trace.buffer);
+		ring_buffer_free(global_trace.trace_buffer.buffer);
 		goto out_free_cpumask;
 	}
 
 	for_each_tracing_cpu(i) {
-		memset(per_cpu_ptr(max_tr.data, i), 0, sizeof(struct trace_array_cpu));
-		per_cpu_ptr(max_tr.data, i)->trace_cpu.cpu = i;
-		per_cpu_ptr(max_tr.data, i)->trace_cpu.tr = &max_tr;
+		memset(per_cpu_ptr(global_trace.max_buffer.data, i), 0,
+		       sizeof(struct trace_array_cpu));
+		per_cpu_ptr(global_trace.max_buffer.data, i)->trace_cpu.cpu = i;
+		per_cpu_ptr(global_trace.max_buffer.data, i)->trace_cpu.tr = &global_trace;
 	}
 #endif
 
 	/* Allocate the first page for all buffers */
-	set_buffer_entries(&global_trace,
-			   ring_buffer_size(global_trace.buffer, 0));
+	set_buffer_entries(&global_trace.trace_buffer,
+			   ring_buffer_size(global_trace.trace_buffer.buffer, 0));
 #ifdef CONFIG_TRACER_MAX_TRACE
-	set_buffer_entries(&max_tr, 1);
+	set_buffer_entries(&global_trace.max_buffer, 1);
 #endif
 
 	trace_init_cmdlines();
@@ -5646,8 +5698,10 @@ __init static int tracer_alloc_buffers(void)
 	return 0;
 
 out_free_cpumask:
-	free_percpu(global_trace.data);
-	free_percpu(max_tr.data);
+	free_percpu(global_trace.trace_buffer.data);
+#ifdef CONFIG_TRACER_MAX_TRACE
+	free_percpu(global_trace.max_buffer.data);
+#endif
 	free_cpumask_var(tracing_cpumask);
 out_free_buffer_mask:
 	free_cpumask_var(tracing_buffer_mask);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e9486c74d..18f7403 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -167,16 +167,37 @@ struct trace_array_cpu {
 
 struct tracer;
 
+struct trace_buffer {
+	struct trace_array		*tr;
+	struct ring_buffer		*buffer;
+	struct trace_array_cpu __percpu	*data;
+	cycle_t				time_start;
+	int				cpu;
+};
+
 /*
  * The trace array - an array of per-CPU trace arrays. This is the
  * highest level data structure that individual tracers deal with.
  * They have on/off state as well:
  */
 struct trace_array {
-	struct ring_buffer	*buffer;
 	struct list_head	list;
 	char			*name;
-	int			cpu;
+	struct trace_buffer	trace_buffer;
+#ifdef CONFIG_TRACER_MAX_TRACE
+	/*
+	 * The max_buffer is used to snapshot the trace when a maximum
+	 * latency is reached, or when the user initiates a snapshot.
+	 * Some tracers will use this to store a maximum trace while
+	 * it continues examining live traces.
+	 *
+	 * The buffers for the max_buffer are set up the same as the trace_buffer
+	 * When a snapshot is taken, the buffer of the max_buffer is swapped
+	 * with the buffer of the trace_buffer and the buffers are reset for
+	 * the trace_buffer so the tracing can continue.
+	 */
+	struct trace_buffer	max_buffer;
+#endif
 	int			buffer_disabled;
 	struct trace_cpu	trace_cpu;	/* place holder */
 #ifdef CONFIG_FTRACE_SYSCALLS
@@ -189,7 +210,6 @@ struct trace_array {
 	int			clock_id;
 	struct tracer		*current_trace;
 	unsigned int		flags;
-	cycle_t			time_start;
 	raw_spinlock_t		start_lock;
 	struct dentry		*dir;
 	struct dentry		*options;
@@ -198,7 +218,6 @@ struct trace_array {
 	struct list_head	systems;
 	struct list_head	events;
 	struct task_struct	*waiter;
-	struct trace_array_cpu __percpu	*data;
 };
 
 enum {
@@ -342,8 +361,10 @@ struct tracer {
 	struct tracer		*next;
 	struct tracer_flags	*flags;
 	bool			print_max;
+#ifdef CONFIG_TRACER_MAX_TRACE
 	bool			use_max_tr;
 	bool			allocated_snapshot;
+#endif
 };
 
 
@@ -489,8 +510,8 @@ trace_buffer_iter(struct trace_iterator *iter, int cpu)
 
 int tracer_init(struct tracer *t, struct trace_array *tr);
 int tracing_is_enabled(void);
-void tracing_reset(struct trace_array *tr, int cpu);
-void tracing_reset_online_cpus(struct trace_array *tr);
+void tracing_reset(struct trace_buffer *buf, int cpu);
+void tracing_reset_online_cpus(struct trace_buffer *buf);
 void tracing_reset_current(int cpu);
 void tracing_reset_all_online_cpus(void);
 int tracing_open_generic(struct inode *inode, struct file *filp);
@@ -670,6 +691,8 @@ trace_array_vprintk(struct trace_array *tr,
 		    unsigned long ip, const char *fmt, va_list args);
 int trace_array_printk(struct trace_array *tr,
 		       unsigned long ip, const char *fmt, ...);
+int trace_array_printk_buf(struct ring_buffer *buffer,
+			   unsigned long ip, const char *fmt, ...);
 void trace_printk_seq(struct trace_seq *s);
 enum print_line_t print_trace_line(struct trace_iterator *iter);
 
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 9d73861..e467c0c 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -28,7 +28,7 @@ static void tracing_stop_function_trace(void);
 static int function_trace_init(struct trace_array *tr)
 {
 	func_trace = tr;
-	tr->cpu = get_cpu();
+	tr->trace_buffer.cpu = get_cpu();
 	put_cpu();
 
 	tracing_start_cmdline_record();
@@ -44,7 +44,7 @@ static void function_trace_reset(struct trace_array *tr)
 
 static void function_trace_start(struct trace_array *tr)
 {
-	tracing_reset_online_cpus(tr);
+	tracing_reset_online_cpus(&tr->trace_buffer);
 }
 
 /* Our option */
@@ -76,7 +76,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip,
 		goto out;
 
 	cpu = smp_processor_id();
-	data = per_cpu_ptr(tr->data, cpu);
+	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
 	if (!atomic_read(&data->disabled)) {
 		local_save_flags(flags);
 		trace_function(tr, ip, parent_ip, flags, pc);
@@ -107,7 +107,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip,
 	 */
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = per_cpu_ptr(tr->data, cpu);
+	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
 	disabled = atomic_inc_return(&data->disabled);
 
 	if (likely(disabled == 1)) {
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index ca986d6..8388bc9 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -218,7 +218,7 @@ int __trace_graph_entry(struct trace_array *tr,
 {
 	struct ftrace_event_call *call = &event_funcgraph_entry;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer = tr->buffer;
+	struct ring_buffer *buffer = tr->trace_buffer.buffer;
 	struct ftrace_graph_ent_entry *entry;
 
 	if (unlikely(__this_cpu_read(ftrace_cpu_disabled)))
@@ -265,7 +265,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = per_cpu_ptr(tr->data, cpu);
+	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
 	disabled = atomic_inc_return(&data->disabled);
 	if (likely(disabled == 1)) {
 		pc = preempt_count();
@@ -323,7 +323,7 @@ void __trace_graph_return(struct trace_array *tr,
 {
 	struct ftrace_event_call *call = &event_funcgraph_exit;
 	struct ring_buffer_event *event;
-	struct ring_buffer *buffer = tr->buffer;
+	struct ring_buffer *buffer = tr->trace_buffer.buffer;
 	struct ftrace_graph_ret_entry *entry;
 
 	if (unlikely(__this_cpu_read(ftrace_cpu_disabled)))
@@ -350,7 +350,7 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = per_cpu_ptr(tr->data, cpu);
+	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
 	disabled = atomic_inc_return(&data->disabled);
 	if (likely(disabled == 1)) {
 		pc = preempt_count();
@@ -560,9 +560,9 @@ get_return_for_leaf(struct trace_iterator *iter,
 			 * We need to consume the current entry to see
 			 * the next one.
 			 */
-			ring_buffer_consume(iter->tr->buffer, iter->cpu,
+			ring_buffer_consume(iter->trace_buffer->buffer, iter->cpu,
 					    NULL, NULL);
-			event = ring_buffer_peek(iter->tr->buffer, iter->cpu,
+			event = ring_buffer_peek(iter->trace_buffer->buffer, iter->cpu,
 						 NULL, NULL);
 		}
 
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 7137a0f..f4f1f06 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -121,7 +121,7 @@ static int func_prolog_dec(struct trace_array *tr,
 	if (!irqs_disabled_flags(*flags))
 		return 0;
 
-	*data = per_cpu_ptr(tr->data, cpu);
+	*data = per_cpu_ptr(tr->trace_buffer.data, cpu);
 	disabled = atomic_inc_return(&(*data)->disabled);
 
 	if (likely(disabled == 1))
@@ -175,7 +175,7 @@ static int irqsoff_set_flag(u32 old_flags, u32 bit, int set)
 		per_cpu(tracing_cpu, cpu) = 0;
 
 	tracing_max_latency = 0;
-	tracing_reset_online_cpus(irqsoff_trace);
+	tracing_reset_online_cpus(&irqsoff_trace->trace_buffer);
 
 	return start_irqsoff_tracer(irqsoff_trace, set);
 }
@@ -380,7 +380,7 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
 	if (per_cpu(tracing_cpu, cpu))
 		return;
 
-	data = per_cpu_ptr(tr->data, cpu);
+	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
 
 	if (unlikely(!data) || atomic_read(&data->disabled))
 		return;
@@ -418,7 +418,7 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
 	if (!tracer_enabled)
 		return;
 
-	data = per_cpu_ptr(tr->data, cpu);
+	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
 
 	if (unlikely(!data) ||
 	    !data->critical_start || atomic_read(&data->disabled))
@@ -565,7 +565,7 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
 	irqsoff_trace = tr;
 	/* make sure that the tracer is visible */
 	smp_wmb();
-	tracing_reset_online_cpus(tr);
+	tracing_reset_online_cpus(&tr->trace_buffer);
 
 	if (start_irqsoff_tracer(tr, is_graph()))
 		printk(KERN_ERR "failed to start irqsoff tracer\n");
diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index 349f694..bd90e1b 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -26,7 +26,7 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
 	trace_init_global_iter(&iter);
 
 	for_each_tracing_cpu(cpu) {
-		atomic_inc(&per_cpu_ptr(iter.tr->data, cpu)->disabled);
+		atomic_inc(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
 	}
 
 	old_userobj = trace_flags;
@@ -46,14 +46,14 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
 	if (cpu_file == RING_BUFFER_ALL_CPUS) {
 		for_each_tracing_cpu(cpu) {
 			iter.buffer_iter[cpu] =
-			ring_buffer_read_prepare(iter.tr->buffer, cpu);
+			ring_buffer_read_prepare(iter.trace_buffer->buffer, cpu);
 			ring_buffer_read_start(iter.buffer_iter[cpu]);
 			tracing_iter_reset(&iter, cpu);
 		}
 	} else {
 		iter.cpu_file = cpu_file;
 		iter.buffer_iter[cpu_file] =
-			ring_buffer_read_prepare(iter.tr->buffer, cpu_file);
+			ring_buffer_read_prepare(iter.trace_buffer->buffer, cpu_file);
 		ring_buffer_read_start(iter.buffer_iter[cpu_file]);
 		tracing_iter_reset(&iter, cpu_file);
 	}
@@ -83,7 +83,7 @@ out:
 	trace_flags = old_userobj;
 
 	for_each_tracing_cpu(cpu) {
-		atomic_dec(&per_cpu_ptr(iter.tr->data, cpu)->disabled);
+		atomic_dec(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
 	}
 
 	for_each_tracing_cpu(cpu)
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 2472f6f..a5e8f48 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -31,7 +31,7 @@ static void mmio_reset_data(struct trace_array *tr)
 	overrun_detected = false;
 	prev_overruns = 0;
 
-	tracing_reset_online_cpus(tr);
+	tracing_reset_online_cpus(&tr->trace_buffer);
 }
 
 static int mmio_trace_init(struct trace_array *tr)
@@ -128,7 +128,7 @@ static void mmio_close(struct trace_iterator *iter)
 static unsigned long count_overruns(struct trace_iterator *iter)
 {
 	unsigned long cnt = atomic_xchg(&dropped_count, 0);
-	unsigned long over = ring_buffer_overruns(iter->tr->buffer);
+	unsigned long over = ring_buffer_overruns(iter->trace_buffer->buffer);
 
 	if (over > prev_overruns)
 		cnt += over - prev_overruns;
@@ -309,7 +309,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 				struct mmiotrace_rw *rw)
 {
 	struct ftrace_event_call *call = &event_mmiotrace_rw;
-	struct ring_buffer *buffer = tr->buffer;
+	struct ring_buffer *buffer = tr->trace_buffer.buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_rw *entry;
 	int pc = preempt_count();
@@ -330,7 +330,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 void mmio_trace_rw(struct mmiotrace_rw *rw)
 {
 	struct trace_array *tr = mmio_trace_array;
-	struct trace_array_cpu *data = per_cpu_ptr(tr->data, smp_processor_id());
+	struct trace_array_cpu *data = per_cpu_ptr(tr->trace_buffer.data, smp_processor_id());
 	__trace_mmiotrace_rw(tr, data, rw);
 }
 
@@ -339,7 +339,7 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 				struct mmiotrace_map *map)
 {
 	struct ftrace_event_call *call = &event_mmiotrace_map;
-	struct ring_buffer *buffer = tr->buffer;
+	struct ring_buffer *buffer = tr->trace_buffer.buffer;
 	struct ring_buffer_event *event;
 	struct trace_mmiotrace_map *entry;
 	int pc = preempt_count();
@@ -363,7 +363,7 @@ void mmio_trace_mapping(struct mmiotrace_map *map)
 	struct trace_array_cpu *data;
 
 	preempt_disable();
-	data = per_cpu_ptr(tr->data, smp_processor_id());
+	data = per_cpu_ptr(tr->trace_buffer.data, smp_processor_id());
 	__trace_mmiotrace_map(tr, data, map);
 	preempt_enable();
 }
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index aa92ac3..2edc722 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -643,7 +643,7 @@ lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
 {
 	unsigned long verbose = trace_flags & TRACE_ITER_VERBOSE;
 	unsigned long in_ns = iter->iter_flags & TRACE_FILE_TIME_IN_NS;
-	unsigned long long abs_ts = iter->ts - iter->tr->time_start;
+	unsigned long long abs_ts = iter->ts - iter->trace_buffer->time_start;
 	unsigned long long rel_ts = next_ts - iter->ts;
 	struct trace_seq *s = &iter->seq;
 
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 1ffe39a..4e98e3b 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -28,7 +28,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
 			   unsigned long flags, int pc)
 {
 	struct ftrace_event_call *call = &event_context_switch;
-	struct ring_buffer *buffer = tr->buffer;
+	struct ring_buffer *buffer = tr->trace_buffer.buffer;
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
 
@@ -69,7 +69,7 @@ probe_sched_switch(void *ignore, struct task_struct *prev, struct task_struct *n
 	pc = preempt_count();
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = per_cpu_ptr(ctx_trace->data, cpu);
+	data = per_cpu_ptr(ctx_trace->trace_buffer.data, cpu);
 
 	if (likely(!atomic_read(&data->disabled)))
 		tracing_sched_switch_trace(ctx_trace, prev, next, flags, pc);
@@ -86,7 +86,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	struct ftrace_event_call *call = &event_wakeup;
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
-	struct ring_buffer *buffer = tr->buffer;
+	struct ring_buffer *buffer = tr->trace_buffer.buffer;
 
 	event = trace_buffer_lock_reserve(buffer, TRACE_WAKE,
 					  sizeof(*entry), flags, pc);
@@ -123,7 +123,7 @@ probe_sched_wakeup(void *ignore, struct task_struct *wakee, int success)
 	pc = preempt_count();
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = per_cpu_ptr(ctx_trace->data, cpu);
+	data = per_cpu_ptr(ctx_trace->trace_buffer.data, cpu);
 
 	if (likely(!atomic_read(&data->disabled)))
 		tracing_sched_wakeup_trace(ctx_trace, wakee, current,
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index e6725c8..fbe950a 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -89,7 +89,7 @@ func_prolog_preempt_disable(struct trace_array *tr,
 	if (cpu != wakeup_current_cpu)
 		goto out_enable;
 
-	*data = per_cpu_ptr(tr->data, cpu);
+	*data = per_cpu_ptr(tr->trace_buffer.data, cpu);
 	disabled = atomic_inc_return(&(*data)->disabled);
 	if (unlikely(disabled != 1))
 		goto out;
@@ -353,7 +353,7 @@ probe_wakeup_sched_switch(void *ignore,
 
 	/* disable local data, not wakeup_cpu data */
 	cpu = raw_smp_processor_id();
-	disabled = atomic_inc_return(&per_cpu_ptr(wakeup_trace->data, cpu)->disabled);
+	disabled = atomic_inc_return(&per_cpu_ptr(wakeup_trace->trace_buffer.data, cpu)->disabled);
 	if (likely(disabled != 1))
 		goto out;
 
@@ -365,7 +365,7 @@ probe_wakeup_sched_switch(void *ignore,
 		goto out_unlock;
 
 	/* The task we are waiting for is waking up */
-	data = per_cpu_ptr(wakeup_trace->data, wakeup_cpu);
+	data = per_cpu_ptr(wakeup_trace->trace_buffer.data, wakeup_cpu);
 
 	__trace_function(wakeup_trace, CALLER_ADDR0, CALLER_ADDR1, flags, pc);
 	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
@@ -387,7 +387,7 @@ out_unlock:
 	arch_spin_unlock(&wakeup_lock);
 	local_irq_restore(flags);
 out:
-	atomic_dec(&per_cpu_ptr(wakeup_trace->data, cpu)->disabled);
+	atomic_dec(&per_cpu_ptr(wakeup_trace->trace_buffer.data, cpu)->disabled);
 }
 
 static void __wakeup_reset(struct trace_array *tr)
@@ -405,7 +405,7 @@ static void wakeup_reset(struct trace_array *tr)
 {
 	unsigned long flags;
 
-	tracing_reset_online_cpus(tr);
+	tracing_reset_online_cpus(&tr->trace_buffer);
 
 	local_irq_save(flags);
 	arch_spin_lock(&wakeup_lock);
@@ -435,7 +435,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 		return;
 
 	pc = preempt_count();
-	disabled = atomic_inc_return(&per_cpu_ptr(wakeup_trace->data, cpu)->disabled);
+	disabled = atomic_inc_return(&per_cpu_ptr(wakeup_trace->trace_buffer.data, cpu)->disabled);
 	if (unlikely(disabled != 1))
 		goto out;
 
@@ -458,7 +458,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 
 	local_save_flags(flags);
 
-	data = per_cpu_ptr(wakeup_trace->data, wakeup_cpu);
+	data = per_cpu_ptr(wakeup_trace->trace_buffer.data, wakeup_cpu);
 	data->preempt_timestamp = ftrace_now(cpu);
 	tracing_sched_wakeup_trace(wakeup_trace, p, current, flags, pc);
 
@@ -472,7 +472,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 out_locked:
 	arch_spin_unlock(&wakeup_lock);
 out:
-	atomic_dec(&per_cpu_ptr(wakeup_trace->data, cpu)->disabled);
+	atomic_dec(&per_cpu_ptr(wakeup_trace->trace_buffer.data, cpu)->disabled);
 }
 
 static void start_wakeup_tracer(struct trace_array *tr)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 51c819c..8672c40 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -21,13 +21,13 @@ static inline int trace_valid_entry(struct trace_entry *entry)
 	return 0;
 }
 
-static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
+static int trace_test_buffer_cpu(struct trace_buffer *buf, int cpu)
 {
 	struct ring_buffer_event *event;
 	struct trace_entry *entry;
 	unsigned int loops = 0;
 
-	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL, NULL))) {
+	while ((event = ring_buffer_consume(buf->buffer, cpu, NULL, NULL))) {
 		entry = ring_buffer_event_data(event);
 
 		/*
@@ -58,7 +58,7 @@ static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
  * Test the trace buffer to see if all the elements
  * are still sane.
  */
-static int trace_test_buffer(struct trace_array *tr, unsigned long *count)
+static int trace_test_buffer(struct trace_buffer *buf, unsigned long *count)
 {
 	unsigned long flags, cnt = 0;
 	int cpu, ret = 0;
@@ -67,7 +67,7 @@ static int trace_test_buffer(struct trace_array *tr, unsigned long *count)
 	local_irq_save(flags);
 	arch_spin_lock(&ftrace_max_lock);
 
-	cnt = ring_buffer_entries(tr->buffer);
+	cnt = ring_buffer_entries(buf->buffer);
 
 	/*
 	 * The trace_test_buffer_cpu runs a while loop to consume all data.
@@ -78,7 +78,7 @@ static int trace_test_buffer(struct trace_array *tr, unsigned long *count)
 	 */
 	tracing_off();
 	for_each_possible_cpu(cpu) {
-		ret = trace_test_buffer_cpu(tr, cpu);
+		ret = trace_test_buffer_cpu(buf, cpu);
 		if (ret)
 			break;
 	}
@@ -355,7 +355,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	msleep(100);
 
 	/* we should have nothing in the buffer */
-	ret = trace_test_buffer(tr, &count);
+	ret = trace_test_buffer(&tr->trace_buffer, &count);
 	if (ret)
 		goto out;
 
@@ -376,7 +376,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	ftrace_enabled = 0;
 
 	/* check the trace buffer */
-	ret = trace_test_buffer(tr, &count);
+	ret = trace_test_buffer(&tr->trace_buffer, &count);
 	tracing_start();
 
 	/* we should only have one item */
@@ -666,7 +666,7 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 	ftrace_enabled = 0;
 
 	/* check the trace buffer */
-	ret = trace_test_buffer(tr, &count);
+	ret = trace_test_buffer(&tr->trace_buffer, &count);
 	trace->reset(tr);
 	tracing_start();
 
@@ -737,7 +737,7 @@ trace_selftest_startup_function_graph(struct tracer *trace,
 	 * Simulate the init() callback but we attach a watchdog callback
 	 * to detect and recover from possible hangs
 	 */
-	tracing_reset_online_cpus(tr);
+	tracing_reset_online_cpus(&tr->trace_buffer);
 	set_graph_array(tr);
 	ret = register_ftrace_graph(&trace_graph_return,
 				    &trace_graph_entry_watchdog);
@@ -760,7 +760,7 @@ trace_selftest_startup_function_graph(struct tracer *trace,
 	tracing_stop();
 
 	/* check the trace buffer */
-	ret = trace_test_buffer(tr, &count);
+	ret = trace_test_buffer(&tr->trace_buffer, &count);
 
 	trace->reset(tr);
 	tracing_start();
@@ -815,9 +815,9 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 	/* stop the tracing. */
 	tracing_stop();
 	/* check both trace buffers */
-	ret = trace_test_buffer(tr, NULL);
+	ret = trace_test_buffer(&tr->trace_buffer, NULL);
 	if (!ret)
-		ret = trace_test_buffer(&max_tr, &count);
+		ret = trace_test_buffer(&tr->max_buffer, &count);
 	trace->reset(tr);
 	tracing_start();
 
@@ -877,9 +877,9 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 	/* stop the tracing. */
 	tracing_stop();
 	/* check both trace buffers */
-	ret = trace_test_buffer(tr, NULL);
+	ret = trace_test_buffer(&tr->trace_buffer, NULL);
 	if (!ret)
-		ret = trace_test_buffer(&max_tr, &count);
+		ret = trace_test_buffer(&tr->max_buffer, &count);
 	trace->reset(tr);
 	tracing_start();
 
@@ -943,11 +943,11 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	/* stop the tracing. */
 	tracing_stop();
 	/* check both trace buffers */
-	ret = trace_test_buffer(tr, NULL);
+	ret = trace_test_buffer(&tr->trace_buffer, NULL);
 	if (ret)
 		goto out;
 
-	ret = trace_test_buffer(&max_tr, &count);
+	ret = trace_test_buffer(&tr->max_buffer, &count);
 	if (ret)
 		goto out;
 
@@ -973,11 +973,11 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	/* stop the tracing. */
 	tracing_stop();
 	/* check both trace buffers */
-	ret = trace_test_buffer(tr, NULL);
+	ret = trace_test_buffer(&tr->trace_buffer, NULL);
 	if (ret)
 		goto out;
 
-	ret = trace_test_buffer(&max_tr, &count);
+	ret = trace_test_buffer(&tr->max_buffer, &count);
 
 	if (!ret && !count) {
 		printk(KERN_CONT ".. no entries found ..");
@@ -1084,10 +1084,10 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	/* stop the tracing. */
 	tracing_stop();
 	/* check both trace buffers */
-	ret = trace_test_buffer(tr, NULL);
+	ret = trace_test_buffer(&tr->trace_buffer, NULL);
 	printk("ret = %d\n", ret);
 	if (!ret)
-		ret = trace_test_buffer(&max_tr, &count);
+		ret = trace_test_buffer(&tr->max_buffer, &count);
 
 
 	trace->reset(tr);
@@ -1126,7 +1126,7 @@ trace_selftest_startup_sched_switch(struct tracer *trace, struct trace_array *tr
 	/* stop the tracing. */
 	tracing_stop();
 	/* check the trace buffer */
-	ret = trace_test_buffer(tr, &count);
+	ret = trace_test_buffer(&tr->trace_buffer, &count);
 	trace->reset(tr);
 	tracing_start();
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 1cd37ff..68f3f34 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -321,7 +321,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
-	buffer = tr->buffer;
+	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer,
 			sys_data->enter_event->event.type, size, 0, 0);
 	if (!event)
@@ -355,7 +355,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
-	buffer = tr->buffer;
+	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer,
 			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
 	if (!event)
-- 
1.7.10.4


