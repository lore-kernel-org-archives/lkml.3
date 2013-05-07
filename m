Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001Ab3EGNta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:49:30 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44509 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933440Ab3EGNqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:46:14 -0400
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Cc: Alex Shi <alex.shi@intel.com>, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/14] rwsem: simplify rwsem_down_read_failed
Date: Tue,  7 May 2013 06:45:52 -0700
Message-Id: <1367934362-10433-5-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367934362-10433-1-git-send-email-walken@google.com>
References: <1367934362-10433-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to acquire a read lock, the RWSEM_ACTIVE_READ_BIAS adjustment
doesn't cause other readers to block, so we never have to worry about waking
them back after canceling this adjustment in rwsem_down_read_failed().

We also never want to steal the lock in rwsem_down_read_failed(), so we
don't have to grab the wait_lock either.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
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
1.8.2.1

