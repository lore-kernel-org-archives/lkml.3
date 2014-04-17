Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaDQPHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:07:25 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:43490 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaDQPFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:05:01 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v9 17/19] pvqspinlock: Add qspinlock para-virtualization support
Date: Thu, 17 Apr 2014 11:04:09 -0400
Message-Id: <1397747051-15401-18-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds base para-virtualization support to the queue
spinlock in the same way as was done in the PV ticket lock code. In
essence, the lock waiters will spin for a specified number of times
(QSPIN_THRESHOLD = 2^14) and then halted itself. The queue head waiter,
unlike the other waiter, will spins 2*QSPIN_THRESHOLD times before
halting itself.  Before being halted, the queue head waiter will set
a flag (_Q_LOCKED_SLOWPATH) in the lock byte to indicate that the
unlock slowpath has to be invoked.

In the unlock slowpath, the current lock holder will find the queue
head by following the previous node pointer links stored in the queue
node structure until it finds one that has the qhead flag turned
on. It then attempt to kick in the CPU of the queue head.

After the queue head acquired the lock, it will also check the status
of the next node and set _Q_LOCKED_SLOWPATH flag if it has been halted.

Enabling the PV code does have a performance impact on spinlock
acquisitions and releases. The following table shows the execution
time (in ms) of a spinlock micro-benchmark that does lock/unlock
operations 5M times for each task versus the number of contending
tasks on a Westmere-EX system.

  # of        Ticket lock	     Queue lock
  tasks   PV off/PV on/%Change 	  PV off/PV on/%Change
  ------  --------------------   ---------------------
    1	     135/  179/+33%	     137/  168/+23%
    2	    1045/ 1103/ +6%	    1161/ 1248/ +7%
    3	    1827/ 2683/+47%	    2357/ 2600/+10%
    4       2689/ 4191/+56%	    2882/ 3115/ +8%
    5       3736/ 5830/+56%	    3493/ 3571/ +2%
    6       4942/ 7609/+54%	    4239/ 4198/ -1%
    7       6304/ 9570/+52%	    4931/ 4895/ -1%
    8       7736/11323/+46%	    5632/ 5588/ -1%

It can be seen that the ticket lock PV code has a fairly big decrease
in performance when there are 3 or more contending tasks. The queue
spinlock PV code, on the other hand, only has a relatively minor drop
in performance for with 1-4 contending tasks. With 5 or more contending
tasks, there is practically no difference in performance. When coupled
with unfair lock, the queue spinlock can be much faster than the PV
ticket lock.

When both the unfair lock and PV spinlock features is turned on,
lock stealing will still be allowed in the fastpath, but not in
the slowpath.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/include/asm/pvqspinlock.h |  306 ++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/qspinlock.h   |   33 ++++
 kernel/locking/qspinlock.c         |   91 ++++++++++-
 3 files changed, 427 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/include/asm/pvqspinlock.h

diff --git a/arch/x86/include/asm/pvqspinlock.h b/arch/x86/include/asm/pvqspinlock.h
new file mode 100644
index 0000000..fea21aa
--- /dev/null
+++ b/arch/x86/include/asm/pvqspinlock.h
@@ -0,0 +1,306 @@
+#ifndef _ASM_X86_PVQSPINLOCK_H
+#define _ASM_X86_PVQSPINLOCK_H
+
+/*
+ *	Queue Spinlock Para-Virtualization (PV) Support
+ *
+ *	+------+	    +-----+   next     +----+
+ *	| Lock |	    |Queue|----------->|Next|
+ *	|Holder|<-----------|Head |<-----------|Node|
+ *	+------+ prev_tail  +-----+ prev_tail  +----+
+ *
+ * The PV support code for queue spinlock is roughly the same as that
+ * of the ticket spinlock. Each CPU waiting for the lock will spin until it
+ * reaches a threshold. When that happens, it will put itself to halt so
+ * that the hypervisor can reuse the CPU cycles in some other guests as well
+ * as returning other hold-up CPUs faster.
+ *
+ * A major difference between the two versions of PV spinlock is the fact
+ * that the spin threshold of the queue spinlock is half of that of the
+ * ticket spinlock. However, the queue head will spin twice as long as the
+ * other nodes before it puts itself to halt. The reason for that is to
+ * increase halting chance of heavily contended locks to favor lightly
+ * contended locks (queue depth of 1 or less).
+ *
+ * There are 2 places where races can happen:
+ *  1) Halting of the queue head CPU (in pv_head_spin_check) and the CPU
+ *     kicking by the lock holder in the unlock path (in pv_kick_node).
+ *  2) Halting of the queue node CPU (in pv_queue_spin_check) and the
+ *     the status check by the previous queue head (in pv_halt_check).
+ * See the comments on those functions to see how the races are being
+ * addressed.
+ */
+
+/*
+ * Spin threshold for queue spinlock
+ */
+#define	QSPIN_THRESHOLD		(1U<<14)
+#define MAYHALT_THRESHOLD	(QSPIN_THRESHOLD - 0x10)
+
+/*
+ * CPU state flags
+ */
+#define PV_CPU_ACTIVE	1	/* This CPU is active		 */
+#define PV_CPU_KICKED   2	/* This CPU is being kicked	 */
+#define PV_CPU_HALTED	-1	/* This CPU is halted		 */
+
+/*
+ * Additional fields to be added to the qnode structure
+ */
+#if CONFIG_NR_CPUS >= (1 << 16)
+#define _cpuid_t	u32
+#else
+#define _cpuid_t	u16
+#endif
+
+struct qnode;
+
+struct pv_qvars {
+	s8	      cpustate;		/* CPU status flag		*/
+	s8	      mayhalt;		/* May be halted soon		*/
+	_cpuid_t      mycpu;		/* CPU number of this node	*/
+	struct qnode *prev;		/* Pointer to previous node	*/
+};
+
+/*
+ * Macro to be used by the unfair lock code to access the previous node pointer
+ * in the pv structure.
+ */
+#define qprev	pv.prev
+
+/**
+ * pv_init_vars - initialize fields in struct pv_qvars
+ * @pv : pointer to struct pv_qvars
+ * @cpu: current CPU number
+ */
+static __always_inline void pv_init_vars(struct pv_qvars *pv, int cpu)
+{
+	pv->cpustate = PV_CPU_ACTIVE;
+	pv->prev     = NULL;
+	pv->mayhalt  = false;
+	pv->mycpu    = cpu;
+}
+
+/**
+ * pv_head_spin_check - perform para-virtualization checks for queue head
+ * @pv    : pointer to struct pv_qvars
+ * @count : loop count
+ * @qcode : queue code of the supposed lock holder
+ * @lock  : pointer to the qspinlock structure
+ *
+ * The following checks will be done:
+ * 1) If it gets a kick signal, reset loop count and flag
+ * 2) Halt itself if lock is still not available after QSPIN_THRESHOLD
+ */
+static __always_inline void pv_head_spin_check(struct pv_qvars *pv, int *count,
+				u32 qcode, struct qspinlock *lock)
+{
+	if (!static_key_false(&paravirt_spinlocks_enabled))
+		return;
+
+	if (pv->cpustate == PV_CPU_KICKED) {
+		/*
+		 * Reset count and flag
+		 */
+		*count	     = 0;
+		pv->cpustate = PV_CPU_ACTIVE;
+
+	} else if (unlikely(*count >= 2*QSPIN_THRESHOLD)) {
+		u8 lockval;
+		s8 oldstate;
+
+		/*
+		 * Set the lock byte to _Q_LOCKED_SLOWPATH before
+		 * trying to halt itself. It is possible that the
+		 * lock byte had been set to _Q_LOCKED_SLOWPATH
+		 * already (spurious wakeup of queue head after a halt
+		 * or opportunistic setting in pv_halt_check()).
+		 * In this case, just proceeds to sleeping.
+		 *
+		 *     queue head		    lock holder
+		 *     ----------		    -----------
+		 *     cpustate = PV_CPU_HALTED
+		 * [1] cmpxchg(_Q_LOCKED_VAL	[2] cmpxchg(_Q_LOCKED_VAL => 0)
+		 * => _Q_LOCKED_SLOWPATH)	    if (cmpxchg fails &&
+		 *     if (cmpxchg succeeds)	    cpustate == PV_CPU_HALTED)
+		 *        halt()		       kick()
+		 *
+		 * Sequence:
+		 * 1,2 - slowpath flag set, queue head halted & lock holder
+		 *	 will call slowpath
+		 * 2,1 - queue head cmpxchg fails, halt is aborted
+		 *
+		 * If the queue head CPU is woken up by a spurious interrupt
+		 * at the same time as the lock holder check the cpustate,
+		 * it is possible that the lock holder will try to kick
+		 * the queue head CPU which isn't halted.
+		 */
+		oldstate = cmpxchg(&pv->cpustate, PV_CPU_ACTIVE, PV_CPU_HALTED);
+		if (oldstate == PV_CPU_KICKED)
+			goto reset;	/* Reset count and state */
+
+		lockval = cmpxchg((u8 *)lock,
+				  _Q_LOCKED_VAL, _Q_LOCKED_SLOWPATH);
+		if (lockval != 0) {
+			__queue_halt_cpu(PV_HALT_QHEAD, &pv->cpustate,
+					 PV_CPU_HALTED);
+			__queue_lockstat((pv->cpustate == PV_CPU_KICKED)
+					? PV_WAKE_KICKED : PV_WAKE_SPURIOUS);
+		}
+		/*
+		 * Else, the lock is free and no halting is needed
+		 */
+reset:
+		ACCESS_ONCE(pv->cpustate) = PV_CPU_ACTIVE;
+		*count = 0;	/* Reset count */
+	}
+}
+
+/**
+ * pv_queue_spin_check - perform para-virtualization checks for queue member
+ * @pv   : pointer to struct pv_qvars
+ * @count: loop count
+ */
+static __always_inline void
+pv_queue_spin_check(struct pv_qvars *pv, struct mcs_spinlock *mcs, int *count)
+{
+	if (!static_key_false(&paravirt_spinlocks_enabled))
+		return;
+	/*
+	 * Attempt to halt oneself after QSPIN_THRESHOLD spins
+	 */
+	if (unlikely(*count >= QSPIN_THRESHOLD)) {
+		/*
+		 * Time to halt itself
+		 */
+		ACCESS_ONCE(pv->cpustate) = PV_CPU_HALTED;
+		/*
+		 * One way to avoid the racing between pv_halt_check()
+		 * and pv_queue_spin_check() is to use memory barrier or
+		 * atomic instruction to synchronize between the two competing
+		 * threads. However, that will slow down the queue spinlock
+		 * slowpath. One way to eliminate this overhead for normal
+		 * cases is to use another flag (mayhalt) to indicate that
+		 * racing condition may happen. This flag is set when the
+		 * loop count is getting close to the halting threshold.
+		 *
+		 * When that happens, a 2 variables (cpustate & qhead
+		 * [=mcs.locked]) handshake is used to make sure that
+		 * pv_halt_check() won't miss setting the _Q_LOCKED_SLOWPATH
+		 * when the CPU is about to be halted.
+		 *
+		 * pv_halt_check		pv_queue_spin_check
+		 * -------------		-------------------
+		 * [1] qhead = true		[3] cpustate = PV_CPU_HALTED
+		 *     smp_mb()			    smp_mb()
+		 * [2] if (cpustate		[4] if (qhead)
+		 *        == PV_CPU_HALTED)
+		 *
+		 * Sequence:
+		 * *,1,*,4,* - halt is aborted as the qhead flag is set,
+		 *	       _Q_LOCKED_SLOWPATH may or may not be set
+		 * 3,4,1,2 - the CPU is halt and _Q_LOCKED_SLOWPATH is set
+		 */
+		smp_mb();
+		if (!ACCESS_ONCE(mcs->locked)) {
+			/*
+			 * Halt the CPU only if it is not the queue head
+			 */
+			__queue_halt_cpu(PV_HALT_QNODE, &pv->cpustate,
+					 PV_CPU_HALTED);
+			__queue_lockstat((pv->cpustate == PV_CPU_KICKED)
+					 ? PV_WAKE_KICKED : PV_WAKE_SPURIOUS);
+		}
+		ACCESS_ONCE(pv->cpustate) = PV_CPU_ACTIVE;
+		*count	    = 0;	/* Reset count & flag */
+		pv->mayhalt = false;
+	} else if (*count == MAYHALT_THRESHOLD) {
+		pv->mayhalt = true;
+		/*
+		 * Make sure that the mayhalt flag is visible to others
+		 * before proceeding.
+		 */
+		smp_mb();
+	}
+}
+
+/**
+ * pv_halt_check - check if the CPU has been halted & set _Q_LOCKED_SLOWPATH
+ * @pv   : pointer to struct pv_qvars
+ * @count: loop count
+ *
+ * The current CPU should have gotten the lock and the queue head flag set
+ * before calling this function.
+ */
+static __always_inline void
+pv_halt_check(struct pv_qvars *pv, struct qspinlock *lock)
+{
+	if (!static_key_false(&paravirt_spinlocks_enabled))
+		return;
+	/*
+	 * Halt state checking will only be done if the mayhalt flag is set
+	 * to avoid the overhead of the memory barrier in normal cases.
+	 * It is highly unlikely that the actual writing to the qhead flag
+	 * will be more than 0x10 iterations later than the reading of the
+	 * mayhalt flag so that it misses seeing the PV_CPU_HALTED state
+	 * which causes lost wakeup.
+	 */
+	if (ACCESS_ONCE(pv->mayhalt)) {
+		/*
+		 * A memory barrier is used here to make sure that the setting
+		 * of queue head flag prior to this function call is visible
+		 * to others before checking the cpustate flag.
+		 */
+		smp_mb();
+		if (pv->cpustate == PV_CPU_HALTED)
+			ACCESS_ONCE(*(u8 *)lock) = _Q_LOCKED_SLOWPATH;
+	}
+}
+
+/**
+ * pv_set_prev - set previous queue node pointer
+ * @pv  : pointer to struct pv_qvars to be set
+ * @prev: pointer to the previous node
+ */
+static __always_inline void pv_set_prev(struct pv_qvars *pv, struct qnode *prev)
+{
+	ACCESS_ONCE(pv->prev) = prev;
+	/*
+	 * Make sure the prev field is set up before others
+	 */
+	smp_wmb();
+}
+
+/*
+ * The following inlined functions are being used by the
+ * queue_spin_unlock_slowpath() function.
+ */
+
+/**
+ * pv_get_prev - get previous queue node pointer
+ * @pv   : pointer to struct pv_qvars to be set
+ * Return: the previous queue node pointer
+ */
+static __always_inline struct qnode *pv_get_prev(struct pv_qvars *pv)
+{
+	return ACCESS_ONCE(pv->prev);
+}
+
+/**
+ * pv_kick_node - kick up the CPU of the given node
+ * @pv  : pointer to struct pv_qvars of the node to be kicked
+ */
+static __always_inline void pv_kick_node(struct pv_qvars *pv)
+{
+	s8 oldstate = xchg(&pv->cpustate, PV_CPU_KICKED);
+
+	/*
+	 * Kick up the CPU only if the state was set to PV_CPU_HALTED
+	 */
+	if (oldstate != PV_CPU_HALTED)
+		__queue_lockstat(PV_KICK_NOHALT);
+	else
+		__queue_kick_cpu(pv->mycpu);
+}
+
+#endif /* _ASM_X86_PVQSPINLOCK_H */
diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
index 19af937..a145c31 100644
--- a/arch/x86/include/asm/qspinlock.h
+++ b/arch/x86/include/asm/qspinlock.h
@@ -19,13 +19,46 @@ extern struct static_key paravirt_unfairlocks_enabled;
  * that the clearing the lock bit is done ASAP without artificial delay
  * due to compiler optimization.
  */
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+static __always_inline void __queue_spin_unlock(struct qspinlock *lock)
+#else
 static inline void queue_spin_unlock(struct qspinlock *lock)
+#endif
 {
 	barrier();
 	ACCESS_ONCE(*(u8 *)lock) = 0;
 	barrier();
 }
 
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+/*
+ * The lock byte can have a value of _Q_LOCKED_SLOWPATH to indicate
+ * that it needs to go through the slowpath to do the unlocking.
+ */
+#define _Q_LOCKED_SLOWPATH	(_Q_LOCKED_VAL | 2)
+
+extern void queue_spin_unlock_slowpath(struct qspinlock *lock);
+
+static inline void queue_spin_unlock(struct qspinlock *lock)
+{
+	barrier();
+	if (static_key_false(&paravirt_spinlocks_enabled)) {
+		/*
+		 * Need to atomically clear the lock byte to avoid racing with
+		 * queue head waiter trying to set _QLOCK_LOCKED_SLOWPATH.
+		 */
+		if (likely(cmpxchg((u8 *)lock, _Q_LOCKED_VAL, 0)
+				== _Q_LOCKED_VAL))
+			return;
+		else
+			queue_spin_unlock_slowpath(lock);
+
+	} else {
+		__queue_spin_unlock(lock);
+	}
+	barrier();
+}
+#endif /* CONFIG_PARAVIRT_SPINLOCKS */
 #endif /* !CONFIG_X86_OOSTORE && !CONFIG_X86_PPRO_FENCE */
 
 #include <asm-generic/qspinlock.h>
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 21421a6..be2adca 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -61,17 +61,45 @@
 #include "mcs_spinlock.h"
 
 /*
+ * Para-virtualized queue spinlock support
+ */
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+#include <asm/pvqspinlock.h>
+#else
+
+struct qnode;
+struct pv_qvars {};
+static inline void pv_init_vars(struct pv_qvars *pv, int cpu_nr)	{}
+static inline void pv_head_spin_check(struct pv_qvars *pv, int *count,
+			u32 qcode, struct qspinlock *lock)		{}
+static inline void pv_queue_spin_check(struct pv_qvars *pv,
+			struct mcs_spinlock *mcs, int *count)		{}
+static inline void pv_halt_check(struct pv_qvars *pv, void *lock)	{}
+static inline void pv_kick_node(struct pv_qvars *pv)			{}
+static inline void pv_set_prev(struct pv_qvars *pv, struct qnode *prev)	{}
+static inline struct qnode *pv_get_prev(struct pv_qvars *pv)
+							{ return NULL; }
+#endif
+
+/*
  * To have additional features for better virtualization support, it is
  * necessary to store additional data in the queue node structure. So
  * a new queue node structure will have to be defined and used here.
+ *
+ * If CONFIG_PARAVIRT_SPINLOCKS is turned on, the previous node pointer in
+ * the pv structure will be used by the unfair lock code.
+ *
  */
 struct qnode {
 	struct mcs_spinlock mcs;
 #ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
 	int		lsteal_mask;	/* Lock stealing frequency mask	*/
 	u32		prev_tail;	/* Tail code of previous node	*/
+#ifndef CONFIG_PARAVIRT_SPINLOCKS
 	struct qnode   *qprev;		/* Previous queue node addr	*/
 #endif
+#endif
+	struct pv_qvars pv;		/* For para-virtualization	*/
 };
 #define qhead	mcs.locked	/* The queue head flag */
 
@@ -666,6 +694,7 @@ queue_spin_lock_slowerpath(struct qspinlock *lock, struct qnode *node, u32 tail)
 {
 	struct qnode *prev, *next;
 	u32 old, val;
+	DEF_LOOP_CNT(hcnt);
 
 	/*
 	 * we already touched the queueing cacheline; don't bother with pending
@@ -683,6 +712,7 @@ queue_spin_lock_slowerpath(struct qspinlock *lock, struct qnode *node, u32 tail)
 
 		prev = decode_tail(old);
 		unfair_set_vars(node, prev, old);
+		pv_set_prev(&node->pv, prev);
 		ACCESS_ONCE(prev->mcs.next) = (struct mcs_spinlock *)node;
 
 		while (!smp_load_acquire(&node->qhead)) {
@@ -697,6 +727,8 @@ queue_spin_lock_slowerpath(struct qspinlock *lock, struct qnode *node, u32 tail)
 					goto notify_next;
 				return;
 			}
+			pv_queue_spin_check(&node->pv, &node->mcs,
+					    LOOP_CNT(&cnt));
 			arch_mutex_cpu_relax();
 		}
 	} else {
@@ -713,8 +745,14 @@ queue_spin_lock_slowerpath(struct qspinlock *lock, struct qnode *node, u32 tail)
 	 */
 retry_queue_wait:
 	while ((val = smp_load_acquire(&lock->val.counter))
-				       & _Q_LOCKED_PENDING_MASK)
+				       & _Q_LOCKED_PENDING_MASK) {
+		INC_LOOP_CNT(hcnt);
+		/*
+		 * Perform queue head para-virtualization checks
+		 */
+		pv_head_spin_check(&node->pv, LOOP_CNT(&hcnt), old, lock);
 		arch_mutex_cpu_relax();
+	}
 
 	/*
 	 * claim the lock:
@@ -727,6 +765,7 @@ retry_queue_wait:
 	 * to grab the lock.
 	 */
 	for (;;) {
+		LOOP_CNT(hcnt = 0);	/* Reset loop count */
 		if (val != tail) {
 			/*
 			 * The get_qlock function will only failed if the
@@ -772,6 +811,7 @@ notify_next:
 	 * The next one in queue is now at the head
 	 */
 	arch_mcs_spin_unlock_contended(&next->qhead);
+	pv_halt_check(&next->pv, lock);
 }
 
 /**
@@ -801,7 +841,7 @@ notify_next:
 void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 {
 	struct qnode *node;
-	u32 tail, idx;
+	u32 tail, idx, cpu_nr;
 
 	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
 
@@ -810,12 +850,13 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 
 	node = this_cpu_ptr(&qnodes[0]);
 	idx = node->mcs.count++;
-	tail = encode_tail(smp_processor_id(), idx);
+	tail = encode_tail(cpu_nr = smp_processor_id(), idx);
 
 	node += idx;
 	node->qhead = 0;
 	node->mcs.next = NULL;
 	unfair_init_vars(node);
+	pv_init_vars(&node->pv, cpu_nr);
 
 	/*
 	 * We touched a (possibly) cold cacheline; attempt the trylock once
@@ -831,3 +872,47 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	this_cpu_dec(qnodes[0].mcs.count);
 }
 EXPORT_SYMBOL(queue_spin_lock_slowpath);
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+/**
+ * queue_spin_unlock_slowpath - kick up the CPU of the queue head
+ * @lock : Pointer to queue spinlock structure
+ *
+ * The lock is released after finding the queue head to avoid racing
+ * condition between the queue head and the lock holder.
+ */
+void queue_spin_unlock_slowpath(struct qspinlock *lock)
+{
+	struct qnode *node, *prev;
+
+	/*
+	 * Get the queue tail node
+	 */
+	node = decode_tail(atomic_read(&lock->val));
+
+	/*
+	 * Locate the queue head node by following the prev pointer from
+	 * tail to head.
+	 * It is assumed that the PV guests won't have that many CPUs so
+	 * that it won't take a long time to follow the pointers.
+	 */
+	while (!ACCESS_ONCE(node->qhead)) {
+		prev = pv_get_prev(&node->pv);
+		if (prev)
+			node = prev;
+		else
+			/*
+			 * Delay a bit to allow the prev pointer to be set up
+			 */
+			arch_mutex_cpu_relax();
+	}
+	/*
+	 * Found the queue head, now release the lock before waking it up
+	 * If unfair lock is enabled, this allows other ready tasks to get
+	 * lock before the halting CPU is waken up.
+	 */
+	__queue_spin_unlock(lock);
+	pv_kick_node(&node->pv);
+}
+EXPORT_SYMBOL(queue_spin_unlock_slowpath);
+#endif /* CONFIG_PARAVIRT_SPINLOCKS */
-- 
1.7.1

