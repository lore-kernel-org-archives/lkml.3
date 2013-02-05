Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3BENLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:11:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:35489 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab3BENLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:11:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,602,1355126400"; 
   d="scan'208";a="252815847"
From: Alex Shi <alex.shi@intel.com>
To: mingo@kernel.org, torvalds@linux-foundation.org
Cc: paul.gortmaker@windriver.com, alex.shi@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rwsem: steal writing sem for better performance
Date: Tue,  5 Feb 2013 21:11:55 +0800
Message-Id: <1360069915-31619-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5a50508 change to rwsem from mutex, that cause aim7 fork_test
dropped 50%. Yuanhan liu does a good analysis, find it caused by
strict sequential writing. Ingo suggest stealing sem writing from
front task in waiting queue. https://lkml.org/lkml/2013/1/29/84
So has this patch.

In this patch, I just allow writing steal happen when the first waiter
is also writer. Then the performance fully recovered.

Reported-by: lkp@linux.intel.com
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 lib/rwsem.c | 75 +++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 46 insertions(+), 29 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 8337e1b..88ba8e5 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -2,6 +2,8 @@
  *
  * Written by David Howells (dhowells@redhat.com).
  * Derived from arch/i386/kernel/semaphore.c
+ *
+ * Steal writing sem. Alex Shi <alex.shi@intel.com>
  */
 #include <linux/rwsem.h>
 #include <linux/sched.h>
@@ -60,7 +62,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
 	struct list_head *next;
-	signed long oldcount, woken, loop, adjustment;
+	signed long woken, loop, adjustment;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 	if (!(waiter->flags & RWSEM_WAITING_FOR_WRITE))
@@ -72,30 +74,8 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 		 */
 		goto out;
 
-	/* There's a writer at the front of the queue - try to grant it the
-	 * write lock.  However, we only wake this writer if we can transition
-	 * the active part of the count from 0 -> 1
-	 */
-	adjustment = RWSEM_ACTIVE_WRITE_BIAS;
-	if (waiter->list.next == &sem->wait_list)
-		adjustment -= RWSEM_WAITING_BIAS;
-
- try_again_write:
-	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
-	if (oldcount & RWSEM_ACTIVE_MASK)
-		/* Someone grabbed the sem already */
-		goto undo_write;
-
-	/* We must be careful not to touch 'waiter' after we set ->task = NULL.
-	 * It is an allocated on the waiter's stack and may become invalid at
-	 * any time after that point (due to a wakeup from another source).
-	 */
-	list_del(&waiter->list);
-	tsk = waiter->task;
-	smp_mb();
-	waiter->task = NULL;
-	wake_up_process(tsk);
-	put_task_struct(tsk);
+	/* wake up the writing waiter and let the task grap sem */
+	wake_up_process(waiter->task);
 	goto out;
 
  readers_only:
@@ -157,12 +137,40 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 
  out:
 	return sem;
+}
+
+/* try to get write sem,  caller hold sem->wait_lock */
+static int try_get_writer_sem(struct rw_semaphore *sem,
+					struct rwsem_waiter *waiter)
+{
+	struct rwsem_waiter *fwaiter;
+	long oldcount, adjustment;
 
-	/* undo the change to the active count, but check for a transition
-	 * 1->0 */
- undo_write:
+	/* only steal when first waiter is writing */
+	fwaiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
+	if (!(fwaiter->flags & RWSEM_WAITING_FOR_WRITE))
+		return 0;
+
+	adjustment = RWSEM_ACTIVE_WRITE_BIAS;
+	/* only one waiter in queue */
+	if (fwaiter == waiter && waiter->list.next == &sem->wait_list)
+		adjustment -= RWSEM_WAITING_BIAS;
+
+try_again_write:
+	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
+	if (!(oldcount & RWSEM_ACTIVE_MASK)) {
+		/* no active lock */
+		struct task_struct *tsk = waiter->task;
+
+		list_del(&waiter->list);
+		smp_mb();
+		put_task_struct(tsk);
+		tsk->state = TASK_RUNNING;
+		return 1;
+	}
+	/* some one grabbed the sem already */
 	if (rwsem_atomic_update(-adjustment, sem) & RWSEM_ACTIVE_MASK)
-		goto out;
+		return 0;
 	goto try_again_write;
 }
 
@@ -210,6 +218,15 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	for (;;) {
 		if (!waiter.task)
 			break;
+
+		raw_spin_lock_irq(&sem->wait_lock);
+		/* try to get the writer sem, may steal from the head writer */
+		if (flags == RWSEM_WAITING_FOR_WRITE)
+			if (try_get_writer_sem(sem, &waiter)) {
+				raw_spin_unlock_irq(&sem->wait_lock);
+				return sem;
+			}
+		raw_spin_unlock_irq(&sem->wait_lock);
 		schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	}
-- 
1.7.12

