Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaEADVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:21:43 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:7041 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaEADVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:21:42 -0400
Message-ID: <1398914496.22957.11.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH v3] rwsem: Support optimistic spinning
From: Davidlohr Bueso <davidlohr@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-kernel@vger.kernel.org
Date: Wed, 30 Apr 2014 20:21:36 -0700
In-Reply-To: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have reached the point where our mutexes are quite fine tuned
for a number of situations. This includes the use of heuristics
and optimistic spinning, based on MCS locking techniques.

Exclusive ownership of read-write semaphores are, conceptually,
just about the same as mutexes, making them close cousins. To
this end we need to make them both perform similarly, and
right now, rwsems are simply not up to it. This was discovered
by both reverting commit 4fc3f1d6 (mm/rmap, migration: Make
rmap_walk_anon() and try_to_unmap_anon() more scalable) and
similarly, converting some other mutexes (ie: i_mmap_mutex) to
rwsems. This creates a situation where users have to choose
between a rwsem and mutex taking into account this important
performance difference. Specifically, biggest difference between
both locks is when we fail to acquire a mutex in the fastpath,
optimistic spinning comes in to play and we can avoid a large
amount of unnecessary sleeping and overhead of moving tasks in
and out of wait queue. Rwsems do not have such logic.

This patch, based on the work from Tim Chen and I, adds support
for write-side optimistic spinning when the lock is contended.
It also includes support for the recently added cancelable MCS
locking for adaptive spinning. Note that is is only applicable
to the xadd method, and the spinlock rwsem variant remains intact.

Allowing optimistic spinning before putting the writer on the wait
queue reduces wait queue contention and provided greater chance
for the rwsem to get acquired. With these changes, rwsem is on par
with mutex. The performance benefits can be seen on a number of
workloads. For instance, on a 8 socket, 80 core 64bit Westmere box,
aim7 shows the following improvements in throughput:

+--------------+---------------------+-----------------+
|   Workload   | throughput-increase | number of users |
+--------------+---------------------+-----------------+
| alltests     | 20%                 | >1000           |
| custom       | 27%, 60%            | 10-100, >1000   |
| high_systime | 36%, 30%            | >100, >1000     |
| shared       | 58%, 29%            | 10-100, >1000   |
+--------------+---------------------+-----------------+

There was also improvement on smaller systems, such as a quad-core
x86-64 laptop running a 30Gb PostgreSQL (pgbench) workload for up
to +60% in throughput for over 50 clients. Additionally, benefits
were also noticed in exim (mail server) workloads. Furthermore, no
performance regression have been seen at all.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
Changes from v2 (https://lkml.org/lkml/2014/4/28/610):
 - Documented owner entry in struct rw_semaphore.

 - For rwsem_down_write_failed(): Use set_current_state() family 
   instead of through a tsk variable. Also cleanup. The 'waiting'
   boolean was kept as we do endup having to check the list_empty
   later on, and since we endup adding a new element to the list,
   it is much simpler and straightforward to keep it around calling
   __rwsem_do_wake().

 - Rewrote rwsem_can_spin_on_owner(), including checking for
   need_resched().
   
 - Cleaned up rwsem_try_write_lock_unqueued().

 - Added more comments.

 - Did more testing, so far no regressions or issues.

Changes from v1 (http://www.spinics.net/lists/kernel/msg1727764.html):
 - Explicitly mention in the changelog that this works only for xadd rwsem method.
 - Make clear/set owner functions depend on CONFIG_SMP and CONFIG_RWSEM_XCHGADD_ALGORITHM
 - Make sure we clear the owner before releasing the write lock.

 include/linux/rwsem.h       |  25 ++++-
 kernel/locking/rwsem-xadd.c | 224 ++++++++++++++++++++++++++++++++++++++------
 kernel/locking/rwsem.c      |  31 +++++-
 3 files changed, 245 insertions(+), 35 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 03f3b05..3e108f1 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -16,6 +16,7 @@
 
 #include <linux/atomic.h>
 
+struct optimistic_spin_queue;
 struct rw_semaphore;
 
 #ifdef CONFIG_RWSEM_GENERIC_SPINLOCK
@@ -23,9 +24,17 @@ struct rw_semaphore;
 #else
 /* All arch specific implementations share the same struct */
 struct rw_semaphore {
-	long			count;
-	raw_spinlock_t		wait_lock;
-	struct list_head	wait_list;
+	long count;
+	raw_spinlock_t wait_lock;
+	struct list_head wait_list;
+#ifdef CONFIG_SMP
+	/*
+	 * Write owner. Used as a speculative check to see
+	 * if the owner is running on the cpu.
+	 */
+	struct task_struct *owner;
+	struct optimistic_spin_queue *osq; /* spinner MCS lock */
+#endif
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
@@ -55,11 +64,21 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
 
+#ifdef CONFIG_SMP
+#define __RWSEM_INITIALIZER(name)			\
+	{ RWSEM_UNLOCKED_VALUE,				\
+	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
+	  LIST_HEAD_INIT((name).wait_list),		\
+	  NULL, /* owner */				\
+	  NULL /* mcs lock */                           \
+	  __RWSEM_DEP_MAP_INIT(name) }
+#else
 #define __RWSEM_INITIALIZER(name)			\
 	{ RWSEM_UNLOCKED_VALUE,				\
 	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
 	  LIST_HEAD_INIT((name).wait_list)		\
 	  __RWSEM_DEP_MAP_INIT(name) }
+#endif
 
 #define DECLARE_RWSEM(name) \
 	struct rw_semaphore name = __RWSEM_INITIALIZER(name)
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 1d66e08..82c4e7e 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -5,15 +5,19 @@
  *
  * Writer lock-stealing by Alex Shi <alex.shi@intel.com>
  * and Michel Lespinasse <walken@google.com>
+ *
+ * Optimistic spinning by Tim Chen <tim.c.chen@intel.com>
+ * and Davidlohr Bueso <davidlohr@hp.com>. Based on mutexes.
  */
 #include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/init.h>
+#include <linux/sched/rt.h>
 #include <linux/export.h>
 
-/*
- * Initialize an rwsem:
- */
+#include "mcs_spinlock.h"
+
+/*initialize a rwsem */
 void __init_rwsem(struct rw_semaphore *sem, const char *name,
 		  struct lock_class_key *key)
 {
@@ -27,6 +31,10 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	sem->count = RWSEM_UNLOCKED_VALUE;
 	raw_spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->wait_list);
+#ifdef CONFIG_SMP
+	sem->owner = NULL;
+	sem->osq = NULL;
+#endif
 }
 
 EXPORT_SYMBOL(__init_rwsem);
@@ -141,7 +149,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 }
 
 /*
- * wait for the read lock to be granted
+ * Wait for the read lock to be granted
  */
 __visible
 struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
@@ -188,64 +196,218 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 	return sem;
 }
 
+static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
+{
+	if (!(count & RWSEM_ACTIVE_MASK)) {
+		/* try acquiring the write lock */
+		if (sem->count == RWSEM_WAITING_BIAS &&
+		    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
+			    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
+			if (!list_is_singular(&sem->wait_list))
+				rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
+			return true;
+		}
+	}
+	return false;
+}
+
+#ifdef CONFIG_SMP
+/*
+ * Try to acquire write lock before the writer has been put on wait queue.
+ */
+static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
+{
+	long old, count = ACCESS_ONCE(sem->count);
+
+	while (true) {
+		if (!(count == 0 || count == RWSEM_WAITING_BIAS))
+			return false;
+
+		old = cmpxchg(&sem->count, count, count + RWSEM_ACTIVE_WRITE_BIAS);
+		if (old == count)
+			return true;
+
+		count = old;
+	}
+}
+
+static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
+{
+	struct task_struct *owner;
+	bool on_cpu = true;
+
+	if (need_resched())
+		return 0;
+
+	rcu_read_lock();
+	owner = ACCESS_ONCE(sem->owner);
+	if (owner)
+		on_cpu = owner->on_cpu;
+	rcu_read_unlock();
+
+	/*
+	 * If lock->owner is not set, the mutex owner may have
+	 * just acquired it and not set the owner yet or the mutex
+	 * has been released.
+	 */
+	return on_cpu;
+}
+
+static inline bool owner_running(struct rw_semaphore *sem,
+				 struct task_struct *owner)
+{
+	if (sem->owner != owner)
+		return false;
+
+	/*
+	 * Ensure we emit the owner->on_cpu, dereference _after_ checking
+	 * lock->owner still matches owner, if that fails, owner might
+	 * point to free()d memory, if it still matches, the rcu_read_lock()
+	 * ensures the memory stays valid.
+	 */
+	barrier();
+
+	return owner->on_cpu;
+}
+
+static noinline
+bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
+{
+	rcu_read_lock();
+	while (owner_running(sem, owner)) {
+		if (need_resched())
+			break;
+
+		arch_mutex_cpu_relax();
+	}
+	rcu_read_unlock();
+
+	/*
+	 * We break out the loop above on need_resched() or when the
+	 * owner changed, which is a sign for heavy contention. Return
+	 * success only when lock->owner is NULL.
+	 */
+	return sem->owner == NULL;
+}
+
+static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
+{
+	struct task_struct *owner;
+	bool taken = false;
+
+	preempt_disable();
+
+	/* sem->wait_lock should not be held when doing optimistic spinning */
+	if (!rwsem_can_spin_on_owner(sem))
+		goto done;
+
+	if (!osq_lock(&sem->osq))
+		goto done;
+
+	while (true) {
+		owner = ACCESS_ONCE(sem->owner);
+		if (owner && !rwsem_spin_on_owner(sem, owner))
+			break;
+
+		/* wait_lock will be acquired if write_lock is obtained */
+		if (rwsem_try_write_lock_unqueued(sem)) {
+			taken = true;
+			break;
+		}
+
+		/*
+		 * When there's no owner, we might have preempted between the
+		 * owner acquiring the lock and setting the owner field. If
+		 * we're an RT task that will live-lock because we won't let
+		 * the owner complete.
+		 */
+		if (!owner && (need_resched() || rt_task(current)))
+			break;
+
+		/*
+		 * The cpu_relax() call is a compiler barrier which forces
+		 * everything in this loop to be re-loaded. We don't need
+		 * memory barriers as we'll eventually observe the right
+		 * values at the cost of a few extra spins.
+		 */
+		arch_mutex_cpu_relax();
+	}
+	osq_unlock(&sem->osq);
+done:
+	preempt_enable();
+	return taken;
+}
+
+#else
+static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
+{
+	return false;
+}
+#endif
+
 /*
- * wait until we successfully acquire the write lock
+ * Wait until we successfully acquire the write lock
  */
 __visible
 struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
-	long count, adjustment = -RWSEM_ACTIVE_WRITE_BIAS;
+	long count;
+	bool waiting = true; /* any queued threads before us */
 	struct rwsem_waiter waiter;
-	struct task_struct *tsk = current;
+
+	/* undo write bias from down_write operation, stop active locking */
+	count = rwsem_atomic_update(-RWSEM_ACTIVE_WRITE_BIAS, sem);
+
+	/* do optimistic spinning and steal lock if possible */
+	if (rwsem_optimistic_spin(sem))
+		return sem;
 
 	/* set up my own style of waitqueue */
-	waiter.task = tsk;
+	waiter.task = current;
 	waiter.type = RWSEM_WAITING_FOR_WRITE;
 
 	raw_spin_lock_irq(&sem->wait_lock);
+
+	/* account for this before adding a new element to the list */
 	if (list_empty(&sem->wait_list))
-		adjustment += RWSEM_WAITING_BIAS;
+		waiting = false;
+
 	list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we're now waiting on the lock, but no longer actively locking */
-	count = rwsem_atomic_update(adjustment, sem);
+	if (waiting) {
+		count = ACCESS_ONCE(sem->count);
 
-	/* If there were already threads queued before us and there are no
-	 * active writers, the lock must be read owned; so we try to wake
-	 * any read locks that were queued ahead of us. */
-	if (count > RWSEM_WAITING_BIAS &&
-	    adjustment == -RWSEM_ACTIVE_WRITE_BIAS)
-		sem = __rwsem_do_wake(sem, RWSEM_WAKE_READERS);
+		/*
+		 * If there were already threads queued before us and there are no
+		 * active writers, the lock must be read owned; so we try to wake
+		 * any read locks that were queued ahead of us.
+		 */
+		if (count > RWSEM_WAITING_BIAS)
+			sem = __rwsem_do_wake(sem, RWSEM_WAKE_READERS);
+
+	} else
+		count = rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
 
 	/* wait until we successfully acquire the lock */
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+	set_current_state(TASK_UNINTERRUPTIBLE);
 	while (true) {
-		if (!(count & RWSEM_ACTIVE_MASK)) {
-			/* Try acquiring the write lock. */
-			count = RWSEM_ACTIVE_WRITE_BIAS;
-			if (!list_is_singular(&sem->wait_list))
-				count += RWSEM_WAITING_BIAS;
-
-			if (sem->count == RWSEM_WAITING_BIAS &&
-			    cmpxchg(&sem->count, RWSEM_WAITING_BIAS, count) ==
-							RWSEM_WAITING_BIAS)
-				break;
-		}
-
+		if (rwsem_try_write_lock(count, sem))
+			break;
 		raw_spin_unlock_irq(&sem->wait_lock);
 
 		/* Block until there are no active lockers. */
 		do {
 			schedule();
-			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+			set_current_state(TASK_UNINTERRUPTIBLE);
 		} while ((count = sem->count) & RWSEM_ACTIVE_MASK);
 
 		raw_spin_lock_irq(&sem->wait_lock);
 	}
+	__set_current_state(TASK_RUNNING);
 
 	list_del(&waiter.list);
 	raw_spin_unlock_irq(&sem->wait_lock);
-	tsk->state = TASK_RUNNING;
 
 	return sem;
 }
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index cfff143..42f806d 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -12,6 +12,27 @@
 
 #include <linux/atomic.h>
 
+#if defined(CONFIG_SMP) && defined(CONFIG_RWSEM_XCHGADD_ALGORITHM)
+static inline void rwsem_set_owner(struct rw_semaphore *sem)
+{
+	sem->owner = current;
+}
+
+static inline void rwsem_clear_owner(struct rw_semaphore *sem)
+{
+	sem->owner = NULL;
+}
+
+#else
+static inline void rwsem_set_owner(struct rw_semaphore *sem)
+{
+}
+
+static inline void rwsem_clear_owner(struct rw_semaphore *sem)
+{
+}
+#endif
+
 /*
  * lock for reading
  */
@@ -48,6 +69,7 @@ void __sched down_write(struct rw_semaphore *sem)
 	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+	rwsem_set_owner(sem);
 }
 
 EXPORT_SYMBOL(down_write);
@@ -59,8 +81,11 @@ int down_write_trylock(struct rw_semaphore *sem)
 {
 	int ret = __down_write_trylock(sem);
 
-	if (ret == 1)
+	if (ret == 1) {
 		rwsem_acquire(&sem->dep_map, 0, 1, _RET_IP_);
+		rwsem_set_owner(sem);
+	}
+
 	return ret;
 }
 
@@ -85,6 +110,7 @@ void up_write(struct rw_semaphore *sem)
 {
 	rwsem_release(&sem->dep_map, 1, _RET_IP_);
 
+	rwsem_clear_owner(sem);
 	__up_write(sem);
 }
 
@@ -99,6 +125,7 @@ void downgrade_write(struct rw_semaphore *sem)
 	 * lockdep: a downgraded write will live on as a write
 	 * dependency.
 	 */
+	rwsem_clear_owner(sem);
 	__downgrade_write(sem);
 }
 
@@ -122,6 +149,7 @@ void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest)
 	rwsem_acquire_nest(&sem->dep_map, 0, 0, nest, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+	rwsem_set_owner(sem);
 }
 
 EXPORT_SYMBOL(_down_write_nest_lock);
@@ -141,6 +169,7 @@ void down_write_nested(struct rw_semaphore *sem, int subclass)
 	rwsem_acquire(&sem->dep_map, subclass, 0, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+	rwsem_set_owner(sem);
 }
 
 EXPORT_SYMBOL(down_write_nested);
-- 
1.8.1.4



