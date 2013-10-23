Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3JWJ0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:26:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:61687 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3JWJ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:26:32 -0400
Message-ID: <5267963A.7010406@windriver.com>
Date: Wed, 23 Oct 2013 17:26:18 +0800
From: =?UTF-8?B?IuKAnHRpZWp1bi5jaGVu4oCdIg==?= 
	<tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [v5][PATCH 1/6] powerpc/book3e: load critical/machine/debug exception
 stack
References: <1371724110-8250-1-git-send-email-tiejun.chen@windriver.com>	 <1371724110-8250-2-git-send-email-tiejun.chen@windriver.com> <1382135824.7979.906.camel@snotra.buserror.net>
In-Reply-To: <1382135824.7979.906.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.185]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2013 06:37 AM, Scott Wood wrote:
> On Thu, 2013-06-20 at 18:28 +0800, Tiejun Chen wrote:
>> We always alloc critical/machine/debug check exceptions. This is
>> different from the normal exception. So we should load these exception
>> stack properly like we did for booke.
>
> This is "booke".  Do you mean like "like we did for 32-bit"?

Yes.

>
> And the code is already trying to load the special stack; it just
> happens that it's loading from a different location than the C code
> placed the stack addresses.  The changelog should point out the specific
> thing that is being fixed.

Here I don't fix anything, and I just want to do the same thing as 32-bit.

>
>> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
>> ---
>>   arch/powerpc/kernel/exceptions-64e.S |   49 +++++++++++++++++++++++++++++++---
>>   1 file changed, 46 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
>> index 4b23119..4d8e57f 100644
>> --- a/arch/powerpc/kernel/exceptions-64e.S
>> +++ b/arch/powerpc/kernel/exceptions-64e.S
>> @@ -36,6 +36,37 @@
>>    */
>>   #define	SPECIAL_EXC_FRAME_SIZE	INT_FRAME_SIZE
>>
>> +/* only on book3e */
>> +#define DBG_STACK_BASE		dbgirq_ctx
>> +#define MC_STACK_BASE		mcheckirq_ctx
>> +#define CRIT_STACK_BASE		critirq_ctx
>> +
>> +#ifdef CONFIG_RELOCATABLE
>> +#define LOAD_STACK_BASE(reg, level)			\
>> +	tovirt(r2,r2);					\
>> +	LOAD_REG_ADDR(reg, level##_STACK_BASE);
>> +#else
>> +#define LOAD_STACK_BASE(reg, level)			\
>> +	LOAD_REG_IMMEDIATE(reg, level##_STACK_BASE);
>> +#endif
>> +
>> +#ifdef CONFIG_SMP
>> +#define BOOK3E_LOAD_EXC_LEVEL_STACK(level)		\
>> +	mfspr	r14,SPRN_PIR;				\
>> +	slwi	r14,r14,3;				\
>> +	LOAD_STACK_BASE(r10, level);			\
>> +	add	r10,r10,r14;				\
>> +	ld	r10,0(r10);				\
>> +	addi	r10,r10,THREAD_SIZE;			\
>> +	std	r10,PACA_##level##_STACK(r13);
>> +#else
>> +#define BOOK3E_LOAD_EXC_LEVEL_STACK(level)		\
>> +	LOAD_STACK_BASE(r10, level);			\
>> +	ld	r10,0(r10);				\
>> +	addi	r10,r10,THREAD_SIZE;			\
>> +	std	r10,PACA_##level##_STACK(r13);
>> +#endif
>
> It looks like you're loading the stack from *irq_ctx, storing it in
> PACA_*_stack, and then (immediately after this in the caller) loading it
> back from PACA_*_STACK.  Why not just load it from *irq_ctx and get rid
> of PACA_*_STACK altogether -- or change the C code to initialize the
> addresses in the PACA instead, and get ird of *irq_ctx on 64-bit?

Okay, I'd like to move forward the c code, please see next version.

>
>>   /* Exception prolog code for all exceptions */
>>   #define EXCEPTION_PROLOG(n, intnum, type, addition)	    		    \
>>   	mtspr	SPRN_SPRG_##type##_SCRATCH,r13;	/* get spare registers */   \
>> @@ -68,20 +99,32 @@
>>   #define SPRN_GDBELL_SRR1	SPRN_GSRR1
>>
>>   #define CRIT_SET_KSTACK						            \
>> +	andi.	r10,r11,MSR_PR;							\
>> +	bne	1f;								\
>> +	BOOK3E_LOAD_EXC_LEVEL_STACK(CRIT);					\
>>   	ld	r1,PACA_CRIT_STACK(r13);				    \
>> -	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;
>> +	subi	r1,r1,SPECIAL_EXC_FRAME_SIZE;					\
>
> The caller will already check MSR_PR and override this if coming from
> userspace; why do you need to check again here?

Looks this is redundant so this will be left out.

Thanks,

Tiejun
