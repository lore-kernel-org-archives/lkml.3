Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab3B0Rub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:50:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22754 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760600Ab3B0RuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:50:03 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=LsK2J2nZ9SgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=HN0oG5qPuz4A:10 a=20KFwNOVAAAA:8 a=efaqhuXlXx2-n2e1KygA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=uOHyDuDE29-RT7me:21 a=DgEeBGFpi8OoTU9T:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130227174958.187886981@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 27 Feb 2013 12:22:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Subject: [for-next][PATCH 3/8] tracing: Encapsulate global_trace and remove dependencies on global
 vars
References: <20130227172232.707306533@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Encapsulate-global_trace-and-remove-dependen.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The global_trace variable in kernel/trace/trace.c has been kept 'static' and
local to that file so that it would not be used too much outside of that
file. This has paid off, even though there were lots of changes to make
the trace_array structure more generic (not depending on global_trace).

Removal of a lot of direct usages of global_trace is needed to be able to
create more trace_arrays such that we can add multiple buffers.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |  510 ++++++++++++++++++++++++++++----------------------
 kernel/trace/trace.h |   19 ++
 2 files changed, 306 insertions(+), 223 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e06f1aa..13c5809 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1,7 +1,7 @@
 /*
  * ring buffer based function tracer
  *
- * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
+ * Copyright (C) 2007-2012 Steven Rostedt <srostedt@redhat.com>
  * Copyright (C) 2008 Ingo Molnar <mingo@redhat.com>
  *
  * Originally taken from the RT patch by:
@@ -251,9 +251,6 @@ static unsigned long		trace_buf_size = TRACE_BUF_SIZE_DEFAULT;
 /* trace_types holds a link list of available tracers. */
 static struct tracer		*trace_types __read_mostly;
 
-/* current_trace points to the tracer that is currently active */
-static struct tracer		*current_trace __read_mostly = &nop_trace;
-
 /*
  * trace_types_lock is used to protect the trace_types list.
  */
@@ -350,9 +347,6 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
 	TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS;
 
-static int trace_stop_count;
-static DEFINE_RAW_SPINLOCK(tracing_start_lock);
-
 /**
  * trace_wake_up - wake up tasks waiting for trace input
  *
@@ -708,14 +702,14 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
 	struct ring_buffer *buf = tr->buffer;
 
-	if (trace_stop_count)
+	if (tr->stop_count)
 		return;
 
 	WARN_ON_ONCE(!irqs_disabled());
 
-	if (!current_trace->allocated_snapshot) {
+	if (!tr->current_trace->allocated_snapshot) {
 		/* Only the nop tracer should hit this when disabling */
-		WARN_ON_ONCE(current_trace != &nop_trace);
+		WARN_ON_ONCE(tr->current_trace != &nop_trace);
 		return;
 	}
 
@@ -741,11 +735,11 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
 	int ret;
 
-	if (trace_stop_count)
+	if (tr->stop_count)
 		return;
 
 	WARN_ON_ONCE(!irqs_disabled());
-	if (WARN_ON_ONCE(!current_trace->allocated_snapshot))
+	if (WARN_ON_ONCE(!tr->current_trace->allocated_snapshot))
 		return;
 
 	arch_spin_lock(&ftrace_max_lock);
@@ -852,8 +846,8 @@ int register_tracer(struct tracer *type)
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 	if (type->selftest && !tracing_selftest_disabled) {
-		struct tracer *saved_tracer = current_trace;
 		struct trace_array *tr = &global_trace;
+		struct tracer *saved_tracer = tr->current_trace;
 
 		/*
 		 * Run a selftest on this tracer.
@@ -864,7 +858,7 @@ int register_tracer(struct tracer *type)
 		 */
 		tracing_reset_online_cpus(tr);
 
-		current_trace = type;
+		tr->current_trace = type;
 
 		if (type->use_max_tr) {
 			/* If we expanded the buffers, make sure the max is expanded too */
@@ -878,7 +872,7 @@ int register_tracer(struct tracer *type)
 		pr_info("Testing tracer %s: ", type->name);
 		ret = type->selftest(type, tr);
 		/* the test is responsible for resetting too */
-		current_trace = saved_tracer;
+		tr->current_trace = saved_tracer;
 		if (ret) {
 			printk(KERN_CONT "FAILED!\n");
 			/* Add the warning after printing 'FAILED' */
@@ -996,7 +990,7 @@ static void trace_init_cmdlines(void)
 
 int is_tracing_stopped(void)
 {
-	return trace_stop_count;
+	return global_trace.stop_count;
 }
 
 /**
@@ -1028,12 +1022,12 @@ void tracing_start(void)
 	if (tracing_disabled)
 		return;
 
-	raw_spin_lock_irqsave(&tracing_start_lock, flags);
-	if (--trace_stop_count) {
-		if (trace_stop_count < 0) {
+	raw_spin_lock_irqsave(&global_trace.start_lock, flags);
+	if (--global_trace.stop_count) {
+		if (global_trace.stop_count < 0) {
 			/* Someone screwed up their debugging */
 			WARN_ON_ONCE(1);
-			trace_stop_count = 0;
+			global_trace.stop_count = 0;
 		}
 		goto out;
 	}
@@ -1053,7 +1047,38 @@ void tracing_start(void)
 
 	ftrace_start();
  out:
-	raw_spin_unlock_irqrestore(&tracing_start_lock, flags);
+	raw_spin_unlock_irqrestore(&global_trace.start_lock, flags);
+}
+
+static void tracing_start_tr(struct trace_array *tr)
+{
+	struct ring_buffer *buffer;
+	unsigned long flags;
+
+	if (tracing_disabled)
+		return;
+
+	/* If global, we need to also start the max tracer */
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL)
+		return tracing_start();
+
+	raw_spin_lock_irqsave(&tr->start_lock, flags);
+
+	if (--tr->stop_count) {
+		if (tr->stop_count < 0) {
+			/* Someone screwed up their debugging */
+			WARN_ON_ONCE(1);
+			tr->stop_count = 0;
+		}
+		goto out;
+	}
+
+	buffer = tr->buffer;
+	if (buffer)
+		ring_buffer_record_enable(buffer);
+
+ out:
+	raw_spin_unlock_irqrestore(&tr->start_lock, flags);
 }
 
 /**
@@ -1068,8 +1093,8 @@ void tracing_stop(void)
 	unsigned long flags;
 
 	ftrace_stop();
-	raw_spin_lock_irqsave(&tracing_start_lock, flags);
-	if (trace_stop_count++)
+	raw_spin_lock_irqsave(&global_trace.start_lock, flags);
+	if (global_trace.stop_count++)
 		goto out;
 
 	/* Prevent the buffers from switching */
@@ -1086,7 +1111,28 @@ void tracing_stop(void)
 	arch_spin_unlock(&ftrace_max_lock);
 
  out:
-	raw_spin_unlock_irqrestore(&tracing_start_lock, flags);
+	raw_spin_unlock_irqrestore(&global_trace.start_lock, flags);
+}
+
+static void tracing_stop_tr(struct trace_array *tr)
+{
+	struct ring_buffer *buffer;
+	unsigned long flags;
+
+	/* If global, we need to also stop the max tracer */
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL)
+		return tracing_stop();
+
+	raw_spin_lock_irqsave(&tr->start_lock, flags);
+	if (tr->stop_count++)
+		goto out;
+
+	buffer = tr->buffer;
+	if (buffer)
+		ring_buffer_record_disable(buffer);
+
+ out:
+	raw_spin_unlock_irqrestore(&tr->start_lock, flags);
 }
 
 void trace_stop_cmdline_recording(void);
@@ -1955,6 +2001,7 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
 	struct trace_iterator *iter = m->private;
+	struct trace_array *tr = iter->tr;
 	int cpu_file = iter->cpu_file;
 	void *p = NULL;
 	loff_t l = 0;
@@ -1967,8 +2014,8 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 	 * will point to the same string as current_trace->name.
 	 */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(current_trace && iter->trace->name != current_trace->name))
-		*iter->trace = *current_trace;
+	if (unlikely(tr->current_trace && iter->trace->name != tr->current_trace->name))
+		*iter->trace = *tr->current_trace;
 	mutex_unlock(&trace_types_lock);
 
 	if (iter->snapshot && iter->trace->use_max_tr)
@@ -2098,7 +2145,7 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
 	struct trace_array *tr = iter->tr;
 	struct trace_array_cpu *data = tr->data[tr->cpu];
-	struct tracer *type = current_trace;
+	struct tracer *type = iter->trace;
 	unsigned long entries;
 	unsigned long total;
 	const char *name = "preemption";
@@ -2454,7 +2501,8 @@ static const struct seq_operations tracer_seq_ops = {
 static struct trace_iterator *
 __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 {
-	long cpu_file = (long) inode->i_private;
+	struct trace_cpu *tc = inode->i_private;
+	struct trace_array *tr = tc->tr;
 	struct trace_iterator *iter;
 	int cpu;
 
@@ -2479,19 +2527,20 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 	if (!iter->trace)
 		goto fail;
 
-	*iter->trace = *current_trace;
+	*iter->trace = *tr->current_trace;
 
 	if (!zalloc_cpumask_var(&iter->started, GFP_KERNEL))
 		goto fail;
 
-	if (current_trace->print_max || snapshot)
+	/* Currently only the top directory has a snapshot */
+	if (tr->current_trace->print_max || snapshot)
 		iter->tr = &max_tr;
 	else
-		iter->tr = &global_trace;
+		iter->tr = tr;
 	iter->snapshot = snapshot;
 	iter->pos = -1;
 	mutex_init(&iter->mutex);
-	iter->cpu_file = cpu_file;
+	iter->cpu_file = tc->cpu;
 
 	/* Notify the tracer early; before we stop tracing. */
 	if (iter->trace && iter->trace->open)
@@ -2507,7 +2556,7 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 
 	/* stop the trace while dumping if we are not opening "snapshot" */
 	if (!iter->snapshot)
-		tracing_stop();
+		tracing_stop_tr(tr);
 
 	if (iter->cpu_file == RING_BUFFER_ALL_CPUS) {
 		for_each_tracing_cpu(cpu) {
@@ -2554,6 +2603,7 @@ static int tracing_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
 	struct trace_iterator *iter;
+	struct trace_array *tr;
 	int cpu;
 
 	if (!(file->f_mode & FMODE_READ))
@@ -2561,6 +2611,12 @@ static int tracing_release(struct inode *inode, struct file *file)
 
 	iter = m->private;
 
+	/* Only the global tracer has a matching max_tr */
+	if (iter->tr == &max_tr)
+		tr = &global_trace;
+	else
+		tr = iter->tr;
+
 	mutex_lock(&trace_types_lock);
 	for_each_tracing_cpu(cpu) {
 		if (iter->buffer_iter[cpu])
@@ -2572,7 +2628,7 @@ static int tracing_release(struct inode *inode, struct file *file)
 
 	if (!iter->snapshot)
 		/* reenable tracing if it was previously enabled */
-		tracing_start();
+		tracing_start_tr(tr);
 	mutex_unlock(&trace_types_lock);
 
 	mutex_destroy(&iter->mutex);
@@ -2591,12 +2647,13 @@ static int tracing_open(struct inode *inode, struct file *file)
 	/* If this file was open for write, then erase contents */
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC)) {
-		long cpu = (long) inode->i_private;
+		struct trace_cpu *tc = inode->i_private;
+		struct trace_array *tr = tc->tr;
 
-		if (cpu == RING_BUFFER_ALL_CPUS)
-			tracing_reset_online_cpus(&global_trace);
+		if (tc->cpu == RING_BUFFER_ALL_CPUS)
+			tracing_reset_online_cpus(tr);
 		else
-			tracing_reset(&global_trace, cpu);
+			tracing_reset(tr, tc->cpu);
 	}
 
 	if (file->f_mode & FMODE_READ) {
@@ -2743,8 +2800,9 @@ static ssize_t
 tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 		      size_t count, loff_t *ppos)
 {
-	int err, cpu;
+	struct trace_array *tr = filp->private_data;
 	cpumask_var_t tracing_cpumask_new;
+	int err, cpu;
 
 	if (!alloc_cpumask_var(&tracing_cpumask_new, GFP_KERNEL))
 		return -ENOMEM;
@@ -2764,13 +2822,13 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 		 */
 		if (cpumask_test_cpu(cpu, tracing_cpumask) &&
 				!cpumask_test_cpu(cpu, tracing_cpumask_new)) {
-			atomic_inc(&global_trace.data[cpu]->disabled);
-			ring_buffer_record_disable_cpu(global_trace.buffer, cpu);
+			atomic_inc(&tr->data[cpu]->disabled);
+			ring_buffer_record_disable_cpu(tr->buffer, cpu);
 		}
 		if (!cpumask_test_cpu(cpu, tracing_cpumask) &&
 				cpumask_test_cpu(cpu, tracing_cpumask_new)) {
-			atomic_dec(&global_trace.data[cpu]->disabled);
-			ring_buffer_record_enable_cpu(global_trace.buffer, cpu);
+			atomic_dec(&tr->data[cpu]->disabled);
+			ring_buffer_record_enable_cpu(tr->buffer, cpu);
 		}
 	}
 	arch_spin_unlock(&ftrace_max_lock);
@@ -2799,12 +2857,13 @@ static const struct file_operations tracing_cpumask_fops = {
 static int tracing_trace_options_show(struct seq_file *m, void *v)
 {
 	struct tracer_opt *trace_opts;
+	struct trace_array *tr = m->private;
 	u32 tracer_flags;
 	int i;
 
 	mutex_lock(&trace_types_lock);
-	tracer_flags = current_trace->flags->val;
-	trace_opts = current_trace->flags->opts;
+	tracer_flags = tr->current_trace->flags->val;
+	trace_opts = tr->current_trace->flags->opts;
 
 	for (i = 0; trace_options[i]; i++) {
 		if (trace_flags & (1 << i))
@@ -2880,7 +2939,7 @@ static void set_tracer_flags(unsigned int mask, int enabled)
 		trace_printk_start_stop_comm(enabled);
 }
 
-static int trace_set_options(char *option)
+static int trace_set_options(struct trace_array *tr, char *option)
 {
 	char *cmp;
 	int neg = 0;
@@ -2904,7 +2963,7 @@ static int trace_set_options(char *option)
 	/* If no option could be set, test the specific tracer options */
 	if (!trace_options[i]) {
 		mutex_lock(&trace_types_lock);
-		ret = set_tracer_option(current_trace, cmp, neg);
+		ret = set_tracer_option(tr->current_trace, cmp, neg);
 		mutex_unlock(&trace_types_lock);
 	}
 
@@ -2915,6 +2974,8 @@ static ssize_t
 tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 			size_t cnt, loff_t *ppos)
 {
+	struct seq_file *m = filp->private_data;
+	struct trace_array *tr = m->private;
 	char buf[64];
 
 	if (cnt >= sizeof(buf))
@@ -2925,7 +2986,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 
 	buf[cnt] = 0;
 
-	trace_set_options(buf);
+	trace_set_options(tr, buf);
 
 	*ppos += cnt;
 
@@ -2936,7 +2997,8 @@ static int tracing_trace_options_open(struct inode *inode, struct file *file)
 {
 	if (tracing_disabled)
 		return -ENODEV;
-	return single_open(file, tracing_trace_options_show, NULL);
+
+	return single_open(file, tracing_trace_options_show, inode->i_private);
 }
 
 static const struct file_operations tracing_iter_fops = {
@@ -3034,11 +3096,12 @@ static ssize_t
 tracing_set_trace_read(struct file *filp, char __user *ubuf,
 		       size_t cnt, loff_t *ppos)
 {
+	struct trace_array *tr = filp->private_data;
 	char buf[MAX_TRACER_SIZE+2];
 	int r;
 
 	mutex_lock(&trace_types_lock);
-	r = sprintf(buf, "%s\n", current_trace->name);
+	r = sprintf(buf, "%s\n", tr->current_trace->name);
 	mutex_unlock(&trace_types_lock);
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
@@ -3082,7 +3145,8 @@ static int resize_buffer_duplicate_size(struct trace_array *tr,
 	return ret;
 }
 
-static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
+static int __tracing_resize_ring_buffer(struct trace_array *tr,
+					unsigned long size, int cpu)
 {
 	int ret;
 
@@ -3094,20 +3158,20 @@ static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
 	ring_buffer_expanded = 1;
 
 	/* May be called before buffers are initialized */
-	if (!global_trace.buffer)
+	if (!tr->buffer)
 		return 0;
 
-	ret = ring_buffer_resize(global_trace.buffer, size, cpu);
+	ret = ring_buffer_resize(tr->buffer, size, cpu);
 	if (ret < 0)
 		return ret;
 
-	if (!current_trace->use_max_tr)
+	if (!(tr->flags & TRACE_ARRAY_FL_GLOBAL) ||
+	    !tr->current_trace->use_max_tr)
 		goto out;
 
 	ret = ring_buffer_resize(max_tr.buffer, size, cpu);
 	if (ret < 0) {
-		int r = resize_buffer_duplicate_size(&global_trace,
-						     &global_trace, cpu);
+		int r = resize_buffer_duplicate_size(tr, tr, cpu);
 		if (r < 0) {
 			/*
 			 * AARGH! We are left with different
@@ -3136,14 +3200,15 @@ static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
 
  out:
 	if (cpu == RING_BUFFER_ALL_CPUS)
-		set_buffer_entries(&global_trace, size);
+		set_buffer_entries(tr, size);
 	else
-		global_trace.data[cpu]->entries = size;
+		tr->data[cpu]->entries = size;
 
 	return ret;
 }
 
-static ssize_t tracing_resize_ring_buffer(unsigned long size, int cpu_id)
+static ssize_t tracing_resize_ring_buffer(struct trace_array *tr,
+					  unsigned long size, int cpu_id)
 {
 	int ret = size;
 
@@ -3157,7 +3222,7 @@ static ssize_t tracing_resize_ring_buffer(unsigned long size, int cpu_id)
 		}
 	}
 
-	ret = __tracing_resize_ring_buffer(size, cpu_id);
+	ret = __tracing_resize_ring_buffer(tr, size, cpu_id);
 	if (ret < 0)
 		ret = -ENOMEM;
 
@@ -3184,7 +3249,7 @@ int tracing_update_buffers(void)
 
 	mutex_lock(&trace_types_lock);
 	if (!ring_buffer_expanded)
-		ret = __tracing_resize_ring_buffer(trace_buf_size,
+		ret = __tracing_resize_ring_buffer(&global_trace, trace_buf_size,
 						RING_BUFFER_ALL_CPUS);
 	mutex_unlock(&trace_types_lock);
 
@@ -3194,7 +3259,7 @@ int tracing_update_buffers(void)
 struct trace_option_dentry;
 
 static struct trace_option_dentry *
-create_trace_option_files(struct tracer *tracer);
+create_trace_option_files(struct trace_array *tr, struct tracer *tracer);
 
 static void
 destroy_trace_option_files(struct trace_option_dentry *topts);
@@ -3210,7 +3275,7 @@ static int tracing_set_tracer(const char *buf)
 	mutex_lock(&trace_types_lock);
 
 	if (!ring_buffer_expanded) {
-		ret = __tracing_resize_ring_buffer(trace_buf_size,
+		ret = __tracing_resize_ring_buffer(tr, trace_buf_size,
 						RING_BUFFER_ALL_CPUS);
 		if (ret < 0)
 			goto out;
@@ -3225,15 +3290,15 @@ static int tracing_set_tracer(const char *buf)
 		ret = -EINVAL;
 		goto out;
 	}
-	if (t == current_trace)
+	if (t == tr->current_trace)
 		goto out;
 
 	trace_branch_disable();
-	if (current_trace->reset)
-		current_trace->reset(tr);
+	if (tr->current_trace->reset)
+		tr->current_trace->reset(tr);
 
-	had_max_tr = current_trace->allocated_snapshot;
-	current_trace = &nop_trace;
+	had_max_tr = tr->current_trace->allocated_snapshot;
+	tr->current_trace = &nop_trace;
 
 	if (had_max_tr && !t->use_max_tr) {
 		/*
@@ -3252,11 +3317,11 @@ static int tracing_set_tracer(const char *buf)
 		ring_buffer_resize(max_tr.buffer, 1, RING_BUFFER_ALL_CPUS);
 		set_buffer_entries(&max_tr, 1);
 		tracing_reset_online_cpus(&max_tr);
-		current_trace->allocated_snapshot = false;
+		tr->current_trace->allocated_snapshot = false;
 	}
 	destroy_trace_option_files(topts);
 
-	topts = create_trace_option_files(t);
+	topts = create_trace_option_files(tr, t);
 	if (t->use_max_tr && !had_max_tr) {
 		/* we need to make per cpu buffer sizes equivalent */
 		ret = resize_buffer_duplicate_size(&max_tr, &global_trace,
@@ -3272,7 +3337,7 @@ static int tracing_set_tracer(const char *buf)
 			goto out;
 	}
 
-	current_trace = t;
+	tr->current_trace = t;
 	trace_branch_enable(tr);
  out:
 	mutex_unlock(&trace_types_lock);
@@ -3346,7 +3411,8 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
 
 static int tracing_open_pipe(struct inode *inode, struct file *filp)
 {
-	long cpu_file = (long) inode->i_private;
+	struct trace_cpu *tc = inode->i_private;
+	struct trace_array *tr = tc->tr;
 	struct trace_iterator *iter;
 	int ret = 0;
 
@@ -3371,7 +3437,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 		ret = -ENOMEM;
 		goto fail;
 	}
-	*iter->trace = *current_trace;
+	*iter->trace = *tr->current_trace;
 
 	if (!alloc_cpumask_var(&iter->started, GFP_KERNEL)) {
 		ret = -ENOMEM;
@@ -3388,8 +3454,8 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 	if (trace_clocks[trace_clock_id].in_ns)
 		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
 
-	iter->cpu_file = cpu_file;
-	iter->tr = &global_trace;
+	iter->cpu_file = tc->cpu;
+	iter->tr = tc->tr;
 	mutex_init(&iter->mutex);
 	filp->private_data = iter;
 
@@ -3511,6 +3577,7 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 		  size_t cnt, loff_t *ppos)
 {
 	struct trace_iterator *iter = filp->private_data;
+	struct trace_array *tr = iter->tr;
 	ssize_t sret;
 
 	/* return any leftover data */
@@ -3522,8 +3589,8 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(iter->trace->name != current_trace->name))
-		*iter->trace = *current_trace;
+	if (unlikely(iter->trace->name != tr->current_trace->name))
+		*iter->trace = *tr->current_trace;
 	mutex_unlock(&trace_types_lock);
 
 	/*
@@ -3679,6 +3746,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		.ops		= &tracing_pipe_buf_ops,
 		.spd_release	= tracing_spd_release_pipe,
 	};
+	struct trace_array *tr = iter->tr;
 	ssize_t ret;
 	size_t rem;
 	unsigned int i;
@@ -3688,8 +3756,8 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(iter->trace->name != current_trace->name))
-		*iter->trace = *current_trace;
+	if (unlikely(iter->trace->name != tr->current_trace->name))
+		*iter->trace = *tr->current_trace;
 	mutex_unlock(&trace_types_lock);
 
 	mutex_lock(&iter->mutex);
@@ -3751,43 +3819,19 @@ out_err:
 	goto out;
 }
 
-struct ftrace_entries_info {
-	struct trace_array	*tr;
-	int			cpu;
-};
-
-static int tracing_entries_open(struct inode *inode, struct file *filp)
-{
-	struct ftrace_entries_info *info;
-
-	if (tracing_disabled)
-		return -ENODEV;
-
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
-
-	info->tr = &global_trace;
-	info->cpu = (unsigned long)inode->i_private;
-
-	filp->private_data = info;
-
-	return 0;
-}
-
 static ssize_t
 tracing_entries_read(struct file *filp, char __user *ubuf,
 		     size_t cnt, loff_t *ppos)
 {
-	struct ftrace_entries_info *info = filp->private_data;
-	struct trace_array *tr = info->tr;
+	struct trace_cpu *tc = filp->private_data;
+	struct trace_array *tr = tc->tr;
 	char buf[64];
 	int r = 0;
 	ssize_t ret;
 
 	mutex_lock(&trace_types_lock);
 
-	if (info->cpu == RING_BUFFER_ALL_CPUS) {
+	if (tc->cpu == RING_BUFFER_ALL_CPUS) {
 		int cpu, buf_size_same;
 		unsigned long size;
 
@@ -3814,7 +3858,7 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
 		} else
 			r = sprintf(buf, "X\n");
 	} else
-		r = sprintf(buf, "%lu\n", tr->data[info->cpu]->entries >> 10);
+		r = sprintf(buf, "%lu\n", tr->data[tc->cpu]->entries >> 10);
 
 	mutex_unlock(&trace_types_lock);
 
@@ -3826,7 +3870,7 @@ static ssize_t
 tracing_entries_write(struct file *filp, const char __user *ubuf,
 		      size_t cnt, loff_t *ppos)
 {
-	struct ftrace_entries_info *info = filp->private_data;
+	struct trace_cpu *tc = filp->private_data;
 	unsigned long val;
 	int ret;
 
@@ -3841,7 +3885,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	/* value is in KB */
 	val <<= 10;
 
-	ret = tracing_resize_ring_buffer(val, info->cpu);
+	ret = tracing_resize_ring_buffer(tc->tr, val, tc->cpu);
 	if (ret < 0)
 		return ret;
 
@@ -3850,16 +3894,6 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
-static int
-tracing_entries_release(struct inode *inode, struct file *filp)
-{
-	struct ftrace_entries_info *info = filp->private_data;
-
-	kfree(info);
-
-	return 0;
-}
-
 static ssize_t
 tracing_total_entries_read(struct file *filp, char __user *ubuf,
 				size_t cnt, loff_t *ppos)
@@ -3901,11 +3935,13 @@ tracing_free_buffer_write(struct file *filp, const char __user *ubuf,
 static int
 tracing_free_buffer_release(struct inode *inode, struct file *filp)
 {
+	struct trace_array *tr = inode->i_private;
+
 	/* disable tracing ? */
 	if (trace_flags & TRACE_ITER_STOP_ON_FREE)
 		tracing_off();
 	/* resize the ring buffer to 0 */
-	tracing_resize_ring_buffer(0, RING_BUFFER_ALL_CPUS);
+	tracing_resize_ring_buffer(tr, 0, RING_BUFFER_ALL_CPUS);
 
 	return 0;
 }
@@ -4016,13 +4052,14 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 
 static int tracing_clock_show(struct seq_file *m, void *v)
 {
+	struct trace_array *tr = m->private;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(trace_clocks); i++)
 		seq_printf(m,
 			"%s%s%s%s", i ? " " : "",
-			i == trace_clock_id ? "[" : "", trace_clocks[i].name,
-			i == trace_clock_id ? "]" : "");
+			i == tr->clock_id ? "[" : "", trace_clocks[i].name,
+			i == tr->clock_id ? "]" : "");
 	seq_putc(m, '\n');
 
 	return 0;
@@ -4031,6 +4068,8 @@ static int tracing_clock_show(struct seq_file *m, void *v)
 static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 				   size_t cnt, loff_t *fpos)
 {
+	struct seq_file *m = filp->private_data;
+	struct trace_array *tr = m->private;
 	char buf[64];
 	const char *clockstr;
 	int i;
@@ -4052,12 +4091,12 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 	if (i == ARRAY_SIZE(trace_clocks))
 		return -EINVAL;
 
-	trace_clock_id = i;
-
 	mutex_lock(&trace_types_lock);
 
-	ring_buffer_set_clock(global_trace.buffer, trace_clocks[i].func);
-	if (max_tr.buffer)
+	tr->clock_id = i;
+
+	ring_buffer_set_clock(tr->buffer, trace_clocks[i].func);
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL && max_tr.buffer)
 		ring_buffer_set_clock(max_tr.buffer, trace_clocks[i].func);
 
 	/*
@@ -4078,7 +4117,8 @@ static int tracing_clock_open(struct inode *inode, struct file *file)
 {
 	if (tracing_disabled)
 		return -ENODEV;
-	return single_open(file, tracing_clock_show, NULL);
+
+	return single_open(file, tracing_clock_show, inode->i_private);
 }
 
 #ifdef CONFIG_TRACER_SNAPSHOT
@@ -4099,6 +4139,7 @@ static ssize_t
 tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		       loff_t *ppos)
 {
+	struct trace_array *tr = filp->private_data;
 	unsigned long val;
 	int ret;
 
@@ -4112,30 +4153,30 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	mutex_lock(&trace_types_lock);
 
-	if (current_trace->use_max_tr) {
+	if (tr->current_trace->use_max_tr) {
 		ret = -EBUSY;
 		goto out;
 	}
 
 	switch (val) {
 	case 0:
-		if (current_trace->allocated_snapshot) {
+		if (tr->current_trace->allocated_snapshot) {
 			/* free spare buffer */
 			ring_buffer_resize(max_tr.buffer, 1,
 					   RING_BUFFER_ALL_CPUS);
 			set_buffer_entries(&max_tr, 1);
 			tracing_reset_online_cpus(&max_tr);
-			current_trace->allocated_snapshot = false;
+			tr->current_trace->allocated_snapshot = false;
 		}
 		break;
 	case 1:
-		if (!current_trace->allocated_snapshot) {
+		if (!tr->current_trace->allocated_snapshot) {
 			/* allocate spare buffer */
 			ret = resize_buffer_duplicate_size(&max_tr,
 					&global_trace, RING_BUFFER_ALL_CPUS);
 			if (ret < 0)
 				break;
-			current_trace->allocated_snapshot = true;
+			tr->current_trace->allocated_snapshot = true;
 		}
 
 		local_irq_disable();
@@ -4144,7 +4185,7 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		local_irq_enable();
 		break;
 	default:
-		if (current_trace->allocated_snapshot)
+		if (tr->current_trace->allocated_snapshot)
 			tracing_reset_online_cpus(&max_tr);
 		else
 			ret = -EINVAL;
@@ -4186,10 +4227,9 @@ static const struct file_operations tracing_pipe_fops = {
 };
 
 static const struct file_operations tracing_entries_fops = {
-	.open		= tracing_entries_open,
+	.open		= tracing_open_generic,
 	.read		= tracing_entries_read,
 	.write		= tracing_entries_write,
-	.release	= tracing_entries_release,
 	.llseek		= generic_file_llseek,
 };
 
@@ -4237,7 +4277,8 @@ struct ftrace_buffer_info {
 
 static int tracing_buffers_open(struct inode *inode, struct file *filp)
 {
-	int cpu = (int)(long)inode->i_private;
+	struct trace_cpu *tc = inode->i_private;
+	struct trace_array *tr = tc->tr;
 	struct ftrace_buffer_info *info;
 
 	if (tracing_disabled)
@@ -4247,8 +4288,8 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 	if (!info)
 		return -ENOMEM;
 
-	info->tr	= &global_trace;
-	info->cpu	= cpu;
+	info->tr	= tr;
+	info->cpu	= tc->cpu;
 	info->spare	= NULL;
 	/* Force reading ring buffer for first read */
 	info->read	= (unsigned int)-1;
@@ -4485,12 +4526,13 @@ static ssize_t
 tracing_stats_read(struct file *filp, char __user *ubuf,
 		   size_t count, loff_t *ppos)
 {
-	unsigned long cpu = (unsigned long)filp->private_data;
-	struct trace_array *tr = &global_trace;
+	struct trace_cpu *tc = filp->private_data;
+	struct trace_array *tr = tc->tr;
 	struct trace_seq *s;
 	unsigned long cnt;
 	unsigned long long t;
 	unsigned long usec_rem;
+	int cpu = tc->cpu;
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
@@ -4586,58 +4628,57 @@ static const struct file_operations tracing_dyn_info_fops = {
 };
 #endif
 
-static struct dentry *d_tracer;
-
-struct dentry *tracing_init_dentry(void)
+struct dentry *tracing_init_dentry_tr(struct trace_array *tr)
 {
 	static int once;
 
-	if (d_tracer)
-		return d_tracer;
+	if (tr->dir)
+		return tr->dir;
 
 	if (!debugfs_initialized())
 		return NULL;
 
-	d_tracer = debugfs_create_dir("tracing", NULL);
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL)
+		tr->dir = debugfs_create_dir("tracing", NULL);
 
-	if (!d_tracer && !once) {
+	if (!tr->dir && !once) {
 		once = 1;
 		pr_warning("Could not create debugfs directory 'tracing'\n");
 		return NULL;
 	}
 
-	return d_tracer;
+	return tr->dir;
 }
 
-static struct dentry *d_percpu;
+struct dentry *tracing_init_dentry(void)
+{
+	return tracing_init_dentry_tr(&global_trace);
+}
 
-static struct dentry *tracing_dentry_percpu(void)
+static struct dentry *tracing_dentry_percpu(struct trace_array *tr, int cpu)
 {
-	static int once;
 	struct dentry *d_tracer;
 
-	if (d_percpu)
-		return d_percpu;
-
-	d_tracer = tracing_init_dentry();
+	if (tr->percpu_dir)
+		return tr->percpu_dir;
 
+	d_tracer = tracing_init_dentry_tr(tr);
 	if (!d_tracer)
 		return NULL;
 
-	d_percpu = debugfs_create_dir("per_cpu", d_tracer);
+	tr->percpu_dir = debugfs_create_dir("per_cpu", d_tracer);
 
-	if (!d_percpu && !once) {
-		once = 1;
-		pr_warning("Could not create debugfs directory 'per_cpu'\n");
-		return NULL;
-	}
+	WARN_ONCE(!tr->percpu_dir,
+		  "Could not create debugfs directory 'per_cpu/%d'\n", cpu);
 
-	return d_percpu;
+	return tr->percpu_dir;
 }
 
-static void tracing_init_debugfs_percpu(long cpu)
+static void
+tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 {
-	struct dentry *d_percpu = tracing_dentry_percpu();
+	struct trace_array_cpu *data = tr->data[cpu];
+	struct dentry *d_percpu = tracing_dentry_percpu(tr, cpu);
 	struct dentry *d_cpu;
 	char cpu_dir[30]; /* 30 characters should be more than enough */
 
@@ -4653,20 +4694,20 @@ static void tracing_init_debugfs_percpu(long cpu)
 
 	/* per cpu trace_pipe */
 	trace_create_file("trace_pipe", 0444, d_cpu,
-			(void *) cpu, &tracing_pipe_fops);
+			(void *)&data->trace_cpu, &tracing_pipe_fops);
 
 	/* per cpu trace */
 	trace_create_file("trace", 0644, d_cpu,
-			(void *) cpu, &tracing_fops);
+			(void *)&data->trace_cpu, &tracing_fops);
 
 	trace_create_file("trace_pipe_raw", 0444, d_cpu,
-			(void *) cpu, &tracing_buffers_fops);
+			(void *)&data->trace_cpu, &tracing_buffers_fops);
 
 	trace_create_file("stats", 0444, d_cpu,
-			(void *) cpu, &tracing_stats_fops);
+			(void *)&data->trace_cpu, &tracing_stats_fops);
 
 	trace_create_file("buffer_size_kb", 0444, d_cpu,
-			(void *) cpu, &tracing_entries_fops);
+			(void *)&data->trace_cpu, &tracing_entries_fops);
 }
 
 #ifdef CONFIG_FTRACE_SELFTEST
@@ -4677,6 +4718,7 @@ static void tracing_init_debugfs_percpu(long cpu)
 struct trace_option_dentry {
 	struct tracer_opt		*opt;
 	struct tracer_flags		*flags;
+	struct trace_array		*tr;
 	struct dentry			*entry;
 };
 
@@ -4712,7 +4754,7 @@ trace_options_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 	if (!!(topt->flags->val & topt->opt->bit) != val) {
 		mutex_lock(&trace_types_lock);
-		ret = __set_tracer_option(current_trace, topt->flags,
+		ret = __set_tracer_option(topt->tr->current_trace, topt->flags,
 					  topt->opt, !val);
 		mutex_unlock(&trace_types_lock);
 		if (ret)
@@ -4791,40 +4833,41 @@ struct dentry *trace_create_file(const char *name,
 }
 
 
-static struct dentry *trace_options_init_dentry(void)
+static struct dentry *trace_options_init_dentry(struct trace_array *tr)
 {
 	struct dentry *d_tracer;
-	static struct dentry *t_options;
 
-	if (t_options)
-		return t_options;
+	if (tr->options)
+		return tr->options;
 
-	d_tracer = tracing_init_dentry();
+	d_tracer = tracing_init_dentry_tr(tr);
 	if (!d_tracer)
 		return NULL;
 
-	t_options = debugfs_create_dir("options", d_tracer);
-	if (!t_options) {
+	tr->options = debugfs_create_dir("options", d_tracer);
+	if (!tr->options) {
 		pr_warning("Could not create debugfs directory 'options'\n");
 		return NULL;
 	}
 
-	return t_options;
+	return tr->options;
 }
 
 static void
-create_trace_option_file(struct trace_option_dentry *topt,
+create_trace_option_file(struct trace_array *tr,
+			 struct trace_option_dentry *topt,
 			 struct tracer_flags *flags,
 			 struct tracer_opt *opt)
 {
 	struct dentry *t_options;
 
-	t_options = trace_options_init_dentry();
+	t_options = trace_options_init_dentry(tr);
 	if (!t_options)
 		return;
 
 	topt->flags = flags;
 	topt->opt = opt;
+	topt->tr = tr;
 
 	topt->entry = trace_create_file(opt->name, 0644, t_options, topt,
 				    &trace_options_fops);
@@ -4832,7 +4875,7 @@ create_trace_option_file(struct trace_option_dentry *topt,
 }
 
 static struct trace_option_dentry *
-create_trace_option_files(struct tracer *tracer)
+create_trace_option_files(struct trace_array *tr, struct tracer *tracer)
 {
 	struct trace_option_dentry *topts;
 	struct tracer_flags *flags;
@@ -4857,7 +4900,7 @@ create_trace_option_files(struct tracer *tracer)
 		return NULL;
 
 	for (cnt = 0; opts[cnt].name; cnt++)
-		create_trace_option_file(&topts[cnt], flags,
+		create_trace_option_file(tr, &topts[cnt], flags,
 					 &opts[cnt]);
 
 	return topts;
@@ -4880,11 +4923,12 @@ destroy_trace_option_files(struct trace_option_dentry *topts)
 }
 
 static struct dentry *
-create_trace_option_core_file(const char *option, long index)
+create_trace_option_core_file(struct trace_array *tr,
+			      const char *option, long index)
 {
 	struct dentry *t_options;
 
-	t_options = trace_options_init_dentry();
+	t_options = trace_options_init_dentry(tr);
 	if (!t_options)
 		return NULL;
 
@@ -4892,17 +4936,17 @@ create_trace_option_core_file(const char *option, long index)
 				    &trace_options_core_fops);
 }
 
-static __init void create_trace_options_dir(void)
+static __init void create_trace_options_dir(struct trace_array *tr)
 {
 	struct dentry *t_options;
 	int i;
 
-	t_options = trace_options_init_dentry();
+	t_options = trace_options_init_dentry(tr);
 	if (!t_options)
 		return;
 
 	for (i = 0; trace_options[i]; i++)
-		create_trace_option_core_file(trace_options[i], i);
+		create_trace_option_core_file(tr, trace_options[i], i);
 }
 
 static ssize_t
@@ -4941,12 +4985,12 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
 		mutex_lock(&trace_types_lock);
 		if (val) {
 			ring_buffer_record_on(buffer);
-			if (current_trace->start)
-				current_trace->start(tr);
+			if (tr->current_trace->start)
+				tr->current_trace->start(tr);
 		} else {
 			ring_buffer_record_off(buffer);
-			if (current_trace->stop)
-				current_trace->stop(tr);
+			if (tr->current_trace->stop)
+				tr->current_trace->stop(tr);
 		}
 		mutex_unlock(&trace_types_lock);
 	}
@@ -4963,6 +5007,38 @@ static const struct file_operations rb_simple_fops = {
 	.llseek		= default_llseek,
 };
 
+static void
+init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
+{
+
+	trace_create_file("trace_options", 0644, d_tracer,
+			  tr, &tracing_iter_fops);
+
+	trace_create_file("trace", 0644, d_tracer,
+			(void *)&tr->trace_cpu, &tracing_fops);
+
+	trace_create_file("trace_pipe", 0444, d_tracer,
+			(void *)&tr->trace_cpu, &tracing_pipe_fops);
+
+	trace_create_file("buffer_size_kb", 0644, d_tracer,
+			(void *)&tr->trace_cpu, &tracing_entries_fops);
+
+	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
+			  tr, &tracing_total_entries_fops);
+
+	trace_create_file("free_buffer", 0644, d_tracer,
+			  tr, &tracing_free_buffer_fops);
+
+	trace_create_file("trace_marker", 0220, d_tracer,
+			  tr, &tracing_mark_fops);
+
+	trace_create_file("trace_clock", 0644, d_tracer, tr,
+			  &trace_clock_fops);
+
+	trace_create_file("tracing_on", 0644, d_tracer,
+			    tr, &rb_simple_fops);
+}
+
 static __init int tracer_init_debugfs(void)
 {
 	struct dentry *d_tracer;
@@ -4972,14 +5048,10 @@ static __init int tracer_init_debugfs(void)
 
 	d_tracer = tracing_init_dentry();
 
-	trace_create_file("trace_options", 0644, d_tracer,
-			NULL, &tracing_iter_fops);
+	init_tracer_debugfs(&global_trace, d_tracer);
 
 	trace_create_file("tracing_cpumask", 0644, d_tracer,
-			NULL, &tracing_cpumask_fops);
-
-	trace_create_file("trace", 0644, d_tracer,
-			(void *) RING_BUFFER_ALL_CPUS, &tracing_fops);
+			&global_trace, &tracing_cpumask_fops);
 
 	trace_create_file("available_tracers", 0444, d_tracer,
 			&global_trace, &show_traces_fops);
@@ -4998,30 +5070,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("README", 0444, d_tracer,
 			NULL, &tracing_readme_fops);
 
-	trace_create_file("trace_pipe", 0444, d_tracer,
-			(void *) RING_BUFFER_ALL_CPUS, &tracing_pipe_fops);
-
-	trace_create_file("buffer_size_kb", 0644, d_tracer,
-			(void *) RING_BUFFER_ALL_CPUS, &tracing_entries_fops);
-
-	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
-			&global_trace, &tracing_total_entries_fops);
-
-	trace_create_file("free_buffer", 0644, d_tracer,
-			&global_trace, &tracing_free_buffer_fops);
-
-	trace_create_file("trace_marker", 0220, d_tracer,
-			NULL, &tracing_mark_fops);
-
 	trace_create_file("saved_cmdlines", 0444, d_tracer,
 			NULL, &tracing_saved_cmdlines_fops);
 
-	trace_create_file("trace_clock", 0644, d_tracer, NULL,
-			  &trace_clock_fops);
-
-	trace_create_file("tracing_on", 0644, d_tracer,
-			    &global_trace, &rb_simple_fops);
-
 #ifdef CONFIG_DYNAMIC_FTRACE
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
@@ -5029,13 +5080,13 @@ static __init int tracer_init_debugfs(void)
 
 #ifdef CONFIG_TRACER_SNAPSHOT
 	trace_create_file("snapshot", 0644, d_tracer,
-			  (void *) TRACE_PIPE_ALL_CPU, &snapshot_fops);
+			  (void *) RING_BUFFER_ALL_CPUS, &snapshot_fops);
 #endif
 
-	create_trace_options_dir();
+	create_trace_options_dir(&global_trace);
 
 	for_each_tracing_cpu(cpu)
-		tracing_init_debugfs_percpu(cpu);
+		tracing_init_debugfs_percpu(&global_trace, cpu);
 
 	return 0;
 }
@@ -5105,7 +5156,7 @@ trace_printk_seq(struct trace_seq *s)
 void trace_init_global_iter(struct trace_iterator *iter)
 {
 	iter->tr = &global_trace;
-	iter->trace = current_trace;
+	iter->trace = iter->tr->current_trace;
 	iter->cpu_file = RING_BUFFER_ALL_CPUS;
 }
 
@@ -5259,6 +5310,8 @@ __init static int tracer_alloc_buffers(void)
 	cpumask_copy(tracing_buffer_mask, cpu_possible_mask);
 	cpumask_copy(tracing_cpumask, cpu_all_mask);
 
+	raw_spin_lock_init(&global_trace.start_lock);
+
 	/* TODO: make the number of buffers hot pluggable with CPUS */
 	global_trace.buffer = ring_buffer_alloc(ring_buf_size, rb_flags);
 	if (!global_trace.buffer) {
@@ -5272,6 +5325,7 @@ __init static int tracer_alloc_buffers(void)
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 	max_tr.buffer = ring_buffer_alloc(1, rb_flags);
+	raw_spin_lock_init(&max_tr.start_lock);
 	if (!max_tr.buffer) {
 		printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
 		WARN_ON(1);
@@ -5283,7 +5337,11 @@ __init static int tracer_alloc_buffers(void)
 	/* Allocate the first page for all buffers */
 	for_each_tracing_cpu(i) {
 		global_trace.data[i] = &per_cpu(global_trace_cpu, i);
+		global_trace.data[i]->trace_cpu.cpu = i;
+		global_trace.data[i]->trace_cpu.tr = &global_trace;
 		max_tr.data[i] = &per_cpu(max_tr_data, i);
+		max_tr.data[i]->trace_cpu.cpu = i;
+		max_tr.data[i]->trace_cpu.tr = &max_tr;
 	}
 
 	set_buffer_entries(&global_trace,
@@ -5297,6 +5355,8 @@ __init static int tracer_alloc_buffers(void)
 
 	register_tracer(&nop_trace);
 
+	global_trace.current_trace = &nop_trace;
+
 	/* All seems OK, enable tracing */
 	tracing_disabled = 0;
 
@@ -5307,6 +5367,10 @@ __init static int tracer_alloc_buffers(void)
 
 	global_trace.flags = TRACE_ARRAY_FL_GLOBAL;
 
+	/* Holder for file callbacks */
+	global_trace.trace_cpu.cpu = RING_BUFFER_ALL_CPUS;
+	global_trace.trace_cpu.tr = &global_trace;
+
 	INIT_LIST_HEAD(&global_trace.systems);
 	INIT_LIST_HEAD(&global_trace.events);
 	list_add(&global_trace.list, &ftrace_trace_arrays);
@@ -5315,7 +5379,7 @@ __init static int tracer_alloc_buffers(void)
 		char *option;
 
 		option = strsep(&trace_boot_options, ",");
-		trace_set_options(option);
+		trace_set_options(&global_trace, option);
 	}
 
 	return 0;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 0698e49..0499cce 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -127,12 +127,21 @@ enum trace_flag_type {
 
 #define TRACE_BUF_SIZE		1024
 
+struct trace_array;
+
+struct trace_cpu {
+	struct trace_array	*tr;
+	struct dentry		*dir;
+	int			cpu;
+};
+
 /*
  * The CPU trace array - it consists of thousands of trace entries
  * plus some other descriptor data: (for example which task started
  * the trace, etc.)
  */
 struct trace_array_cpu {
+	struct trace_cpu	trace_cpu;
 	atomic_t		disabled;
 	void			*buffer_page;	/* ring buffer spare */
 
@@ -151,6 +160,8 @@ struct trace_array_cpu {
 	char			comm[TASK_COMM_LEN];
 };
 
+struct tracer;
+
 /*
  * The trace array - an array of per-CPU trace arrays. This is the
  * highest level data structure that individual tracers deal with.
@@ -161,9 +172,16 @@ struct trace_array {
 	struct list_head	list;
 	int			cpu;
 	int			buffer_disabled;
+	struct trace_cpu	trace_cpu;	/* place holder */
+	int			stop_count;
+	int			clock_id;
+	struct tracer		*current_trace;
 	unsigned int		flags;
 	cycle_t			time_start;
+	raw_spinlock_t		start_lock;
 	struct dentry		*dir;
+	struct dentry		*options;
+	struct dentry		*percpu_dir;
 	struct dentry		*event_dir;
 	struct list_head	systems;
 	struct list_head	events;
@@ -470,6 +488,7 @@ struct dentry *trace_create_file(const char *name,
 				 void *data,
 				 const struct file_operations *fops);
 
+struct dentry *tracing_init_dentry_tr(struct trace_array *tr);
 struct dentry *tracing_init_dentry(void);
 
 struct ring_buffer_event;
-- 
1.7.10.4


