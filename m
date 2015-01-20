Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbbATUNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:13:46 -0500
Received: from g4t3427.houston.hp.com ([15.201.208.55]:57734 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbbATUNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:13:41 -0500
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
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v14 09/11] pvqspinlock, x86: Add para-virtualization support
Date: Tue, 20 Jan 2015 15:12:33 -0500
Message-Id: <1421784755-21945-10-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1421784755-21945-1-git-send-email-Waiman.Long@hp.com>
References: <1421784755-21945-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds para-virtualization support to the queue spinlock
code base with minimal impact to the native case. There are some
minor code changes in the generic qspinlock.c file which should be
usable in other architectures. The other code changes are specific
to x86 processors and so are all put under the arch/x86 directory.

On the lock side, the slowpath code is split into 2 separate functions
generated from the same code - one for bare metal and one for PV guest.
The switching is done in the _raw_spin_lock* functions. This makes
sure that the performance impact to the bare metal case is minimal,
just a few NOPs in the _raw_spin_lock* functions. In the PV slowpath
code, there are 2 paravirt callee saved calls that minimize register
pressure.

On the unlock side, however, the disabling of unlock function inlining
does have some slight impact on bare metal performance.

The actual paravirt code comes in 5 parts;

 - init_node; this initializes the extra data members required for PV
   state. PV state data is kept 1 cacheline ahead of the regular data.

 - link_and_wait_node; this replaces the regular MCS queuing code. CPU
   halting can happen if the wait is too long.

 - wait_head; this waits until the lock is avialable and the CPU will
   be halted if the wait is too long.

 - wait_check; this is called after acquiring the lock to see if the
   next queue head CPU is halted. If this is the case, the lock bit is
   changed to indicate the queue head will have to be kicked on unlock.

 - queue_unlock;  this routine has a jump label to check if paravirt
   is enabled. If yes, it has to do an atomic cmpxchg to clear the lock
   bit or call the slowpath function to kick the queue head cpu.

Tracking the head is done in two parts, firstly the pv_wait_head will
store its cpu number in whichever node is pointed to by the tail part
of the lock word. Secondly, pv_link_and_wait_node() will propagate the
existing head from the old to the new tail node.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/include/asm/paravirt.h       |   22 ++
 arch/x86/include/asm/paravirt_types.h |   27 ++
 arch/x86/include/asm/pvqspinlock.h    |  426 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/qspinlock.h      |   71 ++++++-
 arch/x86/kernel/paravirt-spinlocks.c  |    6 +
 include/asm-generic/qspinlock.h       |    2 +
 kernel/locking/qspinlock.c            |   70 +++++-
 7 files changed, 617 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/include/asm/pvqspinlock.h

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 32444ae..628a79f 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -712,6 +712,27 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 
 #if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+
+static __always_inline void pv_kick_cpu(int cpu)
+{
+	PVOP_VCALL1(pv_lock_ops.kick_cpu, cpu);
+}
+
+/*
+ * Return 0 if CPU has been halted or -1 if aborted.
+ */
+static __always_inline int pv_lockwait(u8 *byte, u8 val)
+{
+	return PVOP_CALLEE2(int, pv_lock_ops.lockwait, byte, val);
+}
+
+static __always_inline void pv_lockstat(int stat_types)
+{
+	PVOP_VCALLEE1(pv_lock_ops.lockstat, stat_types);
+}
+
+#else
 static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock,
 							__ticket_t ticket)
 {
@@ -723,6 +744,7 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
 {
 	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
 }
+#endif
 
 #endif
 
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 7549b8b..b4b4065 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -326,6 +326,9 @@ struct pv_mmu_ops {
 			   phys_addr_t phys, pgprot_t flags);
 };
 
+struct mcs_spinlock;
+struct qspinlock;
+
 struct arch_spinlock;
 #ifdef CONFIG_SMP
 #include <asm/spinlock_types.h>
@@ -333,9 +336,33 @@ struct arch_spinlock;
 typedef u16 __ticket_t;
 #endif
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+enum pv_lock_stats {
+	_PV_HALT_QHEAD,		/* Queue head halting	    */
+	_PV_HALT_QNODE,		/* Other queue node halting */
+	_PV_HALT_ABORT,		/* Halting aborted	    */
+	_PV_WAKE_KICKED,	/* Wakeup by kicking	    */
+	_PV_WAKE_SPURIOUS,	/* Spurious wakeup	    */
+	_PV_KICK_NOHALT		/* Kick but CPU not halted  */
+};
+
+#define PV_LOCKSTAT_HALT_QHEAD		(1 << _PV_HALT_QHEAD)
+#define PV_LOCKSTAT_HALT_QNODE		(1 << _PV_HALT_QNODE)
+#define PV_LOCKSTAT_HALT_ABORT		(1 << _PV_HALT_ABORT)
+#define PV_LOCKSTAT_WAKE_KICKED		(1 << _PV_WAKE_KICKED)
+#define PV_LOCKSTAT_WAKE_SPURIOUS	(1 << _PV_WAKE_SPURIOUS)
+#define PV_LOCKSTAT_KICK_NOHALT		(1 << _PV_KICK_NOHALT)
+#endif
+
 struct pv_lock_ops {
+#ifdef CONFIG_QUEUE_SPINLOCK
+	void (*kick_cpu)(int cpu);
+	struct paravirt_callee_save lockstat;
+	struct paravirt_callee_save lockwait;
+#else
 	struct paravirt_callee_save lock_spinning;
 	void (*unlock_kick)(struct arch_spinlock *lock, __ticket_t ticket);
+#endif
 };
 
 /* This contains all the paravirt structures: we get a convenient
diff --git a/arch/x86/include/asm/pvqspinlock.h b/arch/x86/include/asm/pvqspinlock.h
new file mode 100644
index 0000000..52d77aa
--- /dev/null
+++ b/arch/x86/include/asm/pvqspinlock.h
@@ -0,0 +1,426 @@
+#ifndef _ASM_X86_PVQSPINLOCK_H
+#define _ASM_X86_PVQSPINLOCK_H
+
+/*
+ *	Queue Spinlock Para-Virtualization (PV) Support
+ *
+ * The PV support code for queue spinlock is roughly the same as that
+ * of the ticket spinlock. Each CPU waiting for the lock will spin until it
+ * reaches a threshold. When that happens, it will put itself to a halt state
+ * so that the hypervisor can reuse the CPU cycles in some other guests as
+ * well as returning other hold-up CPUs faster.
+ *
+ * Auxillary fields in the pv_qnode structure are used to hold information
+ * relevant to the PV support so that it won't impact on the behavior and
+ * performance of the bare metal code.
+ *
+ * There are 2 places where races can happen:
+ *  1) Halting of the queue head CPU (in pv_wait_head) and the CPU
+ *     kicking by the lock holder in the unlock path (in pv_kick_node).
+ *  2) Halting of the queue node CPU (in pv_link_and_wait_node) and the
+ *     the status check by the previous queue head (in pv_wait_check).
+ *
+ * See the comments on those functions to see how the races are being
+ * addressed.
+ */
+
+/*
+ * Spin thresholds for queue spinlock
+ *
+ * The mayhalt threshold is used to avoid the introduction of an additional
+ * memory barrier or atomic instruction in pv_wait_check() under normal
+ * circumstances. If it is close to the threshold, the penalty has to be
+ * paid to make sure that we won't miss a halted waiter.
+ */
+#define	QSPIN_THRESHOLD		SPIN_THRESHOLD
+#define MAYHALT_THRESHOLD	(QSPIN_THRESHOLD >> 5)
+
+/*
+ * CPU state flags
+ */
+#define PV_CPU_ACTIVE	1	/* This CPU is active		 */
+#define PV_CPU_KICKED   2	/* This CPU is being kicked	 */
+#define PV_CPU_HALTED	-1	/* This CPU is halted		 */
+
+/*
+ * Special head node pointer value
+ */
+#define PV_INVALID_HEAD	NULL
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
+	struct mcs_spinlock  __res[3];	/* 3 reserved MCS nodes		*/
+	s8		     cpustate;	/* CPU status flag		*/
+	s8		     mayhalt;	/* May be halted soon		*/
+	int		     mycpu;	/* CPU number of this node	*/
+	struct mcs_spinlock  *head;	/* Queue head node pointer	*/
+};
+
+/**
+ * pv_init_node - initialize fields in struct pv_qnode
+ * @node: pointer to struct mcs_spinlock
+ * @cpu : current CPU number
+ */
+static inline void pv_init_node(struct mcs_spinlock *node)
+{
+	struct pv_qnode *pn = (struct pv_qnode *)node;
+
+	BUILD_BUG_ON(sizeof(struct pv_qnode) > 5*sizeof(struct mcs_spinlock));
+
+	pn->cpustate = PV_CPU_ACTIVE;
+	pn->mayhalt  = false;
+	pn->mycpu    = smp_processor_id();
+	pn->head     = PV_INVALID_HEAD;
+}
+
+/**
+ * pv_decode_tail - initialize fields in struct pv_qnode
+ * @tail: the tail code (lock value)
+ * Return: a pointer to the tail pv_qnode structure
+ */
+static inline struct pv_qnode *pv_decode_tail(u32 tail)
+{
+	return (struct pv_qnode *)decode_tail(tail);
+}
+
+/**
+ * pv_set_head_in_tail - set head node pointer in tail node
+ * @lock: pointer to the qspinlock structure
+ * @head: pointer to queue head mcs_spinlock structure
+ */
+static inline void
+pv_set_head_in_tail(struct qspinlock *lock, struct mcs_spinlock *head)
+{
+	struct pv_qnode *tn, *new_tn;	/* Tail nodes */
+
+	/*
+	 * The writing is repeated in case the queue tail changes and the
+	 * correct head isn't there yet.
+	 */
+	new_tn = pv_decode_tail(atomic_read(&lock->val));
+	do {
+		tn = new_tn;
+		while (tn->head == PV_INVALID_HEAD)
+			cpu_relax();
+		/*
+		 * Use an atomic op to make sure that other queuing CPUs see
+		 * the new head value before reading the tail again.
+		 */
+		(void)xchg(&tn->head, head);
+		new_tn = pv_decode_tail(atomic_read(&lock->val));
+	} while (tn != new_tn);
+}
+
+/**
+ * pv_link_and_wait_node - perform para-virtualization checks for queue member
+ * @old  : the old lock value
+ * @node : pointer to the mcs_spinlock structure
+ * Return: true if PV spinlock is enabled, false otherwise.
+ */
+static inline bool pv_link_and_wait_node(u32 old, struct mcs_spinlock *node)
+{
+	struct pv_qnode *ppn, *pn = (struct pv_qnode *)node;
+	unsigned int count;
+
+	if (!(old & _Q_TAIL_MASK)) {
+		node->locked = true;	/* At queue head now */
+		goto gotlock;
+	}
+
+	ppn = pv_decode_tail(old);
+	ACCESS_ONCE(ppn->mcs.next) = node;
+
+	/*
+	 * It is possible that this node will become the queue head while
+	 * waiting for the head value of the previous node to be set.
+	 */
+	while (ppn->head == PV_INVALID_HEAD) {
+		if (node->locked)
+			goto gotlock;
+		cpu_relax();
+	}
+	pn->head = ppn->head;
+
+	for (;;) {
+		count = QSPIN_THRESHOLD/2;
+
+		while (count--) {
+			if (smp_load_acquire(&node->locked))
+				goto gotlock;
+			if (count == MAYHALT_THRESHOLD) {
+				pn->mayhalt = true;
+				/*
+				 * Make sure that the mayhalt flag is visible
+				 * to others.
+				 */
+				smp_mb();
+			}
+			cpu_relax();
+		}
+		/*
+		 * Halt oneself after QSPIN_THRESHOLD/2 spins, the spin
+		 * threshold is less than that of the queue head so that
+		 * tasks waiting on a lightly contended spinlock has higher
+		 * chance of proceeding.
+		 */
+		if (cmpxchg(&pn->cpustate, PV_CPU_ACTIVE, PV_CPU_HALTED)
+		    != PV_CPU_ACTIVE) {
+			pn->cpustate = PV_CPU_ACTIVE;
+			continue;	/* Reset CPU state and count */
+		}
+
+		/*
+		 * One way to avoid the racing between pv_wait_check()
+		 * and pv_link_and_wait_node() is to use memory barrier or
+		 * atomic instruction to synchronize between the two competing
+		 * threads. However, that will slow down the queue spinlock
+		 * slowpath. One way to eliminate this overhead for normal
+		 * cases is to use another flag (mayhalt) to indicate that
+		 * racing condition may happen. This flag is set when the
+		 * loop count is getting close to the halting threshold.
+		 *
+		 * When that happens, a 2 variables (cpustate & node->locked
+		 * handshake is used to make sure that pv_wait_check() won't
+		 * miss setting the _Q_LOCKED_SLOWPATH when the CPU is about
+		 * to be halted.
+		 *
+		 * pv_wait_check		pv_link_and_wait_node
+		 * -------------		---------------------
+		 * [1] node->locked = true	[3] cpustate = PV_CPU_HALTED
+		 *     smp_mb()			    barrier();
+		 * [2] if (cpustate		[4] if (node->locked)
+		 *        == PV_CPU_HALTED)
+		 *
+		 * Sequence:
+		 * *,1,*,4,* - halt is aborted as the node->locked flag is set,
+		 *	       _Q_LOCKED_SLOWPATH may or may not be set
+		 * 3,4,1,2 - the CPU is halt and _Q_LOCKED_SLOWPATH is set
+		 */
+		if (!ACCESS_ONCE(node->locked)) {
+			/*
+			 * Halt the CPU only if it is not the queue head
+			 */
+			if (pv_lockwait(&pn->cpustate, PV_CPU_HALTED) == 0)
+				pv_lockstat(PV_LOCKSTAT_HALT_QNODE |
+					   ((pn->cpustate == PV_CPU_KICKED)
+					   ? PV_LOCKSTAT_WAKE_KICKED
+					   : PV_LOCKSTAT_WAKE_SPURIOUS));
+		}
+		ACCESS_ONCE(pn->cpustate) = PV_CPU_ACTIVE;
+		pn->mayhalt = false;
+
+		if (smp_load_acquire(&node->locked))
+			break;
+	}
+gotlock:
+	pn->head = node;
+	return true;
+}
+
+/**
+ * pv_wait_head - para-virtualization waiting loop for the queue head
+ * @lock : pointer to the qspinlock structure
+ * @node : pointer to the mcs_spinlock structure
+ * Return: the current lock value
+ *
+ * This function will halt itself if lock is still not available after
+ * QSPIN_THRESHOLD iterations.
+ */
+static inline int
+pv_wait_head(struct qspinlock *lock, struct mcs_spinlock *node)
+{
+	struct pv_qnode *pn = (struct pv_qnode *)node;
+
+	for (;;) {
+		unsigned int count;
+		s8 oldstate;
+		int val;
+
+reset:
+		count = QSPIN_THRESHOLD;
+		ACCESS_ONCE(pn->cpustate) = PV_CPU_ACTIVE;
+
+		while (count--) {
+			val = smp_load_acquire(&lock->val.counter);
+			if (!(val & _Q_LOCKED_PENDING_MASK))
+				return val;
+			if (pn->cpustate == PV_CPU_KICKED)
+				/*
+				 * Reset count and flag
+				 */
+				goto reset;
+			cpu_relax();
+		}
+
+		/*
+		 * Write the head CPU number into the queue tail node before
+		 * halting.
+		 */
+		pv_set_head_in_tail(lock, node);
+
+		/*
+		 * Set the lock byte to _Q_LOCKED_SLOWPATH before
+		 * trying to halt itself. It is possible that the
+		 * lock byte had been set to _Q_LOCKED_SLOWPATH
+		 * already (spurious wakeup of queue head after a halt
+		 * or opportunistic setting in pv_wait_check()).
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
+		oldstate = cmpxchg(&pn->cpustate, PV_CPU_ACTIVE, PV_CPU_HALTED);
+		if (oldstate == PV_CPU_KICKED)
+			continue;	/* Reset count & flag */
+
+		val = cmpxchg((u8 *)lock,
+				  _Q_LOCKED_VAL, _Q_LOCKED_SLOWPATH);
+		if (val) {
+			if (pv_lockwait((u8 *)lock, _Q_LOCKED_SLOWPATH) == 0)
+				pv_lockstat(PV_LOCKSTAT_HALT_QHEAD |
+					   ((pn->cpustate == PV_CPU_KICKED)
+					   ? PV_LOCKSTAT_WAKE_KICKED
+					   : PV_LOCKSTAT_WAKE_SPURIOUS));
+		} else {
+			/*
+			 * The lock is free and no halting is needed
+			 */
+			ACCESS_ONCE(pn->cpustate) = PV_CPU_ACTIVE;
+			return smp_load_acquire(&lock->val.counter);
+		}
+	}
+	/* Unreachable */
+	return 0;
+}
+
+/**
+ * pv_wait_check - check if the next queue head CPU has been halted
+ * @lock: pointer to the qspinlock structure
+ * @node: pointer to the mcs_spinlock structure of lock holder
+ * @next: pointer to the mcs_spinlock structure of new queue head
+ *
+ * The current CPU should have gotten the lock before calling this function.
+ */
+static inline void pv_wait_check(struct qspinlock *lock,
+		   struct mcs_spinlock *node, struct mcs_spinlock *next)
+{
+	struct pv_qnode *pnxt = (struct pv_qnode *)next;
+	struct pv_qnode *pcur = (struct pv_qnode *)node;
+
+	/*
+	 * Clear the locked and head values of lock holder
+	 */
+	pcur->mcs.locked = false;
+	pcur->head	 = PV_INVALID_HEAD;
+
+	/*
+	 * Halt state checking will only be done if the mayhalt flag is set
+	 * to avoid the overhead of the memory barrier in normal cases.
+	 * It is highly unlikely that the actual writing to the node->locked
+	 * flag will be more than 0x10 iterations later than the reading of
+	 * the mayhalt flag so that it misses seeing the PV_CPU_HALTED state
+	 * which causes lost wakeup.
+	 */
+	if (!ACCESS_ONCE(pnxt->mayhalt))
+		return;
+
+	/*
+	 * A memory barrier is used here to make sure that the setting
+	 * of node->locked flag prior to this function call is visible
+	 * to others before checking the cpustate flag.
+	 */
+	smp_mb();
+	if (pnxt->cpustate != PV_CPU_HALTED)
+		return;
+
+	pv_set_head_in_tail(lock, next);
+	ACCESS_ONCE(*(u8 *)lock) = _Q_LOCKED_SLOWPATH;
+}
+
+/**
+ * pv_kick_node - kick up the CPU of the given node
+ * @node : pointer to struct mcs_spinlock of the node to be kicked
+ */
+static inline void pv_kick_node(struct mcs_spinlock *node)
+{
+	struct pv_qnode *pn = (struct pv_qnode *)node;
+	s8 oldstate;
+
+	oldstate = xchg(&pn->cpustate, PV_CPU_KICKED);
+	/*
+	 * Kick the CPU only if the state was set to PV_CPU_HALTED
+	 */
+	if (oldstate != PV_CPU_HALTED)
+		pv_lockstat(PV_LOCKSTAT_KICK_NOHALT);
+	else
+		pv_kick_cpu(pn->mycpu);
+}
+
+/*
+ * pv_get_qhead - get node pointer of queue head
+ * @lock : pointer to the qspinlock structure
+ * Return: pointer to mcs_spinlock structure of queue head
+ */
+static inline struct mcs_spinlock *pv_get_qhead(struct qspinlock *lock)
+{
+	struct pv_qnode *pn = pv_decode_tail(atomic_read(&lock->val));
+
+	while (pn->head == PV_INVALID_HEAD)
+		cpu_relax();
+
+	BUG_ON(!pn->head->locked);
+	return pn->head;
+}
+
+/**
+ * queue_spin_unlock_slowpath - kick up the CPU of the queue head
+ * @lock : Pointer to queue spinlock structure
+ *
+ * The lock is released after finding the queue head to avoid racing
+ * condition between the queue head and the lock holder.
+ */
+void queue_spin_unlock_slowpath(struct qspinlock *lock)
+{
+	struct mcs_spinlock *node = pv_get_qhead(lock);
+
+	/*
+	 * Found the queue head, now release the lock before waking it up
+	 */
+	native_spin_unlock(lock);
+	pv_kick_node(node);
+}
+EXPORT_SYMBOL(queue_spin_unlock_slowpath);
+
+#endif /* _ASM_X86_PVQSPINLOCK_H */
diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
index 05a77fe..28daa2b 100644
--- a/arch/x86/include/asm/qspinlock.h
+++ b/arch/x86/include/asm/qspinlock.h
@@ -5,21 +5,86 @@
 #include <asm-generic/qspinlock_types.h>
 
 #ifndef CONFIG_X86_PPRO_FENCE
+static __always_inline void native_spin_unlock(struct qspinlock *lock)
+{
+	barrier();
+	ACCESS_ONCE(*(u8 *)lock) = 0;
+}
+#else
+static __always_inline void native_spin_unlock(struct qspinlock *lock)
+{
+	atomic_dec(&lock->val);
+}
+#endif /* !CONFIG_X86_PPRO_FENCE */
 
 #define	queue_spin_unlock queue_spin_unlock
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+/*
+ * The lock byte can have a value of _Q_LOCKED_SLOWPATH to indicate
+ * that it needs to go through the slowpath to do the unlocking.
+ */
+#define _Q_LOCKED_SLOWPATH	(_Q_LOCKED_VAL | 2)
+
+extern void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val);
+extern void pv_queue_spin_lock_slowpath(struct qspinlock *lock, u32 val);
+
+/*
+ * Paravirtualized versions of queue_spin_lock and queue_spin_unlock
+ */
+
+#define queue_spin_lock	queue_spin_lock
+/**
+ * queue_spin_lock - acquire a queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ *
+ * N.B. INLINE_SPIN_LOCK should not be enabled when PARAVIRT_SPINLOCK is on.
+ */
+static __always_inline void queue_spin_lock(struct qspinlock *lock)
+{
+	u32 val;
+
+	val = atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL);
+	if (likely(val == 0))
+		return;
+	if (static_key_false(&paravirt_spinlocks_enabled))
+		pv_queue_spin_lock_slowpath(lock, val);
+	else
+		queue_spin_lock_slowpath(lock, val);
+}
+
+extern void queue_spin_unlock_slowpath(struct qspinlock *lock);
+
 /**
  * queue_spin_unlock - release a queue spinlock
  * @lock : Pointer to queue spinlock structure
  *
  * An effective smp_store_release() on the least-significant byte.
+ *
+ * Inlining of the unlock function is disabled when CONFIG_PARAVIRT_SPINLOCKS
+ * is defined. So _raw_spin_unlock() will be the only call site that will
+ * have to be patched.
  */
 static inline void queue_spin_unlock(struct qspinlock *lock)
 {
 	barrier();
-	ACCESS_ONCE(*(u8 *)lock) = 0;
-}
+	if (!static_key_false(&paravirt_spinlocks_enabled)) {
+		native_spin_unlock(lock);
+		return;
+	}
 
-#endif /* !CONFIG_X86_PPRO_FENCE */
+	/*
+	 * Need to atomically clear the lock byte to avoid racing with
+	 * queue head waiter trying to set _QLOCK_LOCKED_SLOWPATH.
+	 */
+	if (unlikely(cmpxchg((u8 *)lock, _Q_LOCKED_VAL, 0) != _Q_LOCKED_VAL))
+		queue_spin_unlock_slowpath(lock);
+}
+#else
+static inline void queue_spin_unlock(struct qspinlock *lock)
+{
+	native_spin_unlock(lock);
+}
+#endif /* CONFIG_PARAVIRT_SPINLOCKS */
 
 #define virt_queue_spin_lock virt_queue_spin_lock
 
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index e434f24..6dfa2be 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -10,9 +10,15 @@
 
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
+#ifdef CONFIG_QUEUE_SPINLOCK
+	.kick_cpu = paravirt_nop,
+	.lockstat = __PV_IS_CALLEE_SAVE(paravirt_nop),
+	.lockwait = __PV_IS_CALLEE_SAVE(paravirt_nop),
+#else
 	.lock_spinning = __PV_IS_CALLEE_SAVE(paravirt_nop),
 	.unlock_kick = paravirt_nop,
 #endif
+#endif
 };
 EXPORT_SYMBOL(pv_lock_ops);
 
diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
index 82054a1..757bd69 100644
--- a/include/asm-generic/qspinlock.h
+++ b/include/asm-generic/qspinlock.h
@@ -67,6 +67,7 @@ static __always_inline int queue_spin_trylock(struct qspinlock *lock)
 	return 0;
 }
 
+#ifndef queue_spin_lock
 extern void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val);
 
 /**
@@ -82,6 +83,7 @@ static __always_inline void queue_spin_lock(struct qspinlock *lock)
 		return;
 	queue_spin_lock_slowpath(lock, val);
 }
+#endif
 
 #ifndef queue_spin_unlock
 /**
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 1c1926a..3d05d3a 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -16,6 +16,7 @@
  * Authors: Waiman Long <waiman.long@hp.com>
  *          Peter Zijlstra <pzijlstr@redhat.com>
  */
+#ifndef _GEN_PV_LOCK_SLOWPATH
 #include <linux/smp.h>
 #include <linux/bug.h>
 #include <linux/cpumask.h>
@@ -63,13 +64,21 @@
 
 #include "mcs_spinlock.h"
 
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+#define MAX_NODES	8
+#else
+#define MAX_NODES	4
+#endif
+
 /*
  * Per-CPU queue node structures; we can never have more than 4 nested
  * contexts: task, softirq, hardirq, nmi.
  *
  * Exactly fits one 64-byte cacheline on a 64-bit architecture.
+ *
+ * PV doubles the storage and uses the second cacheline for PV states.
  */
-static DEFINE_PER_CPU_ALIGNED(struct mcs_spinlock, mcs_nodes[4]);
+static DEFINE_PER_CPU_ALIGNED(struct mcs_spinlock, mcs_nodes[MAX_NODES]);
 
 /*
  * We must be able to distinguish between no-tail and the tail at 0:0,
@@ -228,6 +237,33 @@ static __always_inline void set_locked(struct qspinlock *lock)
 	ACCESS_ONCE(l->locked) = _Q_LOCKED_VAL;
 }
 
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+#include <asm/pvqspinlock.h>
+#endif
+
+/*
+ * Non-PV functions for bare-metal slowpath code
+ */
+static inline void nonpv_init_node(struct mcs_spinlock *node)	{ }
+static inline void nonpv_wait_check(struct qspinlock *lock,
+				    struct mcs_spinlock *node,
+				    struct mcs_spinlock *next)	{ }
+static inline bool nonpv_link_and_wait_node(u32 old, struct mcs_spinlock *node)
+		   { return false; }
+static inline int  nonpv_wait_head(struct qspinlock *lock,
+				struct mcs_spinlock *node)
+		   { return smp_load_acquire(&lock->val.counter); }
+static inline bool return_true(void)	{ return true;  }
+static inline bool return_false(void)	{ return false; }
+
+#define pv_init_node		nonpv_init_node
+#define pv_wait_check		nonpv_wait_check
+#define pv_link_and_wait_node	nonpv_link_and_wait_node
+#define pv_wait_head		nonpv_wait_head
+#define pv_enabled		return_false
+
+#endif	/* _GEN_PV_LOCK_SLOWPATH */
+
 /**
  * queue_spin_lock_slowpath - acquire the queue spinlock
  * @lock: Pointer to queue spinlock structure
@@ -257,6 +293,9 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 
 	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
 
+	if (pv_enabled())
+		goto queue;
+
 	if (virt_queue_spin_lock(lock))
 		return;
 
@@ -333,6 +372,7 @@ queue:
 	node += idx;
 	node->locked = 0;
 	node->next = NULL;
+	pv_init_node(node);
 
 	/*
 	 * We touched a (possibly) cold cacheline in the per-cpu queue node;
@@ -354,7 +394,7 @@ queue:
 	 * if there was a previous node; link it and wait until reaching the
 	 * head of the waitqueue.
 	 */
-	if (old & _Q_TAIL_MASK) {
+	if (!pv_link_and_wait_node(old, node) && (old & _Q_TAIL_MASK)) {
 		prev = decode_tail(old);
 		ACCESS_ONCE(prev->next) = node;
 
@@ -369,9 +409,11 @@ queue:
 	 *
 	 * *,x,y -> *,0,0
 	 */
-	while ((val = smp_load_acquire(&lock->val.counter)) &
-			_Q_LOCKED_PENDING_MASK)
+	val = pv_wait_head(lock, node);
+	while (val & _Q_LOCKED_PENDING_MASK) {
 		cpu_relax();
+		val = smp_load_acquire(&lock->val.counter);
+	}
 
 	/*
 	 * claim the lock:
@@ -402,6 +444,7 @@ queue:
 		cpu_relax();
 
 	arch_mcs_spin_unlock_contended(&next->locked);
+	pv_wait_check(lock, node, next);
 
 release:
 	/*
@@ -410,3 +453,22 @@ release:
 	this_cpu_dec(mcs_nodes[0].count);
 }
 EXPORT_SYMBOL(queue_spin_lock_slowpath);
+
+#if !defined(_GEN_PV_LOCK_SLOWPATH) && defined(CONFIG_PARAVIRT_SPINLOCKS)
+/*
+ * Generate the PV version of the queue_spin_lock_slowpath function by
+ * enabling all the PV specific code paths.
+ */
+#undef	pv_enabled
+#undef	pv_init_node
+#undef	pv_wait_check
+#undef	pv_link_and_wait_node
+#undef	pv_wait_head
+
+#define _GEN_PV_LOCK_SLOWPATH
+#define pv_enabled			return_true
+#define queue_spin_lock_slowpath	pv_queue_spin_lock_slowpath
+
+#include "qspinlock.c"
+
+#endif
-- 
1.7.1

