Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3H0BZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:25:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab3H0BHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 19/74] tracing: Introduce trace_create_cpu_file() and tracing_get_cpu()
Date: Mon, 26 Aug 2013 18:08:17 -0700
Message-Id: <20130827010428.429537595@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 649e9c70da6bfbeb563193a35d3424a5aa7c0d38 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |   50 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 14 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2834,6 +2834,17 @@ static int s_show(struct seq_file *m, vo
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
@@ -5521,6 +5532,17 @@ static struct dentry *tracing_dentry_per
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
@@ -5540,28 +5562,28 @@ tracing_init_debugfs_percpu(struct trace
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
 


