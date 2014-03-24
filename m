Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaCXSOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 14:14:12 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:34937 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaCXSOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 14:14:08 -0400
From: Bharath Ravi <rbharath@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>, Bharath Ravi <rbharath@google.com>,
        Laurent Chavey <chavey@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] tracing: Replace usage of trace_flags with new accessors.
Date: Mon, 24 Mar 2014 11:13:44 -0700
Message-Id: <1395684826-22931-2-git-send-email-rbharath@google.com>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1395684826-22931-1-git-send-email-rbharath@google.com>
References: <1395684826-22931-1-git-send-email-rbharath@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace_flags global variable stores various trace options that are
shared across all ftrace instances. This patch adds accessors function
for trace_flags - a getter and a setter - and replaces usages of
trace_flags with these.

This is in preparation for replacing the global trace_flags with
instance specific (local) trace_flags, allowing each instance to set
trace_flags independently.

Signed-off-by: Bharath Ravi <rbharath@google.com>
---
 kernel/trace/blktrace.c              |  3 +-
 kernel/trace/ftrace.c                |  4 +--
 kernel/trace/trace.c                 | 64 ++++++++++++++++++++++--------------
 kernel/trace/trace.h                 |  2 ++
 kernel/trace/trace_events.c          |  2 +-
 kernel/trace/trace_functions_graph.c | 10 +++---
 kernel/trace/trace_irqsoff.c         |  4 +--
 kernel/trace/trace_kdb.c             |  6 ++--
 kernel/trace/trace_output.c          |  8 ++---
 kernel/trace/trace_printk.c          |  8 ++---
 kernel/trace/trace_sched_wakeup.c    |  3 +-
 kernel/trace/trace_syscalls.c        |  2 +-
 12 files changed, 68 insertions(+), 48 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b418cb0..dd5112a 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1368,7 +1368,7 @@ static enum print_line_t print_one_line(struct trace_iterator *iter,
 
 	t	   = te_blk_io_trace(iter->ent);
 	what	   = t->action & ((1 << BLK_TC_SHIFT) - 1);
-	long_act   = !!(trace_flags & TRACE_ITER_VERBOSE);
+	long_act   = !!(global_trace_flags() & TRACE_ITER_VERBOSE);
 	log_action = classic ? &blk_log_action_classic : &blk_log_action;
 
 	if (t->action == BLK_TN_MESSAGE) {
@@ -1429,6 +1429,7 @@ static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
 
 static int blk_tracer_set_flag(u32 old_flags, u32 bit, int set)
 {
+	unsigned long trace_flags = global_trace_flags();
 	/* don't output context-info for blk_classic output */
 	if (bit == TRACE_BLK_OPT_CLASSIC) {
 		if (set)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cd7f76d..a4b7a5f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -939,7 +939,7 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 
 	calltime = trace->rettime - trace->calltime;
 
-	if (!(trace_flags & TRACE_ITER_GRAPH_TIME)) {
+	if (!(global_trace_flags() & TRACE_ITER_GRAPH_TIME)) {
 		int index;
 
 		index = trace->depth;
@@ -4979,7 +4979,7 @@ ftrace_graph_probe_sched_switch(void *ignore,
 	 * Does the user want to count the time a function was asleep.
 	 * If so, do not update the time stamps.
 	 */
-	if (trace_flags & TRACE_ITER_SLEEP_TIME)
+	if (global_trace_flags() & TRACE_ITER_SLEEP_TIME)
 		return;
 
 	timestamp = trace_clock_local();
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 815c878..9f0a5f9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -408,10 +408,20 @@ static inline void trace_access_lock_init(void)
 
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
-	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
-	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
+	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO |	TRACE_ITER_SLEEP_TIME |
+	TRACE_ITER_GRAPH_TIME |	TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
 	TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS | TRACE_ITER_FUNCTION;
 
+unsigned long global_trace_flags(void)
+{
+	return trace_flags;
+}
+
+void set_global_trace_flags(unsigned long flags)
+{
+	trace_flags = flags;
+}
+
 static void tracer_tracing_on(struct trace_array *tr)
 {
 	if (tr->trace_buffer.buffer)
@@ -1770,7 +1780,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
 void ftrace_trace_stack_regs(struct ring_buffer *buffer, unsigned long flags,
 			     int skip, int pc, struct pt_regs *regs)
 {
-	if (!(trace_flags & TRACE_ITER_STACKTRACE))
+	if (!(global_trace_flags() & TRACE_ITER_STACKTRACE))
 		return;
 
 	__ftrace_trace_stack(buffer, flags, skip, pc, regs);
@@ -1779,7 +1789,7 @@ void ftrace_trace_stack_regs(struct ring_buffer *buffer, unsigned long flags,
 void ftrace_trace_stack(struct ring_buffer *buffer, unsigned long flags,
 			int skip, int pc)
 {
-	if (!(trace_flags & TRACE_ITER_STACKTRACE))
+	if (!(global_trace_flags() & TRACE_ITER_STACKTRACE))
 		return;
 
 	__ftrace_trace_stack(buffer, flags, skip, pc, NULL);
@@ -1823,7 +1833,7 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 	struct userstack_entry *entry;
 	struct stack_trace trace;
 
-	if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
+	if (!(global_trace_flags() & TRACE_ITER_USERSTACKTRACE))
 		return;
 
 	/*
@@ -2128,7 +2138,7 @@ int trace_array_printk(struct trace_array *tr,
 	int ret;
 	va_list ap;
 
-	if (!(trace_flags & TRACE_ITER_PRINTK))
+	if (!(global_trace_flags() & TRACE_ITER_PRINTK))
 		return 0;
 
 	va_start(ap, fmt);
@@ -2143,7 +2153,7 @@ int trace_array_printk_buf(struct ring_buffer *buffer,
 	int ret;
 	va_list ap;
 
-	if (!(trace_flags & TRACE_ITER_PRINTK))
+	if (!(global_trace_flags() & TRACE_ITER_PRINTK))
 		return 0;
 
 	va_start(ap, fmt);
@@ -2484,7 +2494,7 @@ static void print_func_help_header_irq(struct trace_buffer *buf, struct seq_file
 void
 print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 {
-	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
+	unsigned long sym_flags = (global_trace_flags() & TRACE_ITER_SYM_MASK);
 	struct trace_buffer *buf = iter->trace_buffer;
 	struct trace_array_cpu *data = per_cpu_ptr(buf->data, buf->cpu);
 	struct tracer *type = iter->trace;
@@ -2547,7 +2557,7 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 
-	if (!(trace_flags & TRACE_ITER_ANNOTATE))
+	if (!(global_trace_flags() & TRACE_ITER_ANNOTATE))
 		return;
 
 	if (!(iter->iter_flags & TRACE_FILE_ANNOTATE))
@@ -2570,7 +2580,7 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
 static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
-	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
+	unsigned long sym_flags = (global_trace_flags() & TRACE_ITER_SYM_MASK);
 	struct trace_entry *entry;
 	struct trace_event *event;
 
@@ -2580,7 +2590,7 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 
 	event = ftrace_find_event(entry->type);
 
-	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+	if (global_trace_flags() & TRACE_ITER_CONTEXT_INFO) {
 		if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
 			if (!trace_print_lat_context(iter))
 				goto partial;
@@ -2609,7 +2619,7 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+	if (global_trace_flags() & TRACE_ITER_CONTEXT_INFO) {
 		if (!trace_seq_printf(s, "%d %d %llu ",
 				      entry->pid, iter->cpu, iter->ts))
 			goto partial;
@@ -2636,7 +2646,7 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+	if (global_trace_flags() & TRACE_ITER_CONTEXT_INFO) {
 		SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
 		SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
 		SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
@@ -2662,7 +2672,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+	if (global_trace_flags() & TRACE_ITER_CONTEXT_INFO) {
 		SEQ_PUT_FIELD_RET(s, entry->pid);
 		SEQ_PUT_FIELD_RET(s, iter->cpu);
 		SEQ_PUT_FIELD_RET(s, iter->ts);
@@ -2709,6 +2719,7 @@ int trace_empty(struct trace_iterator *iter)
 /*  Called with trace_event_read_lock() held. */
 enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
+	unsigned long trace_flags = global_trace_flags();
 	enum print_line_t ret;
 
 	if (iter->lost_events &&
@@ -2760,12 +2771,13 @@ void trace_latency_header(struct seq_file *m)
 	if (iter->iter_flags & TRACE_FILE_LAT_FMT)
 		print_trace_header(m, iter);
 
-	if (!(trace_flags & TRACE_ITER_VERBOSE))
+	if (!(global_trace_flags() & TRACE_ITER_VERBOSE))
 		print_lat_help_header(m);
 }
 
 void trace_default_header(struct seq_file *m)
 {
+	unsigned long trace_flags = global_trace_flags();
 	struct trace_iterator *iter = m->private;
 
 	if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
@@ -3111,7 +3123,7 @@ static int tracing_open(struct inode *inode, struct file *file)
 		iter = __tracing_open(inode, file, false);
 		if (IS_ERR(iter))
 			ret = PTR_ERR(iter);
-		else if (trace_flags & TRACE_ITER_LATENCY_FMT)
+		else if (global_trace_flags() & TRACE_ITER_LATENCY_FMT)
 			iter->iter_flags |= TRACE_FILE_LAT_FMT;
 	}
 
@@ -3322,7 +3334,7 @@ static int tracing_trace_options_show(struct seq_file *m, void *v)
 	trace_opts = tr->current_trace->flags->opts;
 
 	for (i = 0; trace_options[i]; i++) {
-		if (trace_flags & (1 << i))
+		if (global_trace_flags() & (1 << i))
 			seq_printf(m, "%s\n", trace_options[i]);
 		else
 			seq_printf(m, "no%s\n", trace_options[i]);
@@ -3385,6 +3397,7 @@ int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set)
 
 int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 {
+	unsigned long trace_flags = global_trace_flags();
 	/* do nothing if flag is already set */
 	if (!!(trace_flags & mask) == !!enabled)
 		return 0;
@@ -4057,7 +4070,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 	/* trace pipe does not show start of buffer */
 	cpumask_setall(iter->started);
 
-	if (trace_flags & TRACE_ITER_LATENCY_FMT)
+	if (global_trace_flags() & TRACE_ITER_LATENCY_FMT)
 		iter->iter_flags |= TRACE_FILE_LAT_FMT;
 
 	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
@@ -4115,7 +4128,7 @@ trace_poll(struct trace_iterator *iter, struct file *filp, poll_table *poll_tabl
 	if (trace_buffer_iter(iter, iter->cpu_file))
 		return POLLIN | POLLRDNORM;
 
-	if (trace_flags & TRACE_ITER_BLOCK)
+	if (global_trace_flags() & TRACE_ITER_BLOCK)
 		/*
 		 * Always select as readable when in blocking mode
 		 */
@@ -4553,7 +4566,7 @@ tracing_free_buffer_release(struct inode *inode, struct file *filp)
 	struct trace_array *tr = inode->i_private;
 
 	/* disable tracing ? */
-	if (trace_flags & TRACE_ITER_STOP_ON_FREE)
+	if (global_trace_flags() & TRACE_ITER_STOP_ON_FREE)
 		tracer_tracing_off(tr);
 	/* resize the ring buffer to 0 */
 	tracing_resize_ring_buffer(tr, 0, RING_BUFFER_ALL_CPUS);
@@ -4586,7 +4599,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	if (tracing_disabled)
 		return -EINVAL;
 
-	if (!(trace_flags & TRACE_ITER_MARKERS))
+	if (!(global_trace_flags() & TRACE_ITER_MARKERS))
 		return -EINVAL;
 
 	if (cnt > TRACE_BUF_SIZE)
@@ -5716,7 +5729,7 @@ trace_options_core_read(struct file *filp, char __user *ubuf, size_t cnt,
 	long index = (long)filp->private_data;
 	char *buf;
 
-	if (trace_flags & (1 << index))
+	if (global_trace_flags() & (1 << index))
 		buf = "1\n";
 	else
 		buf = "0\n";
@@ -5954,6 +5967,7 @@ static int
 allocate_trace_buffer(struct trace_array *tr, struct trace_buffer *buf, int size)
 {
 	enum ring_buffer_flags rb_flags;
+	unsigned long trace_flags = global_trace_flags();
 
 	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
 
@@ -6390,10 +6404,10 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 		atomic_inc(&per_cpu_ptr(iter.tr->trace_buffer.data, cpu)->disabled);
 	}
 
-	old_userobj = trace_flags & TRACE_ITER_SYM_USEROBJ;
+	old_userobj = global_trace_flags() & TRACE_ITER_SYM_USEROBJ;
 
 	/* don't look at user memory in panic mode */
-	trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
+	set_global_trace_flags(global_trace_flags() & ~TRACE_ITER_SYM_USEROBJ);
 
 	switch (oops_dump_mode) {
 	case DUMP_ALL:
@@ -6456,7 +6470,7 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 		printk(KERN_TRACE "---------------------------------\n");
 
  out_enable:
-	trace_flags |= old_userobj;
+	set_global_trace_flags(global_trace_flags() | old_userobj);
 
 	for_each_tracing_cpu(cpu) {
 		atomic_dec(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 02b592f..82b50a0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -705,6 +705,8 @@ void trace_printk_seq(struct trace_seq *s);
 enum print_line_t print_trace_line(struct trace_iterator *iter);
 
 extern unsigned long trace_flags;
+unsigned long global_trace_flags(void);
+void set_global_trace_flags(unsigned long flags);
 
 /* Standard output formatting function used for function return traces */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f3989ce..9658252 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -320,7 +320,7 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 			if (soft_disable)
 				set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
 
-			if (trace_flags & TRACE_ITER_RECORD_CMD) {
+			if (global_trace_flags() & TRACE_ITER_RECORD_CMD) {
 				tracing_start_cmdline_record();
 				set_bit(FTRACE_EVENT_FL_RECORDED_CMD_BIT, &file->flags);
 			}
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 0b99120..019bfdd 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -675,7 +675,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		addr >= (unsigned long)__irqentry_text_end)
 		return TRACE_TYPE_UNHANDLED;
 
-	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+	if (global_trace_flags() & TRACE_ITER_CONTEXT_INFO) {
 		/* Absolute time */
 		if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
 			ret = print_graph_abs_time(iter->ts, s);
@@ -775,7 +775,7 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
 	int ret = -1;
 
 	if (!(flags & TRACE_GRAPH_PRINT_DURATION) ||
-	    !(trace_flags & TRACE_ITER_CONTEXT_INFO))
+	    !(global_trace_flags() & TRACE_ITER_CONTEXT_INFO))
 			return TRACE_TYPE_HANDLED;
 
 	/* No real adata, just filling the column with spaces */
@@ -932,6 +932,7 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 	struct trace_entry *ent = iter->ent;
 	int cpu = iter->cpu;
 	int ret;
+	unsigned long trace_flags = global_trace_flags();
 
 	/* Pid */
 	if (verif_pid(s, ent->pid, cpu, data) == TRACE_TYPE_PARTIAL_LINE)
@@ -1208,7 +1209,7 @@ static enum print_line_t
 print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 		    struct trace_iterator *iter, u32 flags)
 {
-	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
+	unsigned long sym_flags = (global_trace_flags() & TRACE_ITER_SYM_MASK);
 	struct fgraph_data *data = iter->private;
 	struct trace_event *event;
 	int depth = 0;
@@ -1371,7 +1372,7 @@ static void print_lat_header(struct seq_file *s, u32 flags)
 
 static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 {
-	int lat = trace_flags & TRACE_ITER_LATENCY_FMT;
+	int lat = global_trace_flags() & TRACE_ITER_LATENCY_FMT;
 
 	if (lat)
 		print_lat_header(s, flags);
@@ -1412,6 +1413,7 @@ void print_graph_headers(struct seq_file *s)
 
 void print_graph_headers_flags(struct seq_file *s, u32 flags)
 {
+	unsigned long trace_flags = global_trace_flags();
 	struct trace_iterator *iter = s->private;
 
 	if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2aefbee..4943166 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -532,7 +532,7 @@ void trace_preempt_off(unsigned long a0, unsigned long a1)
 static int register_irqsoff_function(int graph, int set)
 {
 	int ret;
-
+	unsigned long trace_flags = global_trace_flags();
 	/* 'set' is set if TRACE_ITER_FUNCTION is about to be set */
 	if (function_enabled || (!set && !(trace_flags & TRACE_ITER_FUNCTION)))
 		return 0;
@@ -601,7 +601,7 @@ static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
 
 static void __irqsoff_tracer_init(struct trace_array *tr)
 {
-	save_flags = trace_flags;
+	save_flags = global_trace_flags();
 
 	/* non overwrite screws up the latency tracers */
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index bd90e1b..ff61721 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -29,10 +29,10 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
 		atomic_inc(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
 	}
 
-	old_userobj = trace_flags;
+	old_userobj = global_trace_flags();
 
 	/* don't look at user memory in panic mode */
-	trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
+	set_trace_flags(global_trace_flags() & ~TRACE_ITER_SYM_USEROBJ);
 
 	kdb_printf("Dumping ftrace buffer:\n");
 
@@ -80,7 +80,7 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
 		kdb_printf("---------------------------------\n");
 
 out:
-	trace_flags = old_userobj;
+	set_trace_flags(old_userobj);
 
 	for_each_tracing_cpu(cpu) {
 		atomic_dec(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index ed32284..700eb02 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -534,7 +534,7 @@ seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 	int ret = 1;
 	unsigned int i;
 
-	if (trace_flags & TRACE_ITER_SYM_USEROBJ) {
+	if (global_trace_flags() & TRACE_ITER_SYM_USEROBJ) {
 		struct task_struct *task;
 		/*
 		 * we do the lookup on the thread group leader,
@@ -672,7 +672,7 @@ static unsigned long preempt_mark_thresh_us = 100;
 static int
 lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
 {
-	unsigned long verbose = trace_flags & TRACE_ITER_VERBOSE;
+	unsigned long verbose = global_trace_flags() & TRACE_ITER_VERBOSE;
 	unsigned long in_ns = iter->iter_flags & TRACE_FILE_TIME_IN_NS;
 	unsigned long long abs_ts = iter->ts - iter->trace_buffer->time_start;
 	unsigned long long rel_ts = next_ts - iter->ts;
@@ -725,7 +725,7 @@ int trace_print_context(struct trace_iterator *iter)
 	if (!ret)
 		return 0;
 
-	if (trace_flags & TRACE_ITER_IRQ_INFO) {
+	if (global_trace_flags() & TRACE_ITER_IRQ_INFO) {
 		ret = trace_print_lat_fmt(s, entry);
 		if (!ret)
 			return 0;
@@ -750,7 +750,7 @@ int trace_print_lat_context(struct trace_iterator *iter)
 	struct trace_entry *entry = iter->ent,
 			   *next_entry = trace_find_next_entry(iter, NULL,
 							       &next_ts);
-	unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
+	unsigned long verbose = (global_trace_flags() & TRACE_ITER_VERBOSE);
 
 	/* Restore the original ent_size */
 	iter->ent_size = ent_size;
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 2900817..7c9ce2e 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -194,7 +194,7 @@ int __trace_bprintk(unsigned long ip, const char *fmt, ...)
 	if (unlikely(!fmt))
 		return 0;
 
-	if (!(trace_flags & TRACE_ITER_PRINTK))
+	if (!(global_trace_flags() & TRACE_ITER_PRINTK))
 		return 0;
 
 	va_start(ap, fmt);
@@ -209,7 +209,7 @@ int __ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap)
 	if (unlikely(!fmt))
 		return 0;
 
-	if (!(trace_flags & TRACE_ITER_PRINTK))
+	if (!(global_trace_flags() & TRACE_ITER_PRINTK))
 		return 0;
 
 	return trace_vbprintk(ip, fmt, ap);
@@ -221,7 +221,7 @@ int __trace_printk(unsigned long ip, const char *fmt, ...)
 	int ret;
 	va_list ap;
 
-	if (!(trace_flags & TRACE_ITER_PRINTK))
+	if (!(global_trace_flags() & TRACE_ITER_PRINTK))
 		return 0;
 
 	va_start(ap, fmt);
@@ -233,7 +233,7 @@ EXPORT_SYMBOL_GPL(__trace_printk);
 
 int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
 {
-	if (!(trace_flags & TRACE_ITER_PRINTK))
+	if (!(global_trace_flags() & TRACE_ITER_PRINTK))
 		return 0;
 
 	return trace_vprintk(ip, fmt, ap);
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 6e32635..d643705 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -141,6 +141,7 @@ static struct ftrace_ops trace_ops __read_mostly =
 static int register_wakeup_function(int graph, int set)
 {
 	int ret;
+	int trace_flags = global_trace_flags();
 
 	/* 'set' is set if TRACE_ITER_FUNCTION is about to be set */
 	if (function_enabled || (!set && !(trace_flags & TRACE_ITER_FUNCTION)))
@@ -605,7 +606,7 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 
 static int __wakeup_tracer_init(struct trace_array *tr)
 {
-	save_flags = trace_flags;
+	save_flags = global_trace_flags();
 
 	/* non overwrite screws up the latency tracers */
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 759d5e0..617cbd6 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -134,7 +134,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 
 	for (i = 0; i < entry->nb_args; i++) {
 		/* parameter types */
-		if (trace_flags & TRACE_ITER_VERBOSE) {
+		if (global_trace_flags() & TRACE_ITER_VERBOSE) {
 			ret = trace_seq_printf(s, "%s ", entry->types[i]);
 			if (!ret)
 				return TRACE_TYPE_PARTIAL_LINE;
-- 
1.9.1.423.g4596e3a

