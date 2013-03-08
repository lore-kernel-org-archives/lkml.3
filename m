Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813Ab3CHDHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8123 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760221Ab3CHDGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:54 -0500
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=PanAdV3MlecA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=XMFs5ALVl2YA:10 a=20KFwNOVAAAA:8 a=SSmOFEACAAAA:8 a=yjSudTl7AAAA:8 a=0vt0KrtZjW_BmtTeXAAA:9 a=XJHVlXgjdsAA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030653.574096327@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 11/17] tracing: Consolidate buffer allocation code
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-Consolidate-buffer-allocation-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

There's a bit of duplicate code in creating the trace buffers for
the normal trace buffer and the max trace buffer among the instances
and the main global_trace. This code can be consolidated and cleaned
up a bit making the code cleaner and more readable as well as less
duplication.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |  130 ++++++++++++++++++++++++--------------------------
 1 file changed, 63 insertions(+), 67 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3213f1e..1dec636 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3146,6 +3146,7 @@ int tracer_init(struct tracer *t, struct trace_array *tr)
 static void set_buffer_entries(struct trace_buffer *buf, unsigned long val)
 {
 	int cpu;
+
 	for_each_tracing_cpu(cpu)
 		per_cpu_ptr(buf->data, cpu)->entries = val;
 }
@@ -5231,12 +5232,70 @@ struct dentry *trace_instance_dir;
 static void
 init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer);
 
-static int new_instance_create(const char *name)
+static void init_trace_buffers(struct trace_array *tr, struct trace_buffer *buf)
+{
+	int cpu;
+
+	for_each_tracing_cpu(cpu) {
+		memset(per_cpu_ptr(buf->data, cpu), 0, sizeof(struct trace_array_cpu));
+		per_cpu_ptr(buf->data, cpu)->trace_cpu.cpu = cpu;
+		per_cpu_ptr(buf->data, cpu)->trace_cpu.tr = tr;
+	}
+}
+
+static int allocate_trace_buffers(struct trace_array *tr, int size)
 {
 	enum ring_buffer_flags rb_flags;
+
+	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
+
+	tr->trace_buffer.buffer = ring_buffer_alloc(size, rb_flags);
+	if (!tr->trace_buffer.buffer)
+		goto out_free;
+
+	tr->trace_buffer.data = alloc_percpu(struct trace_array_cpu);
+	if (!tr->trace_buffer.data)
+		goto out_free;
+
+	init_trace_buffers(tr, &tr->trace_buffer);
+
+	/* Allocate the first page for all buffers */
+	set_buffer_entries(&tr->trace_buffer,
+			   ring_buffer_size(tr->trace_buffer.buffer, 0));
+
+#ifdef CONFIG_TRACER_MAX_TRACE
+
+	tr->max_buffer.buffer = ring_buffer_alloc(1, rb_flags);
+	if (!tr->max_buffer.buffer)
+		goto out_free;
+
+	tr->max_buffer.data = alloc_percpu(struct trace_array_cpu);
+	if (!tr->max_buffer.data)
+		goto out_free;
+
+	init_trace_buffers(tr, &tr->max_buffer);
+
+	set_buffer_entries(&tr->max_buffer, 1);
+#endif
+	return 0;
+
+ out_free:
+	if (tr->trace_buffer.buffer)
+		ring_buffer_free(tr->trace_buffer.buffer);
+	free_percpu(tr->trace_buffer.data);
+
+#ifdef CONFIG_TRACER_MAX_TRACE
+	if (tr->max_buffer.buffer)
+		ring_buffer_free(tr->max_buffer.buffer);
+	free_percpu(tr->max_buffer.data);
+#endif
+	return -ENOMEM;
+}
+
+static int new_instance_create(const char *name)
+{
 	struct trace_array *tr;
 	int ret;
-	int i;
 
 	mutex_lock(&trace_types_lock);
 
@@ -5262,22 +5321,9 @@ static int new_instance_create(const char *name)
 	INIT_LIST_HEAD(&tr->systems);
 	INIT_LIST_HEAD(&tr->events);
 
-	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
-
-	tr->trace_buffer.buffer = ring_buffer_alloc(trace_buf_size, rb_flags);
-	if (!tr->trace_buffer.buffer)
-		goto out_free_tr;
-
-	tr->trace_buffer.data = alloc_percpu(struct trace_array_cpu);
-	if (!tr->trace_buffer.data)
+	if (allocate_trace_buffers(tr, trace_buf_size) < 0)
 		goto out_free_tr;
 
-	for_each_tracing_cpu(i) {
-		memset(per_cpu_ptr(tr->trace_buffer.data, i), 0, sizeof(struct trace_array_cpu));
-		per_cpu_ptr(tr->trace_buffer.data, i)->trace_cpu.cpu = i;
-		per_cpu_ptr(tr->trace_buffer.data, i)->trace_cpu.tr = tr;
-	}
-
 	/* Holder for file callbacks */
 	tr->trace_cpu.cpu = RING_BUFFER_ALL_CPUS;
 	tr->trace_cpu.tr = tr;
@@ -5700,8 +5746,6 @@ EXPORT_SYMBOL_GPL(ftrace_dump);
 __init static int tracer_alloc_buffers(void)
 {
 	int ring_buf_size;
-	enum ring_buffer_flags rb_flags;
-	int i;
 	int ret = -ENOMEM;
 
 
@@ -5722,69 +5766,21 @@ __init static int tracer_alloc_buffers(void)
 	else
 		ring_buf_size = 1;
 
-	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
-
 	cpumask_copy(tracing_buffer_mask, cpu_possible_mask);
 	cpumask_copy(tracing_cpumask, cpu_all_mask);
 
 	raw_spin_lock_init(&global_trace.start_lock);
 
 	/* TODO: make the number of buffers hot pluggable with CPUS */
-	global_trace.trace_buffer.buffer = ring_buffer_alloc(ring_buf_size, rb_flags);
-	if (!global_trace.trace_buffer.buffer) {
+	if (allocate_trace_buffers(&global_trace, ring_buf_size) < 0) {
 		printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
 		WARN_ON(1);
 		goto out_free_cpumask;
 	}
 
-	global_trace.trace_buffer.data = alloc_percpu(struct trace_array_cpu);
-
-	if (!global_trace.trace_buffer.data) {
-		printk(KERN_ERR "tracer: failed to allocate percpu memory!\n");
-		WARN_ON(1);
-		goto out_free_cpumask;
-	}
-
-	for_each_tracing_cpu(i) {
-		memset(per_cpu_ptr(global_trace.trace_buffer.data, i), 0,
-		       sizeof(struct trace_array_cpu));
-		per_cpu_ptr(global_trace.trace_buffer.data, i)->trace_cpu.cpu = i;
-		per_cpu_ptr(global_trace.trace_buffer.data, i)->trace_cpu.tr = &global_trace;
-	}
-
 	if (global_trace.buffer_disabled)
 		tracing_off();
 
-#ifdef CONFIG_TRACER_MAX_TRACE
-	global_trace.max_buffer.data = alloc_percpu(struct trace_array_cpu);
-	if (!global_trace.max_buffer.data) {
-		printk(KERN_ERR "tracer: failed to allocate percpu memory!\n");
-		WARN_ON(1);
-		goto out_free_cpumask;
-	}
-	global_trace.max_buffer.buffer = ring_buffer_alloc(1, rb_flags);
-	if (!global_trace.max_buffer.buffer) {
-		printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
-		WARN_ON(1);
-		ring_buffer_free(global_trace.trace_buffer.buffer);
-		goto out_free_cpumask;
-	}
-
-	for_each_tracing_cpu(i) {
-		memset(per_cpu_ptr(global_trace.max_buffer.data, i), 0,
-		       sizeof(struct trace_array_cpu));
-		per_cpu_ptr(global_trace.max_buffer.data, i)->trace_cpu.cpu = i;
-		per_cpu_ptr(global_trace.max_buffer.data, i)->trace_cpu.tr = &global_trace;
-	}
-#endif
-
-	/* Allocate the first page for all buffers */
-	set_buffer_entries(&global_trace.trace_buffer,
-			   ring_buffer_size(global_trace.trace_buffer.buffer, 0));
-#ifdef CONFIG_TRACER_MAX_TRACE
-	set_buffer_entries(&global_trace.max_buffer, 1);
-#endif
-
 	trace_init_cmdlines();
 
 	register_tracer(&nop_trace);
-- 
1.7.10.4


