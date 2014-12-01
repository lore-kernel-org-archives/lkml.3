Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaLAG1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 01:27:40 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59679 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaLAG1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 01:27:39 -0500
Message-ID: <547C0A4D.4050804@linux.vnet.ibm.com>
Date: Mon, 01 Dec 2014 11:57:25 +0530
From: Shreyas B Prabhu <shreyas@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 3/4] powernv: cpuidle: Redesign idle states management
References: <1416914279-30384-1-git-send-email-shreyas@linux.vnet.ibm.com> <1416914279-30384-4-git-send-email-shreyas@linux.vnet.ibm.com> <20141127235035.GC12871@iris.ozlabs.ibm.com>
In-Reply-To: <20141127235035.GC12871@iris.ozlabs.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120106-0005-0000-0000-00000282E538
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 28 November 2014 05:20 AM, Paul Mackerras wrote:
> On Tue, Nov 25, 2014 at 04:47:58PM +0530, Shreyas B. Prabhu wrote:
> [snip]
>> +2:
>> +	/* Sleep or winkle */
>> +	li	r7,1
>> +	mfspr	r8,SPRN_PIR
>> +	/*
>> +	 * The last 3 bits of PIR represents the thread id of a cpu
>> +	 * in power8. This will need adjusting for power7.
>> +	 */
>> +	andi.	r8,r8,0x07			/* Get thread id into r8 */
>> +	rotld	r7,r7,r8
> 
> I would suggest adding another u8 field to the paca to store our
> thread bit, and initialize it to 1 << (cpu_id % threads_per_core)
> early on.  That will handle the POWER7 case correctly and reduce these
> four instructions to one.
> 
Okay. I'll make the change. 
>> +
>> +	ld	r14,PACA_CORE_IDLE_STATE_PTR(r13)
>> +lwarx_loop1:
>> +	lwarx	r15,0,r14
>> +	andc	r15,r15,r7			/* Clear thread bit */
>> +
>> +	andi.	r15,r15,PNV_CORE_IDLE_THREAD_BITS
>> +	beq	last_thread
>> +
>> +	/* Not the last thread to goto sleep */
>> +	stwcx.	r15,0,r14
>> +	bne-	lwarx_loop1
>> +	b	common_enter
>> +
>> +last_thread:
>> +	LOAD_REG_ADDR(r3, pnv_need_fastsleep_workaround)
>> +	lbz	r3,0(r3)
>> +	cmpwi	r3,1
>> +	bne	common_enter
>> +	/*
>> +	 * Last thread of the core entering sleep. Last thread needs to execute
>> +	 * the hardware bug workaround code. Before that, set the lock bit to
>> +	 * avoid the race of other threads waking up and undoing workaround
>> +	 * before workaround is applied.
>> +	 */
>> +	ori	r15,r15,PNV_CORE_IDLE_LOCK_BIT
>> +	stwcx.	r15,0,r14
>> +	bne-	lwarx_loop1
>> +
>> +	/* Fast sleep workaround */
>> +	li	r3,1
>> +	li	r4,1
>> +	li	r0,OPAL_CONFIG_CPU_IDLE_STATE
>> +	bl	opal_call_realmode
>> +
>> +	/* Clear Lock bit */
>> +	andi.	r15,r15,PNV_CORE_IDLE_THREAD_BITS
>> +	stw	r15,0(r14)
> 
> In this case we know the result of the andi. will be 0, so this could
> be just li r0,0; stw r0,0(r14).
> 

Yes. I'll make the change.
>> +
>> +common_enter: /* common code for all the threads entering sleep */
>> +	IDLE_STATE_ENTER_SEQ(PPC_SLEEP)
>>  
>>  _GLOBAL(power7_idle)
>>  	/* Now check if user or arch enabled NAP mode */
>> @@ -141,49 +191,16 @@ _GLOBAL(power7_idle)
>>  
>>  _GLOBAL(power7_nap)
>>  	mr	r4,r3
>> -	li	r3,0
>> +	li	r3,PNV_THREAD_NAP
>>  	b	power7_powersave_common
>>  	/* No return */
>>  
>>  _GLOBAL(power7_sleep)
>> -	li	r3,1
>> +	li	r3,PNV_THREAD_SLEEP
>>  	li	r4,1
>>  	b	power7_powersave_common
>>  	/* No return */
>>  
>> -/*
>> - * Make opal call in realmode. This is a generic function to be called
>> - * from realmode from reset vector. It handles endianess.
>> - *
>> - * r13 - paca pointer
>> - * r1  - stack pointer
>> - * r3  - opal token
>> - */
>> -opal_call_realmode:
>> -	mflr	r12
>> -	std	r12,_LINK(r1)
>> -	ld	r2,PACATOC(r13)
>> -	/* Set opal return address */
>> -	LOAD_REG_ADDR(r0,return_from_opal_call)
>> -	mtlr	r0
>> -	/* Handle endian-ness */
>> -	li	r0,MSR_LE
>> -	mfmsr	r12
>> -	andc	r12,r12,r0
>> -	mtspr	SPRN_HSRR1,r12
>> -	mr	r0,r3			/* Move opal token to r0 */
>> -	LOAD_REG_ADDR(r11,opal)
>> -	ld	r12,8(r11)
>> -	ld	r2,0(r11)
>> -	mtspr	SPRN_HSRR0,r12
>> -	hrfid
>> -
>> -return_from_opal_call:
>> -	FIXUP_ENDIAN
>> -	ld	r0,_LINK(r1)
>> -	mtlr	r0
>> -	blr
>> -
>>  #define CHECK_HMI_INTERRUPT						\
>>  	mfspr	r0,SPRN_SRR1;						\
>>  BEGIN_FTR_SECTION_NESTED(66);						\
>> @@ -196,10 +213,8 @@ ALT_FTR_SECTION_END_NESTED_IFSET(CPU_FTR_ARCH_207S, 66);		\
>>  	/* Invoke opal call to handle hmi */				\
>>  	ld	r2,PACATOC(r13);					\
>>  	ld	r1,PACAR1(r13);						\
>> -	std	r3,ORIG_GPR3(r1);	/* Save original r3 */		\
>> -	li	r3,OPAL_HANDLE_HMI;	/* Pass opal token argument*/	\
>> +	li	r0,OPAL_HANDLE_HMI;	/* Pass opal token argument*/	\
>>  	bl	opal_call_realmode;					\
>> -	ld	r3,ORIG_GPR3(r1);	/* Restore original r3 */	\
>>  20:	nop;
>>  
>>  
>> @@ -210,12 +225,91 @@ _GLOBAL(power7_wakeup_tb_loss)
>>  BEGIN_FTR_SECTION
>>  	CHECK_HMI_INTERRUPT
>>  END_FTR_SECTION_IFSET(CPU_FTR_HVMODE)
>> +
>> +	li	r7,1
>> +	mfspr	r8,SPRN_PIR
>> +	/*
>> +	 * The last 3 bits of PIR represents the thread id of a cpu
>> +	 * in power8. This will need adjusting for power7.
>> +	 */
>> +	andi.	r8,r8,0x07		/* Get thread id into r8 */
>> +	rotld	r7,r7,r8
>> +	/* r7 now has 'thread_id'th bit set */
>> +
>> +	ld	r14,PACA_CORE_IDLE_STATE_PTR(r13)
>> +lwarx_loop2:
>> +	lwarx	r15,0,r14
>> +	andi.	r9,r15,PNV_CORE_IDLE_LOCK_BIT
>> +	/*
>> +	 * Lock bit is set in one of the 2 cases-
>> +	 * a. In the sleep/winkle enter path, the last thread is executing
>> +	 * fastsleep workaround code.
>> +	 * b. In the wake up path, another thread is executing fastsleep
>> +	 * workaround undo code or resyncing timebase or restoring context
>> +	 * In either case loop until the lock bit is cleared.
>> +	 */
>> +	bne	lwarx_loop2
>> +
>> +	cmpwi	cr2,r15,0
>> +	or	r15,r15,r7		/* Set thread bit */
>> +
>> +	beq	cr2,first_thread
>> +
>> +	/* Not first thread in core to wake up */
>> +	stwcx.	r15,0,r14
>> +	bne-	lwarx_loop2
>> +	b	common_exit
>> +
>> +first_thread:
>> +	/* First thread in core to wakeup */
>> +	ori	r15,r15,PNV_CORE_IDLE_LOCK_BIT
>> +	stwcx.	r15,0,r14
>> +	bne-	lwarx_loop2
>> +
>> +	LOAD_REG_ADDR(r3, pnv_need_fastsleep_workaround)
>> +	lbz	r3,0(r3)
>> +	cmpwi	r3,1
>> +	/*  skip fastsleep workaround if its not needed */
>> +	bne	timebase_resync
>> +
>> +	/* Undo fast sleep workaround */
>> +	mfcr	r16	/* Backup CR into a non-volatile register */
>> +	li	r3,1
>> +	li	r4,0
>> +	li	r0,OPAL_CONFIG_CPU_IDLE_STATE
>> +	bl	opal_call_realmode
>> +	mtcr	r16	/* Restore CR */
>> +
>> +	/* Do timebase resync if we are waking up from sleep. Use cr1 value
>> +	 * set in exceptions-64s.S */
>> +	ble	cr1,clear_lock
>> +
>> +timebase_resync:
>>  	/* Time base re-sync */
>> -	li	r3,OPAL_RESYNC_TIMEBASE
>> +	li	r0,OPAL_RESYNC_TIMEBASE
>>  	bl	opal_call_realmode;
> 
> So if pnv_need_fastsleep_workaround is zero, we always do the timebase
> resync, but if pnv_need_fastsleep_workaround is one, we only do the
> timebase resync if we had a loss of state.  Is that really what you
> meant?
> 
Timebase resync is needed only if we have a loss of state, irrespective of
pnv_need_fastsleep_workaround. 
But I see here in pnv_need_fastsleep_workaround = 0 path, I am doing timebase
resync unconditionally. I'll fix that.

The correct flow is, if its the first thread in the core waking up from sleep
- call OPAL_CONFIG_CPU_IDLE_STATE if pnv_need_fastsleep_workaround = 1
- If we had a state loss, call OPAL_RESYNC_TIMEBASE to resync timebase.
>> -
>>  	/* TODO: Check r3 for failure */
>>  
>> +clear_lock:
>> +	andi.	r15,r15,PNV_CORE_IDLE_THREAD_BITS
>> +	stw	r15,0(r14)
>> +
>> +common_exit:
>> +	li	r5,PNV_THREAD_RUNNING
>> +	stb     r5,PACA_THREAD_IDLE_STATE(r13)
>> +
>> +#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
>> +	li      r0,KVM_HWTHREAD_IN_KERNEL
>> +	stb     r0,HSTATE_HWTHREAD_STATE(r13)
>> +	/* Order setting hwthread_state vs. testing hwthread_req */
>> +	sync
>> +	lbz     r0,HSTATE_HWTHREAD_REQ(r13)
>> +	cmpwi   r0,0
>> +	beq     6f
>> +	b       kvm_start_guest
>> +6:
>> +#endif
> 
> I'd prefer not to duplicate this code.  Could you instead branch back
> to the code in exceptions-64s.S?  Or call this code via a bl and get
> back to exceptions-64s.S via a blr.
> 

Okay.
>> +
>>  	REST_NVGPRS(r1)
>>  	REST_GPR(2, r1)
>>  	ld	r3,_CCR(r1)
>> diff --git a/arch/powerpc/platforms/powernv/opal-wrappers.S b/arch/powerpc/platforms/powernv/opal-wrappers.S
>> index feb549a..b2aa93b 100644
>> --- a/arch/powerpc/platforms/powernv/opal-wrappers.S
>> +++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
>> @@ -158,6 +158,43 @@ opal_tracepoint_return:
>>  	blr
>>  #endif
>>  
>> +/*
>> + * Make opal call in realmode. This is a generic function to be called
>> + * from realmode. It handles endianness.
>> + *
>> + * r13 - paca pointer
>> + * r1  - stack pointer
>> + * r0  - opal token
>> + */
>> +_GLOBAL(opal_call_realmode)
>> +	mflr	r12
>> +	std	r12,_LINK(r1)
> 
> This is a bug waiting to happen.  Using _LINK(r1) was OK in this
> code's previous location, since there we know there is a
> INT_FRAME_SIZE-sized stack frame and the _LINK field is basically
> unused.  Now that you're making this available to call from anywhere,
> you can't trash the caller's stack frame like this.  You need to use
> PPC_LR_STKOFF(r1) instead.
>
 
Okay.
>> +	ld	r2,PACATOC(r13)
>> +	/* Set opal return address */
>> +	LOAD_REG_ADDR(r12,return_from_opal_call)
>> +	mtlr	r12
>> +
>> +	mfmsr	r12
>> +#ifdef __LITTLE_ENDIAN__
>> +	/* Handle endian-ness */
>> +	li	r11,MSR_LE
>> +	andc	r12,r12,r11
>> +#endif
>> +	mtspr	SPRN_HSRR1,r12
>> +	LOAD_REG_ADDR(r11,opal)
>> +	ld	r12,8(r11)
>> +	ld	r2,0(r11)
>> +	mtspr	SPRN_HSRR0,r12
>> +	hrfid
>> +
>> +return_from_opal_call:
>> +#ifdef __LITTLE_ENDIAN__
>> +	FIXUP_ENDIAN
>> +#endif
>> +	ld	r12,_LINK(r1)
>> +	mtlr	r12
>> +	blr
> 
> Paul.
> 

Thanks,
Shreyas

