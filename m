Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbbAZL7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:59:14 -0500
Received: from relay.parallels.com ([195.214.232.42]:42666 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbbAZL7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:59:12 -0500
Message-ID: <1422273513.6345.29.camel@tkhai>
Subject: Re: [RFC] sched, x86: Prevent resched interrupts if task in kernel
 mode and !CONFIG_PREEMPT
From: Kirill Tkhai <ktkhai@parallels.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 26 Jan 2015 14:58:33 +0300
In-Reply-To: <CALCETrWFZ94LxPA2X1OROVAbcossdUgFEWATbfbR3ogqNxARsw@mail.gmail.com>
References: <1422028412.6345.6.camel@tkhai>
	 <20150123160746.GD23123@twins.programming.kicks-ass.net>
	 <CALCETrVEsNj8dvqd-mNqb5tKNQOwQEgtMRUeTtJSS8-EmntAiA@mail.gmail.com>
	 <1422032989.6345.26.camel@tkhai>
	 <CALCETrWFZ94LxPA2X1OROVAbcossdUgFEWATbfbR3ogqNxARsw@mail.gmail.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Пт, 23/01/2015 в 18:36 -0800, Andy Lutomirski пишет:
> On Fri, Jan 23, 2015 at 9:09 AM, Kirill Tkhai <ktkhai@parallels.com> wrote:
> > В Пт, 23/01/2015 в 08:24 -0800, Andy Lutomirski пишет:
> >> On Fri, Jan 23, 2015 at 8:07 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > On Fri, Jan 23, 2015 at 06:53:32PM +0300, Kirill Tkhai wrote:
> >> >> ---
> >> >>  arch/x86/kernel/entry_64.S |   10 ++++++++++
> >> >>  1 file changed, 10 insertions(+)
> >> >>
> >> >> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> >> >> index c653dc4..a046ba8 100644
> >> >> --- a/arch/x86/kernel/entry_64.S
> >> >> +++ b/arch/x86/kernel/entry_64.S
> >> >> @@ -409,6 +409,13 @@ GLOBAL(system_call_after_swapgs)
> >> >>       movq_cfi rax,(ORIG_RAX-ARGOFFSET)
> >> >>       movq  %rcx,RIP-ARGOFFSET(%rsp)
> >> >>       CFI_REL_OFFSET rip,RIP-ARGOFFSET
> >> >> +#if !defined(CONFIG_PREEMPT) || !defined(SMP)
> >> >> +     /*
> >> >> +      * Tell resched_curr() do not send useless interrupts to us.
> >> >> +      * Kernel isn't preemptible till sysret_careful() anyway.
> >> >> +      */
> >> >> +     LOCK ; bts $TIF_POLLING_NRFLAG,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
> >> >> +#endif
> >>
> >> That's kind of expensive.  What's the !SMP part for?
> >
> > smp_send_reschedule() is NOP on UP. There is no problem.
> 
> Shouldn't it be #if !defined(CONFIG_PREEMPT) && defined(CONFIG_SMP) then?

Definitely, thanks.

> 
> >
> >>
> >> >>       testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
> >> >>       jnz tracesys
> >> >>  system_call_fastpath:
> >> >> @@ -427,6 +434,9 @@ GLOBAL(system_call_after_swapgs)
> >> >>   * Has incomplete stack frame and undefined top of stack.
> >> >>   */
> >> >>  ret_from_sys_call:
> >> >> +#if !defined(CONFIG_PREEMPT) || !defined(SMP)
> >> >> +     LOCK ; btr $TIF_POLLING_NRFLAG,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
> >> >> +#endif
> >>
> >> If only it were this simple.  There are lots of ways out of syscalls,
> >> and this is only one of them :(  If we did this, I'd rather do it
> >> through the do_notify_resume mechanism or something.
> >
> > Yes, syscall is the only thing I did as an example.
> >
> >> I don't see any way to do this without at least one atomic op or
> >> smp_mb per syscall, and that's kind of expensive.
> >
> > JFI, doesn't x86 set_bit() lock a small area of memory? I thought
> > it's not very expensive on this arch (some bus optimizations or
> > something like this).
> 
> An entire syscall on x86 is well under 200 cycles.  lock addl is >20
> cycles for me, and I don't see why the atomic bitops would be faster.
> (Oddly, mfence is slower than lock addl, which is really odd, since
> lock addl implies mfence.)  So this overhead may actually matter.

Yeah, it's really big overhead.

> >
> >> Would it make sense to try to use context tracking instead?  On
> >> systems that use context tracking, syscalls are already expensive, and
> >> we're already keeping track of which CPUs are in user mode.
> >
> > I'll look at context_tracking, but I'm not sure some smp synchronization
> > there.
> 
> It could be combinable with existing synchronization there.

I'll look at this. Thanks!

Kirill

