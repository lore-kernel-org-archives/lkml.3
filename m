Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161150AbaGRNxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:53:51 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17486 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761298AbaGRNKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:10:14 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 167/170] ring-buffer: Check if buffer exists before polling
Date: Fri, 18 Jul 2014 14:12:52 +0200
Message-Id: <2cc74b130195cde747edb3061bec624cef7763e2.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8b8b36834d0fff67fc8668093f4312dd04dcf21d upstream.

The per_cpu buffers are created one per possible CPU. But these do
not mean that those CPUs are online, nor do they even exist.

With the addition of the ring buffer polling, it assumes that the
caller polls on an existing buffer. But this is not the case if
the user reads trace_pipe from a CPU that does not exist, and this
causes the kernel to crash.

Simple fix is to check the cpu against buffer bitmask against to see
if the buffer was allocated or not and return -ENODEV if it is
not.

More updates were done to pass the -ENODEV back up to userspace.

Link: http://lkml.kernel.org/r/5393DB61.6060707@oracle.com

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/ring_buffer.h |  2 +-
 kernel/trace/ring_buffer.c  |  5 ++++-
 kernel/trace/trace.c        | 25 ++++++++++++++++++-------
 kernel/trace/trace.h        |  4 ++--
 4 files changed, 25 insertions(+), 11 deletions(-)

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
index 0e337eedb909..15c4ae203885 100644
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
index 57d7c64bb980..5e9cb157d31e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1044,13 +1044,13 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 }
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
-static void default_wait_pipe(struct trace_iterator *iter)
+static int default_wait_pipe(struct trace_iterator *iter)
 {
 	/* Iterators are static, they should be filled or empty */
 	if (trace_buffer_iter(iter, iter->cpu_file))
-		return;
+		return 0;
 
-	ring_buffer_wait(iter->trace_buffer->buffer, iter->cpu_file);
+	return ring_buffer_wait(iter->trace_buffer->buffer, iter->cpu_file);
 }
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
@@ -4059,17 +4059,19 @@ tracing_poll_pipe(struct file *filp, poll_table *poll_table)
  *
  *     Anyway, this is really very primitive wakeup.
  */
-void poll_wait_pipe(struct trace_iterator *iter)
+int poll_wait_pipe(struct trace_iterator *iter)
 {
 	set_current_state(TASK_INTERRUPTIBLE);
 	/* sleep for 100 msecs, and try again. */
 	schedule_timeout(HZ / 10);
+	return 0;
 }
 
 /* Must be called with trace_types_lock mutex held. */
 static int tracing_wait_pipe(struct file *filp)
 {
 	struct trace_iterator *iter = filp->private_data;
+	int ret;
 
 	while (trace_empty(iter)) {
 
@@ -4079,10 +4081,13 @@ static int tracing_wait_pipe(struct file *filp)
 
 		mutex_unlock(&iter->mutex);
 
-		iter->trace->wait_pipe(iter);
+		ret = iter->trace->wait_pipe(iter);
 
 		mutex_lock(&iter->mutex);
 
+		if (ret)
+			return ret;
+
 		if (signal_pending(current))
 			return -EINTR;
 
@@ -5016,8 +5021,12 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 				goto out_unlock;
 			}
 			mutex_unlock(&trace_types_lock);
-			iter->trace->wait_pipe(iter);
+			ret = iter->trace->wait_pipe(iter);
 			mutex_lock(&trace_types_lock);
+			if (ret) {
+				size = ret;
+				goto out_unlock;
+			}
 			if (signal_pending(current)) {
 				size = -EINTR;
 				goto out_unlock;
@@ -5229,8 +5238,10 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 			goto out;
 		}
 		mutex_unlock(&trace_types_lock);
-		iter->trace->wait_pipe(iter);
+		ret = iter->trace->wait_pipe(iter);
 		mutex_lock(&trace_types_lock);
+		if (ret)
+			goto out;
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			goto out;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 10c86fb7a2b4..7e8be3e50f83 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -334,7 +334,7 @@ struct tracer {
 	void			(*stop)(struct trace_array *tr);
 	void			(*open)(struct trace_iterator *iter);
 	void			(*pipe_open)(struct trace_iterator *iter);
-	void			(*wait_pipe)(struct trace_iterator *iter);
+	int			(*wait_pipe)(struct trace_iterator *iter);
 	void			(*close)(struct trace_iterator *iter);
 	void			(*pipe_close)(struct trace_iterator *iter);
 	ssize_t			(*read)(struct trace_iterator *iter,
@@ -549,7 +549,7 @@ void trace_init_global_iter(struct trace_iterator *iter);
 
 void tracing_iter_reset(struct trace_iterator *iter, int cpu);
 
-void poll_wait_pipe(struct trace_iterator *iter);
+int poll_wait_pipe(struct trace_iterator *iter);
 
 void tracing_sched_switch_trace(struct trace_array *tr,
 				struct task_struct *prev,
-- 
2.0.0

