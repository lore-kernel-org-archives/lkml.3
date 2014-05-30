Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbaE3Pqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:46:54 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:3802 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965026AbaE3Pqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:46:50 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
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
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v11 14/16] pvqspinlock: Add qspinlock para-virtualization support
Date: Fri, 30 May 2014 11:44:00 -0400
Message-Id: <1401464642-33890-15-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
References: <1401464642-33890-1-git-send-email-Waiman.Long@hp.com>
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
spinlock PV code, on the other hand, only has a relatively minor
drop in performance for with 1-4 contending tasks. With 5 or more
contending tasks, there is practically no difference in performance.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/include/asm/pvqspinlock.h |  359 ++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/qspinlock.h   |   33 ++++
 kernel/locking/qspinlock.c         |   72 +++++++-
 3 files changed, 458 insertions(+), 6 deletions(-)
 create mode 100644 arch/x86/include/asm/pvqspinlock.h

diff --git a/arch/x86/include/asm/pvqspinlock.h b/arch/x86/include/asm/pvqspinlock.h
new file mode 100644
index 0000000..af00eda
--- /dev/null
+++ b/arch/x86/include/asm/pvqspinlock.h
@@ -0,0 +1,359 @@
+#ifndef _ASM_X86_PVQSPINLOCK_H
+#define _ASM_X86_PVQSPINLOCK_H
+
+/*
+ *	Queue Spinlock Para-Virtualization (PV) Support
+ *
+ *              +------+        +------+        +------+
+ *   pv_qnode   |Queue |  prev  |      |  prev  |Queue |
+ *              | Head |<-------| Node | .... <-| Tail |
+ *              +------+        +------+        +------+
+ *                 |               |               |
+ *                 V               V               V
+ *              +------+        +------+        +------+
+ * mcs_spinlock |locked|        |locked|        |locked|
+ *              | = 1  |------->| = 0  |-> .... | = 0  |
+ *              +------+  next  +------+  next  +------+
+ *
+ * The PV support code for queue spinlock is roughly the same as that
+ * of the ticket spinlock. Each CPU waiting for the lock will spin until it
+ * reaches a threshold. When that happens, it will put itself to halt so
+ * that the hypervisor can reuse the CPU cycles in some other guests as well
+ * as returning other hold-up CPUs faster.
+ *
+ * Auxillary fields in the pv_qnode structure are used to hold information
+ * relevant to the PV support so that it won't impact on the behavior and
+ * performance of the bare metal code. The structure contains a prev pointer
+ * so that a lock holder can find out the queue head from the queue tail
+ * following the prev pointers.
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
+ * Additional fields to be added to the queue node structure
+ *
+ * The size of the mcs_spinlock structure is 16 bytes for x64 and 12 bytes
+ * for i386. Four of those structures are defined per CPU. To add more fields
+ * without increasing the size of the mcs_spinlock structure, we overlay those
+ * additional data fields at an additional mcs_spinlock size bucket at exactly
+ * 3 units away. As a result, we need to double the number of mcs_spinlock
+ * buckets. The mcs_spinlock structure will be casted to the pv_qnode 
+ * internally.
+ *
+ * +------------+------------+------------+------------+
+ * | MCS Node 0 | MCS Node 1 | MCS Node 2 | MCS Node 3 |
+ * +------------+------------+------------+------------+
+ * | PV  Node 0 | PV  Node 1 | PV  Node 2 | PV  Node 3 |
+ * +------------+------------+------------+------------+
+ */
+struct pv_qnode {
+	struct mcs_spinlock  mcs;	/* MCS node			*/
+	struct mcs_spinlock  dummy[3];	/* 3 dummy MCS nodes		*/
+	s8		     cpustate;	/* CPU status flag		*/
+	s8		     mayhalt;	/* May be halted soon		*/
+	u32		     mycpu;	/* CPU number of this node	*/
+	struct pv_qnode     *prev;	/* Pointer to previous node	*/
+};
+
+#define	qhead	mcs.locked		/* Queue head flag */
+
+/**
+ * pv_init_vars - initialize fields in struct pv_qnode
+ * @mcs: pointer to struct mcs_spinlock
+ * @cpu: current CPU number
+ */
+static inline void pv_init_vars(struct mcs_spinlock *node, int cpu)
+{
+	struct pv_qnode *pv = (struct pv_qnode *)node;
+
+	BUILD_BUG_ON(sizeof(struct pv_qnode) > 5*sizeof(struct mcs_spinlock));
+
+	if (!static_key_false(&paravirt_spinlocks_enabled))
+		return;
+
+	pv->cpustate = PV_CPU_ACTIVE;
+	pv->prev     = NULL;
+	pv->mayhalt  = false;
+	pv->mycpu    = cpu;
+}
+
+/**
+ * pv_head_spin_check - perform para-virtualization checks for queue head
+ * @mcs  : pointer to the mcs_spinlock structure
+ * @lock : pointer to the qspinlock structure
+ * @count: loop count pointer
+ *
+ * This function will halt itself if lock is still not available after
+ * QSPIN_THRESHOLD iterations.
+ */
+static inline void
+pv_head_spin_check(struct mcs_spinlock *mcs, struct qspinlock *lock, int *count)
+{
+	struct pv_qnode *pv = (struct pv_qnode *)mcs;
+
+	if (!static_key_false(&paravirt_spinlocks_enabled))
+		return;
+
+	(*count)++;
+	if (pv->cpustate == PV_CPU_KICKED) {
+		/*
+		 * Reset count and flag
+		 */
+		pv->cpustate = PV_CPU_ACTIVE;
+		*count = 0;
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
+ * @mcs  : pointer to the mcs_spinlock structure
+ * @count: loop count pointer
+ */
+static inline void pv_queue_spin_check(struct mcs_spinlock *mcs, int *count)
+{
+	struct pv_qnode *pv = (struct pv_qnode *)mcs;
+
+	if (!static_key_false(&paravirt_spinlocks_enabled))
+		return;
+	/*
+	 * Attempt to halt oneself after QSPIN_THRESHOLD spins
+	 */
+	(*count)++;
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
+		 * [=mcs->locked]) handshake is used to make sure that
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
+		if (!ACCESS_ONCE(pv->qhead)) {
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
+ * @mcs  : pointer to the mcs_spinlock structure
+ * @count: loop count
+ *
+ * The current CPU should have gotten the lock and the queue head flag set
+ * before calling this function.
+ */
+static inline void
+pv_halt_check(struct mcs_spinlock *mcs, struct qspinlock *lock)
+{
+	struct pv_qnode *pv = (struct pv_qnode *)mcs;
+
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
+ * @mcs : pointer to the mcs_spinlock structure
+ * @prev: pointer to the previous pv_qnode
+ */
+static inline void
+pv_set_prev(struct mcs_spinlock *mcs, struct mcs_spinlock *prev)
+{
+	struct pv_qnode *pv = (struct pv_qnode *)mcs;
+
+	ACCESS_ONCE(pv->prev) = (struct pv_qnode *)prev;
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
+ * pv_tail_to_qhead - get queue head pv_qnode from tail code
+ * @tail  : pointer to queue tail code
+ * @Return: mcs_spinlock pointer of queue head
+ *
+ * This function should only be called by the current lock holder so that
+ * the queue head won't be changed.
+ */
+static struct mcs_spinlock *pv_tail_to_qhead(u32 tail)
+{
+	struct pv_qnode *prev, *pv = (struct pv_qnode *)decode_tail(tail);
+
+	/*
+	 * Locate the queue head node by following the prev pointer from
+	 * tail to head. It is assumed that the PV guests won't have that
+	 * many CPUs so that it won't take a long time to follow the pointers.
+	 */
+	while (!ACCESS_ONCE(pv->qhead)) {
+		prev = ACCESS_ONCE(pv->prev);
+		if (prev)
+			pv = prev;
+		else
+			/*
+			 * Delay a bit to allow the prev pointer or the queue
+			 * head flag to be set up
+			 */
+			cpu_relax();
+	}
+	return (struct mcs_spinlock *)pv;
+}
+
+/**
+ * pv_kick_node - kick up the CPU of the given node
+ * @mcs : pointer to struct mcs_spinlock of the node to be kicked
+ */
+static inline void pv_kick_node(struct mcs_spinlock *mcs)
+{
+	struct pv_qnode *pv = (struct pv_qnode *)mcs;
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
index 448de8b..5ddc456 100644
--- a/arch/x86/include/asm/qspinlock.h
+++ b/arch/x86/include/asm/qspinlock.h
@@ -19,13 +19,46 @@ extern struct static_key virt_unfairlocks_enabled;
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
index 8deedcf..adedd75 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -60,12 +60,17 @@
  * Check the pending bit spinning threshold only if PV qspinlock is enabled
  */
 #define PSPIN_THRESHOLD		(1 << 10)
-#define MAX_NODES		4
 
+/*
+ * We need to double the number of per-cpu mcs_spinlock structures to hold
+ * additional fields specific to para-virtualization support.
+ */
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
-#define pv_qspinlock_enabled()	static_key_false(&paravirt_spinlocks_enabled)
+# define MAX_NODES		8
+# define pv_qspinlock_enabled()	static_key_false(&paravirt_spinlocks_enabled)
 #else
-#define pv_qspinlock_enabled()	false
+# define MAX_NODES		4
+# define pv_qspinlock_enabled()	false
 #endif
 
 /*
@@ -243,6 +248,22 @@ static __always_inline int try_set_locked(struct qspinlock *lock)
 	return 1;
 }
 
+/*
+ * Para-virtualization (PV) queue spinlock support
+ */
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+#include <asm/pvqspinlock.h>
+#else
+static inline void pv_init_vars(struct mcs_spinlock *mcs, int cpu)	{}
+static inline void pv_head_spin_check(struct mcs_spinlock *mcs,
+			struct qspinlock *lock, int *count)		{}
+static inline void pv_queue_spin_check(struct mcs_spinlock *mcs,
+			int *count)					{}
+static inline void pv_halt_check(struct mcs_spinlock *mcs, void *lock)	{}
+static inline void pv_set_prev(struct mcs_spinlock *mcs,
+			struct mcs_spinlock *prev)			{}
+#endif /* CONFIG_PARAVIRT_SPINLOCKS */
+
 /**
  * queue_spin_lock_slowerpath - a slower patch for acquiring queue spinlock
  * @lock: Pointer to queue spinlock structure
@@ -260,6 +281,7 @@ static noinline void queue_spin_lock_slowerpath(struct qspinlock *lock,
 {
 	struct mcs_spinlock *prev, *next;
 	u32 val, old;
+	int hcnt = 0;	/* Queue head loop counter */
 
 	/*
 	 * we already touched the queueing cacheline; don't bother with pending
@@ -273,9 +295,16 @@ static noinline void queue_spin_lock_slowerpath(struct qspinlock *lock,
 	 * if there was a previous node; link it and wait.
 	 */
 	if (old & _Q_TAIL_MASK) {
+		int qcnt = 0;	/* Queue node loop counter */
+
 		prev = decode_tail(old);
+		pv_set_prev(node, prev);
 		ACCESS_ONCE(prev->next) = node;
 
+		while (!smp_load_acquire(&node->locked)) {
+			pv_queue_spin_check(node, &qcnt);
+			arch_mutex_cpu_relax();
+		}
 		arch_mcs_spin_lock_contended(&node->locked);
 	} else {
 		/* Mark it as the queue head */
@@ -292,8 +321,14 @@ static noinline void queue_spin_lock_slowerpath(struct qspinlock *lock,
 	 */
 retry_queue_wait:
 	while ((val = smp_load_acquire(&lock->val.counter))
-				       & _Q_LOCKED_PENDING_MASK)
+				       & _Q_LOCKED_PENDING_MASK) {
+		/*
+		 * Perform queue head para-virtualization checks
+		 */
+		pv_head_spin_check(node, lock, &hcnt);
 		arch_mutex_cpu_relax();
+	}
+	hcnt = 0;	/* Reset loop count */
 
 	/*
 	 * claim the lock:
@@ -331,6 +366,7 @@ retry_queue_wait:
 		arch_mutex_cpu_relax();
 
 	arch_mcs_spin_unlock_contended(&next->locked);
+	pv_halt_check(next, lock);
 }
 
 /**
@@ -358,7 +394,7 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 {
 	struct mcs_spinlock *node;
 	u32 new, old, tail;
-	int idx;
+	int idx, cpu_nr;
 	int retry = INT_MAX;	/* Retry count, queue if <= 0 */
 
 	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
@@ -470,11 +506,12 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 queue:
 	node = this_cpu_ptr(&mcs_nodes[0]);
 	idx = node->count++;
-	tail = encode_tail(smp_processor_id(), idx);
+	tail = encode_tail(cpu_nr = smp_processor_id(), idx);
 
 	node += idx;
 	node->locked = 0;
 	node->next = NULL;
+	pv_init_vars(node, cpu_nr);
 
 	/*
 	 * We touched a (possibly) cold cacheline in the per-cpu queue node;
@@ -490,3 +527,26 @@ queue:
 	this_cpu_dec(mcs_nodes[0].count);
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
+	struct mcs_spinlock *node = pv_tail_to_qhead(atomic_read(&lock->val));
+
+	/*
+	 * Found the queue head, now release the lock before waking it up
+	 * If unfair lock is enabled, this allows other ready tasks to get
+	 * lock before the halting CPU is waken up.
+	 */
+	__queue_spin_unlock(lock);
+	pv_kick_node(node);
+}
+EXPORT_SYMBOL(queue_spin_unlock_slowpath);
+#endif /* CONFIG_PARAVIRT_SPINLOCKS */
-- 
1.7.1

