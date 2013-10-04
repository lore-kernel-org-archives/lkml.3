Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3JDUoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:44:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55458 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3JDUoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:44:16 -0400
Date: Fri, 4 Oct 2013 22:44:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] sched/wait: Collapse __wait_event macros -v5
Message-ID: <20131004204405.GU3081@twins.programming.kicks-ass.net>
References: <20131002092217.784439754@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002092217.784439754@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


slightly related; do we want to do something like the following two
patches?

---
Subject: sched: Move wait code
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri Oct 4 17:24:35 CEST 2013

For some reason only the wait part of the wait api lives in
kernel/wait.c and the wake part still lives in kernel/sched/core.c;
ammend this.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c |  107 ----------------------------------------------------
 kernel/wait.c       |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+), 105 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2579,109 +2579,6 @@ int default_wake_function(wait_queue_t *
 }
 EXPORT_SYMBOL(default_wake_function);
 
-/*
- * The core wakeup function. Non-exclusive wakeups (nr_exclusive == 0) just
- * wake everything up. If it's an exclusive wakeup (nr_exclusive == small +ve
- * number) then we wake all the non-exclusive tasks and one exclusive task.
- *
- * There are circumstances in which we can try to wake a task which has already
- * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
- * zero in this (rare) case, and we handle it by continuing to scan the queue.
- */
-static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, int wake_flags, void *key)
-{
-	wait_queue_t *curr, *next;
-
-	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
-		unsigned flags = curr->flags;
-
-		if (curr->func(curr, mode, wake_flags, key) &&
-				(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
-			break;
-	}
-}
-
-/**
- * __wake_up - wake up threads blocked on a waitqueue.
- * @q: the waitqueue
- * @mode: which threads
- * @nr_exclusive: how many wake-one or wake-many threads to wake up
- * @key: is directly passed to the wakeup function
- *
- * It may be assumed that this function implies a write memory barrier before
- * changing the task state if and only if any tasks are woken up.
- */
-void __wake_up(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, void *key)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_common(q, mode, nr_exclusive, 0, key);
-	spin_unlock_irqrestore(&q->lock, flags);
-}
-EXPORT_SYMBOL(__wake_up);
-
-/*
- * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
- */
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr)
-{
-	__wake_up_common(q, mode, nr, 0, NULL);
-}
-EXPORT_SYMBOL_GPL(__wake_up_locked);
-
-void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
-{
-	__wake_up_common(q, mode, 1, 0, key);
-}
-EXPORT_SYMBOL_GPL(__wake_up_locked_key);
-
-/**
- * __wake_up_sync_key - wake up threads blocked on a waitqueue.
- * @q: the waitqueue
- * @mode: which threads
- * @nr_exclusive: how many wake-one or wake-many threads to wake up
- * @key: opaque value to be passed to wakeup targets
- *
- * The sync wakeup differs that the waker knows that it will schedule
- * away soon, so while the target thread will be woken up, it will not
- * be migrated to another CPU - ie. the two threads are 'synchronized'
- * with each other. This can prevent needless bouncing between CPUs.
- *
- * On UP it can prevent extra preemption.
- *
- * It may be assumed that this function implies a write memory barrier before
- * changing the task state if and only if any tasks are woken up.
- */
-void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, void *key)
-{
-	unsigned long flags;
-	int wake_flags = WF_SYNC;
-
-	if (unlikely(!q))
-		return;
-
-	if (unlikely(nr_exclusive != 1))
-		wake_flags = 0;
-
-	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_common(q, mode, nr_exclusive, wake_flags, key);
-	spin_unlock_irqrestore(&q->lock, flags);
-}
-EXPORT_SYMBOL_GPL(__wake_up_sync_key);
-
-/*
- * __wake_up_sync - see __wake_up_sync_key()
- */
-void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
-{
-	__wake_up_sync_key(q, mode, nr_exclusive, NULL);
-}
-EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
-
 /**
  * complete: - signals a single thread waiting on this completion
  * @x:  holds the state of this particular completion
@@ -2700,7 +2597,7 @@ void complete(struct completion *x)
 
 	spin_lock_irqsave(&x->wait.lock, flags);
 	x->done++;
-	__wake_up_common(&x->wait, TASK_NORMAL, 1, 0, NULL);
+	__wake_up_locked_key(&x->wait, TASK_NORMAL, NULL);
 	spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete);
@@ -2720,7 +2617,7 @@ void complete_all(struct completion *x)
 
 	spin_lock_irqsave(&x->wait.lock, flags);
 	x->done += UINT_MAX/2;
-	__wake_up_common(&x->wait, TASK_NORMAL, 0, 0, NULL);
+	__wake_up_locked(&x->wait, TASK_NORMAL, 0);
 	spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete_all);
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -53,6 +53,109 @@ EXPORT_SYMBOL(remove_wait_queue);
 
 
 /*
+ * The core wakeup function. Non-exclusive wakeups (nr_exclusive == 0) just
+ * wake everything up. If it's an exclusive wakeup (nr_exclusive == small +ve
+ * number) then we wake all the non-exclusive tasks and one exclusive task.
+ *
+ * There are circumstances in which we can try to wake a task which has already
+ * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
+ * zero in this (rare) case, and we handle it by continuing to scan the queue.
+ */
+static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
+			int nr_exclusive, int wake_flags, void *key)
+{
+	wait_queue_t *curr, *next;
+
+	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
+		unsigned flags = curr->flags;
+
+		if (curr->func(curr, mode, wake_flags, key) &&
+				(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
+			break;
+	}
+}
+
+/**
+ * __wake_up - wake up threads blocked on a waitqueue.
+ * @q: the waitqueue
+ * @mode: which threads
+ * @nr_exclusive: how many wake-one or wake-many threads to wake up
+ * @key: is directly passed to the wakeup function
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
+ */
+void __wake_up(wait_queue_head_t *q, unsigned int mode,
+			int nr_exclusive, void *key)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+	__wake_up_common(q, mode, nr_exclusive, 0, key);
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(__wake_up);
+
+/*
+ * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
+ */
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr)
+{
+	__wake_up_common(q, mode, nr, 0, NULL);
+}
+EXPORT_SYMBOL_GPL(__wake_up_locked);
+
+void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
+{
+	__wake_up_common(q, mode, 1, 0, key);
+}
+EXPORT_SYMBOL_GPL(__wake_up_locked_key);
+
+/**
+ * __wake_up_sync_key - wake up threads blocked on a waitqueue.
+ * @q: the waitqueue
+ * @mode: which threads
+ * @nr_exclusive: how many wake-one or wake-many threads to wake up
+ * @key: opaque value to be passed to wakeup targets
+ *
+ * The sync wakeup differs that the waker knows that it will schedule
+ * away soon, so while the target thread will be woken up, it will not
+ * be migrated to another CPU - ie. the two threads are 'synchronized'
+ * with each other. This can prevent needless bouncing between CPUs.
+ *
+ * On UP it can prevent extra preemption.
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
+ */
+void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
+			int nr_exclusive, void *key)
+{
+	unsigned long flags;
+	int wake_flags = 1; /* XXX WF_SYNC */
+
+	if (unlikely(!q))
+		return;
+
+	if (unlikely(nr_exclusive != 1))
+		wake_flags = 0;
+
+	spin_lock_irqsave(&q->lock, flags);
+	__wake_up_common(q, mode, nr_exclusive, wake_flags, key);
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL_GPL(__wake_up_sync_key);
+
+/*
+ * __wake_up_sync - see __wake_up_sync_key()
+ */
+void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
+{
+	__wake_up_sync_key(q, mode, nr_exclusive, NULL);
+}
+EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
+
+/*
  * Note: we use "set_current_state()" _after_ the wait-queue add,
  * because we need a memory barrier there on SMP, so that any
  * wake-function that tests for the wait-queue being active
