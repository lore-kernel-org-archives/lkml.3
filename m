Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab3IMFEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 01:04:37 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:26079 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab3IMFEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 01:04:36 -0400
Message-ID: <52329CDF.9020103@c-s.fr>
Date: Fri, 13 Sep 2013 07:04:31 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: Re: [PATCH v2] powerpc 8xx: Fixing issue with CONFIG_PIN_TLB
References: <201309121825.r8CIPrkI005690@localhost.localdomain> <1379011469.2536.45.camel@snotra.buserror.net>
In-Reply-To: <1379011469.2536.45.camel@snotra.buserror.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12/09/2013 20:44, Scott Wood a écrit :
> On Thu, 2013-09-12 at 20:25 +0200, Christophe Leroy wrote:
>> This is a reorganisation of the setup of the TLB at kernel startup, in order
>> to handle the CONFIG_PIN_TLB case in accordance with chapter 8.10.3 of MPC866
>> and MPC885 reference manuals.
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>
>> diff -ur linux-3.11.org/arch/powerpc/kernel/head_8xx.S linux-3.11/arch/powerpc/kernel/head_8xx.S
>> --- linux-3.11.org/arch/powerpc/kernel/head_8xx.S	2013-09-02 22:46:10.000000000 +0200
>> +++ linux-3.11/arch/powerpc/kernel/head_8xx.S	2013-09-09 11:28:54.000000000 +0200
>> @@ -785,27 +785,24 @@
>>    * these mappings is mapped by page tables.
>>    */
>>   initial_mmu:
>> -	tlbia			/* Invalidate all TLB entries */
>> -/* Always pin the first 8 MB ITLB to prevent ITLB
>> -   misses while mucking around with SRR0/SRR1 in asm
>> -*/
>> -	lis	r8, MI_RSV4I@h
>> -	ori	r8, r8, 0x1c00
>> -
>> +	lis	r8, MI_RESETVAL@h
>>   	mtspr	SPRN_MI_CTR, r8	/* Set instruction MMU control */
>>   
>> -#ifdef CONFIG_PIN_TLB
>> -	lis	r10, (MD_RSV4I | MD_RESETVAL)@h
>> -	ori	r10, r10, 0x1c00
>> -	mr	r8, r10
>> -#else
>>   	lis	r10, MD_RESETVAL@h
>> -#endif
>>   #ifndef CONFIG_8xx_COPYBACK
>>   	oris	r10, r10, MD_WTDEF@h
>>   #endif
>>   	mtspr	SPRN_MD_CTR, r10	/* Set data TLB control */
>>   
>> +	tlbia			/* Invalidate all TLB entries */
> Is this change to make sure we invalidate everything even if the
> bootloader set RSV4I?
Most probably. It is step 2 of the process defined in MPC866 and MPC885 
Reference Manuals:

§8.10.3 Loading Locked TLB Entries:
The process of loading a single reserved entry in the TLB is as follows:
1. Disable the TLB by clearing MSR[IR] or MSR[DR] as needed.
2. Clear MI_CTR[RSV4I] (MD_CTR[RSV4D]).
3. Invalidate the EA of the reserved page by using tlbia or tlbie.
4. Set MI_CTR[ITLB_INDX] (MD_CTR[DTLB_INDX]) to the appropriate value 
(between 27 and 31).
5. Load Mx_EPN with the effective page number, the ASID of the reserved 
page, and set EV.
6. Run software tablewalk code to load the appropriate entry into the 
translation lookaside buffer. See Section 8.10.1.1, “Translation Reload 
Examples.”
7. Repeat steps 4–6 to load other TLB entries.
8. Set MI_CTR[RSV4I] (MD_CTR[RSV4D])
>
>> +	ori	r8, r8, 0x1c00
>> +	mtspr	SPRN_MI_CTR, r8	/* Set instruction MMU control */
>> +#ifdef CONFIG_PIN_TLB
>> +	ori	r10, r10, 0x1c00
>> +	mtspr	SPRN_MD_CTR, r10	/* Set data TLB control */
>> +#endif
> Still 0x1c00?
Yes, I kept the same entries in order to limit modifications:
* 28 = First 8Mbytes page
* 29 = IMMR
* 30 = Second 8Mbytes page
* 31 = Third 8Mbytes page
>
>>   	/* Now map the lower 8 Meg into the TLBs.  For this quick hack,
>>   	 * we can load the instruction and data TLB registers with the
>>   	 * same values.
>> @@ -825,6 +822,12 @@
>>   	mtspr	SPRN_MI_AP, r8
>>   	mtspr	SPRN_MD_AP, r8
>>   
>> +	/* Always pin the first 8 MB ITLB to prevent ITLB
>> +	 * misses while mucking around with SRR0/SRR1 in asm
>> +	 */
>> +	lis	r8, (MI_RSV4I | MI_RESETVAL)@h
>> +	mtspr	SPRN_MI_CTR, r8	/* Set instruction MMU control */
> Entry 0 is not pinnable.
Here we are not trying to pin entry 0. We are at step 8, we are setting 
MI_RSV4I. At the same time, we set MD_CTR to 0 which is off the pinned 
range, to be sure that we won't overwrite one of the pinned entries.

The main difference compared to the previous implementation is that 
before, we were setting the RSV4I bit before loading the TLB entries. 
Now, as defined in the Reference Manuals, we are doing it at the end.

Christophe
