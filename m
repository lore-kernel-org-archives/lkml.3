Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935284AbaGXKRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:17:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54791 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaGXJrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 046/128] ring-buffer: Check if buffer exists before polling
Date: Thu, 24 Jul 2014 10:44:55 +0100
Message-Id: <1406195177-8656-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

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
[ luis: backported to 3.11: used rostedt's backport for 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
index 56ecc310b818..5f22856fd02a 100644
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
@@ -4064,17 +4064,19 @@ tracing_poll_pipe(struct file *filp, poll_table *poll_table)
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
 
@@ -4084,10 +4086,13 @@ static int tracing_wait_pipe(struct file *filp)
 
 		mutex_unlock(&iter->mutex);
 
-		iter->trace->wait_pipe(iter);
+		ret = iter->trace->wait_pipe(iter);
 
 		mutex_lock(&iter->mutex);
 
+		if (ret)
+			return ret;
+
 		if (signal_pending(current))
 			return -EINTR;
 
@@ -5021,8 +5026,12 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
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
@@ -5234,8 +5243,10 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
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
index afaae41b0a02..61fbe61ed3a0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -333,7 +333,7 @@ struct tracer {
 	void			(*stop)(struct trace_array *tr);
 	void			(*open)(struct trace_iterator *iter);
 	void			(*pipe_open)(struct trace_iterator *iter);
-	void			(*wait_pipe)(struct trace_iterator *iter);
+	int			(*wait_pipe)(struct trace_iterator *iter);
 	void			(*close)(struct trace_iterator *iter);
 	void			(*pipe_close)(struct trace_iterator *iter);
 	ssize_t			(*read)(struct trace_iterator *iter,
@@ -548,7 +548,7 @@ void trace_init_global_iter(struct trace_iterator *iter);
 
 void tracing_iter_reset(struct trace_iterator *iter, int cpu);
 
-void poll_wait_pipe(struct trace_iterator *iter);
+int poll_wait_pipe(struct trace_iterator *iter);
 
 void tracing_sched_switch_trace(struct trace_array *tr,
 				struct task_struct *prev,
-- 
1.9.1

