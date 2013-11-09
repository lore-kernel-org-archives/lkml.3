Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab3KIG7E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:59:04 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:52113 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab3KIG67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:58:59 -0500
MIME-Version: 1.0
In-Reply-To: <20131108132119.GB2602@localhost.localdomain>
References: <1383731448-847-1-git-send-email-a.anurag@samsung.com>
	<20131108132119.GB2602@localhost.localdomain>
Date: Sat, 9 Nov 2013 12:28:57 +0530
Message-ID: <CAPoNrtuuHOB5d+vo-wGJ=5JQG=K0ZdaAv2Nyfxnit=WAWzXegg@mail.gmail.com>
Subject: Re: [PATCH] ARM: unwinder: Handle Stackoverflow in unwind_exec_insn
From: Anurag Aggarwal <anurag19aggarwal@gmail.com>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Anurag Aggarwal <a.anurag@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        naveen.sel@samsung.com,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        narendra.m1@samsung.com, nico@linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpgs@samsung.com, naveenkrishna.ch@gmail.com, rajat.suri@samsung.com,
        mohammad.a2@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your input Dave,

I think there is another way to avoid the stack overflow and reduce
the number of checks also,

Stack overflow will cause a problem only when we are backtracking the
last set of registers.
i.e when the difference between current SP and top of stack is less
than or equal to number of registers

we can create two unwind_exec_insn, one without checks and one with checks.

then we call the correct function from unwind_frame depending on the
difference of SP and top of stack.

This will reduce the amount of checks every time we read a set of
registers from stack

Regards
Anurag

On Fri, Nov 8, 2013 at 6:51 PM, Dave Martin <Dave.Martin@arm.com> wrote:
> On Wed, Nov 06, 2013 at 03:20:48PM +0530, Anurag Aggarwal wrote:
>> Altough stack overflow is expected in unwind_exec_insn, but in cases when area beyond stack is not mapped to physical memory this can cause data abort.
>>
>> To avoid above condition handle stack overflow in unwind_exec_insn by checking vsp pointer from top of stack
>
> This looks worthwhile, but this patch duplicates the same check in
> many places, making the code harder to read and maintain than
> necessary.  It would be a good opportunity for a bit of refactoring,
> since we've already tried to fix these backtrace overrun issues
> at least once in the past (not 100% successfully ...)
>
>
> Really, there is a single common check needed: every time we want to
> read a word from the stack, we need to check that word is within
> the proper stack bounds before doing the read.
>
>
> At the start of the backtrace, we should determine the thread stack
> bounds for the thread.  Those bounds should be fixed for the whole
> backtrace; it makes sense to store them in the unwind_ctrl_block
> structure, so that called functions can see them.
>
> Then a helper can be written that does the correct bounds check and
> reads a word from the stack, using the current frame's base virtual
> SP and the thread stack bounds.
>
> Then we just need to use that helper whenever we want to read a
> word from the stack.
>
> Cheers
> ---Dave
>
>
>> Signed-off-by: Anurag Aggarwal <a.anurag@samsung.com>
>> ---
>>  arch/arm/kernel/unwind.c | 23 +++++++++++++++--------
>>  1 files changed, 15 insertions(+), 8 deletions(-)
>> diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
>> index 00df012..d8b8721 100644
>> --- a/arch/arm/kernel/unwind.c
>> +++ b/arch/arm/kernel/unwind.c
>> @@ -241,6 +241,10 @@ static unsigned long unwind_get_byte(struct unwind_ctrl_block *ctrl)
>> static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
>>  {
>>       unsigned long insn = unwind_get_byte(ctrl);
>> +     unsigned long high, low;
>> +     unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
>> +     low = ctrl->vrs[SP];
>> +     high = ALIGN(low, THREAD_SIZE);
>>
>>       pr_debug("%s: insn = %08lx\n", __func__, insn);
>>
>> @@ -263,27 +267,27 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
>>
>>               /* pop R4-R15 according to mask */
>>               load_sp = mask & (1 << (13 - 4));
>> -             while (mask) {
>> +             while (mask && vsp < high) {
>>                       if (mask & 1)
>>                               ctrl->vrs[reg] = *vsp++;
>>                       mask >>= 1;
>>                       reg++;
>>               }
>> -             if (!load_sp)
>> +             if (!load_sp && vsp < high)
>>                       ctrl->vrs[SP] = (unsigned long)vsp;
>>       } else if ((insn & 0xf0) == 0x90 &&
>>                  (insn & 0x0d) != 0x0d)
>>               ctrl->vrs[SP] = ctrl->vrs[insn & 0x0f];
>>       else if ((insn & 0xf0) == 0xa0) {
>> -             unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
>>               int reg;
>>
>>               /* pop R4-R[4+bbb] */
>> -             for (reg = 4; reg <= 4 + (insn & 7); reg++)
>> +             for (reg = 4;  (reg <= 4 + (insn & 7)) && (vsp < high; reg++)
>>                       ctrl->vrs[reg] = *vsp++;
>> -             if (insn & 0x80)
>> +             if (insn & 0x80 && vsp < high)
>>                       ctrl->vrs[14] = *vsp++;
>> -             ctrl->vrs[SP] = (unsigned long)vsp;
>> +             if (vsp < high)
>> +                     ctrl->vrs[SP] = (unsigned long)vsp;
>>       } else if (insn == 0xb0) {
>>               if (ctrl->vrs[PC] == 0)
>>                       ctrl->vrs[PC] = ctrl->vrs[LR];
>> @@ -301,13 +305,14 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
>>               }
>>
>>               /* pop R0-R3 according to mask */
>> -             while (mask) {
>> +             while (mask && vsp < high) {
>>                       if (mask & 1)
>>                               ctrl->vrs[reg] = *vsp++;
>>                       mask >>= 1;
>>                       reg++;
>>               }
>> -             ctrl->vrs[SP] = (unsigned long)vsp;
>> +             if (vsp < high)
>> +                     ctrl->vrs[SP] = (unsigned long)vsp;
>>       } else if (insn == 0xb2) {
>>               unsigned long uleb128 = unwind_get_byte(ctrl);
>>
>> @@ -317,6 +322,8 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
>>               return -URC_FAILURE;
>>       }
>>
>> +     if (vsp >= high)
>> +             return -URC_FAILURE;
>>       pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
>>                ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
>>
>> --
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
Anurag Aggarwal
