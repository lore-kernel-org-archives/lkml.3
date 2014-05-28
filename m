Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaE1MMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:12:42 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:49288 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaE1MMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:12:39 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <konrad.wilk@oracle.com>, <pbonzini@redhat.com>, <gleb@redhat.com>,
        <peterz@infradead.org>, <paulmck@linux.vnet.ibm.com>
Cc: <torvalds@linux-foundation.org>, <waiman.long@hp.com>, <davej@redhat.com>,
        <oleg@redhat.com>, <x86@kernel.org>, <jeremy@goop.org>,
        <paul.gortmaker@windriver.com>, <ak@linux.intel.com>,
        <jasowang@redhat.com>, <fernando_b1@lab.ntt.co.jp>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <xen-devel@lists.xenproject.org>, <riel@redhat.com>,
        <mtosatti@redhat.com>, <chegu_vinod@hp.com>,
        <raghavendra.kt@linux.vnet.ibm.com>
Subject: [RFC] Implement Batched (group) ticket lock
Date: Wed, 28 May 2014 17:46:39 +0530
Message-Id: <1401279399-23854-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052812-7164-0000-0000-0000020D7CAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In virtualized environment there are mainly three problems
related to spinlocks that affect performance.
1. LHP (lock holder preemption)
2. Lock Waiter Preemption (LWP)
3. Starvation/fairness

 Though ticketlocks solve the fairness problem, it worsens LWP, LHP problems.
pv-ticketlocks tried to address this. But we can further improve at the
cost of relaxed fairness.

In this patch, we form a batch of eligible lock holders and we serve the eligible
(to hold the lock) batches in FIFO, but the lock-waiters within eligible batch are served
in an unfair manner. This increases probability of any eligible lock-holder being
in running state (to an average of (batch_size/2)-1). It also provides needed
bounded starvation since any lock requester can not acquire more than batch_size
times repeatedly during contention. On the negetive side we would need an extra cmpxchg.

 The patch has the batch size of 4. (As we know increasing  batch size means we are
closer to unfair locks and batch size of 1 = ticketlock).

Result:
Test system: 32cpu 2node machine w/ 64GB each (16 pcpu machine +ht).
Guests:  8GB  16vcpu guests (average of 8 iterations)

 % Improvements with kvm guests (batch size = 4):
  ebizzy_0.5x   4.3
  ebizzy_1.0x   7.8
  ebizzy_1.5x  23.4
  ebizzy_2.0x  48.6

Baremetal:
ebizzy showed very high stdev, kernbench result was good but both of them did
not show much difference.

ebizzy: rec/sec higher is better
base    50452
patched 50703

kernbench  time in sec (lesser is better)
base    48.9 sec
patched 48.8 sec

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/include/asm/spinlock.h       | 35 +++++++++++++++++++++++++----------
 arch/x86/include/asm/spinlock_types.h | 14 ++++++++++----
 arch/x86/kernel/kvm.c                 |  6 ++++--
 3 files changed, 39 insertions(+), 16 deletions(-)

TODO:
- we need an intelligent way to nullify the effect of batching for baremetal
 (because extra cmpxchg is not required).

- we may have to make batch size as kernel arg to solve above problem
 (to run same kernel for host/guest). Increasing batch size also seem to help
 virtualized guest more, so we will have flexibility of tuning depending on vm size.

- My kernbench/ebizzy test on baremetal (32 cpu +ht sandybridge) did not seem to
  show the impact of extra cmpxchg. but there should be effect of extra cmpxchg.

- virtualized guest had slight impact on 1x cases of some benchmarks but we have got
 impressive performance for >1x cases. So overall, patch needs exhaustive tesing.

- we can further add dynamically changing batch_size implementation (inspiration and
  hint by Paul McKenney) as necessary.
 
 I have found that increasing  batch size gives excellent improvements for 
 overcommitted guests. I understand that we need more exhaustive testing.

 Please provide your suggestion and comments.

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 0f62f54..87685f1 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -81,23 +81,36 @@ static __always_inline int arch_spin_value_unlocked(arch_spinlock_t lock)
  */
 static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
 {
-	register struct __raw_tickets inc = { .tail = TICKET_LOCK_INC };
+	register struct __raw_tickets inc = { .tail = TICKET_LOCK_TAIL_INC };
+	struct __raw_tickets new;
 
 	inc = xadd(&lock->tickets, inc);
-	if (likely(inc.head == inc.tail))
-		goto out;
 
 	inc.tail &= ~TICKET_SLOWPATH_FLAG;
 	for (;;) {
 		unsigned count = SPIN_THRESHOLD;
 
 		do {
-			if (ACCESS_ONCE(lock->tickets.head) == inc.tail)
-				goto out;
+			if ((inc.head & TICKET_LOCK_BATCH_MASK) == (inc.tail &
+							TICKET_LOCK_BATCH_MASK))
+				goto spin;
 			cpu_relax();
+			inc.head = ACCESS_ONCE(lock->tickets.head);
 		} while (--count);
 		__ticket_lock_spinning(lock, inc.tail);
 	}
+spin:
+	for (;;) {
+		inc.head = ACCESS_ONCE(lock->tickets.head);
+		if (!(inc.head & TICKET_LOCK_HEAD_INC)) {
+			new.head = inc.head | TICKET_LOCK_HEAD_INC;
+			if (cmpxchg(&lock->tickets.head, inc.head, new.head)
+					== inc.head)
+				goto out;
+		}
+		cpu_relax();
+	}
+
 out:	barrier();	/* make sure nothing creeps before the lock is taken */
 }
 
@@ -109,7 +122,8 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 	if (old.tickets.head != (old.tickets.tail & ~TICKET_SLOWPATH_FLAG))
 		return 0;
 
-	new.head_tail = old.head_tail + (TICKET_LOCK_INC << TICKET_SHIFT);
+	new.head_tail = old.head_tail + (TICKET_LOCK_TAIL_INC << TICKET_SHIFT);
+	new.head_tail |= TICKET_LOCK_HEAD_INC;
 
 	/* cmpxchg is a full barrier, so nothing can move before it */
 	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
@@ -123,7 +137,7 @@ static inline void __ticket_unlock_slowpath(arch_spinlock_t *lock,
 	BUILD_BUG_ON(((__ticket_t)NR_CPUS) != NR_CPUS);
 
 	/* Perform the unlock on the "before" copy */
-	old.tickets.head += TICKET_LOCK_INC;
+	old.tickets.head += TICKET_LOCK_HEAD_INC;
 
 	/* Clear the slowpath flag */
 	new.head_tail = old.head_tail & ~(TICKET_SLOWPATH_FLAG << TICKET_SHIFT);
@@ -150,14 +164,15 @@ static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 		arch_spinlock_t prev;
 
 		prev = *lock;
-		add_smp(&lock->tickets.head, TICKET_LOCK_INC);
+		add_smp(&lock->tickets.head, TICKET_LOCK_HEAD_INC);
 
 		/* add_smp() is a full mb() */
 
 		if (unlikely(lock->tickets.tail & TICKET_SLOWPATH_FLAG))
 			__ticket_unlock_slowpath(lock, prev);
 	} else
-		__add(&lock->tickets.head, TICKET_LOCK_INC, UNLOCK_LOCK_PREFIX);
+		__add(&lock->tickets.head,
+		      TICKET_LOCK_HEAD_INC, UNLOCK_LOCK_PREFIX);
 }
 
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
@@ -171,7 +186,7 @@ static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
 	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
 
-	return (__ticket_t)(tmp.tail - tmp.head) > TICKET_LOCK_INC;
+	return (__ticket_t)(tmp.tail - tmp.head) > TICKET_LOCK_TAIL_INC;
 }
 #define arch_spin_is_contended	arch_spin_is_contended
 
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 4f1bea1..b04c03d 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -3,15 +3,16 @@
 
 #include <linux/types.h>
 
+#define TICKET_LOCK_INC_SHIFT 1
+#define __TICKET_LOCK_TAIL_INC (1<<TICKET_LOCK_INC_SHIFT)
+
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
-#define __TICKET_LOCK_INC	2
 #define TICKET_SLOWPATH_FLAG	((__ticket_t)1)
 #else
-#define __TICKET_LOCK_INC	1
 #define TICKET_SLOWPATH_FLAG	((__ticket_t)0)
 #endif
 
-#if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_INC))
+#if (CONFIG_NR_CPUS < (256 / __TICKET_LOCK_TAIL_INC))
 typedef u8  __ticket_t;
 typedef u16 __ticketpair_t;
 #else
@@ -19,7 +20,12 @@ typedef u16 __ticket_t;
 typedef u32 __ticketpair_t;
 #endif
 
-#define TICKET_LOCK_INC	((__ticket_t)__TICKET_LOCK_INC)
+#define TICKET_LOCK_TAIL_INC ((__ticket_t)__TICKET_LOCK_TAIL_INC)
+
+#define TICKET_LOCK_HEAD_INC ((__ticket_t)1)
+#define TICKET_BATCH    0x4 /* 4 waiters can contend simultaneously */
+#define TICKET_LOCK_BATCH_MASK (~(TICKET_BATCH<<TICKET_LOCK_INC_SHIFT) + \
+				  TICKET_LOCK_TAIL_INC - 1)
 
 #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 0331cb3..3dd41f7 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -755,7 +755,8 @@ __visible void kvm_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 	 * check again make sure it didn't become free while
 	 * we weren't looking.
 	 */
-	if (ACCESS_ONCE(lock->tickets.head) == want) {
+	if ((ACCESS_ONCE(lock->tickets.head) & TICKET_LOCK_BATCH_MASK) ==
+				(want & TICKET_LOCK_BATCH_MASK)) {
 		add_stats(TAKEN_SLOW_PICKUP, 1);
 		goto out;
 	}
@@ -787,7 +788,8 @@ static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
 	for_each_cpu(cpu, &waiting_cpus) {
 		const struct kvm_lock_waiting *w = &per_cpu(klock_waiting, cpu);
 		if (ACCESS_ONCE(w->lock) == lock &&
-		    ACCESS_ONCE(w->want) == ticket) {
+		    (ACCESS_ONCE(w->want) & TICKET_LOCK_BATCH_MASK) ==
+			(ticket & TICKET_LOCK_BATCH_MASK)) {
 			add_stats(RELEASED_SLOW_KICKED, 1);
 			kvm_kick_cpu(cpu);
 			break;
-- 
1.7.11.7

