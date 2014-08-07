Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaHGW1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 18:27:15 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:21075 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbaHGW1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 18:27:00 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2 1/7] locking/rwsem: check for active writer/spinner before wakeup
Date: Thu,  7 Aug 2014 18:26:42 -0400
Message-Id: <1407450408-11679-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
References: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a highly contended rwsem, spinlock contention due to the slow
rwsem_wake() call can be a significant portion of the total CPU cycles
used. With writer lock stealing and writer optimistic spinning, there
is also a pretty good chance that the lock may have been stolen
before the waker wakes up the waiters. The woken tasks, if any,
will have to go back to sleep again.

This patch adds checking code at the beginning of the rwsem_wake()
and __rwsem_do_wake() function to look for spinner and active
writer respectively.  The presence of an active writer will abort the
wakeup operation.  The presence of a spinner will still allow wakeup
operation to proceed as long as the trylock operation succeeds. This
strikes a good balance between excessive spinlock contention especially
when there are a lot of active readers and a lot of failed fastpath
operations because there are tasks waiting in the queue.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/osq_lock.h    |    5 ++++
 kernel/locking/rwsem-xadd.c |   57 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 61 insertions(+), 1 deletions(-)

diff --git a/include/linux/osq_lock.h b/include/linux/osq_lock.h
index 90230d5..ade1973 100644
--- a/include/linux/osq_lock.h
+++ b/include/linux/osq_lock.h
@@ -24,4 +24,9 @@ static inline void osq_lock_init(struct optimistic_spin_queue *lock)
 	atomic_set(&lock->tail, OSQ_UNLOCKED_VAL);
 }
 
+static inline bool osq_is_locked(struct optimistic_spin_queue *lock)
+{
+	return atomic_read(&lock->tail) != OSQ_UNLOCKED_VAL;
+}
+
 #endif
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index a2391ac..d38cfae 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -107,6 +107,37 @@ enum rwsem_wake_type {
 	RWSEM_WAKE_READ_OWNED	/* Waker thread holds the read lock */
 };
 
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
+/*
+ * return true if there is an active writer by checking the owner field which
+ * should be set if there is one.
+ */
+static inline bool rwsem_has_active_writer(struct rw_semaphore *sem)
+{
+	struct task_struct *owner = ACCESS_ONCE(sem->owner);
+
+	return owner != NULL;
+}
+
+/*
+ * Return true if the rwsem has active spinner
+ */
+static inline bool rwsem_has_spinner(struct rw_semaphore *sem)
+{
+	return osq_is_locked(&sem->osq);
+}
+#else /* CONFIG_RWSEM_SPIN_ON_OWNER */
+static inline bool rwsem_has_active_writer(struct rw_semaphore *sem)
+{
+	return false;	/* Assume it has no active writer */
+}
+
+static inline bool rwsem_has_spinner(struct rw_semaphore *sem)
+{
+	return false;
+}
+#endif /* CONFIG_RWSEM_SPIN_ON_OWNER */
+
 /*
  * handle the lock release when processes blocked on it that can now run
  * - if we come here from up_xxxx(), then:
@@ -125,6 +156,15 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 	struct list_head *next;
 	long oldcount, woken, loop, adjustment;
 
+	/*
+	 * Abort the wakeup operation if there is an active writer as the
+	 * lock was stolen. up_write() should have cleared the owner field
+	 * before calling this function. If that field is now set, there must
+	 * be an active writer present.
+	 */
+	if (rwsem_has_active_writer(sem))
+		goto out;
+
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
 		if (wake_type == RWSEM_WAKE_ANY)
@@ -475,7 +515,22 @@ struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 {
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&sem->wait_lock, flags);
+	/*
+	 * If a spinner is present, it is not necessary to do the wakeup.
+	 * Try to do wakeup when the trylock succeeds to avoid potential
+	 * spinlock contention which may introduce too much delay in the
+	 * unlock operation.
+	 *
+	 * In case the spinning writer is just going to break out of the loop,
+	 * it will still do a trylock in rwsem_down_write_failed() before
+	 * sleeping.
+	 */
+	if (rwsem_has_spinner(sem)) {
+		if (!raw_spin_trylock_irqsave(&sem->wait_lock, flags))
+			return sem;
+	} else {
+		raw_spin_lock_irqsave(&sem->wait_lock, flags);
+	}
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
-- 
1.7.1

