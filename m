Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaLHFw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 00:52:27 -0500
Received: from ozlabs.org ([103.22.144.67]:53009 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaLHFw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 00:52:26 -0500
Date: Mon, 8 Dec 2014 16:52:17 +1100
From: Paul Mackerras <paulus@samba.org>
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 4/4] powernv: powerpc: Add winkle support for offline
 cpus
Message-ID: <20141208055217.GC4437@drongo>
References: <1417678103-32571-1-git-send-email-shreyas@linux.vnet.ibm.com>
 <1417678103-32571-5-git-send-email-shreyas@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417678103-32571-5-git-send-email-shreyas@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 12:58:23PM +0530, Shreyas B. Prabhu wrote:
> Winkle is a deep idle state supported in power8 chips. A core enters
> winkle when all the threads of the core enter winkle. In this state
> power supply to the entire chiplet i.e core, private L2 and private L3
> is turned off. As a result it gives higher powersavings compared to
> sleep.
> 
> But entering winkle results in a total hypervisor state loss. Hence the
> hypervisor context has to be preserved before entering winkle and
> restored upon wake up.
> 
> Power-on Reset Engine (PORE) is a dedicated engine which is responsible
> for powering on the chiplet during wake up. It can be programmed to
> restore the register contests of a few specific registers. This patch
> uses PORE to restore register state wherever possible and uses stack to
> save and restore rest of the necessary registers.
> 
> With hypervisor state restore things fall under three categories-
> per-core state, per-subcore state and per-thread state. To manage this,
> extend the infrastructure introduced for sleep. Mainly we add a paca
> variable subcore_sibling_mask. Using this and the core_idle_state we can
> distingush first thread in core and subcore.

Comments below...

> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
> index 7637889..2b9b5fb 100644
> --- a/arch/powerpc/kernel/exceptions-64s.S
> +++ b/arch/powerpc/kernel/exceptions-64s.S
> @@ -102,9 +102,7 @@ system_reset_pSeries:
>  #ifdef CONFIG_PPC_P7_NAP
>  BEGIN_FTR_SECTION
>  	/* Running native on arch 2.06 or later, check if we are
> -	 * waking up from nap. We only handle no state loss and
> -	 * supervisor state loss. We do -not- handle hypervisor
> -	 * state loss at this time.
> +	 * waking up from nap/sleep/winkle.
>  	 */
>  	mfspr	r13,SPRN_SRR1
>  	rlwinm.	r13,r13,47-31,30,31
> @@ -112,7 +110,17 @@ BEGIN_FTR_SECTION
>  
>  	cmpwi	cr3,r13,2
>  
> -	GET_PACA(r13)
> +	/* Check if last bit of HSPGR0 is set. This indicates whether we are
> +	 * waking up from winkle */
> +	li	r3,1
> +	mfspr	r4,SPRN_HSPRG0
> +	and	r5,r4,r3
> +	cmpwi	cr4,r5,1	/* Store result in cr4 for later use */
> +
> +	andc	r4,r4,r3
> +	mtspr	SPRN_HSPRG0,r4
> +
> +	mr	r13,r4

This seems unnecessarily convoluted.  How about:

	GET_PACA(r13)
	clrldi	r5,r13,63
	clrrdi	r13,r13,1
	cmpwi	cr4,r5,1
	mtspr	SPRN_HSPRG0,r13

> diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
> index 8c3a1f4..8102075 100644
> --- a/arch/powerpc/kernel/idle_power7.S
> +++ b/arch/powerpc/kernel/idle_power7.S
> @@ -19,8 +19,24 @@
>  #include <asm/kvm_book3s_asm.h>
>  #include <asm/opal.h>
>  #include <asm/cpuidle.h>
> +#include <asm/mmu-hash64.h>
>  
>  #undef DEBUG
> +/*
> + * Use unused space in the interrupt stack to save and restore
> + * registers for winkle support.
> + */
> +#define _SDR1	GPR3
> +#define _RPR	GPR4
> +#define _SPURR	GPR5
> +#define _PURR	GPR6
> +#define _TSCR	GPR7
> +#define _DSCR	GPR8
> +#define _AMOR	GPR9
> +#define _PMC5	GPR10
> +#define _PMC6	GPR11

Why only PMC5 and PMC6 out of all the PMU registers?  What about
PMC1-PMC4 and the MMCR registers?  I assume they're lost during winkle
state also, aren't they?  If we're not saving them, what's the point
of saving and restoring PMC5 and PMC6?

> +#define _WORT	GPR12
> +#define _WORC	GPR13
>  
>  /* Idle state entry routines */
>  
> @@ -124,8 +140,8 @@ power7_enter_nap_mode:
>  	stb	r4,HSTATE_HWTHREAD_STATE(r13)
>  #endif
>  	stb	r3,PACA_THREAD_IDLE_STATE(r13)
> -	cmpwi	cr1,r3,PNV_THREAD_SLEEP
> -	bge	cr1,2f
> +	cmpwi	cr3,r3,PNV_THREAD_SLEEP
> +	bge	cr3,2f
>  	IDLE_STATE_ENTER_SEQ(PPC_NAP)
>  	/* No return */
>  2:
> @@ -154,7 +170,8 @@ pnv_fastsleep_workaround_at_entry:
>  	isync
>  	bne-	lwarx_loop1
>  
> -common_enter: /* common code for all the threads entering sleep */
> +common_enter: /* common code for all the threads entering sleep  or winkle */
> +	bgt	cr3,enter_winkle
>  	IDLE_STATE_ENTER_SEQ(PPC_SLEEP)
>  
>  fastsleep_workaround_at_entry:
> @@ -175,6 +192,34 @@ fastsleep_workaround_at_entry:
>  	stw	r0,0(r14)
>  	b	common_enter
>  
> +enter_winkle:
> +	/*
> +	 * Note all register i.e per-core, per-subcore or per-thread is saved
> +	 * here since any thread in the core might wake up first
> +	 */
> +	mfspr	r3,SPRN_SDR1
> +	std	r3,_SDR1(r1)
> +	mfspr	r3,SPRN_RPR
> +	std	r3,_RPR(r1)
> +	mfspr	r3,SPRN_SPURR
> +	std	r3,_SPURR(r1)
> +	mfspr	r3,SPRN_PURR
> +	std	r3,_PURR(r1)
> +	mfspr	r3,SPRN_TSCR
> +	std	r3,_TSCR(r1)
> +	mfspr	r3,SPRN_DSCR
> +	std	r3,_DSCR(r1)
> +	mfspr	r3,SPRN_AMOR
> +	std	r3,_AMOR(r1)
> +	mfspr	r3,SPRN_PMC5
> +	std	r3,_PMC5(r1)
> +	mfspr	r3,SPRN_PMC6
> +	std	r3,_PMC6(r1)
> +	mfspr	r3,SPRN_WORT
> +	std	r3,_WORT(r1)
> +	mfspr	r3,SPRN_WORC
> +	std	r3,_WORC(r1)
> +	IDLE_STATE_ENTER_SEQ(PPC_WINKLE)
>  
>  _GLOBAL(power7_idle)
>  	/* Now check if user or arch enabled NAP mode */
> @@ -197,6 +242,12 @@ _GLOBAL(power7_sleep)
>  	b	power7_powersave_common
>  	/* No return */
>  
> +_GLOBAL(power7_winkle)
> +	li	r3,3
> +	li	r4,1
> +	b	power7_powersave_common
> +	/* No return */
> +
>  #define CHECK_HMI_INTERRUPT						\
>  	mfspr	r0,SPRN_SRR1;						\
>  BEGIN_FTR_SECTION_NESTED(66);						\
> @@ -238,11 +289,23 @@ lwarx_loop2:
>  	bne	core_idle_lock_held
>  
>  	cmpwi	cr2,r15,0
> +	lbz	r4,PACA_SUBCORE_SIBLING_MASK(r13)
> +	and	r4,r4,r15
> +	cmpwi	cr1,r4,0	/* Check if first in subcore */
> +
> +	/*
> +	 * At this stage
> +	 * cr1 - 10 if first thread to wakeup in subcore
> +	 * cr2 - 10 if first thread to wakeup in core
> +	 * cr3-  01 if waking up from sleep or winkle
> +	 * cr4 - 10 if waking up from winkle
> +	 */

What do "10" and "01" mean in this comment?  (If they were CR field
values in binary they would need to be 3 or 4 bits, not 2.)

Paul.
