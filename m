Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaGGSuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:50:50 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:31250 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaGGSut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:50:49 -0400
From: Jason Low <jason.low2@hp.com>
To: peterz@infradead.org, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org, Waiman.Long@hp.com,
        davidlohr@hp.com, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, riel@redhat.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, hpa@zytor.com, tim.c.chen@linux.intel.com,
        konrad.wilk@oracle.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com, jason.low2@hp.com
Subject: [PATCH 1/4] MCS spinlocks: Rename optimistic_spin_queue to optimistic_spin_node
Date: Mon,  7 Jul 2014 11:50:16 -0700
Message-Id: <1404759019-4268-2-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404759019-4268-1-git-send-email-jason.low2@hp.com>
References: <1404759019-4268-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the per-cpu nodes structure for the cancellable MCS spinlock is
named "optimistic_spin_queue". However, in a follow up patch in the series
we will be introducing a new structure that serves as the new "handle" for
the lock. It would make more sense if that structure is named
"optimistic_spin_queue". Additionally, since the current use of the
"optimistic_spin_queue" structure are  "nodes", it might be better if we
rename them to "node" anyway.

This preparatory patch renames all current "optimistic_spin_queue"
to "optimistic_spin_node".

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 include/linux/mutex.h         |    4 ++--
 include/linux/rwsem.h         |    4 ++--
 kernel/locking/mcs_spinlock.c |   24 ++++++++++++------------
 kernel/locking/mcs_spinlock.h |    8 ++++----
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 11692de..885f3f5 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -46,7 +46,7 @@
  * - detects multi-task circular deadlocks and prints out all affected
  *   locks and tasks (and only those tasks)
  */
-struct optimistic_spin_queue;
+struct optimistic_spin_node;
 struct mutex {
 	/* 1: unlocked, 0: locked, negative: locked, possible waiters */
 	atomic_t		count;
@@ -56,7 +56,7 @@ struct mutex {
 	struct task_struct	*owner;
 #endif
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	struct optimistic_spin_queue	*osq;	/* Spinner MCS lock */
+	struct optimistic_spin_node	*osq;	/* Spinner MCS lock */
 #endif
 #ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 8d79708..ba3f108 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -16,7 +16,7 @@
 
 #include <linux/atomic.h>
 
-struct optimistic_spin_queue;
+struct optimistic_spin_node;
 struct rw_semaphore;
 
 #ifdef CONFIG_RWSEM_GENERIC_SPINLOCK
@@ -33,7 +33,7 @@ struct rw_semaphore {
 	 * if the owner is running on the cpu.
 	 */
 	struct task_struct *owner;
-	struct optimistic_spin_queue *osq; /* spinner MCS lock */
+	struct optimistic_spin_node *osq; /* spinner MCS lock */
 #endif
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/mcs_spinlock.c
index 838dc9e..e9866f7 100644
--- a/kernel/locking/mcs_spinlock.c
+++ b/kernel/locking/mcs_spinlock.c
@@ -14,18 +14,18 @@
  * called from interrupt context and we have preemption disabled while
  * spinning.
  */
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct optimistic_spin_queue, osq_node);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct optimistic_spin_node, osq_node);
 
 /*
  * Get a stable @node->next pointer, either for unlock() or unqueue() purposes.
  * Can return NULL in case we were the last queued and we updated @lock instead.
  */
-static inline struct optimistic_spin_queue *
-osq_wait_next(struct optimistic_spin_queue **lock,
-	      struct optimistic_spin_queue *node,
-	      struct optimistic_spin_queue *prev)
+static inline struct optimistic_spin_node *
+osq_wait_next(struct optimistic_spin_node **lock,
+	      struct optimistic_spin_node *node,
+	      struct optimistic_spin_node *prev)
 {
-	struct optimistic_spin_queue *next = NULL;
+	struct optimistic_spin_node *next = NULL;
 
 	for (;;) {
 		if (*lock == node && cmpxchg(lock, node, prev) == node) {
@@ -59,10 +59,10 @@ osq_wait_next(struct optimistic_spin_queue **lock,
 	return next;
 }
 
-bool osq_lock(struct optimistic_spin_queue **lock)
+bool osq_lock(struct optimistic_spin_node **lock)
 {
-	struct optimistic_spin_queue *node = this_cpu_ptr(&osq_node);
-	struct optimistic_spin_queue *prev, *next;
+	struct optimistic_spin_node *node = this_cpu_ptr(&osq_node);
+	struct optimistic_spin_node *prev, *next;
 
 	node->locked = 0;
 	node->next = NULL;
@@ -149,10 +149,10 @@ unqueue:
 	return false;
 }
 
-void osq_unlock(struct optimistic_spin_queue **lock)
+void osq_unlock(struct optimistic_spin_node **lock)
 {
-	struct optimistic_spin_queue *node = this_cpu_ptr(&osq_node);
-	struct optimistic_spin_queue *next;
+	struct optimistic_spin_node *node = this_cpu_ptr(&osq_node);
+	struct optimistic_spin_node *next;
 
 	/*
 	 * Fast path for the uncontended case.
diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index a2dbac4..c99dc00 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -118,12 +118,12 @@ void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
  * mutex_lock()/rwsem_down_{read,write}() etc.
  */
 
-struct optimistic_spin_queue {
-	struct optimistic_spin_queue *next, *prev;
+struct optimistic_spin_node {
+	struct optimistic_spin_node *next, *prev;
 	int locked; /* 1 if lock acquired */
 };
 
-extern bool osq_lock(struct optimistic_spin_queue **lock);
-extern void osq_unlock(struct optimistic_spin_queue **lock);
+extern bool osq_lock(struct optimistic_spin_node **lock);
+extern void osq_unlock(struct optimistic_spin_node **lock);
 
 #endif /* __LINUX_MCS_SPINLOCK_H */
-- 
1.7.1

