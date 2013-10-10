Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab3JJLDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:03:38 -0400
Received: from intranet.asianux.com ([58.214.24.6]:49045 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab3JJLDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:03:36 -0400
X-Spam-Score: -100.8
Message-ID: <52568949.7070603@asianux.com>
Date: Thu, 10 Oct 2013 19:02:33 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] arm: include: asm: atomic.h: use 'unsigned int' and
 'atomic' instead of 'unsigned long' for atomic_clear_mask()
References: <52561137.3070608@asianux.com> <5256117A.4000009@asianux.com> <5256121A.9030504@asianux.com> <20131010095841.GG3817@mudshark.cambridge.arm.com>
In-Reply-To: <20131010095841.GG3817@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 05:58 PM, Will Deacon wrote:
> On Thu, Oct 10, 2013 at 03:34:02AM +0100, Chen Gang wrote:
>> In current kernel wide source, for arm, only s390 scsi drivers use
>> atomic_clear_mask(), now, s390 itself need use 'unsigned int' and
>> 'atomic_t', so need match s390's atomic_clear_mask().
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  arch/arm/include/asm/atomic.h |   13 +++++++------
>>  1 files changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
>> index da1c77d..0832a7f 100644
>> --- a/arch/arm/include/asm/atomic.h
>> +++ b/arch/arm/include/asm/atomic.h
>> @@ -134,9 +134,10 @@ static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
>>  	return oldval;
>>  }
>>  
>> -static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
>> +static inline void atomic_clear_mask(unsigned int mask, atomic_t *ptr)
>>  {
>> -	unsigned long tmp, tmp2;
>> +	unsigned int tmp;
> 
> I reckon this should be int (the mask parameter is unsigned, but
> atomic_t.counter is signed).

For 'ldrex' and 'strex' (loading/storing instruction), it is really
better to match 'atomic_t.counter', but for 'bic' (operating
instruction), it is better to match 'mask'.

In my opinion, for signed/unsigned, 'operating' has higher priority than
'loading/storing' (especially for *mask functions, by default, suggest
using unsigned).

Commonly, for loading/storing (e.g. 'ldrex', 'strex'), must be sure of
bits wide (signed/unsigned will not cause real issues), but for
operating, signed/unsigned may cause real issues.


> 
>> +	unsigned long tmp2;
>>  
>>  	__asm__ __volatile__("@ atomic_clear_mask\n"
>>  "1:	ldrex	%0, [%3]\n"
>> @@ -144,8 +145,8 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
>>  "	strex	%1, %0, [%3]\n"
>>  "	teq	%1, #0\n"
>>  "	bne	1b"
>> -	: "=&r" (tmp), "=&r" (tmp2), "+Qo" (*addr)
>> -	: "r" (addr), "Ir" (mask)
>> +	: "=&r" (tmp), "=&r" (tmp2), "+Qo" (ptr->counter)
>> +	: "r" (&ptr->counter), "Ir" (mask)
>>  	: "cc");
>>  }
>>  
>> @@ -197,12 +198,12 @@ static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
>>  	return ret;
>>  }
>>  
>> -static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
>> +static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
>>  {
>>  	unsigned long flags;
>>  
>>  	raw_local_irq_save(flags);
>> -	*addr &= ~mask;
>> +	v->counter &= ~mask;
>>  	raw_local_irq_restore(flags);
>>  }
> 
> This is now identical to asm-generic/atomic.h. I wonder whether we could
> just #include that file for the ARMv6 case? You'd need to check the
> differences carefully.
> 

If most of functions for ARMv6 case can use "asm-generic/atomic.h", your
idea sounds good to me, although we don't need 'atomic_set_mask' (it is
inconsistent with 'atomic_clear_mask' in "asm-generic/atomic.h").

> Finally, I still question the need for the clear_mask function anyway. We
> don't implement set_mask, and these functions are only used by either other
> arch code or in drivers that don't work on ARM anyway.
> 

Hmm... can we remove atomic_*_mask() for both arm and arm64?

It seems before get a conclusion, it is necessary to let arm and arm64
pass 'allmodconfig' firstly (and then try to remove these functions to
see the compiling result).

I will/should try 'allmodconfig' for them, but excuse me, it needs
waiting (I am just trying 'arc' architecture with 'allmodconfig', and
already delayed, because I have no enough time resources on it :-( ).

> Will
> 
> 

Thanks.
-- 
Chen Gang
