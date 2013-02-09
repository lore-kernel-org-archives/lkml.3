Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947450Ab3BICpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 21:45:52 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:35241 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760585Ab3BICpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 21:45:49 -0500
From: Michel Lespinasse <walken@google.com>
To: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@kernel.org, arjan@linux.intel.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, alex.shi@intel.com,
        yuanhan.liu@linux.intel.com, dhowells@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Subject: [PATCH 3/4] rwsem: implement write lock stealing
Date: Fri,  8 Feb 2013 18:45:36 -0800
Message-Id: <1360377937-16297-4-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360377937-16297-1-git-send-email-walken@google.com>
References: <1360377937-16297-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for write lock stealing in the generic rwsem code.

rwsem_down_write_failed() is similar to rwsem_down_read_failed(), with
a few significant differences:

- The waiter doesn't try waking blocked threads if there are no active
  lockers - it just steals the lock in that case.

- The waiter doesn't get removed from the wait_list upon wakeup, and
  doesn't get a lock grant either. Therefore, it has to attempt
  stealing the lock before sleeping (if it fails, then it is safe to
  sleep as the active locker will be responsible of waking it up) and
  it has to dequeue itself after successfully acquiring the lock. For
  simplicity, I moved the attempt at stealing the lock within the sem
  wait_lock, so that we can know at that time if we are the last waiter.

- There is no need to get a reference on the task structure, since the
  task is responsible for removing itself from the wait_list. There is
  no risk, like in the rwsem_down_read_failed() case, that a task
  would wake up and exit (thus destroying its task structure) while
  __rwsem_do_wake() is still running - wait_lock protects against that.

The __rwsem_do_wake() funciton is also largely rewritten to account
for the new requirements:

- The code to wake writers is simplified, as it doesn't need to grant them
  the lock (and deal with the possible case where another active locker
  might have appeared)

- The code to wake readers can't just check that there are no writers
  at the start of the operation and assume that this will still be
  true later, since writers might steal the lock until the first
  reader lock is granted. One option could be to grant the first
  reader lock, then count additional readers at the head of the queue,
  grant them extra readers locks if any, and finally wake all these
  readers. However, this gets a bit complex. Instead, I implemented a
  simpler alternative where we maintain a count of queued readers.
  This allows us to grant as many reader locks as necessary at the
  start of the operation, and then wake all these readers (regardless
  of their position in the queue).

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 include/linux/rwsem.h |   2 +
 lib/rwsem.c           | 235 +++++++++++++++++++++++---------------------------
 2 files changed, 109 insertions(+), 128 deletions(-)

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
index cd2d803cbbe4..5f3cabb9eaa7 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -39,13 +39,9 @@ struct rwsem_waiter {
 	enum rwsem_waiter_type type;
 };
 
-/* Wake types for __rwsem_do_wake().  Note that RWSEM_WAKE_NO_ACTIVE and
- * RWSEM_WAKE_READ_OWNED imply that the spinlock must have been kept held
- * since the rwsem value was observed.
- */
+/* Wake types for __rwsem_do_wake(). */
 #define RWSEM_WAKE_ANY        0 /* Wake whatever's at head of wait list */
-#define RWSEM_WAKE_NO_ACTIVE  1 /* rwsem was observed with no active thread */
-#define RWSEM_WAKE_READ_OWNED 2 /* rwsem was observed to be read owned */
+#define RWSEM_WAKE_READERS    1 /* Wake readers only */
 
 /*
  * handle the lock release when processes blocked on it that can now run
@@ -63,129 +59,79 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wake_type)
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
 	struct list_head *next;
-	signed long oldcount, woken, loop, adjustment;
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
+		if (wake_type == RWSEM_WAKE_ANY)
+			/* Wake writer at the front of the queue, but do not
+			 * grant it the lock yet as we want other writers
+			 * to be able to steal it.  Readers, on the other hand,
+			 * will block as they will notice the queued writer.
+			 */
+			wake_up_process(waiter->task);
 		goto out;
+	}
 
-	/* There's a writer at the front of the queue - try to grant it the
-	 * write lock.  However, we only wake this writer if we can transition
-	 * the active part of the count from 0 -> 1
+	/* Writers might steal the lock before we grant it to the next reader.
+	 * We grant the lock to readers ASAP so we can bail out early if a
+	 * writer stole the lock.
 	 */
-	adjustment = RWSEM_ACTIVE_WRITE_BIAS;
-	if (waiter->list.next == &sem->wait_list)
-		adjustment -= RWSEM_WAITING_BIAS;
-
- try_again_write:
+	readers = sem->wait_readers;
+	adjustment = readers * RWSEM_ACTIVE_READ_BIAS - RWSEM_WAITING_BIAS;
+ try_reader_grants:
 	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
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
-	 */
-	if (wake_type == RWSEM_WAKE_ANY &&
-	    rwsem_atomic_update(0, sem) < RWSEM_WAITING_BIAS)
-		/* Someone grabbed the sem for write already */
-		goto out;
-
-	/* Grant an infinite number of read locks to the readers at the front
-	 * of the queue.  Note we increment the 'active part' of the count by
-	 * the number of readers before waking any processes up.
-	 */
-	woken = 0;
-	do {
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
+	if (unlikely(oldcount < RWSEM_WAITING_BIAS)) {
+		/* A writer stole the lock.  Undo our reader grants. */
+		if (rwsem_atomic_update(-adjustment, sem) < RWSEM_WAITING_BIAS)
+			goto out;
+		/* The writer left.  Retry waking readers. */
+		goto try_reader_grants;
+	}
 
 	next = sem->wait_list.next;
-	for (loop = woken; loop > 0; loop--) {
+	do {
 		waiter = list_entry(next, struct rwsem_waiter, list);
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
+	} while (readers);
+	sem->wait_readers = 0;
 
  out:
 	return sem;
-
-	/* undo the change to the active count, but check for a transition
-	 * 1->0 */
- undo_write:
-	if (rwsem_atomic_update(-adjustment, sem) & RWSEM_ACTIVE_MASK)
-		goto out;
-	goto try_again_write;
 }
 
 /*
- * wait for a lock to be granted
+ * wait for the read lock to be granted
  */
-static struct rw_semaphore __sched *
-rwsem_down_failed_common(struct rw_semaphore *sem,
-			 enum rwsem_waiter_type type, signed long adjustment)
+struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 {
+	signed long adjustment = -RWSEM_ACTIVE_READ_BIAS;
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
 	signed long count;
 
 	/* set up my own style of waitqueue */
 	waiter.task = tsk;
-	waiter.type = type;
+	waiter.type = RWSEM_WAITING_FOR_READ;
 	get_task_struct(tsk);
 
 	raw_spin_lock_irq(&sem->wait_lock);
+	sem->wait_readers++;
 	if (list_empty(&sem->wait_list))
 		adjustment += RWSEM_WAITING_BIAS;
 	list_add_tail(&waiter.list, &sem->wait_list);
@@ -193,17 +139,9 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
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
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
+	/* If there are no active locks, wake the front queued process(es). */
+	if (!(count & RWSEM_ACTIVE_MASK))
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
 
 	raw_spin_unlock_irq(&sem->wait_lock);
 
@@ -220,22 +158,63 @@ rwsem_down_failed_common(struct rw_semaphore *sem,
 	return sem;
 }
 
-/*
- * wait for the read lock to be granted
- */
-struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
-{
-	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_READ,
-					-RWSEM_ACTIVE_READ_BIAS);
-}
-
-/*
- * wait for the write lock to be granted
- */
+/* wait until we successfully acquire the write lock */
 struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
-	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_WRITE,
-					-RWSEM_ACTIVE_WRITE_BIAS);
+	signed long adjustment = -RWSEM_ACTIVE_WRITE_BIAS;
+	struct rwsem_waiter waiter;
+	struct task_struct *tsk = current;
+	signed long count;
+
+	/* set up my own style of waitqueue */
+	waiter.task = tsk;
+	waiter.type = RWSEM_WAITING_FOR_WRITE;
+
+	raw_spin_lock_irq(&sem->wait_lock);
+	if (list_empty(&sem->wait_list))
+		adjustment += RWSEM_WAITING_BIAS;
+	list_add_tail(&waiter.list, &sem->wait_list);
+
+	/* Adjust sem->count to indicate our intention to get queued
+	 * on the lock, but no longer activeley locking.
+	 */
+	count = rwsem_atomic_update(adjustment, sem);
+
+	/* If there were already threads queued before us and there are no
+	 * active writers, the lock must be read owned; so we try to wake
+	 * any read locks that were queued ahead of us.
+	 */
+	if (count > RWSEM_WAITING_BIAS &&
+	    adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READERS);
+
+	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+	if (!(count & RWSEM_ACTIVE_MASK)) {
+ trylock:
+
+		/* Try acquiring the write lock. */
+		count = RWSEM_ACTIVE_WRITE_BIAS;
+		if (!list_is_singular(&sem->wait_list))
+			count += RWSEM_WAITING_BIAS;
+		if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
+							RWSEM_WAITING_BIAS) {
+			list_del(&waiter.list);
+			raw_spin_unlock_irq(&sem->wait_lock);
+			tsk->state = TASK_RUNNING;
+			return sem;
+		}
+	}
+
+	raw_spin_unlock_irq(&sem->wait_lock);
+
+	/* Block until there are no active lockers. */
+	do {
+		schedule();
+		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+	} while (sem->count & RWSEM_ACTIVE_MASK);
+
+	raw_spin_lock_irq(&sem->wait_lock);
+	goto trylock;
 }
 
 /*
@@ -270,7 +249,7 @@ struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 
 	/* do nothing if list empty */
 	if (!list_empty(&sem->wait_list))
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READ_OWNED);
+		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READERS);
 
 	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 
-- 
1.8.1
