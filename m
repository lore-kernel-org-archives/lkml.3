Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab3D2NKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 09:10:45 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:55328 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3D2NKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 09:10:44 -0400
Date: Mon, 29 Apr 2013 15:10:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking changes for v3.10
Message-ID: <20130429131039.GA17378@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-locking-for-linus

   HEAD: 2c522836627c6e78660f8bd52cdb4cdcb75e3e3c lockdep: Consolidate bug messages into a single print_lockdep_off() function

The most noticeable change are mutex speedups from Waiman Long, for higher 
loads. These scalability changes should be most noticeable on larger 
server systems.

There are also cleanups, fixes and debuggability improvements.

 Thanks,

	Ingo

------------------>
Dave Jones (2):
      lockdep: Print out additional debugging advice when we hit lockdep BUGs
      lockdep: Consolidate bug messages into a single print_lockdep_off() function

Hong Zhiguo (1):
      lockdep: Remove unnecessary 'hlock_next' variable

Sasha Levin (1):
      locking/rtmutex/tester: Set correct permissions on sysfs files

Waiman Long (4):
      mutex: Move mutex spinning code from sched/core.c back to mutex.c
      mutex: Make more scalable by doing less atomic operations
      mutex: Queue mutex spinners with MCS lock to reduce cacheline contention
      mutex: Back out architecture specific check for negative mutex count


 include/linux/mutex.h   |   3 +
 include/linux/sched.h   |   1 -
 kernel/lockdep.c        |  29 +++++-----
 kernel/mutex.c          | 151 ++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/rtmutex-tester.c |   5 +-
 kernel/sched/core.c     |  45 ---------------
 kernel/sched/features.h |   7 ---
 7 files changed, 168 insertions(+), 73 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 9121595..433da8a 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -53,6 +53,9 @@ struct mutex {
 #if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
 	struct task_struct	*owner;
 #endif
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
+	void			*spin_mlock;	/* Spinner MCS lock */
+#endif
 #ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
 	void			*magic;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..aefe45d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -320,7 +320,6 @@ extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
 extern void schedule_preempt_disabled(void);
-extern int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner);
 
 struct nsproxy;
 struct user_namespace;
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 8a0efac..6a3bccb 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -380,6 +380,13 @@ static int verbose(struct lock_class *class)
 unsigned long nr_stack_trace_entries;
 static unsigned long stack_trace[MAX_STACK_TRACE_ENTRIES];
 
+static void print_lockdep_off(const char *bug_msg)
+{
+	printk(KERN_DEBUG "%s\n", bug_msg);
+	printk(KERN_DEBUG "turning off the locking correctness validator.\n");
+	printk(KERN_DEBUG "Please attach the output of /proc/lock_stat to the bug report\n");
+}
+
 static int save_trace(struct stack_trace *trace)
 {
 	trace->nr_entries = 0;
@@ -409,8 +416,7 @@ static int save_trace(struct stack_trace *trace)
 		if (!debug_locks_off_graph_unlock())
 			return 0;
 
-		printk("BUG: MAX_STACK_TRACE_ENTRIES too low!\n");
-		printk("turning off the locking correctness validator.\n");
+		print_lockdep_off("BUG: MAX_STACK_TRACE_ENTRIES too low!");
 		dump_stack();
 
 		return 0;
@@ -763,8 +769,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 		}
 		raw_local_irq_restore(flags);
 
-		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
-		printk("turning off the locking correctness validator.\n");
+		print_lockdep_off("BUG: MAX_LOCKDEP_KEYS too low!");
 		dump_stack();
 		return NULL;
 	}
@@ -834,8 +839,7 @@ static struct lock_list *alloc_list_entry(void)
 		if (!debug_locks_off_graph_unlock())
 			return NULL;
 
-		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
-		printk("turning off the locking correctness validator.\n");
+		print_lockdep_off("BUG: MAX_LOCKDEP_ENTRIES too low!");
 		dump_stack();
 		return NULL;
 	}
@@ -2000,7 +2004,7 @@ static inline int lookup_chain_cache(struct task_struct *curr,
 	struct lock_class *class = hlock_class(hlock);
 	struct list_head *hash_head = chainhashentry(chain_key);
 	struct lock_chain *chain;
-	struct held_lock *hlock_curr, *hlock_next;
+	struct held_lock *hlock_curr;
 	int i, j;
 
 	/*
@@ -2048,8 +2052,7 @@ cache_hit:
 		if (!debug_locks_off_graph_unlock())
 			return 0;
 
-		printk("BUG: MAX_LOCKDEP_CHAINS too low!\n");
-		printk("turning off the locking correctness validator.\n");
+		print_lockdep_off("BUG: MAX_LOCKDEP_CHAINS too low!");
 		dump_stack();
 		return 0;
 	}
@@ -2057,12 +2060,10 @@ cache_hit:
 	chain->chain_key = chain_key;
 	chain->irq_context = hlock->irq_context;
 	/* Find the first held_lock of current chain */
-	hlock_next = hlock;
 	for (i = curr->lockdep_depth - 1; i >= 0; i--) {
 		hlock_curr = curr->held_locks + i;
-		if (hlock_curr->irq_context != hlock_next->irq_context)
+		if (hlock_curr->irq_context != hlock->irq_context)
 			break;
-		hlock_next = hlock;
 	}
 	i++;
 	chain->depth = curr->lockdep_depth + 1 - i;
@@ -3190,9 +3191,9 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 #endif
 	if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH)) {
 		debug_locks_off();
-		printk("BUG: MAX_LOCK_DEPTH too low, depth: %i  max: %lu!\n",
+		print_lockdep_off("BUG: MAX_LOCK_DEPTH too low!");
+		printk(KERN_DEBUG "depth: %i  max: %lu!\n",
 		       curr->lockdep_depth, MAX_LOCK_DEPTH);
-		printk("turning off the locking correctness validator.\n");
 
 		lockdep_print_held_locks(current);
 		debug_show_all_locks();
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 52f2301..ad53a66 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -37,6 +37,12 @@
 # include <asm/mutex.h>
 #endif
 
+/*
+ * A negative mutex count indicates that waiters are sleeping waiting for the
+ * mutex.
+ */
+#define	MUTEX_SHOW_NO_WAITER(mutex)	(atomic_read(&(mutex)->count) >= 0)
+
 void
 __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 {
@@ -44,6 +50,9 @@ __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 	spin_lock_init(&lock->wait_lock);
 	INIT_LIST_HEAD(&lock->wait_list);
 	mutex_clear_owner(lock);
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
+	lock->spin_mlock = NULL;
+#endif
 
 	debug_mutex_init(lock, name, key);
 }
@@ -95,6 +104,124 @@ void __sched mutex_lock(struct mutex *lock)
 EXPORT_SYMBOL(mutex_lock);
 #endif
 
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
+/*
+ * In order to avoid a stampede of mutex spinners from acquiring the mutex
+ * more or less simultaneously, the spinners need to acquire a MCS lock
+ * first before spinning on the owner field.
+ *
+ * We don't inline mspin_lock() so that perf can correctly account for the
+ * time spent in this lock function.
+ */
+struct mspin_node {
+	struct mspin_node *next ;
+	int		  locked;	/* 1 if lock acquired */
+};
+#define	MLOCK(mutex)	((struct mspin_node **)&((mutex)->spin_mlock))
+
+static noinline
+void mspin_lock(struct mspin_node **lock, struct mspin_node *node)
+{
+	struct mspin_node *prev;
+
+	/* Init node */
+	node->locked = 0;
+	node->next   = NULL;
+
+	prev = xchg(lock, node);
+	if (likely(prev == NULL)) {
+		/* Lock acquired */
+		node->locked = 1;
+		return;
+	}
+	ACCESS_ONCE(prev->next) = node;
+	smp_wmb();
+	/* Wait until the lock holder passes the lock down */
+	while (!ACCESS_ONCE(node->locked))
+		arch_mutex_cpu_relax();
+}
+
+static void mspin_unlock(struct mspin_node **lock, struct mspin_node *node)
+{
+	struct mspin_node *next = ACCESS_ONCE(node->next);
+
+	if (likely(!next)) {
+		/*
+		 * Release the lock by setting it to NULL
+		 */
+		if (cmpxchg(lock, node, NULL) == node)
+			return;
+		/* Wait until the next pointer is set */
+		while (!(next = ACCESS_ONCE(node->next)))
+			arch_mutex_cpu_relax();
+	}
+	ACCESS_ONCE(next->locked) = 1;
+	smp_wmb();
+}
+
+/*
+ * Mutex spinning code migrated from kernel/sched/core.c
+ */
+
+static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
+{
+	if (lock->owner != owner)
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
+/*
+ * Look out! "owner" is an entirely speculative pointer
+ * access and not reliable.
+ */
+static noinline
+int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
+{
+	rcu_read_lock();
+	while (owner_running(lock, owner)) {
+		if (need_resched())
+			break;
+
+		arch_mutex_cpu_relax();
+	}
+	rcu_read_unlock();
+
+	/*
+	 * We break out the loop above on need_resched() and when the
+	 * owner changed, which is a sign for heavy contention. Return
+	 * success only when lock->owner is NULL.
+	 */
+	return lock->owner == NULL;
+}
+
+/*
+ * Initial check for entering the mutex spinning loop
+ */
+static inline int mutex_can_spin_on_owner(struct mutex *lock)
+{
+	int retval = 1;
+
+	rcu_read_lock();
+	if (lock->owner)
+		retval = lock->owner->on_cpu;
+	rcu_read_unlock();
+	/*
+	 * if lock->owner is not set, the mutex owner may have just acquired
+	 * it and not set the owner yet or the mutex has been released.
+	 */
+	return retval;
+}
+#endif
+
 static __used noinline void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
 
 /**
@@ -158,25 +285,39 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	 *
 	 * We can't do this for DEBUG_MUTEXES because that relies on wait_lock
 	 * to serialize everything.
+	 *
+	 * The mutex spinners are queued up using MCS lock so that only one
+	 * spinner can compete for the mutex. However, if mutex spinning isn't
+	 * going to happen, there is no point in going through the lock/unlock
+	 * overhead.
 	 */
+	if (!mutex_can_spin_on_owner(lock))
+		goto slowpath;
 
 	for (;;) {
 		struct task_struct *owner;
+		struct mspin_node  node;
 
 		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
+		mspin_lock(MLOCK(lock), &node);
 		owner = ACCESS_ONCE(lock->owner);
-		if (owner && !mutex_spin_on_owner(lock, owner))
+		if (owner && !mutex_spin_on_owner(lock, owner)) {
+			mspin_unlock(MLOCK(lock), &node);
 			break;
+		}
 
-		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
+		if ((atomic_read(&lock->count) == 1) &&
+		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
 			lock_acquired(&lock->dep_map, ip);
 			mutex_set_owner(lock);
+			mspin_unlock(MLOCK(lock), &node);
 			preempt_enable();
 			return 0;
 		}
+		mspin_unlock(MLOCK(lock), &node);
 
 		/*
 		 * When there's no owner, we might have preempted between the
@@ -195,6 +336,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 */
 		arch_mutex_cpu_relax();
 	}
+slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 
@@ -205,7 +347,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
 
-	if (atomic_xchg(&lock->count, -1) == 1)
+	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, -1) == 1))
 		goto done;
 
 	lock_contended(&lock->dep_map, ip);
@@ -220,7 +362,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * that when we release the lock, we properly wake up the
 		 * other waiters:
 		 */
-		if (atomic_xchg(&lock->count, -1) == 1)
+		if (MUTEX_SHOW_NO_WAITER(lock) &&
+		   (atomic_xchg(&lock->count, -1) == 1))
 			break;
 
 		/*
diff --git a/kernel/rtmutex-tester.c b/kernel/rtmutex-tester.c
index 7890b10..1d96dd0 100644
--- a/kernel/rtmutex-tester.c
+++ b/kernel/rtmutex-tester.c
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/timer.h>
 #include <linux/freezer.h>
+#include <linux/stat.h>
 
 #include "rtmutex.h"
 
@@ -366,8 +367,8 @@ static ssize_t sysfs_test_status(struct device *dev, struct device_attribute *at
 	return curr - buf;
 }
 
-static DEVICE_ATTR(status, 0600, sysfs_test_status, NULL);
-static DEVICE_ATTR(command, 0600, NULL, sysfs_test_command);
+static DEVICE_ATTR(status, S_IRUSR, sysfs_test_status, NULL);
+static DEVICE_ATTR(command, S_IWUSR, NULL, sysfs_test_command);
 
 static struct bus_type rttest_subsys = {
 	.name = "rttest",
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..b37a22b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2997,51 +2997,6 @@ void __sched schedule_preempt_disabled(void)
 	preempt_disable();
 }
 
-#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-
-static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
-{
-	if (lock->owner != owner)
-		return false;
-
-	/*
-	 * Ensure we emit the owner->on_cpu, dereference _after_ checking
-	 * lock->owner still matches owner, if that fails, owner might
-	 * point to free()d memory, if it still matches, the rcu_read_lock()
-	 * ensures the memory stays valid.
-	 */
-	barrier();
-
-	return owner->on_cpu;
-}
-
-/*
- * Look out! "owner" is an entirely speculative pointer
- * access and not reliable.
- */
-int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
-{
-	if (!sched_feat(OWNER_SPIN))
-		return 0;
-
-	rcu_read_lock();
-	while (owner_running(lock, owner)) {
-		if (need_resched())
-			break;
-
-		arch_mutex_cpu_relax();
-	}
-	rcu_read_unlock();
-
-	/*
-	 * We break out the loop above on need_resched() and when the
-	 * owner changed, which is a sign for heavy contention. Return
-	 * success only when lock->owner is NULL.
-	 */
-	return lock->owner == NULL;
-}
-#endif
-
 #ifdef CONFIG_PREEMPT
 /*
  * this is the entry point to schedule() from in-kernel preemption
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 1ad1d2b..99399f8 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -46,13 +46,6 @@ SCHED_FEAT(DOUBLE_TICK, false)
 SCHED_FEAT(LB_BIAS, true)
 
 /*
- * Spin-wait on mutex acquisition when the mutex owner is running on
- * another cpu -- assumes that when the owner is running, it will soon
- * release the lock. Decreases scheduling overhead.
- */
-SCHED_FEAT(OWNER_SPIN, true)
-
-/*
  * Decrement CPU power based on time not spent running tasks
  */
 SCHED_FEAT(NONTASK_POWER, true)
