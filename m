Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab3KHWY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 17:24:57 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:36292 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab3KHWYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 17:24:55 -0500
Date: Fri, 8 Nov 2013 23:24:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131108222444.GE14606@localhost.localdomain>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
 <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 04:15:21PM -0500, Vince Weaver wrote:
> On Fri, 8 Nov 2013, Frederic Weisbecker wrote:
> 
> > On Fri, Nov 08, 2013 at 03:23:07PM -0500, Vince Weaver wrote:
> > > On Fri, 8 Nov 2013, Frederic Weisbecker wrote:
> > > > 
> > > > There seem to be a loop that takes too long in intel_pmu_handle_irq(). Your two
> > > > previous reports seemed to suggest that lbr is involved, but not this one.
> > > 
> > > I may be wrong but I think everything between <NMI> and <EOE> is just
> > > noise from the NMI perf-event watchdog timer kicking in.
> > 
> > Ah good point.
> > 
> > So the pattern seem to be that irq work/perf_event_wakeup is involved, may be
> > interrupting a tracepoint event or so.
> 
> I managed to construct a reproducible test case, which is attached.  I 
> sometimes have to run it 5-10 times before it triggers.
> 

Ah with this I can reproduce. I need to run it into a loop for a few seconds to trigger it:

[   91.750943] ------------[ cut here ]------------
[   91.755440] WARNING: CPU: 1 PID: 968 at kernel/watchdog.c:246 watchdog_overflow_callback+0x9a/0xc0()
[   91.764530] Watchdog detected hard LOCKUP on cpu 1
[   91.769121] Modules linked in:
[   91.772328] CPU: 1 PID: 968 Comm: out Not tainted 3.12.0+ #47
[   91.778042] Hardware name: FUJITSU SIEMENS AMD690VM-FMH/AMD690VM-FMH, BIOS V5.13 03/14/2008
[   91.786358]  00000000000000f6 ffff880107c87bd8 ffffffff815bac1a ffff8800cd0bafa0
[   91.793714]  ffff880107c87c28 ffff880107c87c18 ffffffff8104dffc ffff880107c87e08
[   91.801076]  ffff880103d20000 0000000000000000 ffff880107c87d38 0000000000000000
[   91.808444] Call Trace:
[   91.810869]  <NMI>  [<ffffffff815bac1a>] dump_stack+0x4f/0x7c
[   91.816589]  [<ffffffff8104dffc>] warn_slowpath_common+0x8c/0xc0
[   91.822564]  [<ffffffff8104e0e6>] warn_slowpath_fmt+0x46/0x50
[   91.828281]  [<ffffffff810ef2ea>] watchdog_overflow_callback+0x9a/0xc0
[   91.834777]  [<ffffffff8111bc78>] __perf_event_overflow+0x98/0x310
[   91.840928]  [<ffffffff81118a40>] ? perf_event_task_disable+0x90/0x90
[   91.847336]  [<ffffffff8111cb44>] perf_event_overflow+0x14/0x20
[   91.853227]  [<ffffffff81019eda>] x86_pmu_handle_irq+0x12a/0x180
[   91.859198]  [<ffffffff81018ad4>] perf_event_nmi_handler+0x34/0x60
[   91.865353]  [<ffffffff81006f76>] nmi_handle.isra.3+0xc6/0x3e0
[   91.871154]  [<ffffffff81006eb5>] ? nmi_handle.isra.3+0x5/0x3e0
[   91.877045]  [<ffffffff8102fd60>] ? perf_ibs_handle_irq+0x420/0x420
[   91.883275]  [<ffffffff810073a0>] do_nmi+0x110/0x390
[   91.888219]  [<ffffffff815c9631>] end_repeat_nmi+0x1e/0x2e
[   91.893676]  [<ffffffff812ef38d>] ? delay_tsc+0x6d/0xc0
[   91.898871]  [<ffffffff812ef38d>] ? delay_tsc+0x6d/0xc0
[   91.904068]  [<ffffffff812ef38d>] ? delay_tsc+0x6d/0xc0
[   91.909258]  <<EOE>>  <IRQ>  [<ffffffff812ef27f>] __delay+0xf/0x20
[   91.915415]  [<ffffffff812ef2b7>] __const_udelay+0x27/0x30
[   91.920873]  [<ffffffff810ba31c>] __rcu_read_unlock+0x5c/0xa0
[   91.926589]  [<ffffffff811815b3>] kill_fasync+0x163/0x2a0
[   91.931958]  [<ffffffff81181476>] ? kill_fasync+0x26/0x2a0
[   91.937414]  [<ffffffff812ef2b7>] ? __const_udelay+0x27/0x30
[   91.943045]  [<ffffffff8111988e>] perf_event_wakeup+0x15e/0x290
[   91.948935]  [<ffffffff81119730>] ? __perf_event_task_sched_out+0x540/0x540
[   91.955864]  [<ffffffff811199f7>] perf_pending_event+0x37/0x60
[   91.961667]  [<ffffffff81112bb7>] __irq_work_run+0x77/0xa0
[   91.967122]  [<ffffffff81112c58>] irq_work_run+0x18/0x30
[   91.972404]  [<ffffffff810080ad>] smp_trace_irq_work_interrupt+0x3d/0x2a0
[   91.979163]  [<ffffffff815cb132>] trace_irq_work_interrupt+0x72/0x80
[   91.985486]  [<ffffffff815c8fb7>] ? retint_restore_args+0x13/0x13
[   91.991548]  [<ffffffff815c877a>] ? _raw_spin_unlock_irqrestore+0x7a/0x90
[   91.998305]  [<ffffffff810c101b>] rcu_process_callbacks+0x1db/0x530
[   92.004541]  [<ffffffff8105381d>] __do_softirq+0xdd/0x490
[   92.009911]  [<ffffffff81053fe6>] irq_exit+0x96/0xc0
[   92.014849]  [<ffffffff815cbc3a>] smp_trace_apic_timer_interrupt+0x5a/0x2b4
[   92.021777]  [<ffffffff815ca7b2>] trace_apic_timer_interrupt+0x72/0x80
[   92.028264]  <EOI>  [<ffffffff81180a95>] ? f_setown+0x5/0x150
[   92.033990]  [<ffffffff81180d3a>] ? SyS_fcntl+0xda/0x640
[   92.039267]  [<ffffffff812f06ae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   92.045683]  [<ffffffff815c9aa9>] system_call_fastpath+0x16/0x1b
[   92.051657] ---[ end trace cd18ca1175c8c7fd ]---
[   92.056246] perf samples too long (2385259 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[   92.065604] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 314.659 msecs
[  101.744824] perf samples too long (2366626 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[  111.738707] perf samples too long (2348139 > 10000), lowering kernel.perf_event_max_sample_rate to 13000
[  121.732589] perf samples too long (2329797 > 19230), lowering kernel.perf_event_max_sample_rate to 7000
[  131.726473] perf samples too long (2311632 > 35714), lowering kernel.perf_event_max_sample_rate to 4000
[  141.720356] perf samples too long (2293575 > 62500), lowering kernel.perf_event_max_sample_rate to 2000
[  151.714239] perf samples too long (2275693 > 125000), lowering kernel.perf_event_max_sample_rate to 1000
