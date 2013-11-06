Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab3KFLTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:19:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47481 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3KFLTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:19:50 -0500
Date: Wed, 6 Nov 2013 03:19:18 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-ftycee88naznulqk7ei5mbci@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] sched: Move wait code from core.c to wait.c
Git-Commit-ID: b4145872f7049e429718b40b86e1b46659988398
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 03:19:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b4145872f7049e429718b40b86e1b46659988398
Gitweb:     http://git.kernel.org/tip/b4145872f7049e429718b40b86e1b46659988398
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 4 Oct 2013 17:24:35 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 07:49:18 +0100

sched: Move wait code from core.c to wait.c

For some reason only the wait part of the wait api lives in
kernel/sched/wait.c and the wake part still lives in kernel/sched/core.c;
ammend this.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-ftycee88naznulqk7ei5mbci@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 107 +---------------------------------------------------
 kernel/sched/wait.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+), 105 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 450a34b..91b2845 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2688,109 +2688,6 @@ int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,
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
@@ -2809,7 +2706,7 @@ void complete(struct completion *x)
 
 	spin_lock_irqsave(&x->wait.lock, flags);
 	x->done++;
-	__wake_up_common(&x->wait, TASK_NORMAL, 1, 0, NULL);
+	__wake_up_locked(&x->wait, TASK_NORMAL, 1);
 	spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete);
@@ -2829,7 +2726,7 @@ void complete_all(struct completion *x)
 
 	spin_lock_irqsave(&x->wait.lock, flags);
 	x->done += UINT_MAX/2;
-	__wake_up_common(&x->wait, TASK_NORMAL, 0, 0, NULL);
+	__wake_up_locked(&x->wait, TASK_NORMAL, 0);
 	spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete_all);
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index de21c63..7d50f79 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
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
