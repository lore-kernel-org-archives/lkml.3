Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab3LFLKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:10:39 -0500
Received: from mail.southpole.se ([37.247.8.11]:56019 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757659Ab3LFLKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:10:37 -0500
Message-ID: <52A1B0FB.6030507@southpole.se>
Date: Fri, 06 Dec 2013 12:11:55 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: linux-kernel@vger.kernel.org, linux@openrisc.net
Subject: Re: [PATCH] openrisc: tlb miss handler optimizations
References: <1375343170-17848-1-git-send-email-stefan.kristiansson@saunalahti.fi> <20131206102828.GA1369@chokladfabriken.org>
In-Reply-To: <20131206102828.GA1369@chokladfabriken.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13276) on assp.southpole.se
X-Assp-ID: assp.southpole.se 28232-13277
X-Assp-Session: 7FDDB6889628 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

Sorry... this one got lost in the discussion around the HW assisted TLB 
loader.

The patch is fine, per se... compiles and runs without any obvious 
degradation.  The only concern I might have is the removal of "dead 
code" which, at first glance, seems that it maybe should be 
resurrected... aren't those error checks important?  But we're all 
pressed for time and I don't want to lose this patch again so I'll push 
this to master for now and take another look at it before pushing upstream.

Thanks, and thanks for pinging on me this one,
Jonas

On 12/06/2013 11:28 AM, Stefan Kristiansson wrote:
> Hi Jonas,
>
> I realised that this haven't been picked up nor commented on (and that I missed
> CC you on it).
> Could you take a look at it?
>
> Stefan
>
> On Thu, Aug 01, 2013 at 10:46:10AM +0300, Stefan Kristiansson wrote:
>> By slightly reorganizing the code, the number of registers
>> used in the tlb miss handlers can be reduced by two,
>> thus removing the need to save them to memory.
>>
>> Also, some dead and commented out code is removed.
>>
>> No functional change.
>>
>> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
>> ---
>>   arch/openrisc/kernel/head.S | 141 +++++++++++++++-----------------------------
>>   1 file changed, 46 insertions(+), 95 deletions(-)
>>
>> diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
>> index 1d3c9c2..eecc8df 100644
>> --- a/arch/openrisc/kernel/head.S
>> +++ b/arch/openrisc/kernel/head.S
>> @@ -976,8 +976,6 @@ ENTRY(dtlb_miss_handler)
>>   	EXCEPTION_STORE_GPR2
>>   	EXCEPTION_STORE_GPR3
>>   	EXCEPTION_STORE_GPR4
>> -	EXCEPTION_STORE_GPR5
>> -	EXCEPTION_STORE_GPR6
>>   	/*
>>   	 * get EA of the miss
>>   	 */
>> @@ -985,91 +983,70 @@ ENTRY(dtlb_miss_handler)
>>   	/*
>>   	 * pmd = (pmd_t *)(current_pgd + pgd_index(daddr));
>>   	 */
>> -	GET_CURRENT_PGD(r3,r5)		// r3 is current_pgd, r5 is temp
>> +	GET_CURRENT_PGD(r3,r4)		// r3 is current_pgd, r4 is temp
>>   	l.srli	r4,r2,0x18		// >> PAGE_SHIFT + (PAGE_SHIFT - 2)
>>   	l.slli	r4,r4,0x2		// to get address << 2
>> -	l.add	r5,r4,r3		// r4 is pgd_index(daddr)
>> +	l.add	r3,r4,r3		// r4 is pgd_index(daddr)
>>   	/*
>>   	 * if (pmd_none(*pmd))
>>   	 *   goto pmd_none:
>>   	 */
>> -	tophys	(r4,r5)
>> +	tophys	(r4,r3)
>>   	l.lwz	r3,0x0(r4)		// get *pmd value
>>   	l.sfne	r3,r0
>>   	l.bnf	d_pmd_none
>> -	 l.andi	r3,r3,~PAGE_MASK //0x1fff		// ~PAGE_MASK
>> -	/*
>> -	 * if (pmd_bad(*pmd))
>> -	 *   pmd_clear(pmd)
>> -	 *   goto pmd_bad:
>> -	 */
>> -//	l.sfeq	r3,r0			// check *pmd value
>> -//	l.bf	d_pmd_good
>> -	l.addi	r3,r0,0xffffe000	// PAGE_MASK
>> -//	l.j	d_pmd_bad
>> -//	l.sw	0x0(r4),r0		// clear pmd
>> +	 l.addi	r3,r0,0xffffe000	// PAGE_MASK
>> +
>>   d_pmd_good:
>>   	/*
>>   	 * pte = *pte_offset(pmd, daddr);
>>   	 */
>>   	l.lwz	r4,0x0(r4)		// get **pmd value
>>   	l.and	r4,r4,r3		// & PAGE_MASK
>> -	l.srli	r5,r2,0xd		// >> PAGE_SHIFT, r2 == EEAR
>> -	l.andi	r3,r5,0x7ff		// (1UL << PAGE_SHIFT - 2) - 1
>> +	l.srli	r2,r2,0xd		// >> PAGE_SHIFT, r2 == EEAR
>> +	l.andi	r3,r2,0x7ff		// (1UL << PAGE_SHIFT - 2) - 1
>>   	l.slli	r3,r3,0x2		// to get address << 2
>>   	l.add	r3,r3,r4
>> -	l.lwz	r2,0x0(r3)		// this is pte at last
>> +	l.lwz	r3,0x0(r3)		// this is pte at last
>>   	/*
>>   	 * if (!pte_present(pte))
>>   	 */
>> -	l.andi	r4,r2,0x1
>> +	l.andi	r4,r3,0x1
>>   	l.sfne	r4,r0			// is pte present
>>   	l.bnf	d_pte_not_present
>> -	l.addi	r3,r0,0xffffe3fa	// PAGE_MASK | DTLB_UP_CONVERT_MASK
>> +	l.addi	r4,r0,0xffffe3fa	// PAGE_MASK | DTLB_UP_CONVERT_MASK
>>   	/*
>>   	 * fill DTLB TR register
>>   	 */
>> -	l.and	r4,r2,r3		// apply the mask
>> +	l.and	r4,r3,r4		// apply the mask
>>   	// Determine number of DMMU sets
>> -	l.mfspr r6, r0, SPR_DMMUCFGR
>> -	l.andi	r6, r6, SPR_DMMUCFGR_NTS
>> -	l.srli	r6, r6, SPR_DMMUCFGR_NTS_OFF
>> +	l.mfspr r2, r0, SPR_DMMUCFGR
>> +	l.andi	r2, r2, SPR_DMMUCFGR_NTS
>> +	l.srli	r2, r2, SPR_DMMUCFGR_NTS_OFF
>>   	l.ori	r3, r0, 0x1
>> -	l.sll	r3, r3, r6 	// r3 = number DMMU sets DMMUCFGR
>> -	l.addi	r6, r3, -1  	// r6 = nsets mask
>> -	l.and	r5, r5, r6	// calc offset:	 & (NUM_TLB_ENTRIES-1)
>> +	l.sll	r3, r3, r2 	// r3 = number DMMU sets DMMUCFGR
>> +	l.addi	r2, r3, -1  	// r2 = nsets mask
>> +	l.mfspr	r3, r0, SPR_EEAR_BASE
>> +	l.srli	r3, r3, 0xd	// >> PAGE_SHIFT
>> +	l.and	r2, r3, r2	// calc offset:	 & (NUM_TLB_ENTRIES-1)
>>   	                                                   //NUM_TLB_ENTRIES
>> -	l.mtspr	r5,r4,SPR_DTLBTR_BASE(0)
>> +	l.mtspr	r2,r4,SPR_DTLBTR_BASE(0)
>>   	/*
>>   	 * fill DTLB MR register
>>   	 */
>> -	l.mfspr	r2,r0,SPR_EEAR_BASE
>> -	l.addi	r3,r0,0xffffe000	// PAGE_MASK
>> -	l.and	r4,r2,r3		// apply PAGE_MASK to EA (__PHX__ do we really need this?)
>> -	l.ori	r4,r4,0x1		// set hardware valid bit: DTBL_MR entry
>> -	l.mtspr	r5,r4,SPR_DTLBMR_BASE(0)
>> +	l.slli	r3, r3, 0xd		/* << PAGE_SHIFT => EA & PAGE_MASK */
>> +	l.ori	r4,r3,0x1		// set hardware valid bit: DTBL_MR entry
>> +	l.mtspr	r2,r4,SPR_DTLBMR_BASE(0)
>>
>>   	EXCEPTION_LOAD_GPR2
>>   	EXCEPTION_LOAD_GPR3
>>   	EXCEPTION_LOAD_GPR4
>> -	EXCEPTION_LOAD_GPR5
>> -	EXCEPTION_LOAD_GPR6
>> -	l.rfe
>> -d_pmd_bad:
>> -	l.nop	1
>> -	EXCEPTION_LOAD_GPR2
>> -	EXCEPTION_LOAD_GPR3
>> -	EXCEPTION_LOAD_GPR4
>> -	EXCEPTION_LOAD_GPR5
>> -	EXCEPTION_LOAD_GPR6
>>   	l.rfe
>>   d_pmd_none:
>>   d_pte_not_present:
>>   	EXCEPTION_LOAD_GPR2
>>   	EXCEPTION_LOAD_GPR3
>>   	EXCEPTION_LOAD_GPR4
>> -	EXCEPTION_LOAD_GPR5
>> -	EXCEPTION_LOAD_GPR6
>>   	EXCEPTION_HANDLE(_dtlb_miss_page_fault_handler)
>>
>>   /* ==============================================[ ITLB miss handler ]=== */
>> @@ -1077,8 +1054,6 @@ ENTRY(itlb_miss_handler)
>>   	EXCEPTION_STORE_GPR2
>>   	EXCEPTION_STORE_GPR3
>>   	EXCEPTION_STORE_GPR4
>> -	EXCEPTION_STORE_GPR5
>> -	EXCEPTION_STORE_GPR6
>>   	/*
>>   	 * get EA of the miss
>>   	 */
>> @@ -1088,30 +1063,19 @@ ENTRY(itlb_miss_handler)
>>   	 * pmd = (pmd_t *)(current_pgd + pgd_index(daddr));
>>   	 *
>>   	 */
>> -	GET_CURRENT_PGD(r3,r5)		// r3 is current_pgd, r5 is temp
>> +	GET_CURRENT_PGD(r3,r4)		// r3 is current_pgd, r5 is temp
>>   	l.srli	r4,r2,0x18		// >> PAGE_SHIFT + (PAGE_SHIFT - 2)
>>   	l.slli	r4,r4,0x2		// to get address << 2
>> -	l.add	r5,r4,r3		// r4 is pgd_index(daddr)
>> +	l.add	r3,r4,r3		// r4 is pgd_index(daddr)
>>   	/*
>>   	 * if (pmd_none(*pmd))
>>   	 *   goto pmd_none:
>>   	 */
>> -	tophys	(r4,r5)
>> +	tophys	(r4,r3)
>>   	l.lwz	r3,0x0(r4)		// get *pmd value
>>   	l.sfne	r3,r0
>>   	l.bnf	i_pmd_none
>> -	l.andi	r3,r3,0x1fff		// ~PAGE_MASK
>> -	/*
>> -	 * if (pmd_bad(*pmd))
>> -	 *   pmd_clear(pmd)
>> -	 *   goto pmd_bad:
>> -	 */
>> -
>> -//	l.sfeq	r3,r0			// check *pmd value
>> -//	l.bf	i_pmd_good
>> -	l.addi	r3,r0,0xffffe000	// PAGE_MASK
>> -//	l.j	i_pmd_bad
>> -//	l.sw	0x0(r4),r0		// clear pmd
>> +	 l.addi	r3,r0,0xffffe000	// PAGE_MASK
>>
>>   i_pmd_good:
>>   	/*
>> @@ -1120,35 +1084,36 @@ i_pmd_good:
>>   	 */
>>   	l.lwz	r4,0x0(r4)		// get **pmd value
>>   	l.and	r4,r4,r3		// & PAGE_MASK
>> -	l.srli	r5,r2,0xd		// >> PAGE_SHIFT, r2 == EEAR
>> -	l.andi	r3,r5,0x7ff		// (1UL << PAGE_SHIFT - 2) - 1
>> +	l.srli	r2,r2,0xd		// >> PAGE_SHIFT, r2 == EEAR
>> +	l.andi	r3,r2,0x7ff		// (1UL << PAGE_SHIFT - 2) - 1
>>   	l.slli	r3,r3,0x2		// to get address << 2
>>   	l.add	r3,r3,r4
>> -	l.lwz	r2,0x0(r3)		// this is pte at last
>> +	l.lwz	r3,0x0(r3)		// this is pte at last
>>   	/*
>>   	 * if (!pte_present(pte))
>>   	 *
>>   	 */
>> -	l.andi	r4,r2,0x1
>> +	l.andi	r4,r3,0x1
>>   	l.sfne	r4,r0			// is pte present
>>   	l.bnf	i_pte_not_present
>> -	l.addi	r3,r0,0xffffe03a	// PAGE_MASK | ITLB_UP_CONVERT_MASK
>> +	 l.addi	r4,r0,0xffffe03a	// PAGE_MASK | ITLB_UP_CONVERT_MASK
>>   	/*
>>   	 * fill ITLB TR register
>>   	 */
>> -	l.and	r4,r2,r3		// apply the mask
>> -	l.andi	r3,r2,0x7c0		// _PAGE_EXEC | _PAGE_SRE | _PAGE_SWE |  _PAGE_URE | _PAGE_UWE
>> -//	l.andi	r3,r2,0x400		// _PAGE_EXEC
>> +	l.and	r4,r3,r4		// apply the mask
>> +	l.andi	r3,r3,0x7c0		// _PAGE_EXEC | _PAGE_SRE | _PAGE_SWE |  _PAGE_URE | _PAGE_UWE
>>   	l.sfeq	r3,r0
>>   	l.bf	itlb_tr_fill //_workaround
>>   	// Determine number of IMMU sets
>> -	l.mfspr r6, r0, SPR_IMMUCFGR
>> -	l.andi	r6, r6, SPR_IMMUCFGR_NTS
>> -	l.srli	r6, r6, SPR_IMMUCFGR_NTS_OFF
>> +	l.mfspr r2, r0, SPR_IMMUCFGR
>> +	l.andi	r2, r2, SPR_IMMUCFGR_NTS
>> +	l.srli	r2, r2, SPR_IMMUCFGR_NTS_OFF
>>   	l.ori	r3, r0, 0x1
>> -	l.sll	r3, r3, r6 	// r3 = number IMMU sets IMMUCFGR
>> -	l.addi	r6, r3, -1  	// r6 = nsets mask
>> -	l.and	r5, r5, r6	// calc offset:	 & (NUM_TLB_ENTRIES-1)
>> +	l.sll	r3, r3, r2 	// r3 = number IMMU sets IMMUCFGR
>> +	l.addi	r2, r3, -1  	// r2 = nsets mask
>> +	l.mfspr	r3, r0, SPR_EEAR_BASE
>> +	l.srli	r3, r3, 0xd	// >> PAGE_SHIFT
>> +	l.and	r2, r3, r2	// calc offset:	 & (NUM_TLB_ENTRIES-1)
>>
>>   /*
>>    * __PHX__ :: fixme
>> @@ -1160,38 +1125,24 @@ i_pmd_good:
>>   itlb_tr_fill_workaround:
>>   	l.ori	r4,r4,0xc0		// | (SPR_ITLBTR_UXE | ITLBTR_SXE)
>>   itlb_tr_fill:
>> -	l.mtspr	r5,r4,SPR_ITLBTR_BASE(0)
>> +	l.mtspr	r2,r4,SPR_ITLBTR_BASE(0)
>>   	/*
>>   	 * fill DTLB MR register
>>   	 */
>> -	l.mfspr	r2,r0,SPR_EEAR_BASE
>> -	l.addi	r3,r0,0xffffe000	// PAGE_MASK
>> -	l.and	r4,r2,r3		// apply PAGE_MASK to EA (__PHX__ do we really need this?)
>> -	l.ori	r4,r4,0x1		// set hardware valid bit: DTBL_MR entry
>> -	l.mtspr	r5,r4,SPR_ITLBMR_BASE(0)
>> +	l.slli	r3, r3, 0xd		/* << PAGE_SHIFT => EA & PAGE_MASK */
>> +	l.ori	r4,r3,0x1		// set hardware valid bit: ITBL_MR entry
>> +	l.mtspr	r2,r4,SPR_ITLBMR_BASE(0)
>>
>>   	EXCEPTION_LOAD_GPR2
>>   	EXCEPTION_LOAD_GPR3
>>   	EXCEPTION_LOAD_GPR4
>> -	EXCEPTION_LOAD_GPR5
>> -	EXCEPTION_LOAD_GPR6
>>   	l.rfe
>>
>> -i_pmd_bad:
>> -	l.nop	1
>> -	EXCEPTION_LOAD_GPR2
>> -	EXCEPTION_LOAD_GPR3
>> -	EXCEPTION_LOAD_GPR4
>> -	EXCEPTION_LOAD_GPR5
>> -	EXCEPTION_LOAD_GPR6
>> -	l.rfe
>>   i_pmd_none:
>>   i_pte_not_present:
>>   	EXCEPTION_LOAD_GPR2
>>   	EXCEPTION_LOAD_GPR3
>>   	EXCEPTION_LOAD_GPR4
>> -	EXCEPTION_LOAD_GPR5
>> -	EXCEPTION_LOAD_GPR6
>>   	EXCEPTION_HANDLE(_itlb_miss_page_fault_handler)
>>
>>   /* ==============================================[ boot tlb handlers ]=== */
>> --
>> 1.8.1.2
>>
