Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3BRM4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 07:56:55 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:35851 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab3BRMlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 07:41:07 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v6 05/46] percpu_rwlock: Make percpu-rwlocks IRQ-safe,
 optimally
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, rjw@sisk.pl, sbw@mit.edu,
        fweisbec@gmail.com, linux@arm.linux.org.uk, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        walken@google.com, vincent.guittot@linaro.org
Date: Mon, 18 Feb 2013 18:09:01 +0530
Message-ID: <20130218123901.26245.80637.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com>
References: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021812-4790-0000-0000-000006F5F0AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If interrupt handlers can also be readers, then one of the ways to make
per-CPU rwlocks safe, is to disable interrupts at the reader side before
trying to acquire the per-CPU rwlock and keep it disabled throughout the
duration of the read-side critical section.

The goal is to avoid cases such as:

  1. writer is active and it holds the global rwlock for write

  2. a regular reader comes in and marks itself as present (by incrementing
     its per-CPU refcount) before checking whether writer is active.

  3. an interrupt hits the reader;
     [If it had not hit, the reader would have noticed that the writer is
      active and would have decremented its refcount and would have tried
      to acquire the global rwlock for read].
     Since the interrupt handler also happens to be a reader, it notices
     the non-zero refcount (which was due to the reader who got interrupted)
     and thinks that this is a nested read-side critical section and
     proceeds to take the fastpath, which is wrong. The interrupt handler
     should have noticed that the writer is active and taken the rwlock
     for read.

So, disabling interrupts can help avoid this problem (at the cost of keeping
the interrupts disabled for quite long).

But Oleg had a brilliant idea by which we can do much better than that:
we can manage with disabling interrupts _just_ during the updates (writes to
per-CPU refcounts) to safe-guard against races with interrupt handlers.
Beyond that, we can keep the interrupts enabled and still be safe w.r.t
interrupt handlers that can act as readers.

Basically the idea is that we differentiate between the *part* of the
per-CPU refcount that we use for reference counting vs the part that we use
merely to make the writer wait for us to switch over to the right
synchronization scheme.

The scheme involves splitting the per-CPU refcounts into 2 parts:
eg: the lower 16 bits are used to track the nesting depth of the reader
(a "nested-counter"), and the remaining (upper) bits are used to merely mark
the presence of the reader.

As long as the overall reader_refcnt is non-zero, the writer waits for the
reader (assuming that the reader is still actively using per-CPU refcounts for
synchronization).

The reader first sets one of the higher bits to mark its presence, and then
uses the lower 16 bits to manage the nesting depth. So, an interrupt handler
coming in as illustrated above will be able to distinguish between "this is
a nested read-side critical section" vs "we have merely marked our presence
to make the writer wait for us to switch" by looking at the same refcount.
Thus, it makes it unnecessary to keep interrupts disabled throughout the
read-side critical section, despite having the possibility of interrupt
handlers being readers themselves.


Implement this logic and rename the locking functions appropriately, to
reflect what they do.

Based-on-idea-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/percpu-rwlock.h |   10 ++++---
 lib/percpu-rwlock.c           |   57 ++++++++++++++++++++++++++---------------
 2 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/include/linux/percpu-rwlock.h b/include/linux/percpu-rwlock.h
index 5590b1e..8c9e145 100644
--- a/include/linux/percpu-rwlock.h
+++ b/include/linux/percpu-rwlock.h
@@ -38,11 +38,13 @@ struct percpu_rwlock {
 	rwlock_t			global_rwlock;
 };
 
-extern void percpu_read_lock(struct percpu_rwlock *);
-extern void percpu_read_unlock(struct percpu_rwlock *);
+extern void percpu_read_lock_irqsafe(struct percpu_rwlock *);
+extern void percpu_read_unlock_irqsafe(struct percpu_rwlock *);
 
-extern void percpu_write_lock(struct percpu_rwlock *);
-extern void percpu_write_unlock(struct percpu_rwlock *);
+extern void percpu_write_lock_irqsave(struct percpu_rwlock *,
+				      unsigned long *flags);
+extern void percpu_write_unlock_irqrestore(struct percpu_rwlock *,
+					   unsigned long *flags);
 
 extern int __percpu_init_rwlock(struct percpu_rwlock *,
 				const char *, struct lock_class_key *);
diff --git a/lib/percpu-rwlock.c b/lib/percpu-rwlock.c
index edefdea..ce7e440 100644
--- a/lib/percpu-rwlock.c
+++ b/lib/percpu-rwlock.c
@@ -30,11 +30,15 @@
 #include <asm/processor.h>
 
 
+#define READER_PRESENT		(1UL << 16)
+#define READER_REFCNT_MASK	(READER_PRESENT - 1)
+
 #define reader_yet_to_switch(pcpu_rwlock, cpu)				    \
 	(ACCESS_ONCE(per_cpu_ptr((pcpu_rwlock)->rw_state, cpu)->reader_refcnt))
 
-#define reader_percpu_nesting_depth(pcpu_rwlock)		  \
-	(__this_cpu_read((pcpu_rwlock)->rw_state->reader_refcnt))
+#define reader_percpu_nesting_depth(pcpu_rwlock)			\
+	(__this_cpu_read((pcpu_rwlock)->rw_state->reader_refcnt) &	\
+	 READER_REFCNT_MASK)
 
 #define reader_uses_percpu_refcnt(pcpu_rwlock)				\
 				reader_percpu_nesting_depth(pcpu_rwlock)
@@ -71,7 +75,7 @@ void percpu_free_rwlock(struct percpu_rwlock *pcpu_rwlock)
 	pcpu_rwlock->rw_state = NULL;
 }
 
-void percpu_read_lock(struct percpu_rwlock *pcpu_rwlock)
+void percpu_read_lock_irqsafe(struct percpu_rwlock *pcpu_rwlock)
 {
 	preempt_disable();
 
@@ -79,14 +83,18 @@ void percpu_read_lock(struct percpu_rwlock *pcpu_rwlock)
 	 * Let the writer know that a reader is active, even before we choose
 	 * our reader-side synchronization scheme.
 	 */
-	this_cpu_inc(pcpu_rwlock->rw_state->reader_refcnt);
+	this_cpu_add(pcpu_rwlock->rw_state->reader_refcnt, READER_PRESENT);
 
 	/*
 	 * If we are already using per-cpu refcounts, it is not safe to switch
 	 * the synchronization scheme. So continue using the refcounts.
 	 */
-	if (reader_nested_percpu(pcpu_rwlock))
+	if (reader_uses_percpu_refcnt(pcpu_rwlock)) {
+		this_cpu_inc(pcpu_rwlock->rw_state->reader_refcnt);
+		this_cpu_sub(pcpu_rwlock->rw_state->reader_refcnt,
+			     READER_PRESENT);
 		return;
+	}
 
 	/*
 	 * The write to 'reader_refcnt' must be visible before we read
@@ -95,9 +103,19 @@ void percpu_read_lock(struct percpu_rwlock *pcpu_rwlock)
 	smp_mb();
 
 	if (likely(!writer_active(pcpu_rwlock))) {
-		goto out;
+		this_cpu_inc(pcpu_rwlock->rw_state->reader_refcnt);
 	} else {
 		/* Writer is active, so switch to global rwlock. */
+
+		/*
+		 * While we are spinning on ->global_rwlock, an
+		 * interrupt can hit us, and the interrupt handler
+		 * might call this function. The distinction between
+		 * READER_PRESENT and the refcnt helps ensure that the
+		 * interrupt handler also takes this branch and spins
+		 * on the ->global_rwlock, as long as the writer is
+		 * active.
+		 */
 		read_lock(&pcpu_rwlock->global_rwlock);
 
 		/*
@@ -107,29 +125,24 @@ void percpu_read_lock(struct percpu_rwlock *pcpu_rwlock)
 		 * refcounts. (This also helps avoid heterogeneous nesting of
 		 * readers).
 		 */
-		if (writer_active(pcpu_rwlock)) {
-			/*
-			 * The above writer_active() check can get reordered
-			 * with this_cpu_dec() below, but this is OK, because
-			 * holding the rwlock is conservative.
-			 */
-			this_cpu_dec(pcpu_rwlock->rw_state->reader_refcnt);
-		} else {
+		if (!writer_active(pcpu_rwlock)) {
+			this_cpu_inc(pcpu_rwlock->rw_state->reader_refcnt);
 			read_unlock(&pcpu_rwlock->global_rwlock);
 		}
 	}
 
-out:
+	this_cpu_sub(pcpu_rwlock->rw_state->reader_refcnt, READER_PRESENT);
+
 	/* Prevent reordering of any subsequent reads/writes */
 	smp_mb();
 }
 
-void percpu_read_unlock(struct percpu_rwlock *pcpu_rwlock)
+void percpu_read_unlock_irqsafe(struct percpu_rwlock *pcpu_rwlock)
 {
 	/*
 	 * We never allow heterogeneous nesting of readers. So it is trivial
 	 * to find out the kind of reader we are, and undo the operation
-	 * done by our corresponding percpu_read_lock().
+	 * done by our corresponding percpu_read_lock_irqsafe().
 	 */
 
 	/* Try to fast-path: a nested percpu reader is the simplest case */
@@ -158,7 +171,8 @@ void percpu_read_unlock(struct percpu_rwlock *pcpu_rwlock)
 	preempt_enable();
 }
 
-void percpu_write_lock(struct percpu_rwlock *pcpu_rwlock)
+void percpu_write_lock_irqsave(struct percpu_rwlock *pcpu_rwlock,
+			       unsigned long *flags)
 {
 	unsigned int cpu;
 
@@ -187,10 +201,11 @@ void percpu_write_lock(struct percpu_rwlock *pcpu_rwlock)
 	}
 
 	smp_mb(); /* Complete the wait-for-readers, before taking the lock */
-	write_lock(&pcpu_rwlock->global_rwlock);
+	write_lock_irqsave(&pcpu_rwlock->global_rwlock, *flags);
 }
 
-void percpu_write_unlock(struct percpu_rwlock *pcpu_rwlock)
+void percpu_write_unlock_irqrestore(struct percpu_rwlock *pcpu_rwlock,
+				    unsigned long *flags)
 {
 	unsigned int cpu;
 
@@ -205,6 +220,6 @@ void percpu_write_unlock(struct percpu_rwlock *pcpu_rwlock)
 	for_each_possible_cpu(cpu)
 		per_cpu_ptr(pcpu_rwlock->rw_state, cpu)->writer_signal = false;
 
-	write_unlock(&pcpu_rwlock->global_rwlock);
+	write_unlock_irqrestore(&pcpu_rwlock->global_rwlock, *flags);
 }
 

