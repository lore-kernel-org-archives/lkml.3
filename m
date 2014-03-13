Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaCMNlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:41:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46355 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaCMNlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:41:04 -0400
Message-ID: <5321B56D.1030004@codeaurora.org>
Date: Thu, 13 Mar 2014 09:41:01 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] arm64: Fix __addr_ok and __range_ok macros
References: <1394059289-3972-1-git-send-email-cov@codeaurora.org> <20140313112019.GD30339@arm.com>
In-Reply-To: <20140313112019.GD30339@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin, Will,

Thanks for your feedback. I must admit I'm out of my depth here, so I just
posted what I had, hoping to solicit comments like what you all have kindly
provided.

On 03/13/2014 07:20 AM, Catalin Marinas wrote:
> On Wed, Mar 05, 2014 at 10:41:28PM +0000, Christopher Covington wrote:
>> --- a/arch/arm64/include/asm/uaccess.h
>> +++ b/arch/arm64/include/asm/uaccess.h
>> @@ -66,12 +66,12 @@ static inline void set_fs(mm_segment_t fs)
>>  #define segment_eq(a,b)	((a) == (b))
>>  
>>  /*
>> - * Return 1 if addr < current->addr_limit, 0 otherwise.
>> + * Return 1 if addr <= current->addr_limit, 0 otherwise.
>>   */
>>  #define __addr_ok(addr)							\
>>  ({									\
>>  	unsigned long flag;						\
>> -	asm("cmp %1, %0; cset %0, lo"					\
>> +	asm("cmp %1, %0; cset %0, ls"					\
>>  		: "=&r" (flag)						\
>>  		: "r" (addr), "0" (current_thread_info()->addr_limit)	\
>>  		: "cc");						\
> 
> As Will said, this doesn't look right. Why do you need TASK_SIZE_64 to
> be valid?

I didn't encounter a case where this was necessary. I was just wondering if a
change was needed for one macro, might it be needed for another? I'm now
convinced that the answer is no.

>> @@ -83,7 +83,7 @@ static inline void set_fs(mm_segment_t fs)
>>   * Returns 1 if the range is valid, 0 otherwise.
>>   *
>>   * This is equivalent to the following test:
>> - * (u65)addr + (u65)size < (u65)current->addr_limit
>> + * (u65)addr + (u65)size <= current->addr_limit
>>   *
>>   * This needs 65-bit arithmetic.
>>   */
>> @@ -91,7 +91,7 @@ static inline void set_fs(mm_segment_t fs)
>>  ({									\
>>  	unsigned long flag, roksum;					\
>>  	__chk_user_ptr(addr);						\
>> -	asm("adds %1, %1, %3; ccmp %1, %4, #2, cc; cset %0, cc"		\
>> +	asm("adds %1, %1, %3; ccmp %1, %4, #3, cc; cset %0, ls"		\
>>  		: "=&r" (flag), "=&r" (roksum)				\
>>  		: "1" (addr), "Ir" (size),				\
>>  		  "r" (current_thread_info()->addr_limit)		\
> 
> Just trying to understand: if adds does not set the C flag, we go on and
> do the ccmp. If addr + size <= addr_limit, "cset ls" sets the flag
> variable. If addr + size actually sets the C flag, we need to make sure
> that "cset ls" doesn't trigger, which would mean to set C flag and clear
> Z flag. So why do you change the ccmp flags from #2 to #3? It looks to
> me like #2 is enough.

#2 is indeed sufficient. I'll respin using it.

I think Will's suggested approach could also work but I figure since I've
taken the time to understand the assembly I might as well fix the problem
there rather than adding another step in the calculation for developers and
compilers to parse. (I don't know if this code is performance critical, but I
nevertheless wanted to see how the compiler handled Will's approach.
Unfortunately my initial implementation resulted in unaligned opcode errors
and I haven't yet dug in.)

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
