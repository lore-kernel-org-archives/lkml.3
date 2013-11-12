Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab3KLOtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:49:50 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:6563 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3KLOtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:49:46 -0500
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v6 4/5] qrwlock: Use the mcs_spinlock helper functions for MCS queuing
Date: Tue, 12 Nov 2013 09:48:54 -0500
Message-Id: <1384267735-43213-6-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1384267735-43213-1-git-send-email-Waiman.Long@hp.com>
References: <1384267735-43213-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a pending MCS lock patch series that adds a generic MCS
locking helper functions to do MCS-style locking. This patch will
enable the queue rwlock to use that generic MCS lock/unlock primitives
for internal queuing. This patch should only be merged after the
merging of that generic MCS locking patch.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/qrwlock.h |    7 +--
 lib/qrwlock.c                 |   83 +++-------------------------------------
 2 files changed, 9 insertions(+), 81 deletions(-)

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
index 1f68499..288fb00 100644
--- a/include/asm-generic/qrwlock.h
+++ b/include/asm-generic/qrwlock.h
@@ -54,10 +54,7 @@ typedef u64 __nrcpupair_t;
  * QRW_READER_BIAS to the rw field to increment the reader count won't
  * disturb the writer and the fair fields.
  */
-struct qrwnode {
-	struct qrwnode *next;
-	bool		wait;	/* Waiting flag */
-};
+struct mcs_spinlock;
 
 typedef struct qrwlock {
 	union qrwcnts {
@@ -74,7 +71,7 @@ typedef struct qrwlock {
 		};
 		__nrcpupair_t rw;		/* Reader/writer number pair */
 	} cnts;
-	struct qrwnode *waitq;			/* Tail of waiting queue */
+	struct mcs_spinlock *waitq;		/* Tail of waiting queue */
 } arch_rwlock_t;
 
 /*
diff --git a/lib/qrwlock.c b/lib/qrwlock.c
index 4915dc6..3ae1359 100644
--- a/lib/qrwlock.c
+++ b/lib/qrwlock.c
@@ -20,6 +20,7 @@
 #include <linux/cpumask.h>
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
+#include <linux/mcs_spinlock.h>
 #include <asm-generic/qrwlock.h>
 
 /*
@@ -57,76 +58,6 @@
 # endif
 #endif
 
-#ifndef smp_mb__store_release
-# ifdef CONFIG_X86
-#   define smp_mb__store_release()	barrier()
-# else
-#   define smp_mb__store_release()	smp_mb()
-# endif
-#endif
-
-/**
- * wait_in_queue - Add to queue and wait until it is at the head
- * @lock: Pointer to queue rwlock structure
- * @node: Node pointer to be added to the queue
- */
-static __always_inline void
-wait_in_queue(struct qrwlock *lock, struct qrwnode *node)
-{
-	struct qrwnode *prev;
-
-	node->next = NULL;
-	node->wait = true;
-	prev = xchg(&lock->waitq, node);
-	if (prev) {
-		prev->next = node;
-		/*
-		 * Wait until the waiting flag is off
-		 */
-		while (ACCESS_ONCE(node->wait))
-			arch_mutex_cpu_relax();
-		smp_mb__load_acquire();
-	}
-}
-
-/**
- * signal_next - Signal the next one in queue to be at the head
- * @lock: Pointer to queue rwlock structure
- * @node: Node pointer to the current head of queue
- */
-static __always_inline void
-signal_next(struct qrwlock *lock, struct qrwnode *node)
-{
-	struct qrwnode *next;
-
-	/*
-	 * Try to notify the next node first without disturbing the cacheline
-	 * of the lock. If that fails, check to see if it is the last node
-	 * and so should clear the wait queue.
-	 */
-	next = ACCESS_ONCE(node->next);
-	if (likely(next))
-		goto notify_next;
-
-	/*
-	 * Clear the wait queue if it is the last node
-	 */
-	if ((ACCESS_ONCE(lock->waitq) == node) &&
-	    (cmpxchg(&lock->waitq, node, NULL) == node))
-			return;
-	/*
-	 * Wait until the next one in queue set up the next field
-	 */
-	while (likely(!(next = ACCESS_ONCE(node->next))))
-		arch_mutex_cpu_relax();
-	/*
-	 * The next one in queue is now at the head
-	 */
-notify_next:
-	smp_mb__store_release();
-	ACCESS_ONCE(next->wait) = false;
-}
-
 /**
  * rspin_until_writer_unlock - inc reader count & spin until writer is gone
  * @lock: Pointer to queue rwlock structure
@@ -150,7 +81,7 @@ rspin_until_writer_unlock(struct qrwlock *lock, union qrwcnts cnts)
  */
 void queue_read_lock_slowpath(struct qrwlock *lock)
 {
-	struct qrwnode node;
+	struct mcs_spinlock node;
 	union qrwcnts cnts;
 
 	/*
@@ -170,7 +101,7 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
 	/*
 	 * Put the reader into the wait queue
 	 */
-	wait_in_queue(lock, &node);
+	mcs_spin_lock(lock, &node);
 
 	/*
 	 * At the head of the wait queue now, try to increment the reader
@@ -190,7 +121,7 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
 	 * Need to have a barrier with read-acquire semantics
 	 */
 	smp_mb__load_acquire();
-	signal_next(lock, &node);
+	mcs_spin_unlock(lock, &node);
 }
 EXPORT_SYMBOL(queue_read_lock_slowpath);
 
@@ -256,12 +187,12 @@ static noinline int queue_write_3step_lock(struct qrwlock *lock)
  */
 void queue_write_lock_slowpath(struct qrwlock *lock)
 {
-	struct qrwnode node;
+	struct mcs_spinlock node;
 
 	/*
 	 * Put the writer into the wait queue
 	 */
-	wait_in_queue(lock, &node);
+	mcs_spin_lock(lock, &node);
 
 	/*
 	 * At the head of the wait queue now, call queue_write_3step_lock()
@@ -269,6 +200,6 @@ void queue_write_lock_slowpath(struct qrwlock *lock)
 	 */
 	while (!queue_write_3step_lock(lock))
 		arch_mutex_cpu_relax();
-	signal_next(lock, &node);
+	mcs_spin_unlock(lock, &node);
 }
 EXPORT_SYMBOL(queue_write_lock_slowpath);
-- 
1.7.1

