Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab3CFXXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:23:41 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:55912 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab3CFXWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:22:07 -0500
From: Michel Lespinasse <walken@google.com>
To: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] rwsem: more agressive lock stealing in rwsem_down_write_failed
Date: Wed,  6 Mar 2013 15:21:45 -0800
Message-Id: <1362612111-28673-7-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362612111-28673-1-git-send-email-walken@google.com>
References: <1362612111-28673-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some small code simplifications can be achieved by doing more agressive
lock stealing:

- When rwsem_down_write_failed() notices that there are no active locks
  (and thus no thread to wake us if we decided to sleep), it used to wake
  the first queued process. However, stealing the lock is also sufficient
  to deal with this case, so we don't need this check anymore.

- In try_get_writer_sem(), we can steal the lock even when the first waiter
  is a reader. This is correct because the code path that wakes readers is
  protected by the wait_lock. As to the performance effects of this change,
  they are expected to be minimal: readers are still granted the lock
  (rather than having to acquire it themselves) when they reach the front
  of the wait queue, so we have essentially the same behavior as in
  rwsem-spinlock.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 lib/rwsem.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index c73bd96dc30c..2360bf204098 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -143,20 +143,12 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 }
 
 /* Try to get write sem, caller holds sem->wait_lock: */
-static int try_get_writer_sem(struct rw_semaphore *sem,
-					struct rwsem_waiter *waiter)
+static int try_get_writer_sem(struct rw_semaphore *sem)
 {
-	struct rwsem_waiter *fwaiter;
 	long oldcount, adjustment;
 
-	/* only steal when first waiter is writing */
-	fwaiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-	if (fwaiter->type != RWSEM_WAITING_FOR_WRITE)
-		return 0;
-
 	adjustment = RWSEM_ACTIVE_WRITE_BIAS;
-	/* Only one waiter in the queue: */
-	if (fwaiter == waiter && waiter->list.next == &sem->wait_list)
+	if (list_is_singular(&sem->wait_list))
 		adjustment -= RWSEM_WAITING_BIAS;
 
 try_again_write:
@@ -233,23 +225,18 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 	/* we're now waiting on the lock, but no longer actively locking */
 	count = rwsem_atomic_update(adjustment, sem);
 
-	/* If there are no active locks, wake the front queued process(es) up.
-	 *
-	 * Alternatively, if we're called from a failed down_write(), there
-	 * were already threads queued before us and there are no active
-	 * writers, the lock must be read owned; so we try to wake any read
-	 * locks that were queued ahead of us. */
-	if (count == RWSEM_WAITING_BIAS)
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_NO_ACTIVE);
-	else if (count > RWSEM_WAITING_BIAS &&
-		 adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
+	/* If there were already threads queued before us and there are no
+	 * active writers, the lock must be read owned; so we try to wake
+	 * any read locks that were queued ahead of us. */
+	if (count > RWSEM_WAITING_BIAS &&
+	    adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
 		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
 
 	/* wait until we successfully acquire the lock */
 	while (true) {
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 
-		if (try_get_writer_sem(sem, &waiter))
+		if (try_get_writer_sem(sem))
 			break;
 
 		raw_spin_unlock_irq(&sem->wait_lock);
-- 
1.8.1.3
