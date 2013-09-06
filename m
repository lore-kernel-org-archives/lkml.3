Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab3IFBtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 21:49:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4051 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab3IFBtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 21:49:16 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Emzv1uKqEdEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=k-61ZpOh3VsA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=_oTubpEGIMyqQ9fYCzAA:9 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130906014915.118949140@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 05 Sep 2013 21:48:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>,
        Alexander Z Lam <azl@google.com>
Subject: [for-next][PATCH 1/4] tracing: Make tracing_cpumask available for all instances
References: <20130906014816.037690469@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Make-tracing_cpumask-available-for-all-insta.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Z Lam <azl@google.com>

Allow tracer instances to disable tracing by cpu by moving
the static global tracing_cpumask into trace_array.

Link: http://lkml.kernel.org/r/921622317f239bfc2283cac2242647801ef584f2.1375980149.git.azl@google.com

Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Alexander Z Lam <azl@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   37 ++++++++++++++++++++-----------------
 kernel/trace/trace.h |    1 +
 2 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 496f94d..7974ba2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3166,11 +3166,6 @@ static const struct file_operations show_traces_fops = {
 };
 
 /*
- * Only trace on a CPU if the bitmask is set:
- */
-static cpumask_var_t tracing_cpumask;
-
-/*
  * The tracer itself will not take this lock, but still we want
  * to provide a consistent cpumask to user-space:
  */
@@ -3186,11 +3181,12 @@ static ssize_t
 tracing_cpumask_read(struct file *filp, char __user *ubuf,
 		     size_t count, loff_t *ppos)
 {
+	struct trace_array *tr = file_inode(filp)->i_private;
 	int len;
 
 	mutex_lock(&tracing_cpumask_update_lock);
 
-	len = cpumask_scnprintf(mask_str, count, tracing_cpumask);
+	len = cpumask_scnprintf(mask_str, count, tr->tracing_cpumask);
 	if (count - len < 2) {
 		count = -EINVAL;
 		goto out_err;
@@ -3208,7 +3204,7 @@ static ssize_t
 tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 		      size_t count, loff_t *ppos)
 {
-	struct trace_array *tr = filp->private_data;
+	struct trace_array *tr = file_inode(filp)->i_private;
 	cpumask_var_t tracing_cpumask_new;
 	int err, cpu;
 
@@ -3228,12 +3224,12 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 		 * Increase/decrease the disabled counter if we are
 		 * about to flip a bit in the cpumask:
 		 */
-		if (cpumask_test_cpu(cpu, tracing_cpumask) &&
+		if (cpumask_test_cpu(cpu, tr->tracing_cpumask) &&
 				!cpumask_test_cpu(cpu, tracing_cpumask_new)) {
 			atomic_inc(&per_cpu_ptr(tr->trace_buffer.data, cpu)->disabled);
 			ring_buffer_record_disable_cpu(tr->trace_buffer.buffer, cpu);
 		}
-		if (!cpumask_test_cpu(cpu, tracing_cpumask) &&
+		if (!cpumask_test_cpu(cpu, tr->tracing_cpumask) &&
 				cpumask_test_cpu(cpu, tracing_cpumask_new)) {
 			atomic_dec(&per_cpu_ptr(tr->trace_buffer.data, cpu)->disabled);
 			ring_buffer_record_enable_cpu(tr->trace_buffer.buffer, cpu);
@@ -3242,7 +3238,7 @@ tracing_cpumask_write(struct file *filp, const char __user *ubuf,
 	arch_spin_unlock(&ftrace_max_lock);
 	local_irq_enable();
 
-	cpumask_copy(tracing_cpumask, tracing_cpumask_new);
+	cpumask_copy(tr->tracing_cpumask, tracing_cpumask_new);
 
 	mutex_unlock(&tracing_cpumask_update_lock);
 	free_cpumask_var(tracing_cpumask_new);
@@ -3256,9 +3252,10 @@ err_unlock:
 }
 
 static const struct file_operations tracing_cpumask_fops = {
-	.open		= tracing_open_generic,
+	.open		= tracing_open_generic_tr,
 	.read		= tracing_cpumask_read,
 	.write		= tracing_cpumask_write,
+	.release	= tracing_release_generic_tr,
 	.llseek		= generic_file_llseek,
 };
 
@@ -5938,6 +5935,11 @@ static int new_instance_create(const char *name)
 	if (!tr->name)
 		goto out_free_tr;
 
+	if (!alloc_cpumask_var(&tr->tracing_cpumask, GFP_KERNEL))
+		goto out_free_tr;
+
+	cpumask_copy(tr->tracing_cpumask, cpu_all_mask);
+
 	raw_spin_lock_init(&tr->start_lock);
 
 	tr->current_trace = &nop_trace;
@@ -5969,6 +5971,7 @@ static int new_instance_create(const char *name)
  out_free_tr:
 	if (tr->trace_buffer.buffer)
 		ring_buffer_free(tr->trace_buffer.buffer);
+	free_cpumask_var(tr->tracing_cpumask);
 	kfree(tr->name);
 	kfree(tr);
 
@@ -6098,6 +6101,9 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 {
 	int cpu;
 
+	trace_create_file("tracing_cpumask", 0644, d_tracer,
+			  tr, &tracing_cpumask_fops);
+
 	trace_create_file("trace_options", 0644, d_tracer,
 			  tr, &tracing_iter_fops);
 
@@ -6147,9 +6153,6 @@ static __init int tracer_init_debugfs(void)
 
 	init_tracer_debugfs(&global_trace, d_tracer);
 
-	trace_create_file("tracing_cpumask", 0644, d_tracer,
-			&global_trace, &tracing_cpumask_fops);
-
 	trace_create_file("available_tracers", 0444, d_tracer,
 			&global_trace, &show_traces_fops);
 
@@ -6371,7 +6374,7 @@ __init static int tracer_alloc_buffers(void)
 	if (!alloc_cpumask_var(&tracing_buffer_mask, GFP_KERNEL))
 		goto out;
 
-	if (!alloc_cpumask_var(&tracing_cpumask, GFP_KERNEL))
+	if (!alloc_cpumask_var(&global_trace.tracing_cpumask, GFP_KERNEL))
 		goto out_free_buffer_mask;
 
 	/* Only allocate trace_printk buffers if a trace_printk exists */
@@ -6386,7 +6389,7 @@ __init static int tracer_alloc_buffers(void)
 		ring_buf_size = 1;
 
 	cpumask_copy(tracing_buffer_mask, cpu_possible_mask);
-	cpumask_copy(tracing_cpumask, cpu_all_mask);
+	cpumask_copy(global_trace.tracing_cpumask, cpu_all_mask);
 
 	raw_spin_lock_init(&global_trace.start_lock);
 
@@ -6441,7 +6444,7 @@ out_free_cpumask:
 #ifdef CONFIG_TRACER_MAX_TRACE
 	free_percpu(global_trace.max_buffer.data);
 #endif
-	free_cpumask_var(tracing_cpumask);
+	free_cpumask_var(global_trace.tracing_cpumask);
 out_free_buffer_mask:
 	free_cpumask_var(tracing_buffer_mask);
 out:
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index afaae41..502fed7 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -206,6 +206,7 @@ struct trace_array {
 	struct dentry		*event_dir;
 	struct list_head	systems;
 	struct list_head	events;
+	cpumask_var_t		tracing_cpumask; /* only trace on set CPUs */
 	int			ref;
 };
 
-- 
1.7.10.4


