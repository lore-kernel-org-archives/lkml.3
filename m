Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaKKNF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:05:26 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:47385 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752980AbaKKNFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:05:24 -0500
Date: Tue, 11 Nov 2014 08:05:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Rabin Vincent <rabin@rab.in>
Subject: [GIT PULL] tracing: Fix infinite loops when waiting for full page
 from buffer
Message-ID: <20141111080521.0e43ddd5@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Rabin Vincent found a way that tracing could cause an infinite loop
in the kernel. The splice logic wants a full page from the ring buffer
but the ring_buffer_wait() returns when there's any data in the ring buffer.
The splice code would then continue the loop waiting for a full page.
But if a full page never happens, the splice code will never sleep and
just continue to loop.

There's another case that Rabin fixed that could loop if there's no memory
and kmalloc() constantly returns NULL.

Please pull the latest trace-fixes-v3.18-rc4 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.18-rc4

Tag SHA1: 6c35a7a8ec643089be5869935d87e47a99d36ac1
Head SHA1: 07906da78810dce5fd35b9449358c9208c693dca


Rabin Vincent (2):
      tracing: Do not busy wait in buffer splice
      tracing: Do not risk busy looping in buffer splice

----
 include/linux/ring_buffer.h |  2 +-
 kernel/trace/ring_buffer.c  | 81 ++++++++++++++++++++++++++++++---------------
 kernel/trace/trace.c        | 33 +++++++++---------
 3 files changed, 70 insertions(+), 46 deletions(-)
---------------------------
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 49a4d6f59108..e2c13cd863bd 100644
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
index 2d75c94ae87d..a56e07c8d15b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -538,16 +538,18 @@ static void rb_wake_up_waiters(struct irq_work *work)
  * ring_buffer_wait - wait for input to the ring buffer
  * @buffer: buffer to wait on
  * @cpu: the cpu buffer to wait on
+ * @full: wait until a full page is available, if @cpu != RING_BUFFER_ALL_CPUS
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
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
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
+	}
 
 	finish_wait(&work->waiters, &wait);
-	return 0;
+
+	return ret;
 }
 
 /**
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a528392b1f4..92f4a6cee172 100644
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
@@ -4434,15 +4435,12 @@ static int tracing_wait_pipe(struct file *filp)
 
 		mutex_unlock(&iter->mutex);
 
-		ret = wait_on_pipe(iter);
+		ret = wait_on_pipe(iter, false);
 
 		mutex_lock(&iter->mutex);
 
 		if (ret)
 			return ret;
-
-		if (signal_pending(current))
-			return -EINTR;
 	}
 
 	return 1;
@@ -5372,16 +5370,12 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 				goto out_unlock;
 			}
 			mutex_unlock(&trace_types_lock);
-			ret = wait_on_pipe(iter);
+			ret = wait_on_pipe(iter, false);
 			mutex_lock(&trace_types_lock);
 			if (ret) {
 				size = ret;
 				goto out_unlock;
 			}
-			if (signal_pending(current)) {
-				size = -EINTR;
-				goto out_unlock;
-			}
 			goto again;
 		}
 		size = 0;
@@ -5500,7 +5494,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 	};
 	struct buffer_ref *ref;
 	int entries, size, i;
-	ssize_t ret;
+	ssize_t ret = 0;
 
 	mutex_lock(&trace_types_lock);
 
@@ -5538,13 +5532,16 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 		int r;
 
 		ref = kzalloc(sizeof(*ref), GFP_KERNEL);
-		if (!ref)
+		if (!ref) {
+			ret = -ENOMEM;
 			break;
+		}
 
 		ref->ref = 1;
 		ref->buffer = iter->trace_buffer->buffer;
 		ref->page = ring_buffer_alloc_read_page(ref->buffer, iter->cpu_file);
 		if (!ref->page) {
+			ret = -ENOMEM;
 			kfree(ref);
 			break;
 		}
@@ -5582,19 +5579,19 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 
 	/* did we read anything? */
 	if (!spd.nr_pages) {
+		if (ret)
+			goto out;
+
 		if ((file->f_flags & O_NONBLOCK) || (flags & SPLICE_F_NONBLOCK)) {
 			ret = -EAGAIN;
 			goto out;
 		}
 		mutex_unlock(&trace_types_lock);
-		ret = wait_on_pipe(iter);
+		ret = wait_on_pipe(iter, true);
 		mutex_lock(&trace_types_lock);
 		if (ret)
 			goto out;
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			goto out;
-		}
+
 		goto again;
 	}
 
