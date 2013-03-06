Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab3CFXYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:24:07 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:54234 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab3CFXWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:22:03 -0500
From: Michel Lespinasse <walken@google.com>
To: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] rwsem: simplify rwsem_down_read_failed
Date: Wed,  6 Mar 2013 15:21:43 -0800
Message-Id: <1362612111-28673-5-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362612111-28673-1-git-send-email-walken@google.com>
References: <1362612111-28673-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to acquire a read lock, the RWSEM_ACTIVE_READ_BIAS adjustment
doesn't cause other readers to block, so we never have to worry about waking
them back after canceling this adjustment in rwsem_down_read_failed().

We also never want to steal the lock in rwsem_down_read_failed(), so we
don't have to grab the wait_lock either.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 lib/rwsem.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index fb658af1c12c..66f307e90761 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -182,7 +182,6 @@ try_again_write:
  */
 struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 {
-	enum rwsem_waiter_type type = RWSEM_WAITING_FOR_READ;
 	signed long adjustment = -RWSEM_ACTIVE_READ_BIAS;
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
@@ -190,7 +189,7 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 
 	/* set up my own style of waitqueue */
 	waiter.task = tsk;
-	waiter.type = type;
+	waiter.type = RWSEM_WAITING_FOR_READ;
 	get_task_struct(tsk);
 
 	raw_spin_lock_irq(&sem->wait_lock);
@@ -201,17 +200,9 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 	/* we're now waiting on the lock, but no longer actively locking */
 	count = rwsem_atomic_update(adjustment, sem);
 
-	/* If there are no active locks, wake the front queued process(es) up.
-	 *
-	 * Alternatively, if we're called from a failed down_write(), there
-	 * were already threads queued before us and there are no active
-	 * writers, the lock must be read owned; so we try to wake any read
-	 * locks that were queued ahead of us. */
+	/* If there are no active locks, wake the front queued process(es). */
 	if (count == RWSEM_WAITING_BIAS)
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_NO_ACTIVE);
-	else if (count > RWSEM_WAITING_BIAS &&
-		 adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
 
 	raw_spin_unlock_irq(&sem->wait_lock);
 
@@ -220,15 +211,6 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 		if (!waiter.task)
 			break;
-
-		raw_spin_lock_irq(&sem->wait_lock);
-		/* Try to get the writer sem, may steal from the head writer: */
-		if (type == RWSEM_WAITING_FOR_WRITE)
-			if (try_get_writer_sem(sem, &waiter)) {
-				raw_spin_unlock_irq(&sem->wait_lock);
-				return sem;
-			}
-		raw_spin_unlock_irq(&sem->wait_lock);
 		schedule();
 	}
 
-- 
1.8.1.3
