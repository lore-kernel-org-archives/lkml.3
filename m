Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab3CBDB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:01:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5971 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab3CBDAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:00:54 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=wdXVsk6TmcMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=YUoYiEO2lIAA:10 a=1T9jN4Cz1hROu4quVLwA:9 a=jeBq3FmKZ4MA:10 a=_jxRpb4IoJvlpPwD:21 a=1agdKE7kWPSqXZBq:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130302030051.057315901@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Mar 2013 21:48:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Subject: [for-next][PATCH 7/7] tracing/ring-buffer: Move poll wake ups into ring buffer code
References: <20130302024833.624729274@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-ring-buffer-Move-poll-wake-ups-into-ring-buf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Move the logic to wake up on ring buffer data into the ring buffer
code itself. This simplifies the tracing code a lot and also has the
added benefit that waiters on one of the instance buffers can be woken
only when data is added to that instance instead of data added to
any instance.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |    6 ++
 kernel/trace/ring_buffer.c  |  146 +++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c        |   83 ++++--------------------
 3 files changed, 164 insertions(+), 71 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 1342e69..d69cf63 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -4,6 +4,7 @@
 #include <linux/kmemcheck.h>
 #include <linux/mm.h>
 #include <linux/seq_file.h>
+#include <linux/poll.h>
 
 struct ring_buffer;
 struct ring_buffer_iter;
@@ -96,6 +97,11 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
 	__ring_buffer_alloc((size), (flags), &__key);	\
 })
 
+void ring_buffer_wait(struct ring_buffer *buffer, int cpu);
+int ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
+			  struct file *filp, poll_table *poll_table);
+
+
 #define RING_BUFFER_ALL_CPUS -1
 
 void ring_buffer_free(struct ring_buffer *buffer);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7244acd..56b6ea3 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -8,6 +8,7 @@
 #include <linux/trace_clock.h>
 #include <linux/trace_seq.h>
 #include <linux/spinlock.h>
+#include <linux/irq_work.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
@@ -442,6 +443,12 @@ int ring_buffer_print_page_header(struct trace_seq *s)
 	return ret;
 }
 
+struct rb_irq_work {
+	struct irq_work			work;
+	wait_queue_head_t		waiters;
+	bool				waiters_pending;
+};
+
 /*
  * head_page == tail_page && head == tail then buffer is empty.
  */
@@ -476,6 +483,8 @@ struct ring_buffer_per_cpu {
 	struct list_head		new_pages; /* new pages to add */
 	struct work_struct		update_pages_work;
 	struct completion		update_done;
+
+	struct rb_irq_work		irq_work;
 };
 
 struct ring_buffer {
@@ -495,6 +504,8 @@ struct ring_buffer {
 	struct notifier_block		cpu_notify;
 #endif
 	u64				(*clock)(void);
+
+	struct rb_irq_work		irq_work;
 };
 
 struct ring_buffer_iter {
@@ -506,6 +517,118 @@ struct ring_buffer_iter {
 	u64				read_stamp;
 };
 
+/*
+ * rb_wake_up_waiters - wake up tasks waiting for ring buffer input
+ *
+ * Schedules a delayed work to wake up any task that is blocked on the
+ * ring buffer waiters queue.
+ */
+static void rb_wake_up_waiters(struct irq_work *work)
+{
+	struct rb_irq_work *rbwork = container_of(work, struct rb_irq_work, work);
+
+	wake_up_all(&rbwork->waiters);
+}
+
+/**
+ * ring_buffer_wait - wait for input to the ring buffer
+ * @buffer: buffer to wait on
+ * @cpu: the cpu buffer to wait on
+ *
+ * If @cpu == RING_BUFFER_ALL_CPUS then the task will wake up as soon
+ * as data is added to any of the @buffer's cpu buffers. Otherwise
+ * it will wait for data to be added to a specific cpu buffer.
+ */
+void ring_buffer_wait(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	DEFINE_WAIT(wait);
+	struct rb_irq_work *work;
+
+	/*
+	 * Depending on what the caller is waiting for, either any
+	 * data in any cpu buffer, or a specific buffer, put the
+	 * caller on the appropriate wait queue.
+	 */
+	if (cpu == RING_BUFFER_ALL_CPUS)
+		work = &buffer->irq_work;
+	else {
+		cpu_buffer = buffer->buffers[cpu];
+		work = &cpu_buffer->irq_work;
+	}
+
+
+	prepare_to_wait(&work->waiters, &wait, TASK_INTERRUPTIBLE);
+
+	/*
+	 * The events can happen in critical sections where
+	 * checking a work queue can cause deadlocks.
+	 * After adding a task to the queue, this flag is set
+	 * only to notify events to try to wake up the queue
+	 * using irq_work.
+	 *
+	 * We don't clear it even if the buffer is no longer
+	 * empty. The flag only causes the next event to run
+	 * irq_work to do the work queue wake up. The worse
+	 * that can happen if we race with !trace_empty() is that
+	 * an event will cause an irq_work to try to wake up
+	 * an empty queue.
+	 *
+	 * There's no reason to protect this flag either, as
+	 * the work queue and irq_work logic will do the necessary
+	 * synchronization for the wake ups. The only thing
+	 * that is necessary is that the wake up happens after
+	 * a task has been queued. It's OK for spurious wake ups.
+	 */
+	work->waiters_pending = true;
+
+	if ((cpu == RING_BUFFER_ALL_CPUS && ring_buffer_empty(buffer)) ||
+	    (cpu != RING_BUFFER_ALL_CPUS && ring_buffer_empty_cpu(buffer, cpu)))
+		schedule();
+
+	finish_wait(&work->waiters, &wait);
+}
+
+/**
+ * ring_buffer_poll_wait - poll on buffer input
+ * @buffer: buffer to wait on
+ * @cpu: the cpu buffer to wait on
+ * @filp: the file descriptor
+ * @poll_table: The poll descriptor
+ *
+ * If @cpu == RING_BUFFER_ALL_CPUS then the task will wake up as soon
+ * as data is added to any of the @buffer's cpu buffers. Otherwise
+ * it will wait for data to be added to a specific cpu buffer.
+ *
+ * Returns POLLIN | POLLRDNORM if data exists in the buffers,
+ * zero otherwise.
+ */
+int ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
+			  struct file *filp, poll_table *poll_table)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+	struct rb_irq_work *work;
+
+	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
+	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
+		return POLLIN | POLLRDNORM;
+
+	if (cpu == RING_BUFFER_ALL_CPUS)
+		work = &buffer->irq_work;
+	else {
+		cpu_buffer = buffer->buffers[cpu];
+		work = &cpu_buffer->irq_work;
+	}
+
+	work->waiters_pending = true;
+	poll_wait(filp, &work->waiters, poll_table);
+
+	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
+	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
 /* buffer may be either ring_buffer or ring_buffer_per_cpu */
 #define RB_WARN_ON(b, cond)						\
 	({								\
@@ -1061,6 +1184,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int nr_pages, int cpu)
 	cpu_buffer->lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 	INIT_WORK(&cpu_buffer->update_pages_work, update_pages_handler);
 	init_completion(&cpu_buffer->update_done);
+	init_irq_work(&cpu_buffer->irq_work.work, rb_wake_up_waiters);
 
 	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 			    GFP_KERNEL, cpu_to_node(cpu));
@@ -1156,6 +1280,8 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 	buffer->clock = trace_clock_local;
 	buffer->reader_lock_key = key;
 
+	init_irq_work(&buffer->irq_work.work, rb_wake_up_waiters);
+
 	/* need at least two pages */
 	if (nr_pages < 2)
 		nr_pages = 2;
@@ -2610,6 +2736,22 @@ static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 	rb_end_commit(cpu_buffer);
 }
 
+static __always_inline void
+rb_wakeups(struct ring_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
+{
+	if (buffer->irq_work.waiters_pending) {
+		buffer->irq_work.waiters_pending = false;
+		/* irq_work_queue() supplies it's own memory barriers */
+		irq_work_queue(&buffer->irq_work.work);
+	}
+
+	if (cpu_buffer->irq_work.waiters_pending) {
+		cpu_buffer->irq_work.waiters_pending = false;
+		/* irq_work_queue() supplies it's own memory barriers */
+		irq_work_queue(&cpu_buffer->irq_work.work);
+	}
+}
+
 /**
  * ring_buffer_unlock_commit - commit a reserved
  * @buffer: The buffer to commit to
@@ -2629,6 +2771,8 @@ int ring_buffer_unlock_commit(struct ring_buffer *buffer,
 
 	rb_commit(cpu_buffer, event);
 
+	rb_wakeups(buffer, cpu_buffer);
+
 	trace_recursive_unlock();
 
 	preempt_enable_notrace();
@@ -2801,6 +2945,8 @@ int ring_buffer_write(struct ring_buffer *buffer,
 
 	rb_commit(cpu_buffer, event);
 
+	rb_wakeups(buffer, cpu_buffer);
+
 	ret = 0;
  out:
 	preempt_enable_notrace();
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 32b003c..e0cf94c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -19,7 +19,6 @@
 #include <linux/seq_file.h>
 #include <linux/notifier.h>
 #include <linux/irqflags.h>
-#include <linux/irq_work.h>
 #include <linux/debugfs.h>
 #include <linux/pagemap.h>
 #include <linux/hardirq.h>
@@ -87,14 +86,6 @@ static int dummy_set_flag(u32 old_flags, u32 bit, int set)
 static DEFINE_PER_CPU(bool, trace_cmdline_save);
 
 /*
- * When a reader is waiting for data, then this variable is
- * set to true.
- */
-static bool trace_wakeup_needed;
-
-static struct irq_work trace_work_wakeup;
-
-/*
  * Kill all tracing for good (never come back).
  * It is initialized to 1 but will turn to zero if the initialization
  * of the tracer is successful. But that is the only place that sets
@@ -334,9 +325,6 @@ static inline void trace_access_lock_init(void)
 
 #endif
 
-/* trace_wait is a waitqueue for tasks blocked on trace_poll */
-static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
-
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
@@ -344,19 +332,6 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS;
 
 /**
- * trace_wake_up - wake up tasks waiting for trace input
- *
- * Schedules a delayed work to wake up any task that is blocked on the
- * trace_wait queue. These is used with trace_poll for tasks polling the
- * trace.
- */
-static void trace_wake_up(struct irq_work *work)
-{
-	wake_up_all(&trace_wait);
-
-}
-
-/**
  * tracing_on - enable tracing buffers
  *
  * This function enables tracing buffers that may have been
@@ -762,36 +737,11 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 
 static void default_wait_pipe(struct trace_iterator *iter)
 {
-	DEFINE_WAIT(wait);
-
-	prepare_to_wait(&trace_wait, &wait, TASK_INTERRUPTIBLE);
-
-	/*
-	 * The events can happen in critical sections where
-	 * checking a work queue can cause deadlocks.
-	 * After adding a task to the queue, this flag is set
-	 * only to notify events to try to wake up the queue
-	 * using irq_work.
-	 *
-	 * We don't clear it even if the buffer is no longer
-	 * empty. The flag only causes the next event to run
-	 * irq_work to do the work queue wake up. The worse
-	 * that can happen if we race with !trace_empty() is that
-	 * an event will cause an irq_work to try to wake up
-	 * an empty queue.
-	 *
-	 * There's no reason to protect this flag either, as
-	 * the work queue and irq_work logic will do the necessary
-	 * synchronization for the wake ups. The only thing
-	 * that is necessary is that the wake up happens after
-	 * a task has been queued. It's OK for spurious wake ups.
-	 */
-	trace_wakeup_needed = true;
-
-	if (trace_empty(iter))
-		schedule();
+	/* Iterators are static, they should be filled or empty */
+	if (trace_buffer_iter(iter, iter->cpu_file))
+		return;
 
-	finish_wait(&trace_wait, &wait);
+	ring_buffer_wait(iter->tr->buffer, iter->cpu_file);
 }
 
 /**
@@ -1261,11 +1211,6 @@ void
 __buffer_unlock_commit(struct ring_buffer *buffer, struct ring_buffer_event *event)
 {
 	__this_cpu_write(trace_cmdline_save, true);
-	if (trace_wakeup_needed) {
-		trace_wakeup_needed = false;
-		/* irq_work_queue() supplies it's own memory barriers */
-		irq_work_queue(&trace_work_wakeup);
-	}
 	ring_buffer_unlock_commit(buffer, event);
 }
 
@@ -3505,21 +3450,18 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 static unsigned int
 trace_poll(struct trace_iterator *iter, struct file *filp, poll_table *poll_table)
 {
-	if (trace_flags & TRACE_ITER_BLOCK) {
+	/* Iterators are static, they should be filled or empty */
+	if (trace_buffer_iter(iter, iter->cpu_file))
+		return POLLIN | POLLRDNORM;
+
+	if (trace_flags & TRACE_ITER_BLOCK)
 		/*
 		 * Always select as readable when in blocking mode
 		 */
 		return POLLIN | POLLRDNORM;
-	} else {
-		if (!trace_empty(iter))
-			return POLLIN | POLLRDNORM;
-		trace_wakeup_needed = true;
-		poll_wait(filp, &trace_wait, poll_table);
-		if (!trace_empty(iter))
-			return POLLIN | POLLRDNORM;
-
-		return 0;
-	}
+	else
+		return ring_buffer_poll_wait(iter->tr->buffer, iter->cpu_file,
+					     filp, poll_table);
 }
 
 static unsigned int
@@ -5644,7 +5586,6 @@ __init static int tracer_alloc_buffers(void)
 #endif
 
 	trace_init_cmdlines();
-	init_irq_work(&trace_work_wakeup, trace_wake_up);
 
 	register_tracer(&nop_trace);
 
-- 
1.7.10.4


