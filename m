Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaHDCgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 22:36:44 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:43200 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaHDCgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 22:36:43 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 7/7] locking/rwsem: allow waiting writers to go back to optimistic spinning
Date: Sun,  3 Aug 2014 22:36:22 -0400
Message-Id: <1407119782-41119-8-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More aggressive use of optimistic spinning and enabling readers to
participate in spinning may make tasks waiting in the queue harder
to get access to the semaphore, especially for writers who need
exclusive access.

This patch enables a waking writer to go back to the optimistic
spinning loop as long as the owner is running. This allows waiting
writers better access to the semaphore as well as reduce the size
of the waiting queue.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/rwsem-xadd.c |   38 +++++++++++++++++++++++++++++++-------
 1 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index aafc9f0..94b0124 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -484,6 +484,11 @@ static bool rwsem_optimistic_spin(struct rw_semaphore *sem,
 {
 	return false;
 }
+
+static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
+{
+	return false;
+}
 #endif
 
 /*
@@ -553,12 +558,14 @@ __visible
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
@@ -573,8 +580,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 	raw_spin_lock_irq(&sem->wait_lock);
 
 	/* account for this before adding a new element to the list */
-	if (list_empty(&sem->wait_list))
-		waiting = false;
+	waiting = !list_empty(&sem->wait_list);
 
 	list_add_tail(&waiter.list, &sem->wait_list);
 
@@ -595,23 +601,41 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 
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
+			 * Go back to optimistic spinning if possible
+			 */
+			if (rwsem_can_spin_on_owner(sem)) {
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

