Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab3GZNFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:05:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22167 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758682Ab3GZNFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:05:15 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=PA6JYYoiQokA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=P7NcQqQISwoA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=patYdEJBjaNhU8RuypIA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130726130512.963056235@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 26 Jul 2013 09:03:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 6/9] tracing: Change tracing_fops/snapshot_fops to rely on
 tracing_get_cpu()
References: <20130726130327.911599518@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Change-tracing_fops-snapshot_fops-to-rely-on.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

tracing_open() and tracing_snapshot_open() are racy, the memory
inode->i_private points to can be already freed.

Convert these last users of "inode->i_private == trace_cpu" to
use "i_private = trace_array" and rely on tracing_get_cpu().

v2: incorporate the fix from Steven, tracing_release() must not
    blindly dereference file->private_data unless we know that
    the file was opened for reading.

Link: http://lkml.kernel.org/r/20130723152610.GA23737@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   50 ++++++++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 68b4685..dd7780d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2862,9 +2862,9 @@ static const struct seq_operations tracer_seq_ops = {
 };
 
 static struct trace_iterator *
-__tracing_open(struct trace_array *tr, struct trace_cpu *tc,
-	       struct inode *inode, struct file *file, bool snapshot)
+__tracing_open(struct inode *inode, struct file *file, bool snapshot)
 {
+	struct trace_array *tr = inode->i_private;
 	struct trace_iterator *iter;
 	int cpu;
 
@@ -2905,8 +2905,8 @@ __tracing_open(struct trace_array *tr, struct trace_cpu *tc,
 		iter->trace_buffer = &tr->trace_buffer;
 	iter->snapshot = snapshot;
 	iter->pos = -1;
+	iter->cpu_file = tracing_get_cpu(inode);
 	mutex_init(&iter->mutex);
-	iter->cpu_file = tc->cpu;
 
 	/* Notify the tracer early; before we stop tracing. */
 	if (iter->trace && iter->trace->open)
@@ -2986,22 +2986,18 @@ static int tracing_open_generic_tr(struct inode *inode, struct file *filp)
 
 static int tracing_release(struct inode *inode, struct file *file)
 {
+	struct trace_array *tr = inode->i_private;
 	struct seq_file *m = file->private_data;
 	struct trace_iterator *iter;
-	struct trace_array *tr;
 	int cpu;
 
-	/* Writes do not use seq_file, need to grab tr from inode */
 	if (!(file->f_mode & FMODE_READ)) {
-		struct trace_cpu *tc = inode->i_private;
-
-		trace_array_put(tc->tr);
+		trace_array_put(tr);
 		return 0;
 	}
 
+	/* Writes do not use seq_file */
 	iter = m->private;
-	tr = iter->tr;
-
 	mutex_lock(&trace_types_lock);
 
 	for_each_tracing_cpu(cpu) {
@@ -3048,8 +3044,7 @@ static int tracing_single_release_tr(struct inode *inode, struct file *file)
 
 static int tracing_open(struct inode *inode, struct file *file)
 {
-	struct trace_cpu *tc = inode->i_private;
-	struct trace_array *tr = tc->tr;
+	struct trace_array *tr = inode->i_private;
 	struct trace_iterator *iter;
 	int ret = 0;
 
@@ -3057,16 +3052,17 @@ static int tracing_open(struct inode *inode, struct file *file)
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
@@ -4680,8 +4676,7 @@ struct ftrace_buffer_info {
 #ifdef CONFIG_TRACER_SNAPSHOT
 static int tracing_snapshot_open(struct inode *inode, struct file *file)
 {
-	struct trace_cpu *tc = inode->i_private;
-	struct trace_array *tr = tc->tr;
+	struct trace_array *tr = inode->i_private;
 	struct trace_iterator *iter;
 	struct seq_file *m;
 	int ret = 0;
@@ -4690,7 +4685,7 @@ static int tracing_snapshot_open(struct inode *inode, struct file *file)
 		return -ENODEV;
 
 	if (file->f_mode & FMODE_READ) {
-		iter = __tracing_open(tr, tc, inode, file, true);
+		iter = __tracing_open(inode, file, true);
 		if (IS_ERR(iter))
 			ret = PTR_ERR(iter);
 	} else {
@@ -4707,8 +4702,8 @@ static int tracing_snapshot_open(struct inode *inode, struct file *file)
 		ret = 0;
 
 		iter->tr = tr;
-		iter->trace_buffer = &tc->tr->max_buffer;
-		iter->cpu_file = tc->cpu;
+		iter->trace_buffer = &tr->max_buffer;
+		iter->cpu_file = tracing_get_cpu(inode);
 		m->private = iter;
 		file->private_data = m;
 	}
@@ -5525,7 +5520,6 @@ trace_create_cpu_file(const char *name, umode_t mode, struct dentry *parent,
 static void
 tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 {
-	struct trace_array_cpu *data = per_cpu_ptr(tr->trace_buffer.data, cpu);
 	struct dentry *d_percpu = tracing_dentry_percpu(tr, cpu);
 	struct dentry *d_cpu;
 	char cpu_dir[30]; /* 30 characters should be more than enough */
@@ -5546,7 +5540,7 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 
 	/* per cpu trace */
 	trace_create_cpu_file("trace", 0644, d_cpu,
-				&data->trace_cpu, cpu, &tracing_fops);
+				tr, cpu, &tracing_fops);
 
 	trace_create_cpu_file("trace_pipe_raw", 0444, d_cpu,
 				tr, cpu, &tracing_buffers_fops);
@@ -5559,7 +5553,7 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 
 #ifdef CONFIG_TRACER_SNAPSHOT
 	trace_create_cpu_file("snapshot", 0644, d_cpu,
-				&data->trace_cpu, cpu, &snapshot_fops);
+				tr, cpu, &snapshot_fops);
 
 	trace_create_cpu_file("snapshot_raw", 0444, d_cpu,
 				tr, cpu, &snapshot_raw_fops);
@@ -6125,7 +6119,7 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 			  tr, &tracing_iter_fops);
 
 	trace_create_file("trace", 0644, d_tracer,
-			(void *)&tr->trace_cpu, &tracing_fops);
+			  tr, &tracing_fops);
 
 	trace_create_file("trace_pipe", 0444, d_tracer,
 			  tr, &tracing_pipe_fops);
@@ -6146,11 +6140,11 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
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
1.7.10.4


