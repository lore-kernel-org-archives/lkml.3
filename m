Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbaHGW1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 18:27:31 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:21164 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbaHGW1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 18:27:06 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2 6/7] locking/rwsem: enables optimistic spinning for readers
Date: Thu,  7 Aug 2014 18:26:47 -0400
Message-Id: <1407450408-11679-7-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
References: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables readers to go into the optimistic spinning loop
so that both the readers and writers can spin together. This could
speed up workloads that use both readers and writers.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/rwsem-xadd.c |  122 +++++++++++++++++++++++++++++++++++++------
 1 files changed, 106 insertions(+), 16 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index aa03479..16fabe0 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -282,6 +282,79 @@ static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
 	}
 }
 
+/*
+ * Try to acquire read lock
+ *
+ * There is ambiguity when RWSEM_WAITING_BIAS < count < 0 as a writer may
+ * be active instead of having waiters. So we need to recheck the count
+ * under wait_lock to be sure.
+ */
+static inline bool rwsem_try_read_lock_unqueued(struct rw_semaphore *sem)
+{
+	long old, count = ACCESS_ONCE(sem->count);
+	bool taken = false;	/* True if lock taken */
+
+	while (!taken) {
+		if (count < RWSEM_WAITING_BIAS)
+			break;	/* Have writer and waiter */
+
+		old = count;
+		if (count >= 0 || count == RWSEM_WAITING_BIAS) {
+			count = cmpxchg(&sem->count, old,
+					old + RWSEM_ACTIVE_READ_BIAS);
+			if (count == old) {
+				/* Got the read lock */
+				taken = true;
+				/*
+				 * Try to wake up readers if lock is free
+				 */
+				if ((count == RWSEM_WAITING_BIAS) &&
+				    raw_spin_trylock_irq(&sem->wait_lock)) {
+					if (!list_empty(&sem->wait_list))
+						goto wake_readers;
+					raw_spin_unlock_irq(&sem->wait_lock);
+				}
+			}
+		} else if (!rwsem_has_active_writer(sem)) {
+			long threshold;
+
+			/*
+			 * RWSEM_WAITING_BIAS < count < 0
+			 */
+			raw_spin_lock_irq(&sem->wait_lock);
+			threshold = list_empty(&sem->wait_list)
+				  ? 0 : RWSEM_WAITING_BIAS;
+			count = ACCESS_ONCE(sem->count);
+			if (count < threshold) {
+				raw_spin_unlock_irq(&sem->wait_lock);
+				break;
+			}
+			old   = count;
+			count = cmpxchg(&sem->count, old,
+					old + RWSEM_ACTIVE_READ_BIAS);
+			if (count == old) {
+				taken = true;
+				/*
+				 * Wake up pending readers, if any,
+				 * while holding the lock.
+				 */
+				if (threshold)
+					goto wake_readers;
+			}
+			raw_spin_unlock_irq(&sem->wait_lock);
+		} else {
+			break;
+		}
+	}
+	return taken;
+
+wake_readers:
+	__rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
+	raw_spin_unlock_irq(&sem->wait_lock);
+	return true;
+
+}
+
 static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
 {
 	struct task_struct *owner;
@@ -350,7 +423,8 @@ bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
  * the spinners will still fall back to sleep. On the other hand, it won't
  * waste too many cycles when the lock owning readers are not running.
  */
-static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
+static bool rwsem_optimistic_spin(struct rw_semaphore *sem,
+				  enum rwsem_waiter_type type)
 {
 	struct task_struct *owner;
 	bool taken = false;
@@ -380,11 +454,11 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 			spincnt = 0;
 		}
 
-		/* wait_lock will be acquired if write_lock is obtained */
-		if (rwsem_try_write_lock_unqueued(sem)) {
-			taken = true;
+		taken = (type == RWSEM_WAITING_FOR_WRITE)
+		      ? rwsem_try_write_lock_unqueued(sem)
+		      : rwsem_try_read_lock_unqueued(sem);
+		if (taken)
 			break;
-		}
 
 		/*
 		 * When there's no owner, we might have preempted between the
@@ -410,7 +484,8 @@ done:
 }
 
 #else
-static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
+static bool rwsem_optimistic_spin(struct rw_semaphore *sem,
+				  enum rwsem_waiter_type type)
 {
 	return false;
 }
@@ -422,11 +497,21 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 __visible
 struct rw_semaphore __sched * rwsem_down_read_failed(struct rw_semaphore *sem)
 {
-	long count, adjustment = -RWSEM_ACTIVE_READ_BIAS;
+	long count, adjustment = 0;
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
 
-	/* set up my own style of waitqueue */
+	/* undo read bias from down_read operation, stop active locking */
+	count = rwsem_atomic_update(-RWSEM_ACTIVE_READ_BIAS, sem);
+
+	/* do optimistic spinning and steal lock if possible */
+	if (rwsem_optimistic_spin(sem, RWSEM_WAITING_FOR_READ))
+		return sem;
+
+	/*
+	 * Optimistic spinning failed, proceed to the slowpath
+	 * and block until we can acquire the sem.
+	 */
 	waiter.task = tsk;
 	waiter.type = RWSEM_WAITING_FOR_READ;
 	get_task_struct(tsk);
@@ -436,8 +521,11 @@ struct rw_semaphore __sched * rwsem_down_read_failed(struct rw_semaphore *sem)
 		adjustment += RWSEM_WAITING_BIAS;
 	list_add_tail(&waiter.list, &sem->wait_list);
 
-	/* we're now waiting on the lock, but no longer actively locking */
-	count = rwsem_atomic_update(adjustment, sem);
+	/* we're now waiting on the lock */
+	if (adjustment)
+		count = rwsem_atomic_update(adjustment, sem);
+	else
+		count = ACCESS_ONCE(sem->count);
 
 	/* If there are no active locks, wake the front queued process(es).
 	 *
@@ -445,8 +533,7 @@ struct rw_semaphore __sched * rwsem_down_read_failed(struct rw_semaphore *sem)
 	 * wake our own waiter to join the existing active readers !
 	 */
 	if (count == RWSEM_WAITING_BIAS ||
-	    (count > RWSEM_WAITING_BIAS &&
-	     adjustment != -RWSEM_ACTIVE_READ_BIAS))
+	   (count >  RWSEM_WAITING_BIAS && adjustment))
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
 
 	raw_spin_unlock_irq(&sem->wait_lock);
@@ -478,7 +565,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 	count = rwsem_atomic_update(-RWSEM_ACTIVE_WRITE_BIAS, sem);
 
 	/* do optimistic spinning and steal lock if possible */
-	if (rwsem_optimistic_spin(sem))
+	if (rwsem_optimistic_spin(sem, RWSEM_WAITING_FOR_WRITE))
 		return sem;
 
 	/*
@@ -549,9 +636,12 @@ struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 	 * spinlock contention which may introduce too much delay in the
 	 * unlock operation.
 	 *
-	 * In case the spinning writer is just going to break out of the loop,
-	 * it will still do a trylock in rwsem_down_write_failed() before
-	 * sleeping.
+	 * In case the spinner is just going to break out of the loop, it
+	 * will still do a trylock in rwsem_down_write_failed() before
+	 * sleeping, or call __rwsem_do_wake() in rwsem_down_read_failed()
+	 * if it detects a free lock. In either cases, we won't have the
+	 * situation that the lock is free and no task is woken up from the
+	 * waiting queue.
 	 */
 	if (rwsem_has_spinner(sem)) {
 		if (!raw_spin_trylock_irqsave(&sem->wait_lock, flags))
-- 
1.7.1

