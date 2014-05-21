Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaEURDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:03:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaEURDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:03:18 -0400
Date: Wed, 21 May 2014 19:02:27 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [RFC 08/07] qspinlock: integrate pending bit into queue
Message-ID: <20140521170226.GA9241@potion.brq.redhat.com>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-4-git-send-email-Waiman.Long@hp.com>
 <20140512152208.GA12309@potion.brq.redhat.com>
 <537276B4.10209@hp.com>
 <20140514165121.GA21370@potion.redhat.com>
 <20140514170016.GW30445@twins.programming.kicks-ass.net>
 <20140514191339.GA22813@potion.brq.redhat.com>
 <537A66D3.8070607@hp.com>
 <20140521164930.GA26199@potion.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140521164930.GA26199@potion.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-21 18:49+0200, Radim Krčmář:
> 2014-05-19 16:17-0400, Waiman Long:
> >       As for now, I will focus on just having one pending bit.
> 
> I'll throw some ideas at it,

One of the ideas follows; it seems sound, but I haven't benchmarked it
thoroughly. (Wasted a lot of time by writing/playing with various tools
and loads.)

Dbench on ext4 ramdisk, hackbench and ebizzy have shown a small
improvement in performance, but my main drive was the weird design of
Pending Bit.
Does your setup yield improvements too?
(A minor code swap noted in the patch might help things.)

It is meant to be aplied on top of first 7 patches, because the virt
stuff would just get in the way.
I have preserved a lot of dead code and made some questionable decisions
just to keep the diff short and in one patch, sorry about that.

(It is work in progress, double slashed lines mark points of interest.)

---8<---
Pending Bit wasn't used if we already had a node queue with one cpu,
which meant that we suffered from these drawbacks again:
 - unlock path was more complicated
   (last queued CPU had to clear the tail)
 - cold node cacheline was just one critical section away

With this patch, Pending Bit is used as an additional step in the queue.
Waiting for lock is the same: we try Pending Bit and if it is taken, we
append to Node Queue.
Unlock is different: pending CPU moves into critical section and first
CPU from Node Queue takes Pending Bit and notifies next in line or
clears the tail.

This allows the pending CPU to take the lock as fast as possible,
because all bookkeeping was done when entering Pending Queue.
Node Queue operations can also be slower without affecting the
performance, because we have an additional buffer of one critical
section.
---
 kernel/locking/qspinlock.c | 180 +++++++++++++++++++++++++++++++++------------
 1 file changed, 135 insertions(+), 45 deletions(-)

diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 0ee1a23..76cafb0 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -98,7 +98,10 @@ struct __qspinlock {
 	union {
 		atomic_t val;
 #ifdef __LITTLE_ENDIAN
-		u8	 locked;
+		struct {
+			u8	locked;
+			u8	pending;
+		};
 		struct {
 			u16	locked_pending;
 			u16	tail;
@@ -109,7 +112,8 @@ struct __qspinlock {
 			u16	locked_pending;
 		};
 		struct {
-			u8	reserved[3];
+			u8	reserved[2];
+			u8	pending;
 			u8	locked;
 		};
 #endif
@@ -314,6 +318,59 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
 	return 1;
 }
 
+// nice comment here
+static inline bool trylock(struct qspinlock *lock, u32 *val) {
+	if (!(*val = atomic_read(&lock->val)) &&
+	   (atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL) == 0)) {
+		*val = _Q_LOCKED_VAL;
+		return 1;
+	}
+	return 0;
+}
+
+// here
+static inline bool trypending(struct qspinlock *lock, u32 *pval) {
+	u32 old, val = *pval;
+	// optimizer might produce the same code if we use *pval directly
+
+	// we could use 'if' and a xchg that touches only the pending bit to
+	// save some cycles at the price of a longer line cutting window
+	// (and I think it would bug without changing the rest)
+	while (!(val & (_Q_PENDING_MASK | _Q_TAIL_MASK))) {
+		old = atomic_cmpxchg(&lock->val, val, val | _Q_PENDING_MASK);
+		if (old == val) {
+			*pval = val | _Q_PENDING_MASK;
+			return 1;
+		}
+		val = old;
+	}
+	*pval = val;
+	return 0;
+}
+
+// here
+static inline void set_pending(struct qspinlock *lock, u8 pending)
+{
+	struct __qspinlock *l = (void *)lock;
+
+	// take a look if this is necessary, and if we don't have an
+	// abstraction already
+	barrier();
+	ACCESS_ONCE(l->pending) = pending;
+	barrier();
+}
+
+// and here
+static inline u32 cmpxchg_tail(struct qspinlock *lock, u32 tail, u32 newtail)
+// API-incompatible with set_pending and the shifting is ugly, so I'd rather
+// refactor this one, xchg_tail() and encode_tail() ... another day
+{
+	struct __qspinlock *l = (void *)lock;
+
+	return (u32)cmpxchg(&l->tail, tail >> _Q_TAIL_OFFSET,
+	                    newtail >> _Q_TAIL_OFFSET) << _Q_TAIL_OFFSET;
+}
+
 /**
  * queue_spin_lock_slowpath - acquire the queue spinlock
  * @lock: Pointer to queue spinlock structure
@@ -324,21 +381,21 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
  *              fast     :    slow                                  :    unlock
  *                       :                                          :
  * uncontended  (0,0,0) -:--> (0,0,1) ------------------------------:--> (*,*,0)
- *                       :       | ^--------.------.             /  :
- *                       :       v           \      \            |  :
- * pending               :    (0,1,1) +--> (0,1,0)   \           |  :
- *                       :       | ^--'              |           |  :
- *                       :       v                   |           |  :
- * uncontended           :    (n,x,y) +--> (n,0,0) --'           |  :
+ *                       :       | ^--------.                    /  :
+ *                       :       v           \                   |  :
+ * pending               :    (0,1,1) +--> (0,1,0)               |  :
+ *                       :       | ^--'         ^----------.     |  :
+ *                       :       v                         |     |  :
+ * uncontended           :    (n,x,y) +--> (n,0,y) ---> (0,1,y)  |  :
  *   queue               :       | ^--'                          |  :
  *                       :       v                               |  :
- * contended             :    (*,x,y) +--> (*,0,0) ---> (*,0,1) -'  :
- *   queue               :         ^--'                             :
- *
- * The pending bit processing is in the trylock_pending() function
- * whereas the uncontended and contended queue processing is in the
- * queue_spin_lock_slowpath() function.
+ * contended             :    (*,x,y) +--> (*,0,y)      (*,0,1) -'  :
+ *   queue               :         ^--'       |            ^        :
+ *                       :                    v            |        :
+ *                       :                 (*,1,y) ---> (*,1,0)     :
+ * // diagram might be wrong (and definitely isn't obvious)
  *
+ * // give some insight about the hybrid locking
  */
 void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 {
@@ -348,8 +405,20 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 
 	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
 
-	if (trylock_pending(lock, &val))
-		return;	/* Lock acquired */
+	/*
+	 * Check if nothing changed while we were calling this function.
+	 * (Cold code cacheline could have delayed us.)
+	 */
+	// this should go into a separate patch with micro-optimizations
+	if (trylock(lock, &val))
+		return;
+	/*
+	 * The lock is still held, wait without touching the node unless there
+	 * is at least one cpu waiting before us.
+	 */
+	// create structured code out of this mess
+	if (trypending(lock, &val))
+		goto pending;
 
 	node = this_cpu_ptr(&mcs_nodes[0]);
 	idx = node->count++;
@@ -364,15 +433,18 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	 * attempt the trylock once more in the hope someone let go while we
 	 * weren't watching.
 	 */
-	if (queue_spin_trylock(lock))
+	// is some of the re-checking counterproductive?
+	if (trylock(lock, &val)) {
+		this_cpu_dec(mcs_nodes[0].count); // ugly
+		return;
+	}
+	if (trypending(lock, &val))
 		goto release;
 
 	/*
-	 * we already touched the queueing cacheline; don't bother with pending
-	 * stuff.
-	 *
 	 * p,*,* -> n,*,*
 	 */
+	// racing for pending/queue till here; safe
 	old = xchg_tail(lock, tail, &val);
 
 	/*
@@ -386,41 +458,45 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	}
 
 	/*
-	 * we're at the head of the waitqueue, wait for the owner & pending to
-	 * go away.
-	 * Load-acquired is used here because the get_qlock()
-	 * function below may not be a full memory barrier.
-	 *
-	 * *,x,y -> *,0,0
+	 * We are now waiting for the pending bit to get cleared.
 	 */
-	while ((val = smp_load_acquire(&lock->val.counter))
-				       & _Q_LOCKED_PENDING_MASK)
+	// make a get_pending(lock, &val) helper
+	while ((val = smp_load_acquire(&lock->val.counter)) & _Q_PENDING_MASK)
+		// would longer body ease cacheline contention?
+		// would it be better to use monitor/mwait instead?
+		// (we can tolerate some delay because we aren't pending ...)
 		arch_mutex_cpu_relax();
 
 	/*
-	 * claim the lock:
+	 * The pending bit is free, take it.
 	 *
-	 * n,0,0 -> 0,0,1 : lock, uncontended
-	 * *,0,0 -> *,0,1 : lock, contended
+	 * *,0,* -> *,1,*
+	 */
+	// might add &val param and do |= _Q_PENDING_VAL when refactoring ...
+	set_pending(lock, 1);
+
+	/*
+	 * Clear the tail if noone queued after us.
 	 *
-	 * If the queue head is the only one in the queue (lock value == tail),
-	 * clear the tail code and grab the lock. Otherwise, we only need
-	 * to grab the lock.
+	 * n,1,y -> 0,1,y
 	 */
-	for (;;) {
-		if (val != tail) {
-			get_qlock(lock);
-			break;
-		}
-		old = atomic_cmpxchg(&lock->val, val, _Q_LOCKED_VAL);
-		if (old == val)
-			goto release;	/* No contention */
+	if ((val & _Q_TAIL_MASK) == tail &&
+	    cmpxchg_tail(lock, tail, 0) == tail)
+		goto release;
+	// negate the condition and obliterate the goto with braces
 
-		val = old;
-	}
+	// fun fact:
+	//  if ((val & _Q_TAIL_MASK) == tail) {
+	//  	val = cmpxchg_tail(&lock, tail, 0);
+	//  	if ((val & _Q_TAIL_MASK) == tail)
+	//  		goto release;
+	// produced significantly faster code in my benchmarks ...
+	// (I haven't looked why, seems like a fluke.)
+	// swap the code if you want performance at any cost
 
 	/*
-	 * contended path; wait for next, release.
+	 * Tell the next node that we are pending, so it can start spinning to
+	 * replace us in the future.
 	 */
 	while (!(next = ACCESS_ONCE(node->next)))
 		arch_mutex_cpu_relax();
@@ -432,5 +508,19 @@ release:
 	 * release the node
 	 */
 	this_cpu_dec(mcs_nodes[0].count);
+pending:
+	/*
+	 * we're at the head of the waitqueue, wait for the owner to go away.
+	 * Flip pending and locked bit then.
+	 *
+	 * *,1,0 -> *,0,1
+	 */
+	while ((val = smp_load_acquire(&lock->val.counter)) & _Q_LOCKED_MASK)
+		arch_mutex_cpu_relax();
+	clear_pending_set_locked(lock, val);
+
+	/*
+	 * We have the lock.
+	 */
 }
 EXPORT_SYMBOL(queue_spin_lock_slowpath);
-- 
1.9.0

