Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbbAFHHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 02:07:31 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:14094 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbbAFHH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 02:07:29 -0500
Message-ID: <54AB89AF.4010200@c-s.fr>
Date: Tue, 06 Jan 2015 08:07:27 +0100
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
CC: "scottwood@freescale.com" <scottwood@freescale.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 09/11] powerpc/8xx: dont save CR in SCRATCH registers
References: <20141216150340.108641A5E05@localhost.localdomain> <1420482624.25047.25.camel@transmode.se>
In-Reply-To: <1420482624.25047.25.camel@transmode.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 05/01/2015 19:30, Joakim Tjernlund a écrit :
> On Tue, 2014-12-16 at 16:03 +0100, Christophe Leroy wrote:
>> CR only needs to be preserved when checking if we are handling a kernel address.
>> So we can preserve CR in a register:
>> - In ITLBMiss, check is done only when CONFIG_MODULES is defined. Otherwise we
>> don't need to do anything at all with CR.
>> - If CONFIG_8xx_CPU6 is defined, we have r3 available for saving CR
>> - Otherwise, we use r10, then we reload SRR0/MD_EPN into r10 when CR is restored
> I think the #ifdef CPU6 code makes for too much maintenance. Can you
> loose the #ifdef CPU6 and adjust code so it works for both cases?
I wanted to take the opportunity to save one cycle, but we are wasting 
so many cycles with CPU6 that it is propably not worth it.
Ok, I will remove the special handling for CPU6.

>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>
>> ---
>>   arch/powerpc/kernel/head_8xx.S | 53 +++++++++++++++++++++++++++++-------------
>>   1 file changed, 37 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
>> index c89aed9..a073918 100644
>> --- a/arch/powerpc/kernel/head_8xx.S
>> +++ b/arch/powerpc/kernel/head_8xx.S
>> @@ -308,14 +308,10 @@ SystemCall:
>>   #endif
>>   
>>   InstructionTLBMiss:
>> +       EXCEPTION_PROLOG_0
>>   #ifdef CONFIG_8xx_CPU6
>>          mtspr   SPRN_DAR, r3
>>   #endif
>> -       EXCEPTION_PROLOG_0
>> -       mfcr    r10
>> -       mtspr   SPRN_SPRG_SCRATCH2, r10
>> -       mfspr   r10, SPRN_SRR0/* Get effective address of fault */
>> -       DO_8xx_CPU15(r11, r10)
>>   
>>          /* If we are faulting a kernel address, we have to use the
>>                  * kernel page tables.
>> @@ -323,14 +319,33 @@ InstructionTLBMiss:
>>   #ifdef CONFIG_MODULES
>>          /* Only modules will cause ITLB Misses as we always
>>                  * pin the first 8MB of kernel memory */
>> +#ifdef CONFIG_8xx_CPU6
>> +       mfspr   r10, SPRN_SRR0/* Get effective address of fault */
>> +       DO_8xx_CPU15(r11, r10)
>> +       mfcr    r3
>>          andis.  r11, r10, 0x8000/* Address >= 0x80000000 */
>> +#else
>> +       mfspr   r11, SPRN_SRR0/* Get effective address of fault */
>> +       DO_8xx_CPU15(r10, r11)
>> +       mfcr    r10
>> +       andis.  r11, r11, 0x8000/* Address >= 0x80000000 */
>>   #endif
>>          mfspr   r11, SPRN_M_TW/* Get level 1 table base address */
>> -#ifdef CONFIG_MODULES
>>          beq     3f
>>          lis     r11, (swapper_pg_dir-PAGE_OFFSET)@ha
>>   3:
>> +#ifdef CONFIG_8xx_CPU6
>> +       mtcr    r3
>> +#else
>> +       mtcr    r10
>> +       mfspr   r10, SPRN_SRR0/* Get effective address of fault */
>>   #endif
>> +#else /* CONFIG_MODULES */
>> +       mfspr   r10, SPRN_SRR0/* Get effective address of fault */
>> +       DO_8xx_CPU15(r11, r10)
>> +       mfspr   r11, SPRN_M_TW/* Get level 1 table base address */
>> +#endif /* CONFIG_MODULES */
>> +
>>          /* Insert level 1 index */
>>          rlwimi  r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
>>          lwz     r11, (swapper_pg_dir-PAGE_OFFSET)@l(r11)/* Get the level 1 entry */
>> @@ -362,29 +377,37 @@ InstructionTLBMiss:
>>          mfspr   r3, SPRN_DAR
>>          mtspr   SPRN_DAR, r11/* Tag DAR */
>>   #endif
>> -       mfspr   r10, SPRN_SPRG_SCRATCH2
>> -       mtcr    r10
>>          EXCEPTION_EPILOG_0
>>          rfi
>>   
>>          . = 0x1200
>>   DataStoreTLBMiss:
>> -#ifdef CONFIG_8xx_CPU6
>> -       mtspr   SPRN_DAR, r3
>> -#endif
>>          EXCEPTION_PROLOG_0
>> -       mfcr    r10
>> -       mtspr   SPRN_SPRG_SCRATCH2, r10
>> -       mfspr   r10, SPRN_MD_EPN
>>   
>>          /* If we are faulting a kernel address, we have to use the
>>                  * kernel page tables.
>>                  */
>> +#ifdef CONFIG_8xx_CPU6
>> +       mtspr   SPRN_DAR, r3
>> +       mfcr    r3
>> +       mfspr   r10, SPRN_MD_EPN
>>          andis.  r11, r10, 0x8000
>> +#else
>> +       mfcr    r10
>> +       mfspr   r11, SPRN_MD_EPN
>> +       andis.  r11, r11, 0x8000
>> +#endif
>>          mfspr   r11, SPRN_M_TW/* Get level 1 table base address */
>>          beq     3f
>>          lis     r11, (swapper_pg_dir-PAGE_OFFSET)@ha
>>   3:
>> +#ifdef CONFIG_8xx_CPU6
>> +       mtcr    r3
>> +#else
>> +       mtcr    r10
>> +       mfspr   r10, SPRN_MD_EPN
>> +#endif
>> +
>>          /* Insert level 1 index */
>>          rlwimi  r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
>>          lwz     r11, (swapper_pg_dir-PAGE_OFFSET)@l(r11)/* Get the level 1 entry */
>> @@ -441,8 +464,6 @@ DataStoreTLBMiss:
>>          mfspr   r3, SPRN_DAR
>>   #endif
>>          mtspr   SPRN_DAR, r11/* Tag DAR */
>> -       mfspr   r10, SPRN_SPRG_SCRATCH2
>> -       mtcr    r10
>>          EXCEPTION_EPILOG_0
>>          rfi
>>   

