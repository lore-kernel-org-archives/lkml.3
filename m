Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3KDRSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:18:14 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:30500 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3KDRSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:18:10 -0500
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
Subject: [PATCH v5 4/4] qrwlock: Use the mcs_spinlock helper functions for MCS queuing
Date: Mon,  4 Nov 2013 12:17:20 -0500
Message-Id: <1383585440-4391-5-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1383585440-4391-1-git-send-email-Waiman.Long@hp.com>
References: <1383585440-4391-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a pending patch in the rwsem patch series that adds a generic
MCS locking helper functions to do MCS-style locking. This patch
will enable the queue rwlock to use that generic MCS lock/unlock
primitives for internal queuing. This patch should only be merged
after the merging of that generic MCS locking patch.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/qrwlock.h |    7 +--
 lib/qrwlock.c                 |  140 +++++++++++++----------------------------
 2 files changed, 45 insertions(+), 102 deletions(-)

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
index 78ad4a5..014e6e9 100644
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
index a85b9e1..6817853 100644
--- a/lib/qrwlock.c
+++ b/lib/qrwlock.c
@@ -20,6 +20,7 @@
 #include <linux/cpumask.h>
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
+#include <linux/mcs_spinlock.h>
 #include <asm-generic/qrwlock.h>
 
 /*
@@ -46,87 +47,16 @@
  */
 
 /**
- * wait_in_queue - Add to queue and wait until it is at the head
- * @lock: Pointer to queue rwlock structure
- * @node: Node pointer to be added to the queue
- *
- * The use of smp_wmb() is to make sure that the other CPUs see the change
- * ASAP.
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
-		smp_wmb();
-		/*
-		 * Wait until the waiting flag is off
-		 */
-		while (ACCESS_ONCE(node->wait))
-			cpu_relax();
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
-		cpu_relax();
-	/*
-	 * The next one in queue is now at the head
-	 */
-notify_next:
-	barrier();
-	ACCESS_ONCE(next->wait) = false;
-	smp_wmb();
-}
-
-/**
  * rspin_until_writer_unlock - inc reader count & spin until writer is gone
  * @lock: Pointer to queue rwlock structure
+ * @cnts: Queue read/write lock counts structure
  *
  * In interrupt context or at the head of the queue, the reader will just
  * increment the reader count & wait until the writer releases the lock.
  */
 static __always_inline void
-rspin_until_writer_unlock(struct qrwlock *lock, int inc)
+rspin_until_writer_unlock(struct qrwlock *lock, union qrwcnts cnts)
 {
-	union qrwcnts cnts;
-
-	if (inc)
-		cnts.rw = xadd(&lock->cnts.rw, QRW_READER_BIAS);
-	else
-		cnts.rw = ACCESS_ONCE(lock->cnts.rw);
 	while (cnts.writer == QW_LOCKED) {
 		cpu_relax();
 		cnts.rw = ACCESS_ONCE(lock->cnts.rw);
@@ -139,7 +69,7 @@ rspin_until_writer_unlock(struct qrwlock *lock, int inc)
  */
 void queue_read_lock_slowpath(struct qrwlock *lock)
 {
-	struct qrwnode node;
+	struct mcs_spinlock node;
 	union qrwcnts cnts;
 
 	/*
@@ -150,7 +80,8 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
 		 * Readers in interrupt context will spin until the lock is
 		 * available without waiting in the queue.
 		 */
-		rspin_until_writer_unlock(lock, 0);
+		cnts.rw = ACCESS_ONCE(lock->cnts.rw);
+		rspin_until_writer_unlock(lock, cnts);
 		return;
 	}
 	cnts.rw = xadd(&lock->cnts.rw, -QRW_READER_BIAS);
@@ -158,7 +89,7 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
 	/*
 	 * Put the reader into the wait queue
 	 */
-	wait_in_queue(lock, &node);
+	mcs_spin_lock(&lock->waitq, &node);
 
 	/*
 	 * At the head of the wait queue now, try to increment the reader
@@ -172,12 +103,36 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
 		while (ACCESS_ONCE(lock->cnts.writer))
 			cpu_relax();
 	}
-	rspin_until_writer_unlock(lock, 1);
-	signal_next(lock, &node);
+	/*
+	 * Increment reader count & wait until writer unlock
+	 */
+	cnts.rw = xadd(&lock->cnts.rw, QRW_READER_BIAS);
+	rspin_until_writer_unlock(lock, cnts);
+	mcs_spin_unlock(&lock->waitq, &node);
 }
 EXPORT_SYMBOL(queue_read_lock_slowpath);
 
 /**
+ * _write_trylock - try to acquire a write lock
+ * @lock : Pointer to queue rwlock structure
+ * @old  : Old value of the qrwcnts
+ * @new  : New value of the qrwcnts
+ * Return: 1 if lock acquired, 0 otherwise
+ *
+ * Put old & new as function arguments can force the compiler to generate
+ * better code with less stack memory access.
+ */
+static __always_inline int _write_trylock(struct qrwlock *lock,
+				union qrwcnts old, union qrwcnts new)
+{
+	new.rw     = old.rw;
+	new.writer = QW_LOCKED;
+	if (likely(cmpxchg(&lock->cnts.rw, old.rw, new.rw) == old.rw))
+		return 1;
+	return 0;
+}
+
+/**
  * queue_write_3step_lock - acquire write lock in 3 steps
  * @lock : Pointer to queue rwlock structure
  * Return: 1 if lock acquired, 0 otherwise
@@ -194,33 +149,24 @@ static __always_inline int queue_write_3step_lock(struct qrwlock *lock)
 	union qrwcnts old, new;
 
 	old.rw = ACCESS_ONCE(lock->cnts.rw);
+	new.rw = 0;
 
 	/* Step 1 */
-	if (!old.writer & !old.readers) {
-		new.rw     = old.rw;
-		new.writer = QW_LOCKED;
-		if (likely(cmpxchg(&lock->cnts.rw, old.rw, new.rw) == old.rw))
-			return 1;
-	}
+	if (!old.writer && !old.readers && _write_trylock(lock, old, new))
+		return 1;
 
 	/* Step 2 */
 	if (old.writer || (cmpxchg(&lock->cnts.writer, 0, QW_WAITING) != 0))
 		return 0;
 
 	/* Step 3 */
-	while (true) {
+	cpu_relax();
+	old.rw = ACCESS_ONCE(lock->cnts.rw);
+	while (old.readers || !_write_trylock(lock, old, new)) {
 		cpu_relax();
 		old.rw = ACCESS_ONCE(lock->cnts.rw);
-		if (!old.readers) {
-			new.rw     = old.rw;
-			new.writer = QW_LOCKED;
-			if (likely(cmpxchg(&lock->cnts.rw, old.rw, new.rw)
-				== old.rw))
-				return 1;
-		}
 	}
-	/* Should never reach here */
-	return 0;
+	return 1;
 }
 
 /**
@@ -229,12 +175,12 @@ static __always_inline int queue_write_3step_lock(struct qrwlock *lock)
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
@@ -242,6 +188,6 @@ void queue_write_lock_slowpath(struct qrwlock *lock)
 	 */
 	while (!queue_write_3step_lock(lock))
 		cpu_relax();
-	signal_next(lock, &node);
+	mcs_spin_unlock(&lock->waitq, &node);
 }
 EXPORT_SYMBOL(queue_write_lock_slowpath);
-- 
1.7.1

