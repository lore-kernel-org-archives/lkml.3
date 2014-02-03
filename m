Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaBCTZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:25:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54187 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaBCTZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:25:50 -0500
Date: Mon, 3 Feb 2014 20:25:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, chegu_vinod@hp.com
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
Message-ID: <20140203192525.GN8874@twins.programming.kicks-ass.net>
References: <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
 <1390949495.2807.52.camel@j-VirtualBox>
 <20140129115142.GE9636@twins.programming.kicks-ass.net>
 <1391138977.6284.82.camel@j-VirtualBox>
 <20140131140941.GF4941@twins.programming.kicks-ass.net>
 <CAGQ1y=72+N4=yjVpjsTKjr-8xSQRS2xw4gcOGOipLgwPwgnA7A@mail.gmail.com>
 <20140131200825.GS5002@laptop.programming.kicks-ass.net>
 <1391374883.3164.8.camel@j-VirtualBox>
 <20140202211230.GX5002@laptop.programming.kicks-ass.net>
 <1391452760.7498.26.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391452760.7498.26.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 10:39:20AM -0800, Jason Low wrote:
> > To avoid the xchg on every loop.
> 
> Ah yes, we want to use xchg() on &node->next.
> 
> Since the cmpxchg() is now in a loop in the unlock function, an
> additional (*lock == node) check before the cmpxchg() would also be nice
> to avoid spinning on cmpxchg() there too.

Right, I have the below; you can find the patches this depends upon
here:

  http://programming.kicks-ass.net/sekrit/patches.tar.bz2

---
Subject: locking, mutex: Cancelable MCS lock for adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 29 Jan 2014 12:51:42 +0100

Since we want a task waiting for a mutex_lock() to go to sleep and
reschedule on need_resched() we must be able to abort the
mcs_spin_lock() around the adaptive spin.

Therefore implement a cancelable mcs lock.

XXX: anybody got a better name than m_spinlock?

Cc: paulmck@linux.vnet.ibm.com
Cc: Waiman.Long@hp.com
Cc: torvalds@linux-foundation.org
Cc: tglx@linutronix.de
Cc: riel@redhat.com
Cc: akpm@linux-foundation.org
Cc: davidlohr@hp.com
Cc: hpa@zytor.com
Cc: andi@firstfloor.org
Cc: aswin@hp.com
Cc: scott.norton@hp.com
Cc: chegu_vinod@hp.com
Cc: mingo@redhat.com
Cc: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-7jr68p4f447w2e0ck7y1yl06@git.kernel.org
---
 include/linux/mutex.h         |    4 -
 kernel/locking/Makefile       |    2 
 kernel/locking/mcs_spinlock.c |  156 ++++++++++++++++++++++++++++++++++++++++++
 kernel/locking/mcs_spinlock.h |   18 ++++
 kernel/locking/mutex.c        |   10 +-
 5 files changed, 183 insertions(+), 7 deletions(-)

--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -46,7 +46,7 @@
  * - detects multi-task circular deadlocks and prints out all affected
  *   locks and tasks (and only those tasks)
  */
-struct mcs_spinlock;
+struct m_spinlock;
 struct mutex {
 	/* 1: unlocked, 0: locked, negative: locked, possible waiters */
 	atomic_t		count;
@@ -56,7 +56,7 @@ struct mutex {
 	struct task_struct	*owner;
 #endif
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	struct mcs_spinlock	*mcs_lock;	/* Spinner MCS lock */
+	struct m_spinlock	*m_lock;	/* Spinner MCS lock */
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
@@ -0,0 +1,156 @@
+
+#include <linux/percpu.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include "mcs_spinlock.h"
+
+#ifdef CONFIG_SMP
+
+/*
+ * Using a single mcs node per CPU is safe because mutex_lock() should not be
+ * called from interrupt context and we have preemption disabled over the mcs
+ * lock usage.
+ */
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct m_spinlock, m_node);
+
+/*
+ * Get a stable @node->next pointer, either for unlock() or unqueue() purposes.
+ * Can return NULL in case we were the last queued and we updated @lock instead.
+ */
+static inline struct m_spinlock *
+m_spin_wait_next(struct m_spinlock **lock, struct m_spinlock *node,
+		 struct m_spinlock *prev)
+{
+	struct m_spinlock *next = NULL;
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
+bool m_spin_lock(struct m_spinlock **lock)
+{
+	struct m_spinlock *node = this_cpu_ptr(&m_node);
+	struct m_spinlock *prev, *next;
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
+		if (need_resched())
+			goto unqueue;
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
+	next = m_spin_wait_next(lock, node, prev);
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
+void m_spin_unlock(struct m_spinlock **lock)
+{
+	struct m_spinlock *node = this_cpu_ptr(&m_node);
+	struct m_spinlock *next;
+
+	if (likely(cmpxchg(lock, node, NULL) == node))
+		return;
+
+	next = m_spin_wait_next(lock, node, NULL);
+	if (next)
+		ACCESS_ONCE(next->locked) = 1;
+}
+
+#endif
+
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -109,4 +109,22 @@ void mcs_spin_unlock(struct mcs_spinlock
 	arch_mcs_spin_unlock_contended(&next->locked);
 }
 
+/*
+ * Cancellable version of the MCS lock above.
+ *
+ * This version can fail acquisition and unqueue a spinner; it assumes no
+ * nesting.
+ *
+ * Intended for adaptive spinning of sleeping locks:
+ * mutex_lock()/rwsem_down_{read,write}() etc.
+ */
+
+struct m_spinlock {
+	struct m_spinlock *next, *prev;
+	int locked; /* 1 if lock acquired */
+};
+
+extern bool m_spin_lock(struct m_spinlock **lock);
+extern void m_spin_unlock(struct m_spinlock **lock);
+
 #endif /* __LINUX_MCS_SPINLOCK_H */
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -53,7 +53,7 @@ __mutex_init(struct mutex *lock, const c
 	INIT_LIST_HEAD(&lock->wait_list);
 	mutex_clear_owner(lock);
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	lock->mcs_lock = NULL;
+	lock->m_lock = NULL;
 #endif
 
 	debug_mutex_init(lock, name, key);
@@ -403,7 +403,9 @@ __mutex_lock_common(struct mutex *lock,
 	if (!mutex_can_spin_on_owner(lock))
 		goto slowpath;
 
-	mcs_spin_lock(&lock->mcs_lock);
+	if (!m_spin_lock(&lock->m_lock))
+		goto slowpath;
+
 	for (;;) {
 		struct task_struct *owner;
 
@@ -442,7 +444,7 @@ __mutex_lock_common(struct mutex *lock,
 			}
 
 			mutex_set_owner(lock);
-			mcs_spin_unlock(&lock->mcs_lock);
+			m_spin_unlock(&lock->m_lock);
 			preempt_enable();
 			return 0;
 		}
@@ -464,7 +466,7 @@ __mutex_lock_common(struct mutex *lock,
 		 */
 		arch_mutex_cpu_relax();
 	}
-	mcs_spin_unlock(&lock->mcs_lock);
+	m_spin_unlock(&lock->m_lock);
 slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
