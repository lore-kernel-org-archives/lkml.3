Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaDQX0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:26:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:44529 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750736AbaDQX0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:26:07 -0400
Date: Thu, 17 Apr 2014 19:26:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Carsten Emde <C.Emde@osadl.org>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [RFC PATCH RT V4] rwsem: The return of multi-reader PI rwsems
Message-ID: <20140417192603.6e379157@gandalf.local.home>
In-Reply-To: <20140411092524.1f242e25@gandalf.local.home>
References: <20140409151922.5fa5d999@gandalf.local.home>
	<20140410134217.38cd6db7@gandalf.local.home>
	<20140410223508.6d0fc135@gandalf.local.home>
	<5347E475.4020009@osadl.org>
	<20140411092524.1f242e25@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v3:

Clark reported that he was seeing a large latency when he added this
patch. I tested it out on a 8 logical CPU box, and sure enough I was
seeing it too. After spending the day debugging why, I found that I had
a bug in rt_mutex_getprio(), where I could do:

  min(task_top_pi_waiter(task)->pi_list_entry.prio, prio)

when there was no "top_pi_waiter", which would give garbage as a
result. This would let some tasks have higher priority than they
should, and cause other tasks that should have high priority not run.

After correcting this issue, the latencies are back down to normal.

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/rtmutex.h  |   29 ++
 include/linux/rwsem_rt.h |    8 
 include/linux/sched.h    |   20 +
 kernel/fork.c            |   20 +
 kernel/futex.c           |    2 
 kernel/rt.c              |   27 +
 kernel/rtmutex.c         |  664 ++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/rtmutex_common.h  |   19 +
 kernel/sysctl.c          |   13 
 9 files changed, 772 insertions(+), 30 deletions(-)

Index: linux-rt.git/kernel/rtmutex.c
===================================================================
--- linux-rt.git.orig/kernel/rtmutex.c	2014-04-16 10:19:09.030579948 -0400
+++ linux-rt.git/kernel/rtmutex.c	2014-04-17 19:11:24.018721323 -0400
@@ -26,6 +26,21 @@
 #include "rtmutex_common.h"
 
 /*
+ * rt_rw_limit is the number of simultaneous readers of a rwsem lock.
+ *
+ * rt_rw_limit gets updated on boot up to the number of
+ * possible CPUs, but we need to initialize it to something other
+ * than zero.
+ */
+unsigned rt_rw_limit = NR_CPUS;
+
+/* cnt == 0 means unlimited */
+static inline int under_rt_rw_limit(int cnt)
+{
+	return !rt_rw_limit || cnt < rt_rw_limit;
+}
+
+/*
  * lock->owner state tracking:
  *
  * lock->owner holds the task_struct pointer of the owner. Bit 0
@@ -110,19 +125,48 @@
 		plist_head_init(&lock->wait_list);
 }
 
+static inline void init_rw_lists(struct rt_rw_mutex *rwlock)
+{
+	struct rt_mutex *lock = &rwlock->mutex;
+
+	/*
+	 * A rwsem priority is initialized to -1 and never will
+	 * be that again.
+	 */
+	if (unlikely(rwlock->prio < 0)) {
+		rwlock->prio = MAX_PRIO;
+		init_lists(lock);
+	}
+}
+
+static int rt_mutex_get_readers_prio(struct task_struct *task, int prio);
+static inline int task_has_reader_locks(struct task_struct *task);
+
 /*
  * Calculate task priority from the waiter list priority
  *
  * Return task->normal_prio when the waiter list is empty or when
  * the waiter is not allowed to do priority boosting
+ *
+ * On PREEMPT_RT, we also check the priorities of the list
+ * of read locks that the task holds.
  */
 int rt_mutex_getprio(struct task_struct *task)
 {
-	if (likely(!task_has_pi_waiters(task)))
-		return task->normal_prio;
+	int prio = task->normal_prio;
+	bool has_pi_waiters = task_has_pi_waiters(task);
+	bool has_reader_locks = task_has_reader_locks(task);
+
+	if (likely(!has_pi_waiters && !has_reader_locks))
+		return prio;
+
+	if (has_reader_locks)
+		prio = rt_mutex_get_readers_prio(task, prio);
+
+	if (has_pi_waiters)
+		prio = min(task_top_pi_waiter(task)->pi_list_entry.prio, prio);
 
-	return min(task_top_pi_waiter(task)->pi_list_entry.prio,
-		   task->normal_prio);
+	return prio;
 }
 
 /*
@@ -181,6 +225,11 @@
  */
 int max_lock_depth = 1024;
 
+static int rt_mutex_adjust_readers(struct rt_mutex *orig_lock,
+				   struct rt_mutex_waiter *orig_waiter,
+				   struct task_struct *top_task,
+				   struct rt_mutex *lock,
+				   int recursion_depth);
 /*
  * Adjust the priority chain. Also used for deadlock detection.
  * Decreases task's usage by one - may thus free the task.
@@ -203,7 +252,8 @@
 				      int deadlock_detect,
 				      struct rt_mutex *orig_lock,
 				      struct rt_mutex_waiter *orig_waiter,
-				      struct task_struct *top_task)
+				      struct task_struct *top_task,
+				      int recursion_depth)
 {
 	struct rt_mutex *lock;
 	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
@@ -316,6 +366,18 @@
 
 	/* Grab the next task */
 	task = rt_mutex_owner(lock);
+
+	/*
+	 * Readers are special. We may need to boost more than one owner.
+	 */
+	if (unlikely(task == RT_RW_READER)) {
+		ret = rt_mutex_adjust_readers(orig_lock, orig_waiter,
+					      top_task, lock,
+					      recursion_depth);
+		raw_spin_unlock(&lock->wait_lock);
+		goto out;
+	}
+
 	get_task_struct(task);
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
@@ -349,7 +411,7 @@
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
  out_put_task:
 	put_task_struct(task);
-
+ out:
 	return ret;
 }
 
@@ -518,6 +580,13 @@
 		return 0;
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
+		/* readers are handled differently */
+		if (unlikely(owner == RT_RW_READER)) {
+			res = rt_mutex_adjust_readers(lock, waiter,
+						      current, lock, 0);
+			return res;
+		}
+
 		raw_spin_lock_irqsave(&owner->pi_lock, flags);
 		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
 		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
@@ -527,7 +596,8 @@
 			chain_walk = 1;
 		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	}
-	else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock))
+	else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock) &&
+		 owner != RT_RW_READER)
 		chain_walk = 1;
 
 	if (!chain_walk)
@@ -543,7 +613,7 @@
 	raw_spin_unlock(&lock->wait_lock);
 
 	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock, waiter,
-					 task);
+					 task, 0);
 
 	raw_spin_lock(&lock->wait_lock);
 
@@ -633,7 +703,7 @@
 
 	raw_spin_unlock(&lock->wait_lock);
 
-	rt_mutex_adjust_prio_chain(owner, 0, lock, NULL, current);
+	rt_mutex_adjust_prio_chain(owner, 0, lock, NULL, current, 0);
 
 	raw_spin_lock(&lock->wait_lock);
 }
@@ -660,7 +730,7 @@
 	/* gets dropped in rt_mutex_adjust_prio_chain()! */
 	get_task_struct(task);
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-	rt_mutex_adjust_prio_chain(task, 0, NULL, NULL, task);
+	rt_mutex_adjust_prio_chain(task, 0, NULL, NULL, task, 0);
 }
 
 #ifdef CONFIG_PREEMPT_RT_FULL
@@ -739,7 +809,7 @@
 	struct rt_mutex_waiter waiter, *top_waiter;
 	int ret;
 
-	rt_mutex_init_waiter(&waiter, true);
+	rt_mutex_init_waiter(&waiter, true, false);
 
 	raw_spin_lock(&lock->wait_lock);
 	init_lists(lock);
@@ -1001,15 +1071,564 @@
 
 	return 0;
 }
+
+/*
+ * Wake up the next waiter on a rw lock.
+ *
+ * Similar to wakeup_next_waiter() but the waiter is not on
+ * the owner's pi_waiters. Also, it does not reset the lock
+ * owner.
+ *
+ * Called with lock->wait_lock held.
+ */
+static void wakeup_next_rw_waiter(struct rt_mutex *lock)
+{
+	struct rt_mutex_waiter *waiter;
+
+	waiter = rt_mutex_top_waiter(lock);
+	rt_mutex_wake_waiter(waiter);
+}
+
+/* Called with rwmutex->mutex.wait_lock held */
+static inline void
+rt_rw_mutex_take_as_reader(struct task_struct *task,
+			   struct rt_rw_mutex *rwmutex,
+			   struct rt_mutex_waiter *waiter)
+{
+	struct reader_lock_struct *rls;
+	struct rt_mutex *mutex = &rwmutex->mutex;
+	unsigned long flags;
+	bool wakeup = false;
+
+	rwmutex->nr_owners++;
+	rt_mutex_set_owner(&rwmutex->mutex, RT_RW_READER);
+
+	if (waiter || rt_mutex_has_waiters(mutex)) {
+		unsigned long flags;
+		struct rt_mutex_waiter *top;
+
+		raw_spin_lock_irqsave(&task->pi_lock, flags);
+
+		/* remove the queued waiter. */
+		if (waiter) {
+			plist_del(&waiter->list_entry, &mutex->wait_list);
+			task->pi_blocked_on = NULL;
+		}
+
+		/*
+		 * Initialize the rwmutex prio to the priority of
+		 * the top waiter.
+		 */
+		if (rt_mutex_has_waiters(mutex)) {
+			top = rt_mutex_top_waiter(mutex);
+			top->pi_list_entry.prio = top->list_entry.prio;
+			/*
+			 * Readers set the lock priority for faster access
+			 * to read the priorities of the locks it owns
+			 * when boosting. This helps to not have to take
+			 * the pi_lock of the task. The rwmutex->prio
+			 * is protected by the rwmutex->mutex.wait_lock,
+			 * which is held during boosting.
+			 */
+			rwmutex->prio = top->list_entry.prio;
+
+			/*
+			 * If this waiter is a reader, and the reader limit
+			 * has not been hit, then we can wake this waiter
+			 * up too.
+			 */
+			if (!top->writer && under_rt_rw_limit(rwmutex->nr_owners))
+				wakeup = true;
+		} else
+			rwmutex->prio = MAX_PRIO;
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
+	} else
+		rwmutex->prio = MAX_PRIO;
+
+	/*
+	 * It is possible to have holes in the owned_read_locks array.
+	 * If we take read lock A and then B, but then release A, we
+	 * can't move the pointer of B because if something blocks on
+	 * B, it can use the B pointer to boost this task. B can only
+	 * be moved, by owning the wait_list lock of B. Remember, the
+	 * B lock has its pointers to that index of our array.
+	 */
+	rls = &task->owned_read_locks[task->reader_lock_free];
+	BUG_ON(rls->lock);
+
+	/*
+	 * Grabing the pi_lock here as other tasks can boost this
+	 * lock via other held locks, and if free lock descriptor
+	 * was not at the end of the owned_read_locks array, then
+	 * it might get confused if it sees this descriptor with
+	 * a lock and no task.
+	 */
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	rls->lock = rwmutex;
+	rls->task = task;
+	list_add(&rls->list, &rwmutex->owners);
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
+	if (task->reader_lock_free == task->reader_lock_count) {
+		/*
+		 * If we nest too deep, then this task can never get the lock.
+		 * This task will then block for good. Warn about this and
+		 * hopefully, people will notice the warning. If not, they will notice
+		 * the dead task. Maybe this should be a BUG_ON()
+		 */
+		if (WARN_ON(task->reader_lock_count == MAX_RWLOCK_DEPTH))
+			return;
+
+		/*
+		 * We don't need to take the pi_lock here as we have the
+		 * wait_lock of the lock at the end of the list. If this task
+		 * was being boosted by a task blocked on this lock, it would
+		 * need to grab the wait_lock before boosting this task.
+		 */
+		task->reader_lock_count++;
+		task->reader_lock_free++;
+	} else {
+		/*
+		 * Find the next free lock in array. Again, we do not need
+		 * to grab the pi_lock because the boosting doesn't use
+		 * the reader_lock_free variable, which is the only thing
+		 * we are updating here.
+		 */
+		do {
+			rls = &task->owned_read_locks[++task->reader_lock_free];
+		} while (rls->lock &&
+			 task->reader_lock_free < task->reader_lock_count);
+	}
+
+	if (wakeup)
+		wakeup_next_rw_waiter(&rwmutex->mutex);
+}
+
+static int try_to_take_rw_read(struct rt_rw_mutex *rwmutex,
+			       struct rt_mutex_waiter *waiter)
+{
+	struct task_struct *task = current;
+	struct rt_mutex *mutex = &rwmutex->mutex;
+	struct task_struct *owner;
+
+	assert_raw_spin_locked(&mutex->wait_lock);
+
+	/* The writer unlock can use the fast path */
+	mark_rt_mutex_waiters(mutex);
+
+	/* If we are at the reader limit, we can't take the lock */
+	if (unlikely(!under_rt_rw_limit(rwmutex->nr_owners)))
+		return 0;
+
+	/*
+	 * If there's no waiters, and there is no owner or
+	 * the owner is a reader, we get the lock.
+	 * Note, if the waiter or pending bits are set in the owner
+	 * then we need to do more checks.
+	 */
+	if (likely(!mutex->owner || mutex->owner == RT_RW_READER))
+		goto taken;
+
+	owner = rt_mutex_owner(mutex);
+
+	/* If the lock is owned by a task, then it is a writer */
+	if (owner && owner != RT_RW_READER)
+		return 0;
+
+	/*
+	 * A writer or a reader may be waiting. In either case, we
+	 * may still be able to steal the lock. The RT rwsems are
+	 * not fair if the new reader comes in and is higher priority
+	 * than all the waiters.
+	 */
+	if (likely(rt_mutex_has_waiters(mutex))) {
+		struct task_struct *pown = rt_mutex_top_waiter(mutex)->task;
+
+		if (task != pown && !lock_is_stealable(task, pown, STEAL_NORMAL))
+			return 0;
+	}
+
+ taken:
+	rt_rw_mutex_take_as_reader(task, rwmutex, waiter);
+	return 1;
+}
+
+void rt_rw_mutex_read_lock(struct rt_rw_mutex *rwmutex)
+{
+	struct rt_mutex_waiter waiter;
+	struct rt_mutex *mutex = &rwmutex->mutex;
+	int ret;
+
+	raw_spin_lock(&mutex->wait_lock);
+	init_rw_lists(rwmutex);
+
+	if (likely(try_to_take_rw_read(rwmutex, NULL))) {
+		/* Got the lock */
+		raw_spin_unlock(&mutex->wait_lock);
+		return;
+	}
+
+	rt_mutex_init_waiter(&waiter, false, false);
+
+	set_current_state(TASK_UNINTERRUPTIBLE);
+
+	ret = task_blocks_on_rt_mutex(mutex, &waiter, current, 0);
+	BUG_ON(ret);
+
+	for (;;) {
+		/* Try to acquire the lock: */
+		if (try_to_take_rw_read(rwmutex, &waiter))
+			break;
+
+		raw_spin_unlock(&mutex->wait_lock);
+
+		debug_rt_mutex_print_deadlock(waiter);
+
+		schedule_rt_mutex(mutex);
+
+		raw_spin_lock(&mutex->wait_lock);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+	}
+
+	set_current_state(TASK_RUNNING);
+
+	raw_spin_unlock(&mutex->wait_lock);
+
+	debug_rt_mutex_free_waiter(&waiter);
+}
+
+int rt_rw_mutex_read_trylock(struct rt_rw_mutex *rwmutex)
+{
+	struct rt_mutex *mutex = &rwmutex->mutex;
+	int ret = 0;
+
+	if (!raw_spin_trylock(&mutex->wait_lock))
+		return ret;
+
+	init_rw_lists(rwmutex);
+
+	if (try_to_take_rw_read(rwmutex, NULL))
+		ret = 1;
+
+	raw_spin_unlock(&mutex->wait_lock);
+
+	return ret;
+}
+
+static int
+try_to_take_rw_write(struct rt_rw_mutex *rwmutex, struct rt_mutex_waiter *waiter)
+{
+	struct rt_mutex *mutex = &rwmutex->mutex;
+
+	/* Writers block if there's any readers owning the lock */
+	if (rwmutex->nr_owners)
+		return 0;
+
+	/* No readers, then we can try to take the mutex normally. */
+	return try_to_take_rt_mutex(mutex, current, waiter);
+}
+
+void rt_rw_mutex_write_lock(struct rt_rw_mutex *rwmutex)
+{
+	struct rt_mutex *mutex = &rwmutex->mutex;
+	struct rt_mutex_waiter waiter;
+	struct task_struct *task = current;
+	int ret;
+
+	raw_spin_lock(&mutex->wait_lock);
+	init_rw_lists(rwmutex);
+
+	if (try_to_take_rw_write(rwmutex, NULL)) {
+		raw_spin_unlock(&mutex->wait_lock);
+		return;
+	}
+
+	/* Writers wake up differently than readers (flag it) */
+	rt_mutex_init_waiter(&waiter, false, true);
+
+	ret = task_blocks_on_rt_mutex(mutex, &waiter, task, 0);
+	BUG_ON(ret);
+
+	set_current_state(TASK_UNINTERRUPTIBLE);
+
+	for (;;) {
+		/* Try to acquire the lock: */
+		if (try_to_take_rw_write(rwmutex, &waiter))
+			break;
+
+		raw_spin_unlock(&mutex->wait_lock);
+
+		debug_rt_mutex_print_deadlock(waiter);
+
+		schedule_rt_mutex(mutex);
+
+		raw_spin_lock(&mutex->wait_lock);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+	}
+
+	set_current_state(TASK_RUNNING);
+
+	raw_spin_unlock(&mutex->wait_lock);
+	WARN_ONCE(rwmutex->nr_owners, "Writer has lock with readers");
+
+	debug_rt_mutex_free_waiter(&waiter);
+}
+
+int rt_rw_mutex_write_trylock(struct rt_rw_mutex *rwmutex)
+{
+	struct rt_mutex *mutex = &rwmutex->mutex;
+	int ret = 0;
+
+	if (!raw_spin_trylock(&mutex->wait_lock))
+		return ret;
+
+	init_rw_lists(rwmutex);
+
+	if (try_to_take_rw_write(rwmutex, NULL))
+		ret = 1;
+
+	raw_spin_unlock(&mutex->wait_lock);
+
+	return ret;
+}
+
+/*
+ * When a reader lock is released, see if the reader_lock_count
+ * can be moved back.
+ */
+static void shrink_reader_lock_array(struct task_struct *task)
+{
+	struct reader_lock_struct *read_locks = task->owned_read_locks;
+
+	while (task->reader_lock_count &&
+	       read_locks[task->reader_lock_count - 1].lock == NULL)
+		task->reader_lock_count--;
+
+	if (task->reader_lock_free > task->reader_lock_count)
+		task->reader_lock_free = task->reader_lock_count;
+}
+
+void rt_rw_mutex_read_unlock(struct rt_rw_mutex *rwmutex)
+{
+	struct rt_mutex *mutex = &rwmutex->mutex;
+	struct rt_mutex_waiter *waiter;
+	struct reader_lock_struct *rls;
+	struct task_struct *task = current;
+	unsigned long flags;
+	int readers;
+	int i;
+
+	raw_spin_lock(&mutex->wait_lock);
+
+	rt_mutex_deadlock_account_unlock(current);
+
+	WARN_ON_ONCE(!rwmutex->nr_owners);
+
+	rwmutex->nr_owners--;
+
+	if (rt_mutex_has_waiters(mutex)) {
+		/*
+		 * If the top waiter is a reader and we are under
+		 * the limit, or the top waiter is a writer and
+		 * there's no more readers, then we can give the
+		 * top waiter pending ownership and wake it up.
+		 *
+		 * To simplify things, we only wake up one task, even
+		 * if its a reader. If the reader wakes up and gets the
+		 * lock, it will look to see if it can wake up the next
+		 * waiter, and so on. This way we only need to worry about
+		 * one task at a time.
+		 */
+		waiter = rt_mutex_top_waiter(mutex);
+		readers = rwmutex->nr_owners;
+		if ((waiter->writer && !readers) ||
+		    (!waiter->writer && under_rt_rw_limit(readers)))
+			wakeup_next_rw_waiter(mutex);
+	} else
+		rwmutex->prio = MAX_PRIO;
+
+	if (!rwmutex->nr_owners)
+		rt_mutex_set_owner(&rwmutex->mutex, NULL);
+
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	/* Remove the lock from this tasks list */
+	for (i = task->reader_lock_count - 1; i >= 0; i--) {
+		rls = &task->owned_read_locks[i];
+
+		if (rls->lock == rwmutex) {
+			rls->lock = NULL;
+			list_del_init(&rls->list);
+			/* Shrink the array if we can. */
+			if (i == task->reader_lock_count - 1)
+				shrink_reader_lock_array(task);
+			else if (i < task->reader_lock_free)
+				task->reader_lock_free = i;
+			break;
+		}
+	}
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
+	WARN_ON_ONCE(i < 0);
+
+	raw_spin_unlock(&mutex->wait_lock);
+
+	/* Undo pi boosting if necessary */
+	rt_mutex_adjust_prio(current);
+}
+
+void rt_rw_mutex_downgrade_write(struct rt_rw_mutex *rwmutex)
+{
+	struct task_struct *task = current;
+	struct rt_mutex *mutex = &rwmutex->mutex;
+
+	raw_spin_lock(&mutex->wait_lock);
+
+	/*
+	 * Writers have normal pi with other tasks blocked
+	 * on the lock. That is, the top waiter will be in the
+	 * pi_list of this task. But for readers, waiters of
+	 * the lock are not included in the pi_list, only the
+	 * locks are. We must remove the top waiter of this
+	 * lock from this task.
+	 */
+	if (rt_mutex_has_waiters(mutex)) {
+		struct rt_mutex_waiter *waiter;
+		unsigned long flags;
+
+		waiter = rt_mutex_top_waiter(mutex);
+		raw_spin_lock_irqsave(&task->pi_lock, flags);
+		plist_del(&waiter->pi_list_entry, &task->pi_waiters);
+		/*
+		 * The rt_rw_mutex_take_as_reader() will update
+		 * the rwmutex prio.
+		 */
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	}
+
+	WARN_ONCE(rwmutex->nr_owners, "Writer owned with readers");
+
+	rt_rw_mutex_take_as_reader(task, rwmutex, NULL);
+
+	raw_spin_unlock(&mutex->wait_lock);
+}
+
+static inline int task_has_reader_locks(struct task_struct *task)
+{
+	return task->reader_lock_count;
+}
+
+static int rt_mutex_get_readers_prio(struct task_struct *task, int prio)
+{
+	struct reader_lock_struct *rls;
+	struct rt_rw_mutex *rwmutex;
+	int lock_prio;
+	int i;
+
+	for (i = 0; i < task->reader_lock_count; i++) {
+		rls = &task->owned_read_locks[i];
+		rwmutex = rls->lock;
+		if (!rwmutex)
+			continue;
+		lock_prio = rwmutex->prio;
+		if (prio > lock_prio)
+			prio = lock_prio;
+	}
+	WARN_ON_ONCE(prio < 0);
+
+	return prio;
+}
+
+/* Expects to be called with lock->wait_lock held */
+static int rt_mutex_adjust_readers(struct rt_mutex *orig_lock,
+				   struct rt_mutex_waiter *orig_waiter,
+				   struct task_struct *top_task,
+				   struct rt_mutex *lock,
+				   int recursion_depth)
+{
+	struct reader_lock_struct *rls;
+	struct rt_mutex_waiter *waiter;
+	struct task_struct *task;
+	struct rt_rw_mutex *rwmutex = container_of(lock, struct rt_rw_mutex, mutex);
+	unsigned long flags;
+
+	/* Update the rwmutex's prio */
+	if (rt_mutex_has_waiters(lock)) {
+		waiter = rt_mutex_top_waiter(lock);
+		/*
+		 * Do we need to grab the task->pi_lock?
+		 * Really, we are only reading it. If it
+		 * changes, then that should follow this chain
+		 * too.
+		 */
+		rwmutex->prio = waiter->task->prio;
+	} else
+		rwmutex->prio = MAX_PRIO;
+
+	if (recursion_depth >= MAX_RWLOCK_DEPTH) {
+		WARN_ON(1);
+		return 1;
+	}
+
+	list_for_each_entry(rls, &rwmutex->owners, list) {
+		bool skip = false;
+
+		task = rls->task;
+
+		raw_spin_lock_irqsave(&task->pi_lock, flags);
+		__rt_mutex_adjust_prio(task);
+		/*
+		 * We need to grab the pi_lock to adjust the task prio
+		 * might as well use this to check if the task is blocked
+		 * as well, and save on a call to the prio chain that will
+		 * just grab the lock again and do the test.
+		 */
+		if (!rt_mutex_real_waiter(task->pi_blocked_on))
+			skip = true;
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
+		if (skip)
+			continue;
+
+		get_task_struct(task);
+		/*
+		 * rt_mutex_adjust_prio_chain will do
+		 * the put_task_struct
+		 */
+		rt_mutex_adjust_prio_chain(task, 0, orig_lock,
+					   orig_waiter, top_task,
+					   recursion_depth+1);
+	}
+
+	return 0;
+}
 #else
+static int rt_mutex_adjust_readers(struct rt_mutex *orig_lock,
+				   struct rt_mutex_waiter *orig_waiter,
+				   struct task_struct *top_task,
+				   struct rt_mutex *lock,
+				   int recursion_depth)
+{
+	return 0;
+}
+
+static int rt_mutex_get_readers_prio(struct task_struct *task, int prio)
+{
+	return prio;
+}
+
+static inline int task_has_reader_locks(struct task_struct *task)
+{
+	return 0;
+}
+
 static inline int __sched
 __mutex_lock_check_stamp(struct rt_mutex *lock, struct ww_acquire_ctx *ctx)
 {
 	BUG();
 	return 0;
 }
-
-#endif
+#endif /* CONFIG_PREEMPT_RT */
 
 /**
  * __rt_mutex_slowlock() - Perform the wait-wake-try-to-take loop
@@ -1154,7 +1773,7 @@
 	struct rt_mutex_waiter waiter;
 	int ret = 0;
 
-	rt_mutex_init_waiter(&waiter, false);
+	rt_mutex_init_waiter(&waiter, false, false);
 
 	raw_spin_lock(&lock->wait_lock);
 	init_lists(lock);
@@ -1718,4 +2337,21 @@
 	rt_mutex_unlock(&lock->base.lock);
 }
 EXPORT_SYMBOL(ww_mutex_unlock);
+
+/*
+ * On boot up, rt_rw_limit is set to NR_CPUS. At the end of boot
+ * we can lower that to actual CPUs as everything should be running
+ * as it most likely will on a normal system.
+ *
+ * Note, benchmarks have shown that the best performance we get
+ * from doing a page fault stress test on threads, is when
+ * rt_rw_limit is set to 2x online CPUs.
+ */
+static int __init rt_rw_limit_init(void)
+{
+	rt_rw_limit = nr_cpu_ids * 2;
+	return 0;
+}
+late_initcall(rt_rw_limit_init);
+
 #endif
Index: linux-rt.git/kernel/rtmutex_common.h
===================================================================
--- linux-rt.git.orig/kernel/rtmutex_common.h	2014-04-16 10:19:09.030579948 -0400
+++ linux-rt.git/kernel/rtmutex_common.h	2014-04-16 10:31:20.160360827 -0400
@@ -43,6 +43,7 @@
  * @list_entry:		pi node to enqueue into the mutex waiters list
  * @pi_list_entry:	pi node to enqueue into the mutex owner waiters list
  * @task:		task reference to the blocked task
+ * @writer:		true if its a rwsem writer that is blocked
  */
 struct rt_mutex_waiter {
 	struct plist_node	list_entry;
@@ -50,6 +51,7 @@
 	struct task_struct	*task;
 	struct rt_mutex		*lock;
 	bool			savestate;
+	bool			writer;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 	unsigned long		ip;
 	struct pid		*deadlock_task_pid;
@@ -101,6 +103,20 @@
 		((unsigned long)lock->owner & ~RT_MUTEX_OWNER_MASKALL);
 }
 
+/* used as reader owner of the mutex */
+#define RT_RW_READER		(struct task_struct *)0x100
+
+#ifdef CONFIG_PREEMPT_RT_FULL
+
+void rt_rw_mutex_read_unlock(struct rt_rw_mutex *rwmutex);
+void rt_rw_mutex_downgrade_write(struct rt_rw_mutex *rwmutex);
+int rt_rw_mutex_write_trylock(struct rt_rw_mutex *rwmutex);
+void rt_rw_mutex_write_lock(struct rt_rw_mutex *rwmutex);
+int rt_rw_mutex_read_trylock(struct rt_rw_mutex *rwmutex);
+void rt_rw_mutex_read_lock(struct rt_rw_mutex *rwmutex);
+
+#endif /* CONFIG_PREEMPT_RT */
+
 /*
  * PI-futex support (proxy locking functions, etc.):
  */
@@ -128,11 +144,12 @@
 #endif
 
 static inline void
-rt_mutex_init_waiter(struct rt_mutex_waiter *waiter, bool savestate)
+rt_mutex_init_waiter(struct rt_mutex_waiter *waiter, bool savestate, bool writer)
 {
 	debug_rt_mutex_init_waiter(waiter);
 	waiter->task = NULL;
 	waiter->savestate = savestate;
+	waiter->writer = writer;
 }
 
 #endif
Index: linux-rt.git/kernel/rt.c
===================================================================
--- linux-rt.git.orig/kernel/rt.c	2014-04-16 10:19:09.030579948 -0400
+++ linux-rt.git/kernel/rt.c	2014-04-16 10:31:20.170360699 -0400
@@ -310,14 +310,19 @@
 void  rt_up_write(struct rw_semaphore *rwsem)
 {
 	rwsem_release(&rwsem->dep_map, 1, _RET_IP_);
-	rt_mutex_unlock(&rwsem->lock);
+	/*
+	 * Unlocking a write is the same as unlocking the mutex.
+	 * The woken reader will do all the work if it needs to
+	 * wake up more than one reader.
+	 */
+	__rt_spin_unlock(&rwsem->rwlock.mutex);
 }
 EXPORT_SYMBOL(rt_up_write);
 
 void  rt_up_read(struct rw_semaphore *rwsem)
 {
 	rwsem_release(&rwsem->dep_map, 1, _RET_IP_);
-	rt_mutex_unlock(&rwsem->lock);
+	rt_rw_mutex_read_unlock(&rwsem->rwlock);
 }
 EXPORT_SYMBOL(rt_up_read);
 
@@ -327,13 +332,14 @@
  */
 void  rt_downgrade_write(struct rw_semaphore *rwsem)
 {
-	BUG_ON(rt_mutex_owner(&rwsem->lock) != current);
+	BUG_ON(rt_mutex_owner(&rwsem->rwlock.mutex) != current);
+	rt_rw_mutex_downgrade_write(&rwsem->rwlock);
 }
 EXPORT_SYMBOL(rt_downgrade_write);
 
 int  rt_down_write_trylock(struct rw_semaphore *rwsem)
 {
-	int ret = rt_mutex_trylock(&rwsem->lock);
+	int ret = rt_rw_mutex_write_trylock(&rwsem->rwlock);
 
 	if (ret)
 		rwsem_acquire(&rwsem->dep_map, 0, 1, _RET_IP_);
@@ -344,14 +350,14 @@
 void  rt_down_write(struct rw_semaphore *rwsem)
 {
 	rwsem_acquire(&rwsem->dep_map, 0, 0, _RET_IP_);
-	rt_mutex_lock(&rwsem->lock);
+	rt_rw_mutex_write_lock(&rwsem->rwlock);
 }
 EXPORT_SYMBOL(rt_down_write);
 
 void  rt_down_write_nested(struct rw_semaphore *rwsem, int subclass)
 {
 	rwsem_acquire(&rwsem->dep_map, subclass, 0, _RET_IP_);
-	rt_mutex_lock(&rwsem->lock);
+	rt_rw_mutex_write_lock(&rwsem->rwlock);
 }
 EXPORT_SYMBOL(rt_down_write_nested);
 
@@ -359,14 +365,14 @@
 		struct lockdep_map *nest)
 {
 	rwsem_acquire_nest(&rwsem->dep_map, 0, 0, nest, _RET_IP_);
-	rt_mutex_lock(&rwsem->lock);
+	rt_rw_mutex_write_lock(&rwsem->rwlock);
 }
 
 int  rt_down_read_trylock(struct rw_semaphore *rwsem)
 {
 	int ret;
 
-	ret = rt_mutex_trylock(&rwsem->lock);
+	ret = rt_rw_mutex_read_trylock(&rwsem->rwlock);
 	if (ret)
 		rwsem_acquire(&rwsem->dep_map, 0, 1, _RET_IP_);
 
@@ -377,7 +383,7 @@
 static void __rt_down_read(struct rw_semaphore *rwsem, int subclass)
 {
 	rwsem_acquire(&rwsem->dep_map, subclass, 0, _RET_IP_);
-	rt_mutex_lock(&rwsem->lock);
+	rt_rw_mutex_read_lock(&rwsem->rwlock);
 }
 
 void  rt_down_read(struct rw_semaphore *rwsem)
@@ -402,7 +408,8 @@
 	debug_check_no_locks_freed((void *)rwsem, sizeof(*rwsem));
 	lockdep_init_map(&rwsem->dep_map, name, key, 0);
 #endif
-	rwsem->lock.save_state = 0;
+	rt_rw_mutex_init(&rwsem->rwlock);
+	rwsem->rwlock.mutex.save_state = 0;
 }
 EXPORT_SYMBOL(__rt_rwsem_init);
 
Index: linux-rt.git/include/linux/sched.h
===================================================================
--- linux-rt.git.orig/include/linux/sched.h	2014-04-16 10:19:09.030579948 -0400
+++ linux-rt.git/include/linux/sched.h	2014-04-16 10:31:20.170360699 -0400
@@ -993,6 +993,22 @@
 #endif
 };
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+struct rt_rw_mutex;
+/**
+ * reader_lock_struct
+ *
+ * @lock:	pointer to rwsem that is held
+ * @task:	pointer back to task, for lock code
+ * @list_head:	link into rt_rw_mutex owners list
+ */
+struct reader_lock_struct {
+	struct rt_rw_mutex		*lock;
+	struct task_struct		*task;
+	struct list_head		list;
+};
+#endif
+
 struct sched_rt_entity {
 	struct list_head run_list;
 	unsigned long timeout;
@@ -1224,6 +1240,10 @@
 #ifdef CONFIG_PREEMPT_RT_FULL
 	/* TODO: move me into ->restart_block ? */
 	struct siginfo forced_info;
+#define MAX_RWLOCK_DEPTH 5
+	int reader_lock_count;	/* index of last element in owned_read_locks */
+	int reader_lock_free;	/* index of next free element. */
+	struct reader_lock_struct owned_read_locks[MAX_RWLOCK_DEPTH];
 #endif
 
 	unsigned long sas_ss_sp;
Index: linux-rt.git/kernel/fork.c
===================================================================
--- linux-rt.git.orig/kernel/fork.c	2014-04-16 10:19:09.030579948 -0400
+++ linux-rt.git/kernel/fork.c	2014-04-16 10:31:20.180360572 -0400
@@ -1385,6 +1385,26 @@
 	if (retval)
 		goto bad_fork_cleanup_io;
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+	p->reader_lock_count = 0;
+	p->reader_lock_free = 0;
+	/* Bracket to keep 'i' local */
+	{
+		int i;
+		/*
+		 * We could put the initialization of this list in
+		 * the grabbing of the lock, but it is safer to
+		 * do it now. The list head initialization may be
+		 * removed, but we'll keep it for now, just to be safe.
+		 */
+		for (i = 0; i < MAX_RWLOCK_DEPTH; i++) {
+			p->owned_read_locks[i].lock = NULL;
+			p->owned_read_locks[i].task = p;
+			INIT_LIST_HEAD(&p->owned_read_locks[i].list);
+		}
+	}
+#endif
+
 	if (pid != &init_struct_pid) {
 		retval = -ENOMEM;
 		pid = alloc_pid(p->nsproxy->pid_ns_for_children);
Index: linux-rt.git/kernel/sysctl.c
===================================================================
--- linux-rt.git.orig/kernel/sysctl.c	2014-04-16 10:19:09.030579948 -0400
+++ linux-rt.git/kernel/sysctl.c	2014-04-16 10:31:20.189360458 -0400
@@ -91,6 +91,10 @@
 #include <linux/nmi.h>
 #endif
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+extern int rt_rw_limit;
+#endif
+
 
 #if defined(CONFIG_SYSCTL)
 
@@ -453,6 +457,15 @@
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_PREEMPT_RT_FULL
+	{
+		.procname	= "rwsem_reader_limit",
+		.data		= &rt_rw_limit,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 	{
 		.procname	= "panic",
 		.data		= &panic_timeout,
Index: linux-rt.git/include/linux/rtmutex.h
===================================================================
--- linux-rt.git.orig/include/linux/rtmutex.h	2014-04-16 10:19:09.030579948 -0400
+++ linux-rt.git/include/linux/rtmutex.h	2014-04-16 10:31:20.189360458 -0400
@@ -42,6 +42,21 @@
 #endif
 };
 
+/**
+ * The rt_rw_mutex structure
+ *
+ * @rt_mutex:	The mutex to wait on
+ * @owners:	list of read owners of the mutex
+ * @nr_owners:	number of read owners
+ * @prio:	the priority of the highest waiter
+ */
+struct rt_rw_mutex {
+	struct rt_mutex		mutex;
+	struct list_head	owners;
+	int			nr_owners;
+	int			prio;
+};
+
 struct rt_mutex_waiter;
 struct hrtimer_sleeper;
 
@@ -75,6 +90,15 @@
 		__rt_mutex_init(mutex, #mutex);			\
 	} while (0)
 
+# define rt_rw_mutex_init(rwmutex)					\
+	do {								\
+		raw_spin_lock_init(&(rwmutex)->mutex.wait_lock);	\
+		INIT_LIST_HEAD(&(rwmutex)->owners);			\
+		(rwmutex)->nr_owners = 0;				\
+		(rwmutex)->prio = -1;					\
+		__rt_mutex_init(&(rwmutex)->mutex, #rwmutex);		\
+	} while (0)
+
 #define __RT_MUTEX_INITIALIZER_PLAIN(mutexname) \
 	.wait_lock = __RAW_SPIN_LOCK_UNLOCKED(mutexname.wait_lock) \
 	, .wait_list = PLIST_HEAD_INIT(mutexname.wait_list) \
@@ -85,6 +109,11 @@
 #define __RT_MUTEX_INITIALIZER(mutexname) \
 	{ __RT_MUTEX_INITIALIZER_PLAIN(mutexname) }
 
+#define __RT_RW_MUTEX_INITIALIZER(mutexname)			\
+	{ .owners = LIST_HEAD_INIT(mutexname.owners)		\
+	  , .prio = -1						\
+	  , .mutex = __RT_MUTEX_INITIALIZER(mutexname.mutex) }
+
 #define __RT_MUTEX_INITIALIZER_SAVE_STATE(mutexname) \
 	{ __RT_MUTEX_INITIALIZER_PLAIN(mutexname)    \
 	  , .save_state = 1 }
Index: linux-rt.git/include/linux/rwsem_rt.h
===================================================================
--- linux-rt.git.orig/include/linux/rwsem_rt.h	2014-04-16 10:19:09.030579948 -0400
+++ linux-rt.git/include/linux/rwsem_rt.h	2014-04-16 10:31:20.198360345 -0400
@@ -19,14 +19,14 @@
 #include <linux/rtmutex.h>
 
 struct rw_semaphore {
-	struct rt_mutex		lock;
+	struct rt_rw_mutex	rwlock;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
 };
 
 #define __RWSEM_INITIALIZER(name) \
-	{ .lock = __RT_MUTEX_INITIALIZER(name.lock), \
+	{ .rwlock = __RT_RW_MUTEX_INITIALIZER(name.rwlock), \
 	  RW_DEP_MAP_INIT(name) }
 
 #define DECLARE_RWSEM(lockname) \
@@ -37,7 +37,7 @@
 
 #define __rt_init_rwsem(sem, name, key)			\
 	do {						\
-		rt_mutex_init(&(sem)->lock);		\
+		rt_rw_mutex_init(&(sem)->rwlock);	\
 		__rt_rwsem_init((sem), (name), (key));\
 	} while (0)
 
@@ -63,7 +63,7 @@
 extern void  rt_downgrade_write(struct rw_semaphore *rwsem);
 
 #define init_rwsem(sem)		rt_init_rwsem(sem)
-#define rwsem_is_locked(s)	rt_mutex_is_locked(&(s)->lock)
+#define rwsem_is_locked(s)	rt_mutex_is_locked(&(s)->rwlock.mutex)
 
 static inline void down_read(struct rw_semaphore *sem)
 {
Index: linux-rt.git/kernel/futex.c
===================================================================
--- linux-rt.git.orig/kernel/futex.c	2014-04-16 10:19:09.030579948 -0400
+++ linux-rt.git/kernel/futex.c	2014-04-16 10:31:20.204360269 -0400
@@ -2327,7 +2327,7 @@
 	 * The waiter is allocated on our stack, manipulated by the requeue
 	 * code while we sleep on uaddr.
 	 */
-	rt_mutex_init_waiter(&rt_waiter, false);
+	rt_mutex_init_waiter(&rt_waiter, false, false);
 
 	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
