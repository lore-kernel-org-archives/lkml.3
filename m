Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaLHFBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 00:01:38 -0500
Received: from ozlabs.org ([103.22.144.67]:35954 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbaLHFBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 00:01:35 -0500
Date: Mon, 8 Dec 2014 16:01:26 +1100
From: Paul Mackerras <paulus@samba.org>
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 3/4] powernv: cpuidle: Redesign idle states management
Message-ID: <20141208050126.GB4437@drongo>
References: <1417678103-32571-1-git-send-email-shreyas@linux.vnet.ibm.com>
 <1417678103-32571-4-git-send-email-shreyas@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417678103-32571-4-git-send-email-shreyas@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 12:58:22PM +0530, Shreyas B. Prabhu wrote:
> Deep idle states like sleep and winkle are per core idle states. A core
> enters these states only when all the threads enter either the
> particular idle state or a deeper one. There are tasks like fastsleep
> hardware bug workaround and hypervisor core state save which have to be
> done only by the last thread of the core entering deep idle state and
> similarly tasks like timebase resync, hypervisor core register restore
> that have to be done only by the first thread waking up from these
> state.
> 
> The current idle state management does not have a way to distinguish the
> first/last thread of the core waking/entering idle states. Tasks like
> timebase resync are done for all the threads. This is not only is
> suboptimal, but can cause functionality issues when subcores and kvm is
> involved.
> 
> This patch adds the necessary infrastructure to track idle states of
> threads in a per-core structure. It uses this info to perform tasks like
> fastsleep workaround and timebase resync only once per core.

Comments below...

> diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
> index a5139ea..e4578c3 100644
> --- a/arch/powerpc/include/asm/paca.h
> +++ b/arch/powerpc/include/asm/paca.h
> @@ -158,6 +158,12 @@ struct paca_struct {
>  	 * early exception handler for use by high level C handler
>  	 */
>  	struct opal_machine_check_event *opal_mc_evt;
> +
> +	/* Per-core mask tracking idle threads and a lock bit-[L][TTTTTTTT] */
> +	u32 *core_idle_state_ptr;
> +	u8 thread_idle_state;		/* ~Idle[0]/Nap[1]/Sleep[2]/Winkle[3] */

Might be clearer in the comment to say "/* PNV_THREAD_xxx */" so it's
clear the value should be one of PNV_THREAD_NAP, PNV_THREAD_SLEEP,
etc.

> diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
> index 283c603..8c3a1f4 100644
> --- a/arch/powerpc/kernel/idle_power7.S
> +++ b/arch/powerpc/kernel/idle_power7.S
> @@ -18,6 +18,7 @@
>  #include <asm/hw_irq.h>
>  #include <asm/kvm_book3s_asm.h>
>  #include <asm/opal.h>
> +#include <asm/cpuidle.h>
>  
>  #undef DEBUG
>  
> @@ -37,8 +38,7 @@
>  
>  /*
>   * Pass requested state in r3:
> - * 	0 - nap
> - * 	1 - sleep
> + *	r3 - PNV_THREAD_NAP/SLEEP/WINKLE
>   *
>   * To check IRQ_HAPPENED in r4
>   * 	0 - don't check
> @@ -123,12 +123,58 @@ power7_enter_nap_mode:
>  	li	r4,KVM_HWTHREAD_IN_NAP
>  	stb	r4,HSTATE_HWTHREAD_STATE(r13)
>  #endif
> -	cmpwi	cr0,r3,1
> -	beq	2f
> +	stb	r3,PACA_THREAD_IDLE_STATE(r13)
> +	cmpwi	cr1,r3,PNV_THREAD_SLEEP
> +	bge	cr1,2f
>  	IDLE_STATE_ENTER_SEQ(PPC_NAP)
>  	/* No return */
> -2:	IDLE_STATE_ENTER_SEQ(PPC_SLEEP)
> -	/* No return */
> +2:
> +	/* Sleep or winkle */
> +	lbz	r7,PACA_THREAD_MASK(r13)
> +	ld	r14,PACA_CORE_IDLE_STATE_PTR(r13)
> +lwarx_loop1:
> +	lwarx	r15,0,r14
> +	andc	r15,r15,r7			/* Clear thread bit */
> +
> +	andi.	r15,r15,PNV_CORE_IDLE_THREAD_BITS
> +
> +/*
> + * If cr0 = 0, then current thread is the last thread of the core entering
> + * sleep. Last thread needs to execute the hardware bug workaround code if
> + * required by the platform.
> + * Make the workaround call unconditionally here. The below branch call is
> + * patched out when the idle states are discovered if the platform does not
> + * require it.
> + */
> +.global pnv_fastsleep_workaround_at_entry
> +pnv_fastsleep_workaround_at_entry:
> +	beq	fastsleep_workaround_at_entry

Did you investigate using the feature bit mechanism to do this
patching for you?  You would need to allocate a CPU feature bit and
parse the device tree early on and set or clear the feature bit,
before the feature fixups are done.  The code here would then end up
looking like:

BEGIN_FTR_SECTION
	beq	fastsleep_workaround_at_entry
END_FTR_SECTION_IFSET(CPU_FTR_FASTSLEEP_WORKAROUND)

> +	stwcx.	r15,0,r14
> +	isync
> +	bne-	lwarx_loop1

The isync has to come after the bne.  Please fix this here and in the
other places where you added the isync.

> +common_enter: /* common code for all the threads entering sleep */
> +	IDLE_STATE_ENTER_SEQ(PPC_SLEEP)
> +
> +fastsleep_workaround_at_entry:
> +	ori	r15,r15,PNV_CORE_IDLE_LOCK_BIT
> +	stwcx.	r15,0,r14
> +	isync
> +	bne-	lwarx_loop1
> +
> +	/* Fast sleep workaround */
> +	li	r3,1
> +	li	r4,1
> +	li	r0,OPAL_CONFIG_CPU_IDLE_STATE
> +	bl	opal_call_realmode
> +
> +	/* Clear Lock bit */
> +	li	r0,0
> +	lwsync
> +	stw	r0,0(r14)
> +	b	common_enter
> +
>  
>  _GLOBAL(power7_idle)
>  	/* Now check if user or arch enabled NAP mode */
> @@ -141,49 +187,16 @@ _GLOBAL(power7_idle)
>  
>  _GLOBAL(power7_nap)
>  	mr	r4,r3
> -	li	r3,0
> +	li	r3,PNV_THREAD_NAP
>  	b	power7_powersave_common
>  	/* No return */
>  
>  _GLOBAL(power7_sleep)
> -	li	r3,1
> +	li	r3,PNV_THREAD_SLEEP
>  	li	r4,1
>  	b	power7_powersave_common
>  	/* No return */
>  
> -/*
> - * Make opal call in realmode. This is a generic function to be called
> - * from realmode from reset vector. It handles endianess.
> - *
> - * r13 - paca pointer
> - * r1  - stack pointer
> - * r3  - opal token
> - */
> -opal_call_realmode:
> -	mflr	r12
> -	std	r12,_LINK(r1)
> -	ld	r2,PACATOC(r13)
> -	/* Set opal return address */
> -	LOAD_REG_ADDR(r0,return_from_opal_call)
> -	mtlr	r0
> -	/* Handle endian-ness */
> -	li	r0,MSR_LE
> -	mfmsr	r12
> -	andc	r12,r12,r0
> -	mtspr	SPRN_HSRR1,r12
> -	mr	r0,r3			/* Move opal token to r0 */
> -	LOAD_REG_ADDR(r11,opal)
> -	ld	r12,8(r11)
> -	ld	r2,0(r11)
> -	mtspr	SPRN_HSRR0,r12
> -	hrfid
> -
> -return_from_opal_call:
> -	FIXUP_ENDIAN
> -	ld	r0,_LINK(r1)
> -	mtlr	r0
> -	blr
> -
>  #define CHECK_HMI_INTERRUPT						\
>  	mfspr	r0,SPRN_SRR1;						\
>  BEGIN_FTR_SECTION_NESTED(66);						\
> @@ -196,10 +209,8 @@ ALT_FTR_SECTION_END_NESTED_IFSET(CPU_FTR_ARCH_207S, 66);		\
>  	/* Invoke opal call to handle hmi */				\
>  	ld	r2,PACATOC(r13);					\
>  	ld	r1,PACAR1(r13);						\
> -	std	r3,ORIG_GPR3(r1);	/* Save original r3 */		\
> -	li	r3,OPAL_HANDLE_HMI;	/* Pass opal token argument*/	\
> +	li	r0,OPAL_HANDLE_HMI;	/* Pass opal token argument*/	\
>  	bl	opal_call_realmode;					\
> -	ld	r3,ORIG_GPR3(r1);	/* Restore original r3 */	\
>  20:	nop;

I recently sent a patch "powerpc: powernv: Return to cpu offline loop
when finished in KVM guest" which passes a value in r3 through
power7_wakeup_loss and power7_wakeup_noloss back to the caller of
power7_nap().  So please don't take out the save/restore of r3 here.

> @@ -210,12 +221,90 @@ _GLOBAL(power7_wakeup_tb_loss)
>  BEGIN_FTR_SECTION
>  	CHECK_HMI_INTERRUPT
>  END_FTR_SECTION_IFSET(CPU_FTR_HVMODE)
> +
> +	lbz	r7,PACA_THREAD_MASK(r13)
> +	ld	r14,PACA_CORE_IDLE_STATE_PTR(r13)
> +lwarx_loop2:
> +	lwarx	r15,0,r14
> +	andi.	r9,r15,PNV_CORE_IDLE_LOCK_BIT
> +	/*
> +	 * Lock bit is set in one of the 2 cases-
> +	 * a. In the sleep/winkle enter path, the last thread is executing
> +	 * fastsleep workaround code.
> +	 * b. In the wake up path, another thread is executing fastsleep
> +	 * workaround undo code or resyncing timebase or restoring context
> +	 * In either case loop until the lock bit is cleared.
> +	 */
> +	bne	core_idle_lock_held
> +
> +	cmpwi	cr2,r15,0
> +	or	r15,r15,r7		/* Set thread bit */
> +
> +	beq	cr2,first_thread
> +
> +	/* Not first thread in core to wake up */
> +	stwcx.	r15,0,r14
> +	isync
> +	bne-	lwarx_loop2
> +	b	common_exit
> +
> +core_idle_lock_held:
> +	HMT_LOW
> +core_idle_lock_loop:
> +	lwz	r15,0(14)
> +	andi.   r9,r15,PNV_CORE_IDLE_LOCK_BIT
> +	bne	core_idle_lock_loop
> +	HMT_MEDIUM
> +	b	lwarx_loop2
> +
> +first_thread:
> +	/* First thread in core to wakeup */
> +	ori	r15,r15,PNV_CORE_IDLE_LOCK_BIT
> +	stwcx.	r15,0,r14
> +	isync
> +	bne-	lwarx_loop2
> +
> +	/*
> +	 * First thread in the core waking up from fastsleep. It needs to
> +	 * call the fastsleep workaround code if the platform requires it.
> +	 * Call it unconditionally here. The below branch instruction will
> +	 * be patched out when the idle states are discovered if platform
> +	 * does not require workaround.
> +	 */
> +.global pnv_fastsleep_workaround_at_exit
> +pnv_fastsleep_workaround_at_exit:
> +	b	fastsleep_workaround_at_exit
> +
> +timebase_resync:
> +	/* Do timebase resync if we are waking up from sleep. Use cr3 value
> +	 * set in exceptions-64s.S */
> +	ble	cr3,clear_lock
>  	/* Time base re-sync */
> -	li	r3,OPAL_RESYNC_TIMEBASE
> +	li	r0,OPAL_RESYNC_TIMEBASE
>  	bl	opal_call_realmode;
> -
>  	/* TODO: Check r3 for failure */
>  
> +clear_lock:
> +	andi.	r15,r15,PNV_CORE_IDLE_THREAD_BITS
> +	lwsync
> +	stw	r15,0(r14)
> +
> +common_exit:
> +	li	r5,PNV_THREAD_RUNNING
> +	stb     r5,PACA_THREAD_IDLE_STATE(r13)
> +
> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
> +	li      r0,KVM_HWTHREAD_IN_KERNEL
> +	stb     r0,HSTATE_HWTHREAD_STATE(r13)
> +	/* Order setting hwthread_state vs. testing hwthread_req */
> +	sync
> +	lbz     r0,HSTATE_HWTHREAD_REQ(r13)
> +	cmpwi   r0,0
> +	beq     6f
> +	b       kvm_start_guest

There is a bit of a problem here: the FIXUP_ENDIAN in
opal_call_realmode will trash SRR1 (if the kernel is little-endian),
but the code at kvm_start_guest needs SRR1 from the system reset
exception so that it can know what the wakeup reason was.

> diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
> index 34c6665..97e0279 100644
> --- a/arch/powerpc/platforms/powernv/setup.c
> +++ b/arch/powerpc/platforms/powernv/setup.c
> @@ -36,6 +36,9 @@
>  #include <asm/opal.h>
>  #include <asm/kexec.h>
>  #include <asm/smp.h>
> +#include <asm/cputhreads.h>
> +#include <asm/cpuidle.h>
> +#include <asm/code-patching.h>
>  
>  #include "powernv.h"
>  
> @@ -292,10 +295,43 @@ static void __init pnv_setup_machdep_rtas(void)
>  
>  static u32 supported_cpuidle_states;
>  
> +static void pnv_alloc_idle_core_states(void)
> +{
> +	int i, j;
> +	int nr_cores = cpu_nr_cores();
> +	u32 *core_idle_state;
> +
> +	/*
> +	 * core_idle_state - First 8 bits track the idle state of each thread
> +	 * of the core. The 8th bit is the lock bit. Initially all thread bits
> +	 * are set. They are cleared when the thread enters deep idle state
> +	 * like sleep and winkle. Initially the lock bit is cleared.
> +	 * The lock bit has 2 purposes
> +	 * a. While the first thread is restoring core state, it prevents
> +	 * from other threads in the core from switching to prcoess context.

           ^^^^ remove "from"                               ^^^^^^^ process

> +	 * b. While the last thread in the core is saving the core state, it
> +	 * prevent a different thread from waking up.

           ^^^^^^^ prevents

> +	 */
> +	for (i = 0; i < nr_cores; i++) {
> +		int first_cpu = i * threads_per_core;
> +		int node = cpu_to_node(first_cpu);
> +
> +		core_idle_state = kmalloc_node(sizeof(u32), GFP_KERNEL, node);
> +		for (j = 0; j < threads_per_core; j++) {
> +			int cpu = first_cpu + j;
> +
> +			paca[cpu].core_idle_state_ptr = core_idle_state;
> +			paca[cpu].thread_idle_state = PNV_THREAD_RUNNING;
> +			paca[cpu].thread_mask = 1 << (cpu % threads_per_core);

This would be simpler and quicker:

			paca[cpu].thread_mask = 1 << j;

Paul.
