Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbbAVTaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:30:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbbAVTas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:30:48 -0500
Date: Thu, 22 Jan 2015 20:30:46 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [RFC v3 2/2] x86/xen: allow privcmd hypercalls to be preempted
Message-ID: <20150122193046.GS17887@wotan.suse.de>
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com> <1421893039-426-3-git-send-email-mcgrof@do-not-panic.com> <CALCETrXSQ0JCKY5k0S_xX-i4+1BBVY+_9dv2ouj23WXFi8hyfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXSQ0JCKY5k0S_xX-i4+1BBVY+_9dv2ouj23WXFi8hyfg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 07:18:46PM -0800, Andy Lutomirski wrote:
> On Wed, Jan 21, 2015 at 6:17 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >
> > Xen has support for splitting heavy work work into a series
> > of hypercalls, called multicalls, and preempting them through
> > what Xen calls continuation [0]. Despite this though without
> > CONFIG_PREEMPT preemption won't happen, without preemption
> > a system can become pretty useless on heavy handed hypercalls.
> > Such is the case for example when creating a > 50 GiB HVM guest,
> > we can get softlockups [1] with:.
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
> > Suggested-by: Andy Lutomirski <luto@amacapital.net>
> > Cc: Andy Lutomirski <luto@amacapital.net>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: David Vrabel <david.vrabel@citrix.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: x86@kernel.org
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > Cc: Jan Beulich <JBeulich@suse.com>
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > ---
> >  arch/x86/kernel/entry_32.S       |  2 ++
> >  arch/x86/kernel/entry_64.S       |  2 ++
> >  drivers/xen/events/events_base.c | 13 +++++++++++++
> >  include/xen/events.h             |  1 +
> >  4 files changed, 18 insertions(+)
> >
> > diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> > index 000d419..b4b1f42 100644
> > --- a/arch/x86/kernel/entry_32.S
> > +++ b/arch/x86/kernel/entry_32.S
> > @@ -982,6 +982,8 @@ ENTRY(xen_hypervisor_callback)
> >  ENTRY(xen_do_upcall)
> >  1:     mov %esp, %eax
> >         call xen_evtchn_do_upcall
> > +       movl %esp,%eax
> > +       call xen_end_upcall
> >         jmp  ret_from_intr
> >         CFI_ENDPROC
> >  ENDPROC(xen_hypervisor_callback)
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index 9ebaf63..ee28733 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -1198,6 +1198,8 @@ ENTRY(xen_do_hypervisor_callback)   # do_hypervisor_callback(struct *pt_regs)
> >         popq %rsp
> >         CFI_DEF_CFA_REGISTER rsp
> >         decl PER_CPU_VAR(irq_count)
> > +       movq %rsp, %rdi  /* pass pt_regs as first argument */
> > +       call xen_end_upcall
> >         jmp  error_exit
> >         CFI_ENDPROC
> >  END(xen_do_hypervisor_callback)
> > diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
> > index b4bca2d..23c526b 100644
> > --- a/drivers/xen/events/events_base.c
> > +++ b/drivers/xen/events/events_base.c
> > @@ -32,6 +32,8 @@
> >  #include <linux/slab.h>
> >  #include <linux/irqnr.h>
> >  #include <linux/pci.h>
> > +#include <linux/sched.h>
> > +#include <linux/kprobes.h>
> >
> >  #ifdef CONFIG_X86
> >  #include <asm/desc.h>
> > @@ -1243,6 +1245,17 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
> >         set_irq_regs(old_regs);
> >  }
> >
> > +notrace void xen_end_upcall(struct pt_regs *regs)
> > +{
> > +       if (!xen_is_preemptible_hypercall(regs) ||
> > +           __this_cpu_read(xed_nesting_count))
> > +               return;
> 
> What's xed_nesting_count?

I'll nuke its use here as per David.

> > +
> > +       if (_cond_resched())
> > +               printk(KERN_DEBUG "xen hypercall preempted\n");
> 
> Did you mean to leave this in?  If so, should it be pr_debug?

Nuking as well.

 Luis
