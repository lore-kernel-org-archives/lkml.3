Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaDRRF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:05:56 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:43418 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaDRRFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:05:49 -0400
Message-ID: <53515B56.3070406@hp.com>
Date: Fri, 18 Apr 2014 13:05:26 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Marcos Matsunaga <Marcos.Matsunaga@oracle.com>
Subject: Re: [PATCH v9 00/19] qspinlock: a 4-byte queue spinlock with PV support
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com> <20140417172246.GA9849@localhost.localdomain> <53508474.7010402@hp.com> <20140418131807.GD4010@phenom.dumpdata.com>
In-Reply-To: <20140418131807.GD4010@phenom.dumpdata.com>
Content-Type: multipart/mixed;
 boundary="------------070403060406010903060403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070403060406010903060403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/18/2014 09:18 AM, Konrad Rzeszutek Wilk wrote:
> On Thu, Apr 17, 2014 at 09:48:36PM -0400, Waiman Long wrote:
>> On 04/17/2014 01:23 PM, Konrad Rzeszutek Wilk wrote:
>>> On Thu, Apr 17, 2014 at 11:03:52AM -0400, Waiman Long wrote:
>>>> v8->v9:
>>>>    - Integrate PeterZ's version of the queue spinlock patch with some
>>>>      modification:
>>>>      http://lkml.kernel.org/r/20140310154236.038181843@infradead.org
>>>>    - Break the more complex patches into smaller ones to ease review effort.
>>>>    - Fix a racing condition in the PV qspinlock code.
>>> I am not seeing anything mentioning that the overcommit scenario
>>> for KVM and Xen had been fixed. Or was the 'racing condition' said
>>> issue?
>>>
>>> Thanks.
>> The hanging is caused by a racing condition which should be fixed in
>> the v9 patch. Please let me know if you are still seeing it.
> OK, is there a git tree with these patches to easily slurp them up?
>

I am sorry that I don't have a public git tree with the qspinlock 
patches. However, I have made a consolidated patch (patches 1-19) in the 
attached file. Hopefully that will make it easier to apply the patch. 
BTW, it has to be on top of 3.15-rc1 or later version. This may also be 
a conflict in the xen/spinlock.c file.

-Longman

--------------070403060406010903060403
Content-Type: text/plain;
 name="qspinlock-consolidated-patches"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="qspinlock-consolidated-patches"

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..2f06976 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -29,6 +29,7 @@ config X86
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_INT128 if X86_64
 	select ARCH_WANTS_PROT_NUMA_PROT_NONE
+	select ARCH_USE_QUEUE_SPINLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_PCSPKR_PLATFORM
@@ -584,6 +585,17 @@ config PARAVIRT_SPINLOCKS
 
 	  If you are unsure how to answer this question, answer Y.
 
+config PARAVIRT_UNFAIR_LOCKS
+	bool "Enable unfair locks in a para-virtualized guest"
+	depends on PARAVIRT && SMP && QUEUE_SPINLOCK
+	depends on !CONFIG_X86_OOSTORE && !CONFIG_X86_PPRO_FENCE
+	---help---
+	  This changes the kernel to use unfair locks in a
+	  para-virtualized guest. This will help performance in most
+	  cases. However, there is a possibility of lock starvation
+	  on a heavily contended lock especially in a large guest
+	  with many virtual CPUs.
+
 source "arch/x86/xen/Kconfig"
 
 config KVM_GUEST
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index cd6e161..d71e123 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -711,7 +711,23 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 }
 
 #if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
+#ifdef CONFIG_QUEUE_SPINLOCK
+static __always_inline void __queue_kick_cpu(int cpu)
+{
+	PVOP_VCALL1(pv_lock_ops.kick_cpu, cpu);
+}
+
+static __always_inline void
+__queue_halt_cpu(enum pv_lock_stats type, s8 *state, s8 sval)
+{
+	PVOP_VCALL3(pv_lock_ops.halt_cpu, type, state, sval);
+}
 
+static __always_inline void __queue_lockstat(enum pv_lock_stats type)
+{
+	PVOP_VCALL1(pv_lock_ops.lockstat, type);
+}
+#else
 static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock,
 							__ticket_t ticket)
 {
@@ -723,7 +739,7 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
 {
 	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
 }
-
+#endif
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 7549b8b..549b3a0 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -333,9 +333,26 @@ struct arch_spinlock;
 typedef u16 __ticket_t;
 #endif
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+enum pv_lock_stats {
+	PV_HALT_QHEAD,		/* Queue head halting	    */
+	PV_HALT_QNODE,		/* Other queue node halting */
+	PV_HALT_ABORT,		/* Halting aborted	    */
+	PV_WAKE_KICKED,		/* Wakeup by kicking	    */
+	PV_WAKE_SPURIOUS,	/* Spurious wakeup	    */
+	PV_KICK_NOHALT		/* Kick but CPU not halted  */
+};
+#endif
+
 struct pv_lock_ops {
+#ifdef CONFIG_QUEUE_SPINLOCK
+	void (*kick_cpu)(int cpu);
+	void (*halt_cpu)(enum pv_lock_stats type, s8 *state, s8 sval);
+	void (*lockstat)(enum pv_lock_stats type);
+#else
 	struct paravirt_callee_save lock_spinning;
 	void (*unlock_kick)(struct arch_spinlock *lock, __ticket_t ticket);
+#endif
 };
 
 /* This contains all the paravirt structures: we get a convenient
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
new file mode 100644
index 0000000..a145c31
--- /dev/null
+++ b/arch/x86/include/asm/qspinlock.h
@@ -0,0 +1,141 @@
+#ifndef _ASM_X86_QSPINLOCK_H
+#define _ASM_X86_QSPINLOCK_H
+
+#include <asm-generic/qspinlock_types.h>
+
+#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
+
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+extern struct static_key paravirt_unfairlocks_enabled;
+#endif
+
+#define	queue_spin_unlock queue_spin_unlock
+/**
+ * queue_spin_unlock - release a queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ *
+ * No special memory barrier other than a compiler one is needed for the
+ * x86 architecture. A compiler barrier is added at the end to make sure
+ * that the clearing the lock bit is done ASAP without artificial delay
+ * due to compiler optimization.
+ */
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+static __always_inline void __queue_spin_unlock(struct qspinlock *lock)
+#else
+static inline void queue_spin_unlock(struct qspinlock *lock)
+#endif
+{
+	barrier();
+	ACCESS_ONCE(*(u8 *)lock) = 0;
+	barrier();
+}
+
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
+#endif /* !CONFIG_X86_OOSTORE && !CONFIG_X86_PPRO_FENCE */
+
+#include <asm-generic/qspinlock.h>
+
+union arch_qspinlock {
+	atomic_t val;
+	u8	 locked;
+};
+
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+/**
+ * queue_spin_trylock_unfair - try to acquire the queue spinlock unfairly
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static __always_inline int queue_spin_trylock_unfair(struct qspinlock *lock)
+{
+	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
+
+	if (!qlock->locked && (cmpxchg(&qlock->locked, 0, _Q_LOCKED_VAL) == 0))
+		return 1;
+	return 0;
+}
+
+/**
+ * queue_spin_lock_unfair - acquire a queue spinlock unfairly
+ * @lock: Pointer to queue spinlock structure
+ */
+static __always_inline void queue_spin_lock_unfair(struct qspinlock *lock)
+{
+	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
+
+	if (likely(cmpxchg(&qlock->locked, 0, _Q_LOCKED_VAL) == 0))
+		return;
+	/*
+	 * Since the lock is now unfair, we should not activate the 2-task
+	 * pending bit spinning code path which disallows lock stealing.
+	 */
+	queue_spin_lock_slowpath(lock, -1);
+}
+
+/*
+ * Redefine arch_spin_lock and arch_spin_trylock as inline functions that will
+ * jump to the unfair versions if the static key paravirt_unfairlocks_enabled
+ * is true.
+ */
+#undef arch_spin_lock
+#undef arch_spin_trylock
+#undef arch_spin_lock_flags
+
+/**
+ * arch_spin_lock - acquire a queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ */
+static inline void arch_spin_lock(struct qspinlock *lock)
+{
+	if (static_key_false(&paravirt_unfairlocks_enabled))
+		queue_spin_lock_unfair(lock);
+	else
+		queue_spin_lock(lock);
+}
+
+/**
+ * arch_spin_trylock - try to acquire the queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static inline int arch_spin_trylock(struct qspinlock *lock)
+{
+	if (static_key_false(&paravirt_unfairlocks_enabled))
+		return queue_spin_trylock_unfair(lock);
+	else
+		return queue_spin_trylock(lock);
+}
+
+#define arch_spin_lock_flags(l, f)	arch_spin_lock(l)
+
+#endif /* CONFIG_PARAVIRT_UNFAIR_LOCKS */
+
+#endif /* _ASM_X86_QSPINLOCK_H */
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 0f62f54..428d0d1 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -39,9 +39,13 @@
 /* How long a lock should spin before we consider blocking */
 #define SPIN_THRESHOLD	(1 << 15)
 
-extern struct static_key paravirt_ticketlocks_enabled;
+extern struct static_key paravirt_spinlocks_enabled;
 static __always_inline bool static_key_false(struct static_key *key);
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+#include <asm/qspinlock.h>
+#else
+
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 
 static inline void __ticket_enter_slowpath(arch_spinlock_t *lock)
@@ -146,7 +150,7 @@ static inline void __ticket_unlock_slowpath(arch_spinlock_t *lock,
 static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	if (TICKET_SLOWPATH_FLAG &&
-	    static_key_false(&paravirt_ticketlocks_enabled)) {
+	    static_key_false(&paravirt_spinlocks_enabled)) {
 		arch_spinlock_t prev;
 
 		prev = *lock;
@@ -180,6 +184,7 @@ static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 {
 	arch_spin_lock(lock);
 }
+#endif /* CONFIG_QUEUE_SPINLOCK */
 
 static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 4f1bea1..7960268 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -23,6 +23,9 @@ typedef u32 __ticketpair_t;
 
 #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+#include <asm-generic/qspinlock_types.h>
+#else
 typedef struct arch_spinlock {
 	union {
 		__ticketpair_t head_tail;
@@ -33,6 +36,7 @@ typedef struct arch_spinlock {
 } arch_spinlock_t;
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
+#endif /* CONFIG_QUEUE_SPINLOCK */
 
 #include <asm/rwlock.h>
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f4d9600..b436419 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -88,6 +88,7 @@ obj-$(CONFIG_DEBUG_NMI_SELFTEST) += nmi_selftest.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvmclock.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= paravirt-spinlocks.o
+obj-$(CONFIG_PARAVIRT_UNFAIR_LOCKS)+= paravirt-spinlocks.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 0331cb3..eef427b 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -567,6 +567,7 @@ static void kvm_kick_cpu(int cpu)
 	kvm_hypercall2(KVM_HC_KICK_CPU, flags, apicid);
 }
 
+#ifndef CONFIG_QUEUE_SPINLOCK
 enum kvm_contention_stat {
 	TAKEN_SLOW,
 	TAKEN_SLOW_PICKUP,
@@ -794,6 +795,134 @@ static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
 		}
 	}
 }
+#else /* !CONFIG_QUEUE_SPINLOCK */
+
+#ifdef CONFIG_KVM_DEBUG_FS
+static struct dentry *d_spin_debug;
+static struct dentry *d_kvm_debug;
+static u32 kick_nohlt_stats;	/* Kick but not halt count	*/
+static u32 halt_qhead_stats;	/* Queue head halting count	*/
+static u32 halt_qnode_stats;	/* Queue node halting count	*/
+static u32 halt_abort_stats;	/* Halting abort count		*/
+static u32 wake_kick_stats;	/* Wakeup by kicking count	*/
+static u32 wake_spur_stats;	/* Spurious wakeup count	*/
+static u64 time_blocked;	/* Total blocking time		*/
+
+static int __init kvm_spinlock_debugfs(void)
+{
+	d_kvm_debug = debugfs_create_dir("kvm-guest", NULL);
+	if (!d_kvm_debug) {
+		printk(KERN_WARNING
+		       "Could not create 'kvm' debugfs directory\n");
+		return -ENOMEM;
+	}
+	d_spin_debug = debugfs_create_dir("spinlocks", d_kvm_debug);
+
+	debugfs_create_u32("kick_nohlt_stats",
+			   0644, d_spin_debug, &kick_nohlt_stats);
+	debugfs_create_u32("halt_qhead_stats",
+			   0644, d_spin_debug, &halt_qhead_stats);
+	debugfs_create_u32("halt_qnode_stats",
+			   0644, d_spin_debug, &halt_qnode_stats);
+	debugfs_create_u32("halt_abort_stats",
+			   0644, d_spin_debug, &halt_abort_stats);
+	debugfs_create_u32("wake_kick_stats",
+			   0644, d_spin_debug, &wake_kick_stats);
+	debugfs_create_u32("wake_spur_stats",
+			   0644, d_spin_debug, &wake_spur_stats);
+	debugfs_create_u64("time_blocked",
+			   0644, d_spin_debug, &time_blocked);
+	return 0;
+}
+
+static inline void kvm_halt_stats(enum pv_lock_stats type)
+{
+	if (type == PV_HALT_QHEAD)
+		add_smp(&halt_qhead_stats, 1);
+	else if (type == PV_HALT_QNODE)
+		add_smp(&halt_qnode_stats, 1);
+	else /* type == PV_HALT_ABORT */
+		add_smp(&halt_abort_stats, 1);
+}
+
+static inline void kvm_lock_stats(enum pv_lock_stats type)
+{
+	if (type == PV_WAKE_KICKED)
+		add_smp(&wake_kick_stats, 1);
+	else if (type == PV_WAKE_SPURIOUS)
+		add_smp(&wake_spur_stats, 1);
+	else /* type == PV_KICK_NOHALT */
+		add_smp(&kick_nohlt_stats, 1);
+}
+
+static inline u64 spin_time_start(void)
+{
+	return sched_clock();
+}
+
+static inline void spin_time_accum_blocked(u64 start)
+{
+	u64 delta;
+
+	delta = sched_clock() - start;
+	add_smp(&time_blocked, delta);
+}
+
+fs_initcall(kvm_spinlock_debugfs);
+
+#else /* CONFIG_KVM_DEBUG_FS */
+static inline void kvm_halt_stats(enum pv_lock_stats type)
+{
+}
+
+static inline void kvm_lock_stats(enum pv_lock_stats type)
+{
+}
+
+static inline u64 spin_time_start(void)
+{
+	return 0;
+}
+
+static inline void spin_time_accum_blocked(u64 start)
+{
+}
+#endif /* CONFIG_KVM_DEBUG_FS */
+
+/*
+ * Halt the current CPU & release it back to the host
+ */
+static void kvm_halt_cpu(enum pv_lock_stats type, s8 *state, s8 sval)
+{
+	unsigned long flags;
+	u64 start;
+
+	if (in_nmi())
+		return;
+
+	/*
+	 * Make sure an interrupt handler can't upset things in a
+	 * partially setup state.
+	 */
+	local_irq_save(flags);
+	/*
+	 * Don't halt if the CPU state has been changed.
+	 */
+	if (ACCESS_ONCE(*state) != sval) {
+		kvm_halt_stats(PV_HALT_ABORT);
+		goto out;
+	}
+	start = spin_time_start();
+	kvm_halt_stats(type);
+	if (arch_irqs_disabled_flags(flags))
+		halt();
+	else
+		safe_halt();
+	spin_time_accum_blocked(start);
+out:
+	local_irq_restore(flags);
+}
+#endif /* !CONFIG_QUEUE_SPINLOCK */
 
 /*
  * Setup pv_lock_ops to exploit KVM_FEATURE_PV_UNHALT if present.
@@ -806,8 +935,14 @@ void __init kvm_spinlock_init(void)
 	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
 		return;
 
+#ifdef CONFIG_QUEUE_SPINLOCK
+	pv_lock_ops.kick_cpu = kvm_kick_cpu;
+	pv_lock_ops.halt_cpu = kvm_halt_cpu;
+	pv_lock_ops.lockstat = kvm_lock_stats;
+#else
 	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(kvm_lock_spinning);
 	pv_lock_ops.unlock_kick = kvm_unlock_kick;
+#endif
 }
 
 static __init int kvm_spinlock_init_jump(void)
@@ -817,7 +952,7 @@ static __init int kvm_spinlock_init_jump(void)
 	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
 		return 0;
 
-	static_key_slow_inc(&paravirt_ticketlocks_enabled);
+	static_key_slow_inc(&paravirt_spinlocks_enabled);
 	printk(KERN_INFO "KVM setup paravirtual spinlock\n");
 
 	return 0;
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index bbb6c73..8d15bea 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -8,13 +8,45 @@
 
 #include <asm/paravirt.h>
 
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
+#ifdef CONFIG_QUEUE_SPINLOCK
+	.kick_cpu = paravirt_nop,
+	.halt_cpu = paravirt_nop,
+	.lockstat = paravirt_nop,
+#else
 	.lock_spinning = __PV_IS_CALLEE_SAVE(paravirt_nop),
 	.unlock_kick = paravirt_nop,
 #endif
+#endif
 };
 EXPORT_SYMBOL(pv_lock_ops);
 
-struct static_key paravirt_ticketlocks_enabled = STATIC_KEY_INIT_FALSE;
-EXPORT_SYMBOL(paravirt_ticketlocks_enabled);
+struct static_key paravirt_spinlocks_enabled = STATIC_KEY_INIT_FALSE;
+EXPORT_SYMBOL(paravirt_spinlocks_enabled);
+#endif
+
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+struct static_key paravirt_unfairlocks_enabled = STATIC_KEY_INIT_FALSE;
+EXPORT_SYMBOL(paravirt_unfairlocks_enabled);
+
+#include <linux/init.h>
+#include <asm/cpufeature.h>
+
+/*
+ * Enable unfair lock only if it is running under a hypervisor
+ */
+static __init int unfair_locks_init_jump(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		return 0;
+
+	static_key_slow_inc(&paravirt_unfairlocks_enabled);
+	printk(KERN_INFO "Unfair spinlock enabled\n");
+
+	return 0;
+}
+early_initcall(unfair_locks_init_jump);
+
+#endif
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 0ba5f3b..2a259bb 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -17,6 +17,12 @@
 #include "xen-ops.h"
 #include "debugfs.h"
 
+static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
+static DEFINE_PER_CPU(char *, irq_name);
+static bool xen_pvspin = true;
+
+#ifndef CONFIG_QUEUE_SPINLOCK
+
 enum xen_contention_stat {
 	TAKEN_SLOW,
 	TAKEN_SLOW_PICKUP,
@@ -100,12 +106,9 @@ struct xen_lock_waiting {
 	__ticket_t want;
 };
 
-static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
-static DEFINE_PER_CPU(char *, irq_name);
 static DEFINE_PER_CPU(struct xen_lock_waiting, lock_waiting);
 static cpumask_t waiting_cpus;
 
-static bool xen_pvspin = true;
 __visible void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
 {
 	int irq = __this_cpu_read(lock_kicker_irq);
@@ -213,6 +216,118 @@ static void xen_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
 	}
 }
 
+#else /* CONFIG_QUEUE_SPINLOCK */
+
+#ifdef CONFIG_XEN_DEBUG_FS
+static u32 kick_nohlt_stats;		/* Kick but not halt count	*/
+static u32 halt_qhead_stats;		/* Queue head halting count	*/
+static u32 halt_qnode_stats;		/* Queue node halting count	*/
+static u32 halt_abort_stats;		/* Halting abort count		*/
+static u32 wake_kick_stats;		/* Wakeup by kicking count	*/
+static u32 wake_spur_stats;		/* Spurious wakeup count	*/
+static u64 time_blocked;		/* Total blocking time		*/
+
+static inline void xen_halt_stats(enum pv_lock_stats type)
+{
+	if (type == PV_HALT_QHEAD)
+		add_smp(&halt_qhead_stats, 1);
+	else if (type == PV_HALT_QNODE)
+		add_smp(&halt_qnode_stats, 1);
+	else /* type == PV_HALT_ABORT */
+		add_smp(&halt_abort_stats, 1);
+}
+
+static inline void xen_lock_stats(enum pv_lock_stats type)
+{
+	if (type == PV_WAKE_KICKED)
+		add_smp(&wake_kick_stats, 1);
+	else if (type == PV_WAKE_SPURIOUS)
+		add_smp(&wake_spur_stats, 1);
+	else /* type == PV_KICK_NOHALT */
+		add_smp(&kick_nohlt_stats, 1);
+}
+
+static inline u64 spin_time_start(void)
+{
+	return sched_clock();
+}
+
+static inline void spin_time_accum_blocked(u64 start)
+{
+	u64 delta;
+
+	delta = sched_clock() - start;
+	add_smp(&time_blocked, delta);
+}
+#else /* CONFIG_XEN_DEBUG_FS */
+static inline void xen_halt_stats(enum pv_lock_stats type)
+{
+}
+
+static inline void xen_lock_stats(enum pv_lock_stats type)
+{
+}
+
+static inline u64 spin_time_start(void)
+{
+	return 0;
+}
+
+static inline void spin_time_accum_blocked(u64 start)
+{
+}
+#endif /* CONFIG_XEN_DEBUG_FS */
+
+static void xen_kick_cpu(int cpu)
+{
+	xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
+}
+
+/*
+ * Halt the current CPU & release it back to the host
+ */
+static void xen_halt_cpu(enum pv_lock_stats type, s8 *state, s8 sval)
+{
+	int irq = __this_cpu_read(lock_kicker_irq);
+	unsigned long flags;
+	u64 start;
+
+	/* If kicker interrupts not initialized yet, just spin */
+	if (irq == -1)
+		return;
+
+	/*
+	 * Make sure an interrupt handler can't upset things in a
+	 * partially setup state.
+	 */
+	local_irq_save(flags);
+	start = spin_time_start();
+
+	xen_halt_stats(type);
+	/* clear pending */
+	xen_clear_irq_pending(irq);
+
+	/* Allow interrupts while blocked */
+	local_irq_restore(flags);
+	/*
+	 * Don't halt if the CPU state has been changed.
+	 */
+	if (ACCESS_ONCE(*state) != sval) {
+		xen_halt_stats(PV_HALT_ABORT);
+		return;
+	}
+	/*
+	 * If an interrupt happens here, it will leave the wakeup irq
+	 * pending, which will cause xen_poll_irq() to return
+	 * immediately.
+	 */
+
+	/* Block until irq becomes pending (or perhaps a spurious wakeup) */
+	xen_poll_irq(irq);
+	spin_time_accum_blocked(start);
+}
+#endif /* CONFIG_QUEUE_SPINLOCK */
+
 static irqreturn_t dummy_handler(int irq, void *dev_id)
 {
 	BUG();
@@ -258,7 +373,6 @@ void xen_uninit_lock_cpu(int cpu)
 	per_cpu(irq_name, cpu) = NULL;
 }
 
-
 /*
  * Our init of PV spinlocks is split in two init functions due to us
  * using paravirt patching and jump labels patching and having to do
@@ -275,8 +389,15 @@ void __init xen_init_spinlocks(void)
 		return;
 	}
 	printk(KERN_DEBUG "xen: PV spinlocks enabled\n");
+
+#ifdef CONFIG_QUEUE_SPINLOCK
+	pv_lock_ops.kick_cpu = xen_kick_cpu;
+	pv_lock_ops.halt_cpu = xen_halt_cpu;
+	pv_lock_ops.lockstat = xen_lock_stats;
+#else
 	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(xen_lock_spinning);
 	pv_lock_ops.unlock_kick = xen_unlock_kick;
+#endif
 }
 
 /*
@@ -293,7 +414,7 @@ static __init int xen_init_spinlocks_jump(void)
 	if (!xen_domain())
 		return 0;
 
-	static_key_slow_inc(&paravirt_ticketlocks_enabled);
+	static_key_slow_inc(&paravirt_spinlocks_enabled);
 	return 0;
 }
 early_initcall(xen_init_spinlocks_jump);
@@ -321,6 +442,7 @@ static int __init xen_spinlock_debugfs(void)
 
 	d_spin_debug = debugfs_create_dir("spinlocks", d_xen);
 
+#ifndef CONFIG_QUEUE_SPINLOCK
 	debugfs_create_u8("zero_stats", 0644, d_spin_debug, &zero_stats);
 
 	debugfs_create_u32("taken_slow", 0444, d_spin_debug,
@@ -340,7 +462,22 @@ static int __init xen_spinlock_debugfs(void)
 
 	debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
 				spinlock_stats.histo_spin_blocked, HISTO_BUCKETS + 1);
-
+#else /* CONFIG_QUEUE_SPINLOCK */
+	debugfs_create_u32("kick_nohlt_stats",
+			   0644, d_spin_debug, &kick_nohlt_stats);
+	debugfs_create_u32("halt_qhead_stats",
+			   0644, d_spin_debug, &halt_qhead_stats);
+	debugfs_create_u32("halt_qnode_stats",
+			   0644, d_spin_debug, &halt_qnode_stats);
+	debugfs_create_u32("halt_abort_stats",
+			   0644, d_spin_debug, &halt_abort_stats);
+	debugfs_create_u32("wake_kick_stats",
+			   0644, d_spin_debug, &wake_kick_stats);
+	debugfs_create_u32("wake_spur_stats",
+			   0644, d_spin_debug, &wake_spur_stats);
+	debugfs_create_u64("time_blocked",
+			   0644, d_spin_debug, &time_blocked);
+#endif /* CONFIG_QUEUE_SPINLOCK */
 	return 0;
 }
 fs_initcall(xen_spinlock_debugfs);
diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
new file mode 100644
index 0000000..e8a7ae8
--- /dev/null
+++ b/include/asm-generic/qspinlock.h
@@ -0,0 +1,118 @@
+/*
+ * Queue spinlock
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * (C) Copyright 2013-2014 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ */
+#ifndef __ASM_GENERIC_QSPINLOCK_H
+#define __ASM_GENERIC_QSPINLOCK_H
+
+#include <asm-generic/qspinlock_types.h>
+
+/**
+ * queue_spin_is_locked - is the spinlock locked?
+ * @lock: Pointer to queue spinlock structure
+ * Return: 1 if it is locked, 0 otherwise
+ */
+static __always_inline int queue_spin_is_locked(struct qspinlock *lock)
+{
+	return atomic_read(&lock->val);
+}
+
+/**
+ * queue_spin_value_unlocked - is the spinlock structure unlocked?
+ * @lock: queue spinlock structure
+ * Return: 1 if it is unlocked, 0 otherwise
+ *
+ * N.B. Whenever there are tasks waiting for the lock, it is considered
+ *      locked wrt the lockref code to avoid lock stealing by the lockref
+ *      code and change things underneath the lock. This also allows some
+ *      optimizations to be applied without conflict with lockref.
+ */
+static __always_inline int queue_spin_value_unlocked(struct qspinlock lock)
+{
+	return !atomic_read(&lock.val);
+}
+
+/**
+ * queue_spin_is_contended - check if the lock is contended
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock contended, 0 otherwise
+ */
+static __always_inline int queue_spin_is_contended(struct qspinlock *lock)
+{
+	return atomic_read(&lock->val) & ~_Q_LOCKED_MASK;
+}
+/**
+ * queue_spin_trylock - try to acquire the queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static __always_inline int queue_spin_trylock(struct qspinlock *lock)
+{
+	if (!atomic_read(&lock->val) &&
+	   (atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL) == 0))
+		return 1;
+	return 0;
+}
+
+extern void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val);
+
+/**
+ * queue_spin_lock - acquire a queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ */
+static __always_inline void queue_spin_lock(struct qspinlock *lock)
+{
+	u32 val;
+
+	val = atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL);
+	if (likely(val == 0))
+		return;
+	queue_spin_lock_slowpath(lock, val);
+}
+
+#ifndef queue_spin_unlock
+/**
+ * queue_spin_unlock - release a queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ */
+static __always_inline void queue_spin_unlock(struct qspinlock *lock)
+{
+	/*
+	 * smp_mb__before_atomic() in order to guarantee release semantics
+	 */
+	smp_mb__before_atomic_dec();
+	atomic_sub(_Q_LOCKED_VAL, &lock->val);
+}
+#endif
+
+/*
+ * Initializier
+ */
+#define	__ARCH_SPIN_LOCK_UNLOCKED	{ ATOMIC_INIT(0) }
+
+/*
+ * Remapping spinlock architecture specific functions to the corresponding
+ * queue spinlock functions.
+ */
+#define arch_spin_is_locked(l)		queue_spin_is_locked(l)
+#define arch_spin_is_contended(l)	queue_spin_is_contended(l)
+#define arch_spin_value_unlocked(l)	queue_spin_value_unlocked(l)
+#define arch_spin_lock(l)		queue_spin_lock(l)
+#define arch_spin_trylock(l)		queue_spin_trylock(l)
+#define arch_spin_unlock(l)		queue_spin_unlock(l)
+#define arch_spin_lock_flags(l, f)	queue_spin_lock(l)
+
+#endif /* __ASM_GENERIC_QSPINLOCK_H */
diff --git a/include/asm-generic/qspinlock_types.h b/include/asm-generic/qspinlock_types.h
new file mode 100644
index 0000000..4914abe
--- /dev/null
+++ b/include/asm-generic/qspinlock_types.h
@@ -0,0 +1,82 @@
+/*
+ * Queue spinlock
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * (C) Copyright 2013-2014 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ */
+#ifndef __ASM_GENERIC_QSPINLOCK_TYPES_H
+#define __ASM_GENERIC_QSPINLOCK_TYPES_H
+
+/*
+ * Including atomic.h with PARAVIRT on will cause compilation errors because
+ * of recursive header file incluson via paravirt_types.h. A workaround is
+ * to include paravirt_types.h here.
+ */
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt_types.h>
+#else
+#include <linux/types.h>
+#include <linux/atomic.h>
+#include <linux/bug.h>
+#endif
+
+typedef struct qspinlock {
+	atomic_t	val;
+} arch_spinlock_t;
+
+/*
+ * Bitfields in the atomic value:
+ *
+ * When NR_CPUS < 16K
+ *  0- 7: locked byte
+ *     8: pending
+ *  9-15: not used
+ * 16-17: tail index
+ * 18-31: tail cpu (+1)
+ *
+ * When NR_CPUS >= 16K
+ *  0- 7: locked byte
+ *     8: pending
+ *  9-10: tail index
+ * 11-31: tail cpu (+1)
+ */
+#define	_Q_SET_MASK(type)	(((1U << _Q_ ## type ## _BITS) - 1)\
+				      << _Q_ ## type ## _OFFSET)
+#define _Q_LOCKED_OFFSET	0
+#define _Q_LOCKED_BITS		8
+#define _Q_LOCKED_MASK		_Q_SET_MASK(LOCKED)
+
+#define _Q_PENDING_OFFSET	(_Q_LOCKED_OFFSET + _Q_LOCKED_BITS)
+#if CONFIG_NR_CPUS < (1U << 14)
+#define _Q_PENDING_BITS		8
+#else
+#define _Q_PENDING_BITS		1
+#endif
+#define _Q_PENDING_MASK		_Q_SET_MASK(PENDING)
+
+#define _Q_TAIL_IDX_OFFSET	(_Q_PENDING_OFFSET + _Q_PENDING_BITS)
+#define _Q_TAIL_IDX_BITS	2
+#define _Q_TAIL_IDX_MASK	_Q_SET_MASK(TAIL_IDX)
+
+#define _Q_TAIL_CPU_OFFSET	(_Q_TAIL_IDX_OFFSET + _Q_TAIL_IDX_BITS)
+#define _Q_TAIL_CPU_BITS	(32 - _Q_TAIL_CPU_OFFSET)
+#define _Q_TAIL_CPU_MASK	_Q_SET_MASK(TAIL_CPU)
+
+#define _Q_TAIL_OFFSET		_Q_TAIL_IDX_OFFSET
+#define _Q_TAIL_MASK		(_Q_TAIL_IDX_MASK | _Q_TAIL_CPU_MASK)
+
+#define _Q_LOCKED_VAL		(1U << _Q_LOCKED_OFFSET)
+#define _Q_PENDING_VAL		(1U << _Q_PENDING_OFFSET)
+
+#endif /* __ASM_GENERIC_QSPINLOCK_TYPES_H */
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index d2b32ac..451e392 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -223,3 +223,10 @@ endif
 config MUTEX_SPIN_ON_OWNER
 	def_bool y
 	depends on SMP && !DEBUG_MUTEXES
+
+config ARCH_USE_QUEUE_SPINLOCK
+	bool
+
+config QUEUE_SPINLOCK
+	def_bool y if ARCH_USE_QUEUE_SPINLOCK
+	depends on SMP
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index b8bdcd4..e6741ac 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -16,6 +16,7 @@ endif
 obj-$(CONFIG_SMP) += spinlock.o
 obj-$(CONFIG_SMP) += lglock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
+obj-$(CONFIG_QUEUE_SPINLOCK) += qspinlock.o
 obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index a2dbac4..a59b677 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -17,6 +17,7 @@
 struct mcs_spinlock {
 	struct mcs_spinlock *next;
 	int locked; /* 1 if lock acquired */
+	int count;
 };
 
 #ifndef arch_mcs_spin_lock_contended
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
new file mode 100644
index 0000000..be2adca
--- /dev/null
+++ b/kernel/locking/qspinlock.c
@@ -0,0 +1,918 @@
+/*
+ * Queue spinlock
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * (C) Copyright 2013-2014 Hewlett-Packard Development Company, L.P.
+ *
+ * Authors: Waiman Long <waiman.long@hp.com>
+ *          Peter Zijlstra <pzijlstr@redhat.com>
+ */
+#include <linux/smp.h>
+#include <linux/bug.h>
+#include <linux/cpumask.h>
+#include <linux/percpu.h>
+#include <linux/hardirq.h>
+#include <linux/mutex.h>
+#include <asm/byteorder.h>
+#include <asm/qspinlock.h>
+
+#if !defined(__LITTLE_ENDIAN) && !defined(__BIG_ENDIAN)
+#error "Missing either LITTLE_ENDIAN or BIG_ENDIAN definition."
+#endif
+
+/*
+ * The basic principle of a queue-based spinlock can best be understood
+ * by studying a classic queue-based spinlock implementation called the
+ * MCS lock. The paper below provides a good description for this kind
+ * of lock.
+ *
+ * http://www.cise.ufl.edu/tr/DOC/REP-1992-71.pdf
+ *
+ * This queue spinlock implementation is based on the MCS lock, however to make
+ * it fit the 4 bytes we assume spinlock_t to be, and preserve its existing
+ * API, we must modify it some.
+ *
+ * In particular; where the traditional MCS lock consists of a tail pointer
+ * (8 bytes) and needs the next pointer (another 8 bytes) of its own node to
+ * unlock the next pending (next->locked), we compress both these: {tail,
+ * next->locked} into a single u32 value.
+ *
+ * Since a spinlock disables recursion of its own context and there is a limit
+ * to the contexts that can nest; namely: task, softirq, hardirq, nmi, we can
+ * encode the tail as and index indicating this context and a cpu number.
+ *
+ * We can further change the first spinner to spin on a bit in the lock word
+ * instead of its node; whereby avoiding the need to carry a node from lock to
+ * unlock, and preserving API.
+ *
+ * N.B. The current implementation only supports architectures that allow
+ *      atomic operations on smaller 8-bit and 16-bit data types.
+ */
+
+#include "mcs_spinlock.h"
+
+/*
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
+ * To have additional features for better virtualization support, it is
+ * necessary to store additional data in the queue node structure. So
+ * a new queue node structure will have to be defined and used here.
+ *
+ * If CONFIG_PARAVIRT_SPINLOCKS is turned on, the previous node pointer in
+ * the pv structure will be used by the unfair lock code.
+ *
+ */
+struct qnode {
+	struct mcs_spinlock mcs;
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+	int		lsteal_mask;	/* Lock stealing frequency mask	*/
+	u32		prev_tail;	/* Tail code of previous node	*/
+#ifndef CONFIG_PARAVIRT_SPINLOCKS
+	struct qnode   *qprev;		/* Previous queue node addr	*/
+#endif
+#endif
+	struct pv_qvars pv;		/* For para-virtualization	*/
+};
+#define qhead	mcs.locked	/* The queue head flag */
+
+/*
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
+ * Check the pending bit spinning threshold only if PV qspinlock is enabled
+ */
+#define PSPIN_THRESHOLD		(1 << 10)
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+#define pv_qspinlock_enabled()	static_key_false(&paravirt_spinlocks_enabled)
+#else
+#define pv_qspinlock_enabled()	false
+#endif
+
+/*
+ * Per-CPU queue node structures; we can never have more than 4 nested
+ * contexts: task, softirq, hardirq, nmi.
+ *
+ * Exactly fits one cacheline.
+ */
+static DEFINE_PER_CPU_ALIGNED(struct qnode, qnodes[4]);
+
+/*
+ * We must be able to distinguish between no-tail and the tail at 0:0,
+ * therefore increment the cpu number by one.
+ */
+
+static inline u32 encode_tail(int cpu, int idx)
+{
+	u32 tail;
+
+	tail  = (cpu + 1) << _Q_TAIL_CPU_OFFSET;
+	tail |= idx << _Q_TAIL_IDX_OFFSET; /* assume < 4 */
+
+	return tail;
+}
+
+static inline struct qnode *decode_tail(u32 tail)
+{
+	int cpu = (tail >> _Q_TAIL_CPU_OFFSET) - 1;
+	int idx = (tail &  _Q_TAIL_IDX_MASK) >> _Q_TAIL_IDX_OFFSET;
+
+	return per_cpu_ptr(&qnodes[idx], cpu);
+}
+
+#define _Q_LOCKED_PENDING_MASK	(_Q_LOCKED_MASK | _Q_PENDING_MASK)
+
+/*
+ * By using the whole 2nd least significant byte for the pending bit, we
+ * can allow better optimization of the lock acquisition for the pending
+ * bit holder.
+ */
+struct __qspinlock {
+	union {
+		atomic_t val;
+#ifdef __LITTLE_ENDIAN
+		u8	 locked;
+		struct {
+			u16	locked_pending;
+			u16	tail;
+		};
+#else
+		struct {
+			u16	tail;
+			u16	locked_pending;
+		};
+		struct {
+			u8	reserved[3];
+			u8	locked;
+		};
+#endif
+	};
+};
+
+#if _Q_PENDING_BITS == 8
+/**
+ * clear_pending_set_locked - take ownership and clear the pending bit.
+ * @lock: Pointer to queue spinlock structure
+ * @val : Current value of the queue spinlock 32-bit word
+ *
+ * *,1,0 -> *,0,1
+ */
+static __always_inline void
+clear_pending_set_locked(struct qspinlock *lock, u32 val)
+{
+	struct __qspinlock *l = (void *)lock;
+
+	ACCESS_ONCE(l->locked_pending) = 1;
+}
+
+/*
+ * xchg_tail - Put in the new queue tail code word & retrieve previous one
+ * @lock : Pointer to queue spinlock structure
+ * @tail : The new queue tail code word
+ * @pval : Pointer to current value of the queue spinlock 32-bit word
+ * Return: The previous queue tail code word
+ *
+ * xchg(lock, tail)
+ *
+ * p,*,* -> n,*,* ; prev = xchg(lock, node)
+ */
+static __always_inline u32
+xchg_tail(struct qspinlock *lock, u32 tail, u32 *pval)
+{
+	struct __qspinlock *l = (void *)lock;
+
+	return (u32)xchg(&l->tail, tail >> _Q_TAIL_OFFSET) << _Q_TAIL_OFFSET;
+}
+
+/*
+ * cmpxchg_tail - Put in the new tail code if it matches the old one
+ * @lock : Pointer to queue spinlock structure
+ * @old  : The old tail code value
+ * @new  : The new tail code value
+ * Return: true if operation succeeds, fail otherwise
+ */
+static __always_inline int
+cmpxchg_tail(struct qspinlock *lock, u32 old, u32 new)
+{
+	struct __qspinlock *l = (void *)lock;
+
+	old >>= _Q_TAIL_OFFSET;
+	new >>= _Q_TAIL_OFFSET;
+	return cmpxchg(&l->tail, old, new) == old;
+}
+
+#else /* _Q_PENDING_BITS == 8 */
+
+/**
+ * clear_pending_set_locked - take ownership and clear the pending bit.
+ * @lock: Pointer to queue spinlock structure
+ * @val : Current value of the queue spinlock 32-bit word
+ *
+ * *,1,0 -> *,0,1
+ */
+static __always_inline void
+clear_pending_set_locked(struct qspinlock *lock, u32 val)
+{
+	u32 new, old;
+
+	for (;;) {
+		new = (val & ~_Q_PENDING_MASK) | _Q_LOCKED_VAL;
+
+		old = atomic_cmpxchg(&lock->val, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+}
+
+/**
+ * xchg_tail - Put in the new queue tail code word & retrieve previous one
+ * @lock : Pointer to queue spinlock structure
+ * @tail : The new queue tail code word
+ * @pval : Pointer to current value of the queue spinlock 32-bit word
+ * Return: The previous queue tail code word
+ *
+ * xchg(lock, tail)
+ *
+ * p,*,* -> n,*,* ; prev = xchg(lock, node)
+ */
+static __always_inline u32
+xchg_tail(struct qspinlock *lock, u32 tail, u32 *pval)
+{
+	u32 old, new, val = *pval;
+
+	for (;;) {
+		new = (val & _Q_LOCKED_PENDING_MASK) | tail;
+		old = atomic_cmpxchg(&lock->val, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+	*pval = new;
+	return old;
+}
+
+/*
+ * cmpxchg_tail - Put in the new tail code if it matches the old one
+ * @lock : Pointer to queue spinlock structure
+ * @old  : The old tail code value
+ * @new  : The new tail code value
+ * Return: true if operation succeeds, fail otherwise
+ *
+ * It is assumed that the caller has grabbed the lock before calling it.
+ */
+static __always_inline int
+cmpxchg_tail(struct qspinlock *lock, u32 old, u32 new)
+{
+	u32 val;
+	u32 lp = _Q_LOCKED_VAL;	/* Lock & pending bits value */
+
+	for (;;) {
+		u32 val = atomic_cmpxchg(&lock->val, old | lp, new | lp);
+
+		/*
+		 * If the lock or pending bits somehow changes, redo it again
+		 */
+		if ((val & _Q_LOCKED_PENDING_MASK) != lp) {
+			lp = val & _Q_LOCKED_PENDING_MASK;
+			continue;
+		}
+		return val == (old | lp);
+	}
+}
+#endif /* _Q_PENDING_BITS == 8 */
+
+/*
+ ************************************************************************
+ * Inline functions for supporting unfair queue lock			*
+ ************************************************************************
+ */
+/*
+ * Unfair lock support in a virtualized guest
+ *
+ * An unfair lock can be implemented using a simple test-and-set lock like
+ * what is being done in a read-write lock. This simple scheme has 2 major
+ * problems:
+ *  1) It needs constant reading and occasionally writing to the lock word
+ *     thus putting a lot of cacheline contention traffic on the affected
+ *     cacheline.
+ *  2) Lock starvation is a real possibility especially if the number of
+ *     virtual CPUs is large.
+ *
+ * To reduce the undesirable side effects of an unfair lock, the queue
+ * unfair spinlock implements a more elaborate scheme.  Lock stealing is
+ * allowed in the following places:
+ *  1) In the spin_lock and spin_trylock fastpaths
+ *  2) When spinning in the waiter queue before becoming the queue head
+ *
+ * A lock acquirer has only one chance of stealing the lock in the spin_lock
+ * and spin_trylock fastpath. If the attempt fails for spin_lock, the task
+ * will be queued in the wait queue.
+ *
+ * Even in the wait queue, the task can still attempt to steal the lock
+ * periodically at a frequency about inversely and logarithmically proportional
+ * to its distance from the queue head. In other word, the closer it is to
+ * the queue head, the higher a chance it has of stealing the lock. This
+ * scheme reduces the load on the lock cacheline while trying to maintain
+ * a somewhat FIFO way of getting the lock so as to reduce the chance of lock
+ * starvation.
+ */
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+#define LSTEAL_MIN		(1 << 3)
+#define LSTEAL_MAX		(1 << 10)
+#define LSTEAL_MIN_MASK		(LSTEAL_MIN - 1)
+#define LSTEAL_MAX_MASK		(LSTEAL_MAX - 1)
+
+/**
+ * unfair_init_vars - initialize unfair relevant fields in queue node structure
+ * @node: Current queue node address
+ */
+static inline void unfair_init_vars(struct qnode *node)
+{
+	node->qprev	  = NULL;
+	node->prev_tail   = 0;
+	node->lsteal_mask = LSTEAL_MIN_MASK;
+}
+
+/**
+ * unfair_set_vars - set unfair related fields in the queue node structure
+ * @node     : Current queue node address
+ * @prev     : Previous queue node address
+ * @prev_tail: Previous tail code
+ */
+static inline void
+unfair_set_vars(struct qnode *node, struct qnode *prev, u32 prev_tail)
+{
+	/*
+	 * Disable waiter lock stealing if PV spinlock is enabled
+	 */
+	if (pv_qspinlock_enabled() ||
+	   !static_key_false(&paravirt_unfairlocks_enabled))
+		return;
+
+	node->qprev	= prev;
+	node->prev_tail = prev_tail;
+	/*
+	 * This node will spin double the number of time of the previous node
+	 * before attempting to steal the lock until it reaches a maximum.
+	 */
+	node->lsteal_mask = prev->qhead ? LSTEAL_MIN_MASK :
+			    (prev->lsteal_mask << 1) + 1;
+	if (node->lsteal_mask > LSTEAL_MAX_MASK)
+		node->lsteal_mask = LSTEAL_MAX_MASK;
+	/* Make sure the new fields are visible to others */
+	smp_wmb();
+}
+
+/**
+ * unfair_check_and_clear_tail - check the tail value in lock & clear it if
+ *				 it matches the given tail
+ * @lock : Pointer to queue spinlock structure
+ * @tail : The tail code to be checked against
+ * Return: true if the tail code matches and is cleared, false otherwise
+ */
+static inline int unfair_check_and_clear_tail(struct qspinlock *lock, u32 tail)
+{
+	/*
+	 * Disable waiter lock stealing if PV spinlock is enabled
+	 */
+	if (pv_qspinlock_enabled() ||
+	   !static_key_false(&paravirt_unfairlocks_enabled))
+		return false;
+
+	/*
+	 * Try to clear the current tail code if it matches the given tail
+	 */
+	return ((atomic_read(&lock->val) & _Q_TAIL_MASK) == tail) &&
+		cmpxchg_tail(lock, tail, 0);
+}
+
+/**
+ * unfair_get_lock - try to steal the lock periodically
+ * @lock : Pointer to queue spinlock structure
+ * @node : Current queue node address
+ * @tail : My tail code value
+ * @count: Loop count
+ * Return: true if the lock has been stolen, false otherwise
+ *
+ * When a true value is returned, the caller will have to notify the next
+ * node only if the qhead flag is set and the next pointer in the queue
+ * node is not NULL.
+ */
+static inline int
+unfair_get_lock(struct qspinlock *lock, struct qnode *node, u32 tail, int count)
+{
+	u32	     prev_tail;
+	int	     isqhead;
+	struct qnode *next;
+
+	/*
+	 * Disable waiter lock stealing if PV spinlock is enabled
+	 */
+	if (pv_qspinlock_enabled() ||
+	   !static_key_false(&paravirt_unfairlocks_enabled) ||
+	   ((count & node->lsteal_mask) != node->lsteal_mask))
+		return false;
+
+	if (!queue_spin_trylock_unfair(lock)) {
+		/*
+		 * Lock stealing fails, re-adjust the lsteal mask so that
+		 * it is about double of the previous node.
+		 */
+		struct qnode *prev = node->qprev;
+
+		node->lsteal_mask = prev->qhead ? LSTEAL_MIN_MASK :
+				    (prev->lsteal_mask << 1) + 1;
+		if (node->lsteal_mask > LSTEAL_MAX_MASK)
+			node->lsteal_mask = LSTEAL_MAX_MASK;
+		return false;
+	}
+
+	/*
+	 * Have stolen the lock, need to remove itself from the wait queue.
+	 * There are 3 steps that need to be done:
+	 * 1) If it is at the end of the queue, change the tail code in the
+	 *    lock to the one before it. If the current node happens to be
+	 *    the queue head, the previous tail code is 0.
+	 * 2) Change the next pointer in the previous queue node to point
+	 *    to the next one in queue or NULL if it is at the end of queue.
+	 * 3) If a next node is present, copy the prev_tail and qprev values
+	 *    to the next node.
+	 */
+	isqhead   = ACCESS_ONCE(node->qhead);
+	prev_tail = isqhead ? 0 : node->prev_tail;
+
+	/* Step 1 */
+	if (((atomic_read(&lock->val) & _Q_TAIL_MASK) == tail) &&
+	     cmpxchg_tail(lock, tail, prev_tail)) {
+		/*
+		 * Successfully change the tail code back to the previous one.
+		 * Now need to clear the next pointer in the previous node
+		 * only if it contains my queue node address and is not
+		 * the queue head. The cmpxchg() call below may fail if
+		 * a new task comes along and put its node address into the
+		 * next pointer. Whether the operation succeeds or fails
+		 * doesn't really matter.
+		 */
+		/* Step 2 */
+		if (!isqhead)
+			(void)cmpxchg(&node->qprev->mcs.next, &node->mcs, NULL);
+		node->mcs.next = NULL;
+		return true;
+	}
+
+	/*
+	 * A next node has to be present if the lock has a different tail
+	 * code. So wait until the next pointer is set.
+	 */
+	while (!(next = (struct qnode *)ACCESS_ONCE(node->mcs.next)))
+		arch_mutex_cpu_relax();
+
+	if (!isqhead) {
+		/*
+		 * Change the node data only if it is not the queue head
+		 * Steps 2 & 3
+		 */
+		ACCESS_ONCE(node->qprev->mcs.next) =
+				(struct mcs_spinlock *)next;
+		ACCESS_ONCE(next->qprev)     = node->qprev;
+		ACCESS_ONCE(next->prev_tail) = node->prev_tail;
+
+		/*
+		 * Make sure all the new node information are visible
+		 * before proceeding.
+		 */
+		smp_wmb();
+	}
+	return true;
+}
+
+#else /* CONFIG_PARAVIRT_UNFAIR_LOCKS */
+
+static void unfair_init_vars(struct qnode *node)	{}
+static void unfair_set_vars(struct qnode *node, struct qnode *prev,
+		u32 prev_tail)				{}
+static int unfair_get_lock(struct qspinlock *lock, struct qnode *node,
+		u32 tail, int count)			{ return false; }
+static int unfair_check_and_clear_tail(struct qspinlock *lock, u32 tail)
+							{ return false; }
+#endif /* CONFIG_PARAVIRT_UNFAIR_LOCKS */
+
+/**
+ * get_qlock - Set the lock bit and own the lock
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock acquired, 0 otherwise
+ *
+ * This routine should only be called when the caller is the only one
+ * entitled to acquire the lock.
+ */
+static __always_inline int get_qlock(struct qspinlock *lock)
+{
+	struct __qspinlock *l = (void *)lock;
+
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+	if (static_key_false(&paravirt_unfairlocks_enabled))
+		/*
+		 * Need to use atomic operation to get the lock when
+		 * lock stealing can happen.
+		 */
+		return cmpxchg(&l->locked, 0, _Q_LOCKED_VAL) == 0;
+#endif
+	barrier();
+	ACCESS_ONCE(l->locked) = _Q_LOCKED_VAL;
+	barrier();
+	return 1;
+}
+
+/**
+ * trylock_pending - try to acquire queue spinlock using the pending bit
+ * @lock : Pointer to queue spinlock structure
+ * @pval : Pointer to value of the queue spinlock 32-bit word
+ * Return: 1 if lock acquired, 0 otherwise
+ *
+ * The pending bit won't be set as soon as one or more tasks queue up.
+ * This function should only be called when lock stealing will not happen.
+ * Otherwise, it has to be disabled.
+ */
+static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
+{
+	u32 old, new, val = *pval;
+	int retry = 1;
+
+	/*
+	 * trylock || pending
+	 *
+	 * 0,0,0 -> 0,0,1 ; trylock
+	 * 0,0,1 -> 0,1,1 ; pending
+	 */
+	for (;;) {
+		/*
+		 * If we observe that the queue is not empty,
+		 * return and be queued.
+		 */
+		if (val & _Q_TAIL_MASK)
+			return 0;
+
+		if ((val & _Q_LOCKED_PENDING_MASK) ==
+		    (_Q_LOCKED_VAL|_Q_PENDING_VAL)) {
+			/*
+			 * If both the lock and pending bits are set, we wait
+			 * a while to see if that either bit will be cleared.
+			 * If that is no change, we return and be queued.
+			 */
+			if (!retry)
+				return 0;
+			retry--;
+			cpu_relax();
+			cpu_relax();
+			*pval = val = atomic_read(&lock->val);
+			continue;
+		} else if ((val & _Q_LOCKED_PENDING_MASK) == _Q_PENDING_VAL) {
+			/*
+			 * Pending bit is set, but not the lock bit.
+			 * Assuming that the pending bit holder is going to
+			 * set the lock bit and clear the pending bit soon,
+			 * it is better to wait than to exit at this point.
+			 */
+			cpu_relax();
+			*pval = val = atomic_read(&lock->val);
+			continue;
+		}
+
+		new = _Q_LOCKED_VAL;
+		if (val == new)
+			new |= _Q_PENDING_VAL;
+
+		old = atomic_cmpxchg(&lock->val, val, new);
+		if (old == val)
+			break;
+
+		*pval = val = old;
+	}
+
+	/*
+	 * we won the trylock
+	 */
+	if (new == _Q_LOCKED_VAL)
+		return 1;
+
+	/*
+	 * we're pending, wait for the owner to go away.
+	 *
+	 * *,1,1 -> *,1,0
+	 *
+	 * this wait loop must be a load-acquire such that we match the
+	 * store-release that clears the locked bit and create lock
+	 * sequentiality; this because not all try_clear_pending_set_locked()
+	 * implementations imply full barriers.
+	 *
+	 * When PV qspinlock is enabled, exit the pending bit code path and
+	 * go back to the regular queuing path if the lock isn't available
+	 * within a certain threshold.
+	 */
+	if (pv_qspinlock_enabled())
+		retry = PSPIN_THRESHOLD;
+	while ((val = smp_load_acquire(&lock->val.counter)) & _Q_LOCKED_MASK) {
+		if (pv_qspinlock_enabled() && (--retry == 0)) {
+			/*
+			 * Clear the pending bit and exit
+			 */
+			for (;;) {
+				new = val & ~_Q_PENDING_MASK;
+				old = atomic_cmpxchg(&lock->val, val, new);
+				if (old == val)
+					return 0;
+				val = old;
+			}
+		}
+		arch_mutex_cpu_relax();
+	}
+
+	/*
+	 * take ownership and clear the pending bit.
+	 *
+	 * *,1,0 -> *,0,1
+	 */
+	clear_pending_set_locked(lock, val);
+	return 1;
+}
+
+/**
+ * queue_spin_lock_slowerpath - a slower path for acquiring queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ * @node: Pointer to the queue node
+ * @tail: The tail code
+ *
+ * The reason for splitting a slowerpath from slowpath is to avoid the
+ * unnecessary overhead of non-scratch pad register pushing and popping
+ * due to increased complexity with unfair and PV spinlock from slowing
+ * down the nominally faster pending bit and trylock code path. So this
+ * function is not inlined.
+ */
+static noinline void
+queue_spin_lock_slowerpath(struct qspinlock *lock, struct qnode *node, u32 tail)
+{
+	struct qnode *prev, *next;
+	u32 old, val;
+	DEF_LOOP_CNT(hcnt);
+
+	/*
+	 * we already touched the queueing cacheline; don't bother with pending
+	 * stuff.
+	 *
+	 * p,*,* -> n,*,*
+	 */
+	old = xchg_tail(lock, tail, &val);
+
+	/*
+	 * if there was a previous node; link it and wait.
+	 */
+	if (old & _Q_TAIL_MASK) {
+		DEF_LOOP_CNT(cnt);
+
+		prev = decode_tail(old);
+		unfair_set_vars(node, prev, old);
+		pv_set_prev(&node->pv, prev);
+		ACCESS_ONCE(prev->mcs.next) = (struct mcs_spinlock *)node;
+
+		while (!smp_load_acquire(&node->qhead)) {
+			INC_LOOP_CNT(cnt);
+			if (unfair_get_lock(lock, node, tail, LOOP_CNT(cnt))) {
+				/*
+				 * Need to notify the next node only if both
+				 * the qhead flag and the next pointer in the
+				 * queue node are set.
+				 */
+				if (unlikely(node->qhead && node->mcs.next))
+					goto notify_next;
+				return;
+			}
+			pv_queue_spin_check(&node->pv, &node->mcs,
+					    LOOP_CNT(&cnt));
+			arch_mutex_cpu_relax();
+		}
+	} else {
+		ACCESS_ONCE(node->qhead) = true;
+	}
+
+	/*
+	 * we're at the head of the waitqueue, wait for the owner & pending to
+	 * go away.
+	 * Load-acquired is used here because the get_qlock()
+	 * function below may not be a full memory barrier.
+	 *
+	 * *,x,y -> *,0,0
+	 */
+retry_queue_wait:
+	while ((val = smp_load_acquire(&lock->val.counter))
+				       & _Q_LOCKED_PENDING_MASK) {
+		INC_LOOP_CNT(hcnt);
+		/*
+		 * Perform queue head para-virtualization checks
+		 */
+		pv_head_spin_check(&node->pv, LOOP_CNT(&hcnt), old, lock);
+		arch_mutex_cpu_relax();
+	}
+
+	/*
+	 * claim the lock:
+	 *
+	 * n,0,0 -> 0,0,1 : lock, uncontended
+	 * *,0,0 -> *,0,1 : lock, contended
+	 *
+	 * If the queue head is the only one in the queue (lock value == tail),
+	 * clear the tail code and grab the lock. Otherwise, we only need
+	 * to grab the lock.
+	 */
+	for (;;) {
+		LOOP_CNT(hcnt = 0);	/* Reset loop count */
+		if (val != tail) {
+			/*
+			 * The get_qlock function will only failed if the
+			 * lock was stolen.
+			 */
+			if (get_qlock(lock)) {
+				/*
+				 * It is possible that in between the reading
+				 * of the lock value and the acquisition of
+				 * the lock, the next node may have stolen the
+				 * lock and be removed from the queue. So
+				 * the lock value may contain the tail code
+				 * of the current node. We need to recheck
+				 * the tail value here to be sure. And if
+				 * the tail code was cleared, we don't need
+				 * to notify the next node.
+				 */
+				if (unlikely(unfair_check_and_clear_tail(lock,
+						tail)))
+					return;
+				break;
+			} else {
+				goto retry_queue_wait;
+			}
+		}
+		old = atomic_cmpxchg(&lock->val, val, _Q_LOCKED_VAL);
+		if (old == val)
+			return;	/* No contention */
+		else if (old & _Q_LOCKED_MASK)
+			goto retry_queue_wait;
+
+		val = old;
+	}
+
+	/*
+	 * contended path; wait for next, return.
+	 */
+notify_next:
+	while (!(next = (struct qnode *)ACCESS_ONCE(node->mcs.next)))
+		arch_mutex_cpu_relax();
+
+	/*
+	 * The next one in queue is now at the head
+	 */
+	arch_mcs_spin_unlock_contended(&next->qhead);
+	pv_halt_check(&next->pv, lock);
+}
+
+/**
+ * queue_spin_lock_slowpath - acquire the queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ * @val: Current value of the queue spinlock 32-bit word
+ *
+ * (queue tail, pending bit, lock bit)
+ *
+ *              fast     :    slow                                  :    unlock
+ *                       :                                          :
+ * uncontended  (0,0,0) -:--> (0,0,1) ------------------------------:--> (*,*,0)
+ *                       :       | ^--------.------.             /  :
+ *                       :       v           \      \            |  :
+ * pending               :    (0,1,1) +--> (0,1,0)   \           |  :
+ *                       :       | ^--'              |           |  :
+ *                       :       v                   |           |  :
+ * uncontended           :    (n,x,y) +--> (n,0,0) --'           |  :
+ *   queue               :       | ^--'                          |  :
+ *                       :       v                               |  :
+ * contended             :    (*,x,y) +--> (*,0,0) ---> (*,0,1) -'  :
+ *   queue               :         ^--'                             :
+ *
+ * This slowpath only contains the faster pending bit and trylock codes.
+ * The slower queuing code is in the slowerpath function.
+ */
+void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
+{
+	struct qnode *node;
+	u32 tail, idx, cpu_nr;
+
+	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
+
+	if (trylock_pending(lock, &val))
+		return;	/* Lock acquired */
+
+	node = this_cpu_ptr(&qnodes[0]);
+	idx = node->mcs.count++;
+	tail = encode_tail(cpu_nr = smp_processor_id(), idx);
+
+	node += idx;
+	node->qhead = 0;
+	node->mcs.next = NULL;
+	unfair_init_vars(node);
+	pv_init_vars(&node->pv, cpu_nr);
+
+	/*
+	 * We touched a (possibly) cold cacheline; attempt the trylock once
+	 * more in the hope someone let go while we weren't watching as long
+	 * as no one was queuing.
+	 */
+	if ((val & _Q_TAIL_MASK) || !queue_spin_trylock(lock))
+		queue_spin_lock_slowerpath(lock, node, tail);
+
+	/*
+	 * release the node
+	 */
+	this_cpu_dec(qnodes[0].mcs.count);
+}
+EXPORT_SYMBOL(queue_spin_lock_slowpath);
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

--------------070403060406010903060403--
