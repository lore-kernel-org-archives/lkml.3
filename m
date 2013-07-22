Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab3GVNsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:48:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305Ab3GVNsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:48:52 -0400
Date: Mon, 22 Jul 2013 15:43:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] tracing: Introduce trace_create_cpu_file() and
	tracing_get_cpu()
Message-ID: <20130722134342.GA18355@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722134313.GA18328@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace.c |   46 ++++++++++++++++++++++++++++++++--------------
 1 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3f24777..1e0fae9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2843,6 +2843,13 @@ static int s_show(struct seq_file *m, void *v)
 	return 0;
 }
 
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
@@ -5529,6 +5536,17 @@ static struct dentry *tracing_dentry_percpu(struct trace_array *tr, int cpu)
 	return tr->percpu_dir;
 }
 
+static struct dentry *
+trace_create_cpu_file(const char *name, umode_t mode, struct dentry *parent,
+		      void *data, long cpu, const struct file_operations *fops)
+{
+	struct dentry *ret = trace_create_file(name, mode, parent, data, fops);
+
+	if (ret) /* See tracing_get_cpu() */
+		ret->d_inode->i_cdev = (void*)(cpu + 1);
+	return ret;
+}
+
 static void
 tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 {
@@ -5548,28 +5566,28 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
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
+			  	&data->trace_cpu, cpu, &snapshot_fops);
 
-	trace_create_file("snapshot_raw", 0444, d_cpu,
-			(void *)&data->trace_cpu, &snapshot_raw_fops);
+	trace_create_cpu_file("snapshot_raw", 0444, d_cpu,
+				&data->trace_cpu, cpu, &snapshot_raw_fops);
 #endif
 }
 
-- 
1.5.5.1

