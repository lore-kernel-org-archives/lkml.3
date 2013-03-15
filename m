Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3COKyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:54:43 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64929 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab3COKyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:54:40 -0400
From: Michel Lespinasse <walken@google.com>
To: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/13] rwsem: simplify rwsem_down_write_failed
Date: Fri, 15 Mar 2013 03:54:21 -0700
Message-Id: <1363344869-15732-6-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363344869-15732-1-git-send-email-walken@google.com>
References: <1363344869-15732-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When waking writers, we never grant them the lock - instead, they have
to acquire it themselves when they run, and remove themselves from the
wait_list when they succeed.

As a result, we can do a few simplifications in rwsem_down_write_failed():

- We don't need to check for !waiter.task since __rwsem_do_wake() doesn't
  remove writers from the wait_list

- There is no point releaseing the wait_lock before entering the wait loop,
  as we will need to reacquire it immediately. We can change the loop so
  that the lock is always held at the start of each loop iteration.

- We don't need to get a reference on the task structure, since the task
  is responsible for removing itself from the wait_list. There is no risk,
  like in the rwsem_down_read_failed() case, that a task would wake up and
  exit (thus destroying its task structure) while __rwsem_do_wake() is
  still running - wait_lock protects against that.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 lib/rwsem.c | 33 +++++++++------------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 66f307e90761..c73bd96dc30c 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -161,16 +161,8 @@ static int try_get_writer_sem(struct rw_semaphore *sem,
 
 try_again_write:
 	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
-	if (!(oldcount & RWSEM_ACTIVE_MASK)) {
-		/* No active lock: */
-		struct task_struct *tsk = waiter->task;
-
-		list_del(&waiter->list);
-		smp_mb();
-		put_task_struct(tsk);
-		tsk->state = TASK_RUNNING;
+	if (!(oldcount & RWSEM_ACTIVE_MASK))
 		return 1;
-	}
 	/* some one grabbed the sem already */
 	if (rwsem_atomic_update(-adjustment, sem) & RWSEM_ACTIVE_MASK)
 		return 0;
@@ -220,11 +212,10 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 }
 
 /*
- * wait for the write lock to be granted
+ * wait until we successfully acquire the write lock
  */
 struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
-	enum rwsem_waiter_type type = RWSEM_WAITING_FOR_WRITE;
 	signed long adjustment = -RWSEM_ACTIVE_WRITE_BIAS;
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
@@ -232,8 +223,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 
 	/* set up my own style of waitqueue */
 	waiter.task = tsk;
-	waiter.type = type;
-	get_task_struct(tsk);
+	waiter.type = RWSEM_WAITING_FOR_WRITE;
 
 	raw_spin_lock_irq(&sem->wait_lock);
 	if (list_empty(&sem->wait_list))
@@ -255,25 +245,20 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 		 adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
 
-	raw_spin_unlock_irq(&sem->wait_lock);
-
-	/* wait to be given the lock */
+	/* wait until we successfully acquire the lock */
 	while (true) {
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
-		if (!waiter.task)
+
+		if (try_get_writer_sem(sem, &waiter))
 			break;
 
-		raw_spin_lock_irq(&sem->wait_lock);
-		/* Try to get the writer sem, may steal from the head writer: */
-		if (type == RWSEM_WAITING_FOR_WRITE)
-			if (try_get_writer_sem(sem, &waiter)) {
-				raw_spin_unlock_irq(&sem->wait_lock);
-				return sem;
-			}
 		raw_spin_unlock_irq(&sem->wait_lock);
 		schedule();
+		raw_spin_lock_irq(&sem->wait_lock);
 	}
 
+	list_del(&waiter.list);
+	raw_spin_unlock_irq(&sem->wait_lock);
 	tsk->state = TASK_RUNNING;
 
 	return sem;
-- 
1.8.1.3
