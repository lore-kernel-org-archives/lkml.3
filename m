Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816AbaDBN2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:28:36 -0400
Received: from g6t1525.atlanta.hp.com ([15.193.200.68]:18317 "EHLO
	g6t1525.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758798AbaDBN2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:28:30 -0400
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
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v8 08/10] pvqspinlock, x86: Add qspinlock para-virtualization support
Date: Wed,  2 Apr 2014 09:27:37 -0400
Message-Id: <1396445259-27670-9-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds para-virtualization support to the queue spinlock in
the same way as was done in the PV ticket lock code. In essence, the
lock waiters will spin for a specified number of times (QSPIN_THRESHOLD
= 2^14) and then halted itself. The queue head waiter, unlike the
other waiter, will spins 2*QSPIN_THRESHOLD times before halting
itself.  Before being halted, the queue head waiter will set a flag
(_QLOCK_LOCKED_SLOWPATH) in the lock byte to indicate that the unlock
slowpath has to be invoked.

In the unlock slowpath, the current lock holder will find the queue
head by following the previous node pointer links stored in the queue
node structure until it finds one that has the qhead flag turned
on. It then attempt to kick the CPU of the queue head.

After the queue head acquired the lock, it will also check the status
of the next node and set _QLOCK_LOCKED_SLOWPATH if it has been halted.

Enabling the PV code does have a performance impact on spinlock
acquisitions and releases. The following table shows the execution
time (in ms) of a spinlock micro-benchmark that does lock/unlock
operations 5M times for each task versus the number of contending
tasks on a Westmere-EX system.

  # of        Ticket lock	     Queue lock
  tasks   PV off/PV on/%Change 	  PV off/PV on/%Change
  ------  --------------------   ---------------------
    1	     135/  179/+33%	     137/  169/+23%
    2	    1045/ 1103/ +6%	     964/ 1137/+18%
    3	    1827/ 2683/+47%	    2228/ 2537/+14%
    4       2689/ 4191/+56%	    2769/ 3097/+12%
    5       3736/ 5830/+56%	    3447/ 3568/ +4%
    6       4942/ 7609/+54%	    4169/ 4292/ +3%
    7       6304/ 9570/+52%	    4898/ 5021/ +3%
    8       7736/11323/+46%	    5620/ 5717/ +2%

The big reduction in performance with 2 contending tasks for the PV
queue spinlock is due to the switching off of the optimized code path
when PV spinlock code is turned on.

It can be seen that the ticket lock PV code has a fairly big decrease
in performance when there are 3 or more contending tasks. The queue
spinlock PV code, on the other hand, only has a relatively minor drop
in performance for 3 or more contending tasks. At 5 or more contending
tasks, there is practically no difference in performance. When coupled
with unfair lock, the queue spinlock can be much faster than the PV
ticket lock.

When both the unfair lock and PV spinlock features is turned on,
lock stealing will still be allowed in the fastpath, but not in
the slowpath.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/include/asm/paravirt.h       |   17 ++-
 arch/x86/include/asm/paravirt_types.h |   16 ++
 arch/x86/include/asm/pvqspinlock.h    |  260 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/qspinlock.h      |   35 +++++
 arch/x86/kernel/paravirt-spinlocks.c  |    6 +
 kernel/locking/qspinlock.c            |  138 +++++++++++++++++-
 6 files changed, 465 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/include/asm/pvqspinlock.h

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index cd6e161..a35cd02 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -711,7 +711,22 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 }
 
 #if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
+#ifdef CONFIG_QUEUE_SPINLOCK
+static __always_inline void __queue_kick_cpu(int cpu)
+{
+	PVOP_VCALL1(pv_lock_ops.kick_cpu, cpu);
+}
+
+static __always_inline void __queue_hibernate(enum pv_lock_stats type)
+{
+	PVOP_VCALL1(pv_lock_ops.hibernate, type);
+}
 
+static __always_inline void __queue_lockstat(enum pv_lock_stats type)
+{
+	PVOP_VCALL1(pv_lock_ops.lockstat, type);
+}
+#else
 static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock,
 							__ticket_t ticket)
 {
@@ -723,7 +738,7 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
 {
 	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
 }
-
+#endif
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 7549b8b..a8564b9 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -333,9 +333,25 @@ struct arch_spinlock;
 typedef u16 __ticket_t;
 #endif
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+enum pv_lock_stats {
+	PV_HALT_QHEAD,		/* Queue head halting	    */
+	PV_HALT_QNODE,		/* Other queue node halting */
+	PV_WAKE_KICKED,		/* Wakeup by kicking	    */
+	PV_WAKE_SPURIOUS,	/* Spurious wakeup	    */
+	PV_KICK_NOHALT		/* Kick but CPU not halted  */
+};
+#endif
+
 struct pv_lock_ops {
+#ifdef CONFIG_QUEUE_SPINLOCK
+	void (*kick_cpu)(int cpu);
+	void (*hibernate)(enum pv_lock_stats type);
+	void (*lockstat)(enum pv_lock_stats type);
+#else
 	struct paravirt_callee_save lock_spinning;
 	void (*unlock_kick)(struct arch_spinlock *lock, __ticket_t ticket);
+#endif
 };
 
 /* This contains all the paravirt structures: we get a convenient
diff --git a/arch/x86/include/asm/pvqspinlock.h b/arch/x86/include/asm/pvqspinlock.h
new file mode 100644
index 0000000..a632dcb
--- /dev/null
+++ b/arch/x86/include/asm/pvqspinlock.h
@@ -0,0 +1,260 @@
+#ifndef _ASM_X86_PVQSPINLOCK_H
+#define _ASM_X86_PVQSPINLOCK_H
+
+/*
+ *	Queue Spinlock Para-Virtualization (PV) Support
+ *
+ *	+------+	    +-----+   next     +----+
+ *	| Lock |	    |Queue|----------->|Next|
+ *	|Holder|<-----------|Head |<-----------|Node|
+ *	+------+ prev_qcode +-----+ prev_qcode +----+
+ *
+ * The PV support code for queue spinlock is roughly the same as that
+ * of the ticket spinlock. Each CPU waiting for the lock will spin until it
+ * reaches a threshold. When that happens, it will put itself to halt so
+ * that the hypervisor can reuse the CPU cycles in some other guests.
+ *
+ * A major difference between the two versions of PV support is the fact
+ * that the queue head will spin twice as long as the other nodes before it
+ * puts itself to halt.
+ *
+ * There are 2 places where race can happen:
+ *  1) Halting of the queue head CPU (in pv_head_spin_check) and the CPU
+ *     kicking by the lock holder (in pv_kick_node).
+ *  2) Halting of the queue node CPU (in pv_queue_spin_check) and the
+ *     the status check by the previous queue head (in pv_next_node_check).
+ * See the comments on those functions to see how the races are being
+ * addressed.
+ */
+
+/*
+ * Spin threshold for queue spinlock
+ * This is half of the ticket lock's SPIN_THRESHOLD. The queue head will
+ * be halted after 2*QSPIN_THRESHOLD whereas the other nodes will be
+ * halted after QSPIN_THRESHOLD.
+ */
+#define	QSPIN_THRESHOLD	(1U<<14)
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
+	s8	      qhead;		/* Becoming queue head		*/
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
+	pv->qhead    = false;
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
+ * 2) Halt itself if lock is still not available after 2*QSPIN_THRESHOLD
+ */
+static __always_inline void pv_head_spin_check(struct pv_qvars *pv, int *count,
+				u32 qcode, struct qspinlock *lock)
+{
+	if (!static_key_false(&paravirt_spinlocks_enabled))
+		return;
+
+	if (unlikely(*count >= 2*QSPIN_THRESHOLD)) {
+		u8 lockval;
+
+		/*
+		 * Set the lock byte to _QLOCK_LOCKED_SLOWPATH before
+		 * trying to hibernate itself. It is possible that the
+		 * lock byte had been set to _QLOCK_LOCKED_SLOWPATH
+		 * already (spurious wakeup of queue head after a halt).
+		 * In this case, just proceeds to sleeping.
+		 *
+		 *     queue head		    lock holder
+		 *     ----------		    -----------
+		 *     cpustate = PV_CPU_HALTED
+		 * [1] cmpxchg(_QLOCK_LOCKED	[2] cmpxchg(_QLOCK_LOCKED => 0)
+		 * => _QLOCK_LOCKED_SLOWPATH)	    if (cmpxchg fails &&
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
+		ACCESS_ONCE(pv->cpustate) = PV_CPU_HALTED;
+		lockval = cmpxchg(&((union arch_qspinlock *)lock)->lock,
+			  _QLOCK_LOCKED, _QLOCK_LOCKED_SLOWPATH);
+		if (lockval == 0) {
+			/*
+			 * Can exit now as the lock is free
+			 */
+			ACCESS_ONCE(pv->cpustate) = PV_CPU_ACTIVE;
+			*count = 0;
+			return;
+		}
+		__queue_hibernate(PV_HALT_QHEAD);
+		__queue_lockstat((pv->cpustate == PV_CPU_KICKED)
+				 ? PV_WAKE_KICKED : PV_WAKE_SPURIOUS);
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
+static __always_inline void pv_queue_spin_check(struct pv_qvars *pv, int *count)
+{
+	if (!static_key_false(&paravirt_spinlocks_enabled))
+		return;
+	/*
+	 * Attempt to halt oneself after QSPIN_THRESHOLD spins
+	 */
+	if (unlikely(*count >= QSPIN_THRESHOLD)) {
+		/*
+		 * Time to hibernate itself
+		 */
+		ACCESS_ONCE(pv->cpustate) = PV_CPU_HALTED;
+		/*
+		 * In order to avoid the racing between pv_next_node_check()
+		 * and pv_queue_spin_check(), 2 variables handshake is used
+		 * to make sure that pv_next_node_check() won't miss setting
+		 * the _QLOCK_LOCKED_SLOWPATH when the CPU is about to be
+		 * halted.
+		 *
+		 * pv_next_node_check		pv_queue_spin_check
+		 * ------------------		-------------------
+		 * [1] qhead = true		[3] cpustate = PV_CPU_HALTED
+		 *     barrier()		    barrier()
+		 * [2] if (cpustate		[4] if (qhead)
+		 *        == PV_CPU_HALTED)
+		 *
+		 * Sequence:
+		 * *,1,*,4,* - halt is aborted as the qhead flag is set,
+		 *	       _QLOCK_LOCKED_SLOWPATH may or may not be set
+		 * 3,4,1,2 - the CPU is halt and _QLOCK_LOCKED_SLOWPATH is set
+		 */
+		barrier();
+		if (!ACCESS_ONCE(pv->qhead)) {
+			__queue_hibernate(PV_HALT_QNODE);
+			__queue_lockstat((pv->cpustate == PV_CPU_KICKED)
+					 ? PV_WAKE_KICKED : PV_WAKE_SPURIOUS);
+		} else {
+			pv->qhead = false;
+		}
+		ACCESS_ONCE(pv->cpustate) = PV_CPU_ACTIVE;
+		*count = 0;	/* Reset count */
+	}
+}
+
+/**
+ * pv_next_node_check - set _QLOCK_LOCKED_SLOWPATH flag if the next node
+ *			is halted
+ * @pv   : pointer to struct pv_qvars
+ * @count: loop count
+ *
+ * The current CPU should have gotten the lock before calling this function.
+ */
+static __always_inline void
+pv_next_node_check(struct pv_qvars *pv, struct qspinlock *lock)
+{
+	if (!static_key_false(&paravirt_spinlocks_enabled))
+		return;
+	pv->qhead = true;
+	/*
+	 * Make sure qhead flag is visible before checking the cpustate flag
+	 */
+	barrier();
+	if (ACCESS_ONCE(pv->cpustate) == PV_CPU_HALTED)
+		ACCESS_ONCE(((union arch_qspinlock *)lock)->lock)
+			= _QLOCK_LOCKED_SLOWPATH;
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
+	if (pv->cpustate != PV_CPU_HALTED) {
+		__queue_lockstat(PV_KICK_NOHALT);
+		return;
+	}
+	ACCESS_ONCE(pv->cpustate) = PV_CPU_KICKED;
+	__queue_kick_cpu(pv->mycpu);
+}
+
+#endif /* _ASM_X86_PVQSPINLOCK_H */
diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
index d91994d..98692cf 100644
--- a/arch/x86/include/asm/qspinlock.h
+++ b/arch/x86/include/asm/qspinlock.h
@@ -42,7 +42,11 @@ extern struct static_key paravirt_unfairlocks_enabled;
  * that the clearing the lock bit is done ASAP without artificial delay
  * due to compiler optimization.
  */
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+static __always_inline void __queue_spin_unlock(struct qspinlock *lock)
+#else
 static inline void queue_spin_unlock(struct qspinlock *lock)
+#endif
 {
 	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
 
@@ -51,6 +55,37 @@ static inline void queue_spin_unlock(struct qspinlock *lock)
 	barrier();
 }
 
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+/*
+ * The lock byte can have a value of _QLOCK_LOCKED_SLOWPATH to indicate
+ * that it needs to go through the slowpath to do the unlocking.
+ */
+#define _QLOCK_LOCKED_SLOWPATH	3	/* Set both bits 0 & 1 */
+
+extern void queue_spin_unlock_slowpath(struct qspinlock *lock);
+
+static inline void queue_spin_unlock(struct qspinlock *lock)
+{
+	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
+
+	barrier();
+	if (static_key_false(&paravirt_spinlocks_enabled)) {
+		/*
+		 * Need to atomically clear the lock byte to avoid racing with
+		 * queue head waiter trying to set _QLOCK_LOCKED_SLOWPATH.
+		 */
+		if (likely(cmpxchg(&qlock->lock, _QLOCK_LOCKED, 0)
+				== _QLOCK_LOCKED))
+			return;
+		else
+			queue_spin_unlock_slowpath(lock);
+
+	} else {
+		__queue_spin_unlock(lock);
+	}
+}
+#endif
+
 #ifdef _QCODE_SHORT
 #define __queue_spin_trylock __queue_spin_trylock
 /**
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 6d36731..9379417 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -11,9 +11,15 @@
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
+#ifdef CONFIG_QUEUE_SPINLOCK
+	.kick_cpu  = paravirt_nop,
+	.hibernate = paravirt_nop,
+	.lockstat  = paravirt_nop,
+#else
 	.lock_spinning = __PV_IS_CALLEE_SAVE(paravirt_nop),
 	.unlock_kick = paravirt_nop,
 #endif
+#endif
 };
 EXPORT_SYMBOL(pv_lock_ops);
 
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 527efc3..3448010 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -58,6 +58,26 @@
  */
 
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
+static inline void pv_queue_spin_check(struct pv_qvars *pv, int *count)	{}
+static inline void pv_next_node_check(struct pv_qvars *pv, void *lock)	{}
+static inline void pv_kick_node(struct pv_qvars *pv)			{}
+static inline void pv_set_prev(struct pv_qvars *pv, struct qnode *prev)	{}
+static inline struct qnode *pv_get_prev(struct pv_qvars *pv)
+{ return NULL; }
+#endif
+
+/*
  * The 24-bit queue node code is divided into the following 2 fields:
  * Bits 0-1 : queue node index (4 nodes)
  * Bits 2-23: CPU number + 1   (4M - 1 CPUs)
@@ -86,14 +106,20 @@ enum exitval {
 
 /*
  * The queue node structure
+ *
+ * If CONFIG_PARAVIRT_SPINLOCKS is turned on, the previous node pointer in
+ * the pv structure will be used by the unfair lock code.
  */
 struct qnode {
 	u32		 qhead;		/* Queue head flag		*/
 #ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
 	int		 lsteal_mask;	/* Lock stealing frequency mask	*/
 	u32		 prev_qcode;	/* Queue code of previous node	*/
+#ifndef CONFIG_PARAVIRT_SPINLOCKS
 	struct qnode    *qprev;		/* Previous queue node addr	*/
 #endif
+#endif
+	struct pv_qvars	 pv;		/* Para-virtualization		*/
 	struct qnode	*next;		/* Next queue node addr		*/
 };
 
@@ -103,6 +129,20 @@ struct qnode_set {
 };
 
 /*
+ * Allow spinning loop count only if either PV spinlock or unfair lock is
+ * configured.
+ */
+#if defined(CONFIG_PARAVIRT_UNFAIR_LOCKS) || defined(CONFIG_PARAVIRT_SPINLOCKS)
+#define	DEF_LOOP_CNT(c)		int c = 0
+#define	INC_LOOP_CNT(c)		(c)++
+#define	LOOP_CNT(c)		c
+#else
+#define	DEF_LOOP_CNT(c)
+#define	INC_LOOP_CNT(c)
+#define	LOOP_CNT(c)		0
+#endif
+
+/*
  * Per-CPU queue node structures
  */
 static DEFINE_PER_CPU_ALIGNED(struct qnode_set, qnset) = { { { 0 } }, 0 };
@@ -190,6 +230,16 @@ static inline int queue_spin_trylock_quick(struct qspinlock *lock, int qsval)
 	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
 	int		      wset  = false;	/* True if wait bit was set */
 
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+	/*
+	 * Disable the quick spinning code path if PV spinlock is enabled to
+	 * make sure that all the spinning CPUs can be halted when the lock
+	 * holder is scheduled out.
+	 */
+	if (static_key_false(&paravirt_spinlocks_enabled))
+		return 0;
+#endif
+
 	/*
 	 * Fall into the quick spinning code path only if no task is waiting
 	 * in the queue.
@@ -526,9 +576,6 @@ cmpxchg_queue_code(struct qspinlock *lock, u32 ocode, u32 ncode)
  * starvation.
  */
 #ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
-#define DEF_LOOP_CNT(c)		int c = 0
-#define INC_LOOP_CNT(c)		(c)++
-#define LOOP_CNT(c)		c
 #define LSTEAL_MIN		(1 << 3)
 #define LSTEAL_MAX		(1 << 10)
 #define LSTEAL_MIN_MASK		(LSTEAL_MIN - 1)
@@ -554,6 +601,14 @@ static void unfair_init_vars(struct qnode *node)
 static void
 unfair_set_vars(struct qnode *node, struct qnode *prev, u32 prev_qcode)
 {
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+	/*
+	 * Disable waiter lock stealing if PV spinlock is enabled
+	 */
+	if (static_key_false(&paravirt_spinlocks_enabled))
+		return;
+#endif
+
 	if (!static_key_false(&paravirt_unfairlocks_enabled))
 		return;
 
@@ -580,6 +635,14 @@ unfair_set_vars(struct qnode *node, struct qnode *prev, u32 prev_qcode)
  */
 static enum exitval unfair_check_qcode(struct qspinlock *lock, u32 my_qcode)
 {
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+	/*
+	 * Disable waiter lock stealing if PV spinlock is enabled
+	 */
+	if (static_key_false(&paravirt_spinlocks_enabled))
+		return NOTIFY_NEXT;
+#endif
+
 	if (!static_key_false(&paravirt_unfairlocks_enabled))
 		return NOTIFY_NEXT;
 
@@ -607,6 +670,14 @@ static enum exitval unfair_get_lock(struct qspinlock *lock, struct qnode *node,
 	int	     qhead;
 	struct qnode *next;
 
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+	/*
+	 * Disable waiter lock stealing if PV spinlock is enabled
+	 */
+	if (static_key_false(&paravirt_spinlocks_enabled))
+		return NORMAL_EXIT;
+#endif
+
 	if (!static_key_false(&paravirt_unfairlocks_enabled) ||
 	   ((count & node->lsteal_mask) != node->lsteal_mask))
 		return NORMAL_EXIT;
@@ -675,9 +746,6 @@ static enum exitval unfair_get_lock(struct qspinlock *lock, struct qnode *node,
 }
 
 #else /* CONFIG_PARAVIRT_UNFAIR_LOCKS */
-#define	DEF_LOOP_CNT(c)
-#define	INC_LOOP_CNT(c)
-#define	LOOP_CNT(c)		0
 
 static void unfair_init_vars(struct qnode *node)	{}
 static void unfair_set_vars(struct qnode *node, struct qnode *prev,
@@ -748,6 +816,7 @@ static noinline void queue_spin_lock_slowerpath(struct qspinlock *lock,
 	struct qnode *next;
 	u32 prev_qcode;
 	enum exitval exitval;
+	DEF_LOOP_CNT(hcnt);
 
 	/*
 	 * Exchange current copy of the queue node code
@@ -767,6 +836,7 @@ static noinline void queue_spin_lock_slowerpath(struct qspinlock *lock,
 		DEF_LOOP_CNT(cnt);
 
 		unfair_set_vars(node, prev, prev_qcode);
+		pv_set_prev(&node->pv, prev);
 		ACCESS_ONCE(prev->next) = node;
 		/*
 		 * Wait until the queue head flag is on
@@ -780,13 +850,17 @@ static noinline void queue_spin_lock_slowerpath(struct qspinlock *lock,
 				goto release_node;
 			else if (unlikely(exitval == NOTIFY_NEXT))
 				goto notify_next;
+			pv_queue_spin_check(&node->pv, LOOP_CNT(&cnt));
 		} while (!ACCESS_ONCE(node->qhead));
+	} else {
+		ACCESS_ONCE(node->qhead) = true;
 	}
 
 	/*
 	 * At the head of the wait queue now
 	 */
 	for (;; arch_mutex_cpu_relax()) {
+		INC_LOOP_CNT(hcnt);
 		qsval = atomic_read(&lock->qlcode);
 		if (qsval & _QLOCK_LOCK_MASK)
 			continue;	/* Lock not available yet */
@@ -820,6 +894,12 @@ static noinline void queue_spin_lock_slowerpath(struct qspinlock *lock,
 		} else if (queue_spin_trylock_and_clr_qcode(lock, my_qcode)) {
 			goto release_node;
 		}
+
+		/*
+		 * Perform para-virtualization checks
+		 */
+		pv_head_spin_check(&node->pv, LOOP_CNT(&hcnt), prev_qcode,
+				   lock);
 	}
 
 notify_next:
@@ -832,6 +912,7 @@ set_qhead:
 	/*
 	 * The next one in queue is now at the head
 	 */
+	pv_next_node_check(&next->pv, lock);
 	ACCESS_ONCE(next->qhead) = true;
 
 release_node:
@@ -871,6 +952,7 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, int qsval)
 	node->qhead = false;
 	node->next  = NULL;
 	unfair_init_vars(node);
+	pv_init_vars(&node->pv, cpu_nr);
 
 	/*
 	 * The lock may be available at this point, try again if no task was
@@ -882,3 +964,47 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, int qsval)
 		queue_spin_lock_slowerpath(lock, node, my_qcode);
 }
 EXPORT_SYMBOL(queue_spin_lock_slowpath);
+
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
+	u32 qcode = queue_get_qcode(lock);
+
+	/*
+	 * Get the queue tail node
+	 */
+	node = xlate_qcode(qcode);
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
+	 */
+	__queue_spin_unlock(lock);
+	pv_kick_node(&node->pv);
+}
+EXPORT_SYMBOL(queue_spin_unlock_slowpath);
+#endif /* CONFIG_PARAVIRT_SPINLOCKS */
-- 
1.7.1

