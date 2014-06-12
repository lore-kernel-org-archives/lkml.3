Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbaFLPao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:30:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:58145 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756011AbaFLPam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:30:42 -0400
Date: Thu, 12 Jun 2014 11:30:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [GIT PULL] tracing: Cleanups and bug fixes
Message-ID: <20140612113041.1db84533@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

One bug fix that goes back to 3.10. Accessing a non existent buffer
if "possible cpus" is greater than actual CPUs (including offline CPUs).

Namhyung Kim did some reviews of the patches I sent this merge window and
found a memory leak and had a few clean ups.

Please pull the latest trace-3.16-2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.16-2

Tag SHA1: df40e73fe2e002e1771a1607429846c120058b73
Head SHA1: da9c3413a27be5ba6f996e90495c836dd30b8841


Namhyung Kim (1):
      tracing: Cleanup saved_cmdlines_size changes

Steven Rostedt (Red Hat) (3):
      ring-buffer: Check if buffer exists before polling
      tracing: Fix leak of per cpu max data in instances
      tracing: Fix check of ftrace_trace_arrays list_empty() check

----
 include/linux/ring_buffer.h |  2 +-
 kernel/trace/ring_buffer.c  |  5 ++++-
 kernel/trace/trace.c        | 49 ++++++++++++++++++++++++++++-----------------
 kernel/trace/trace.h        |  2 +-
 4 files changed, 37 insertions(+), 21 deletions(-)
---------------------------
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index d69cf637a15a..49a4d6f59108 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -97,7 +97,7 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
 	__ring_buffer_alloc((size), (flags), &__key);	\
 })
 
-void ring_buffer_wait(struct ring_buffer *buffer, int cpu);
+int ring_buffer_wait(struct ring_buffer *buffer, int cpu);
 int ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
 			  struct file *filp, poll_table *poll_table);
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index c634868c2921..7c56c3d06943 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -543,7 +543,7 @@ static void rb_wake_up_waiters(struct irq_work *work)
  * as data is added to any of the @buffer's cpu buffers. Otherwise
  * it will wait for data to be added to a specific cpu buffer.
  */
-void ring_buffer_wait(struct ring_buffer *buffer, int cpu)
+int ring_buffer_wait(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	DEFINE_WAIT(wait);
@@ -557,6 +557,8 @@ void ring_buffer_wait(struct ring_buffer *buffer, int cpu)
 	if (cpu == RING_BUFFER_ALL_CPUS)
 		work = &buffer->irq_work;
 	else {
+		if (!cpumask_test_cpu(cpu, buffer->cpumask))
+			return -ENODEV;
 		cpu_buffer = buffer->buffers[cpu];
 		work = &cpu_buffer->irq_work;
 	}
@@ -591,6 +593,7 @@ void ring_buffer_wait(struct ring_buffer *buffer, int cpu)
 		schedule();
 
 	finish_wait(&work->waiters, &wait);
+	return 0;
 }
 
 /**
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 16f7038d1f4d..384ede311717 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1085,13 +1085,13 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 }
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
-static void wait_on_pipe(struct trace_iterator *iter)
+static int wait_on_pipe(struct trace_iterator *iter)
 {
 	/* Iterators are static, they should be filled or empty */
 	if (trace_buffer_iter(iter, iter->cpu_file))
-		return;
+		return 0;
 
-	ring_buffer_wait(iter->trace_buffer->buffer, iter->cpu_file);
+	return ring_buffer_wait(iter->trace_buffer->buffer, iter->cpu_file);
 }
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
@@ -1338,7 +1338,7 @@ static int trace_create_savedcmd(void)
 {
 	int ret;
 
-	savedcmd = kmalloc(sizeof(struct saved_cmdlines_buffer), GFP_KERNEL);
+	savedcmd = kmalloc(sizeof(*savedcmd), GFP_KERNEL);
 	if (!savedcmd)
 		return -ENOMEM;
 
@@ -3840,7 +3840,7 @@ tracing_saved_cmdlines_size_read(struct file *filp, char __user *ubuf,
 	int r;
 
 	arch_spin_lock(&trace_cmdline_lock);
-	r = sprintf(buf, "%u\n", savedcmd->cmdline_num);
+	r = scnprintf(buf, sizeof(buf), "%u\n", savedcmd->cmdline_num);
 	arch_spin_unlock(&trace_cmdline_lock);
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
@@ -3857,7 +3857,7 @@ static int tracing_resize_saved_cmdlines(unsigned int val)
 {
 	struct saved_cmdlines_buffer *s, *savedcmd_temp;
 
-	s = kmalloc(sizeof(struct saved_cmdlines_buffer), GFP_KERNEL);
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
 
@@ -4378,6 +4378,7 @@ tracing_poll_pipe(struct file *filp, poll_table *poll_table)
 static int tracing_wait_pipe(struct file *filp)
 {
 	struct trace_iterator *iter = filp->private_data;
+	int ret;
 
 	while (trace_empty(iter)) {
 
@@ -4399,10 +4400,13 @@ static int tracing_wait_pipe(struct file *filp)
 
 		mutex_unlock(&iter->mutex);
 
-		wait_on_pipe(iter);
+		ret = wait_on_pipe(iter);
 
 		mutex_lock(&iter->mutex);
 
+		if (ret)
+			return ret;
+
 		if (signal_pending(current))
 			return -EINTR;
 	}
@@ -5327,8 +5331,12 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 				goto out_unlock;
 			}
 			mutex_unlock(&trace_types_lock);
-			wait_on_pipe(iter);
+			ret = wait_on_pipe(iter);
 			mutex_lock(&trace_types_lock);
+			if (ret) {
+				size = ret;
+				goto out_unlock;
+			}
 			if (signal_pending(current)) {
 				size = -EINTR;
 				goto out_unlock;
@@ -5538,8 +5546,10 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 			goto out;
 		}
 		mutex_unlock(&trace_types_lock);
-		wait_on_pipe(iter);
+		ret = wait_on_pipe(iter);
 		mutex_lock(&trace_types_lock);
+		if (ret)
+			goto out;
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			goto out;
@@ -6232,22 +6242,25 @@ static int allocate_trace_buffers(struct trace_array *tr, int size)
 	return 0;
 }
 
+static void free_trace_buffer(struct trace_buffer *buf)
+{
+	if (buf->buffer) {
+		ring_buffer_free(buf->buffer);
+		buf->buffer = NULL;
+		free_percpu(buf->data);
+		buf->data = NULL;
+	}
+}
+
 static void free_trace_buffers(struct trace_array *tr)
 {
 	if (!tr)
 		return;
 
-	if (tr->trace_buffer.buffer) {
-		ring_buffer_free(tr->trace_buffer.buffer);
-		tr->trace_buffer.buffer = NULL;
-		free_percpu(tr->trace_buffer.data);
-	}
+	free_trace_buffer(&tr->trace_buffer);
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-	if (tr->max_buffer.buffer) {
-		ring_buffer_free(tr->max_buffer.buffer);
-		tr->max_buffer.buffer = NULL;
-	}
+	free_trace_buffer(&tr->max_buffer);
 #endif
 }
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9e82551dd566..9258f5a815db 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -252,7 +252,7 @@ static inline struct trace_array *top_trace_array(void)
 {
 	struct trace_array *tr;
 
-	if (list_empty(ftrace_trace_arrays.prev))
+	if (list_empty(&ftrace_trace_arrays))
 		return NULL;
 
 	tr = list_entry(ftrace_trace_arrays.prev,
