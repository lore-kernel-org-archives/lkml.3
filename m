Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab3GVNtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:49:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab3GVNtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:49:13 -0400
Date: Mon, 22 Jul 2013 15:43:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] tracing: Change tracing_fops/snapshot_fops to rely on
	tracing_get_cpu()
Message-ID: <20130722134357.GA18378@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722134313.GA18328@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tracing_open() and tracing_snapshot_open() are racy, the memory
inode->i_private points to can be already freed.

Convert these last users of "inode->i_private == trace_cpu" to
use "i_private = trace_array" and rely on tracing_get_cpu().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace.c |   52 +++++++++++++++++++++----------------------------
 1 files changed, 22 insertions(+), 30 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 611113d..0c0b4d5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2858,9 +2858,9 @@ static const struct seq_operations tracer_seq_ops = {
 };
 
 static struct trace_iterator *
-__tracing_open(struct trace_array *tr, struct trace_cpu *tc,
-	       struct inode *inode, struct file *file, bool snapshot)
+__tracing_open(struct inode *inode, struct file *file, bool snapshot)
 {
+	struct trace_array *tr = inode->i_private;
 	struct trace_iterator *iter;
 	int cpu;
 
@@ -2901,8 +2901,8 @@ __tracing_open(struct trace_array *tr, struct trace_cpu *tc,
 		iter->trace_buffer = &tr->trace_buffer;
 	iter->snapshot = snapshot;
 	iter->pos = -1;
+	iter->cpu_file = tracing_get_cpu(inode);
 	mutex_init(&iter->mutex);
-	iter->cpu_file = tc->cpu;
 
 	/* Notify the tracer early; before we stop tracing. */
 	if (iter->trace && iter->trace->open)
@@ -2982,22 +2982,16 @@ static int tracing_open_generic_tr(struct inode *inode, struct file *filp)
 
 static int tracing_release(struct inode *inode, struct file *file)
 {
+	struct trace_array *tr = inode->i_private;
 	struct seq_file *m = file->private_data;
-	struct trace_iterator *iter;
-	struct trace_array *tr;
+	struct trace_iterator *iter = m->private;
 	int cpu;
 
-	/* Writes do not use seq_file, need to grab tr from inode */
 	if (!(file->f_mode & FMODE_READ)) {
-		struct trace_cpu *tc = inode->i_private;
-
-		trace_array_put(tc->tr);
+		trace_array_put(tr);
 		return 0;
 	}
 
-	iter = m->private;
-	tr = iter->tr;
-
 	mutex_lock(&trace_types_lock);
 
 	for_each_tracing_cpu(cpu) {
@@ -3044,8 +3038,7 @@ static int tracing_single_release_tr(struct inode *inode, struct file *file)
 
 static int tracing_open(struct inode *inode, struct file *file)
 {
-	struct trace_cpu *tc = inode->i_private;
-	struct trace_array *tr = tc->tr;
+	struct trace_array *tr = inode->i_private;
 	struct trace_iterator *iter;
 	int ret = 0;
 
@@ -3053,16 +3046,17 @@ static int tracing_open(struct inode *inode, struct file *file)
 		return -ENODEV;
 
 	/* If this file was open for write, then erase contents */
-	if ((file->f_mode & FMODE_WRITE) &&
-	    (file->f_flags & O_TRUNC)) {
-		if (tc->cpu == RING_BUFFER_ALL_CPUS)
+	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC)) {
+		int cpu = tracing_get_cpu(inode);
+
+		if (cpu == RING_BUFFER_ALL_CPUS)
 			tracing_reset_online_cpus(&tr->trace_buffer);
 		else
-			tracing_reset(&tr->trace_buffer, tc->cpu);
+			tracing_reset(&tr->trace_buffer, cpu);
 	}
 
 	if (file->f_mode & FMODE_READ) {
-		iter = __tracing_open(tr, tc, inode, file, false);
+		iter = __tracing_open(inode, file, false);
 		if (IS_ERR(iter))
 			ret = PTR_ERR(iter);
 		else if (trace_flags & TRACE_ITER_LATENCY_FMT)
@@ -4676,8 +4670,7 @@ struct ftrace_buffer_info {
 #ifdef CONFIG_TRACER_SNAPSHOT
 static int tracing_snapshot_open(struct inode *inode, struct file *file)
 {
-	struct trace_cpu *tc = inode->i_private;
-	struct trace_array *tr = tc->tr;
+	struct trace_array *tr = inode->i_private;
 	struct trace_iterator *iter;
 	struct seq_file *m;
 	int ret = 0;
@@ -4686,7 +4679,7 @@ static int tracing_snapshot_open(struct inode *inode, struct file *file)
 		return -ENODEV;
 
 	if (file->f_mode & FMODE_READ) {
-		iter = __tracing_open(tr, tc, inode, file, true);
+		iter = __tracing_open(inode, file, true);
 		if (IS_ERR(iter))
 			ret = PTR_ERR(iter);
 	} else {
@@ -4703,8 +4696,8 @@ static int tracing_snapshot_open(struct inode *inode, struct file *file)
 		ret = 0;
 
 		iter->tr = tr;
-		iter->trace_buffer = &tc->tr->max_buffer;
-		iter->cpu_file = tc->cpu;
+		iter->trace_buffer = &tr->max_buffer;
+		iter->cpu_file = tracing_get_cpu(inode);
 		m->private = iter;
 		file->private_data = m;
 	}
@@ -5521,7 +5514,6 @@ trace_create_cpu_file(const char *name, umode_t mode, struct dentry *parent,
 static void
 tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 {
-	struct trace_array_cpu *data = per_cpu_ptr(tr->trace_buffer.data, cpu);
 	struct dentry *d_percpu = tracing_dentry_percpu(tr, cpu);
 	struct dentry *d_cpu;
 	char cpu_dir[30]; /* 30 characters should be more than enough */
@@ -5542,7 +5534,7 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 
 	/* per cpu trace */
 	trace_create_cpu_file("trace", 0644, d_cpu,
-				&data->trace_cpu, cpu, &tracing_fops);
+				tr, cpu, &tracing_fops);
 
 	trace_create_cpu_file("trace_pipe_raw", 0444, d_cpu,
 				tr, cpu, &tracing_buffers_fops);
@@ -5555,7 +5547,7 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 
 #ifdef CONFIG_TRACER_SNAPSHOT
 	trace_create_cpu_file("snapshot", 0644, d_cpu,
-			  	&data->trace_cpu, cpu, &snapshot_fops);
+			  	tr, cpu, &snapshot_fops);
 
 	trace_create_cpu_file("snapshot_raw", 0444, d_cpu,
 				tr, cpu, &snapshot_raw_fops);
@@ -6121,7 +6113,7 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 			  tr, &tracing_iter_fops);
 
 	trace_create_file("trace", 0644, d_tracer,
-			(void *)&tr->trace_cpu, &tracing_fops);
+			  tr, &tracing_fops);
 
 	trace_create_file("trace_pipe", 0444, d_tracer,
 			  tr, &tracing_pipe_fops);
@@ -6142,11 +6134,11 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 			  &trace_clock_fops);
 
 	trace_create_file("tracing_on", 0644, d_tracer,
-			    tr, &rb_simple_fops);
+			  tr, &rb_simple_fops);
 
 #ifdef CONFIG_TRACER_SNAPSHOT
 	trace_create_file("snapshot", 0644, d_tracer,
-			  (void *)&tr->trace_cpu, &snapshot_fops);
+			  tr, &snapshot_fops);
 #endif
 
 	for_each_tracing_cpu(cpu)
-- 
1.5.5.1

