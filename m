Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab3LQMqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:46:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41682 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3LQMqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:46:14 -0500
Message-Id: <20131217123353.045465166@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 17 Dec 2013 13:27:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 07/13] rtmutex: Turn the plist into an rb-tree
References: <20131217122720.950475833@infradead.org>
Content-Disposition: inline; filename=0008-rtmutex-Turn-the-plist-into-an-rb-tree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn the pi-chains from plist to rb-tree, in the rt_mutex code,
and provide a proper comparison function for -deadline and
-priority tasks.

This is done mainly because:
 - classical prio field of the plist is just an int, which might
   not be enough for representing a deadline;
 - manipulating such a list would become O(nr_deadline_tasks),
   which might be to much, as the number of -deadline task increases.

Therefore, an rb-tree is used, and tasks are queued in it according
to the following logic:
 - among two -priority (i.e., SCHED_BATCH/OTHER/RR/FIFO) tasks, the
   one with the higher (lower, actually!) prio wins;
 - among a -priority and a -deadline task, the latter always wins;
 - among two -deadline tasks, the one with the earliest deadline
   wins.

Queueing and dequeueing functions are changed accordingly, for both
the list of a task's pi-waiters and the list of tasks blocked on
a pi-lock.

Cc: nicola.manica@disi.unitn.it
Cc: darren@dvhart.com
Cc: oleg@redhat.com
Cc: dhaval.giani@gmail.com
Cc: paulmck@linux.vnet.ibm.com
Cc: fchecconi@gmail.com
Cc: fweisbec@gmail.com
Cc: harald.gustafsson@ericsson.com
Cc: hgu1972@gmail.com
Cc: insop.song@gmail.com
Cc: p.faure@akatech.ch
Cc: jkacur@redhat.com
Cc: rostedt@goodmis.org
Cc: johan.eker@ericsson.com
Cc: tglx@linutronix.de
Cc: liming.wang@windriver.com
Cc: tommaso.cucinotta@sssup.it
Cc: luca.abeni@unitn.it
Cc: vincent.guittot@linaro.org
Cc: michael@amarulasolutions.com
Cc: bruce.ashfield@windriver.com
Cc: mingo@redhat.com
Cc: claudio@evidence.eu.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/init_task.h       |   10 ++
 include/linux/rtmutex.h         |   18 +---
 include/linux/sched.h           |    4 -
 kernel/fork.c                   |    3 
 kernel/futex.c                  |    2 
 kernel/locking/rtmutex-debug.c  |    8 --
 kernel/locking/rtmutex.c        |  151 ++++++++++++++++++++++++++++++++--------
 kernel/locking/rtmutex_common.h |   22 ++---
 kernel/sched/core.c             |    4 -
 9 files changed, 157 insertions(+), 65 deletions(-)

--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -11,6 +11,7 @@
 #include <linux/user_namespace.h>
 #include <linux/securebits.h>
 #include <linux/seqlock.h>
+#include <linux/rbtree.h>
 #include <net/net_namespace.h>
 #include <linux/sched/rt.h>
 
@@ -154,6 +155,14 @@ extern struct task_group root_task_group
 
 #define INIT_TASK_COMM "swapper"
 
+#ifdef CONFIG_RT_MUTEXES
+# define INIT_RT_MUTEXES(tsk)						\
+	.pi_waiters = RB_ROOT,						\
+	.pi_waiters_leftmost = NULL,
+#else
+# define INIT_RT_MUTEXES(tsk)
+#endif
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -221,6 +230,7 @@ extern struct task_group root_task_group
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
 	INIT_CPUSET_SEQ(tsk)						\
+	INIT_RT_MUTEXES(tsk)						\
 	INIT_VTIME(tsk)							\
 }
 
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -13,7 +13,7 @@
 #define __LINUX_RT_MUTEX_H
 
 #include <linux/linkage.h>
-#include <linux/plist.h>
+#include <linux/rbtree.h>
 #include <linux/spinlock_types.h>
 
 extern int max_lock_depth; /* for sysctl */
@@ -22,12 +22,14 @@ extern int max_lock_depth; /* for sysctl
  * The rt_mutex structure
  *
  * @wait_lock:	spinlock to protect the structure
- * @wait_list:	pilist head to enqueue waiters in priority order
+ * @waiters:	rbtree root to enqueue waiters in priority order
+ * @waiters_leftmost: top waiter
  * @owner:	the mutex owner
  */
 struct rt_mutex {
 	raw_spinlock_t		wait_lock;
-	struct plist_head	wait_list;
+	struct rb_root          waiters;
+	struct rb_node          *waiters_leftmost;
 	struct task_struct	*owner;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 	int			save_state;
@@ -66,7 +68,7 @@ struct hrtimer_sleeper;
 
 #define __RT_MUTEX_INITIALIZER(mutexname) \
 	{ .wait_lock = __RAW_SPIN_LOCK_UNLOCKED(mutexname.wait_lock) \
-	, .wait_list = PLIST_HEAD_INIT(mutexname.wait_list) \
+	, .waiters = RB_ROOT \
 	, .owner = NULL \
 	__DEBUG_RT_MUTEX_INITIALIZER(mutexname)}
 
@@ -98,12 +100,4 @@ extern int rt_mutex_trylock(struct rt_mu
 
 extern void rt_mutex_unlock(struct rt_mutex *lock);
 
-#ifdef CONFIG_RT_MUTEXES
-# define INIT_RT_MUTEXES(tsk)						\
-	.pi_waiters	= PLIST_HEAD_INIT(tsk.pi_waiters),	\
-	INIT_RT_MUTEX_DEBUG(tsk)
-#else
-# define INIT_RT_MUTEXES(tsk)
-#endif
-
 #endif
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -16,6 +16,7 @@ struct sched_param {
 #include <linux/types.h>
 #include <linux/timex.h>
 #include <linux/jiffies.h>
+#include <linux/plist.h>
 #include <linux/rbtree.h>
 #include <linux/thread_info.h>
 #include <linux/cpumask.h>
@@ -1346,7 +1347,8 @@ struct task_struct {
 
 #ifdef CONFIG_RT_MUTEXES
 	/* PI waiters blocked on a rt_mutex held by this task */
-	struct plist_head pi_waiters;
+	struct rb_root pi_waiters;
+	struct rb_node *pi_waiters_leftmost;
 	/* Deadlock detection and priority inheritance handling */
 	struct rt_mutex_waiter *pi_blocked_on;
 #endif
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1086,7 +1086,8 @@ static void rt_mutex_init_task(struct ta
 {
 	raw_spin_lock_init(&p->pi_lock);
 #ifdef CONFIG_RT_MUTEXES
-	plist_head_init(&p->pi_waiters);
+	p->pi_waiters = RB_ROOT;
+	p->pi_waiters_leftmost = NULL;
 	p->pi_blocked_on = NULL;
 #endif
 }
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2315,6 +2315,8 @@ static int futex_wait_requeue_pi(u32 __u
 	 * code while we sleep on uaddr.
 	 */
 	debug_rt_mutex_init_waiter(&rt_waiter);
+	RB_CLEAR_NODE(&rt_waiter.pi_tree_entry);
+	RB_CLEAR_NODE(&rt_waiter.tree_entry);
 	rt_waiter.task = NULL;
 
 	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
--- a/kernel/locking/rtmutex-debug.c
+++ b/kernel/locking/rtmutex-debug.c
@@ -24,7 +24,7 @@
 #include <linux/kallsyms.h>
 #include <linux/syscalls.h>
 #include <linux/interrupt.h>
-#include <linux/plist.h>
+#include <linux/rbtree.h>
 #include <linux/fs.h>
 #include <linux/debug_locks.h>
 
@@ -57,7 +57,7 @@ static void printk_lock(struct rt_mutex
 
 void rt_mutex_debug_task_free(struct task_struct *task)
 {
-	DEBUG_LOCKS_WARN_ON(!plist_head_empty(&task->pi_waiters));
+	DEBUG_LOCKS_WARN_ON(!RB_EMPTY_ROOT(&task->pi_waiters));
 	DEBUG_LOCKS_WARN_ON(task->pi_blocked_on);
 }
 
@@ -154,16 +154,12 @@ void debug_rt_mutex_proxy_unlock(struct
 void debug_rt_mutex_init_waiter(struct rt_mutex_waiter *waiter)
 {
 	memset(waiter, 0x11, sizeof(*waiter));
-	plist_node_init(&waiter->list_entry, MAX_PRIO);
-	plist_node_init(&waiter->pi_list_entry, MAX_PRIO);
 	waiter->deadlock_task_pid = NULL;
 }
 
 void debug_rt_mutex_free_waiter(struct rt_mutex_waiter *waiter)
 {
 	put_pid(waiter->deadlock_task_pid);
-	DEBUG_LOCKS_WARN_ON(!plist_node_empty(&waiter->list_entry));
-	DEBUG_LOCKS_WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
 	memset(waiter, 0x22, sizeof(*waiter));
 }
 
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -14,6 +14,7 @@
 #include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/deadline.h>
 #include <linux/timer.h>
 
 #include "rtmutex_common.h"
@@ -91,10 +92,104 @@ static inline void mark_rt_mutex_waiters
 }
 #endif
 
+static inline int
+rt_mutex_waiter_less(struct rt_mutex_waiter *left,
+		     struct rt_mutex_waiter *right)
+{
+	if (left->task->prio < right->task->prio)
+		return 1;
+
+	/*
+	 * If both tasks are dl_task(), we check their deadlines.
+	 */
+	if (dl_prio(left->task->prio) && dl_prio(right->task->prio))
+		return (left->task->dl.deadline < right->task->dl.deadline);
+
+	return 0;
+}
+
+static void
+rt_mutex_enqueue(struct rt_mutex *lock, struct rt_mutex_waiter *waiter)
+{
+	struct rb_node **link = &lock->waiters.rb_node;
+	struct rb_node *parent = NULL;
+	struct rt_mutex_waiter *entry;
+	int leftmost = 1;
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct rt_mutex_waiter, tree_entry);
+		if (rt_mutex_waiter_less(waiter, entry)) {
+			link = &parent->rb_left;
+		} else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	if (leftmost)
+		lock->waiters_leftmost = &waiter->tree_entry;
+
+	rb_link_node(&waiter->tree_entry, parent, link);
+	rb_insert_color(&waiter->tree_entry, &lock->waiters);
+}
+
+static void
+rt_mutex_dequeue(struct rt_mutex *lock, struct rt_mutex_waiter *waiter)
+{
+	if (RB_EMPTY_NODE(&waiter->tree_entry))
+		return;
+
+	if (lock->waiters_leftmost == &waiter->tree_entry)
+		lock->waiters_leftmost = rb_next(&waiter->tree_entry);
+
+	rb_erase(&waiter->tree_entry, &lock->waiters);
+	RB_CLEAR_NODE(&waiter->tree_entry);
+}
+
+static void
+rt_mutex_enqueue_pi(struct task_struct *task, struct rt_mutex_waiter *waiter)
+{
+	struct rb_node **link = &task->pi_waiters.rb_node;
+	struct rb_node *parent = NULL;
+	struct rt_mutex_waiter *entry;
+	int leftmost = 1;
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct rt_mutex_waiter, pi_tree_entry);
+		if (rt_mutex_waiter_less(waiter, entry)) {
+			link = &parent->rb_left;
+		} else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	if (leftmost)
+		task->pi_waiters_leftmost = &waiter->pi_tree_entry;
+
+	rb_link_node(&waiter->pi_tree_entry, parent, link);
+	rb_insert_color(&waiter->pi_tree_entry, &task->pi_waiters);
+}
+
+static void
+rt_mutex_dequeue_pi(struct task_struct *task, struct rt_mutex_waiter *waiter)
+{
+	if (RB_EMPTY_NODE(&waiter->pi_tree_entry))
+		return;
+
+	if (task->pi_waiters_leftmost == &waiter->pi_tree_entry)
+		task->pi_waiters_leftmost = rb_next(&waiter->pi_tree_entry);
+
+	rb_erase(&waiter->pi_tree_entry, &task->pi_waiters);
+	RB_CLEAR_NODE(&waiter->pi_tree_entry);
+}
+
 /*
- * Calculate task priority from the waiter list priority
+ * Calculate task priority from the waiter tree priority
  *
- * Return task->normal_prio when the waiter list is empty or when
+ * Return task->normal_prio when the waiter tree is empty or when
  * the waiter is not allowed to do priority boosting
  */
 int rt_mutex_getprio(struct task_struct *task)
@@ -102,7 +197,7 @@ int rt_mutex_getprio(struct task_struct
 	if (likely(!task_has_pi_waiters(task)))
 		return task->normal_prio;
 
-	return min(task_top_pi_waiter(task)->pi_list_entry.prio,
+	return min(task_top_pi_waiter(task)->task->prio,
 		   task->normal_prio);
 }
 
@@ -233,7 +328,7 @@ static int rt_mutex_adjust_prio_chain(st
 	 * When deadlock detection is off then we check, if further
 	 * priority adjustment is necessary.
 	 */
-	if (!detect_deadlock && waiter->list_entry.prio == task->prio)
+	if (!detect_deadlock && waiter->task->prio == task->prio)
 		goto out_unlock_pi;
 
 	lock = waiter->lock;
@@ -254,9 +349,9 @@ static int rt_mutex_adjust_prio_chain(st
 	top_waiter = rt_mutex_top_waiter(lock);
 
 	/* Requeue the waiter */
-	plist_del(&waiter->list_entry, &lock->wait_list);
-	waiter->list_entry.prio = task->prio;
-	plist_add(&waiter->list_entry, &lock->wait_list);
+	rt_mutex_dequeue(lock, waiter);
+	waiter->task->prio = task->prio;
+	rt_mutex_enqueue(lock, waiter);
 
 	/* Release the task */
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
@@ -280,17 +375,15 @@ static int rt_mutex_adjust_prio_chain(st
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		/* Boost the owner */
-		plist_del(&top_waiter->pi_list_entry, &task->pi_waiters);
-		waiter->pi_list_entry.prio = waiter->list_entry.prio;
-		plist_add(&waiter->pi_list_entry, &task->pi_waiters);
+		rt_mutex_dequeue_pi(task, top_waiter);
+		rt_mutex_enqueue_pi(task, waiter);
 		__rt_mutex_adjust_prio(task);
 
 	} else if (top_waiter == waiter) {
 		/* Deboost the owner */
-		plist_del(&waiter->pi_list_entry, &task->pi_waiters);
+		rt_mutex_dequeue_pi(task, waiter);
 		waiter = rt_mutex_top_waiter(lock);
-		waiter->pi_list_entry.prio = waiter->list_entry.prio;
-		plist_add(&waiter->pi_list_entry, &task->pi_waiters);
+		rt_mutex_enqueue_pi(task, waiter);
 		__rt_mutex_adjust_prio(task);
 	}
 
@@ -355,7 +448,7 @@ static int try_to_take_rt_mutex(struct r
 	 * 3) it is top waiter
 	 */
 	if (rt_mutex_has_waiters(lock)) {
-		if (task->prio >= rt_mutex_top_waiter(lock)->list_entry.prio) {
+		if (task->prio >= rt_mutex_top_waiter(lock)->task->prio) {
 			if (!waiter || waiter != rt_mutex_top_waiter(lock))
 				return 0;
 		}
@@ -369,7 +462,7 @@ static int try_to_take_rt_mutex(struct r
 
 		/* remove the queued waiter. */
 		if (waiter) {
-			plist_del(&waiter->list_entry, &lock->wait_list);
+			rt_mutex_dequeue(lock, waiter);
 			task->pi_blocked_on = NULL;
 		}
 
@@ -379,8 +472,7 @@ static int try_to_take_rt_mutex(struct r
 		 */
 		if (rt_mutex_has_waiters(lock)) {
 			top = rt_mutex_top_waiter(lock);
-			top->pi_list_entry.prio = top->list_entry.prio;
-			plist_add(&top->pi_list_entry, &task->pi_waiters);
+			rt_mutex_enqueue_pi(task, top);
 		}
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 	}
@@ -416,13 +508,11 @@ static int task_blocks_on_rt_mutex(struc
 	__rt_mutex_adjust_prio(task);
 	waiter->task = task;
 	waiter->lock = lock;
-	plist_node_init(&waiter->list_entry, task->prio);
-	plist_node_init(&waiter->pi_list_entry, task->prio);
 
 	/* Get the top priority waiter on the lock */
 	if (rt_mutex_has_waiters(lock))
 		top_waiter = rt_mutex_top_waiter(lock);
-	plist_add(&waiter->list_entry, &lock->wait_list);
+	rt_mutex_enqueue(lock, waiter);
 
 	task->pi_blocked_on = waiter;
 
@@ -433,8 +523,8 @@ static int task_blocks_on_rt_mutex(struc
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		raw_spin_lock_irqsave(&owner->pi_lock, flags);
-		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
-		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
+		rt_mutex_dequeue_pi(owner, top_waiter);
+		rt_mutex_enqueue_pi(owner, waiter);
 
 		__rt_mutex_adjust_prio(owner);
 		if (owner->pi_blocked_on)
@@ -486,7 +576,7 @@ static void wakeup_next_waiter(struct rt
 	 * boosted mode and go back to normal after releasing
 	 * lock->wait_lock.
 	 */
-	plist_del(&waiter->pi_list_entry, &current->pi_waiters);
+	rt_mutex_dequeue_pi(current, waiter);
 
 	rt_mutex_set_owner(lock, NULL);
 
@@ -510,7 +600,7 @@ static void remove_waiter(struct rt_mute
 	int chain_walk = 0;
 
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
-	plist_del(&waiter->list_entry, &lock->wait_list);
+	rt_mutex_dequeue(lock, waiter);
 	current->pi_blocked_on = NULL;
 	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
@@ -521,13 +611,13 @@ static void remove_waiter(struct rt_mute
 
 		raw_spin_lock_irqsave(&owner->pi_lock, flags);
 
-		plist_del(&waiter->pi_list_entry, &owner->pi_waiters);
+		rt_mutex_dequeue_pi(owner, waiter);
 
 		if (rt_mutex_has_waiters(lock)) {
 			struct rt_mutex_waiter *next;
 
 			next = rt_mutex_top_waiter(lock);
-			plist_add(&next->pi_list_entry, &owner->pi_waiters);
+			rt_mutex_enqueue_pi(owner, next);
 		}
 		__rt_mutex_adjust_prio(owner);
 
@@ -537,8 +627,6 @@ static void remove_waiter(struct rt_mute
 		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	}
 
-	WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
-
 	if (!chain_walk)
 		return;
 
@@ -565,7 +653,7 @@ void rt_mutex_adjust_pi(struct task_stru
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	waiter = task->pi_blocked_on;
-	if (!waiter || waiter->list_entry.prio == task->prio) {
+	if (!waiter || waiter->task->prio == task->prio) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		return;
 	}
@@ -638,6 +726,8 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 	int ret = 0;
 
 	debug_rt_mutex_init_waiter(&waiter);
+	RB_CLEAR_NODE(&waiter.pi_tree_entry);
+	RB_CLEAR_NODE(&waiter.tree_entry);
 
 	raw_spin_lock(&lock->wait_lock);
 
@@ -904,7 +994,8 @@ void __rt_mutex_init(struct rt_mutex *lo
 {
 	lock->owner = NULL;
 	raw_spin_lock_init(&lock->wait_lock);
-	plist_head_init(&lock->wait_list);
+	lock->waiters = RB_ROOT;
+	lock->waiters_leftmost = NULL;
 
 	debug_rt_mutex_init(lock, name);
 }
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -40,13 +40,13 @@ extern void schedule_rt_mutex_test(struc
  * This is the control structure for tasks blocked on a rt_mutex,
  * which is allocated on the kernel stack on of the blocked task.
  *
- * @list_entry:		pi node to enqueue into the mutex waiters list
- * @pi_list_entry:	pi node to enqueue into the mutex owner waiters list
+ * @tree_entry:		pi node to enqueue into the mutex waiters tree
+ * @pi_tree_entry:	pi node to enqueue into the mutex owner waiters tree
  * @task:		task reference to the blocked task
  */
 struct rt_mutex_waiter {
-	struct plist_node	list_entry;
-	struct plist_node	pi_list_entry;
+	struct rb_node          tree_entry;
+	struct rb_node          pi_tree_entry;
 	struct task_struct	*task;
 	struct rt_mutex		*lock;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
@@ -57,11 +57,11 @@ struct rt_mutex_waiter {
 };
 
 /*
- * Various helpers to access the waiters-plist:
+ * Various helpers to access the waiters-tree:
  */
 static inline int rt_mutex_has_waiters(struct rt_mutex *lock)
 {
-	return !plist_head_empty(&lock->wait_list);
+	return !RB_EMPTY_ROOT(&lock->waiters);
 }
 
 static inline struct rt_mutex_waiter *
@@ -69,8 +69,8 @@ rt_mutex_top_waiter(struct rt_mutex *loc
 {
 	struct rt_mutex_waiter *w;
 
-	w = plist_first_entry(&lock->wait_list, struct rt_mutex_waiter,
-			       list_entry);
+	w = rb_entry(lock->waiters_leftmost, struct rt_mutex_waiter,
+		     tree_entry);
 	BUG_ON(w->lock != lock);
 
 	return w;
@@ -78,14 +78,14 @@ rt_mutex_top_waiter(struct rt_mutex *loc
 
 static inline int task_has_pi_waiters(struct task_struct *p)
 {
-	return !plist_head_empty(&p->pi_waiters);
+	return !RB_EMPTY_ROOT(&p->pi_waiters);
 }
 
 static inline struct rt_mutex_waiter *
 task_top_pi_waiter(struct task_struct *p)
 {
-	return plist_first_entry(&p->pi_waiters, struct rt_mutex_waiter,
-				  pi_list_entry);
+	return rb_entry(p->pi_waiters_leftmost, struct rt_mutex_waiter,
+			pi_tree_entry);
 }
 
 /*
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6625,10 +6625,6 @@ void __init sched_init(void)
 	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
 #endif
 
-#ifdef CONFIG_RT_MUTEXES
-	plist_head_init(&init_task.pi_waiters);
-#endif
-
 	/*
 	 * The boot idle thread does lazy MMU switching as well:
 	 */


