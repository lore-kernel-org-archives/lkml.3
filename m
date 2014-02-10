Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaBJUld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:41:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35702 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaBJUl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:41:28 -0500
Message-Id: <20140210203659.671232531@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Feb 2014 20:58:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Jason Low <jason.low2@hp.com>, Waiman Long <waiman.long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: [PATCH 5/8] locking, mutex: Cancelable MCS lock for adaptive spinning
References: <20140210195820.834693028@infradead.org>
Content-Disposition: inline; filename=peter_zijlstra-_patch_v2_5_5__mutex-give_spinners_a_chance_to.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we want a task waiting for a mutex_lock() to go to sleep and
reschedule on need_resched() we must be able to abort the
mcs_spin_lock() around the adaptive spin.

Therefore implement a cancelable mcs lock.

Cc: riel@redhat.com
Cc: akpm@linux-foundation.org
Cc: davidlohr@hp.com
Cc: hpa@zytor.com
Cc: andi@firstfloor.org
Cc: aswin@hp.com
Cc: scott.norton@hp.com
Cc: Jason Low <jason.low2@hp.com>
Cc: chegu_vinod@hp.com
Cc: mingo@kernel.org
Cc: paulmck@linux.vnet.ibm.com
Cc: Waiman.Long@hp.com
Cc: torvalds@linux-foundation.org
Cc: tglx@linutronix.de
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/mutex.h         |    4 -
 kernel/locking/Makefile       |    2 
 kernel/locking/mcs_spinlock.c |  167 ++++++++++++++++++++++++++++++++++++++++++
 kernel/locking/mcs_spinlock.h |   15 +++
 kernel/locking/mutex.c        |   10 +-
 5 files changed, 191 insertions(+), 7 deletions(-)

--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -46,7 +46,7 @@
  * - detects multi-task circular deadlocks and prints out all affected
  *   locks and tasks (and only those tasks)
  */
-struct mcs_spinlock;
+struct optimistic_spin_queue;
 struct mutex {
 	/* 1: unlocked, 0: locked, negative: locked, possible waiters */
 	atomic_t		count;
@@ -56,7 +56,7 @@ struct mutex {
 	struct task_struct	*owner;
 #endif
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	struct mcs_spinlock	*mcs_lock;	/* Spinner MCS lock */
+	struct optimistic_spin_queue	*osq;	/* Spinner MCS lock */
 #endif
 #ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -1,5 +1,5 @@
 
-obj-y += mutex.o semaphore.o rwsem.o lglock.o
+obj-y += mutex.o semaphore.o rwsem.o lglock.o mcs_spinlock.o
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = -pg
--- /dev/null
+++ b/kernel/locking/mcs_spinlock.c
@@ -0,0 +1,167 @@
+
+#include <linux/percpu.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include "mcs_spinlock.h"
+
+#ifdef CONFIG_SMP
+
+/*
+ * An MCS like lock especially tailored for optimistic spinning for sleeping
+ * lock implementations (mutex, rwsem, etc).
+ *
+ * Using a single mcs node per CPU is safe because sleeping locks should not be
+ * called from interrupt context and we have preemption disabled while
+ * spinning.
+ */
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct optimistic_spin_queue, osq_node);
+
+/*
+ * Get a stable @node->next pointer, either for unlock() or unqueue() purposes.
+ * Can return NULL in case we were the last queued and we updated @lock instead.
+ */
+static inline struct optimistic_spin_queue *
+osq_wait_next(struct optimistic_spin_queue **lock,
+	      struct optimistic_spin_queue *node,
+	      struct optimistic_spin_queue *prev)
+{
+	struct optimistic_spin_queue *next = NULL;
+
+	for (;;) {
+		if (*lock == node && cmpxchg(lock, node, prev) == node) {
+			/*
+			 * We were the last queued, we moved @lock back. @prev
+			 * will now observe @lock and will complete its
+			 * unlock()/unqueue().
+			 */
+			break;
+		}
+
+		/*
+		 * We must xchg() the @node->next value, because if we were to
+		 * leave it in, a concurrent unlock()/unqueue() from
+		 * @node->next might complete Step-A and think its @prev is
+		 * still valid.
+		 *
+		 * If the concurrent unlock()/unqueue() wins the race, we'll
+		 * wait for either @lock to point to us, through its Step-B, or
+		 * wait for a new @node->next from its Step-C.
+		 */
+		if (node->next) {
+			next = xchg(&node->next, NULL);
+			if (next)
+				break;
+		}
+
+		arch_mutex_cpu_relax();
+	}
+
+	return next;
+}
+
+bool osq_lock(struct optimistic_spin_queue **lock)
+{
+	struct optimistic_spin_queue *node = this_cpu_ptr(&osq_node);
+	struct optimistic_spin_queue *prev, *next;
+
+	node->locked = 0;
+	node->next = NULL;
+
+	node->prev = prev = xchg(lock, node);
+	if (likely(prev == NULL))
+		return true;
+
+	ACCESS_ONCE(prev->next) = node;
+
+	/*
+	 * Normally @prev is untouchable after the above store; because at that
+	 * moment unlock can proceed and wipe the node element from stack.
+	 *
+	 * However, since our nodes are static per-cpu storage, we're
+	 * guaranteed their existence -- this allows us to apply
+	 * cmpxchg in an attempt to undo our queueing.
+	 */
+
+	while (!smp_load_acquire(&node->locked)) {
+		/*
+		 * If we need to reschedule bail... so we can block.
+		 */
+		if (need_resched())
+			goto unqueue;
+
+		arch_mutex_cpu_relax();
+	}
+	return true;
+
+unqueue:
+	/*
+	 * Step - A  -- stabilize @prev
+	 *
+	 * Undo our @prev->next assignment; this will make @prev's
+	 * unlock()/unqueue() wait for a next pointer since @lock points to us
+	 * (or later).
+	 */
+
+	for (;;) {
+		if (prev->next == node &&
+		    cmpxchg(&prev->next, node, NULL) == node)
+			break;
+
+		/*
+		 * We can only fail the cmpxchg() racing against an unlock(),
+		 * in which case we should observe @node->locked becomming
+		 * true.
+		 */
+		if (smp_load_acquire(&node->locked))
+			return true;
+
+		/*
+		 * Or we race against a concurrent unqueue()'s step-B, in which
+		 * case its step-C will write us a new @node->prev pointer.
+		 */
+		prev = ACCESS_ONCE(node->prev);
+	}
+
+	/*
+	 * Step - B -- stabilize @next
+	 *
+	 * Similar to unlock(), wait for @node->next or move @lock from @node
+	 * back to @prev.
+	 */
+
+	next = osq_wait_next(lock, node, prev);
+	if (!next)
+		return false;
+
+	/*
+	 * Step - C -- unlink
+	 *
+	 * @prev is stable because its still waiting for a new @prev->next
+	 * pointer, @next is stable because our @node->next pointer is NULL and
+	 * it will wait in Step-A.
+	 */
+
+	ACCESS_ONCE(next->prev) = prev;
+	ACCESS_ONCE(prev->next) = next;
+
+	return false;
+}
+
+void osq_unlock(struct optimistic_spin_queue **lock)
+{
+	struct optimistic_spin_queue *node = this_cpu_ptr(&osq_node);
+	struct optimistic_spin_queue *next;
+
+	/*
+	 * Fast path for the uncontended case.
+	 */
+	if (likely(cmpxchg(lock, node, NULL) == node))
+		return;
+
+	next = osq_wait_next(lock, node, NULL);
+	if (next)
+		ACCESS_ONCE(next->locked) = 1;
+}
+
+#endif
+
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -111,4 +111,19 @@ void mcs_spin_unlock(struct mcs_spinlock
 	arch_mcs_spin_unlock_contended(&next->locked);
 }
 
+/*
+ * Cancellable version of the MCS lock above.
+ *
+ * Intended for adaptive spinning of sleeping locks:
+ * mutex_lock()/rwsem_down_{read,write}() etc.
+ */
+
+struct optimistic_spin_queue {
+	struct optimistic_spin_queue *next, *prev;
+	int locked; /* 1 if lock acquired */
+};
+
+extern bool osq_lock(struct optimistic_spin_queue **lock);
+extern void osq_unlock(struct optimistic_spin_queue **lock);
+
 #endif /* __LINUX_MCS_SPINLOCK_H */
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -53,7 +53,7 @@ __mutex_init(struct mutex *lock, const c
 	INIT_LIST_HEAD(&lock->wait_list);
 	mutex_clear_owner(lock);
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	lock->mcs_lock = NULL;
+	lock->osq = NULL;
 #endif
 
 	debug_mutex_init(lock, name, key);
@@ -403,7 +403,9 @@ __mutex_lock_common(struct mutex *lock,
 	if (!mutex_can_spin_on_owner(lock))
 		goto slowpath;
 
-	mcs_spin_lock(&lock->mcs_lock);
+	if (!osq_lock(&lock->osq))
+		goto slowpath;
+
 	for (;;) {
 		struct task_struct *owner;
 
@@ -442,7 +444,7 @@ __mutex_lock_common(struct mutex *lock,
 			}
 
 			mutex_set_owner(lock);
-			mcs_spin_unlock(&lock->mcs_lock);
+			osq_unlock(&lock->osq);
 			preempt_enable();
 			return 0;
 		}
@@ -464,7 +466,7 @@ __mutex_lock_common(struct mutex *lock,
 		 */
 		arch_mutex_cpu_relax();
 	}
-	mcs_spin_unlock(&lock->mcs_lock);
+	osq_unlock(&lock->osq);
 slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);


