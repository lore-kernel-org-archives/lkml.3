Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaGGTGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:06:09 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:56114 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaGGTGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:06:07 -0400
From: Jason Low <jason.low2@hp.com>
To: peterz@infradead.org, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org, Waiman.Long@hp.com,
        davidlohr@hp.com, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, riel@redhat.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, hpa@zytor.com, tim.c.chen@linux.intel.com,
        konrad.wilk@oracle.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com, jason.low2@hp.com
Subject: [PATCH 2/4] MCS spinlocks: Convert osq lock to atomic_t to reduce overhead
Date: Mon,  7 Jul 2014 11:50:17 -0700
Message-Id: <1404759019-4268-3-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404759019-4268-1-git-send-email-jason.low2@hp.com>
References: <1404759019-4268-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cancellable MCS spinlock is currently used to queue threads that are
doing optimistic spinning. It uses per-cpu nodes, where a thread obtaining
the lock would access and queue the local node corresponding to the CPU that
it's running on. Currently, the cancellable MCS lock is implemented by using
pointers to these nodes.

In this patch, instead of operating on pointers to the per-cpu nodes, we
store the CPU numbers in which the per-cpu nodes correspond to in atomic_t.
A similar concept is used with the qspinlock.

By operating on the CPU # of the nodes using atomic_t instead of pointers
to those nodes, this can reduce the overhead of the cancellable MCS spinlock
by 32 bits (on 64 bit systems).

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 include/linux/mutex.h         |    4 +-
 include/linux/osq_lock.h      |   19 +++++++++++++++++
 include/linux/rwsem.h         |    7 ++---
 kernel/locking/mcs_spinlock.c |   44 ++++++++++++++++++++++++++++++++++------
 kernel/locking/mcs_spinlock.h |    5 ++-
 kernel/locking/mutex.c        |    2 +-
 kernel/locking/rwsem-xadd.c   |    2 +-
 7 files changed, 66 insertions(+), 17 deletions(-)
 create mode 100644 include/linux/osq_lock.h

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 885f3f5..42aa9b9 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -17,6 +17,7 @@
 #include <linux/lockdep.h>
 #include <linux/atomic.h>
 #include <asm/processor.h>
+#include <linux/osq_lock.h>
 
 /*
  * Simple, straightforward mutexes with strict semantics:
@@ -46,7 +47,6 @@
  * - detects multi-task circular deadlocks and prints out all affected
  *   locks and tasks (and only those tasks)
  */
-struct optimistic_spin_node;
 struct mutex {
 	/* 1: unlocked, 0: locked, negative: locked, possible waiters */
 	atomic_t		count;
@@ -56,7 +56,7 @@ struct mutex {
 	struct task_struct	*owner;
 #endif
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	struct optimistic_spin_node	*osq;	/* Spinner MCS lock */
+	struct optimistic_spin_queue osq; /* Spinner MCS lock */
 #endif
 #ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
diff --git a/include/linux/osq_lock.h b/include/linux/osq_lock.h
new file mode 100644
index 0000000..b001682
--- /dev/null
+++ b/include/linux/osq_lock.h
@@ -0,0 +1,19 @@
+#ifndef __LINUX_OSQ_LOCK_H
+#define __LINUX_OSQ_LOCK_H
+
+/*
+ * An MCS like lock especially tailored for optimistic spinning for sleeping
+ * lock implementations (mutex, rwsem, etc).
+ */
+
+#define OSQ_UNLOCKED_VAL (0)
+
+struct optimistic_spin_queue {
+	/*
+	 * Stores an encoded value of the CPU # of the tail node in the queue.
+	 * If the queue is empty, then it's set to OSQ_UNLOCKED_VAL.
+	 */
+	atomic_t tail;
+};
+
+#endif
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index ba3f108..9fdcdd0 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -13,10 +13,9 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
-
 #include <linux/atomic.h>
+#include <linux/osq_lock.h>
 
-struct optimistic_spin_node;
 struct rw_semaphore;
 
 #ifdef CONFIG_RWSEM_GENERIC_SPINLOCK
@@ -33,7 +32,7 @@ struct rw_semaphore {
 	 * if the owner is running on the cpu.
 	 */
 	struct task_struct *owner;
-	struct optimistic_spin_node *osq; /* spinner MCS lock */
+	struct optimistic_spin_queue osq; /* spinner MCS lock */
 #endif
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
@@ -70,7 +69,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
 	  LIST_HEAD_INIT((name).wait_list),		\
 	  NULL, /* owner */				\
-	  NULL /* mcs lock */                           \
+	  { ATOMIC_INIT(OSQ_UNLOCKED_VAL) } /* osq */   \
 	  __RWSEM_DEP_MAP_INIT(name) }
 #else
 #define __RWSEM_INITIALIZER(name)			\
diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/mcs_spinlock.c
index e9866f7..124a3bb 100644
--- a/kernel/locking/mcs_spinlock.c
+++ b/kernel/locking/mcs_spinlock.c
@@ -17,18 +17,43 @@
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct optimistic_spin_node, osq_node);
 
 /*
+ * We use the value 0 to represent "no CPU", thus the encoded value
+ * will be the CPU number incremented by 1.
+ */
+static inline int encode_cpu(int cpu_nr)
+{
+	return (cpu_nr + 1);
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
  * Get a stable @node->next pointer, either for unlock() or unqueue() purposes.
  * Can return NULL in case we were the last queued and we updated @lock instead.
  */
 static inline struct optimistic_spin_node *
-osq_wait_next(struct optimistic_spin_node **lock,
+osq_wait_next(struct optimistic_spin_queue *lock,
 	      struct optimistic_spin_node *node,
 	      struct optimistic_spin_node *prev)
 {
 	struct optimistic_spin_node *next = NULL;
+	int curr = encode_cpu(smp_processor_id()), old;
+
+	/*
+	 * If there is a prev node in queue, then the 'old' value will be
+	 * the prev node's CPU #, else it's set to OSQ_UNLOCKED_VAL since if
+	 * we're currently last in queue, then the queue will then become empty.
+	 */
+	old = prev ? prev->cpu : OSQ_UNLOCKED_VAL;
 
 	for (;;) {
-		if (*lock == node && cmpxchg(lock, node, prev) == node) {
+		if (atomic_read(&lock->tail) == curr &&
+		    atomic_cmpxchg(&lock->tail, curr, old) == curr) {
 			/*
 			 * We were the last queued, we moved @lock back. @prev
 			 * will now observe @lock and will complete its
@@ -59,18 +84,22 @@ osq_wait_next(struct optimistic_spin_node **lock,
 	return next;
 }
 
-bool osq_lock(struct optimistic_spin_node **lock)
+bool osq_lock(struct optimistic_spin_queue *lock)
 {
 	struct optimistic_spin_node *node = this_cpu_ptr(&osq_node);
 	struct optimistic_spin_node *prev, *next;
+	int curr = encode_cpu(smp_processor_id()), old;
 
 	node->locked = 0;
 	node->next = NULL;
+	node->cpu = curr;
 
-	node->prev = prev = xchg(lock, node);
-	if (likely(prev == NULL))
+	old = atomic_xchg(&lock->tail, curr);
+	if (old == OSQ_UNLOCKED_VAL)
 		return true;
 
+	prev = decode_cpu(old);
+	node->prev = prev;
 	ACCESS_ONCE(prev->next) = node;
 
 	/*
@@ -149,15 +178,16 @@ unqueue:
 	return false;
 }
 
-void osq_unlock(struct optimistic_spin_node **lock)
+void osq_unlock(struct optimistic_spin_queue *lock)
 {
 	struct optimistic_spin_node *node = this_cpu_ptr(&osq_node);
 	struct optimistic_spin_node *next;
+	int curr = encode_cpu(smp_processor_id());
 
 	/*
 	 * Fast path for the uncontended case.
 	 */
-	if (likely(cmpxchg(lock, node, NULL) == node))
+	if (likely(atomic_cmpxchg(&lock->tail, curr, OSQ_UNLOCKED_VAL) == curr))
 		return;
 
 	/*
diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index c99dc00..74356dc 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -121,9 +121,10 @@ void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 struct optimistic_spin_node {
 	struct optimistic_spin_node *next, *prev;
 	int locked; /* 1 if lock acquired */
+	int cpu; /* encoded CPU # value */
 };
 
-extern bool osq_lock(struct optimistic_spin_node **lock);
-extern void osq_unlock(struct optimistic_spin_node **lock);
+extern bool osq_lock(struct optimistic_spin_queue *lock);
+extern void osq_unlock(struct optimistic_spin_queue *lock);
 
 #endif /* __LINUX_MCS_SPINLOCK_H */
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index bc73d33..d9b3139 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -60,7 +60,7 @@ __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 	INIT_LIST_HEAD(&lock->wait_list);
 	mutex_clear_owner(lock);
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	lock->osq = NULL;
+	atomic_set(&lock->osq.tail, OSQ_UNLOCKED_VAL);
 #endif
 
 	debug_mutex_init(lock, name, key);
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index dacc321..9416ddb 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -84,7 +84,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	INIT_LIST_HEAD(&sem->wait_list);
 #ifdef CONFIG_SMP
 	sem->owner = NULL;
-	sem->osq = NULL;
+	atomic_set(&sem->osq.tail, OSQ_UNLOCKED_VAL);
 #endif
 }
 
-- 
1.7.1

