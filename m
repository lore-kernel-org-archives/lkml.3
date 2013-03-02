Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3CBDBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:01:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19152 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab3CBDAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:00:52 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Rw6BOHqBrr4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=pO7k4AzT96AA:10 a=heqyoBbkUSUReroWpHIA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130302024833.624729274@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Mar 2013 21:48:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Subject: [for-next][PATCH 0/7] tracing: fixups, memory savings, and block on splice
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is some more updates coming for v3.10.

One, I had to rebase from my last patch set because it broke
kgdb tracing as well as the new snapshot feature. The end of this
email contains the difference between my last patch set and what I
pushed to next in my rebase.

The first patch contains a fix to the kernel command line setting
of trace_events, as the multi buffers change broke it.

Watching Ezequiel Garcia presentation at ELC, he pointed out the waste
in the kernel from subsystems abusing kmalloc when kmem_cache_alloc()
would be better. The trace system was one of the problem areas.
By converting two common structures to slab caches, I was able to
save 36K of memory!

I also noticed that the field and event names in the format files
and filtering logic was being strdup'd from strings that happen to
be constant. I originally did this in case of modules, but then,
if a module adds an event, it must also remove it before unloading,
which would destroy the reference to the string.

By not doing the strdup() and just point to the original string
I was able to save over a 100K of memory!!! This also makes each
TRACE_EVENT() less expensive.

I finally got around to fixing a long standing bug in the splice
logic. That is, it never blocked when there was no data and required
the caller to poll. Now with irq_work(), splice and reads from
trace_pipe_raw() can block and wait for data in the buffer before
returning.

Also, since we have multiple buffers, and instead of waking up
all waiters on all buffers for data in a single buffer, I moved the
wake up logic into the ring buffer code itself. Now all users of the
ring buffer can block until data is present.

Enjoy,

-- Steve



Steven Rostedt (5):
      tracing: Get trace_events kernel command line working again
      tracing: Use kmem_cache_alloc instead of kmalloc in trace_events.c
      tracing: Use direct field, type and system names
      tracing: Fix polling on trace_pipe_raw
      tracing: Fix read blocking on trace_pipe_raw

Steven Rostedt (Red Hat) (2):
      tracing: Do not block on splice if either file or splice NONBLOCK flag is set
      tracing/ring-buffer: Move poll wake ups into ring buffer code

----
 include/linux/ring_buffer.h |    6 ++
 kernel/trace/ring_buffer.c  |  146 +++++++++++++++++++++++++++++++++
 kernel/trace/trace.c        |  171 +++++++++++++++++----------------------
 kernel/trace/trace.h        |    4 +-
 kernel/trace/trace_events.c |  188 ++++++++++++++++++++++++++++++++++++-------
 5 files changed, 386 insertions(+), 129 deletions(-)

[ rebase changes from last for-next patch set ]

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index af7be82..b36befa 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4133,14 +4133,30 @@ static int tracing_clock_open(struct inode *inode, struct file *file)
 #ifdef CONFIG_TRACER_SNAPSHOT
 static int tracing_snapshot_open(struct inode *inode, struct file *file)
 {
+	struct trace_cpu *tc = inode->i_private;
 	struct trace_iterator *iter;
+	struct seq_file *m;
 	int ret = 0;
 
 	if (file->f_mode & FMODE_READ) {
 		iter = __tracing_open(inode, file, true);
 		if (IS_ERR(iter))
 			ret = PTR_ERR(iter);
+	} else {
+		/* Writes still need the seq_file to hold the private data */
+		m = kzalloc(sizeof(*m), GFP_KERNEL);
+		if (!m)
+			return -ENOMEM;
+		iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+		if (!iter) {
+			kfree(m);
+			return -ENOMEM;
+		}
+		iter->tr = tc->tr;
+		m->private = iter;
+		file->private_data = m;
 	}
+
 	return ret;
 }
 
@@ -4148,7 +4164,9 @@ static ssize_t
 tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		       loff_t *ppos)
 {
-	struct trace_array *tr = filp->private_data;
+	struct seq_file *m = filp->private_data;
+	struct trace_iterator *iter = m->private;
+	struct trace_array *tr = iter->tr;
 	unsigned long val;
 	int ret;
 
@@ -4209,6 +4227,22 @@ out:
 	mutex_unlock(&trace_types_lock);
 	return ret;
 }
+
+static int tracing_snapshot_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = file->private_data;
+
+	if (file->f_mode & FMODE_READ)
+		return tracing_release(inode, file);
+
+	/* If write only, the seq_file is just a stub */
+	if (m)
+		kfree(m->private);
+	kfree(m);
+
+	return 0;
+}
+
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
 
@@ -4273,7 +4307,7 @@ static const struct file_operations snapshot_fops = {
 	.read		= seq_read,
 	.write		= tracing_snapshot_write,
 	.llseek		= tracing_seek,
-	.release	= tracing_release,
+	.release	= tracing_snapshot_release,
 };
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
@@ -5284,7 +5318,7 @@ static __init int tracer_init_debugfs(void)
 
 #ifdef CONFIG_TRACER_SNAPSHOT
 	trace_create_file("snapshot", 0644, d_tracer,
-			  (void *) RING_BUFFER_ALL_CPUS, &snapshot_fops);
+			  (void *)&global_trace.trace_cpu, &snapshot_fops);
 #endif
 
 	create_trace_instances(d_tracer);
diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index cc1dbdc..349f694 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -26,7 +26,7 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
 	trace_init_global_iter(&iter);
 
 	for_each_tracing_cpu(cpu) {
-		atomic_inc(&iter.tr->data[cpu]->disabled);
+		atomic_inc(&per_cpu_ptr(iter.tr->data, cpu)->disabled);
 	}
 
 	old_userobj = trace_flags;
@@ -83,7 +83,7 @@ out:
 	trace_flags = old_userobj;
 
 	for_each_tracing_cpu(cpu) {
-		atomic_dec(&iter.tr->data[cpu]->disabled);
+		atomic_dec(&per_cpu_ptr(iter.tr->data, cpu)->disabled);
 	}
 
 	for_each_tracing_cpu(cpu)
