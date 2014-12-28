Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaL1JM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 04:12:56 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:36151 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaL1JMZ (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Sun, 28 Dec 2014 04:12:25 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 6/8] locking/mcs: Better differentiate between mcs variants
Date: Sun, 28 Dec 2014 01:11:21 -0800
Message-Id: <1419757883-4423-7-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
References: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have two flavors of the MCS spinlock: standard and cancelable (osq).
While each one is independent of the other, we currently mix and match
them. This patch:

o Moves osq code out of mcs_spinlock.h (which only deals with the traditional
version) into include/linux/osq_lock.h. No unnecessary code is added to the
more global header file, anything locks that make use of osq must include
it anyway.

o Renames mcs_spinlock.c to osq_lock.c. This file only contains osq code.

o Introduces a CONFIG_LOCK_SPIN_ON_OWNER in order to only build osq_lock
if there is support for it.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 include/linux/osq_lock.h      |  12 ++-
 kernel/Kconfig.locks          |   4 +
 kernel/locking/Makefile       |   3 +-
 kernel/locking/mcs_spinlock.c | 208 ------------------------------------------
 kernel/locking/mcs_spinlock.h |  16 ----
 kernel/locking/osq_lock.c     | 203 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 219 insertions(+), 227 deletions(-)
 delete mode 100644 kernel/locking/mcs_spinlock.c
 create mode 100644 kernel/locking/osq_lock.c

diff --git a/include/linux/osq_lock.h b/include/linux/osq_lock.h
index 90230d5..3a6490e 100644
--- a/include/linux/osq_lock.h
+++ b/include/linux/osq_lock.h
@@ -5,8 +5,11 @@
  * An MCS like lock especially tailored for optimistic spinning for sleeping
  * lock implementations (mutex, rwsem, etc).
  */
-
-#define OSQ_UNLOCKED_VAL (0)
+struct optimistic_spin_node {
+	struct optimistic_spin_node *next, *prev;
+	int locked; /* 1 if lock acquired */
+	int cpu; /* encoded CPU # + 1 value */
+};
 
 struct optimistic_spin_queue {
 	/*
@@ -16,6 +19,8 @@ struct optimistic_spin_queue {
 	atomic_t tail;
 };
 
+#define OSQ_UNLOCKED_VAL (0)
+
 /* Init macro and function. */
 #define OSQ_LOCK_UNLOCKED { ATOMIC_INIT(OSQ_UNLOCKED_VAL) }
 
@@ -24,4 +29,7 @@ static inline void osq_lock_init(struct optimistic_spin_queue *lock)
 	atomic_set(&lock->tail, OSQ_UNLOCKED_VAL);
 }
 
+extern bool osq_lock(struct optimistic_spin_queue *lock);
+extern void osq_unlock(struct optimistic_spin_queue *lock);
+
 #endif
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 76768ee..08561f1 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -231,6 +231,10 @@ config RWSEM_SPIN_ON_OWNER
        def_bool y
        depends on SMP && RWSEM_XCHGADD_ALGORITHM && ARCH_SUPPORTS_ATOMIC_RMW
 
+config LOCK_SPIN_ON_OWNER
+       def_bool y
+       depends on MUTEX_SPIN_ON_OWNER || RWSEM_SPIN_ON_OWNER
+
 config ARCH_USE_QUEUE_RWLOCK
 	bool
 
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index 8541bfd..4ca8eb1 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -1,5 +1,5 @@
 
-obj-y += mutex.o semaphore.o rwsem.o mcs_spinlock.o
+obj-y += mutex.o semaphore.o rwsem.o
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = -pg
@@ -14,6 +14,7 @@ ifeq ($(CONFIG_PROC_FS),y)
 obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
 endif
 obj-$(CONFIG_SMP) += spinlock.o
+obj-$(CONFIG_LOCK_SPIN_ON_OWNER) += osq_lock.o
 obj-$(CONFIG_SMP) += lglock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/mcs_spinlock.c
deleted file mode 100644
index 9887a90..0000000
--- a/kernel/locking/mcs_spinlock.c
+++ /dev/null
@@ -1,208 +0,0 @@
-#include <linux/percpu.h>
-#include <linux/sched.h>
-#include "mcs_spinlock.h"
-
-#ifdef CONFIG_SMP
-
-/*
- * An MCS like lock especially tailored for optimistic spinning for sleeping
- * lock implementations (mutex, rwsem, etc).
- *
- * Using a single mcs node per CPU is safe because sleeping locks should not be
- * called from interrupt context and we have preemption disabled while
- * spinning.
- */
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct optimistic_spin_node, osq_node);
-
-/*
- * We use the value 0 to represent "no CPU", thus the encoded value
- * will be the CPU number incremented by 1.
- */
-static inline int encode_cpu(int cpu_nr)
-{
-	return cpu_nr + 1;
-}
-
-static inline struct optimistic_spin_node *decode_cpu(int encoded_cpu_val)
-{
-	int cpu_nr = encoded_cpu_val - 1;
-
-	return per_cpu_ptr(&osq_node, cpu_nr);
-}
-
-/*
- * Get a stable @node->next pointer, either for unlock() or unqueue() purposes.
- * Can return NULL in case we were the last queued and we updated @lock instead.
- */
-static inline struct optimistic_spin_node *
-osq_wait_next(struct optimistic_spin_queue *lock,
-	      struct optimistic_spin_node *node,
-	      struct optimistic_spin_node *prev)
-{
-	struct optimistic_spin_node *next = NULL;
-	int curr = encode_cpu(smp_processor_id());
-	int old;
-
-	/*
-	 * If there is a prev node in queue, then the 'old' value will be
-	 * the prev node's CPU #, else it's set to OSQ_UNLOCKED_VAL since if
-	 * we're currently last in queue, then the queue will then become empty.
-	 */
-	old = prev ? prev->cpu : OSQ_UNLOCKED_VAL;
-
-	for (;;) {
-		if (atomic_read(&lock->tail) == curr &&
-		    atomic_cmpxchg(&lock->tail, curr, old) == curr) {
-			/*
-			 * We were the last queued, we moved @lock back. @prev
-			 * will now observe @lock and will complete its
-			 * unlock()/unqueue().
-			 */
-			break;
-		}
-
-		/*
-		 * We must xchg() the @node->next value, because if we were to
-		 * leave it in, a concurrent unlock()/unqueue() from
-		 * @node->next might complete Step-A and think its @prev is
-		 * still valid.
-		 *
-		 * If the concurrent unlock()/unqueue() wins the race, we'll
-		 * wait for either @lock to point to us, through its Step-B, or
-		 * wait for a new @node->next from its Step-C.
-		 */
-		if (node->next) {
-			next = xchg(&node->next, NULL);
-			if (next)
-				break;
-		}
-
-		cpu_relax_lowlatency();
-	}
-
-	return next;
-}
-
-bool osq_lock(struct optimistic_spin_queue *lock)
-{
-	struct optimistic_spin_node *node = this_cpu_ptr(&osq_node);
-	struct optimistic_spin_node *prev, *next;
-	int curr = encode_cpu(smp_processor_id());
-	int old;
-
-	node->locked = 0;
-	node->next = NULL;
-	node->cpu = curr;
-
-	old = atomic_xchg(&lock->tail, curr);
-	if (old == OSQ_UNLOCKED_VAL)
-		return true;
-
-	prev = decode_cpu(old);
-	node->prev = prev;
-	ACCESS_ONCE(prev->next) = node;
-
-	/*
-	 * Normally @prev is untouchable after the above store; because at that
-	 * moment unlock can proceed and wipe the node element from stack.
-	 *
-	 * However, since our nodes are static per-cpu storage, we're
-	 * guaranteed their existence -- this allows us to apply
-	 * cmpxchg in an attempt to undo our queueing.
-	 */
-
-	while (!smp_load_acquire(&node->locked)) {
-		/*
-		 * If we need to reschedule bail... so we can block.
-		 */
-		if (need_resched())
-			goto unqueue;
-
-		cpu_relax_lowlatency();
-	}
-	return true;
-
-unqueue:
-	/*
-	 * Step - A  -- stabilize @prev
-	 *
-	 * Undo our @prev->next assignment; this will make @prev's
-	 * unlock()/unqueue() wait for a next pointer since @lock points to us
-	 * (or later).
-	 */
-
-	for (;;) {
-		if (prev->next == node &&
-		    cmpxchg(&prev->next, node, NULL) == node)
-			break;
-
-		/*
-		 * We can only fail the cmpxchg() racing against an unlock(),
-		 * in which case we should observe @node->locked becomming
-		 * true.
-		 */
-		if (smp_load_acquire(&node->locked))
-			return true;
-
-		cpu_relax_lowlatency();
-
-		/*
-		 * Or we race against a concurrent unqueue()'s step-B, in which
-		 * case its step-C will write us a new @node->prev pointer.
-		 */
-		prev = ACCESS_ONCE(node->prev);
-	}
-
-	/*
-	 * Step - B -- stabilize @next
-	 *
-	 * Similar to unlock(), wait for @node->next or move @lock from @node
-	 * back to @prev.
-	 */
-
-	next = osq_wait_next(lock, node, prev);
-	if (!next)
-		return false;
-
-	/*
-	 * Step - C -- unlink
-	 *
-	 * @prev is stable because its still waiting for a new @prev->next
-	 * pointer, @next is stable because our @node->next pointer is NULL and
-	 * it will wait in Step-A.
-	 */
-
-	ACCESS_ONCE(next->prev) = prev;
-	ACCESS_ONCE(prev->next) = next;
-
-	return false;
-}
-
-void osq_unlock(struct optimistic_spin_queue *lock)
-{
-	struct optimistic_spin_node *node, *next;
-	int curr = encode_cpu(smp_processor_id());
-
-	/*
-	 * Fast path for the uncontended case.
-	 */
-	if (likely(atomic_cmpxchg(&lock->tail, curr, OSQ_UNLOCKED_VAL) == curr))
-		return;
-
-	/*
-	 * Second most likely case.
-	 */
-	node = this_cpu_ptr(&osq_node);
-	next = xchg(&node->next, NULL);
-	if (next) {
-		ACCESS_ONCE(next->locked) = 1;
-		return;
-	}
-
-	next = osq_wait_next(lock, node, NULL);
-	if (next)
-		ACCESS_ONCE(next->locked) = 1;
-}
-
-#endif
-
diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index 4d60986..d1fe2ba 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -108,20 +108,4 @@ void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 	arch_mcs_spin_unlock_contended(&next->locked);
 }
 
-/*
- * Cancellable version of the MCS lock above.
- *
- * Intended for adaptive spinning of sleeping locks:
- * mutex_lock()/rwsem_down_{read,write}() etc.
- */
-
-struct optimistic_spin_node {
-	struct optimistic_spin_node *next, *prev;
-	int locked; /* 1 if lock acquired */
-	int cpu; /* encoded CPU # value */
-};
-
-extern bool osq_lock(struct optimistic_spin_queue *lock);
-extern void osq_unlock(struct optimistic_spin_queue *lock);
-
 #endif /* __LINUX_MCS_SPINLOCK_H */
diff --git a/kernel/locking/osq_lock.c b/kernel/locking/osq_lock.c
new file mode 100644
index 0000000..ec83d4d
--- /dev/null
+++ b/kernel/locking/osq_lock.c
@@ -0,0 +1,203 @@
+#include <linux/percpu.h>
+#include <linux/sched.h>
+#include <linux/osq_lock.h>
+
+/*
+ * An MCS like lock especially tailored for optimistic spinning for sleeping
+ * lock implementations (mutex, rwsem, etc).
+ *
+ * Using a single mcs node per CPU is safe because sleeping locks should not be
+ * called from interrupt context and we have preemption disabled while
+ * spinning.
+ */
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct optimistic_spin_node, osq_node);
+
+/*
+ * We use the value 0 to represent "no CPU", thus the encoded value
+ * will be the CPU number incremented by 1.
+ */
+static inline int encode_cpu(int cpu_nr)
+{
+	return cpu_nr + 1;
+}
+
+static inline struct optimistic_spin_node *decode_cpu(int encoded_cpu_val)
+{
+	int cpu_nr = encoded_cpu_val - 1;
+
+	return per_cpu_ptr(&osq_node, cpu_nr);
+}
+
+/*
+ * Get a stable @node->next pointer, either for unlock() or unqueue() purposes.
+ * Can return NULL in case we were the last queued and we updated @lock instead.
+ */
+static inline struct optimistic_spin_node *
+osq_wait_next(struct optimistic_spin_queue *lock,
+	      struct optimistic_spin_node *node,
+	      struct optimistic_spin_node *prev)
+{
+	struct optimistic_spin_node *next = NULL;
+	int curr = encode_cpu(smp_processor_id());
+	int old;
+
+	/*
+	 * If there is a prev node in queue, then the 'old' value will be
+	 * the prev node's CPU #, else it's set to OSQ_UNLOCKED_VAL since if
+	 * we're currently last in queue, then the queue will then become empty.
+	 */
+	old = prev ? prev->cpu : OSQ_UNLOCKED_VAL;
+
+	for (;;) {
+		if (atomic_read(&lock->tail) == curr &&
+		    atomic_cmpxchg(&lock->tail, curr, old) == curr) {
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
+		cpu_relax_lowlatency();
+	}
+
+	return next;
+}
+
+bool osq_lock(struct optimistic_spin_queue *lock)
+{
+	struct optimistic_spin_node *node = this_cpu_ptr(&osq_node);
+	struct optimistic_spin_node *prev, *next;
+	int curr = encode_cpu(smp_processor_id());
+	int old;
+
+	node->locked = 0;
+	node->next = NULL;
+	node->cpu = curr;
+
+	old = atomic_xchg(&lock->tail, curr);
+	if (old == OSQ_UNLOCKED_VAL)
+		return true;
+
+	prev = decode_cpu(old);
+	node->prev = prev;
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
+		cpu_relax_lowlatency();
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
+		cpu_relax_lowlatency();
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
+void osq_unlock(struct optimistic_spin_queue *lock)
+{
+	struct optimistic_spin_node *node, *next;
+	int curr = encode_cpu(smp_processor_id());
+
+	/*
+	 * Fast path for the uncontended case.
+	 */
+	if (likely(atomic_cmpxchg(&lock->tail, curr, OSQ_UNLOCKED_VAL) == curr))
+		return;
+
+	/*
+	 * Second most likely case.
+	 */
+	node = this_cpu_ptr(&osq_node);
+	next = xchg(&node->next, NULL);
+	if (next) {
+		ACCESS_ONCE(next->locked) = 1;
+		return;
+	}
+
+	next = osq_wait_next(lock, node, NULL);
+	if (next)
+		ACCESS_ONCE(next->locked) = 1;
+}
-- 
2.1.2

