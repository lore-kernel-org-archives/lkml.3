Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaKZNIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:08:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:50773 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaKZNI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:08:28 -0500
Date: Wed, 26 Nov 2014 14:08:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Berthier, Emmanuel" <emmanuel.berthier@intel.com>
cc: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] [LBR] Dump LBRs on Oops
In-Reply-To: <65CD3FC07F3BF942ABE211646D72D770356EA9E0@IRSMSX110.ger.corp.intel.com>
Message-ID: <alpine.DEB.2.11.1411261318050.3961@nanos>
References: <1416589419-9952-1-git-send-email-emmanuel.berthier@intel.com> <alpine.DEB.2.11.1411212240390.6439@nanos> <65CD3FC07F3BF942ABE211646D72D770356EA9E0@IRSMSX110.ger.corp.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014, Berthier, Emmanuel wrote:
> > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> The purpose of this patch is to use the LBR as a small instruction trace.
> The result will be:
> 
>  Last Branch Records:
>   _to: [<ffffffff82810980>] page_fault+0x0/0x70
>  from: [<0000000000000000>] 0x0
>   _to: [<0000000000000000>] 0x0
>  from: [<ffffffff8263693c>] corrupt_stack+0x3c/0x40
>   _to: [<ffffffff82636900>] corrupt_stack+0x0/0x40
>  from: [<ffffffff821dde6a>] simple_attr_write+0xca/0xf0
>   _to: [<ffffffff821dde63>] simple_attr_write+0xc3/0xf0
>  from: [<ffffffff8235387f>] simple_strtoll+0xf/0x20
>   _to: [<ffffffff8235387e>] simple_strtoll+0xe/0x20
>  from: [<ffffffff82351d5b>] simple_strtoull+0x4b/0x50
>   _to: [<ffffffff82351d4e>] simple_strtoull+0x3e/0x50
>  from: [<ffffffff82351d48>] simple_strtoull+0x38/0x50
>   _to: [<ffffffff82351d3d>] simple_strtoull+0x2d/0x50
>  from: [<ffffffff8235b4cb>] _parse_integer+0x9b/0xc0
>   _to: [<ffffffff8235b4b0>] _parse_integer+0x80/0xc0
>  from: [<ffffffff8235b497>] _parse_integer+0x67/0xc0

Ok. That could be useful indeed.
  
> > So, if perf uses LBR we do not print it? What a weird design decision. 
> > If the machine crashes, we want that information no matter whether 
> > perf is active or not. What kind of twisted logic is that?
> 
> Ok, let me explain.
> LBR usages are exclusive. Perf uses LBR to calculate some CPU
> statistics. I use LBR to track code execution before Exceptions.
> So, as soon as we enable perf, I disable LBR dump and vice versa.

That wants to be documented in the code.

> > > +		} else if (x86_pmu.lbr_nr == 0) {
> > > +			pr_cont(" (x86_model unknown, check
> > intel_pmu_init())\n");
> > 
> > Huch? Why we get here if the pmu does not support it at all? Why 
> > should we bother to print it? If it's not printed it's not available. It's that simple.
> 
> That's a warning to point out that current core is not
> supported. New cores have to be declared in
> 
> intel_pmu_init() after:
> 
> 	switch (boot_cpu_data.x86_model) {
> 	. . . 
> 	case 28: /* Atom */
> 	case 38: /* Lincroft */
> 	case 39: /* Penwell */
> 	case 53: /* Cloverview */
> 	case 54: /* Cedarview */
> 
> I work on new cores and their names will not be revealed before a while.
> So, next time this feature will be used on a new core, it's
> important to understand why is not supported and where to make the
> simple update.

We add printks not for people who work on the support of unreleased
hardware. They should better know what they are doing. If they can't
figure that out they should not touch the kernel in the first place.

> > >  void show_regs(struct pt_regs *regs)  {
> > >  	int i;
> > > @@ -314,10 +352,15 @@ void show_regs(struct pt_regs *regs)
> > >  		unsigned char c;
> > >  		u8 *ip;
> > >
> > > +		/*
> > > +		 * Called before show_stack_log_lvl() as it could trig
> > > +		 * page_fault and reenable LBR
> > 
> > Huch? The kernel stack dump is going to page fault? If that happens 
> > then you are in deep shit anyway. I doubt that anything useful gets 
> > out of the machine at this point, LBR or not.
> > 
> > Aside of that if we want to debug with the LBR then we better freeze 
> > that whole thing across a dump and be done with it.
> 
> I met that case but did no dig deeply into it...

Hmm, a corrupted stack might trigger this together with some of the
other debug options enabled. So we really might to put it in front.

> > > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S 
> > > index df088bb..120e989 100644
> > > --- a/arch/x86/kernel/entry_64.S
> > > +++ b/arch/x86/kernel/entry_64.S
> > > @@ -1035,6 +1035,42 @@ apicinterrupt IRQ_WORK_VECTOR \
> > >  	irq_work_interrupt smp_irq_work_interrupt  #endif
> > >
> > > +.macro STOP_LBR
> > > +#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
> > > +	testl $1, lbr_dump_on_exception
> > > +	jz 1f
> > > +	push %rax
> > > +	push %rcx
> > > +	push %rdx
> > > +	movl $MSR_IA32_DEBUGCTLMSR, %ecx
> > > +	rdmsr
> > > +	and $~1, %eax	/* Disable LBR recording */
> > > +	wrmsr
> > > +	pop %rdx
> > > +	pop %rcx
> > > +	pop %rax
> > > +1:
> > > +#endif
> > > +.endm
> > > +
> > > +.macro START_LBR
> > > +#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
> > > +	testl $1, lbr_dump_on_exception
> > > +	jz 1f
> > > +	push %rax
> > > +	push %rcx
> > > +	push %rdx
> > > +	movl $MSR_IA32_DEBUGCTLMSR, %ecx
> > > +	rdmsr
> > > +	or $1, %eax		/* Enable LBR recording */

> So, by default, when Perf is not used, LBR will be enabled at the
> first exception (usually a simple page fault) with default filtering
> options, i.e no filtering.  As soon as we start perf, the
> lbr_dump_on_exception global is unset and LBR start/stop are
> bypassed.
> 
> LBR filtering is reset during perf stop.

So while I can see how this could be useful there are a few things
which need more thought:

1) We want to enable/disable this at boot time.

   In the disabled case we might also stub out the test/jz and replace
   it by an unconditional jump, but that needs more thought.

2) Right now you stop the trace on every exception no matter whether
   it comes from user or kernel space.

   Stopping the trace when we handle a user space fault does not make
   any sense and inflicts just pointless overhead.

   Aside of that if the fault handler then crashes we do not have the
   LBR information because we froze it when entering from user space
   in the first place.

Thanks,

	tglx


