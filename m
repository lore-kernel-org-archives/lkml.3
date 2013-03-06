Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab3CFXWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:22:46 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:62736 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab3CFXWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:22:16 -0500
From: Michel Lespinasse <walken@google.com>
To: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] rwsem: wake all readers when first waiter is a reader
Date: Wed,  6 Mar 2013 15:21:50 -0800
Message-Id: <1362612111-28673-12-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362612111-28673-1-git-send-email-walken@google.com>
References: <1362612111-28673-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the first queued waiter is a reader, wake all readers instead of
just those that are at the front of the queue. There are really two
motivations for this change:

- This should result in increased parallelism for workloads that mix
  readers and writers.

- As we want to enable fast-path write lock stealing (without taking the
  wait_lock), we don't want to spend much time counting readers to wake
  while fast-path write lock stealing might still get the lock. By
  maintaining a count of queued readers, and waking them all at once, we
  avoid having to count readers before attempting to grand them read locks.

Regarding the implementation, a few things are worth mentioning:

- On 64-bit architectures, wait_readers fills a hole that would otherwise
  be present between wait_lock and wait_list, so it doesn't actually grow
  the struct rw_semaphore size.

- The only difference between the RWSEM_WAKE_ANY and RWSEM_WAKE_NO_ACTIVE
  wake types was whether we need to check for write locks before granting
  read locks. The updated code always starts by granting read locks, so
  the difference is now moot. We can thus replace the wake_type with a
  boolean 'wakewrite' value, just as in rwsem-spinlock.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 include/linux/rwsem.h |   2 +
 lib/rwsem.c           | 128 ++++++++++++++++++++------------------------------
 2 files changed, 53 insertions(+), 77 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 8da67d625e13..be6f9649512d 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -25,6 +25,7 @@ struct rw_semaphore;
 struct rw_semaphore {
 	long			count;
 	raw_spinlock_t		wait_lock;
+	unsigned int		wait_readers;
 	struct list_head	wait_list;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
@@ -58,6 +59,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 #define __RWSEM_INITIALIZER(name)			\
 	{ RWSEM_UNLOCKED_VALUE,				\
 	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
+	  0,						\
 	  LIST_HEAD_INIT((name).wait_list)		\
 	  __RWSEM_DEP_MAP_INIT(name) }
 
diff --git a/lib/rwsem.c b/lib/rwsem.c
index 0d50e46d5b0c..f9a57054e9f2 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -41,14 +41,6 @@ struct rwsem_waiter {
 	enum rwsem_waiter_type type;
 };
 
-/* Wake types for __rwsem_do_wake().  Note that RWSEM_WAKE_NO_ACTIVE and
- * RWSEM_WAKE_READ_OWNED imply that the spinlock must have been kept held
- * since the rwsem value was observed.
- */
-#define RWSEM_WAKE_ANY        0 /* Wake whatever's at head of wait list */
-#define RWSEM_WAKE_NO_ACTIVE  1 /* rwsem was observed with no active thread */
-#define RWSEM_WAKE_READ_OWNED 2 /* rwsem was observed to be read owned */
-
 /*
  * handle the lock release when processes blocked on it that can now run
  * - if we come here from up_xxxx(), then:
@@ -60,83 +52,64 @@ struct rwsem_waiter {
  * - writers are only woken if downgrading is false
  */
 static struct rw_semaphore *
-__rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
+__rwsem_do_wake(struct rw_semaphore *sem, bool wakewrite)
 {
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
 	struct list_head *next;
-	signed long woken, loop, adjustment;
+	signed long oldcount, readers, adjustment;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
-	if (waiter->type != RWSEM_WAITING_FOR_WRITE)
-		goto readers_only;
-
-	if (wake_type == RWSEM_WAKE_READ_OWNED)
-		/* Another active reader was observed, so wakeup is not
-		 * likely to succeed. Save the atomic op.
-		 */
+	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
+		if (wakewrite)
+			/* Wake writer at the front of the queue, but do not
+			 * grant it the lock yet as we want other writers
+			 * to be able to steal it.  Readers, on the other hand,
+			 * will block as they will notice the queued writer.
+			 */
+			wake_up_process(waiter->task);
 		goto out;
+	}
 
-	/* Wake up the writing waiter and let the task grab the sem: */
-	wake_up_process(waiter->task);
-	goto out;
-
- readers_only:
-	/* If we come here from up_xxxx(), another thread might have reached
-	 * rwsem_down_failed_common() before we acquired the spinlock and
-	 * woken up a waiter, making it now active.  We prefer to check for
-	 * this first in order to not spend too much time with the spinlock
-	 * held if we're not going to be able to wake up readers in the end.
-	 *
-	 * Note that we do not need to update the rwsem count: any writer
-	 * trying to acquire rwsem will run rwsem_down_write_failed() due
-	 * to the waiting threads and block trying to acquire the spinlock.
-	 *
-	 * We use a dummy atomic update in order to acquire the cache line
-	 * exclusively since we expect to succeed and run the final rwsem
-	 * count adjustment pretty soon.
+	/* Writers might steal the lock before we grant it to the next reader.
+	 * We grant the lock to readers ASAP so we can bail out early if a
+	 * writer stole the lock.
 	 */
-	if (wake_type == RWSEM_WAKE_ANY &&
-	    rwsem_atomic_update(0, sem) < RWSEM_WAITING_BIAS)
-		/* Someone grabbed the sem for write already */
-		goto out;
+	readers = sem->wait_readers;
+	adjustment = readers * RWSEM_ACTIVE_READ_BIAS - RWSEM_WAITING_BIAS;
+ retry_reader_grants:
+	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
+	if (unlikely(oldcount < RWSEM_WAITING_BIAS)) {
+		/* A writer stole the lock.  Undo our reader grants. */
+		if (rwsem_atomic_update(-adjustment, sem) < RWSEM_WAITING_BIAS)
+			goto out;
+		/* The writer left.  Retry waking readers. */
+		goto retry_reader_grants;
+	}
 
-	/* Grant an infinite number of read locks to the readers at the front
-	 * of the queue.  Note we increment the 'active part' of the count by
-	 * the number of readers before waking any processes up.
+	/* Read locks have been granted to all queued readers; we can now
+	 * actualy wake them.
 	 */
-	woken = 0;
 	do {
-		woken++;
-
-		if (waiter->list.next == &sem->wait_list)
-			break;
-
-		waiter = list_entry(waiter->list.next,
-					struct rwsem_waiter, list);
-
-	} while (waiter->type != RWSEM_WAITING_FOR_WRITE);
-
-	adjustment = woken * RWSEM_ACTIVE_READ_BIAS;
-	if (waiter->type != RWSEM_WAITING_FOR_WRITE)
-		/* hit end of list above */
-		adjustment -= RWSEM_WAITING_BIAS;
-
-	rwsem_atomic_add(adjustment, sem);
-
-	next = sem->wait_list.next;
-	for (loop = woken; loop > 0; loop--) {
-		waiter = list_entry(next, struct rwsem_waiter, list);
 		next = waiter->list.next;
-		tsk = waiter->task;
-		smp_mb();
-		waiter->task = NULL;
-		wake_up_process(tsk);
-		put_task_struct(tsk);
-	}
-
-	sem->wait_list.next = next;
-	next->prev = &sem->wait_list;
+		if (waiter->type != RWSEM_WAITING_FOR_WRITE) {
+			list_del(&waiter->list);
+
+			/* Set RWSEM_WAITING_BIAS before waking the last reader
+			 * so we know there will be a remaining active locker.
+			 */
+			if (!(--readers) && !list_empty(&sem->wait_list))
+				rwsem_atomic_add(RWSEM_WAITING_BIAS, sem);
+
+			tsk = waiter->task;
+			smp_mb();
+			waiter->task = NULL;
+			wake_up_process(tsk);
+			put_task_struct(tsk);
+		}
+		waiter = list_entry(next, struct rwsem_waiter, list);
+	} while (readers);
+	sem->wait_readers = 0;
 
  out:
 	return sem;
@@ -158,6 +131,7 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 	get_task_struct(tsk);
 
 	raw_spin_lock_irq(&sem->wait_lock);
+	sem->wait_readers++;
 	if (list_empty(&sem->wait_list))
 		adjustment += RWSEM_WAITING_BIAS;
 	list_add_tail(&waiter.list, &sem->wait_list);
@@ -166,8 +140,8 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 	count = rwsem_atomic_update(adjustment, sem);
 
 	/* If there are no active locks, wake the front queued process(es). */
-	if (count == RWSEM_WAITING_BIAS)
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_NO_ACTIVE);
+	if (!(count & RWSEM_ACTIVE_MASK))
+		sem = __rwsem_do_wake(sem, true);
 
 	raw_spin_unlock_irq(&sem->wait_lock);
 
@@ -211,7 +185,7 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 	 * any read locks that were queued ahead of us. */
 	if (count > RWSEM_WAITING_BIAS &&
 	    adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
+		sem = __rwsem_do_wake(sem, false);
 
 	/* wait until we successfully acquire the lock */
 	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
@@ -256,7 +230,7 @@ struct rw_semaphore *rwsem_wake(struct rw_semaphore *sem)
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
+		sem = __rwsem_do_wake(sem, true);
 
 	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 
@@ -276,7 +250,7 @@ struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
+		sem = __rwsem_do_wake(sem, false);
 
 	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 
-- 
1.8.1.3
