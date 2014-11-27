Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaK0Ak1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 19:40:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:57481 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbaK0AkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 19:40:25 -0500
Message-ID: <1417048678.5089.71.camel@kernel.crashing.org>
Subject: Re: [PATCH v2 3/4] powernv: cpuidle: Redesign idle states management
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 27 Nov 2014 11:37:58 +1100
In-Reply-To: <1416914279-30384-4-git-send-email-shreyas@linux.vnet.ibm.com>
References: <1416914279-30384-1-git-send-email-shreyas@linux.vnet.ibm.com>
	 <1416914279-30384-4-git-send-email-shreyas@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
> @@ -123,12 +123,62 @@ power7_enter_nap_mode:
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
> +	li	r7,1
> +	mfspr	r8,SPRN_PIR
> +	/*
> +	 * The last 3 bits of PIR represents the thread id of a cpu
> +	 * in power8. This will need adjusting for power7.
> +	 */
> +	andi.	r8,r8,0x07			/* Get thread id into r8 */
> +	rotld	r7,r7,r8
> +
> +	ld	r14,PACA_CORE_IDLE_STATE_PTR(r13)

I assume we have already saved all non-volatile registers ? Because you
are clobbering one here and more below.

> +lwarx_loop1:
> +	lwarx	r15,0,r14
> +	andc	r15,r15,r7			/* Clear thread bit */
> +
> +	andi.	r15,r15,PNV_CORE_IDLE_THREAD_BITS
> +	beq	last_thread
> +
> +	/* Not the last thread to goto sleep */
> +	stwcx.	r15,0,r14
> +	bne-	lwarx_loop1
> +	b	common_enter
> +
> +last_thread:
> +	LOAD_REG_ADDR(r3, pnv_need_fastsleep_workaround)
> +	lbz	r3,0(r3)
> +	cmpwi	r3,1
> +	bne	common_enter

This looks wrong. If the workaround is 0, we don't do the stwcx. at
all... Did you try with pnv_need_fastsleep_workaround set to 0 ? It
should work most of the time as long as you don't hit the fairly
rare race window :)

Also it would be nice to make the above a dynamically patches feature
section, though that means pnv_need_fastsleep_workaround needs to turn
into a CPU feature bit and that needs to be done *very* early on.

Another option is to patch out manually from the pnv code the pair:

	andi.	r15,r15,PNV_CORE_IDLE_THREAD_BITS
 	beq	last_thread

To turn them into nops by hand rather than using the feature system.

> +	/*
> +	 * Last thread of the core entering sleep. Last thread needs to execute
> +	 * the hardware bug workaround code. Before that, set the lock bit to
> +	 * avoid the race of other threads waking up and undoing workaround
> +	 * before workaround is applied.
> +	 */
> +	ori	r15,r15,PNV_CORE_IDLE_LOCK_BIT
> +	stwcx.	r15,0,r14
> +	bne-	lwarx_loop1
> +
> +	/* Fast sleep workaround */
> +	li	r3,1
> +	li	r4,1
> +	li	r0,OPAL_CONFIG_CPU_IDLE_STATE
> +	bl	opal_call_realmode
> +
> +	/* Clear Lock bit */

It's a lock, I would add a lwsync here to be safe, and I would add an
isync before the bne- above. Just to ensure that whatever is done
inside that locked section remains in there.

> +	andi.	r15,r15,PNV_CORE_IDLE_THREAD_BITS
> +	stw	r15,0(r14)
> +
> +common_enter: /* common code for all the threads entering sleep */
> +	IDLE_STATE_ENTER_SEQ(PPC_SLEEP)
>  
>  _GLOBAL(power7_idle)
>  	/* Now check if user or arch enabled NAP mode */
> @@ -141,49 +191,16 @@ _GLOBAL(power7_idle)
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
> @@ -196,10 +213,8 @@ ALT_FTR_SECTION_END_NESTED_IFSET(CPU_FTR_ARCH_207S, 66);		\
>  	/* Invoke opal call to handle hmi */				\
>  	ld	r2,PACATOC(r13);					\
>  	ld	r1,PACAR1(r13);						\
> -	std	r3,ORIG_GPR3(r1);	/* Save original r3 */		\
> -	li	r3,OPAL_HANDLE_HMI;	/* Pass opal token argument*/	\
> +	li	r0,OPAL_HANDLE_HMI;	/* Pass opal token argument*/	\
>  	bl	opal_call_realmode;					\
> -	ld	r3,ORIG_GPR3(r1);	/* Restore original r3 */	\
>  20:	nop;
>  
> 
> @@ -210,12 +225,91 @@ _GLOBAL(power7_wakeup_tb_loss)
>  BEGIN_FTR_SECTION
>  	CHECK_HMI_INTERRUPT
>  END_FTR_SECTION_IFSET(CPU_FTR_HVMODE)
> +
> +	li	r7,1
> +	mfspr	r8,SPRN_PIR
> +	/*
> +	 * The last 3 bits of PIR represents the thread id of a cpu
> +	 * in power8. This will need adjusting for power7.
> +	 */
> +	andi.	r8,r8,0x07		/* Get thread id into r8 */

I'd be more comfortable if we patched that instruction at boot with the
right mask.

> +	rotld	r7,r7,r8
> +	/* r7 now has 'thread_id'th bit set */
> +
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
> +	bne	lwarx_loop2

We should do some smt priority games here otherwise the spinning threads
are going to slow down the one with the lock. Basically, if we see the
lock held, go out of line, smt_low, spin on a normal load, and when
smt_medium and go back to lwarx

> +	cmpwi	cr2,r15,0
> +	or	r15,r15,r7		/* Set thread bit */
> +
> +	beq	cr2,first_thread
> +
> +	/* Not first thread in core to wake up */
> +	stwcx.	r15,0,r14
> +	bne-	lwarx_loop2
> +	b	common_exit
> +
> +first_thread:
> +	/* First thread in core to wakeup */
> +	ori	r15,r15,PNV_CORE_IDLE_LOCK_BIT
> +	stwcx.	r15,0,r14
> +	bne-	lwarx_loop2
> +
> +	LOAD_REG_ADDR(r3, pnv_need_fastsleep_workaround)
> +	lbz	r3,0(r3)
> +	cmpwi	r3,1

Same comment about dynamic patching.

> +	/*  skip fastsleep workaround if its not needed */
> +	bne	timebase_resync
> +
> +	/* Undo fast sleep workaround */
> +	mfcr	r16	/* Backup CR into a non-volatile register */

Why ? If you have your non-volatiles saved you can use an NV CR like CR2
no ? You need to restore those anyway...

Also same comments as on the way down vs barriers when doing
lock/unlock.

> +	li	r3,1
> +	li	r4,0
> +	li	r0,OPAL_CONFIG_CPU_IDLE_STATE
> +	bl	opal_call_realmode
> +	mtcr	r16	/* Restore CR */
> +
> +	/* Do timebase resync if we are waking up from sleep. Use cr1 value
> +	 * set in exceptions-64s.S */
> +	ble	cr1,clear_lock
> +
> +timebase_resync:
>  	/* Time base re-sync */
> -	li	r3,OPAL_RESYNC_TIMEBASE
> +	li	r0,OPAL_RESYNC_TIMEBASE
>  	bl	opal_call_realmode;
> -
>  	/* TODO: Check r3 for failure */
>  
> +clear_lock:
> +	andi.	r15,r15,PNV_CORE_IDLE_THREAD_BITS
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
> +6:
> +#endif
> +
>  	REST_NVGPRS(r1)
>  	REST_GPR(2, r1)
>  	ld	r3,_CCR(r1)
> diff --git a/arch/powerpc/platforms/powernv/opal-wrappers.S b/arch/powerpc/platforms/powernv/opal-wrappers.S
> index feb549a..b2aa93b 100644
> --- a/arch/powerpc/platforms/powernv/opal-wrappers.S
> +++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
> @@ -158,6 +158,43 @@ opal_tracepoint_return:
>  	blr
>  #endif
>  
> +/*
> + * Make opal call in realmode. This is a generic function to be called
> + * from realmode. It handles endianness.
> + *
> + * r13 - paca pointer
> + * r1  - stack pointer
> + * r0  - opal token
> + */
> +_GLOBAL(opal_call_realmode)
> +	mflr	r12
> +	std	r12,_LINK(r1)
> +	ld	r2,PACATOC(r13)
> +	/* Set opal return address */
> +	LOAD_REG_ADDR(r12,return_from_opal_call)
> +	mtlr	r12
> +
> +	mfmsr	r12
> +#ifdef __LITTLE_ENDIAN__
> +	/* Handle endian-ness */
> +	li	r11,MSR_LE
> +	andc	r12,r12,r11
> +#endif
> +	mtspr	SPRN_HSRR1,r12
> +	LOAD_REG_ADDR(r11,opal)
> +	ld	r12,8(r11)
> +	ld	r2,0(r11)
> +	mtspr	SPRN_HSRR0,r12
> +	hrfid
> +
> +return_from_opal_call:
> +#ifdef __LITTLE_ENDIAN__
> +	FIXUP_ENDIAN
> +#endif
> +	ld	r12,_LINK(r1)
> +	mtlr	r12
> +	blr
> +
>  OPAL_CALL(opal_invalid_call,			OPAL_INVALID_CALL);
>  OPAL_CALL(opal_console_write,			OPAL_CONSOLE_WRITE);
>  OPAL_CALL(opal_console_read,			OPAL_CONSOLE_READ);
> diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
> index 34c6665..17fb98c 100644
> --- a/arch/powerpc/platforms/powernv/setup.c
> +++ b/arch/powerpc/platforms/powernv/setup.c
> @@ -36,6 +36,8 @@
>  #include <asm/opal.h>
>  #include <asm/kexec.h>
>  #include <asm/smp.h>
> +#include <asm/cputhreads.h>
> +#include <asm/cpuidle.h>
>  
>  #include "powernv.h"
>  
> @@ -292,11 +294,45 @@ static void __init pnv_setup_machdep_rtas(void)
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
> +	 * b. While the last thread in the core is saving the core state, it
> +	 * prevent a different thread from waking up.
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
> +
> +		}
> +	}
> +}
> +
>  u32 pnv_get_supported_cpuidle_states(void)
>  {
>  	return supported_cpuidle_states;
>  }
> +EXPORT_SYMBOL_GPL(pnv_get_supported_cpuidle_states);
>  
> +u8 pnv_need_fastsleep_workaround;
>  static int __init pnv_init_idle_states(void)
>  {
>  	struct device_node *power_mgt;
> @@ -306,6 +342,7 @@ static int __init pnv_init_idle_states(void)
>  	int i;
>  
>  	supported_cpuidle_states = 0;
> +	pnv_need_fastsleep_workaround = 0;
>  
>  	if (cpuidle_disable != IDLE_NO_OVERRIDE)
>  		return 0;
> @@ -332,13 +369,14 @@ static int __init pnv_init_idle_states(void)
>  		flags = be32_to_cpu(idle_state_flags[i]);
>  		supported_cpuidle_states |= flags;
>  	}
> -
> +	if (supported_cpuidle_states & OPAL_PM_SLEEP_ENABLED_ER1)
> +		pnv_need_fastsleep_workaround = 1;
> +	pnv_alloc_idle_core_states();
>  	return 0;
>  }
>  
>  subsys_initcall(pnv_init_idle_states);
>  
> -
>  static int __init pnv_probe(void)
>  {
>  	unsigned long root = of_get_flat_dt_root();
> diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
> index 3dc4cec..12b761a 100644
> --- a/arch/powerpc/platforms/powernv/smp.c
> +++ b/arch/powerpc/platforms/powernv/smp.c
> @@ -167,7 +167,8 @@ static void pnv_smp_cpu_kill_self(void)
>  	mtspr(SPRN_LPCR, mfspr(SPRN_LPCR) & ~(u64)LPCR_PECE1);
>  	while (!generic_check_cpu_restart(cpu)) {
>  		ppc64_runlatch_off();
> -		if (idle_states & OPAL_PM_SLEEP_ENABLED)
> +		if ((idle_states & OPAL_PM_SLEEP_ENABLED) ||
> +				(idle_states & OPAL_PM_SLEEP_ENABLED_ER1))
>  			power7_sleep();
>  		else
>  			power7_nap(1);
> diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
> index 0a7d827..a489b56 100644
> --- a/drivers/cpuidle/cpuidle-powernv.c
> +++ b/drivers/cpuidle/cpuidle-powernv.c
> @@ -208,7 +208,8 @@ static int powernv_add_idle_states(void)
>  			nr_idle_states++;
>  		}
>  
> -		if (flags & OPAL_PM_SLEEP_ENABLED) {
> +		if (flags & OPAL_PM_SLEEP_ENABLED ||
> +			flags & OPAL_PM_SLEEP_ENABLED_ER1) {
>  			/* Add FASTSLEEP state */
>  			strcpy(powernv_states[nr_idle_states].name, "FastSleep");
>  			strcpy(powernv_states[nr_idle_states].desc, "FastSleep");


