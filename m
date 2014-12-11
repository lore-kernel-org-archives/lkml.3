Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424AbaLKAzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:55:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932933AbaLKAzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:55:13 -0500
Date: Thu, 11 Dec 2014 01:55:09 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jan Beulich <JBeulich@suse.com>,
        Juergen Gross <jgross@suse.com>, bpoirier@suse.de,
        X86 ML <x86@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 2/2] x86/xen: allow privcmd hypercalls to be
	preempted
Message-ID: <20141211005509.GN25677@wotan.suse.de>
References: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com> <1418254487-9988-3-git-send-email-mcgrof@do-not-panic.com> <CALCETrVAQ5JRoyL=V=fj+KxwUXfOTibKQkEDcvSqJzEi2sgshA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVAQ5JRoyL=V=fj+KxwUXfOTibKQkEDcvSqJzEi2sgshA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 03:51:48PM -0800, Andy Lutomirski wrote:
> On Wed, Dec 10, 2014 at 3:34 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >
> > Xen has support for splitting heavy work work into a series
> > of hypercalls, called multicalls, and preempting them through
> > what Xen calls continuation [0]. Despite this though without
> > CONFIG_PREEMPT preemption won't happen and while enabling
> > CONFIG_RT_GROUP_SCHED can at times help its not enough to
> > make a system usable. Such is the case for example when
> > creating a > 50 GiB HVM guest, we can get softlockups [1] with:.
> >
> > kernel: [  802.084335] BUG: soft lockup - CPU#1 stuck for 22s! [xend:31351]
> >
> > The softlock up triggers on the TASK_UNINTERRUPTIBLE hanger check
> > (default 120 seconds), on the Xen side in this particular case
> > this happens when the following Xen hypervisor code is used:
> >
> > xc_domain_set_pod_target() -->
> >   do_memory_op() -->
> >     arch_memory_op() -->
> >       p2m_pod_set_mem_target()
> >         -- long delay (real or emulated) --
> >
> > This happens on arch_memory_op() on the XENMEM_set_pod_target memory
> > op even though arch_memory_op() can handle continuation via
> > hypercall_create_continuation() for example.
> >
> > Machines over 50 GiB of memory are on high demand and hard to come
> > by so to help replicate this sort of issue long delays on select
> > hypercalls have been emulated in order to be able to test this on
> > smaller machines [2].
> >
> > On one hand this issue can be considered as expected given that
> > CONFIG_PREEMPT=n is used however we have forced voluntary preemption
> > precedent practices in the kernel even for CONFIG_PREEMPT=n through
> > the usage of cond_resched() sprinkled in many places. To address
> > this issue with Xen hypercalls though we need to find a way to aid
> > to the schedular in the middle of hypercalls. We are motivated to
> > address this issue on CONFIG_PREEMPT=n as otherwise the system becomes
> > rather unresponsive for long periods of time; in the worst case, at least
> > only currently by emulating long delays on select io disk bound
> > hypercalls, this can lead to filesystem corruption if the delay happens
> > for example on SCHEDOP_remote_shutdown (when we call 'xl <domain> shutdown').
> >
> > We can address this problem by trying to check if we should schedule
> > on the xen timer in the middle of a hypercall on the return from the
> > timer interrupt. We want to be careful to not always force voluntary
> > preemption though so to do this we only selectively enable preemption
> > on very specific xen hypercalls.
> >
> > This enables hypercall preemption by selectively forcing checks for
> > voluntary preempting only on ioctl initiated private hypercalls
> > where we know some folks have run into reported issues [1].
> >
> > [0] http://xenbits.xen.org/gitweb/?p=xen.git;a=commitdiff;h=42217cbc5b3e84b8c145d8cfb62dd5de0134b9e8;hp=3a0b9c57d5c9e82c55dd967c84dd06cb43c49ee9
> > [1] https://bugzilla.novell.com/show_bug.cgi?id=861093
> > [2] http://ftp.suse.com/pub/people/mcgrof/xen/emulate-long-xen-hypercalls.patch
> >
> > Based on original work by: David Vrabel <david.vrabel@citrix.com>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: David Vrabel <david.vrabel@citrix.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: x86@kernel.org
> > Cc: Andy Lutomirski <luto@amacapital.net>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > Cc: Jan Beulich <JBeulich@suse.com>
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > ---
> >  arch/x86/kernel/entry_32.S | 21 +++++++++++++++++++++
> >  arch/x86/kernel/entry_64.S | 17 +++++++++++++++++
> >  drivers/xen/Makefile       |  2 +-
> >  drivers/xen/preempt.c      | 17 +++++++++++++++++
> >  drivers/xen/privcmd.c      |  2 ++
> >  include/xen/xen-ops.h      | 26 ++++++++++++++++++++++++++
> >  6 files changed, 84 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/xen/preempt.c
> >
> > diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> > index 344b63f..40b5c0c 100644
> > --- a/arch/x86/kernel/entry_32.S
> > +++ b/arch/x86/kernel/entry_32.S
> > @@ -982,7 +982,28 @@ ENTRY(xen_hypervisor_callback)
> >  ENTRY(xen_do_upcall)
> >  1:     mov %esp, %eax
> >         call xen_evtchn_do_upcall
> > +#ifdef CONFIG_PREEMPT
> >         jmp  ret_from_intr
> > +#else
> > +       GET_THREAD_INFO(%ebp)
> > +#ifdef CONFIG_VM86
> > +       movl PT_EFLAGS(%esp), %eax      # mix EFLAGS and CS
> > +       movb PT_CS(%esp), %al
> > +       andl $(X86_EFLAGS_VM | SEGMENT_RPL_MASK), %eax
> > +#else
> > +       movl PT_CS(%esp), %eax
> > +       andl $SEGMENT_RPL_MASK, %eax
> > +#endif
> > +       cmpl $USER_RPL, %eax
> > +       jae resume_userspace            # returning to v8086 or userspace
> > +       DISABLE_INTERRUPTS(CLBR_ANY)
> > +       cmpb $0,PER_CPU_VAR(xen_in_preemptible_hcall)
> > +       jz resume_kernel
> > +       movb $0,PER_CPU_VAR(xen_in_preemptible_hcall)
> > +       call cond_resched_irq
> > +       movb $1,PER_CPU_VAR(xen_in_preemptible_hcall)
> > +       jmp resume_kernel
> > +#endif /* CONFIG_PREEMPT */
> >         CFI_ENDPROC
> >  ENDPROC(xen_hypervisor_callback)
> >
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index c0226ab..0ccdd06 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -1170,7 +1170,23 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
> >         popq %rsp
> >         CFI_DEF_CFA_REGISTER rsp
> >         decl PER_CPU_VAR(irq_count)
> > +#ifdef CONFIG_PREEMPT
> >         jmp  error_exit
> > +#else
> > +       movl %ebx, %eax
> > +       RESTORE_REST
> > +       DISABLE_INTERRUPTS(CLBR_NONE)
> > +       TRACE_IRQS_OFF
> > +       GET_THREAD_INFO(%rcx)
> > +       testl %eax, %eax
> > +       je error_exit_user
> > +       cmpb $0,PER_CPU_VAR(xen_in_preemptible_hcall)
> > +       jz retint_kernel
> 
> I think I understand this part.
> 
> > +       movb $0,PER_CPU_VAR(xen_in_preemptible_hcall)
> 
> Why?  Is the issue that, if preemptible hypercalls nest, you don't
> want to preempt again?


So this callback on the xen timer, without the CPU variable
we would not be able to selectively preempt specific hypercalls
and we'd a no-preempt kernel fully preemptive.

I asked the same question, see:

https://lkml.org/lkml/2014/12/3/756

> 
> > +       call cond_resched_irq
> 
> On !CONFIG_PREEMPT, there's no preempt_disable, right?  So how do you
> guarantee that you don't preempt something you shouldn't?

Not sure I follow, but in essence this is no different then the use
of cond_resched() on !CONFIG_PREEMPT, the only thing here is we are
in interrupt context. If this is about abuse of making !CONFIG_PREEMPT
voluntarily preemptive at select points then I had similar concerns
and David pointed out to me the wide use of cond_resched() on the
kernel.

> Is the idea
> that these events will only fire nested *directly* inside a
> preemptible hypercall?

Yeah its the timer interrupt that would trigger the above.

> Also, should you check that IRQs were on when
> the event fired?  (Are they on in pt_regs?)

Right before this xen_evtchn_do_upcall() is issued, which
saves pt_regs and then restores them.

> > +       movb $1,PER_CPU_VAR(xen_in_preemptible_hcall)
> > +       jmp retint_kernel
> > +#endif /* CONFIG_PREEMPT */
> >         CFI_ENDPROC
> 
> All that being said, this is IMO a bit gross.

That was my first reaction hence my original attempt to try to get away from
this. I've learned David also tried to not go down this route too before,
more on this below.

>  You've added a bunch of
> asm that's kind of like a parallel error_exit,

yeah.. I first tried to macro'tize this but it looked hairy, if we
wanted to do that... (although the name probably ain't best)

32-bit:
.macro test_from_kernel kernel_ret:req
	GET_THREAD_INFO(%ebp)
#ifdef CONFIG_VM86
	movl PT_EFLAGS(%esp), %eax	# mix EFLAGS and CS
	movb PT_CS(%esp), %al
	andl $(X86_EFLAGS_VM | SEGMENT_RPL_MASK), %eax
#else
	/*
	 * We can be coming here from child spawned by kernel_thread().
	 */
	movl PT_CS(%esp), %eax
	andl $SEGMENT_RPL_MASK, %eax
#endif
	cmpl $USER_RPL, %eax
	jb \kernel_ret
.endm

64-bit:
	.macro test_from_kernel kernel_ret:req
	movl %ebx,%eax
	RESTORE_REST
	DISABLE_INTERRUPTS(CLBR_NONE)
	TRACE_IRQS_OFF
	GET_THREAD_INFO(%rcx)
	testl %eax,%eax
	jne \kernel_ret
	.endm

> and the error entry and
> exit code is hairy enough that this scares me.

yeah...

>  Can you do this mostly in C instead?  This would look a nicer if it could be:
> 
>     call xen_evtchn_do_upcall
>     popq %rsp
>     CFI_DEF_CFA_REGISTER rsp
>     decl PER_CPU_VAR(irq_count)
> +  call xen_end_upcall
>     jmp error_exit

It seems David tried this originally eons ago:

http://lists.xen.org/archives/html/xen-devel/2014-02/msg01101.html

and the strategy was shifted based on Jan's feedback that we could
not sched as we're on the IRQ stack. David evolved the strategy
to asm and to use preempt_schedule_irq(), this new iteratin just
revisits the same old but tries to generalize scheduling on IRQ
context on very special circumstances.

> Where xen_end_upcall would be witten in C, nokprobes and notrace (if
> needed) and would check pt_regs and whatever else and just call
> schedule if needed?

If there's a way to do it it'd be great. I am not sure if we can though.

  Luis
