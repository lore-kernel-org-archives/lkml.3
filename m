Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaKXTtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:49:08 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:58170 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaKXTtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:49:06 -0500
MIME-Version: 1.0
In-Reply-To: <20141122172025.GC4395@pd.tnic>
References: <cover.1416604491.git.luto@amacapital.net> <7665538633a500255d7da9ca5985547f6a2aa191.1416604491.git.luto@amacapital.net>
 <20141122172025.GC4395@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 24 Nov 2014 11:48:43 -0800
Message-ID: <CALCETrWwPz=GNwo=tNyc2_2xsQxtd1qcLj5Sw-Qw2Ox_U93jSQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] x86, traps: Track entry into and exit from IST context
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 9:20 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Nov 21, 2014 at 01:26:08PM -0800, Andy Lutomirski wrote:
>> We currently pretend that IST context is like standard exception
>> context, but this is incorrect.  IST entries from userspace are like
>> standard exceptions except that they use per-cpu stacks, so they are
>> atomic.  IST entries from kernel space are like NMIs from RCU's
>> perspective -- they are not quiescent states even if they
>> interrupted the kernel during a quiescent state.
>>
>> Add and use ist_enter and ist_exit to track IST context.  Even
>> though x86_32 has no IST stacks, we track these interrupts the same
>> way.
>>
>> This fixes two issues:
>>
>>  - Scheduling from an IST interrupt handler will now warn.  It would
>>    previously appear to work as long as we got lucky and nothing
>>    overwrote the stack frame.  (I don't know of any bugs in this
>>    that would trigger the warning, but it's good to be on the safe
>>    side.)
>>
>>  - RCU handling in IST context was dangerous.  As far as I know,
>>    only machine checks were likely to trigger this, but it's good to
>>    be on the safe side.
>>
>> Note that the machine check handlers appears to have been missing
>> any context tracking at all before this patch.
>>
>> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>> Cc: Josh Triplett <josh@joshtriplett.org>
>> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  arch/x86/include/asm/traps.h         |  4 +++
>>  arch/x86/kernel/cpu/mcheck/mce.c     |  5 ++++
>>  arch/x86/kernel/cpu/mcheck/p5.c      |  6 +++++
>>  arch/x86/kernel/cpu/mcheck/winchip.c |  5 ++++
>>  arch/x86/kernel/traps.c              | 49 ++++++++++++++++++++++++++++++------
>>  5 files changed, 61 insertions(+), 8 deletions(-)
>
> ...
>
>> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
>> index 0d0e922fafc1..f5c4b8813774 100644
>> --- a/arch/x86/kernel/traps.c
>> +++ b/arch/x86/kernel/traps.c
>> @@ -107,6 +107,39 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
>>       preempt_count_dec();
>>  }
>>
>> +enum ctx_state ist_enter(struct pt_regs *regs)
>> +{
>> +     /*
>> +      * We are atomic because we're on the IST stack (or we're on x86_32,
>> +      * in which case we still shouldn't schedule.
>> +      */
>> +     preempt_count_add(HARDIRQ_OFFSET);
>> +
>> +     if (user_mode_vm(regs)) {
>> +             /* Other than that, we're just an exception. */
>> +             return exception_enter();
>> +     } else {
>> +             /*
>> +              * We might have interrupted pretty much anything.  In
>> +              * fact, if we're a machine check, we can even interrupt
>> +              * NMI processing.  We don't want in_nmi() to return true,
>> +              * but we need to notify RCU.
>> +              */
>> +             rcu_nmi_enter();
>> +             return IN_KERNEL;  /* the value is irrelevant. */
>> +     }
>
> I guess dropping the explicit else-branch could make it look a bit nicer
> with the curly braces gone and all...
>
> enum ctx_state ist_enter(struct pt_regs *regs)
> {
>         /*
>          * We are atomic because we're on the IST stack (or we're on x86_32,
>          * in which case we still shouldn't schedule.
>          */
>         preempt_count_add(HARDIRQ_OFFSET);
>
>         if (user_mode_vm(regs))
>                 /* Other than that, we're just an exception. */
>                 return exception_enter();
>

Two indented lines w/o curly braces makes me think of goto fail; :-/

TBH, when there are clearly two options, I tend to prefer the braces
that make it very obvious what's going on.  I had some memorable bugs
several years ago that would have been impossible if I has used braces
more liberally.

--Andy

>         /*
>          * We might have interrupted pretty much anything.  In fact, if we're a
>          * machine check, we can even interrupt NMI processing.  We don't want
>          * in_nmi() to return true, but we need to notify RCU.
>          */
>         rcu_nmi_enter();
>         return IN_KERNEL;  /* the value is irrelevant. */
> }
>
>> +}
>> +
>> +void ist_exit(struct pt_regs *regs, enum ctx_state prev_state)
>> +{
>> +     preempt_count_sub(HARDIRQ_OFFSET);
>> +
>> +     if (user_mode_vm(regs))
>> +             return exception_exit(prev_state);
>> +     else
>> +             rcu_nmi_exit();
>> +}
>
> Ditto here.
>
>> +
>>  static nokprobe_inline int
>>  do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
>>                 struct pt_regs *regs, long error_code)
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --



-- 
Andy Lutomirski
AMA Capital Management, LLC
