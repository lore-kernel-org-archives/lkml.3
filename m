Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbaAJU27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 15:28:59 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:47529 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaAJU25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 15:28:57 -0500
MIME-Version: 1.0
In-Reply-To: <20140110200603.GJ7572@laptop.programming.kicks-ass.net>
References: <52D011C9.7000209@hp.com> <20140110165822.GI7572@laptop.programming.kicks-ass.net>
 <20140110170223.GD8224@laptop.programming.kicks-ass.net> <20140110174141.GE8224@laptop.programming.kicks-ass.net>
 <CALCETrW2r=_Vt7+4aNKkKGeCAi8=WPULvPX3eyUEKH5nsu_CKQ@mail.gmail.com> <20140110200603.GJ7572@laptop.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 10 Jan 2014 12:28:36 -0800
Message-ID: <CALCETrWPJtbJTb1oqHuy+W_nS2XHDGMOWC7OAV_tLq+brPzpMw@mail.gmail.com>
Subject: Re: SIGSEGV when using "perf record -g" with 3.13-rc* kernel
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 12:06 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Jan 10, 2014 at 10:54:52AM -0800, Andy Lutomirski wrote:
>> Yuck -- when I wrote that thing, I hadn't imagined that an interrupt
>> (there's nothing particularly special about NMIs here, I think) would
>> try to access user memory.  The fix below looks okay, but IMO it needs
>> a big fat comment explaining what's going on.
>
> Agreed on both points, we can equally trigger this using software
> timers, so any interrupt must be exempt. And yes a comment!
>
>> Is there a way to ask whether the previous entry into the kernel came
>> from user space?
>
> Not afaik, but in_interrupt() gets us any interrupt context, whatever
> remains must be task context. Still not quite the same, but close enough
> I think.
>
>> The valid "sig_on_uaccess_error" case happens when
>> the current fault was triggered by a fault from userspace.  The
>> invalid case (and any invalid case from, say, an int3 that a
>> tracepoint stuck in there) would be a page fault triggered by a fault
>> handler that in turn started in kernel space (in particular, in
>> emulate_vsyscall).
>>
>> For that matter, why does current_thread_info() work from an NMI at
>> all?  Does the NMI vector not have its own stack?  The call that
>> installs it is set_intr_gate_ist(X86_TRAP_NMI, &nmi, NMI_STACK).
>
> NMIs do have their own stack, however x86_64 grabs kernel_stack from a
> per-cpu variable, not rsp.
>
>> In any case, this at least needs a comment.  I don't see why this same
>> bug couldn't be triggered by non-NMI based tracing mechanisms, though.
>>
>> Sigh, corner cases of corner cases...
>
> :-)
>
> Something like this perhaps?
>
> ---
> Subject: x86, mm: Allow double faults from interrupts
>
> Waiman managed to trigger a PMI while in a emulate_vsyscall() fault, the
> PMI in turn managed to trigger a fault while obtaining a stack trace.
> This triggered the double fault logic and killed the process dead.
>
> Fix this by explicitly excluding interrupts from the double fault logic.
>
> Reported-by: Waiman Long <waiman.long@hp.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/x86/mm/fault.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 9ff85bb8dd69..4c8e32986aad 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -641,6 +641,20 @@ no_context(struct pt_regs *regs, unsigned long error_code,
>
>         /* Are we prepared to handle this kernel fault? */
>         if (fixup_exception(regs)) {
> +               /*
> +                * Any interrupt that takes a fault gets the fixup. This
> +                * makes the below double fault logic only apply to a
> +                * task double faulting from task context.
> +                */
> +               if (in_interrupt())
> +                       return;
> +
> +               /*
> +                * Per the above we're !in_interrupt(), aka. task context.
> +                *
> +                * In this case we need to make sure we're not double faulting
> +                * through the emulate_vsyscall() logic.
> +                */
>                 if (current_thread_info()->sig_on_uaccess_error && signal) {
>                         tsk->thread.trap_nr = X86_TRAP_PF;
>                         tsk->thread.error_code = error_code | PF_USER;
> @@ -649,6 +663,10 @@ no_context(struct pt_regs *regs, unsigned long error_code,
>                         /* XXX: hwpoison faults will set the wrong code. */
>                         force_sig_info_fault(signal, si_code, address, tsk, 0);
>                 }
> +
> +               /*
> +                * Barring that, we can do the fixup and be happy.
> +                */
>                 return;
>         }
>

My only real nit is the same thing that confused me the first time I
read your email -- when I see "double fault", I think #DF.  How about
something like "It's possible for an interrupt to occur while
sig_on_uaccess_error is set.  In that case, uaccess faults that are
caused by the interrupt handler should not send signals."?

--Andy
