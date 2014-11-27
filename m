Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaK0GYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:24:38 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:60597 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaK0GYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:24:36 -0500
Message-ID: <5476C392.4060205@linux.vnet.ibm.com>
Date: Thu, 27 Nov 2014 11:54:18 +0530
From: Shreyas B Prabhu <shreyas@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 4/4] powernv: powerpc: Add winkle support for offline
 cpus
References: <1416914279-30384-1-git-send-email-shreyas@linux.vnet.ibm.com> <1416914279-30384-5-git-send-email-shreyas@linux.vnet.ibm.com> <1417053311.5089.74.camel@kernel.crashing.org>
In-Reply-To: <1417053311.5089.74.camel@kernel.crashing.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112706-0025-0000-0000-0000021AB8A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Thursday 27 November 2014 07:25 AM, Benjamin Herrenschmidt wrote:
> On Tue, 2014-11-25 at 16:47 +0530, Shreyas B. Prabhu wrote:
> 
>> diff --git a/arch/powerpc/kernel/cpu_setup_power.S b/arch/powerpc/kernel/cpu_setup_power.S
>> index 4673353..66874aa 100644
>> --- a/arch/powerpc/kernel/cpu_setup_power.S
>> +++ b/arch/powerpc/kernel/cpu_setup_power.S
>> @@ -55,6 +55,8 @@ _GLOBAL(__setup_cpu_power8)
>>  	beqlr
>>  	li	r0,0
>>  	mtspr	SPRN_LPID,r0
>> +	mtspr	SPRN_WORT,r0
>> +	mtspr	SPRN_WORC,r0
>>  	mfspr	r3,SPRN_LPCR
>>  	ori	r3, r3, LPCR_PECEDH
>>  	bl	__init_LPCR
>> @@ -75,6 +77,8 @@ _GLOBAL(__restore_cpu_power8)
>>  	li	r0,0
>>  	mtspr	SPRN_LPID,r0
>>  	mfspr   r3,SPRN_LPCR
>> +	mtspr	SPRN_WORT,r0
>> +	mtspr	SPRN_WORC,r0
>>  	ori	r3, r3, LPCR_PECEDH
>>  	bl	__init_LPCR
>>  	bl	__init_HFSCR
> 
> Clearing WORT and WORC might not be the best thing. We know the HW folks
> have been trying to tune those values and we might need to preserve what
> the boot FW has set.
> 
> Can you get in touch with them and double check what we should do here ?
> 

I observed these were always 0. I'll speak to HW folks as you suggested.

>> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
>> index 3311c8d..c9897cb 100644
>> --- a/arch/powerpc/kernel/exceptions-64s.S
>> +++ b/arch/powerpc/kernel/exceptions-64s.S
>> @@ -112,6 +112,16 @@ BEGIN_FTR_SECTION
>>  
>>  	cmpwi	cr1,r13,2
>>  
>> +	/* Check if last bit of HSPGR0 is set. This indicates whether we are
>> +	 * waking up from winkle */
>> +	li	r3,1
>> +	mfspr	r4,SPRN_HSPRG0
>> +	and	r5,r4,r3
>> +	cmpwi	cr4,r5,1	/* Store result in cr4 for later use */
>> +
>> +	andc	r4,r4,r3
>> +	mtspr	SPRN_HSPRG0,r4
>> +
> 
> There is an open question here whether adding a beq cr4,+8 after the
> cmpwi (or a +4 after the andc) is worthwhile. Can you check ? (either
> measure or talk to HW folks). 

Okay. This because mtspr is heavier op than beq?
> Also we could write directly to r13...

You mean use mr r13,r4 instead or GET_PACA?

>>  	GET_PACA(r13)
>>  	lbz	r0,PACA_THREAD_IDLE_STATE(r13)
>>  	cmpwi   cr2,r0,PNV_THREAD_NAP
>> diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
>> index c1d590f..78c30b0 100644
>> --- a/arch/powerpc/kernel/idle_power7.S
>> +++ b/arch/powerpc/kernel/idle_power7.S
>> @@ -19,8 +19,22 @@
>>  #include <asm/kvm_book3s_asm.h>
>>  #include <asm/opal.h>
>>  #include <asm/cpuidle.h>
>> +#include <asm/mmu-hash64.h>
>>  
>>  #undef DEBUG
>> +/*
>> + * Use unused space in the interrupt stack to save and restore
>> + * registers for winkle support.
>> + */
>> +#define _SDR1	GPR3
>> +#define _RPR	GPR4
>> +#define _SPURR	GPR5
>> +#define _PURR	GPR6
>> +#define _TSCR	GPR7
>> +#define _DSCR	GPR8
>> +#define _AMOR	GPR9
>> +#define _PMC5	GPR10
>> +#define _PMC6	GPR11
> 
> WORT/WORTC need saving restoring

The reason I skipped this was because these were always 0. But since its
set by FW, I'll save and restore them.

> 
>>  /* Idle state entry routines */
>>  
>> @@ -153,32 +167,60 @@ lwarx_loop1:
>>  	b	common_enter
>>  
>>  last_thread:
>> -	LOAD_REG_ADDR(r3, pnv_need_fastsleep_workaround)
>> -	lbz	r3,0(r3)
>> -	cmpwi	r3,1
>> -	bne	common_enter
>>  	/*
>>  	 * Last thread of the core entering sleep. Last thread needs to execute
>>  	 * the hardware bug workaround code. Before that, set the lock bit to
>>  	 * avoid the race of other threads waking up and undoing workaround
>>  	 * before workaround is applied.
>>  	 */
>> +	LOAD_REG_ADDR(r3, pnv_need_fastsleep_workaround)
>> +	lbz	r3,0(r3)
>> +	cmpwi	r3,1
>> +	bne	common_enter
>> +
>>  	ori	r15,r15,PNV_CORE_IDLE_LOCK_BIT
>>  	stwcx.	r15,0,r14
>>  	bne-	lwarx_loop1
>>  
>>  	/* Fast sleep workaround */
>> +	mfcr	r16	/* Backup CR to a non-volatile register */
>>  	li	r3,1
>>  	li	r4,1
>>  	li	r0,OPAL_CONFIG_CPU_IDLE_STATE
>>  	bl	opal_call_realmode
>> +	mtcr	r16	/* Restore CR */
> 
> Why isn't the above already in the previous patch ? Also see my comment
> about using a non-volatile CR instead.

In the previous patch I wasn't using any CR after this OPAL call. Hence
I had skipped it. As you suggested I'll avoid this by using CR[234].
> 
>>  	/* Clear Lock bit */
>>  	andi.	r15,r15,PNV_CORE_IDLE_THREAD_BITS
>>  	stw	r15,0(r14)
>>  
>> -common_enter: /* common code for all the threads entering sleep */
>> +common_enter: /* common code for all the threads entering sleep or winkle*/
>> +	bgt	cr1,enter_winkle
>>  	IDLE_STATE_ENTER_SEQ(PPC_SLEEP)
>> +enter_winkle:
>> +	/*
>> +	 * Note all register i.e per-core, per-subcore or per-thread is saved
>> +	 * here since any thread in the core might wake up first
>> +	 */
>> +	mfspr	r3,SPRN_SDR1
>> +	std	r3,_SDR1(r1)
>> +	mfspr	r3,SPRN_RPR
>> +	std	r3,_RPR(r1)
>> +	mfspr	r3,SPRN_SPURR
>> +	std	r3,_SPURR(r1)
>> +	mfspr	r3,SPRN_PURR
>> +	std	r3,_PURR(r1)
>> +	mfspr	r3,SPRN_TSCR
>> +	std	r3,_TSCR(r1)
>> +	mfspr	r3,SPRN_DSCR
>> +	std	r3,_DSCR(r1)
>> +	mfspr	r3,SPRN_AMOR
>> +	std	r3,_AMOR(r1)
>> +	mfspr	r3,SPRN_PMC5
>> +	std	r3,_PMC5(r1)
>> +	mfspr	r3,SPRN_PMC6
>> +	std	r3,_PMC6(r1)
>> +	IDLE_STATE_ENTER_SEQ(PPC_WINKLE)
>>  
>>  _GLOBAL(power7_idle)
>>  	/* Now check if user or arch enabled NAP mode */
>> @@ -201,6 +243,12 @@ _GLOBAL(power7_sleep)
>>  	b	power7_powersave_common
>>  	/* No return */
>>  
>> +_GLOBAL(power7_winkle)
>> +	li	r3,PNV_THREAD_WINKLE
>> +	li	r4,1
>> +	b	power7_powersave_common
>> +	/* No return */
>> +
>>  #define CHECK_HMI_INTERRUPT						\
>>  	mfspr	r0,SPRN_SRR1;						\
>>  BEGIN_FTR_SECTION_NESTED(66);						\
>> @@ -250,22 +298,54 @@ lwarx_loop2:
>>  	 */
>>  	bne	lwarx_loop2
>>  
>> -	cmpwi	cr2,r15,0
>> +	cmpwi	cr2,r15,0	/* Check if first in core */
>> +	lbz	r4,PACA_SUBCORE_SIBLING_MASK(r13)
>> +	and	r4,r4,r15
>> +	cmpwi	cr3,r4,0	/* Check if first in subcore */
>> +
>> +	/*
>> +	 * At this stage
>> +	 * cr1 - 01 if waking up from sleep or winkle
>> +	 * cr2 - 10 if first thread to wakeup in core
>> +	 * cr3 - 10 if first thread to wakeup in subcore
>> +	 * cr4 - 10 if waking up from winkle
>> +	 */
>> +
>>  	or	r15,r15,r7		/* Set thread bit */
>>  
>> -	beq	cr2,first_thread
>> +	beq	cr3,first_thread_in_subcore
>>  
>> -	/* Not first thread in core to wake up */
>> +	/* Not first thread in subcore to wake up */
>>  	stwcx.	r15,0,r14
>>  	bne-	lwarx_loop2
>>  	b	common_exit
>>  
>> -first_thread:
>> -	/* First thread in core to wakeup */
>> +first_thread_in_subcore:
>> +	/* First thread in subcore to wakeup set the lock bit */
>>  	ori	r15,r15,PNV_CORE_IDLE_LOCK_BIT
>>  	stwcx.	r15,0,r14
>>  	bne-	lwarx_loop2
>>  
>> +	/*
>> +	 * If waking up from sleep, subcore state is not lost. Hence
>> +	 * skip subcore state restore
>> +	 */
>> +	bne	cr4,subcore_state_restored
>> +
>> +	/* Restore per-subcore state */
>> +	ld      r4,_SDR1(r1)
>> +	mtspr   SPRN_SDR1,r4
>> +	ld      r4,_RPR(r1)
>> +	mtspr   SPRN_RPR,r4
>> +	ld	r4,_AMOR(r1)
>> +	mtspr	SPRN_AMOR,r4
>> +
>> +subcore_state_restored:
>> +	/* Check if the thread is also the first thread in the core. If not,
>> +	 * skip to clear_lock */
>> +	bne	cr2,clear_lock
>> +
>> +first_thread_in_core:
>>  	LOAD_REG_ADDR(r3, pnv_need_fastsleep_workaround)
>>  	lbz	r3,0(r3)
>>  	cmpwi	r3,1
>> @@ -280,21 +360,71 @@ first_thread:
>>  	bl	opal_call_realmode
>>  	mtcr	r16	/* Restore CR */
>>  
>> -	/* Do timebase resync if we are waking up from sleep. Use cr1 value
>> -	 * set in exceptions-64s.S */
>> +timebase_resync:
>> +	/* Do timebase resync only if the core truly woke up from
>> +	 * sleep/winkle */
>>  	ble	cr1,clear_lock
>>  
>> -timebase_resync:
>>  	/* Time base re-sync */
>> +	mfcr	r16	/* Backup CR into a non-volatile register */
>>  	li	r0,OPAL_RESYNC_TIMEBASE
>>  	bl	opal_call_realmode;
>>  	/* TODO: Check r3 for failure */
>> +	mtcr	r16	/* Restore CR */
>> +
>> +	/*
>> +	 * If waking up from sleep, per core state is not lost, skip to
>> +	 * clear_lock.
>> +	 */
>> +	bne	cr4,clear_lock
>> +
>> +	/* Restore per core state */
>> +	ld	r4,_TSCR(r1)
>> +	mtspr	SPRN_TSCR,r4
>>  
>>  clear_lock:
>>  	andi.	r15,r15,PNV_CORE_IDLE_THREAD_BITS
>>  	stw	r15,0(r14)
>>  
>>  common_exit:
>> +	/* Common to all threads
>> +	 *
>> +	 * If waking up from sleep, hypervisor state is not lost. Hence
>> +	 * skip hypervisor state restore.
>> +	 */
>> +	bne	cr4,hypervisor_state_restored
>> +
>> +	/* Waking up from winkle */
>> +
>> +	/* Restore per thread state */
>> +	bl	__restore_cpu_power8
>> +
>> +	/* Restore SLB  from PACA */
>> +	ld	r8,PACA_SLBSHADOWPTR(r13)
>> +
>> +	.rept	SLB_NUM_BOLTED
>> +	li	r3, SLBSHADOW_SAVEAREA
>> +	LDX_BE	r5, r8, r3
>> +	addi	r3, r3, 8
>> +	LDX_BE	r6, r8, r3
>> +	andis.	r7,r5,SLB_ESID_V@h
>> +	beq	1f
>> +	slbmte	r6,r5
>> +1:	addi	r8,r8,16
>> +	.endr
>> +
>> +	ld	r4,_SPURR(r1)
>> +	mtspr	SPRN_SPURR,r4
>> +	ld	r4,_PURR(r1)
>> +	mtspr	SPRN_PURR,r4
>> +	ld	r4,_DSCR(r1)
>> +	mtspr	SPRN_DSCR,r4
>> +	ld	r4,_PMC5(r1)
>> +	mtspr	SPRN_PMC5,r4
>> +	ld	r4,_PMC6(r1)
>> +	mtspr	SPRN_PMC6,r4
>> +
>> +hypervisor_state_restored:
>>  	li	r5,PNV_THREAD_RUNNING
>>  	stb     r5,PACA_THREAD_IDLE_STATE(r13)
>>  
>> diff --git a/arch/powerpc/platforms/powernv/opal-wrappers.S b/arch/powerpc/platforms/powernv/opal-wrappers.S
>> index b2aa93b..e1e91e0 100644
>> --- a/arch/powerpc/platforms/powernv/opal-wrappers.S
>> +++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
>> @@ -191,6 +191,7 @@ return_from_opal_call:
>>  #ifdef __LITTLE_ENDIAN__
>>  	FIXUP_ENDIAN
>>  #endif
>> +	ld	r2,PACATOC(r13)
>>  	ld	r12,_LINK(r1)
>>  	mtlr	r12
>>  	blr
>> @@ -284,6 +285,7 @@ OPAL_CALL(opal_sensor_read,			OPAL_SENSOR_READ);
>>  OPAL_CALL(opal_get_param,			OPAL_GET_PARAM);
>>  OPAL_CALL(opal_set_param,			OPAL_SET_PARAM);
>>  OPAL_CALL(opal_handle_hmi,			OPAL_HANDLE_HMI);
>> +OPAL_CALL(opal_slw_set_reg,			OPAL_SLW_SET_REG);
>>  OPAL_CALL(opal_register_dump_region,		OPAL_REGISTER_DUMP_REGION);
>>  OPAL_CALL(opal_unregister_dump_region,		OPAL_UNREGISTER_DUMP_REGION);
>>  OPAL_CALL(opal_pci_set_phb_cxl_mode,		OPAL_PCI_SET_PHB_CXL_MODE);
>> diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
>> index 17fb98c..4a886a1 100644
>> --- a/arch/powerpc/platforms/powernv/setup.c
>> +++ b/arch/powerpc/platforms/powernv/setup.c
>> @@ -40,6 +40,7 @@
>>  #include <asm/cpuidle.h>
>>  
>>  #include "powernv.h"
>> +#include "subcore.h"
>>  
>>  static void __init pnv_setup_arch(void)
>>  {
>> @@ -293,6 +294,74 @@ static void __init pnv_setup_machdep_rtas(void)
>>  #endif /* CONFIG_PPC_POWERNV_RTAS */
>>  
>>  static u32 supported_cpuidle_states;
>> +int pnv_save_sprs_for_winkle(void)
>> +{
>> +	int cpu;
>> +	int rc;
>> +
>> +	/*
>> +	 * hid0, hid1, hid4, hid5, hmeer and lpcr values are symmetric accross
>> +	 * all cpus at boot. Get these reg values of current cpu and use the
>> +	 * same accross all cpus.
>> +	 */
>> +	uint64_t lpcr_val = mfspr(SPRN_LPCR);
>> +	uint64_t hid0_val = mfspr(SPRN_HID0);
>> +	uint64_t hid1_val = mfspr(SPRN_HID1);
>> +	uint64_t hid4_val = mfspr(SPRN_HID4);
>> +	uint64_t hid5_val = mfspr(SPRN_HID5);
>> +	uint64_t hmeer_val = mfspr(SPRN_HMEER);
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		uint64_t pir = get_hard_smp_processor_id(cpu);
>> +		uint64_t hsprg0_val = (uint64_t)&paca[cpu];
>> +
>> +		/*
>> +		 * HSPRG0 is used to store the cpu's pointer to paca. Hence last
>> +		 * 3 bits are guaranteed to be 0. Program slw to restore HSPRG0
>> +		 * with 63rd bit set, so that when a thread wakes up at 0x100 we
>> +		 * can use this bit to distinguish between fastsleep and
>> +		 * deep winkle.
>> +		 */
>> +		hsprg0_val |= 1;
>> +
>> +		rc = opal_slw_set_reg(pir, SPRN_HSPRG0, hsprg0_val);
>> +		if (rc != 0)
>> +			return rc;
>> +
>> +		rc = opal_slw_set_reg(pir, SPRN_LPCR, lpcr_val);
>> +		if (rc != 0)
>> +			return rc;
>> +
>> +		/* HIDs are per core registers */
>> +		if (cpu_thread_in_core(cpu) == 0) {
>> +
>> +			rc = opal_slw_set_reg(pir, SPRN_HMEER, hmeer_val);
>> +			if (rc != 0)
>> +				return rc;
>> +
>> +			rc = opal_slw_set_reg(pir, SPRN_HID0, hid0_val);
>> +			if (rc != 0)
>> +				return rc;
>> +
>> +			rc = opal_slw_set_reg(pir, SPRN_HID1, hid1_val);
>> +			if (rc != 0)
>> +				return rc;
>> +
>> +			rc = opal_slw_set_reg(pir, SPRN_HID4, hid4_val);
>> +			if (rc != 0)
>> +				return rc;
>> +
>> +			rc = opal_slw_set_reg(pir, SPRN_HID5, hid5_val);
>> +			if (rc != 0)
>> +				return rc;
>> +
>> +		}
>> +
>> +	}
>> +
>> +	return 0;
>> +
>> +}
>>  
>>  static void pnv_alloc_idle_core_states(void)
>>  {
>> @@ -324,6 +393,10 @@ static void pnv_alloc_idle_core_states(void)
>>  
>>  		}
>>  	}
>> +	update_subcore_sibling_mask();
>> +	if (supported_cpuidle_states & OPAL_PM_WINKLE_ENABLED)
>> +		pnv_save_sprs_for_winkle();
>> +
>>  }
>>  
>>  u32 pnv_get_supported_cpuidle_states(void)
>> diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
>> index 12b761a..5e35857 100644
>> --- a/arch/powerpc/platforms/powernv/smp.c
>> +++ b/arch/powerpc/platforms/powernv/smp.c
>> @@ -167,7 +167,9 @@ static void pnv_smp_cpu_kill_self(void)
>>  	mtspr(SPRN_LPCR, mfspr(SPRN_LPCR) & ~(u64)LPCR_PECE1);
>>  	while (!generic_check_cpu_restart(cpu)) {
>>  		ppc64_runlatch_off();
>> -		if ((idle_states & OPAL_PM_SLEEP_ENABLED) ||
>> +		if (idle_states & OPAL_PM_WINKLE_ENABLED)
>> +			power7_winkle();
>> +		else if ((idle_states & OPAL_PM_SLEEP_ENABLED) ||
>>  				(idle_states & OPAL_PM_SLEEP_ENABLED_ER1))
>>  			power7_sleep();
>>  		else
>> diff --git a/arch/powerpc/platforms/powernv/subcore.c b/arch/powerpc/platforms/powernv/subcore.c
>> index c87f96b..f60f80a 100644
>> --- a/arch/powerpc/platforms/powernv/subcore.c
>> +++ b/arch/powerpc/platforms/powernv/subcore.c
>> @@ -160,6 +160,18 @@ static void wait_for_sync_step(int step)
>>  	mb();
>>  }
>>  
>> +static void update_hid_in_slw(u64 hid0)
>> +{
>> +	u64 idle_states = pnv_get_supported_cpuidle_states();
>> +
>> +	if (idle_states & OPAL_PM_WINKLE_ENABLED) {
>> +		/* OPAL call to patch slw with the new HID0 value */
>> +		u64 cpu_pir = hard_smp_processor_id();
>> +
>> +		opal_slw_set_reg(cpu_pir, SPRN_HID0, hid0);
>> +	}
>> +}
>> +
>>  static void unsplit_core(void)
>>  {
>>  	u64 hid0, mask;
>> @@ -179,6 +191,7 @@ static void unsplit_core(void)
>>  	hid0 = mfspr(SPRN_HID0);
>>  	hid0 &= ~HID0_POWER8_DYNLPARDIS;
>>  	mtspr(SPRN_HID0, hid0);
>> +	update_hid_in_slw(hid0);
>>  
>>  	while (mfspr(SPRN_HID0) & mask)
>>  		cpu_relax();
>> @@ -215,6 +228,7 @@ static void split_core(int new_mode)
>>  	hid0  = mfspr(SPRN_HID0);
>>  	hid0 |= HID0_POWER8_DYNLPARDIS | split_parms[i].value;
>>  	mtspr(SPRN_HID0, hid0);
>> +	update_hid_in_slw(hid0);
>>  
>>  	/* Wait for it to happen */
>>  	while (!(mfspr(SPRN_HID0) & split_parms[i].mask))
>> @@ -251,6 +265,25 @@ bool cpu_core_split_required(void)
>>  	return true;
>>  }
>>  
>> +void update_subcore_sibling_mask(void)
>> +{
>> +	int cpu;
>> +	/*
>> +	 * sibling mask for the first cpu. Left shift this by required bits
>> +	 * to get sibling mask for the rest of the cpus.
>> +	 */
>> +	int sibling_mask_first_cpu =  (1 << threads_per_subcore) - 1;
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		int tid = cpu_thread_in_core(cpu);
>> +		int offset = (tid / threads_per_subcore) * threads_per_subcore;
>> +		int mask = sibling_mask_first_cpu << offset;
>> +
>> +		paca[cpu].subcore_sibling_mask = mask;
>> +
>> +	}
>> +}
>> +
>>  static int cpu_update_split_mode(void *data)
>>  {
>>  	int cpu, new_mode = *(int *)data;
>> @@ -284,6 +317,7 @@ static int cpu_update_split_mode(void *data)
>>  		/* Make the new mode public */
>>  		subcores_per_core = new_mode;
>>  		threads_per_subcore = threads_per_core / subcores_per_core;
>> +		update_subcore_sibling_mask();
>>  
>>  		/* Make sure the new mode is written before we exit */
>>  		mb();
>> diff --git a/arch/powerpc/platforms/powernv/subcore.h b/arch/powerpc/platforms/powernv/subcore.h
>> index 148abc9..604eb40 100644
>> --- a/arch/powerpc/platforms/powernv/subcore.h
>> +++ b/arch/powerpc/platforms/powernv/subcore.h
>> @@ -15,4 +15,5 @@
>>  
>>  #ifndef __ASSEMBLY__
>>  void split_core_secondary_loop(u8 *state);
>> +extern void update_subcore_sibling_mask(void);
>>  #endif
> 
> 
Thanks,
Shreyas

