Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaAJRl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:41:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36791 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaAJRlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:41:53 -0500
Date: Fri, 10 Jan 2014 18:41:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: SIGSEGV when using "perf record -g" with 3.13-rc* kernel
Message-ID: <20140110174141.GE8224@laptop.programming.kicks-ass.net>
References: <52D011C9.7000209@hp.com>
 <20140110165822.GI7572@laptop.programming.kicks-ass.net>
 <20140110170223.GD8224@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110170223.GD8224@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 06:02:23PM +0100, Peter Zijlstra wrote:
> On Fri, Jan 10, 2014 at 05:58:22PM +0100, Peter Zijlstra wrote:
> > On Fri, Jan 10, 2014 at 10:29:13AM -0500, Waiman Long wrote:
> > > Peter,
> > > 
> > > Call Trace:
> > > <NMI>  [<ffffffff815710af>] dump_stack+0x49/0x62
> > >  [<ffffffff8104e3bc>] warn_slowpath_common+0x8c/0xc0
> > >  [<ffffffff8104e40a>] warn_slowpath_null+0x1a/0x20
> > >  [<ffffffff8105f1f1>] force_sig_info+0x131/0x140
> > >  [<ffffffff81042a4f>] force_sig_info_fault+0x5f/0x70
> > >  [<ffffffff8106d8da>] ? search_exception_tables+0x2a/0x50
> > >  [<ffffffff81043b3d>] ? fixup_exception+0x1d/0x70
> > >  [<ffffffff81042cc9>] no_context+0x159/0x1f0
> > >  [<ffffffff81042e8d>] __bad_area_nosemaphore+0x12d/0x230
> > >  [<ffffffff81042e8d>] ? __bad_area_nosemaphore+0x12d/0x230
> > >  [<ffffffff81042fa3>] bad_area_nosemaphore+0x13/0x20
> > >  [<ffffffff81578fc2>] __do_page_fault+0x362/0x480
> > >  [<ffffffff81578fc2>] ? __do_page_fault+0x362/0x480
> > >  [<ffffffff815791be>] do_page_fault+0xe/0x10
> > >  [<ffffffff81575962>] page_fault+0x22/0x30
> > >  [<ffffffff815817e4>] ? bad_to_user+0x5e/0x66b
> > >  [<ffffffff81285316>] copy_from_user_nmi+0x76/0x90
> > >  [<ffffffff81017a20>] perf_callchain_user+0xd0/0x360
> > >  [<ffffffff8111f64f>] perf_callchain+0x1af/0x1f0
> > >  [<ffffffff81117693>] perf_prepare_sample+0x2f3/0x3a0
> > >  [<ffffffff8111a2af>] __perf_event_overflow+0x10f/0x220
> > >  [<ffffffff8111ab14>] perf_event_overflow+0x14/0x20
> > >  [<ffffffff8101f69e>] intel_pmu_handle_irq+0x1de/0x3c0
> > >  [<ffffffff81008e44>] ? emulate_vsyscall+0x144/0x390
> > >  [<ffffffff81576e64>] perf_event_nmi_handler+0x34/0x60
> > >  [<ffffffff8157664a>] nmi_handle+0x8a/0x170
> > >  [<ffffffff81576848>] default_do_nmi+0x68/0x210
> > >  [<ffffffff81576a80>] do_nmi+0x90/0xe0
> > >  [<ffffffff81575c67>] end_repeat_nmi+0x1e/0x2e
> > >  [<ffffffff81008e44>] ? emulate_vsyscall+0x144/0x390
> > >  [<ffffffff81008e44>] ? emulate_vsyscall+0x144/0x390
> > >  [<ffffffff81008e44>] ? emulate_vsyscall+0x144/0x390
> > > <<EOE>>  [<ffffffff81042f7d>] __bad_area_nosemaphore+0x21d/0x230
> > >  [<ffffffff81042fa3>] bad_area_nosemaphore+0x13/0x20
> > >  [<ffffffff81578fc2>] __do_page_fault+0x362/0x480
> > >  [<ffffffff8113cfbc>] ? vm_mmap_pgoff+0xbc/0xe0
> > >  [<ffffffff815791be>] do_page_fault+0xe/0x10
> > >  [<ffffffff81575962>] page_fault+0x22/0x30
> > > ---[ end trace 037bf09d279751ec ]---
> > > 
> > > So this is a double page faults. Looking at relevant changes in
> > > 3.13 kernel, I spotted the following one patch that modified the
> > > perf_callchain_user() function shown up in the stack trace above:
> > > 
> > 
> > Hurm, that's an expected double fault, not something we should take the
> > process down for.
> > 
> > I'll have to look at how all that works for a bit.

Andy, introduced all this in 4fc3490114bb ("x86-64: Set siginfo and
context on vsyscall emulation faults").

It looks like your initial userspace fault hit the magic button and ends
up in emulate_vsyscall. Right at that point we trigger a PMI, which
tries to do a stack-trace. That stack-trace also stumbles into unmapped
memory (might be the same) and faults again.

Now at that point, we usually just give up on the callchain and proceed
like normal, however because of this double fault emulate-vsyscall
SIGSEGV magic you loose.

So the below might well be a valid fix.. Anybody? Andy?

> How easily can you reproduce this? Could you test something like the
> below, which would allow us to take double faults from NMI context.
> 
> ---
>  arch/x86/mm/fault.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 9ff85bb8dd69..18c498d4274d 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -641,7 +641,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
>  
>  	/* Are we prepared to handle this kernel fault? */
>  	if (fixup_exception(regs)) {
> -		if (current_thread_info()->sig_on_uaccess_error && signal) {
> +		if (!in_nmi() && current_thread_info()->sig_on_uaccess_error && signal) {
>  			tsk->thread.trap_nr = X86_TRAP_PF;
>  			tsk->thread.error_code = error_code | PF_USER;
>  			tsk->thread.cr2 = address;
