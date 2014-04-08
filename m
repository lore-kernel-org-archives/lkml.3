Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbaDHTQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:16:10 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:7302 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463AbaDHTQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:16:07 -0400
Message-ID: <53444AEE.9050705@hp.com>
Date: Tue, 08 Apr 2014 15:15:58 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v8 00/10] qspinlock: a 4-byte queue spinlock with PV support
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com> <5342425A.7040005@linux.vnet.ibm.com> <5342D475.7060503@hp.com> <5342E5B2.1070306@linux.vnet.ibm.com>
In-Reply-To: <5342E5B2.1070306@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------040207070205080604010401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040207070205080604010401
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/07/2014 01:51 PM, Raghavendra K T wrote:
> On 04/07/2014 10:08 PM, Waiman Long wrote:
>> On 04/07/2014 02:14 AM, Raghavendra K T wrote:
> [...]
>>> But I am seeing hang in overcommit cases. Gdb showed that many vcpus
>>> are halted and there was no progress. Suspecting the problem /race with
>>> halting, I removed the halt() part of kvm_hibernate().  I am yet to
>>> take a closer look at the code on halt() related changes.
>>
>> It seems like there may still be race conditions where the current code
>> is not handling correctly. I will look into that to see where the
>> problem is. BTW, what test do you use to produce the hang condition?
>
> Running ebizzy on 2 of the vms simultaneously (for sometime in 
> repeated loop) could reproduce it.
>

Yes, I am able to reproduce the hang problem with ebizzy. BTW, could you 
try to apply the attached patch file on top of the v8 patch series to 
see if it can fix the hang problem?

>
>> What is the baseline for the performance improvement? Is it without the
>> unfair lock and PV qspinlock?
>
> Baseline was 3.14-rc8 without any of the qspin patch series.
>

Does the baseline have PV ticketlock or without any PV support?

-Longman

--------------040207070205080604010401
Content-Type: text/plain;
 name="0011"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0011"

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index a35cd02..825c535 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -717,9 +717,10 @@ static __always_inline void __queue_kick_cpu(int cpu)
 	PVOP_VCALL1(pv_lock_ops.kick_cpu, cpu);
 }
 
-static __always_inline void __queue_hibernate(enum pv_lock_stats type)
+static __always_inline void
+__queue_hibernate(enum pv_lock_stats type, s8 *state, s8 sval)
 {
-	PVOP_VCALL1(pv_lock_ops.hibernate, type);
+	PVOP_VCALL3(pv_lock_ops.hibernate, type, state, sval);
 }
 
 static __always_inline void __queue_lockstat(enum pv_lock_stats type)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index a8564b9..0e204dd 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -346,7 +346,7 @@ enum pv_lock_stats {
 struct pv_lock_ops {
 #ifdef CONFIG_QUEUE_SPINLOCK
 	void (*kick_cpu)(int cpu);
-	void (*hibernate)(enum pv_lock_stats type);
+	void (*hibernate)(enum pv_lock_stats type, s8 *state, s8 sval);
 	void (*lockstat)(enum pv_lock_stats type);
 #else
 	struct paravirt_callee_save lock_spinning;
diff --git a/arch/x86/include/asm/pvqspinlock.h b/arch/x86/include/asm/pvqspinlock.h
index a632dcb..4b33769 100644
--- a/arch/x86/include/asm/pvqspinlock.h
+++ b/arch/x86/include/asm/pvqspinlock.h
@@ -134,7 +134,7 @@ static __always_inline void pv_head_spin_check(struct pv_qvars *pv, int *count,
 			*count = 0;
 			return;
 		}
-		__queue_hibernate(PV_HALT_QHEAD);
+		__queue_hibernate(PV_HALT_QHEAD, &pv->cpustate, PV_CPU_HALTED);
 		__queue_lockstat((pv->cpustate == PV_CPU_KICKED)
 				 ? PV_WAKE_KICKED : PV_WAKE_SPURIOUS);
 		ACCESS_ONCE(pv->cpustate) = PV_CPU_ACTIVE;
@@ -169,7 +169,7 @@ static __always_inline void pv_queue_spin_check(struct pv_qvars *pv, int *count)
 		 * pv_next_node_check		pv_queue_spin_check
 		 * ------------------		-------------------
 		 * [1] qhead = true		[3] cpustate = PV_CPU_HALTED
-		 *     barrier()		    barrier()
+		 *     smp_mb()			    smp_mb()
 		 * [2] if (cpustate		[4] if (qhead)
 		 *        == PV_CPU_HALTED)
 		 *
@@ -178,9 +178,10 @@ static __always_inline void pv_queue_spin_check(struct pv_qvars *pv, int *count)
 		 *	       _QLOCK_LOCKED_SLOWPATH may or may not be set
 		 * 3,4,1,2 - the CPU is halt and _QLOCK_LOCKED_SLOWPATH is set
 		 */
-		barrier();
+		smp_mb();
 		if (!ACCESS_ONCE(pv->qhead)) {
-			__queue_hibernate(PV_HALT_QNODE);
+			__queue_hibernate(PV_HALT_QNODE, &pv->cpustate,
+					  PV_CPU_HALTED);
 			__queue_lockstat((pv->cpustate == PV_CPU_KICKED)
 					 ? PV_WAKE_KICKED : PV_WAKE_SPURIOUS);
 		} else {
@@ -208,7 +209,7 @@ pv_next_node_check(struct pv_qvars *pv, struct qspinlock *lock)
 	/*
 	 * Make sure qhead flag is visible before checking the cpustate flag
 	 */
-	barrier();
+	smp_mb();
 	if (ACCESS_ONCE(pv->cpustate) == PV_CPU_HALTED)
 		ACCESS_ONCE(((union arch_qspinlock *)lock)->lock)
 			= _QLOCK_LOCKED_SLOWPATH;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 7d97e58..ce4b74b 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -880,23 +880,29 @@ static void kvm_kick_cpu_stats(int cpu)
 /*
  * Halt the current CPU & release it back to the host
  */
-static void kvm_hibernate(enum pv_lock_stats type)
+static void kvm_hibernate(enum pv_lock_stats type, s8 *state, s8 sval)
 {
 	unsigned long flags;
 
 	if (in_nmi())
 		return;
 
-	kvm_halt_stats(type);
 	/*
 	 * Make sure an interrupt handler can't upset things in a
 	 * partially setup state.
 	 */
 	local_irq_save(flags);
+	/*
+	 * Don't halt if the CPU state has been changed.
+	 */
+	if (ACCESS_ONCE(*state) != sval)
+		goto out;
+	kvm_halt_stats(type);
 	if (arch_irqs_disabled_flags(flags))
 		halt();
 	else
 		safe_halt();
+out:
 	local_irq_restore(flags);
 }
 #endif /* !CONFIG_QUEUE_SPINLOCK */
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 6bbe798..c597bbd 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -271,7 +271,7 @@ static void xen_kick_cpu(int cpu)
 /*
  * Halt the current CPU & release it back to the host
  */
-static void xen_hibernate(enum pv_lock_stats type)
+static void xen_hibernate(enum pv_lock_stats type, s8 *state, s8 sval)
 {
 	int irq = __this_cpu_read(lock_kicker_irq);
 	unsigned long flags;
@@ -292,7 +292,11 @@ static void xen_hibernate(enum pv_lock_stats type)
 
 	/* Allow interrupts while blocked */
 	local_irq_restore(flags);
-
+	/*
+	 * Don't halt if the CPU state has been changed.
+	 */
+	if (ACCESS_ONCE(*state) != sval)
+		return;
 	/*
 	 * If an interrupt happens here, it will leave the wakeup irq
 	 * pending, which will cause xen_poll_irq() to return

--------------040207070205080604010401--
