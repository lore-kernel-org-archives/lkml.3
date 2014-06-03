Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaFCWxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:53:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbaFCWxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:53:51 -0400
Date: Tue, 3 Jun 2014 15:53:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-Id: <20140603155349.7dc8cb0ea46c43e66d4cf038@linux-foundation.org>
In-Reply-To: <1401832948.8843.10.camel@buesod1.americas.hpqcorp.net>
References: <20140603114821.GA23711@gmail.com>
	<1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
	<20140603145526.f78e1cb7462048376709b6f0@linux-foundation.org>
	<1401832948.8843.10.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2014 15:02:28 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:

> On Tue, 2014-06-03 at 14:55 -0700, Andrew Morton wrote:
> > On Tue, 03 Jun 2014 14:50:51 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
> > 
> > > > The main changes in this cycle were:
> > > > 
> > > >  - reduced/streamlined smp_mb__*() interface that allows more usecases 
> > > >    and makes the existing ones less buggy, especially in rarer 
> > > >    architectures
> > > > 
> > > >  - add rwsem implementation comments
> > > > 
> > > >  - bump up lockdep limits
> > > 
> > > So I guess the rwsem optimistic spinning stuff will be routed through
> > > akpm then (which is already in -next for a while, through -mm).
> > 
> > I'd prefer not - I put it in there just to get some linux-next exposure.
> > A change like this should be carefully poked at by people who understand
> > what they're poking.
> 
> The patch was reviewed, tested and taken for tip by tglx -- then dropped
> because of the gcc warnings for archs that use the spinlock rwsem
> variant, which was quickly fixed and confirmed by Peter.
> 
> So I'm not sure why it dropped in the first place (the same thing
> occurred with the qrwlock_t stuff).
> 
> This is a pretty big change that boosts performance significantly. I
> really wouldn't want to wait another development cycle for nothing. If
> it's too late in the pull request and tip maintainers are ok with it, I
> would very much like it to be merged either directly through Linux
> (who's occasionally done such things in the past) or by you.

Here's the latest version.


From: Davidlohr Bueso <davidlohr@hp.com>
Subject: rwsem: Support optimistic spinning

We have reached the point where our mutexes are quite fine tuned for a
number of situations.  This includes the use of heuristics and optimistic
spinning, based on MCS locking techniques.

Exclusive ownership of read-write semaphores are, conceptually, just about
the same as mutexes, making them close cousins.  To this end we need to
make them both perform similarly, and right now, rwsems are simply not up
to it.  This was discovered by both reverting commit 4fc3f1d6 (mm/rmap,
migration: Make rmap_walk_anon() and try_to_unmap_anon() more scalable)
and similarly, converting some other mutexes (ie: i_mmap_mutex) to rwsems.
 This creates a situation where users have to choose between a rwsem and
mutex taking into account this important performance difference. 
Specifically, biggest difference between both locks is when we fail to
acquire a mutex in the fastpath, optimistic spinning comes in to play and
we can avoid a large amount of unnecessary sleeping and overhead of moving
tasks in and out of wait queue.  Rwsems do not have such logic.

This patch, based on the work from Tim Chen and I, adds support for
write-side optimistic spinning when the lock is contended.  It also
includes support for the recently added cancelable MCS locking for
adaptive spinning.  Note that is is only applicable to the xadd method,
and the spinlock rwsem variant remains intact.

Allowing optimistic spinning before putting the writer on the wait queue
reduces wait queue contention and provided greater chance for the rwsem to
get acquired.  With these changes, rwsem is on par with mutex.  The
performance benefits can be seen on a number of workloads.  For instance,
on a 8 socket, 80 core 64bit Westmere box, aim7 shows the following
improvements in throughput:

+--------------+---------------------+-----------------+
|   Workload   | throughput-increase | number of users |
+--------------+---------------------+-----------------+
| alltests     | 20%                 | >1000           |
| custom       | 27%, 60%            | 10-100, >1000   |
| high_systime | 36%, 30%            | >100, >1000     |
| shared       | 58%, 29%            | 10-100, >1000   |
+--------------+---------------------+-----------------+

There was also improvement on smaller systems, such as a quad-core x86-64
laptop running a 30Gb PostgreSQL (pgbench) workload for up to +60% in
throughput for over 50 clients.  Additionally, benefits were also noticed
in exim (mail server) workloads.  When comparing against regular
non-blocking rw locks ([q]rwlock_t), this change proves that it can
outperform them, for instance when studying the popular anon-vma lock:

http://www.spinics.net/lists/linux-mm/msg72705.html

Furthermore, no performance regression have been seen at all.

This patch applies on top of the -tip branch.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rwsem.h       |   25 +++
 kernel/locking/rwsem-xadd.c |  229 +++++++++++++++++++++++++++++-----
 kernel/locking/rwsem.c      |   31 ++++
 3 files changed, 249 insertions(+), 36 deletions(-)

diff -puN include/linux/rwsem.h~rwsem-support-optimistic-spinning include/linux/rwsem.h
--- a/include/linux/rwsem.h~rwsem-support-optimistic-spinning
+++ a/include/linux/rwsem.h
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
@@ -55,11 +64,21 @@ static inline int rwsem_is_locked(struct
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
 
+#if defined(CONFIG_SMP) && defined(CONFIG_RWSEM_XCHGADD_ALGORITHM)
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
diff -puN kernel/locking/rwsem-xadd.c~rwsem-support-optimistic-spinning kernel/locking/rwsem-xadd.c
--- a/kernel/locking/rwsem-xadd.c~rwsem-support-optimistic-spinning
+++ a/kernel/locking/rwsem-xadd.c
@@ -5,12 +5,18 @@
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
 
+#include "mcs_spinlock.h"
+
 /*
  * Guide to the rw_semaphore's count field for common values.
  * (32-bit case illustrated, similar for 64-bit)
@@ -60,9 +66,7 @@
  *
  */
 
-/*
- * Initialize an rwsem:
- */
+/* initialize a rwsem */
 void __init_rwsem(struct rw_semaphore *sem, const char *name,
 		  struct lock_class_key *key)
 {
@@ -76,6 +80,10 @@ void __init_rwsem(struct rw_semaphore *s
 	sem->count = RWSEM_UNLOCKED_VALUE;
 	raw_spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->wait_list);
+#ifdef CONFIG_SMP
+	sem->owner = NULL;
+	sem->osq = NULL;
+#endif
 }
 
 EXPORT_SYMBOL(__init_rwsem);
@@ -190,7 +198,7 @@ __rwsem_do_wake(struct rw_semaphore *sem
 }
 
 /*
- * wait for the read lock to be granted
+ * Wait for the read lock to be granted
  */
 __visible
 struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
@@ -237,64 +245,221 @@ struct rw_semaphore __sched *rwsem_down_
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
 /*
- * wait until we successfully acquire the write lock
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
+	 * If sem->owner is not set, the rwsem owner may have
+	 * just acquired it and not set the owner yet or the rwsem
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
+	 * sem->owner still matches owner, if that fails, owner might
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
+	 * success only when sem->owner is NULL.
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
+/*
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
 
-	/* set up my own style of waitqueue */
-	waiter.task = tsk;
+	/* undo write bias from down_write operation, stop active locking */
+	count = rwsem_atomic_update(-RWSEM_ACTIVE_WRITE_BIAS, sem);
+
+	/* do optimistic spinning and steal lock if possible */
+	if (rwsem_optimistic_spin(sem))
+		return sem;
+
+	/*
+	 * Optimistic spinning failed, proceed to the slowpath
+	 * and block until we can acquire the sem.
+	 */
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
+		 * If there were already threads queued before us and there are
+		 * no active writers, the lock must be read owned; so we try to
+		 * wake any read locks that were queued ahead of us.
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
diff -puN kernel/locking/rwsem.c~rwsem-support-optimistic-spinning kernel/locking/rwsem.c
--- a/kernel/locking/rwsem.c~rwsem-support-optimistic-spinning
+++ a/kernel/locking/rwsem.c
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
@@ -48,6 +69,7 @@ void __sched down_write(struct rw_semaph
 	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+	rwsem_set_owner(sem);
 }
 
 EXPORT_SYMBOL(down_write);
@@ -59,8 +81,11 @@ int down_write_trylock(struct rw_semapho
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
 
@@ -99,6 +125,7 @@ void downgrade_write(struct rw_semaphore
 	 * lockdep: a downgraded write will live on as a write
 	 * dependency.
 	 */
+	rwsem_clear_owner(sem);
 	__downgrade_write(sem);
 }
 
@@ -122,6 +149,7 @@ void _down_write_nest_lock(struct rw_sem
 	rwsem_acquire_nest(&sem->dep_map, 0, 0, nest, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+	rwsem_set_owner(sem);
 }
 
 EXPORT_SYMBOL(_down_write_nest_lock);
@@ -141,6 +169,7 @@ void down_write_nested(struct rw_semapho
 	rwsem_acquire(&sem->dep_map, subclass, 0, _RET_IP_);
 
 	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
+	rwsem_set_owner(sem);
 }
 
 EXPORT_SYMBOL(down_write_nested);
_

