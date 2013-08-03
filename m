Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab3HCBgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 21:36:47 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:37978 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab3HCBgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 21:36:44 -0400
From: Alexander Z Lam <azl@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>
Subject: [PATCH 3/3] tracing: Make tracing_cpumask available for all instances
Date: Fri,  2 Aug 2013 18:36:17 -0700
Message-Id: <1375493777-17261-3-git-send-email-azl@google.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1375493777-17261-1-git-send-email-azl@google.com>
References: <1375493777-17261-1-git-send-email-azl@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow tracer instances to disable tracing by cpu by moving
the static global tracing_cpumask into trace_array.

Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: Alexander Z Lam <lambchop468@gmail.com>
Signed-off-by: Alexander Z Lam <azl@google.com>
---
 kernel/trace/trace.c | 37 ++++++++++++++++++++-----------------
 kernel/trace/trace.h |  1 +
 2 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 678a88b..1824443 100644
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
+	struct trace_array *tr = file_inode(filp);
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
 
@@ -5937,6 +5934,11 @@ static int new_instance_create(const char *name)
 	if (!tr->name)
 		goto out_free_tr;
 
+	if (!alloc_cpumask_var(&tr->tracing_cpumask, GFP_KERNEL))
+		goto out_free_tr;
+
+	cpumask_copy(tr->tracing_cpumask, cpu_all_mask);
+
 	raw_spin_lock_init(&tr->start_lock);
 
 	tr->current_trace = &nop_trace;
@@ -5968,6 +5970,7 @@ static int new_instance_create(const char *name)
  out_free_tr:
 	if (tr->trace_buffer.buffer)
 		ring_buffer_free(tr->trace_buffer.buffer);
+	free_cpumask_var(tr->tracing_cpumask);
 	kfree(tr->name);
 	kfree(tr);
 
@@ -6097,6 +6100,9 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 {
 	int cpu;
 
+	trace_create_file("tracing_cpumask", 0644, d_tracer,
+			  tr, &tracing_cpumask_fops);
+
 	trace_create_file("trace_options", 0644, d_tracer,
 			  tr, &tracing_iter_fops);
 
@@ -6146,9 +6152,6 @@ static __init int tracer_init_debugfs(void)
 
 	init_tracer_debugfs(&global_trace, d_tracer);
 
-	trace_create_file("tracing_cpumask", 0644, d_tracer,
-			&global_trace, &tracing_cpumask_fops);
-
 	trace_create_file("available_tracers", 0444, d_tracer,
 			&global_trace, &show_traces_fops);
 
@@ -6370,7 +6373,7 @@ __init static int tracer_alloc_buffers(void)
 	if (!alloc_cpumask_var(&tracing_buffer_mask, GFP_KERNEL))
 		goto out;
 
-	if (!alloc_cpumask_var(&tracing_cpumask, GFP_KERNEL))
+	if (!alloc_cpumask_var(&global_trace.tracing_cpumask, GFP_KERNEL))
 		goto out_free_buffer_mask;
 
 	/* Only allocate trace_printk buffers if a trace_printk exists */
@@ -6385,7 +6388,7 @@ __init static int tracer_alloc_buffers(void)
 		ring_buf_size = 1;
 
 	cpumask_copy(tracing_buffer_mask, cpu_possible_mask);
-	cpumask_copy(tracing_cpumask, cpu_all_mask);
+	cpumask_copy(global_trace.tracing_cpumask, cpu_all_mask);
 
 	raw_spin_lock_init(&global_trace.start_lock);
 
@@ -6440,7 +6443,7 @@ out_free_cpumask:
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
1.8.3

