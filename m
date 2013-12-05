Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3LEPP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:15:28 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:37990 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3LEPPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:15:25 -0500
MIME-Version: 1.0
In-Reply-To: <20131205135928.GA4096@e103592.cambridge.arm.com>
References: <1386242785-5146-1-git-send-email-a.anurag@samsung.com>
	<20131205135928.GA4096@e103592.cambridge.arm.com>
Date: Thu, 5 Dec 2013 20:45:22 +0530
Message-ID: <CAPoNrtuzV=eOWP44om+E6m0NSx+xfFtg-STjPLMBO4OUBF84kQ@mail.gmail.com>
Subject: Re: [PATCH V4] ARM : unwinder : Prevent data abort due to stack overflow
From: Anurag Aggarwal <anurag19aggarwal@gmail.com>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Anurag Aggarwal <a.anurag@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "cpgs@samsung.com" <cpgs@samsung.com>,
        "narendra.m1@samsung.com" <narendra.m1@samsung.com>,
        "poorva.s@samsung.com" <poorva.s@samsung.com>,
        "naveen.sel@samsung.com" <naveen.sel@samsung.com>,
        "ashish.kalra@samsung.com" <ashish.kalra@samsung.com>,
        "mohammad.a2@samsung.com" <mohammad.a2@samsung.com>,
        "rajat.suri@samsung.com" <rajat.suri@samsung.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>if (unlikely(check) &&
>>    *vsp >= (unsigned long *)ctrl->sp_high))

Good idea, It can help in optimizing the code and will leave code more readable
and it will be easy to maintain also.

>>Does the code check anywhere that SP is word-aligned?
>>
>>That should probably be checked if it's not done already.

I think this should be handled in separate patch
I would also like to hear more your ideas for the file

Regards
Anurag

On Thu, Dec 5, 2013 at 7:29 PM, Dave Martin <Dave.Martin@arm.com> wrote:
> On Thu, Dec 05, 2013 at 11:26:25AM +0000, Anurag Aggarwal wrote:
>> While unwinding backtrace, stack overflow is possible. This stack
>> overflow can sometimes lead to data abort in system if the area after
>> stack is not mapped to physical memory.
>>
>> To prevent this problem from happening, execute the instructions that
>> can cause a data abort in separate helper functions, where a check for
>> feasibility is made before reading each word from the stack.
>>
>> Signed-off-by: Anurag Aggarwal <a.anurag@samsung.com>
>> ---
>>  arch/arm/kernel/unwind.c |  127 ++++++++++++++++++++++++++++++++-------------
>>  1 files changed, 90 insertions(+), 37 deletions(-)
>>
>> diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
>> index 00df012..94f6ef4 100644
>> --- a/arch/arm/kernel/unwind.c
>> +++ b/arch/arm/kernel/unwind.c
>> @@ -68,6 +68,7 @@ EXPORT_SYMBOL(__aeabi_unwind_cpp_pr2);
>>  struct unwind_ctrl_block {
>>       unsigned long vrs[16];          /* virtual register set */
>>       const unsigned long *insn;      /* pointer to the current instructions word */
>> +     unsigned long sp_high;          /* highest value of sp allowed*/
>>       int entries;                    /* number of entries left to interpret */
>>       int byte;                       /* current byte number in the instructions word */
>>  };
>> @@ -235,6 +236,86 @@ static unsigned long unwind_get_byte(struct unwind_ctrl_block *ctrl)
>>       return ret;
>>  }
>>
>> +/* Before poping a register check whether it is feasible or not */
>> +static int unwind_pop_register(struct unwind_ctrl_block *ctrl,
>> +                             unsigned long **vsp, unsigned int reg)
>> +{
>> +     if (*vsp >= (unsigned long *)ctrl->sp_high)
>> +             return -URC_FAILURE;
>> +
>> +     ctrl->vrs[reg] = *(*vsp)++;
>> +     return URC_OK;
>
> It occurred to me that your optimisation can still be implemented on
> top on this.
>
> If you add an extra flag parameter to unwind_pop_register telling it
> whether to do checking or not, I think that the compiler and/or
> CPU branch predictor should be able to do a pretty good job of
> optimising the common case.  Until we get near sp_high, if(check) will
> branch the same way every time.
>
> if (unlikely(check) &&
>     *vsp >= (unsigned long *)ctrl->sp_high))
>
> would make sense, in fact.
>
>
> I think this brings most of the benefit, without needing to code the
> insn exec rules twice.
>
> I'm still not sure the optimisation benefits us much, but I think
> that would be a tidier way of doing it if you want to try.
>
>> +}
>> +
>> +/* Helper functions to execute the instructions */
>> +static int unwind_exec_pop_subset_r4_to_r13(struct unwind_ctrl_block *ctrl,
>> +                                             unsigned long mask)
>> +{
>> +     unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
>> +     int load_sp, reg = 4;
>> +
>> +     load_sp = mask & (1 << (13 - 4));
>> +     while (mask) {
>> +             if (mask & 1)
>> +                     if (unwind_pop_register(ctrl, &vsp, reg))
>> +                             return -URC_FAILURE;
>> +             mask >>= 1;
>> +             reg++;
>> +     }
>> +     if (!load_sp)
>> +             ctrl->vrs[SP] = (unsigned long)vsp;
>> +
>> +     pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
>> +             ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
>
> Minor-ish nit: you now duplicate this same pr_debug() in many places.
> Apologies, I didn't spot that in the previous review.
>
> What about something like this:
>
> static int unwind_exec_insn(...)
> {
>         int ret = URC_OK;
>
>         } else if (...)
>                 ret = unwind_exec_pop_subset_r4_to_r13(...);
>                 if (ret)
>                         goto error;
>         else ...
>
>         pr_debug(...);
>
> error:
>         return ret;
> }
>
> Then everything returns through the same pr_debug() after the insn has
> been executed.
>
> [...]
>
>> @@ -329,13 +382,13 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
>>   */
>>  int unwind_frame(struct stackframe *frame)
>>  {
>> -     unsigned long high, low;
>> +     unsigned long low;
>>       const struct unwind_idx *idx;
>>       struct unwind_ctrl_block ctrl;
>>
>> -     /* only go to a higher address on the stack */
>> +     /* store the highest address on the stack to avoid crossing it*/
>>       low = frame->sp;
>> -     high = ALIGN(low, THREAD_SIZE);
>> +     ctrl.sp_high = ALIGN(low, THREAD_SIZE);
>
> Does the code check anywhere that SP is word-aligned?
>
> That should probably be checked if it's not done already.
>
> I have some unrelated changes I want to make in this file (which is
> part of why I'm being pushy about getting things nice and clean) ... so
> I'm happy to follow up with that as a separate patch later.  It's a
> separate issue, really.  It doesn't necessarily belong in this patch.
>
> Cheers
> ---Dave



-- 
Anurag Aggarwal
