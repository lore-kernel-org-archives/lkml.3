Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab3GZNHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:07:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22167 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167Ab3GZNFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:05:14 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=umxIWT8KrmgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_0n16rK9-DoA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=drOt6m5kAAAA:8 a=wSzaHhsv_aiVKQLHw7gA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=RrDjIHZgRldgP6t1:21 a=gzxYhkax53QkkKgk:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130726130512.134982592@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 26 Jul 2013 09:03:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/9] tracing: Introduce trace_create_cpu_file() and tracing_get_cpu()
References: <20130726130327.911599518@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Introduce-trace_create_cpu_file-and-tracing_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Every "file_operations" used by tracing_init_debugfs_percpu is buggy.
f_op->open/etc does:

	1. struct trace_cpu *tc = inode->i_private;
	   struct trace_array *tr = tc->tr;

	2. trace_array_get(tr) or fail;

	3. do_something(tc);

But tc (and tr) can be already freed before trace_array_get() is called.
And it doesn't matter whether this file is per-cpu or it was created by
init_tracer_debugfs(), free_percpu() or kfree() are equally bad.

Note that even 1. is not safe, the freed memory can be unmapped. But even
if it was safe trace_array_get() can wrongly succeed if we also race with
the next new_instance_create() which can re-allocate the same tr, or tc
was overwritten and ->tr points to the valid tr. In this case 3. uses the
freed/reused memory.

Add the new trivial helper, trace_create_cpu_file() which simply calls
trace_create_file() and encodes "cpu" in "struct inode". Another helper,
tracing_get_cpu() will be used to read cpu_nr-or-RING_BUFFER_ALL_CPUS.

The patch abuses ->i_cdev to encode the number, it is never used unless
the file is S_ISCHR(). But we could use something else, say, i_bytes or
even ->d_fsdata. In any case this hack is hidden inside these 2 helpers,
it would be trivial to change them if needed.

This patch only changes tracing_init_debugfs_percpu() to use the new
trace_create_cpu_file(), the next patches will change file_operations.

Note: tracing_get_cpu(inode) is always safe but you can't trust the
result unless trace_array_get() was called, without trace_types_lock
which acts as a barrier it can wrongly return RING_BUFFER_ALL_CPUS.

Link: http://lkml.kernel.org/r/20130723152554.GA23710@redhat.com

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   50 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3f24777..cfff63c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2843,6 +2843,17 @@ static int s_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+/*
+ * Should be used after trace_array_get(), trace_types_lock
+ * ensures that i_cdev was already initialized.
+ */
+static inline int tracing_get_cpu(struct inode *inode)
+{
+	if (inode->i_cdev) /* See trace_create_cpu_file() */
+		return (long)inode->i_cdev - 1;
+	return RING_BUFFER_ALL_CPUS;
+}
+
 static const struct seq_operations tracer_seq_ops = {
 	.start		= s_start,
 	.next		= s_next,
@@ -5529,6 +5540,17 @@ static struct dentry *tracing_dentry_percpu(struct trace_array *tr, int cpu)
 	return tr->percpu_dir;
 }
 
+static struct dentry *
+trace_create_cpu_file(const char *name, umode_t mode, struct dentry *parent,
+		      void *data, long cpu, const struct file_operations *fops)
+{
+	struct dentry *ret = trace_create_file(name, mode, parent, data, fops);
+
+	if (ret) /* See tracing_get_cpu() */
+		ret->d_inode->i_cdev = (void *)(cpu + 1);
+	return ret;
+}
+
 static void
 tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 {
@@ -5548,28 +5570,28 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 	}
 
 	/* per cpu trace_pipe */
-	trace_create_file("trace_pipe", 0444, d_cpu,
-			(void *)&data->trace_cpu, &tracing_pipe_fops);
+	trace_create_cpu_file("trace_pipe", 0444, d_cpu,
+				&data->trace_cpu, cpu, &tracing_pipe_fops);
 
 	/* per cpu trace */
-	trace_create_file("trace", 0644, d_cpu,
-			(void *)&data->trace_cpu, &tracing_fops);
+	trace_create_cpu_file("trace", 0644, d_cpu,
+				&data->trace_cpu, cpu, &tracing_fops);
 
-	trace_create_file("trace_pipe_raw", 0444, d_cpu,
-			(void *)&data->trace_cpu, &tracing_buffers_fops);
+	trace_create_cpu_file("trace_pipe_raw", 0444, d_cpu,
+				&data->trace_cpu, cpu, &tracing_buffers_fops);
 
-	trace_create_file("stats", 0444, d_cpu,
-			(void *)&data->trace_cpu, &tracing_stats_fops);
+	trace_create_cpu_file("stats", 0444, d_cpu,
+				&data->trace_cpu, cpu, &tracing_stats_fops);
 
-	trace_create_file("buffer_size_kb", 0444, d_cpu,
-			(void *)&data->trace_cpu, &tracing_entries_fops);
+	trace_create_cpu_file("buffer_size_kb", 0444, d_cpu,
+				&data->trace_cpu, cpu, &tracing_entries_fops);
 
 #ifdef CONFIG_TRACER_SNAPSHOT
-	trace_create_file("snapshot", 0644, d_cpu,
-			  (void *)&data->trace_cpu, &snapshot_fops);
+	trace_create_cpu_file("snapshot", 0644, d_cpu,
+				&data->trace_cpu, cpu, &snapshot_fops);
 
-	trace_create_file("snapshot_raw", 0444, d_cpu,
-			(void *)&data->trace_cpu, &snapshot_raw_fops);
+	trace_create_cpu_file("snapshot_raw", 0444, d_cpu,
+				&data->trace_cpu, cpu, &snapshot_raw_fops);
 #endif
 }
 
-- 
1.7.10.4


