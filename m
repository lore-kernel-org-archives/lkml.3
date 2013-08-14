Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab3HNRbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 13:31:10 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:57109 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab3HNRbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 13:31:08 -0400
Date: Wed, 14 Aug 2013 19:31:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kevin Hilman <khilman@linaro.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] timers/nohz updates for 3.12
Message-ID: <20130814173103.GA19235@gmail.com>
References: <1375729264-19845-1-git-send-email-fweisbec@gmail.com>
 <20130812184428.GA19785@gmail.com>
 <20130813000355.GD27436@somewhere>
 <20130813145730.GA4485@gmail.com>
 <20130814155638.GA4506@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814155638.GA4506@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Aug 13, 2013 at 04:57:30PM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > > >  19 files changed, 534 insertions(+), 326 deletions(-)
> > > > 
> > > > When merged to -tip it causes this build error:
> > > > 
> > > >  kernel/time/tick-sched.c:186:3: error: 'have_nohz_full_mask' undeclared (first use in this function)
> > > >  kernel/time/tick-sched.c:345:2: error: 'cpu' undeclared (first use in this function)
> > > > 
> > > > config attached.
> > > > 
> > > > I did what looked like to be an obvious conflict resolution to 
> > > > tick-sched.c (attached), please double check that too.
> > > > 
> > > > While at it, mind rebasing your changes to tip:timers/urgent, which has a 
> > > > few nohz fixes pending as well?
> > > 
> > > Ok I did the rebase on top of tip:timers/urgent and handled the 
> > > conflicts along. The new branch is "timers/nohz-v2".
> > > 
> > > Tell me if anything goes wrong with it.
> > 
> > it produces this splat on bootup with the attached config, on a dual-core 
> > Athlon64 box:
> > 
> > calling  context_tracking_init+0x0/0x3a @ 1
> > initcall context_tracking_init+0x0/0x3a returned 0 after 0 usecs
> > calling  dynamic_debug_init+0x0/0x239 @ 1
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 1 at kernel/sched/cputime.c:639 get_vtime_delta+0x49/0x5f()
> > CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc5-01689-g7830cba-dirty #226899
> > Hardware name: System manufacturer System Product Name/A8N-E, BIOS ASUS A8N-E ACPI BIOS Revision 1008 08/22/2005
> >  0000000000000009 ffff88003fa03ea8 ffffffff81f83f30 0000000000000b63
> >  0000000000000000 ffff88003fa03ee8 ffffffff810996a4 0000000000000000
> >  ffffffff810bcfb5 ffff88003e33a000 0000000015752a00 0000000000000000
> > Call Trace:
> >  <IRQ>  [<ffffffff81f83f30>] dump_stack+0x46/0x58
> >  [<ffffffff810996a4>] warn_slowpath_common+0x72/0x8c
> >  [<ffffffff810bcfb5>] ? get_vtime_delta+0x49/0x5f
> >  [<ffffffff8109976c>] warn_slowpath_null+0x15/0x19
> >  [<ffffffff810bcfb5>] get_vtime_delta+0x49/0x5f
> >  [<ffffffff810bd213>] __vtime_account_system+0xf/0x37
> >  [<ffffffff810bd426>] vtime_account_system+0x21/0x2e
> >  [<ffffffff810bd5bf>] vtime_common_account_irq_enter+0x41/0x43
> >  [<ffffffff8109ce4a>] irq_enter+0x65/0x7c
> >  [<ffffffff810434e2>] smp_apic_timer_interrupt+0x23/0x40
> >  [<ffffffff81f9435d>] apic_timer_interrupt+0x6d/0x80
> >  <EOI>  [<ffffffff810c42d5>] ? arch_local_irq_restore+0x12/0x19
> >  [<ffffffff810c5acb>] vprintk_emit+0x3e2/0x40a
> >  [<ffffffff81099995>] ? cpu_maps_update_begin+0x12/0x14
> >  [<ffffffff832e9244>] ? ddebug_setup_query+0x4d/0x4d
> >  [<ffffffff81f80ddd>] printk+0x5c/0x5e
> >  [<ffffffff8135caff>] __dynamic_pr_debug+0x79/0x7b
> >  [<ffffffff810c764d>] ? timekeeping_get_ns.constprop.10+0x12/0x38
> >  [<ffffffff832db12b>] ? init_hw_breakpoint+0xf7/0xf7
> >  [<ffffffff810c7bbb>] ? ktime_get+0x65/0x74
> >  [<ffffffff832db12b>] ? init_hw_breakpoint+0xf7/0xf7
> >  [<ffffffff832e9244>] ? ddebug_setup_query+0x4d/0x4d
> >  [<ffffffff832c4d9d>] do_one_initcall+0x5b/0x12a
> >  [<ffffffff832d09a5>] ? native_smp_prepare_cpus+0x300/0x341
> >  [<ffffffff832c4ed6>] kernel_init_freeable+0x6a/0x195
> >  [<ffffffff81f7c075>] ? rest_init+0xb9/0xb9
> >  [<ffffffff81f7c07e>] kernel_init+0x9/0xd1
> >  [<ffffffff81f9357c>] ret_from_fork+0x7c/0xb0
> >  [<ffffffff81f7c075>] ? rest_init+0xb9/0xb9
> > ---[ end trace 268f4433da36e82f ]---
> > initcall dynamic_debug_init+0x0/0x239 returned 0 after 0 usecs
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Sorry about that, I missed it. This is because context tracking 
> initialization when CONFIG_CONTEXT_TRACKING_FORCE=y is done too late. As 
> a result, the user init task can run with context tracking disabled when 
> it is scheduled for the first time and then later run with context 
> tracking enabled due to the late initialization. And this finally messes 
> up the state of context tracking internal on CPU 0.
> 
> Anyway I fixed this by moving the context tracking initialization 
> earlier, before irqs are enabled and the user init task is created.
> 
> Please check out the branch "timers/nohz-v3".
> 
> Only commit "context_tracking: Ground setup for static key use" which is 
> now 65f382fd0c8fa483713c0971de9f1dfb4cf1ad9c has changed to integrate 
> the fix.
> 
> And following is the diff against the previous branch.

Pulled, thanks Frederic! Seems to be working better now.

Thanks,

	Ingo
