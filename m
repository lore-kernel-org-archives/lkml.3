Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbaAaJ05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 04:26:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41712 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaAaJ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 04:26:53 -0500
Date: Fri, 31 Jan 2014 10:26:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v11 0/4] Introducing a queue read/write lock
 implementation
Message-ID: <20140131092616.GC5126@laptop.programming.kicks-ass.net>
References: <1390537731-45996-1-git-send-email-Waiman.Long@hp.com>
 <20140130130453.GB2936@laptop.programming.kicks-ass.net>
 <20140130151715.GA5126@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130151715.GA5126@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 04:17:15PM +0100, Peter Zijlstra wrote:
> The below is still small and actually works.

OK, so having actually worked through the thing; I realized we can
actually do a version without MCS lock and instead use a ticket lock for
the waitqueue.

This is both smaller (back to 8 bytes for the rwlock_t), and should be
faster under moderate contention for not having to touch extra
cachelines.

Completely untested and with a rather crude generic ticket lock
implementation to illustrate the concept:

---
--- a/include/asm-generic/qrwlock_types.h
+++ b/include/asm-generic/qrwlock_types.h
@@ -3,15 +3,13 @@
 
 #include <linux/atomic.h>
 
-struct mcs_spinlock;
-
 /*
  * The queue read/write lock data structure
  */
 
 struct qrwlock {
 	atomic_t		cnts;
-	struct mcs_spinlock	*waitq;
+	atomic_t		tickets;
 };
 
 #endif /* __ASM_GENERIC_QRWLOCK_TYPES_H */
--- a/kernel/locking/qrwlock.c
+++ b/kernel/locking/qrwlock.c
@@ -21,29 +21,32 @@
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
 #include <linux/mutex.h>
-#include <linux/mcs_spinlock.h>
 #include <asm/qrwlock.h>
 
-/*
- * Compared with regular rwlock, the queue rwlock has has the following
- * advantages:
- * 1. Even though there is a slight chance of stealing the lock if come at
- *    the right moment, the granting of the lock is mostly in FIFO order.
- * 2. It is usually faster in high contention situation.
- *
- * The only downside is that the lock is 4 bytes larger in 32-bit systems
- * and 12 bytes larger in 64-bit systems.
- *
- * There are two queues for writers. The writer field of the lock is a
- * one-slot wait queue. The writers that follow will have to wait in the
- * combined reader/writer queue (waitq).
- *
- * Compared with x86 ticket spinlock, the queue rwlock is faster in high
- * contention situation. The writer lock is also faster in single thread
- * operations. Therefore, queue rwlock can be considered as a replacement
- * for those spinlocks that are highly contended as long as an increase
- * in lock size is not an issue.
- */
+#define TICKET_MSB	0x8000
+#define TICKET_MASK	0x7FFF
+
+#define atomic_xadd(v, a) (atomic_add_return((v), (a)) - (v))
+
+static inline void ticket_spin_lock(atomic_t *tickets)
+{
+	u32 val = atomic_xadd(1 << 16, tickets);
+	u32 ticket = (val >> 16) & TICKET_MASK;
+	
+	if (unlikely(val & TICKET_MSB))
+		atomic_clear_mask(TICKET_MSB, tickets);
+
+	if (unlikely((val & TICKET_MASK) != ticket)) {
+		while ((smp_load_acquire((u32 *)tickets) & TICKET_MASK) != ticket)
+			cpu_relax();
+	}
+}
+
+static inline void ticket_spin_unlock(atomic_t *tickets)
+{
+	smp_mb__before_atomic_inc();
+	atomic_inc(tickets);
+}
 
 /**
  * rspin_until_writer_unlock - inc reader count & spin until writer is gone
@@ -68,7 +71,6 @@ rspin_until_writer_unlock(struct qrwlock
  */
 void queue_read_lock_slowpath(struct qrwlock *lock)
 {
-	struct mcs_spinlock node;
 	u32 cnts;
 
 	/*
@@ -88,7 +90,7 @@ void queue_read_lock_slowpath(struct qrw
 	/*
 	 * Put the reader into the wait queue
 	 */
-	mcs_spin_lock(&lock->waitq, &node);
+	ticket_spin_lock(&lock->tickets);
 
 	/*
 	 * At the head of the wait queue now, wait until the writer state
@@ -100,13 +102,13 @@ void queue_read_lock_slowpath(struct qrw
 	while (atomic_read(&lock->cnts) & _QW_WMASK)
 		arch_mutex_cpu_relax();
 
-	cnts = atomic_add_return(_QR_BIAS, &lock->cnts) - _QR_BIAS;
+	cnts = atomic_xadd(_QR_BIAS, &lock->cnts);
 	rspin_until_writer_unlock(lock, cnts);
 
 	/*
 	 * Signal the next one in queue to become queue head
 	 */
-	mcs_spin_unlock(&lock->waitq, &node);
+	ticket_spin_unlock(&lock->tickets);
 }
 EXPORT_SYMBOL(queue_read_lock_slowpath);
 
@@ -116,11 +118,10 @@ EXPORT_SYMBOL(queue_read_lock_slowpath);
  */
 void queue_write_lock_slowpath(struct qrwlock *lock)
 {
-	struct mcs_spinlock node;
 	u32 cnts;
 
 	/* Put the writer into the wait queue */
-	mcs_spin_lock(&lock->waitq, &node);
+	ticket_spin_lock(&lock->tickets);
 
 	/* Try to acquire the lock directly if no reader is present */
 	if (!atomic_read(&lock->cnts) &&
@@ -152,6 +153,6 @@ void queue_write_lock_slowpath(struct qr
 		arch_mutex_cpu_relax();
 	}
 unlock:
-	mcs_spin_unlock(&lock->waitq, &node);
+	ticket_spin_unlock(&lock->tickets);
 }
 EXPORT_SYMBOL(queue_write_lock_slowpath);
