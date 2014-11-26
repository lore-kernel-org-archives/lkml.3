Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaKZK4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 05:56:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:45218 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaKZK4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 05:56:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="421700407"
From: "Berthier, Emmanuel" <emmanuel.berthier@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] [LBR] Dump LBRs on Oops
Thread-Topic: [PATCH] [LBR] Dump LBRs on Oops
Thread-Index: AQHQBa06swP7VVqtjkGZ0Sl9b+2CXJxr0WOAgAbwn5A=
Date: Wed, 26 Nov 2014 10:56:16 +0000
Message-ID: <65CD3FC07F3BF942ABE211646D72D770356EA9E0@IRSMSX110.ger.corp.intel.com>
References: <1416589419-9952-1-git-send-email-emmanuel.berthier@intel.com>
 <alpine.DEB.2.11.1411212240390.6439@nanos>
In-Reply-To: <alpine.DEB.2.11.1411212240390.6439@nanos>
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

> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Saturday, November 22, 2014 1:51 AM On Fri, 21 Nov 2014, 
> Emmanuel Berthier wrote:
> 
> > The purpose of this patch is to stop LBR at the early stage of 
> > Exception Handling, and dump its content later in the dumpstack 
> > process.
> 
> And that's useful in what way? The changelog should not tell WHAT the 
> patch does. It should tell WHY it is useful and what are the usecases/benefits.
> Neither does it tell how that feature can be used/enabled/disabled and 
> how it provides useful information.
> Where is that sample output which demonstrates that this is something 
> which adds debugging value rather than another level of pointless featuritis?

Oops, right. 

Let's take the case of a stack corruption:

static int corrupt_stack(void *data, u64 val)  {  long long ptr[1];

	asm ("");
	ptr[0]=0;
	ptr[1]=0;
	ptr[2]=0;
	ptr[3]=0;

	return -1;
 }

The standard Panic will report:

 BUG: unable to handle kernel NULL pointer dereference at           (null)
 IP: [<          (null)>]           (null)
 PGD 48605067 PUD 0
 Oops: 0010 [#1] PREEMPT SMP
 task: ffff8800384f6300 ti: ffff880035c70000 task.ti: ffff880035c70000
 RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
 RSP: 0018:ffff880035c71ec8  EFLAGS: 00010246
 RAX: 00000000ffffffff RBX: fffffffffffffff2 RCX: 000000000000002a
 RDX: ffff880035c71e90 RSI: 0000000000000001 RDI: 0000000000000000
 RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
 R10: 000000000000000a R11: f000000000000000 R12: ffff880033be0e50
 R13: 0000000000000002 R14: 0000000000000002 R15: ffff880033be0e00
 FS:  0000000000000000(0000) GS:ffff88007ea80000(0063) knlGS:00000000f76cd280
 CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
 CR2: 0000000000000000 CR3: 000000003871b000 CR4: 00000000001007e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Stack:
  0000000000000000 00000000f802bb54 ffff880075e85680 0000000000000002
  00000000f802bb54 ffff880035c71f50 0000000000000000 ffff880035c71f38
  ffffffff821b8266 ffff880075e85680 00000000f802bb54 0000000000000002  Call Trace:
  [<ffffffff821b8266>] ? vfs_write+0xb6/0x1c0
  [<ffffffff821b86fd>] ? SyS_write+0x4d/0x90
  [<ffffffff82817c65>] ? sysenter_dispatch+0x7/0x23
 Code:  Bad RIP value.
 RIP  [<          (null)>]           (null)
  RSP <ffff880035c71ec8>
 CR2: 0000000000000000

The purpose of this patch is to use the LBR as a small instruction trace.
The result will be:

 Last Branch Records:
  _to: [<ffffffff82810980>] page_fault+0x0/0x70
 from: [<0000000000000000>] 0x0
  _to: [<0000000000000000>] 0x0
 from: [<ffffffff8263693c>] corrupt_stack+0x3c/0x40
  _to: [<ffffffff82636900>] corrupt_stack+0x0/0x40
 from: [<ffffffff821dde6a>] simple_attr_write+0xca/0xf0
  _to: [<ffffffff821dde63>] simple_attr_write+0xc3/0xf0
 from: [<ffffffff8235387f>] simple_strtoll+0xf/0x20
  _to: [<ffffffff8235387e>] simple_strtoll+0xe/0x20
 from: [<ffffffff82351d5b>] simple_strtoull+0x4b/0x50
  _to: [<ffffffff82351d4e>] simple_strtoull+0x3e/0x50
 from: [<ffffffff82351d48>] simple_strtoull+0x38/0x50
  _to: [<ffffffff82351d3d>] simple_strtoull+0x2d/0x50
 from: [<ffffffff8235b4cb>] _parse_integer+0x9b/0xc0
  _to: [<ffffffff8235b4b0>] _parse_integer+0x80/0xc0
 from: [<ffffffff8235b497>] _parse_integer+0x67/0xc0
 
> > --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> > @@ -4,7 +4,9 @@
> >  #include <asm/perf_event.h>
> >  #include <asm/msr.h>
> >  #include <asm/insn.h>
> > -
> > +#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION #include <asm/processor.h> 
> > +#endif
> 
> We just can include that file unconditionally.

Ok for patch 2.

> >  #include "perf_event.h"
> >
> >  enum {
> > @@ -135,6 +137,9 @@ static void __intel_pmu_lbr_enable(void)
> >  	u64 debugctl;
> >  	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
> >
> > +	if (IS_ENABLED(CONFIG_LBR_DUMP_ON_EXCEPTION))
> > +		lbr_dump_on_exception = 0;
> 
> With certain compilers you might get a surprise here, because they are 
> too stupid to remove that 'lbr_dump_on_exception = 0;' right away. 
> They kill it in the optimization phase. So they complain about 
> lbr_dump_on_exception not being defined.
> 
> So you need something like this:
> 
> static inline void lbr_set_dump_on_oops(bool enable) { #ifdef 
> CONFIG_LBR_DUMP_ON_EXCEPTION
>        ....
> #endif
> }
> 
> and make that
> 
>      if (IS_ENABLED(CONFIG_LBR_DUMP_ON_EXCEPTION))
>              lbr_set_dump_on_oops(false);
> 
> which is completely pointless as you can just call
> 
>       lbr_set_dump_on_oops(false);
> 
> unconditionally and be done with it.
> 
> IS_ENABLED(CONFIG_XXX) is not a proper solution for all problems. It 
> can avoid #ifdefs, but it also can introduce interesting nonsense.

Ok for patch 2.

> >  	if (cpuc->lbr_sel)
> >  		wrmsrl(MSR_LBR_SELECT, cpuc->lbr_sel->config);
> >
> > @@ -147,6 +152,9 @@ static void __intel_pmu_lbr_disable(void)  {
> >  	u64 debugctl;
> >
> > +	if (IS_ENABLED(CONFIG_LBR_DUMP_ON_EXCEPTION))
> > +		lbr_dump_on_exception = 1;
> 
> Now the even more interesting question is, WHY is 
> lbr_dump_on_exception enabled in __intel_pmu_lbr_disable and disabled 
> in __intel_pmu_lbr_enable?
> 
> This obviously lacks a understandable comment, but before you 
> elaborate on this see the next comment.

Oh no, I would have liked to explain it right now ;-)

> > +void show_lbrs(void)
> > +{
> > +	if (IS_ENABLED(CONFIG_LBR_DUMP_ON_EXCEPTION)) {
> > +		u64 debugctl;
> > +		int i, lbr_on;
> > +
> > +		rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
> > +		lbr_on = debugctl & DEBUGCTLMSR_LBR;
> > +
> > +		pr_info("Last Branch Records:");
> > +		if (!lbr_dump_on_exception) {
> > +			pr_cont(" (Disabled by perf_event)\n");
> 
> So, if perf uses LBR we do not print it? What a weird design decision. 
> If the machine crashes, we want that information no matter whether 
> perf is active or not. What kind of twisted logic is that?

Ok, let me explain.
LBR usages are exclusive. Perf uses LBR to calculate some CPU statistics. I use LBR to track code execution before Exceptions.
So, as soon as we enable perf, I disable LBR dump and vice versa.

> > +		} else if (x86_pmu.lbr_nr == 0) {
> > +			pr_cont(" (x86_model unknown, check
> intel_pmu_init())\n");
> 
> Huch? Why we get here if the pmu does not support it at all? Why 
> should we bother to print it? If it's not printed it's not available. It's that simple.

That's a warning to point out that current core is not supported. New cores have to be declared in
intel_pmu_init() after:

	switch (boot_cpu_data.x86_model) {
	. . . 
	case 28: /* Atom */
	case 38: /* Lincroft */
	case 39: /* Penwell */
	case 53: /* Cloverview */
	case 54: /* Cedarview */

I work on new cores and their names will not be revealed before a while.
So, next time this feature will be used on a new core, it's important to understand why is not supported and where to make the simple update.

> > +		} else if (lbr_on) {
> > +			pr_cont(" (not halted)\n");
> 
> Why would it be not halted? Code comments are optional, right?

The LBR recording is not halted if we call directly panic() without coming from an exception.
In this case, LBR dump is irrelevant.
I will add a comment in patch 2.

> > +		} else {
> > +			struct cpu_hw_events *cpuc =
> > +
> 	this_cpu_ptr(&cpu_hw_events);
> 
> A simple #ifdef would have saved you an indentation level and actually 
> made that code readable. IS_ENABLED() is a proper hammer for some 
> things but not everything is a nail.

Ok, will correct that in patch 2.

> > +			intel_pmu_lbr_read_64(cpuc);
> > +
> > +			pr_cont("\n");
> > +			for (i = 0; i < cpuc->lbr_stack.nr; i++) {
> > +				pr_info("   to: [<%016llx>] ",
> > +						cpuc->lbr_entries[i].to);
> > +				print_symbol("%s\n", cpuc-
> >lbr_entries[i].to);
> > +				pr_info(" from: [<%016llx>] ",
> > +						cpuc->lbr_entries[i].from);
> > +				print_symbol("%s\n", cpuc-
> >lbr_entries[i].from);
> > +			}
> > +		}
> > +	}
> > +}
> > +
> >  void show_regs(struct pt_regs *regs)  {
> >  	int i;
> > @@ -314,10 +352,15 @@ void show_regs(struct pt_regs *regs)
> >  		unsigned char c;
> >  		u8 *ip;
> >
> > +		/*
> > +		 * Called before show_stack_log_lvl() as it could trig
> > +		 * page_fault and reenable LBR
> 
> Huch? The kernel stack dump is going to page fault? If that happens 
> then you are in deep shit anyway. I doubt that anything useful gets 
> out of the machine at this point, LBR or not.
> 
> Aside of that if we want to debug with the LBR then we better freeze 
> that whole thing across a dump and be done with it.

I met that case but did no dig deeply into it...

> > +		 */
> > +		show_lbrs();
> 
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S 
> > index df088bb..120e989 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -1035,6 +1035,42 @@ apicinterrupt IRQ_WORK_VECTOR \
> >  	irq_work_interrupt smp_irq_work_interrupt  #endif
> >
> > +.macro STOP_LBR
> > +#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
> > +	testl $1, lbr_dump_on_exception
> > +	jz 1f
> > +	push %rax
> > +	push %rcx
> > +	push %rdx
> > +	movl $MSR_IA32_DEBUGCTLMSR, %ecx
> > +	rdmsr
> > +	and $~1, %eax	/* Disable LBR recording */
> > +	wrmsr
> > +	pop %rdx
> > +	pop %rcx
> > +	pop %rax
> > +1:
> > +#endif
> > +.endm
> > +
> > +.macro START_LBR
> > +#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
> > +	testl $1, lbr_dump_on_exception
> > +	jz 1f
> > +	push %rax
> > +	push %rcx
> > +	push %rdx
> > +	movl $MSR_IA32_DEBUGCTLMSR, %ecx
> > +	rdmsr
> > +	or $1, %eax		/* Enable LBR recording */
> 
> This is really brilliant. So the logic here is:
> 
> Perf uses LBR  	LBR state at 	 LBR state at	Dump
>      	  	exception entry	 exception exit
> 
> Yes		No change	 No change	No
> 
> No		off -> off or	 off -> on	empty
> 		on  -> off 	 off -> on    	perhaps useful
> 
> So how does LBR get magically enabled?
> 
>    By producing fault #1 and then on the exception exit enabling
>    LBR so that fault #2 can provide data?
> 
>    That's the only way I can see how to do that if you are not
>    magically tweaking MSR_IA32_DEBUGCTLMSR from user space.
> 
>    Now that magically works, because you add that stuff into all
>    exception entry/exit stubs.
> 
>    So it will be enabled magically no matter what and it will also be
>    enabled unconditonally on any machine whether it supports that
>    feature or not. That's the whole reason why you have no 32bit
>    support for this yet.
> 
> How is that thing useful when perf uses LBR?
> 
>    Not at all. We do not gain anything. We explode and have no value
>    at all.
> 
> Aside of that what is setting the proper options for LBR recording in 
> MSR_LBR_SELECT, if available?
> 
>    Nothing, which is useless as well, as the dump might just conatin
>    completely useless crap. There is a reason why haswell introduced
>    LBR filtering.
> 
> So what's the point of this?

Yes, that's a kind of magic ;-)
I've stated that LBR is incompatible with Perf.
So, by default, when Perf is not used, LBR will be enabled at the first exception (usually a simple page fault) with default filtering options, i.e no filtering.
As soon as we start perf, the lbr_dump_on_exception global is unset and LBR start/stop are bypassed.
LBR filtering is reset during perf stop.

> Thanks,
> 
> 	tglx

Thanks a lot for your time!
Emmanuel.
