Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaHGNQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:16:53 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54325 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283AbaHGNQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:16:52 -0400
Date: Thu, 7 Aug 2014 15:16:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: nohz fail (was: perf related boot hang.)
Message-ID: <20140807131646.GB19662@localhost.localdomain>
References: <20140806143621.GA13832@redhat.com>
 <20140806161934.GF19379@twins.programming.kicks-ass.net>
 <20140806194656.GA11570@redhat.com>
 <20140807090333.GL19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807090333.GL19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 11:03:33AM +0200, Peter Zijlstra wrote:
> On Wed, Aug 06, 2014 at 03:46:56PM -0400, Dave Jones wrote:
> > This one happened during runtime, but I got a whole stack..
> > 
> > 
> >  Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 2
> >  CPU: 2 PID: 7538 Comm: kworker/u8:8 Not tainted 3.16.0+ #34
> >  Workqueue: btrfs-endio-write normal_work_helper [btrfs]
> >   ffff880244c06c88 000000001b486fe1 ffff880244c06bf0 ffffffff8a7f1e37
> >   ffffffff8ac52a18 ffff880244c06c78 ffffffff8a7ef928 0000000000000010
> >   ffff880244c06c88 ffff880244c06c20 000000001b486fe1 0000000000000000
> >  Call Trace:
> >   <NMI>  [<ffffffff8a7f1e37>] dump_stack+0x4e/0x7a
> >   [<ffffffff8a7ef928>] panic+0xd4/0x207
> >   [<ffffffff8a1450e8>] watchdog_overflow_callback+0x118/0x120
> >   [<ffffffff8a186b0e>] __perf_event_overflow+0xae/0x350
> >   [<ffffffff8a184f80>] ? perf_event_task_disable+0xa0/0xa0
> >   [<ffffffff8a01a4cf>] ? x86_perf_event_set_period+0xbf/0x150
> >   [<ffffffff8a187934>] perf_event_overflow+0x14/0x20
> >   [<ffffffff8a020386>] intel_pmu_handle_irq+0x206/0x410
> >   [<ffffffff8a01937b>] perf_event_nmi_handler+0x2b/0x50
> >   [<ffffffff8a007b72>] nmi_handle+0xd2/0x390
> >   [<ffffffff8a007aa5>] ? nmi_handle+0x5/0x390
> >   [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
> >   [<ffffffff8a008062>] default_do_nmi+0x72/0x1c0
> >   [<ffffffff8a008268>] do_nmi+0xb8/0x100
> >   [<ffffffff8a7ff66a>] end_repeat_nmi+0x1e/0x2e
> >   [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
> >   [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
> >   [<ffffffff8a0cb7f8>] ? match_held_lock+0x8/0x1b0
> 
> Ok so that part is just the watchdog triggering, so the below part is
> the screwy bit:
> 
> >   <<EOE>>  <IRQ>  [<ffffffff8a0ccd2f>] lock_acquired+0xaf/0x450
> >   [<ffffffff8a0f74c5>] ? lock_hrtimer_base.isra.20+0x25/0x50
> >   [<ffffffff8a7fc678>] _raw_spin_lock_irqsave+0x78/0x90
> >   [<ffffffff8a0f74c5>] ? lock_hrtimer_base.isra.20+0x25/0x50
> >   [<ffffffff8a0f74c5>] lock_hrtimer_base.isra.20+0x25/0x50
> >   [<ffffffff8a0f7723>] hrtimer_try_to_cancel+0x33/0x1e0
> >   [<ffffffff8a0f78ea>] hrtimer_cancel+0x1a/0x30
> >   [<ffffffff8a109237>] tick_nohz_restart+0x17/0x90
> >   [<ffffffff8a10a213>] __tick_nohz_full_check+0xc3/0x100
> >   [<ffffffff8a10a25e>] nohz_full_kick_work_func+0xe/0x10
> >   [<ffffffff8a17c884>] irq_work_run_list+0x44/0x70
> >   [<ffffffff8a17c8da>] irq_work_run+0x2a/0x50
> >   [<ffffffff8a0f700b>] update_process_times+0x5b/0x70
> >   [<ffffffff8a109005>] tick_sched_handle.isra.21+0x25/0x60
> >   [<ffffffff8a109b81>] tick_sched_timer+0x41/0x60
> >   [<ffffffff8a0f7aa2>] __run_hrtimer+0x72/0x470
> >   [<ffffffff8a109b40>] ? tick_sched_do_timer+0xb0/0xb0
> >   [<ffffffff8a0f8707>] hrtimer_interrupt+0x117/0x270
> >   [<ffffffff8a034357>] local_apic_timer_interrupt+0x37/0x60
> >   [<ffffffff8a80010f>] smp_apic_timer_interrupt+0x3f/0x50
> >   [<ffffffff8a7fe52f>] apic_timer_interrupt+0x6f/0x80
> 
> And that looks like someone trying to cancel a timer from a timer, I
> guess that won't work, seeing how cancel will wait for the timer handler
> completion etc.
> 
> This is because of the fallback irq_work_run() in the tick
> (update_process_times).
> 

Indeed, I saw that too but very rarely. The nohz kick needs to restart
the tick asynchronously (so we use irq work) and all is fine as long as
irq work actually runs through the irq work IRQ. But when it triggers
through the tick, that's when we fail like above. This should be a rare
scenario for archs that support raising irq_work, but it can happen.

I've been considering to check and restart the tick from irq exit. But
that's going to add extra checks on all IRQs.

Ideally we should be able to force IRQ work on irq work interrupt when
we know that the arch supports it (except for lazy ones). In fact that
alone is a requisite for nohz full itself. If the arch can't raise irq_work
IRQs, nohz full can't work anyway. So soon or later I knew that one day I'd
need to add a check for that.
