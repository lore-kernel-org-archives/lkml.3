Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbaHGW1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 18:27:34 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:21169 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaHGW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 18:27:08 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2 7/7] locking/rwsem: allow waiting writers to go back to spinning
Date: Thu,  7 Aug 2014 18:26:48 -0400
Message-Id: <1407450408-11679-8-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
References: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More aggressive use of optimistic spinning and enabling readers to
participate in spinning may make tasks waiting in the queue harder
to get access to the semaphore, especially for writers who need
exclusive access.

This patch enables a waking writer to go back to the optimistic
spinning loop as long as the owner is really running and spinners are
present. This allows waiting writers better access to the semaphore
as well as reduce the size of the waiting queue.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/rwsem-xadd.c |   55 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 16fabe0..20adbe9 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -355,10 +355,15 @@ wake_readers:
 
 }
 
-static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
+/*
+ * The defval argument controls whether true or false is returned
+ * when the owner field is NULL.
+ */
+static inline bool
+rwsem_can_spin_on_owner(struct rw_semaphore *sem, bool defval)
 {
 	struct task_struct *owner;
-	bool on_cpu = true;
+	bool on_cpu = defval;
 
 	if (need_resched())
 		return false;
@@ -431,7 +436,7 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem,
 	int  spincnt = 0;
 
 	/* sem->wait_lock should not be held when doing optimistic spinning */
-	if (!rwsem_can_spin_on_owner(sem))
+	if (!rwsem_can_spin_on_owner(sem, true))
 		return false;
 
 	preempt_disable();
@@ -489,6 +494,12 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem,
 {
 	return false;
 }
+
+static inline bool
+rwsem_can_spin_on_owner(struct rw_semaphore *sem, bool default)
+{
+	return false;
+}
 #endif
 
 /*
@@ -558,12 +569,14 @@ __visible
 struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
 	long count;
-	bool waiting = true; /* any queued threads before us */
+	bool waiting; /* any queued threads before us */
+	bool respin;
 	struct rwsem_waiter waiter;
 
 	/* undo write bias from down_write operation, stop active locking */
 	count = rwsem_atomic_update(-RWSEM_ACTIVE_WRITE_BIAS, sem);
 
+optspin:
 	/* do optimistic spinning and steal lock if possible */
 	if (rwsem_optimistic_spin(sem, RWSEM_WAITING_FOR_WRITE))
 		return sem;
@@ -578,8 +591,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 	raw_spin_lock_irq(&sem->wait_lock);
 
 	/* account for this before adding a new element to the list */
-	if (list_empty(&sem->wait_list))
-		waiting = false;
+	waiting = !list_empty(&sem->wait_list);
 
 	list_add_tail(&waiter.list, &sem->wait_list);
 
@@ -600,23 +612,46 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 
 	/* wait until we successfully acquire the lock */
 	set_current_state(TASK_UNINTERRUPTIBLE);
-	while (true) {
+	respin = false;
+	while (!respin) {
 		if (rwsem_try_write_lock(count, sem))
 			break;
 		raw_spin_unlock_irq(&sem->wait_lock);
 
-		/* Block until there are no active lockers. */
-		do {
+		/*
+		 * Block until there are no active lockers or optimistic
+		 * spinning is possible.
+		 */
+		while (true) {
 			schedule();
 			set_current_state(TASK_UNINTERRUPTIBLE);
-		} while ((count = sem->count) & RWSEM_ACTIVE_MASK);
+			count = ACCESS_ONCE(sem->count);
+			if (!(count & RWSEM_ACTIVE_MASK))
+				break;
+			/*
+			 * Go back to optimistic spinning if the lock
+			 * owner is really running and there are spinners.
+			 * If there is no spinner, the task is already at
+			 * the head of the queue or the lock owner (maybe
+			 * readers) may not be actually running.
+			 */
+			if (rwsem_has_spinner(sem) &&
+			    rwsem_can_spin_on_owner(sem, false)) {
+				respin = true;
+				break;
+			}
+		}
 
 		raw_spin_lock_irq(&sem->wait_lock);
 	}
 	__set_current_state(TASK_RUNNING);
 
 	list_del(&waiter.list);
+	if (respin && list_empty(&sem->wait_list))
+		rwsem_atomic_update(-RWSEM_WAITING_BIAS, sem);
 	raw_spin_unlock_irq(&sem->wait_lock);
+	if (respin)
+		goto optspin;
 
 	return sem;
 }
-- 
1.7.1

