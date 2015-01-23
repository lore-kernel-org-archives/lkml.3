Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbbAWQZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:25:06 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:37918 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbAWQZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:25:02 -0500
MIME-Version: 1.0
In-Reply-To: <20150123160746.GD23123@twins.programming.kicks-ass.net>
References: <1422028412.6345.6.camel@tkhai> <20150123160746.GD23123@twins.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 23 Jan 2015 08:24:40 -0800
Message-ID: <CALCETrVEsNj8dvqd-mNqb5tKNQOwQEgtMRUeTtJSS8-EmntAiA@mail.gmail.com>
Subject: Re: [RFC] sched, x86: Prevent resched interrupts if task in kernel
 mode and !CONFIG_PREEMPT
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 8:07 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Jan 23, 2015 at 06:53:32PM +0300, Kirill Tkhai wrote:
>> It's useless to send reschedule interrupts in such situations. The earliest
>> point, where schedule() call is possible, is sysret_careful(). But in that
>> function we directly test TIF_NEED_RESCHED.
>>
>> So it's possible to get rid of that type of interrupts.
>>
>> How about this idea? Is set_bit() cheap on x86 machines?
>
> So you set TIF_POLLING_NRFLAG on syscall entry and clear it again on
> exit? Thereby we avoid the IPI, because the exit path already checks for
> TIF_NEED_RESCHED.

The idle code says:

        /*
         * If the arch has a polling bit, we maintain an invariant:
         *
         * Our polling bit is clear if we're not scheduled (i.e. if
         * rq->curr != rq->idle).  This means that, if rq->idle has
         * the polling bit set, then setting need_resched is
         * guaranteed to cause the cpu to reschedule.
         */

Setting polling on non-idle tasks like this will either involve
weakening this a bit (it'll still be true for rq->idle) or changing
the polling state on context switch.

>
> Should work I suppose, but I'm not too familiar with all that entry.S
> muck. Andy might know and appreciate this.
>
>> ---
>>  arch/x86/kernel/entry_64.S |   10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
>> index c653dc4..a046ba8 100644
>> --- a/arch/x86/kernel/entry_64.S
>> +++ b/arch/x86/kernel/entry_64.S
>> @@ -409,6 +409,13 @@ GLOBAL(system_call_after_swapgs)
>>       movq_cfi rax,(ORIG_RAX-ARGOFFSET)
>>       movq  %rcx,RIP-ARGOFFSET(%rsp)
>>       CFI_REL_OFFSET rip,RIP-ARGOFFSET
>> +#if !defined(CONFIG_PREEMPT) || !defined(SMP)
>> +     /*
>> +      * Tell resched_curr() do not send useless interrupts to us.
>> +      * Kernel isn't preemptible till sysret_careful() anyway.
>> +      */
>> +     LOCK ; bts $TIF_POLLING_NRFLAG,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
>> +#endif

That's kind of expensive.  What's the !SMP part for?

>>       testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
>>       jnz tracesys
>>  system_call_fastpath:
>> @@ -427,6 +434,9 @@ GLOBAL(system_call_after_swapgs)
>>   * Has incomplete stack frame and undefined top of stack.
>>   */
>>  ret_from_sys_call:
>> +#if !defined(CONFIG_PREEMPT) || !defined(SMP)
>> +     LOCK ; btr $TIF_POLLING_NRFLAG,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
>> +#endif

If only it were this simple.  There are lots of ways out of syscalls,
and this is only one of them :(  If we did this, I'd rather do it
through the do_notify_resume mechanism or something.

I don't see any way to do this without at least one atomic op or
smp_mb per syscall, and that's kind of expensive.

Would it make sense to try to use context tracking instead?  On
systems that use context tracking, syscalls are already expensive, and
we're already keeping track of which CPUs are in user mode.

--Andy
