Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaF1JUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 05:20:30 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56312 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaF1JU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 05:20:26 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <konrad.wilk@oracle.com>, <pbonzini@redhat.com>, <gleb@redhat.com>,
        <peterz@infradead.org>, <paulmck@linux.vnet.ibm.com>,
        <torvalds@linux-foundation.org>, <waiman.long@hp.com>,
        <riel@redhat.com>
Cc: <davej@redhat.com>, <oleg@redhat.com>, <x86@kernel.org>, <jeremy@goop.org>,
        <paul.gortmaker@windriver.com>, <ak@linux.intel.com>,
        <jasowang@redhat.com>, <fernando_b1@lab.ntt.co.jp>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <xen-devel@lists.xenproject.org>, <mtosatti@redhat.com>,
        <chegu_vinod@hp.com>, <raghavendra.kt@linux.vnet.ibm.com>
Subject: [RFC PATCH v2] Implement Batched (group) ticket lock
Date: Sat, 28 Jun 2014 14:47:04 +0530
Message-Id: <1403947024-3193-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062809-1542-0000-0000-000002E88D2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In virtualized environment there are mainly three problems
related to spinlocks that affects performance.
1. LHP (lock holder preemption)
2. Lock Waiter Preemption (LWP)
3. Starvation/fairness

Though Ticketlocks solve fairness problem it worsens LWP, LHP problems. Though
pv-ticketlocks tried to address these problems we can further improve at the
 cost of relaxed fairness. The following patch tries to achieve that by grouping
(batched) ticketlocks.

Here we form a batch of eligible lock holders and we serve the eligible (to hold
the lock) batches in FIFO, but the lock-waiters within eligible batch are served
in an unfair manner. This increases probability of any eligible lock-holder being
in running state (to an average of (batch_size/2)-1) and also it provides needed
bounded starvation since any lock requester can not acquire more than batch_size
times repeatedly during contention. On the negetive side we would need an extra cmpxchg.

The patch has the batch size of 8. (As we know increasing  batch size means we are
closer to unfair locks and batch size of 1 = ticketlock).

V2 implementation has been optimized for baremetal :
(1) Making !CONFIG_PARAVIRT_SPINLOCK case equivalent to older ticketlock.
(2) Removing extra overhead of cmpxchg for CONFIG_PARAVIRT_SPINLOCK case
by replacing with add_smp call.

Result:
Test system: 32cpu 2node machine w/ 64GB each (16 pcpu machine +ht).
Guests:  8GB  16vcpu guests (average of 8 iterations)

A: batched ticket with batch_size = 4
B: batched ticket with batch_size = 8
C: qspinlock V11 of Waiman
D: qspinlock V11 of Waiman with VIRT_UNFAIR=y

 % Improvements with kvm guests
		   A      B         C         D
  ebizzy_0.5x   -0.20     1.071	   -0.07      1.39
  ebizzy_1.0x    0.83     8.89      7.89      6.08
  ebizzy_1.5x   24.11    38.39      5.42     42.56
  ebizzy_2.0x   47.77    78.49     11.94    108.14

Observations:
With increased batch_size batch ticketlock has closer performanace
to unfair locks and very promising for kvm guests that expects
high performance of unfair locks with bounded starvation property of
fair locks.

Baremetal:
No significant performnce difference even for CONFIG_PARAVIRT_SPINLOCK enabled
on baremetal

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/include/asm/spinlock.h       | 71 +++++++++++++++++++++++++++++------
 arch/x86/include/asm/spinlock_types.h | 46 ++++++++++++++++++++---
 arch/x86/kernel/kvm.c                 |  6 ++-
 arch/x86/xen/spinlock.c               |  6 ++-
 4 files changed, 107 insertions(+), 22 deletions(-)

Note:
 I tried different implementation for CONFIG_PRAVIRT enabled performance without luck
 for some time that added delay for V2 :(.

 (could not test with PeterZ's latest qspinlock which I reported)

Changes since V1:
 - Make sure no extra cmpxchg overhead for !CONFIG_PARAVIRT (it works like previous ticketlock now
   since batch size is set to 1).
 - Change TICKET_LOCK_INC_SHIFT back to 0 in !CONFIG_PARAVIRT case (Rik).
 - Add build check to make sure TICKET_BATCH is power of 2 (Rik).
 - Replace extra cmpxchg with add_smp for CONFIG_PARAVIRT enabled case in host (Waiman, Linus.. had concernes).
 - Correct TICKET_LOCK_BATCH_MASK to suit all TAIL_INC  (expression given by Waiman).
 - Add comment on LOCK bit (Waiman).
 - Add Xen support (Completely untested).

TODO: (But none of the below imply shortcoming of current patch)
- we can further add dynamically changing batch_size (to 1 and MAX size)
  implementation (inspiration and hint by Paul McKenney) as necessary.

- I have found that increasing  batch size gives excellent improvements for
 overcommitted guests. As Rik pointed we may want to further increase batch_size
 but we need its (side) effect on bigger machine for undercommit cases.

- Should we enable it for baremetal too? (As Rik pointed, exploiting NUMA may
  give more performance)

- Should we have config option for batch_size?

 I would like to thank Rik, Waiman for their review and valuable feedback for V1.
 Please provide your suggestion and comments.

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 54f1c80..cfb78e6 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -8,6 +8,7 @@
 #include <linux/compiler.h>
 #include <asm/paravirt.h>
 #include <asm/bitops.h>
+#include <linux/bug.h>
 
 /*
  * Your basic SMP spinlocks, allowing only a single CPU anywhere
@@ -49,7 +50,42 @@ static inline void __ticket_enter_slowpath(arch_spinlock_t *lock)
 	set_bit(0, (volatile unsigned long *)&lock->tickets.tail);
 }
 
+static int __ticket_lock_get_batch_mask(void)
+{
+	if (static_key_false(&paravirt_ticketlocks_enabled))
+		return TICKET_BATCH_MASK;
+	else
+		return TICKET_BATCH_MASK_NATIVE;
+}
+
+static void __ticket_lock_batch_spin(arch_spinlock_t *lock, __ticket_t ticket)
+{
+	if (static_key_false(&paravirt_ticketlocks_enabled)) {
+		register struct __raw_tickets inc, new;
+
+		inc.head = ACCESS_ONCE(lock->tickets.head);
+		barrier();
+		for (;;) {
+			if (!(inc.head & TICKET_LOCK_LOCK_INC)) {
+				new.head = inc.head | TICKET_LOCK_LOCK_INC;
+				if (cmpxchg(&lock->tickets.head, inc.head,
+							new.head) == inc.head)
+					break;
+			}
+			cpu_relax();
+			inc.head = ACCESS_ONCE(lock->tickets.head);
+		}
+	} else {
+		add_smp(&lock->tickets.head, TICKET_LOCK_UNLOCK_INC);
+	}
+}
+
 #else  /* !CONFIG_PARAVIRT_SPINLOCKS */
+static inline void __ticket_lock_batch_spin(arch_spinlock_t *lock,
+							__ticket_t ticket)
+{
+}
+
 static __always_inline void __ticket_lock_spinning(arch_spinlock_t *lock,
 							__ticket_t ticket)
 {
@@ -59,6 +95,10 @@ static inline void __ticket_unlock_kick(arch_spinlock_t *lock,
 {
 }
 
+static inline int __ticket_lock_get_batch_mask(void)
+{
+	return TICKET_BATCH_MASK_NATIVE;
+}
 #endif /* CONFIG_PARAVIRT_SPINLOCKS */
 
 static __always_inline int arch_spin_value_unlocked(arch_spinlock_t lock)
@@ -81,24 +121,28 @@ static __always_inline int arch_spin_value_unlocked(arch_spinlock_t lock)
  */
 static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
 {
-	register struct __raw_tickets inc = { .tail = TICKET_LOCK_INC };
+	register struct __raw_tickets inc = { .tail = TICKET_LOCK_TAIL_INC };
 
+	check_sane_mask();
 	inc = xadd(&lock->tickets, inc);
-	if (likely(inc.head == inc.tail))
-		goto out;
 
 	inc.tail &= ~TICKET_SLOWPATH_FLAG;
 	for (;;) {
 		unsigned count = SPIN_THRESHOLD;
+		unsigned batchmask = __ticket_lock_get_batch_mask();
 
 		do {
-			if (ACCESS_ONCE(lock->tickets.head) == inc.tail)
-				goto out;
+			inc.head = ACCESS_ONCE(lock->tickets.head);
+			if ((inc.head & batchmask) == (inc.tail & batchmask))
+				goto spin;
 			cpu_relax();
 		} while (--count);
 		__ticket_lock_spinning(lock, inc.tail);
 	}
-out:	barrier();	/* make sure nothing creeps before the lock is taken */
+spin:
+	__ticket_lock_batch_spin(lock, inc.tail);
+
+	barrier();	/* make sure nothing creeps before the lock is taken */
 }
 
 static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
@@ -109,10 +153,12 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 	if (old.tickets.head != (old.tickets.tail & ~TICKET_SLOWPATH_FLAG))
 		return 0;
 
-	new.head_tail = old.head_tail + (TICKET_LOCK_INC << TICKET_SHIFT);
+	new.head_tail = old.head_tail + (TICKET_LOCK_TAIL_INC << TICKET_SHIFT);
+	new.head_tail |= TICKET_LOCK_LOCK_INC;
 
 	/* cmpxchg is a full barrier, so nothing can move before it */
-	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
+	return cmpxchg(&lock->head_tail, old.head_tail,
+					new.head_tail) == old.head_tail;
 }
 
 static inline void __ticket_unlock_slowpath(arch_spinlock_t *lock,
@@ -123,7 +169,7 @@ static inline void __ticket_unlock_slowpath(arch_spinlock_t *lock,
 	BUILD_BUG_ON(((__ticket_t)NR_CPUS) != NR_CPUS);
 
 	/* Perform the unlock on the "before" copy */
-	old.tickets.head += TICKET_LOCK_INC;
+	old.tickets.head += TICKET_LOCK_UNLOCK_INC;
 
 	/* Clear the slowpath flag */
 	new.head_tail = old.head_tail & ~(TICKET_SLOWPATH_FLAG << TICKET_SHIFT);
@@ -150,14 +196,15 @@ static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 		arch_spinlock_t prev;
 
 		prev = *lock;
-		add_smp(&lock->tickets.head, TICKET_LOCK_INC);
+		add_smp(&lock->tickets.head, TICKET_LOCK_UNLOCK_INC);
 
 		/* add_smp() is a full mb() */
 
 		if (unlikely(lock->tickets.tail & TICKET_SLOWPATH_FLAG))
 			__ticket_unlock_slowpath(lock, prev);
 	} else
-		__add(&lock->tickets.head, TICKET_LOCK_INC, UNLOCK_LOCK_PREFIX);
+		__add(&lock->tickets.head, TICKET_LOCK_UNLOCK_INC,
+						UNLOCK_LOCK_PREFIX);
 }
 
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
@@ -171,7 +218,7 @@ static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
 	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-	return (__ticket_t)(tmp.tail - tmp.head) > TICKET_LOCK_INC;
+	return (__ticket_t)(tmp.tail - tmp.head) > TICKET_LOCK_UNLOCK_INC;
 }
 #define arch_spin_is_contended	arch_spin_is_contended
 
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 73c4c00..339ddf8 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -3,15 +3,16 @@
 
 #include <linux/types.h>
 
+
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
-#define __TICKET_LOCK_INC	2
-#define TICKET_SLOWPATH_FLAG	((__ticket_t)1)
+#define TICKET_LOCK_INC_SHIFT		1
+#define __TICKET_LOCK_TAIL_INC		(1<<TICKET_LOCK_INC_SHIFT)
 #else
-#define __TICKET_LOCK_INC	1
-#define TICKET_SLOWPATH_FLAG	((__ticket_t)0)
+#define TICKET_LOCK_INC_SHIFT		0
+#define __TICKET_LOCK_TAIL_INC		(1<<TICKET_LOCK_INC_SHIFT)
 #endif
 
-#if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_INC))
+#if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_TAIL_INC))
 typedef u8  __ticket_t;
 typedef u16 __ticketpair_t;
 #else
@@ -19,7 +20,40 @@ typedef u16 __ticket_t;
 typedef u32 __ticketpair_t;
 #endif
 
-#define TICKET_LOCK_INC	((__ticket_t)__TICKET_LOCK_INC)
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+/*
+ * Batched ticketlock: 2n bits in lock is divided as follows:
+ * ---------------------------------------------------------------
+ * |          tail                     |    head                 |
+ * ---------------------------------------------------------------
+ * | TAIL (n-1) | SLOWPATH_FLAG (1bit) | HEAD (n-1) | LOCK (1bit)|
+ * ---------------------------------------------------------------
+ *
+ * batch_size determines maximum number of cpus contending for lock at any time.
+ * (n-1)-log(batch_size) bits of head and tail determine eligibility for
+ * contending for lock.
+ * SLOWPATH_FLAG in tail indicates contention that is used for spin optimization
+ * in guests.
+ * LOCK bit in head determines whether lock is available.
+ */
+#define TICKET_SLOWPATH_FLAG		((__ticket_t)1)
+#define TICKET_LOCK_LOCK_INC		((__ticket_t)1)
+#define TICKET_LOCK_UNLOCK_INC		((__ticket_t)1)
+#define TICKET_BATCH_MASK_NATIVE (~(TICKET_BATCH_NATIVE<<TICKET_LOCK_INC_SHIFT)+1)
+#else
+#define TICKET_SLOWPATH_FLAG		((__ticket_t)0)
+#define TICKET_LOCK_LOCK_INC		((__ticket_t)0)
+#define TICKET_LOCK_UNLOCK_INC		((__ticket_t)1)
+#define TICKET_BATCH_MASK_NATIVE (~(TICKET_BATCH_NATIVE<<TICKET_LOCK_INC_SHIFT)+1)
+#endif
+
+#define TICKET_LOCK_TAIL_INC	((__ticket_t)__TICKET_LOCK_TAIL_INC)
+#define TICKET_BATCH		8  /* 8 waiters can contend simultaneously */
+#define TICKET_BATCH_NATIVE	1
+#define TICKET_BATCH_MASK	(~(TICKET_BATCH<<TICKET_LOCK_INC_SHIFT) + 1)
+
+/* Ensure batch_size is always power of two */
+#define check_sane_mask()	BUILD_BUG_ON((TICKET_BATCH & (TICKET_BATCH-1)) > 1)
 
 #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 3dd8e2c..28e4492 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -757,7 +757,8 @@ __visible void kvm_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 	 * check again make sure it didn't become free while
 	 * we weren't looking.
 	 */
-	if (ACCESS_ONCE(lock->tickets.head) == want) {
+	if ((ACCESS_ONCE(lock->tickets.head) & TICKET_BATCH_MASK) ==
+				(want & TICKET_BATCH_MASK)) {
 		add_stats(TAKEN_SLOW_PICKUP, 1);
 		goto out;
 	}
@@ -789,7 +790,8 @@ static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
 	for_each_cpu(cpu, &waiting_cpus) {
 		const struct kvm_lock_waiting *w = &per_cpu(klock_waiting, cpu);
 		if (ACCESS_ONCE(w->lock) == lock &&
-		    ACCESS_ONCE(w->want) == ticket) {
+		    (ACCESS_ONCE(w->want) & TICKET_BATCH_MASK) ==
+			(ticket & TICKET_BATCH_MASK)) {
 			add_stats(RELEASED_SLOW_KICKED, 1);
 			kvm_kick_cpu(cpu);
 			break;
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 0ba5f3b..8d83510 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -163,7 +163,8 @@ __visible void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 	 * check again make sure it didn't become free while
 	 * we weren't looking
 	 */
-	if (ACCESS_ONCE(lock->tickets.head) == want) {
+	if ((ACCESS_ONCE(lock->tickets.head) & TICKET_BATCH_MASK) ==
+				(want & TICKET_BATCH_MASK)) {
 		add_stats(TAKEN_SLOW_PICKUP, 1);
 		goto out;
 	}
@@ -205,7 +206,8 @@ static void xen_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
 
 		/* Make sure we read lock before want */
 		if (ACCESS_ONCE(w->lock) == lock &&
-		    ACCESS_ONCE(w->want) == next) {
+		    ((ACCESS_ONCE(w->want) & TICKET_BATCH_MASK) ==
+						(next & TICKET_BATCH_MASK))) {
 			add_stats(RELEASED_SLOW_KICKED, 1);
 			xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
 			break;
-- 
1.7.11.7

