Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab3KHWhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 17:37:09 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36115 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757706Ab3KHWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 17:37:04 -0500
Date: Fri, 8 Nov 2013 23:36:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131108223657.GF14606@localhost.localdomain>
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

And another one, I wonder if actually the problem is on the perf NMI handler
itself, look below:

[  237.192886] ------------[ cut here ]------------
[  237.197385] WARNING: CPU: 2 PID: 1016 at kernel/watchdog.c:246 watchdog_overflow_callback+0x9a/0xc0()
[  237.206562] Watchdog detected hard LOCKUP on cpu 2
[  237.211152] Modules linked in:
[  237.214361] CPU: 2 PID: 1016 Comm: out Not tainted 3.12.0+ #47
[  237.220160] Hardware name: FUJITSU SIEMENS AMD690VM-FMH/AMD690VM-FMH, BIOS V5.13 03/14/2008
[  237.228475]  00000000000000f6 ffff880107d07bd8 ffffffff815bac1a ffff8800cda34f60
[  237.235834]  ffff880107d07c28 ffff880107d07c18 ffffffff8104dffc ffff880107d07e08
[  237.243192]  ffff880103d58000 0000000000000000 ffff880107d07d38 0000000000000000
[  237.250556] Call Trace:
[  237.252984]  <NMI>  [<ffffffff815bac1a>] dump_stack+0x4f/0x7c
[  237.258706]  [<ffffffff8104dffc>] warn_slowpath_common+0x8c/0xc0
[  237.264682]  [<ffffffff8104e0e6>] warn_slowpath_fmt+0x46/0x50
[  237.270397]  [<ffffffff810ef2ea>] watchdog_overflow_callback+0x9a/0xc0
[  237.276895]  [<ffffffff8111bc78>] __perf_event_overflow+0x98/0x310
[  237.283045]  [<ffffffff81118a40>] ? perf_event_task_disable+0x90/0x90
[  237.289453]  [<ffffffff8111cb44>] perf_event_overflow+0x14/0x20
[  237.295344]  [<ffffffff81019eda>] x86_pmu_handle_irq+0x12a/0x180
[  237.301319]  [<ffffffff81018ad4>] perf_event_nmi_handler+0x34/0x60
[  237.307464]  [<ffffffff81006f76>] nmi_handle.isra.3+0xc6/0x3e0
[  237.313271]  [<ffffffff81006eb5>] ? nmi_handle.isra.3+0x5/0x3e0
[  237.319163]  [<ffffffff8102fd60>] ? perf_ibs_handle_irq+0x420/0x420
[  237.325397]  [<ffffffff810073a0>] do_nmi+0x110/0x390
[  237.330336]  [<ffffffff815c9631>] end_repeat_nmi+0x1e/0x2e
[  237.335792]  [<ffffffff81005045>] ? dump_trace+0x75/0x2f0
[  237.341162]  [<ffffffff81005045>] ? dump_trace+0x75/0x2f0
[  237.346532]  [<ffffffff81005045>] ? dump_trace+0x75/0x2f0
[  237.351900]  <<EOE>>  <IRQ>  [<ffffffff8105ec15>] ? __sigqueue_alloc+0x5/0x280
[  237.359091]  [<ffffffff8101a4d1>] perf_callchain_kernel+0x51/0x70
[  237.365155]  [<ffffffff8111fec6>] perf_callchain+0x256/0x2c0
[  237.370783]  [<ffffffff8111bb5b>] perf_prepare_sample+0x27b/0x300
[  237.376849]  [<ffffffff810bc1ea>] ? __rcu_is_watching+0x1a/0x30
[  237.382736]  [<ffffffff8111bd2c>] __perf_event_overflow+0x14c/0x310
[  237.388973]  [<ffffffff8111bcd9>] ? __perf_event_overflow+0xf9/0x310
[  237.395291]  [<ffffffff8109aa6d>] ? trace_hardirqs_off+0xd/0x10
[  237.401186]  [<ffffffff815c8753>] ? _raw_spin_unlock_irqrestore+0x53/0x90
[  237.407941]  [<ffffffff81061b46>] ? do_send_sig_info+0x66/0x90
[  237.413744]  [<ffffffff8111c0f9>] perf_swevent_overflow+0xa9/0xc0
[  237.419808]  [<ffffffff8111c16f>] perf_swevent_event+0x5f/0x80
[  237.425610]  [<ffffffff8111c2b8>] perf_tp_event+0x128/0x420
[  237.431154]  [<ffffffff81008108>] ? smp_trace_irq_work_interrupt+0x98/0x2a0
[  237.438085]  [<ffffffff815c83b5>] ? _raw_read_unlock+0x35/0x60
[  237.443887]  [<ffffffff81003fe7>] perf_trace_x86_irq_vector+0xc7/0xe0
[  237.450295]  [<ffffffff81008108>] ? smp_trace_irq_work_interrupt+0x98/0x2a0
[  237.457226]  [<ffffffff81008108>] smp_trace_irq_work_interrupt+0x98/0x2a0
[  237.463983]  [<ffffffff815cb132>] trace_irq_work_interrupt+0x72/0x80
[  237.470303]  [<ffffffff815c8fb7>] ? retint_restore_args+0x13/0x13
[  237.476366]  [<ffffffff815c877a>] ? _raw_spin_unlock_irqrestore+0x7a/0x90
[  237.483117]  [<ffffffff810c101b>] rcu_process_callbacks+0x1db/0x530
[  237.489360]  [<ffffffff8105381d>] __do_softirq+0xdd/0x490
[  237.494728]  [<ffffffff81053fe6>] irq_exit+0x96/0xc0
[  237.499668]  [<ffffffff815cbc3a>] smp_trace_apic_timer_interrupt+0x5a/0x2b4
[  237.506596]  [<ffffffff815ca7b2>] trace_apic_timer_interrupt+0x72/0x80
[  237.513083]  <EOI>  [<ffffffff812ef38a>] ? delay_tsc+0x6a/0xc0
[  237.518895]  [<ffffffff812ef382>] ? delay_tsc+0x62/0xc0
[  237.524091]  [<ffffffff812ef27f>] __delay+0xf/0x20
[  237.528856]  [<ffffffff812ef2b7>] __const_udelay+0x27/0x30
[  237.534313]  [<ffffffff810ba31c>] __rcu_read_unlock+0x5c/0xa0
[  237.540029]  [<ffffffff81122255>] find_get_page+0xf5/0x220
[  237.545485]  [<ffffffff81122165>] ? find_get_page+0x5/0x220
[  237.551031]  [<ffffffff8112497b>] filemap_fault+0x8b/0x500
[  237.556487]  [<ffffffff81148459>] __do_fault+0x69/0x4f0
[  237.561682]  [<ffffffff8114c6dc>] handle_mm_fault+0x18c/0x940
[  237.567400]  [<ffffffff81042c71>] ? __do_page_fault+0x111/0x4e0
[  237.573289]  [<ffffffff8109af14>] ? __lock_is_held+0x54/0x70
[  237.578913]  [<ffffffff81042cde>] __do_page_fault+0x17e/0x4e0
[  237.584636]  [<ffffffff812ef3a8>] ? delay_tsc+0x88/0xc0
[  237.589831]  [<ffffffff812ef27f>] ? __delay+0xf/0x20
[  237.594769]  [<ffffffff812ef2b7>] ? __const_udelay+0x27/0x30
[  237.600399]  [<ffffffff810ba31c>] ? __rcu_read_unlock+0x5c/0xa0
[  237.606290]  [<ffffffff812f06ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  237.612785]  [<ffffffff8104307e>] do_page_fault+0xe/0x10
[  237.618069]  [<ffffffff815c9228>] page_fault+0x28/0x30
[  237.623178] ---[ end trace 40cda30d05d0ffa6 ]---
[  237.627769] perf samples too long (3397569 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[  237.637124] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 444.233 msecs

444 msecs is huge.

[  247.186562] perf samples too long (3371028 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[  257.180241] perf samples too long (3344694 > 10000), lowering kernel.perf_event_max_sample_rate to 13000
[  267.173920] perf samples too long (3318566 > 19230), lowering kernel.perf_event_max_sample_rate to 7000
[  277.167598] perf samples too long (3292642 > 35714), lowering kernel.perf_event_max_sample_rate to 4000
[  287.161277] perf samples too long (3266920 > 62500), lowering kernel.perf_event_max_sample_rate to 2000
[  297.154956] perf samples too long (3241400 > 125000), lowering kernel.perf_event_max_sample_rate to 1000
