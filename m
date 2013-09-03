Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055Ab3ICMQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:16:06 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:57556 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760040Ab3ICMQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:16:03 -0400
Date: Tue, 3 Sep 2013 14:15:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/locking changes for v3.12
Message-ID: <20130903121559.GA24563@gmail.com>
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

   HEAD: 15e71911fcc655508e02f767a3d9b8b138051d2b generic-ipi/locking: Fix misleading smp_call_function_any() description

Main changes:

 - another mutex optimization, from Davidlohr Bueso

 - improved lglock lockdep tracking, from Michel Lespinasse

 - [ assorted smaller updates, improvements, cleanups. ]

 Thanks,

	Ingo

------------------>
Davidlohr Bueso (2):
      mutex: Do not unnecessarily deal with waiters
      mutex: Avoid label warning when !CONFIG_MUTEX_SPIN_ON_OWNER

Michel Lespinasse (2):
      lockdep: Introduce lock_acquire_exclusive()/shared() helper macros
      lglock: Update lockdep annotations to report recursive local locks

Oleg Nesterov (1):
      hung_task debugging: Print more info when reporting the problem

Peter Zijlstra (1):
      mutex: Fix/document access-once assumption in mutex_can_spin_on_owner()

Xie XiuQi (1):
      generic-ipi/locking: Fix misleading smp_call_function_any() description


 include/linux/lockdep.h | 92 +++++++++++++------------------------------------
 kernel/hung_task.c      | 13 ++++---
 kernel/lglock.c         | 12 +++----
 kernel/mutex.c          | 43 +++++++++++------------
 kernel/smp.c            |  2 --
 5 files changed, 58 insertions(+), 104 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index f1e877b..cfc2f11 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -365,7 +365,7 @@ extern void lockdep_trace_alloc(gfp_t mask);
 
 #define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
 
-#else /* !LOCKDEP */
+#else /* !CONFIG_LOCKDEP */
 
 static inline void lockdep_off(void)
 {
@@ -479,82 +479,36 @@ static inline void print_irqtrace_events(struct task_struct *curr)
  * on the per lock-class debug mode:
  */
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
-# else
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, NULL, i)
-# endif
-# define spin_release(l, n, i)			lock_release(l, n, i)
+#ifdef CONFIG_PROVE_LOCKING
+ #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 2, n, i)
+ #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 2, n, i)
+ #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 2, n, i)
 #else
-# define spin_acquire(l, s, t, i)		do { } while (0)
-# define spin_release(l, n, i)			do { } while (0)
+ #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
+ #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
+ #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
 #endif
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, NULL, i)
-# else
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, NULL, i)
-# endif
-# define rwlock_release(l, n, i)		lock_release(l, n, i)
-#else
-# define rwlock_acquire(l, s, t, i)		do { } while (0)
-# define rwlock_acquire_read(l, s, t, i)	do { } while (0)
-# define rwlock_release(l, n, i)		do { } while (0)
-#endif
+#define spin_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define spin_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
+#define spin_release(l, n, i)			lock_release(l, n, i)
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
-# else
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define mutex_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, n, i)
-# endif
-# define mutex_release(l, n, i)			lock_release(l, n, i)
-#else
-# define mutex_acquire(l, s, t, i)		do { } while (0)
-# define mutex_acquire_nest(l, s, t, n, i)	do { } while (0)
-# define mutex_release(l, n, i)			do { } while (0)
-#endif
+#define rwlock_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define rwlock_acquire_read(l, s, t, i)		lock_acquire_shared_recursive(l, s, t, NULL, i)
+#define rwlock_release(l, n, i)			lock_release(l, n, i)
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, NULL, i)
-# else
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, n, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, NULL, i)
-# endif
+#define mutex_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define mutex_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
+#define mutex_release(l, n, i)			lock_release(l, n, i)
+
+#define rwsem_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
+#define rwsem_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)
+#define rwsem_acquire_read(l, s, t, i)		lock_acquire_shared(l, s, t, NULL, i)
 # define rwsem_release(l, n, i)			lock_release(l, n, i)
-#else
-# define rwsem_acquire(l, s, t, i)		do { } while (0)
-# define rwsem_acquire_nest(l, s, t, n, i)	do { } while (0)
-# define rwsem_acquire_read(l, s, t, i)		do { } while (0)
-# define rwsem_release(l, n, i)			do { } while (0)
-#endif
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# ifdef CONFIG_PROVE_LOCKING
-#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
-#  define lock_map_acquire_read(l)	lock_acquire(l, 0, 0, 2, 2, NULL, _THIS_IP_)
-# else
-#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
-#  define lock_map_acquire_read(l)	lock_acquire(l, 0, 0, 2, 1, NULL, _THIS_IP_)
-# endif
+#define lock_map_acquire(l)			lock_acquire_exclusive(l, 0, 0, NULL, _THIS_IP_)
+#define lock_map_acquire_read(l)		lock_acquire_shared_recursive(l, 0, 0, NULL, _THIS_IP_)
 # define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
-#else
-# define lock_map_acquire(l)			do { } while (0)
-# define lock_map_acquire_read(l)		do { } while (0)
-# define lock_map_release(l)			do { } while (0)
-#endif
 
 #ifdef CONFIG_PROVE_LOCKING
 # define might_lock(lock) 						\
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 6df6149..3e97fb1 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -15,6 +15,7 @@
 #include <linux/lockdep.h>
 #include <linux/export.h>
 #include <linux/sysctl.h>
+#include <linux/utsname.h>
 
 /*
  * The number of tasks checked:
@@ -99,10 +100,14 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
 	 * Ok, the task did not get scheduled for more than 2 minutes,
 	 * complain:
 	 */
-	printk(KERN_ERR "INFO: task %s:%d blocked for more than "
-			"%ld seconds.\n", t->comm, t->pid, timeout);
-	printk(KERN_ERR "\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
-			" disables this message.\n");
+	pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
+		t->comm, t->pid, timeout);
+	pr_err("      %s %s %.*s\n",
+		print_tainted(), init_utsname()->release,
+		(int)strcspn(init_utsname()->version, " "),
+		init_utsname()->version);
+	pr_err("\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
+		" disables this message.\n");
 	sched_show_task(t);
 	debug_show_held_locks(t);
 
diff --git a/kernel/lglock.c b/kernel/lglock.c
index 6535a66..86ae2ae 100644
--- a/kernel/lglock.c
+++ b/kernel/lglock.c
@@ -21,7 +21,7 @@ void lg_local_lock(struct lglock *lg)
 	arch_spinlock_t *lock;
 
 	preempt_disable();
-	rwlock_acquire_read(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	lock_acquire_shared(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
 	lock = this_cpu_ptr(lg->lock);
 	arch_spin_lock(lock);
 }
@@ -31,7 +31,7 @@ void lg_local_unlock(struct lglock *lg)
 {
 	arch_spinlock_t *lock;
 
-	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
 	lock = this_cpu_ptr(lg->lock);
 	arch_spin_unlock(lock);
 	preempt_enable();
@@ -43,7 +43,7 @@ void lg_local_lock_cpu(struct lglock *lg, int cpu)
 	arch_spinlock_t *lock;
 
 	preempt_disable();
-	rwlock_acquire_read(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	lock_acquire_shared(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
 	lock = per_cpu_ptr(lg->lock, cpu);
 	arch_spin_lock(lock);
 }
@@ -53,7 +53,7 @@ void lg_local_unlock_cpu(struct lglock *lg, int cpu)
 {
 	arch_spinlock_t *lock;
 
-	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
 	lock = per_cpu_ptr(lg->lock, cpu);
 	arch_spin_unlock(lock);
 	preempt_enable();
@@ -65,7 +65,7 @@ void lg_global_lock(struct lglock *lg)
 	int i;
 
 	preempt_disable();
-	rwlock_acquire(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	lock_acquire_exclusive(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
 	for_each_possible_cpu(i) {
 		arch_spinlock_t *lock;
 		lock = per_cpu_ptr(lg->lock, i);
@@ -78,7 +78,7 @@ void lg_global_unlock(struct lglock *lg)
 {
 	int i;
 
-	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock_release(&lg->lock_dep_map, 1, _RET_IP_);
 	for_each_possible_cpu(i) {
 		arch_spinlock_t *lock;
 		lock = per_cpu_ptr(lg->lock, i);
diff --git a/kernel/mutex.c b/kernel/mutex.c
index ff05f4b..98164a5 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -209,11 +209,13 @@ int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
  */
 static inline int mutex_can_spin_on_owner(struct mutex *lock)
 {
+	struct task_struct *owner;
 	int retval = 1;
 
 	rcu_read_lock();
-	if (lock->owner)
-		retval = lock->owner->on_cpu;
+	owner = ACCESS_ONCE(lock->owner);
+	if (owner)
+		retval = owner->on_cpu;
 	rcu_read_unlock();
 	/*
 	 * if lock->owner is not set, the mutex owner may have just acquired
@@ -461,7 +463,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			 * performed the optimistic spinning cannot be done.
 			 */
 			if (ACCESS_ONCE(ww->ctx))
-				break;
+				goto slowpath;
 		}
 
 		/*
@@ -472,7 +474,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		owner = ACCESS_ONCE(lock->owner);
 		if (owner && !mutex_spin_on_owner(lock, owner)) {
 			mspin_unlock(MLOCK(lock), &node);
-			break;
+			goto slowpath;
 		}
 
 		if ((atomic_read(&lock->count) == 1) &&
@@ -499,7 +501,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * the owner complete.
 		 */
 		if (!owner && (need_resched() || rt_task(task)))
-			break;
+			goto slowpath;
 
 		/*
 		 * The cpu_relax() call is a compiler barrier which forces
@@ -513,6 +515,10 @@ slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 
+	/* once more, can we acquire the lock? */
+	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, 0) == 1))
+		goto skip_wait;
+
 	debug_mutex_lock_common(lock, &waiter);
 	debug_mutex_add_waiter(lock, &waiter, task_thread_info(task));
 
@@ -520,9 +526,6 @@ slowpath:
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
 
-	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, -1) == 1))
-		goto done;
-
 	lock_contended(&lock->dep_map, ip);
 
 	for (;;) {
@@ -536,7 +539,7 @@ slowpath:
 		 * other waiters:
 		 */
 		if (MUTEX_SHOW_NO_WAITER(lock) &&
-		   (atomic_xchg(&lock->count, -1) == 1))
+		    (atomic_xchg(&lock->count, -1) == 1))
 			break;
 
 		/*
@@ -561,24 +564,25 @@ slowpath:
 		schedule_preempt_disabled();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
+	mutex_remove_waiter(lock, &waiter, current_thread_info());
+	/* set it to 0 if there are no waiters left: */
+	if (likely(list_empty(&lock->wait_list)))
+		atomic_set(&lock->count, 0);
+	debug_mutex_free_waiter(&waiter);
 
-done:
+skip_wait:
+	/* got the lock - cleanup and rejoice! */
 	lock_acquired(&lock->dep_map, ip);
-	/* got the lock - rejoice! */
-	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
 
 	if (!__builtin_constant_p(ww_ctx == NULL)) {
-		struct ww_mutex *ww = container_of(lock,
-						      struct ww_mutex,
-						      base);
+		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
 		struct mutex_waiter *cur;
 
 		/*
 		 * This branch gets optimized out for the common case,
 		 * and is only important for ww_mutex_lock.
 		 */
-
 		ww_mutex_lock_acquired(ww, ww_ctx);
 		ww->ctx = ww_ctx;
 
@@ -592,15 +596,8 @@ done:
 		}
 	}
 
-	/* set it to 0 if there are no waiters left: */
-	if (likely(list_empty(&lock->wait_list)))
-		atomic_set(&lock->count, 0);
-
 	spin_unlock_mutex(&lock->wait_lock, flags);
-
-	debug_mutex_free_waiter(&waiter);
 	preempt_enable();
-
 	return 0;
 
 err:
diff --git a/kernel/smp.c b/kernel/smp.c
index fe9f773..b1c9034 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -278,8 +278,6 @@ EXPORT_SYMBOL(smp_call_function_single);
  * @wait: If true, wait until function has completed.
  *
  * Returns 0 on success, else a negative status code (if no cpus were online).
- * Note that @wait will be implicitly turned on in case of allocation failures,
- * since we fall back to on-stack allocation.
  *
  * Selection preference:
  *	1) current cpu if in @mask
