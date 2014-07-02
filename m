Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbaGBQVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:21:21 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:17649 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaGBQVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:21:20 -0400
From: Jason Low <jason.low2@hp.com>
To: peterz@infradead.org, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org, Waiman.Long@hp.com,
        davidlohr@hp.com, linux-kernel@vger.kernel.org
Cc: riel@redhat.com, akpm@linux-foundation.org, hpa@zytor.com,
        andi@firstfloor.org, James.Bottomley@hansenpartnership.com,
        rostedt@goodmis.org, tim.c.chen@linux.intel.com, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com, jason.low2@hp.com
Subject: [RFC] Cancellable MCS spinlock rework
Date: Wed,  2 Jul 2014 09:21:10 -0700
Message-Id: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cancellable MCS spinlock is currently used to queue threads that are
doing optimistic spinning. It uses per-cpu nodes, where a thread obtaining
the lock would access and queue the local node corresponding to the CPU that
it's running on. Currently, the cancellable MCS lock is implemented by using
pointers to these nodes.

In this RFC patch, instead of operating on pointers to the per-cpu nodes, we
store the CPU numbers in which the per-cpu nodes correspond to in atomic_t.
A similar concept is used with the qspinlock.

We add 1 to the CPU number to retrive an "encoded value" representing the node
of that CPU. By doing this, 0 can represent "no CPU", which allows us to
keep the simple "if (CPU)" and "if (!CPU)" checks. In this patch, the next and
prev pointers in each node were also modified to store encoded CPU values.

By operating on the CPU # of the nodes using atomic_t instead of pointers
to those nodes, this can reduce the overhead of the cancellable MCS spinlock
by 32 bits (on 64 bit systems).

It was also found that the current cancellable MCS lock's use of ACCESS_ONCE
stores + cmpxchg() on some architectures can result in race conditions. Since
this change makes the cancellable MCS lock use atomic operations, this may also
be able to address those problems and avoid needing to implement architecture
dependant workarounds to avoid such issues with this lock.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 include/linux/mutex.h         |    4 +-
 include/linux/osq_lock.h      |    8 ++++
 include/linux/rwsem.h         |    7 ++--
 kernel/locking/mcs_spinlock.c |   81 ++++++++++++++++++++++++++++-------------
 kernel/locking/mcs_spinlock.h |    7 ++--
 kernel/locking/mutex.c        |    2 +-
 kernel/locking/rwsem-xadd.c   |    2 +-
 7 files changed, 74 insertions(+), 37 deletions(-)
 create mode 100644 include/linux/osq_lock.h

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 11692de..0809dc7 100644
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
-struct optimistic_spin_queue;
 struct mutex {
 	/* 1: unlocked, 0: locked, negative: locked, possible waiters */
 	atomic_t		count;
@@ -56,7 +56,7 @@ struct mutex {
 	struct task_struct	*owner;
 #endif
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	struct optimistic_spin_queue	*osq;	/* Spinner MCS lock */
+	struct optimistic_spin_tail osq; /* Spinner MCS lock */
 #endif
 #ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
diff --git a/include/linux/osq_lock.h b/include/linux/osq_lock.h
new file mode 100644
index 0000000..582e8ff
--- /dev/null
+++ b/include/linux/osq_lock.h
@@ -0,0 +1,8 @@
+#ifndef __LINUX_OSQ_LOCK_H
+#define __LINUX_OSQ_LOCK_H
+
+struct optimistic_spin_tail {
+	atomic_t tail;	/* 0 indicates no tail (empty queue) */
+};
+
+#endif
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 8d79708..cdefd08 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -13,10 +13,9 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
-
 #include <linux/atomic.h>
+#include <linux/osq_lock.h>
 
-struct optimistic_spin_queue;
 struct rw_semaphore;
 
 #ifdef CONFIG_RWSEM_GENERIC_SPINLOCK
@@ -33,7 +32,7 @@ struct rw_semaphore {
 	 * if the owner is running on the cpu.
 	 */
 	struct task_struct *owner;
-	struct optimistic_spin_queue *osq; /* spinner MCS lock */
+	struct optimistic_spin_tail osq; /* spinner MCS lock */
 #endif
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
@@ -70,7 +69,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
 	  LIST_HEAD_INIT((name).wait_list),		\
 	  NULL, /* owner */				\
-	  NULL /* mcs lock */                           \
+	  { ATOMIC_INIT(0) } /* mcs lock */                           \
 	  __RWSEM_DEP_MAP_INIT(name) }
 #else
 #define __RWSEM_INITIALIZER(name)			\
diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/mcs_spinlock.c
index 838dc9e..8c12906 100644
--- a/kernel/locking/mcs_spinlock.c
+++ b/kernel/locking/mcs_spinlock.c
@@ -17,18 +17,36 @@
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct optimistic_spin_queue, osq_node);
 
 /*
+ * We use the value 0 to represent "no CPU", thus the encoded value
+ * will be the CPU number incremented by 1.
+ */
+static inline int encode_cpu(int cpu_nr)
+{
+	return (cpu_nr + 1);
+}
+
+static inline struct optimistic_spin_queue *decode_cpu(int encoded_cpu_val)
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
-static inline struct optimistic_spin_queue *
-osq_wait_next(struct optimistic_spin_queue **lock,
+static inline int
+osq_wait_next(struct optimistic_spin_tail *lock,
 	      struct optimistic_spin_queue *node,
-	      struct optimistic_spin_queue *prev)
+	      int prev)
 {
-	struct optimistic_spin_queue *next = NULL;
+	int next = 0;
+	int curr = encode_cpu(smp_processor_id());
 
 	for (;;) {
-		if (*lock == node && cmpxchg(lock, node, prev) == node) {
+		if (atomic_read(&lock->tail) == curr &&
+		    atomic_cmpxchg(&lock->tail, curr, prev) == curr) {
 			/*
 			 * We were the last queued, we moved @lock back. @prev
 			 * will now observe @lock and will complete its
@@ -47,8 +65,8 @@ osq_wait_next(struct optimistic_spin_queue **lock,
 		 * wait for either @lock to point to us, through its Step-B, or
 		 * wait for a new @node->next from its Step-C.
 		 */
-		if (node->next) {
-			next = xchg(&node->next, NULL);
+		if (atomic_read(&node->next)) {
+			next = atomic_xchg(&node->next, 0);
 			if (next)
 				break;
 		}
@@ -59,19 +77,23 @@ osq_wait_next(struct optimistic_spin_queue **lock,
 	return next;
 }
 
-bool osq_lock(struct optimistic_spin_queue **lock)
+bool osq_lock(struct optimistic_spin_tail *lock)
 {
 	struct optimistic_spin_queue *node = this_cpu_ptr(&osq_node);
-	struct optimistic_spin_queue *prev, *next;
+	struct optimistic_spin_queue *prev_node, *next_node;
+	int curr = encode_cpu(smp_processor_id()), prev, next;
 
 	node->locked = 0;
-	node->next = NULL;
+	atomic_set(&node->next, 0);
 
-	node->prev = prev = xchg(lock, node);
-	if (likely(prev == NULL))
+	prev = atomic_xchg(&lock->tail, curr);
+	if (likely(!prev))
 		return true;
 
-	ACCESS_ONCE(prev->next) = node;
+	atomic_set(&node->prev, prev);
+
+	prev_node = decode_cpu(prev);
+	atomic_set(&prev_node->next, curr);
 
 	/*
 	 * Normally @prev is untouchable after the above store; because at that
@@ -103,8 +125,8 @@ unqueue:
 	 */
 
 	for (;;) {
-		if (prev->next == node &&
-		    cmpxchg(&prev->next, node, NULL) == node)
+		if (atomic_read(&prev_node->next) == curr &&
+		    atomic_cmpxchg(&prev_node->next, curr, 0) == curr)
 			break;
 
 		/*
@@ -121,7 +143,8 @@ unqueue:
 		 * Or we race against a concurrent unqueue()'s step-B, in which
 		 * case its step-C will write us a new @node->prev pointer.
 		 */
-		prev = ACCESS_ONCE(node->prev);
+		prev = atomic_read(&node->prev);
+		prev_node = decode_cpu(prev);
 	}
 
 	/*
@@ -134,6 +157,8 @@ unqueue:
 	next = osq_wait_next(lock, node, prev);
 	if (!next)
 		return false;
+	else
+		next_node = decode_cpu(next);
 
 	/*
 	 * Step - C -- unlink
@@ -143,35 +168,39 @@ unqueue:
 	 * it will wait in Step-A.
 	 */
 
-	ACCESS_ONCE(next->prev) = prev;
-	ACCESS_ONCE(prev->next) = next;
+	atomic_set(&next_node->prev, prev);
+	atomic_set(&prev_node->next, next);
 
 	return false;
 }
 
-void osq_unlock(struct optimistic_spin_queue **lock)
+void osq_unlock(struct optimistic_spin_tail *lock)
 {
 	struct optimistic_spin_queue *node = this_cpu_ptr(&osq_node);
-	struct optimistic_spin_queue *next;
+	struct optimistic_spin_queue *next_node;
+	int curr = encode_cpu(smp_processor_id()), next;
 
 	/*
 	 * Fast path for the uncontended case.
 	 */
-	if (likely(cmpxchg(lock, node, NULL) == node))
+	if (likely(atomic_cmpxchg(&lock->tail, curr, 0) == curr))
 		return;
 
 	/*
 	 * Second most likely case.
 	 */
-	next = xchg(&node->next, NULL);
+	next = atomic_xchg(&node->next, 0);
 	if (next) {
-		ACCESS_ONCE(next->locked) = 1;
+		next_node = decode_cpu(next);
+		ACCESS_ONCE(next_node->locked) = 1;
 		return;
 	}
 
-	next = osq_wait_next(lock, node, NULL);
-	if (next)
-		ACCESS_ONCE(next->locked) = 1;
+	next = osq_wait_next(lock, node, 0);
+	if (next) {
+		next_node = decode_cpu(next);
+		ACCESS_ONCE(next_node->locked) = 1;
+	}
 }
 
 #endif
diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index a2dbac4..c07b5e4 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -13,6 +13,7 @@
 #define __LINUX_MCS_SPINLOCK_H
 
 #include <asm/mcs_spinlock.h>
+#include <linux/osq_lock.h>
 
 struct mcs_spinlock {
 	struct mcs_spinlock *next;
@@ -119,11 +120,11 @@ void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
  */
 
 struct optimistic_spin_queue {
-	struct optimistic_spin_queue *next, *prev;
+	atomic_t next, prev;
 	int locked; /* 1 if lock acquired */
 };
 
-extern bool osq_lock(struct optimistic_spin_queue **lock);
-extern void osq_unlock(struct optimistic_spin_queue **lock);
+extern bool osq_lock(struct optimistic_spin_tail *lock);
+extern void osq_unlock(struct optimistic_spin_tail *lock);
 
 #endif /* __LINUX_MCS_SPINLOCK_H */
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index bc73d33..b668d8d 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -60,7 +60,7 @@ __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 	INIT_LIST_HEAD(&lock->wait_list);
 	mutex_clear_owner(lock);
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	lock->osq = NULL;
+	atomic_set(&lock->osq.tail, 0);
 #endif
 
 	debug_mutex_init(lock, name, key);
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index dacc321..b346ff2 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -84,7 +84,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	INIT_LIST_HEAD(&sem->wait_list);
 #ifdef CONFIG_SMP
 	sem->owner = NULL;
-	sem->osq = NULL;
+	atomic_set(&sem->osq.tail, 0);
 #endif
 }
 
-- 
1.7.1

