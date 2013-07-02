Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab3GBUZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:25:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4154 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab3GBUY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:24:29 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=8on8NXd-WuIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=0_u0Gmuu2RoA:10 a=20KFwNOVAAAA:8 a=nm_OfeljWSUgaPJCkq8A:9 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130702202426.468989751@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 02 Jul 2013 16:22:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>
Subject: [for-next][PATCH 08/14] tracing: Use flag buffer_disabled for irqsoff tracer
References: <20130702202216.623562799@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Use-flag-buffer_disabled-for-irqsoff-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If the ring buffer is disabled and the irqsoff tracer records a trace it
will clear out its buffer and lose the data it had previously recorded.

Currently there's a callback when writing to the tracing_of file, but if
tracing is disabled via the function tracer trigger, it will not inform
the irqsoff tracer to stop recording.

By using the "mirror" flag (buffer_disabled) in the trace_array, that keeps
track of the status of the trace_array's buffer, it gives the irqsoff
tracer a fast way to know if it should record a new trace or not.
The flag may be a little behind the real state of the buffer, but it
should not affect the trace too much. It's more important for the irqsoff
tracer to be fast.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c         |  101 +++++++++++++++++++++++++++++-------------
 kernel/trace/trace_irqsoff.c |    4 +-
 2 files changed, 72 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c4c9296..0dc5071 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -226,9 +226,24 @@ cycle_t ftrace_now(int cpu)
 	return ts;
 }
 
+/**
+ * tracing_is_enabled - Show if global_trace has been disabled
+ *
+ * Shows if the global trace has been enabled or not. It uses the
+ * mirror flag "buffer_disabled" to be used in fast paths such as for
+ * the irqsoff tracer. But it may be inaccurate due to races. If you
+ * need to know the accurate state, use tracing_is_on() which is a little
+ * slower, but accurate.
+ */
 int tracing_is_enabled(void)
 {
-	return tracing_is_on();
+	/*
+	 * For quick access (irqsoff uses this in fast path), just
+	 * return the mirror variable of the state of the ring buffer.
+	 * It's a little racy, but we don't really care.
+	 */
+	smp_rmb();
+	return !global_trace.buffer_disabled;
 }
 
 /*
@@ -341,6 +356,23 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
 	TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS | TRACE_ITER_FUNCTION;
 
+void tracer_tracing_on(struct trace_array *tr)
+{
+	if (tr->trace_buffer.buffer)
+		ring_buffer_record_on(tr->trace_buffer.buffer);
+	/*
+	 * This flag is looked at when buffers haven't been allocated
+	 * yet, or by some tracers (like irqsoff), that just want to
+	 * know if the ring buffer has been disabled, but it can handle
+	 * races of where it gets disabled but we still do a record.
+	 * As the check is in the fast path of the tracers, it is more
+	 * important to be fast than accurate.
+	 */
+	tr->buffer_disabled = 0;
+	/* Make the flag seen by readers */
+	smp_wmb();
+}
+
 /**
  * tracing_on - enable tracing buffers
  *
@@ -349,15 +381,7 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
  */
 void tracing_on(void)
 {
-	if (global_trace.trace_buffer.buffer)
-		ring_buffer_record_on(global_trace.trace_buffer.buffer);
-	/*
-	 * This flag is only looked at when buffers haven't been
-	 * allocated yet. We don't really care about the race
-	 * between setting this flag and actually turning
-	 * on the buffer.
-	 */
-	global_trace.buffer_disabled = 0;
+	tracer_tracing_on(&global_trace);
 }
 EXPORT_SYMBOL_GPL(tracing_on);
 
@@ -551,6 +575,23 @@ void tracing_snapshot_alloc(void)
 EXPORT_SYMBOL_GPL(tracing_snapshot_alloc);
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
+void tracer_tracing_off(struct trace_array *tr)
+{
+	if (tr->trace_buffer.buffer)
+		ring_buffer_record_off(tr->trace_buffer.buffer);
+	/*
+	 * This flag is looked at when buffers haven't been allocated
+	 * yet, or by some tracers (like irqsoff), that just want to
+	 * know if the ring buffer has been disabled, but it can handle
+	 * races of where it gets disabled but we still do a record.
+	 * As the check is in the fast path of the tracers, it is more
+	 * important to be fast than accurate.
+	 */
+	tr->buffer_disabled = 1;
+	/* Make the flag seen by readers */
+	smp_wmb();
+}
+
 /**
  * tracing_off - turn off tracing buffers
  *
@@ -561,15 +602,7 @@ EXPORT_SYMBOL_GPL(tracing_snapshot_alloc);
  */
 void tracing_off(void)
 {
-	if (global_trace.trace_buffer.buffer)
-		ring_buffer_record_off(global_trace.trace_buffer.buffer);
-	/*
-	 * This flag is only looked at when buffers haven't been
-	 * allocated yet. We don't really care about the race
-	 * between setting this flag and actually turning
-	 * on the buffer.
-	 */
-	global_trace.buffer_disabled = 1;
+	tracer_tracing_off(&global_trace);
 }
 EXPORT_SYMBOL_GPL(tracing_off);
 
@@ -580,13 +613,24 @@ void disable_trace_on_warning(void)
 }
 
 /**
+ * tracer_tracing_is_on - show real state of ring buffer enabled
+ * @tr : the trace array to know if ring buffer is enabled
+ *
+ * Shows real state of the ring buffer if it is enabled or not.
+ */
+int tracer_tracing_is_on(struct trace_array *tr)
+{
+	if (tr->trace_buffer.buffer)
+		return ring_buffer_record_is_on(tr->trace_buffer.buffer);
+	return !tr->buffer_disabled;
+}
+
+/**
  * tracing_is_on - show state of ring buffers enabled
  */
 int tracing_is_on(void)
 {
-	if (global_trace.trace_buffer.buffer)
-		return ring_buffer_record_is_on(global_trace.trace_buffer.buffer);
-	return !global_trace.buffer_disabled;
+	return tracer_tracing_is_on(&global_trace);
 }
 EXPORT_SYMBOL_GPL(tracing_is_on);
 
@@ -3958,7 +4002,7 @@ static int tracing_wait_pipe(struct file *filp)
 		 *
 		 * iter->pos will be 0 if we haven't read anything.
 		 */
-		if (!tracing_is_enabled() && iter->pos)
+		if (!tracing_is_on() && iter->pos)
 			break;
 	}
 
@@ -5631,15 +5675,10 @@ rb_simple_read(struct file *filp, char __user *ubuf,
 	       size_t cnt, loff_t *ppos)
 {
 	struct trace_array *tr = filp->private_data;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
 	char buf[64];
 	int r;
 
-	if (buffer)
-		r = ring_buffer_record_is_on(buffer);
-	else
-		r = 0;
-
+	r = tracer_tracing_is_on(tr);
 	r = sprintf(buf, "%d\n", r);
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
@@ -5661,11 +5700,11 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
 	if (buffer) {
 		mutex_lock(&trace_types_lock);
 		if (val) {
-			ring_buffer_record_on(buffer);
+			tracer_tracing_on(tr);
 			if (tr->current_trace->start)
 				tr->current_trace->start(tr);
 		} else {
-			ring_buffer_record_off(buffer);
+			tracer_tracing_off(tr);
 			if (tr->current_trace->stop)
 				tr->current_trace->stop(tr);
 		}
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index b19d065..2aefbee 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -373,7 +373,7 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
 	struct trace_array_cpu *data;
 	unsigned long flags;
 
-	if (likely(!tracer_enabled))
+	if (!tracer_enabled || !tracing_is_enabled())
 		return;
 
 	cpu = raw_smp_processor_id();
@@ -416,7 +416,7 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
 	else
 		return;
 
-	if (!tracer_enabled)
+	if (!tracer_enabled || !tracing_is_enabled())
 		return;
 
 	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
-- 
1.7.10.4


