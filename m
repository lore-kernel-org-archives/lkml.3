Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaKZORq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:17:46 -0500
Received: from mga03.intel.com ([134.134.136.65]:3136 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaKZORm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:17:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,462,1413270000"; 
   d="scan'208";a="643887383"
From: "Berthier, Emmanuel" <emmanuel.berthier@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] [LBR] Dump LBRs on Oops
Thread-Topic: [PATCH] [LBR] Dump LBRs on Oops
Thread-Index: AQHQBa06swP7VVqtjkGZ0Sl9b+2CXJxr0WOAgAbwn5CAACa3gIAAC51A
Date: Wed, 26 Nov 2014 14:17:35 +0000
Message-ID: <65CD3FC07F3BF942ABE211646D72D770356EAC51@IRSMSX110.ger.corp.intel.com>
References: <1416589419-9952-1-git-send-email-emmanuel.berthier@intel.com>
 <alpine.DEB.2.11.1411212240390.6439@nanos>
 <65CD3FC07F3BF942ABE211646D72D770356EA9E0@IRSMSX110.ger.corp.intel.com>
 <alpine.DEB.2.11.1411261318050.3961@nanos>
In-Reply-To: <alpine.DEB.2.11.1411261318050.3961@nanos>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Wednesday, November 26, 2014 2:08 PM
> To: Berthier, Emmanuel
> Cc: mingo@redhat.com; hpa@zytor.com; x86@kernel.org; Jarzmik, Robert;
> linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] [LBR] Dump LBRs on Oops
> 
> On Wed, 26 Nov 2014, Berthier, Emmanuel wrote:
> > > So, if perf uses LBR we do not print it? What a weird design decision.
> > > If the machine crashes, we want that information no matter whether
> > > perf is active or not. What kind of twisted logic is that?
> >
> > Ok, let me explain.
> > LBR usages are exclusive. Perf uses LBR to calculate some CPU
> > statistics. I use LBR to track code execution before Exceptions.
> > So, as soon as we enable perf, I disable LBR dump and vice versa.
> 
> That wants to be documented in the code.

Ok, will be in patch 2

> > > > +		} else if (x86_pmu.lbr_nr == 0) {
> > > > +			pr_cont(" (x86_model unknown, check
> > > intel_pmu_init())\n");
> > >
> > > Huch? Why we get here if the pmu does not support it at all? Why
> > > should we bother to print it? If it's not printed it's not available. It's that
> simple.
> >
> > That's a warning to point out that current core is not supported. New
> > cores have to be declared in
> >
> > intel_pmu_init() after:
> >
> > 	switch (boot_cpu_data.x86_model) {
> > 	. . .
> > 	case 28: /* Atom */
> > 	case 38: /* Lincroft */
> > 	case 39: /* Penwell */
> > 	case 53: /* Cloverview */
> > 	case 54: /* Cedarview */
> >
> > I work on new cores and their names will not be revealed before a while.
> > So, next time this feature will be used on a new core, it's important
> > to understand why is not supported and where to make the simple
> > update.
> 
> We add printks not for people who work on the support of unreleased
> hardware. They should better know what they are doing. If they can't figure
> that out they should not touch the kernel in the first place.

LoL
I'm part of those people, I've touched the kernel and I've figured out what was wrong.
And I would like to be helped next year for the next Core: I'm an old man and I need
to leave a white stone trail  ;-)
Could we agree on that one?

> > > >  void show_regs(struct pt_regs *regs)  {
> > > >  	int i;
> > > > @@ -314,10 +352,15 @@ void show_regs(struct pt_regs *regs)
> > > >  		unsigned char c;
> > > >  		u8 *ip;
> > > >
> > > > +		/*
> > > > +		 * Called before show_stack_log_lvl() as it could trig
> > > > +		 * page_fault and reenable LBR
> > >
> > > Huch? The kernel stack dump is going to page fault? If that happens
> > > then you are in deep shit anyway. I doubt that anything useful gets
> > > out of the machine at this point, LBR or not.
> > >
> > > Aside of that if we want to debug with the LBR then we better freeze
> > > that whole thing across a dump and be done with it.
> >
> > I met that case but did no dig deeply into it...
> 
> Hmm, a corrupted stack might trigger this together with some of the other
> debug options enabled. So we really might to put it in front.

Didn't catch you. Could you elaborate on that?

> > > > diff --git a/arch/x86/kernel/entry_64.S
> > > > b/arch/x86/kernel/entry_64.S index df088bb..120e989 100644
> > > > --- a/arch/x86/kernel/entry_64.S
> > > > +++ b/arch/x86/kernel/entry_64.S
> > > > @@ -1035,6 +1035,42 @@ apicinterrupt IRQ_WORK_VECTOR \
> > > >  	irq_work_interrupt smp_irq_work_interrupt  #endif
> > > >
> > > > +.macro STOP_LBR
> > > > +#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
> > > > +	testl $1, lbr_dump_on_exception
> > > > +	jz 1f
> > > > +	push %rax
> > > > +	push %rcx
> > > > +	push %rdx
> > > > +	movl $MSR_IA32_DEBUGCTLMSR, %ecx
> > > > +	rdmsr
> > > > +	and $~1, %eax	/* Disable LBR recording */
> > > > +	wrmsr
> > > > +	pop %rdx
> > > > +	pop %rcx
> > > > +	pop %rax
> > > > +1:
> > > > +#endif
> > > > +.endm
> > > > +
> > > > +.macro START_LBR
> > > > +#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
> > > > +	testl $1, lbr_dump_on_exception
> > > > +	jz 1f
> > > > +	push %rax
> > > > +	push %rcx
> > > > +	push %rdx
> > > > +	movl $MSR_IA32_DEBUGCTLMSR, %ecx
> > > > +	rdmsr
> > > > +	or $1, %eax		/* Enable LBR recording */
> 
> > So, by default, when Perf is not used, LBR will be enabled at the
> > first exception (usually a simple page fault) with default filtering
> > options, i.e no filtering.  As soon as we start perf, the
> > lbr_dump_on_exception global is unset and LBR start/stop are bypassed.
> >
> > LBR filtering is reset during perf stop.
> 
> So while I can see how this could be useful there are a few things which need
> more thought:
> 
> 1) We want to enable/disable this at boot time.
> 
>    In the disabled case we might also stub out the test/jz and replace
>    it by an unconditional jump, but that needs more thought.

I can add a cmdline option to disable it at boot time.
Do you propose to use code instruction patching (same as ftrace) also?
Is-it really worth to bypass test/jz as page fault handling is much more than few instructions?

> 2) Right now you stop the trace on every exception no matter whether
>    it comes from user or kernel space.
> 
>    Stopping the trace when we handle a user space fault does not make
>    any sense and inflicts just pointless overhead.
>
>    Aside of that if the fault handler then crashes we do not have the
>    LBR information because we froze it when entering from user space
>    in the first place.

Agree, but the LBR buffer contains only 8 records: we have to stop it as soon as possible.
If we add some test/jump/call before stopping it, relevant info will be flushed out.

Thanks.

> Thanks,
> 
> 	tglx
> 

