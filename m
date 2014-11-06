Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaKFV0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:26:21 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:57054 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaKFV0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:26:18 -0500
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 1/2] tracing: don't busy wait in buffer splice
Date: Thu,  6 Nov 2014 22:26:06 +0100
Message-Id: <1415309167-2373-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a !PREEMPT kernel, attempting to use trace-cmd results in a soft
lockup:

 # trace-cmd record -e raw_syscalls:* -F false
 NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [trace-cmd:61]
 ...
 Call Trace:
  [<ffffffff8105b580>] ? __wake_up_common+0x90/0x90
  [<ffffffff81092e25>] wait_on_pipe+0x35/0x40
  [<ffffffff810936e3>] tracing_buffers_splice_read+0x2e3/0x3c0
  [<ffffffff81093300>] ? tracing_stats_read+0x2a0/0x2a0
  [<ffffffff812d10ab>] ? _raw_spin_unlock+0x2b/0x40
  [<ffffffff810dc87b>] ? do_read_fault+0x21b/0x290
  [<ffffffff810de56a>] ? handle_mm_fault+0x2ba/0xbd0
  [<ffffffff81095c80>] ? trace_event_buffer_lock_reserve+0x40/0x80
  [<ffffffff810951e2>] ? trace_buffer_lock_reserve+0x22/0x60
  [<ffffffff81095c80>] ? trace_event_buffer_lock_reserve+0x40/0x80
  [<ffffffff8112415d>] do_splice_to+0x6d/0x90
  [<ffffffff81126971>] SyS_splice+0x7c1/0x800
  [<ffffffff812d1edd>] tracesys_phase2+0xd3/0xd8

The problem is this: tracing_buffers_splice_read() calls
ring_buffer_wait() to wait for data in the ring buffers.  The buffers
are not empty so ring_buffer_wait() returns immediately.  But
tracing_buffers_splice_read() calls ring_buffer_read_page() with full=1,
meaning it only wants to read a full page.  When the full page is not
available, tracing_buffers_splice_read() tries to wait again with
ring_buffer_wait(), which again returns immediately, and so on.

Fix this by adding a "full" argument to ring_buffer_wait() which will
make ring_buffer_wait() wait until the writer has left the reader's
page, i.e.  until full-page reads will succeed.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 include/linux/ring_buffer.h |  2 +-
 kernel/trace/ring_buffer.c  | 81 ++++++++++++++++++++++++++++++---------------
 kernel/trace/trace.c        | 12 ++++---
 3 files changed, 62 insertions(+), 33 deletions(-)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 49a4d6f..e2c13cd 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -97,7 +97,7 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
 	__ring_buffer_alloc((size), (flags), &__key);	\
 })
 
-int ring_buffer_wait(struct ring_buffer *buffer, int cpu);
+int ring_buffer_wait(struct ring_buffer *buffer, int cpu, bool full);
 int ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
 			  struct file *filp, poll_table *poll_table);
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2d75c94..8c8143b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -538,16 +538,18 @@ static void rb_wake_up_waiters(struct irq_work *work)
  * ring_buffer_wait - wait for input to the ring buffer
  * @buffer: buffer to wait on
  * @cpu: the cpu buffer to wait on
+ * @full: wait until a full page is available
  *
  * If @cpu == RING_BUFFER_ALL_CPUS then the task will wake up as soon
  * as data is added to any of the @buffer's cpu buffers. Otherwise
  * it will wait for data to be added to a specific cpu buffer.
  */
-int ring_buffer_wait(struct ring_buffer *buffer, int cpu)
+int ring_buffer_wait(struct ring_buffer *buffer, int cpu, bool full)
 {
-	struct ring_buffer_per_cpu *cpu_buffer;
+	struct ring_buffer_per_cpu *uninitialized_var(cpu_buffer);
 	DEFINE_WAIT(wait);
 	struct rb_irq_work *work;
+	int ret = 0;
 
 	/*
 	 * Depending on what the caller is waiting for, either any
@@ -564,36 +566,61 @@ int ring_buffer_wait(struct ring_buffer *buffer, int cpu)
 	}
 
 
-	prepare_to_wait(&work->waiters, &wait, TASK_INTERRUPTIBLE);
+	while (true) {
+		prepare_to_wait(&work->waiters, &wait, TASK_INTERRUPTIBLE);
 
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
-	work->waiters_pending = true;
+		/*
+		 * The events can happen in critical sections where
+		 * checking a work queue can cause deadlocks.
+		 * After adding a task to the queue, this flag is set
+		 * only to notify events to try to wake up the queue
+		 * using irq_work.
+		 *
+		 * We don't clear it even if the buffer is no longer
+		 * empty. The flag only causes the next event to run
+		 * irq_work to do the work queue wake up. The worse
+		 * that can happen if we race with !trace_empty() is that
+		 * an event will cause an irq_work to try to wake up
+		 * an empty queue.
+		 *
+		 * There's no reason to protect this flag either, as
+		 * the work queue and irq_work logic will do the necessary
+		 * synchronization for the wake ups. The only thing
+		 * that is necessary is that the wake up happens after
+		 * a task has been queued. It's OK for spurious wake ups.
+		 */
+		work->waiters_pending = true;
+
+		if (cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer))
+			break;
+
+		if (cpu != RING_BUFFER_ALL_CPUS &&
+		    !ring_buffer_empty_cpu(buffer, cpu)) {
+			unsigned long flags;
+			bool pagebusy;
+
+			if (!full)
+				break;
+
+			raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+			pagebusy = cpu_buffer->reader_page == cpu_buffer->commit_page;
+			raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
+
+			if (!pagebusy)
+				break;
+		}
 
-	if ((cpu == RING_BUFFER_ALL_CPUS && ring_buffer_empty(buffer)) ||
-	    (cpu != RING_BUFFER_ALL_CPUS && ring_buffer_empty_cpu(buffer, cpu)))
 		schedule();
 
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+	}
+
 	finish_wait(&work->waiters, &wait);
-	return 0;
+
+	return ret;
 }
 
 /**
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a52839..e67d0de 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1076,13 +1076,14 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 }
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
-static int wait_on_pipe(struct trace_iterator *iter)
+static int wait_on_pipe(struct trace_iterator *iter, bool full)
 {
 	/* Iterators are static, they should be filled or empty */
 	if (trace_buffer_iter(iter, iter->cpu_file))
 		return 0;
 
-	return ring_buffer_wait(iter->trace_buffer->buffer, iter->cpu_file);
+	return ring_buffer_wait(iter->trace_buffer->buffer, iter->cpu_file,
+				full);
 }
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
@@ -4434,7 +4435,7 @@ static int tracing_wait_pipe(struct file *filp)
 
 		mutex_unlock(&iter->mutex);
 
-		ret = wait_on_pipe(iter);
+		ret = wait_on_pipe(iter, false);
 
 		mutex_lock(&iter->mutex);
 
@@ -5372,7 +5373,7 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 				goto out_unlock;
 			}
 			mutex_unlock(&trace_types_lock);
-			ret = wait_on_pipe(iter);
+			ret = wait_on_pipe(iter, false);
 			mutex_lock(&trace_types_lock);
 			if (ret) {
 				size = ret;
@@ -5587,7 +5588,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 			goto out;
 		}
 		mutex_unlock(&trace_types_lock);
-		ret = wait_on_pipe(iter);
+		ret = wait_on_pipe(iter, true);
 		mutex_lock(&trace_types_lock);
 		if (ret)
 			goto out;
@@ -5595,6 +5596,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 			ret = -EINTR;
 			goto out;
 		}
+
 		goto again;
 	}
 
-- 
2.1.1

