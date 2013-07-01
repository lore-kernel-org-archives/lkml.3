Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab3GAWjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:39:44 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:53135 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3GAWjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:39:42 -0400
From: Alexander Z Lam <azl@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Subject: [PATCH 1/3] tracing: Use a ring buffer size of 1 when creating a new trace buffer
Date: Mon,  1 Jul 2013 15:31:23 -0700
Message-Id: <1372717885-4543-1-git-send-email-azl@google.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use deferred ring buffer allocation in new trace buffer instances by
copying the behavior of the deferred allocation of global_trace's buffer.
Without this, each new trace buffer instance will attempt to allocate
num_cpus * TRACE_BUF_SIZE_DEFAULT bytes for the ring buffer, which might
fail on a system with many cores. If this fails, the new instance is not
created, precluding the user from setting a smaller buffer for which
allocation might succeed.

Cc: David Sharp <dhsharp@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Alexander Z Lam <azl@google.com>
---
 kernel/trace/trace.c        | 92 +++++++++++++++++++++++++--------------------
 kernel/trace/trace.h        |  5 ++-
 kernel/trace/trace_events.c |  8 ++--
 3 files changed, 58 insertions(+), 47 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9e42e48..e0b0d2a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -44,12 +44,6 @@
 #include "trace_output.h"
 
 /*
- * On boot up, the ring buffer is set to the minimum size, so that
- * we do not waste memory on systems that are not using tracing.
- */
-bool ring_buffer_expanded;
-
-/*
  * We need to change this state when a selftest is running.
  * A selftest will lurk into the ring-buffer to count the
  * entries inserted during the selftest although some concurrent
@@ -86,6 +80,20 @@ static int dummy_set_flag(u32 old_flags, u32 bit, int set)
 static DEFINE_PER_CPU(bool, trace_cmdline_save);
 
 /*
+ * The global_trace is the descriptor that holds the tracing
+ * buffers for the live tracing. For each CPU, it contains
+ * a link list of pages that will store trace entries. The
+ * page descriptor of the pages in the memory is used to hold
+ * the link list by linking the lru item in the page descriptor
+ * to each of the pages in the buffer per CPU.
+ *
+ * For each active CPU there is a data field that holds the
+ * pages for the buffer for that CPU. Each CPU has the same number
+ * of pages allocated for its buffer.
+ */
+static struct trace_array	global_trace;
+
+/*
  * Kill all tracing for good (never come back).
  * It is initialized to 1 but will turn to zero if the initialization
  * of the tracer is successful. But that is the only place that sets
@@ -131,7 +139,7 @@ static int __init set_cmdline_ftrace(char *str)
 	strlcpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
 	default_bootup_tracer = bootup_tracer_buf;
 	/* We are using ftrace early, expand it */
-	ring_buffer_expanded = true;
+	global_trace.buffer_expanded = true;
 	return 1;
 }
 __setup("ftrace=", set_cmdline_ftrace);
@@ -163,7 +171,7 @@ static int __init boot_alloc_snapshot(char *str)
 {
 	allocate_snapshot = true;
 	/* We also need the main ring buffer expanded */
-	ring_buffer_expanded = true;
+	global_trace.buffer_expanded = true;
 	return 1;
 }
 __setup("alloc_snapshot", boot_alloc_snapshot);
@@ -188,20 +196,6 @@ unsigned long long ns2usecs(cycle_t nsec)
 	return nsec;
 }
 
-/*
- * The global_trace is the descriptor that holds the tracing
- * buffers for the live tracing. For each CPU, it contains
- * a link list of pages that will store trace entries. The
- * page descriptor of the pages in the memory is used to hold
- * the link list by linking the lru item in the page descriptor
- * to each of the pages in the buffer per CPU.
- *
- * For each active CPU there is a data field that holds the
- * pages for the buffer for that CPU. Each CPU has the same number
- * of pages allocated for its buffer.
- */
-static struct trace_array	global_trace;
-
 LIST_HEAD(ftrace_trace_arrays);
 
 int filter_current_check_discard(struct ring_buffer *buffer,
@@ -988,7 +982,7 @@ static int run_tracer_selftest(struct tracer *type)
 #ifdef CONFIG_TRACER_MAX_TRACE
 	if (type->use_max_tr) {
 		/* If we expanded the buffers, make sure the max is expanded too */
-		if (ring_buffer_expanded)
+		if (tr->buffer_expanded)
 			ring_buffer_resize(tr->max_buffer.buffer, trace_buf_size,
 					   RING_BUFFER_ALL_CPUS);
 		tr->allocated_snapshot = true;
@@ -1014,7 +1008,7 @@ static int run_tracer_selftest(struct tracer *type)
 		tr->allocated_snapshot = false;
 
 		/* Shrink the max buffer again */
-		if (ring_buffer_expanded)
+		if (tr->buffer_expanded)
 			ring_buffer_resize(tr->max_buffer.buffer, 1,
 					   RING_BUFFER_ALL_CPUS);
 	}
@@ -1863,7 +1857,7 @@ void trace_printk_init_buffers(void)
 	pr_info("ftrace: Allocated trace_printk buffers\n");
 
 	/* Expand the buffers to set size */
-	tracing_update_buffers();
+	tracing_update_buffers(&global_trace);
 
 	buffers_allocated = 1;
 
@@ -3538,7 +3532,7 @@ static int __tracing_resize_ring_buffer(struct trace_array *tr,
 	 * we use the size that was given, and we can forget about
 	 * expanding it later.
 	 */
-	ring_buffer_expanded = true;
+	tr->buffer_expanded = true;
 
 	/* May be called before buffers are initialized */
 	if (!tr->trace_buffer.buffer)
@@ -3578,11 +3572,6 @@ static int __tracing_resize_ring_buffer(struct trace_array *tr,
 		return ret;
 	}
 
-	if (cpu == RING_BUFFER_ALL_CPUS)
-		set_buffer_entries(&tr->max_buffer, size);
-	else
-		per_cpu_ptr(tr->max_buffer.data, cpu)->entries = size;
-
  out:
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
@@ -3621,6 +3610,21 @@ out:
 
 
 /**
+ * set_global_ring_buffer_expanded
+ *
+ * Sets the buffer_expanded flag for global_trace, causing the next
+ * (re)allocation of the global tracing events ring buffer to use the expanded
+ * size. During boot, this causes the buffer to assume TRACE_BUF_SIZE_DEFAULT
+ * and after that, to assume the user-set size instead of 1.
+ */
+void set_global_ring_buffer_expanded()
+{
+	mutex_lock(&trace_types_lock);
+	global_trace.buffer_expanded = true;
+	mutex_unlock(&trace_types_lock);
+}
+
+/**
  * tracing_update_buffers - used by tracing facility to expand ring buffers
  *
  * To save on memory when the tracing is never used on a system with it
@@ -3629,14 +3633,16 @@ out:
  * to their default size.
  *
  * This function is to be called when a tracer is about to be used.
+ *
+ * @tr The trace_array which needs its buffers expanded
  */
-int tracing_update_buffers(void)
+int tracing_update_buffers(struct trace_array *tr)
 {
 	int ret = 0;
 
 	mutex_lock(&trace_types_lock);
-	if (!ring_buffer_expanded)
-		ret = __tracing_resize_ring_buffer(&global_trace, trace_buf_size,
+	if (!tr->buffer_expanded)
+		ret = __tracing_resize_ring_buffer(tr, trace_buf_size,
 						RING_BUFFER_ALL_CPUS);
 	mutex_unlock(&trace_types_lock);
 
@@ -3663,7 +3669,7 @@ static int tracing_set_tracer(const char *buf)
 
 	mutex_lock(&trace_types_lock);
 
-	if (!ring_buffer_expanded) {
+	if (!tr->buffer_expanded) {
 		ret = __tracing_resize_ring_buffer(tr, trace_buf_size,
 						RING_BUFFER_ALL_CPUS);
 		if (ret < 0)
@@ -4243,7 +4249,7 @@ tracing_entries_read(struct file *filp, char __user *ubuf,
 		}
 
 		if (buf_size_same) {
-			if (!ring_buffer_expanded)
+			if (!tr->buffer_expanded)
 				r = sprintf(buf, "%lu (expanded: %lu)\n",
 					    size >> 10,
 					    trace_buf_size >> 10);
@@ -4300,10 +4306,10 @@ tracing_total_entries_read(struct file *filp, char __user *ubuf,
 	mutex_lock(&trace_types_lock);
 	for_each_tracing_cpu(cpu) {
 		size += per_cpu_ptr(tr->trace_buffer.data, cpu)->entries >> 10;
-		if (!ring_buffer_expanded)
+		if (!tr->buffer_expanded)
 			expanded_size += trace_buf_size >> 10;
 	}
-	if (ring_buffer_expanded)
+	if (tr->buffer_expanded)
 		r = sprintf(buf, "%lu\n", size);
 	else
 		r = sprintf(buf, "%lu (expanded: %lu)\n", size, expanded_size);
@@ -4566,7 +4572,7 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	unsigned long val;
 	int ret;
 
-	ret = tracing_update_buffers();
+	ret = tracing_update_buffers(tr);
 	if (ret < 0)
 		return ret;
 
@@ -5780,7 +5786,11 @@ static int new_instance_create(const char *name)
 	INIT_LIST_HEAD(&tr->systems);
 	INIT_LIST_HEAD(&tr->events);
 
-	if (allocate_trace_buffers(tr, trace_buf_size) < 0)
+	/* Allocate with small size to avoid failure to allocate buffers on
+	 * many-core systems. The ring buffer will be dynamically expanded via
+	 * tracing_update_buffers when the user attempts to trace, or the user
+	 * can set the size using buffer_size_kb */
+	if (allocate_trace_buffers(tr, 1) < 0)
 		goto out_free_tr;
 
 	/* Holder for file callbacks */
@@ -6217,7 +6227,7 @@ __init static int tracer_alloc_buffers(void)
 		trace_printk_init_buffers();
 
 	/* To save memory, keep the ring buffer size to its minimum */
-	if (ring_buffer_expanded)
+	if (global_trace.buffer_expanded)
 		ring_buf_size = trace_buf_size;
 	else
 		ring_buf_size = 1;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 20572ed..3de07e0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -195,6 +195,7 @@ struct trace_array {
 	struct trace_buffer	max_buffer;
 	bool			allocated_snapshot;
 #endif
+	bool			buffer_expanded;
 	int			buffer_disabled;
 	struct trace_cpu	trace_cpu;	/* place holder */
 #ifdef CONFIG_FTRACE_SYSCALLS
@@ -657,7 +658,6 @@ extern int DYN_FTRACE_TEST_NAME(void);
 #define DYN_FTRACE_TEST_NAME2 trace_selftest_dynamic_test_func2
 extern int DYN_FTRACE_TEST_NAME2(void);
 
-extern bool ring_buffer_expanded;
 extern bool tracing_selftest_disabled;
 DECLARE_PER_CPU(int, ftrace_cpu_disabled);
 
@@ -896,8 +896,9 @@ static inline void trace_branch_disable(void)
 }
 #endif /* CONFIG_BRANCH_TRACER */
 
+void set_global_ring_buffer_expanded(void);
 /* set ring buffers to default size if not already done so */
-int tracing_update_buffers(void);
+int tracing_update_buffers(struct trace_array *tr);
 
 /* trace event type bit fields, not numeric */
 enum {
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f57b015..6db3290 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -495,7 +495,7 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 	if (!cnt)
 		return 0;
 
-	ret = tracing_update_buffers();
+	ret = tracing_update_buffers(tr);
 	if (ret < 0)
 		return ret;
 
@@ -649,7 +649,7 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	if (ret)
 		return ret;
 
-	ret = tracing_update_buffers();
+	ret = tracing_update_buffers(file->tr);
 	if (ret < 0)
 		return ret;
 
@@ -730,7 +730,7 @@ system_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	if (ret)
 		return ret;
 
-	ret = tracing_update_buffers();
+	ret = tracing_update_buffers(dir->tr);
 	if (ret < 0)
 		return ret;
 
@@ -2219,7 +2219,7 @@ static char bootup_event_buf[COMMAND_LINE_SIZE] __initdata;
 static __init int setup_trace_event(char *str)
 {
 	strlcpy(bootup_event_buf, str, COMMAND_LINE_SIZE);
-	ring_buffer_expanded = true;
+	set_global_ring_buffer_expanded();
 	tracing_selftest_disabled = true;
 
 	return 1;
-- 
1.8.3

