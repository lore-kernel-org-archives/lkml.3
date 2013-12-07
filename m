Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3LGINX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 03:13:23 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:48581 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab3LGINW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 03:13:22 -0500
MIME-Version: 1.0
In-Reply-To: <20131206121149.GA4897@e103592.cambridge.arm.com>
References: <1386310193-6434-1-git-send-email-a.anurag@samsung.com>
	<20131206121149.GA4897@e103592.cambridge.arm.com>
Date: Sat, 7 Dec 2013 13:43:21 +0530
Message-ID: <CAPoNrtsHOXJMUsgUE_MET298n_H2sC2P+RbfUoG=kqK9chTTHw@mail.gmail.com>
Subject: Re: [PATCH] ARM : unwinder : Prevent data abort due to stack overflow
From: Anurag Aggarwal <anurag19aggarwal@gmail.com>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Anurag Aggarwal <a.anurag@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
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

>>
>> +     /* we are just starting, initialize last register set as 0 */
>> +     ctrl.last_register_set = 0;
>> +
>>       while (ctrl.entries > 0) {
>> -             int urc = unwind_exec_insn(&ctrl);
>> +             int urc;
>> +             if ((ctrl.sp_high - ctrl.vrs[SP]) < TOTAL_REGISTERS)
>> +                     ctrl.last_register_set = 1;
>
>If this is done once per unwind_exec_insn(), I think it would be better
>to put the check at the start of unwind_exec_insn() instead of outside.

I think it is better to do the above check here only because this check
is strictly not a part of decoder and execution cycle.

I think uniwnd_exec_insn(), should only be used for decoding and
execution of instruction, as you have suggested earlier. So, it makes
sense to keep it in unwind_frame only().


On Fri, Dec 6, 2013 at 5:41 PM, Dave Martin <Dave.Martin@arm.com> wrote:
> On Fri, Dec 06, 2013 at 06:09:53AM +0000, Anurag Aggarwal wrote:
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
>>  arch/arm/kernel/unwind.c | 138 ++++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 100 insertions(+), 38 deletions(-)
>>
>> diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
>> index 00df012..6d854f8 100644
>> --- a/arch/arm/kernel/unwind.c
>> +++ b/arch/arm/kernel/unwind.c
>> @@ -49,6 +49,8 @@
>>  #include <asm/traps.h>
>>  #include <asm/unwind.h>
>>
>> +#define TOTAL_REGISTERS 16
>> +
>>  /* Dummy functions to avoid linker complaints */
>>  void __aeabi_unwind_cpp_pr0(void)
>>  {
>> @@ -66,9 +68,11 @@ void __aeabi_unwind_cpp_pr2(void)
>>  EXPORT_SYMBOL(__aeabi_unwind_cpp_pr2);
>>
>>  struct unwind_ctrl_block {
>> -     unsigned long vrs[16];          /* virtual register set */
>> +     unsigned long vrs[TOTAL_REGISTERS];     /* virtual register set */
>>       const unsigned long *insn;      /* pointer to the current instructions word */
>> +     unsigned long sp_high;          /* highest value of sp allowed*/
>>       int entries;                    /* number of entries left to interpret */
>> +     int last_register_set;          /* store if we are at the last set */
>
> I find the name and comment a bit confusing here.  Also, strictly
> speaking it can be a bool.
>
> Maybe:
>
>         /*
>          * true: check for stack overflow for each register pop;
>          * false: save overhead if there is plenty of stack remaining.
>          */
>         bool check_each_pop;
>
>
> It shouldn't be too hard to understand from reading the code though, so
> I'm happy with your version if you prefer.
>
> [...]
>
>> @@ -382,11 +438,17 @@ int unwind_frame(struct stackframe *frame)
>>               return -URC_FAILURE;
>>       }
>>
>> +     /* we are just starting, initialize last register set as 0 */
>> +     ctrl.last_register_set = 0;
>> +
>>       while (ctrl.entries > 0) {
>> -             int urc = unwind_exec_insn(&ctrl);
>> +             int urc;
>> +             if ((ctrl.sp_high - ctrl.vrs[SP]) < TOTAL_REGISTERS)
>> +                     ctrl.last_register_set = 1;
>
> If this is done once per unwind_exec_insn(), I think it would be better
> to put the check at the start of unwind_exec_insn() instead of outside.
>
>
> The check still looks wrong too?
>
> ctrl.sp_high - ctrl.vrs[SP] gives the available space in bytes, but
> TOTAL_REGISTERS is measured in words.
>
>
> One way to get the correct value would be simply
>
>         sizeof ctrl.vrs
>
> since that's the array we're trying to fill from the stack.
>
> (in that case I guess that the TOTAL_REGISTERS macro might not be needed
> again)
>
> Cheers
> ---Dave



-- 
Anurag Aggarwal
