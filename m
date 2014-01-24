Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaAXE3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 23:29:53 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:29857 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaAXE3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 23:29:35 -0500
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
Subject: [PATCH v11 4/4] qrwlock: Use the mcs_spinlock helper functions for MCS queuing
Date: Thu, 23 Jan 2014 23:28:51 -0500
Message-Id: <1390537731-45996-5-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com>
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a pending MCS lock patch series that adds generic MCS lock
helper functions to do MCS-style locking. This patch will enable
the queue rwlock to use that generic MCS lock/unlock primitives for
internal queuing. This patch should only be merged after the merging
of that generic MCS locking patch.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/asm-generic/qrwlock.h |    7 +---
 kernel/locking/qrwlock.c      |   71 ++++-------------------------------------
 2 files changed, 9 insertions(+), 69 deletions(-)

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
index da0efee..7b337b3 100644
--- a/include/asm-generic/qrwlock.h
+++ b/include/asm-generic/qrwlock.h
@@ -38,10 +38,7 @@
  * the writer field. The least significant 8 bits is the writer field
  * whereas the remaining 24 bits is the reader count.
  */
-struct qrwnode {
-	struct qrwnode *next;
-	int		wait;	/* Waiting flag */
-};
+struct mcs_spinlock;
 
 typedef struct qrwlock {
 	union qrwcnts {
@@ -57,7 +54,7 @@ typedef struct qrwlock {
 		atomic_t    rwa;	/* Reader/writer atomic	*/
 		u32	    rwc;	/* Reader/writer counts */
 	} cnts;
-	struct qrwnode *waitq;		/* Tail of waiting queue */
+	struct mcs_spinlock *waitq;	/* Tail of waiting queue */
 } arch_rwlock_t;
 
 /*
diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
index c76b8ce..cc8d5a1 100644
--- a/kernel/locking/qrwlock.c
+++ b/kernel/locking/qrwlock.c
@@ -21,6 +21,7 @@
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
 #include <linux/mutex.h>
+#include <linux/mcs_spinlock.h>
 #include <asm-generic/qrwlock.h>
 
 /*
@@ -50,64 +51,6 @@
 #define qrw_xadd(rw, inc)	(u32)(atomic_add_return(inc, &(rw).rwa) - inc)
 
 /**
- * wait_in_queue - Add to queue and wait until it is at the head
- * @lock: Pointer to queue rwlock structure
- * @node: Node pointer to be added to the queue
- */
-static inline void wait_in_queue(struct qrwlock *lock, struct qrwnode *node)
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
-		while (smp_load_acquire(&node->wait))
-			arch_mutex_cpu_relax();
-	}
-}
-
-/**
- * signal_next - Signal the next one in queue to be at the head
- * @lock: Pointer to queue rwlock structure
- * @node: Node pointer to the current head of queue
- */
-static inline void signal_next(struct qrwlock *lock, struct qrwnode *node)
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
-	smp_store_release(&next->wait, false);
-}
-
-/**
  * rspin_until_writer_unlock - inc reader count & spin until writer is gone
  * @lock  : Pointer to queue rwlock structure
  * @writer: Current queue rwlock writer status byte
@@ -130,7 +73,7 @@ rspin_until_writer_unlock(struct qrwlock *lock, u32 rwc)
  */
 void queue_read_lock_slowpath(struct qrwlock *lock)
 {
-	struct qrwnode node;
+	struct mcs_spinlock node;
 	union qrwcnts cnts;
 
 	/*
@@ -150,7 +93,7 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
 	/*
 	 * Put the reader into the wait queue
 	 */
-	wait_in_queue(lock, &node);
+	mcs_spin_lock(&lock->waitq, &node);
 
 	/*
 	 * At the head of the wait queue now, wait until the writer state
@@ -167,7 +110,7 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
 	/*
 	 * Signal the next one in queue to become queue head
 	 */
-	signal_next(lock, &node);
+	mcs_spin_unlock(&lock->waitq, &node);
 }
 EXPORT_SYMBOL(queue_read_lock_slowpath);
 
@@ -223,18 +166,18 @@ static inline void queue_write_3step_lock(struct qrwlock *lock)
  */
 void queue_write_lock_slowpath(struct qrwlock *lock)
 {
-	struct qrwnode node;
+	struct mcs_spinlock node;
 
 	/*
 	 * Put the writer into the wait queue
 	 */
-	wait_in_queue(lock, &node);
+	mcs_spin_lock(&lock->waitq, &node);
 
 	/*
 	 * At the head of the wait queue now, call queue_write_3step_lock()
 	 * to acquire the lock until it is done.
 	 */
 	queue_write_3step_lock(lock);
-	signal_next(lock, &node);
+	mcs_spin_unlock(&lock->waitq, &node);
 }
 EXPORT_SYMBOL(queue_write_lock_slowpath);
-- 
1.7.1

