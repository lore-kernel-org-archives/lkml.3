Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419Ab3HIRiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 13:38:55 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39656 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369Ab3HIRix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 13:38:53 -0400
Date: Fri, 9 Aug 2013 10:38:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com
Subject: Re: arm,perf fuzzer and rcu_sched lockup
Message-ID: <20130809173831.GA29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.10.1308091103570.812@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1308091103570.812@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080917-3620-0000-0000-000003E17F51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 11:13:04AM -0400, Vince Weaver wrote:
> 
> This is on a 3.11-rc4 kernel with the two perf/ARM oops patches applied.
> 
> I let the fuzzer run overnight with a serial console hooked up and it was 
> crashed in the morning.  Here's the bug log.
> 
> I'm  cc-ing Dave Jones as I think he's seeing similar traces on x86 with 
> trinity when fuzzing.

Looks like CPU 0 is stuck trying to acquire a lock in kmem_cache_alloc().
Adding the slab allocators guys on CC for their insight.

							Thanx, Paul

> Vince
> 
> [17591.214660] hrtimer: interrupt took 91552 ns
> [17591.231292] NOHZ: local_softirq_pending 100
> [17596.596801] NOHZ: local_softirq_pending 100
> [17629.444610] INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detected by 1, t=2102 jiffies, g=4545, c=4544, q=10)
> [17629.455963] Task dump for CPU 0:
> [17629.455963] perf_fuzzer     R running      0  4985   4228 0x00000000
> [17629.459411] [<c048cf34>] (__schedule+0x4c4/0x748) from [<c0012790>] (no_work_pending+0x8/0x2c)
> 
> ... repeated several hundred times over the course of a few hours
> 
> [79294.544586] INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detected by 1, t=6168611 jiffies, g=4545, c=4544, q=10)
> [79294.544586] Task dump for CPU 0:
> [79294.556213] perf_fuzzer     R running      0  4985   4228 0x00000000
> [79294.566467] [<c048cf34>] (__schedule+0x4c4/0x748) from [<c0012790>] (no_work_pending+0x8/0x2c)
> [79357.584686] INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detected by 1, t=6174916 jiffies, g=4545, c=4544, q=10)
> [79357.596313] Task dump for CPU 0:
> [79357.599761] perf_fuzzer     R running      0  4985   4228 0x00000000
> [79357.599761] [<c048cf34>] (__schedule+0x4c4/0x748) from [<c0012790>] (no_work_pending+0x8/0x2c)
> [79423.164642] INFO: rcu_sched self-detected stall on CPU { 0}  (t=2100 jiffies g=4905 c=4904 q=56)
> [79423.174041] CPU: 0 PID: 4228 Comm: perf_fuzzer Not tainted 3.11.0-rc4 #7
> [79423.181182] [<c001a6ac>] (unwind_backtrace+0x0/0xe0) from [<c0016388>] (show_stack+0x10/0x14)
> [79423.190277] [<c0016388>] (show_stack+0x10/0x14) from [<c0489000>] (dump_stack+0x70/0x8c)
> [79423.198913] [<c0489000>] (dump_stack+0x70/0x8c) from [<c00a0800>] (rcu_check_callbacks+0x1e4/0x66c)
> [79423.208557] [<c00a0800>] (rcu_check_callbacks+0x1e4/0x66c) from [<c0049cc4>] (update_process_times+0x38/0x64)
> [79423.219116] [<c0049cc4>] (update_process_times+0x38/0x64) from [<c008429c>] (tick_sched_handle.isra.9+0x48/0x54)
> [79423.229980] [<c008429c>] (tick_sched_handle.isra.9+0x48/0x54) from [<c00842ec>] (tick_sched_timer+0x44/0x74)
> [79423.240447] [<c00842ec>] (tick_sched_timer+0x44/0x74) from [<c005de68>] (__run_hrtimer+0x104/0x1cc)
> [79423.250091] [<c005de68>] (__run_hrtimer+0x104/0x1cc) from [<c005e8a8>] (hrtimer_interrupt+0x120/0x270)
> [79423.259979] [<c005e8a8>] (hrtimer_interrupt+0x120/0x270) from [<c0018fbc>] (twd_handler+0x34/0x48)
> [79423.269561] [<c0018fbc>] (twd_handler+0x34/0x48) from [<c009b508>] (handle_percpu_devid_irq+0xa8/0x114)
> [79423.279571] [<c009b508>] (handle_percpu_devid_irq+0xa8/0x114) from [<c0097ec4>] (generic_handle_irq+0x20/0x30)
> [79423.290222] [<c0097ec4>] (generic_handle_irq+0x20/0x30) from [<c0013664>] (handle_IRQ+0x68/0x90)
> [79423.299591] [<c0013664>] (handle_IRQ+0x68/0x90) from [<c0008658>] (gic_handle_irq+0x3c/0x60)
> [79423.308593] [<c0008658>] (gic_handle_irq+0x3c/0x60) from [<c048ebc4>] (__irq_svc+0x44/0x58)
> [79423.317474] Exception stack(0xedf5fd68 to 0xedf5fdb0)
> [79423.322845] fd60:                   00000001 00000110 00000000 ed9b0a00 00000002 00000000
> [79423.331542] fd80: edf5e030 c06ee0c0 c00428cc ece65920 0000000a 3f911f7c c0859eb8 edf5fdb0
> [79423.340240] fda0: c00881b0 c0042378 60000113 ffffffff
> [79423.345642] [<c048ebc4>] (__irq_svc+0x44/0x58) from [<c0042378>] (__do_softirq+0xa0/0x26c)
> [79423.354461] [<c0042378>] (__do_softirq+0xa0/0x26c) from [<c00428cc>] (irq_exit+0x84/0xd0)
> [79423.363159] [<c00428cc>] (irq_exit+0x84/0xd0) from [<c0013668>] (handle_IRQ+0x6c/0x90)
> [79423.371582] [<c0013668>] (handle_IRQ+0x6c/0x90) from [<c0008658>] (gic_handle_irq+0x3c/0x60)
> [79423.380584] [<c0008658>] (gic_handle_irq+0x3c/0x60) from [<c048ebc4>] (__irq_svc+0x44/0x58)
> [79423.389465] Exception stack(0xedf5fe20 to 0xedf5fe68)
> [79423.394866] fe20: 00000001 00000110 00000000 ed9b0a00 edf5e000 60000113 000000d0 000000d0
> [79423.403564] fe40: c00e9c64 ece65920 00000001 edf288b8 c0859eb8 edf5fe68 c00881b0 c008aefc
> [79423.412261] fe60: 60000113 ffffffff
> [79423.416015] [<c048ebc4>] (__irq_svc+0x44/0x58) from [<c008aefc>] (lockdep_trace_alloc+0xd0/0xf8)
> [79423.425354] [<c008aefc>] (lockdep_trace_alloc+0xd0/0xf8) from [<c00f39c0>] (kmem_cache_alloc+0x24/0x168)
> [79423.435455] [<c00f39c0>] (kmem_cache_alloc+0x24/0x168) from [<c00e9c64>] (anon_vma_fork+0x54/0x118)
> [79423.445098] [<c00e9c64>] (anon_vma_fork+0x54/0x118) from [<c003c2d8>] (dup_mm+0x180/0x3c0)
> [79423.453887] [<c003c2d8>] (dup_mm+0x180/0x3c0) from [<c003cd68>] (copy_process.part.59+0x808/0xf0c)
> [79423.463439] [<c003cd68>] (copy_process.part.59+0x808/0xf0c) from [<c003d5c4>] (do_fork+0xc0/0x314)
> [79423.472991] [<c003d5c4>] (do_fork+0xc0/0x314) from [<c0012700>] (ret_fast_syscall+0x0/0x48)
> [79486.194641] INFO: rcu_sched self-detected stall on CPU { 0}  (t=8403 jiffies g=4905 c=4904 q=56)
> [79486.194641] CPU: 0 PID: 4228 Comm: perf_fuzzer Not tainted 3.11.0-rc4 #7
> [79486.205200] [<c001a6ac>] (unwind_backtrace+0x0/0xe0) from [<c0016388>] (show_stack+0x10/0x14)
> [79486.214630] [<c0016388>] (show_stack+0x10/0x14) from [<c0489000>] (dump_stack+0x70/0x8c)
> [79486.224639] [<c0489000>] (dump_stack+0x70/0x8c) from [<c00a0800>] (rcu_check_callbacks+0x1e4/0x66c)
> [79486.238555] [<c00a0800>] (rcu_check_callbacks+0x1e4/0x66c) from [<c0049cc4>] (update_process_times+0x38/0x64)
> [79486.249114] [<c0049cc4>] (update_process_times+0x38/0x64) from [<c008429c>] (tick_sched_handle.isra.9+0x48/0x54)
> [79486.259979] [<c008429c>] (tick_sched_handle.isra.9+0x48/0x54) from [<c00842ec>] (tick_sched_timer+0x44/0x74)
> [79486.270446] [<c00842ec>] (tick_sched_timer+0x44/0x74) from [<c005de68>] (__run_hrtimer+0x104/0x1cc)
> [79486.280059] [<c005de68>] (__run_hrtimer+0x104/0x1cc) from [<c005e8a8>] (hrtimer_interrupt+0x120/0x270)
> [79486.289978] [<c005e8a8>] (hrtimer_interrupt+0x120/0x270) from [<c0018fbc>] (twd_handler+0x34/0x48)
> [79486.299530] [<c0018fbc>] (twd_handler+0x34/0x48) from [<c009b508>] (handle_percpu_devid_irq+0xa8/0x114)
> [79486.309539] [<c009b508>] (handle_percpu_devid_irq+0xa8/0x114) from [<c0097ec4>] (generic_handle_irq+0x20/0x30)
> [79486.320190] [<c0097ec4>] (generic_handle_irq+0x20/0x30) from [<c0013664>] (handle_IRQ+0x68/0x90)
> [79486.329559] [<c0013664>] (handle_IRQ+0x68/0x90) from [<c0008658>] (gic_handle_irq+0x3c/0x60)
> [79486.338562] [<c0008658>] (gic_handle_irq+0x3c/0x60) from [<c048ebc4>] (__irq_svc+0x44/0x58)
> [79486.347442] Exception stack(0xedf5fd68 to 0xedf5fdb0)
> [79486.352844] fd60:                   00000001 00000110 00000000 ed9b0a00 00000002 00000000
> [79486.361541] fd80: edf5e030 c06ee0c0 c00428cc ece65920 0000000a 3f911f7c c0859eb8 edf5fdb0
> [79486.370239] fda0: c00881b0 c0042378 60000113 ffffffff
> [79486.375640] [<c048ebc4>] (__irq_svc+0x44/0x58) from [<c0042378>] (__do_softirq+0xa0/0x26c)
> [79486.384460] [<c0042378>] (__do_softirq+0xa0/0x26c) from [<c00428cc>] (irq_exit+0x84/0xd0)
> [79486.393157] [<c00428cc>] (irq_exit+0x84/0xd0) from [<c0013668>] (handle_IRQ+0x6c/0x90)
> [79486.401580] [<c0013668>] (handle_IRQ+0x6c/0x90) from [<c0008658>] (gic_handle_irq+0x3c/0x60)
> [79486.410583] [<c0008658>] (gic_handle_irq+0x3c/0x60) from [<c048ebc4>] (__irq_svc+0x44/0x58)
> [79486.419464] Exception stack(0xedf5fe20 to 0xedf5fe68)
> [79486.424835] fe20: 00000001 00000110 00000000 ed9b0a00 edf5e000 60000113 000000d0 000000d0
> [79486.433563] fe40: c00e9c64 ece65920 00000001 edf288b8 c0859eb8 edf5fe68 c00881b0 c008aefc
> [79486.442260] fe60: 60000113 ffffffff
> [79486.445983] [<c048ebc4>] (__irq_svc+0x44/0x58) from [<c008aefc>] (lockdep_trace_alloc+0xd0/0xf8)
> [79486.455352] [<c008aefc>] (lockdep_trace_alloc+0xd0/0xf8) from [<c00f39c0>] (kmem_cache_alloc+0x24/0x168)
> [79486.465454] [<c00f39c0>] (kmem_cache_alloc+0x24/0x168) from [<c00e9c64>] (anon_vma_fork+0x54/0x118)
> [79486.475097] [<c00e9c64>] (anon_vma_fork+0x54/0x118) from [<c003c2d8>] (dup_mm+0x180/0x3c0)
> [79486.483917] [<c003c2d8>] (dup_mm+0x180/0x3c0) from [<c003cd68>] (copy_process.part.59+0x808/0xf0c)
> [79486.493438] [<c003cd68>] (copy_process.part.59+0x808/0xf0c) from [<c003d5c4>] (do_fork+0xc0/0x314)
> [79486.502990] [<c003d5c4>] (do_fork+0xc0/0x314) from [<c0012700>] (ret_fast_syscall+0x0/0x48)
> [79549.224609] INFO: rcu_sched self-detected stall on CPU { 0}  (t=14706 jiffies g=4905 c=4904 q=56)
> [79549.224670] CPU: 0 PID: 4228 Comm: perf_fuzzer Not tainted 3.11.0-rc4 #7
> [79549.234588] [<c001a6ac>] (unwind_backtrace+0x0/0xe0) from [<c0016388>] (show_stack+0x10/0x14)
> [79549.244720] [<c0016388>] (show_stack+0x10/0x14) from [<c0489000>] (dump_stack+0x70/0x8c)
> [79549.259002] [<c0489000>] (dump_stack+0x70/0x8c) from [<c00a0800>] (rcu_check_callbacks+0x1e4/0x66c)
> [79549.264617] [<c00a0800>] (rcu_check_callbacks+0x1e4/0x66c) from [<c0049cc4>] (update_process_times+0x38/0x64)
> [79549.274627] [<c0049cc4>] (update_process_times+0x38/0x64) from [<c008429c>] (tick_sched_handle.isra.9+0x48/0x54)
> [79549.290039] [<c008429c>] (tick_sched_handle.isra.9+0x48/0x54) from [<c00842ec>] (tick_sched_timer+0x44/0x74)
> [79549.300506] [<c00842ec>] (tick_sched_timer+0x44/0x74) from [<c005de68>] (__run_hrtimer+0x104/0x1cc)
> [79549.304626] [<c005de68>] (__run_hrtimer+0x104/0x1cc) from [<c005e8a8>] (hrtimer_interrupt+0x120/0x270)
> [79549.320068] [<c005e8a8>] (hrtimer_interrupt+0x120/0x270) from [<c0018fbc>] (twd_handler+0x34/0x48)
> [79549.329132] [<c0018fbc>] (twd_handler+0x34/0x48) from [<c009b508>] (handle_percpu_devid_irq+0xa8/0x114)
> [79549.339630] [<c009b508>] (handle_percpu_devid_irq+0xa8/0x114) from [<c0097ec4>] (generic_handle_irq+0x20/0x30)
> [79549.349548] [<c0097ec4>] (generic_handle_irq+0x20/0x30) from [<c0013664>] (handle_IRQ+0x68/0x90)
> [79549.359649] [<c0013664>] (handle_IRQ+0x68/0x90) from [<c0008658>] (gic_handle_irq+0x3c/0x60)
> [79549.364624] [<c0008658>] (gic_handle_irq+0x3c/0x60) from [<c048ebc4>] (__irq_svc+0x44/0x58)
> [79549.374572] Exception stack(0xedf5fd68 to 0xedf5fdb0)
> [79549.374572] fd60:                   00000001 00000110 00000000 ed9b0a00 00000002 00000000
> [79549.384613] fd80: edf5e030 c06ee0c0 c00428cc ece65920 0000000a 3f911f7c c0859eb8 edf5fdb0
> [79549.394622] fda0: c00881b0 c0042378 60000113 ffffffff
> [79549.404571] [<c048ebc4>] (__irq_svc+0x44/0x58) from [<c0042378>] (__do_softirq+0xa0/0x26c)
> [79549.408813] [<c0042378>] (__do_softirq+0xa0/0x26c) from [<c00428cc>] (irq_exit+0x84/0xd0)
> [79549.420379] [<c00428cc>] (irq_exit+0x84/0xd0) from [<c0013668>] (handle_IRQ+0x6c/0x90)
> [79549.424621] [<c0013668>] (handle_IRQ+0x6c/0x90) from [<c0008658>] (gic_handle_irq+0x3c/0x60)
> [79549.440704] [<c0008658>] (gic_handle_irq+0x3c/0x60) from [<c048ebc4>] (__irq_svc+0x44/0x58)
> [79549.449584] Exception stack(0xedf5fe20 to 0xedf5fe68)
> [79549.454589] fe20: 00000001 00000110 00000000 ed9b0a00 edf5e000 60000113 000000d0 000000d0
> [79549.459594] fe40: c00e9c64 ece65920 00000001 edf288b8 c0859eb8 edf5fe68 c00881b0 c008aefc
> [79549.472381] fe60: 60000113 ffffffff
> [79549.476104] [<c048ebc4>] (__irq_svc+0x44/0x58) from [<c008aefc>] (lockdep_trace_alloc+0xd0/0xf8)
> [79549.484588] [<c008aefc>] (lockdep_trace_alloc+0xd0/0xf8) from [<c00f39c0>] (kmem_cache_alloc+0x24/0x168)
> [79549.495574] [<c00f39c0>] (kmem_cache_alloc+0x24/0x168) from [<c00e9c64>] (anon_vma_fork+0x54/0x118)
> [79549.504638] [<c00e9c64>] (anon_vma_fork+0x54/0x118) from [<c003c2d8>] (dup_mm+0x180/0x3c0)
> [79549.504638] [<c003c2d8>] (dup_mm+0x180/0x3c0) from [<c003cd68>] (copy_process.part.59+0x808/0xf0c)
> [79549.514617] [<c003cd68>] (copy_process.part.59+0x808/0xf0c) from [<c003d5c4>] (do_fork+0xc0/0x314)
> [79549.524627] [<c003d5c4>] (do_fork+0xc0/0x314) from [<c0012700>] (ret_fast_syscall+0x0/0x48)
> [79612.254608] INFO: rcu_sched self-detected stall on CPU { 0}  (t=21009 jiffies g=4905 c=4904 q=56)
> [79612.254669] CPU: 0 PID: 4228 Comm: perf_fuzzer Not tainted 3.11.0-rc4 #7
> [79612.264587] [<c001a6ac>] (unwind_backtrace+0x0/0xe0) from [<c0016388>] (show_stack+0x10/0x14)
> [79612.274627] [<c0016388>] (show_stack+0x10/0x14) from [<c0489000>] (dump_stack+0x70/0x8c)
> [79612.274627] [<c0489000>] (dump_stack+0x70/0x8c) from [<c00a0800>] (rcu_check_callbacks+0x1e4/0x66c)
> [79612.298645] [<c00a0800>] (rcu_check_callbacks+0x1e4/0x66c) from [<c0049cc4>] (update_process_times+0x38/0x64)
> [79612.306060] [<c0049cc4>] (update_process_times+0x38/0x64) from [<c008429c>] (tick_sched_handle.isra.9+0x48/0x54)
> [79612.319946] [<c008429c>] (tick_sched_handle.isra.9+0x48/0x54) from [<c00842ec>] (tick_sched_timer+0x44/0x74)
> [79612.329254] [<c00842ec>] (tick_sched_timer+0x44/0x74) from [<c005de68>] (__run_hrtimer+0x104/0x1cc)
> [79612.340179] [<c005de68>] (__run_hrtimer+0x104/0x1cc) from [<c005e8a8>] (hrtimer_interrupt+0x120/0x270)
> [79612.344635] [<c005e8a8>] (hrtimer_interrupt+0x120/0x270) from [<c0018fbc>] (twd_handler+0x34/0x48)
> [79612.354614] [<c0018fbc>] (twd_handler+0x34/0x48) from [<c009b508>] (handle_percpu_devid_irq+0xa8/0x114)
> [79612.364624] [<c009b508>] (handle_percpu_devid_irq+0xa8/0x114) from [<c0097ec4>] (generic_handle_irq+0x20/0x30)
> [79612.380340] [<c0097ec4>] (generic_handle_irq+0x20/0x30) from [<c0013664>] (handle_IRQ+0x68/0x90)
> [79612.388854] [<c0013664>] (handle_IRQ+0x68/0x90) from [<c0008658>] (gic_handle_irq+0x3c/0x60)
> [79612.394653] [<c0008658>] (gic_handle_irq+0x3c/0x60) from [<c048ebc4>] (__irq_svc+0x44/0x58)
> [79612.407592] Exception stack(0xedf5fd68 to 0xedf5fdb0)
> [79612.407592] fd60:                   00000001 00000110 00000000 ed9b0a00 00000002 00000000
> [79612.421691] fd80: edf5e030 c06ee0c0 c00428cc ece65920 0000000a 3f911f7c c0859eb8 edf5fdb0
> [79612.427490] fda0: c00881b0 c0042378 60000113 ffffffff
> [79612.434600] [<c048ebc4>] (__irq_svc+0x44/0x58) from [<c0042378>] (__do_softirq+0xa0/0x26c)
> [79612.444580] [<c0042378>] (__do_softirq+0xa0/0x26c) from [<c00428cc>] (irq_exit+0x84/0xd0)
> [79612.453308] [<c00428cc>] (irq_exit+0x84/0xd0) from [<c0013668>] (handle_IRQ+0x6c/0x90)
> [79612.455871] [<c0013668>] (handle_IRQ+0x6c/0x90) from [<c0008658>] (gic_handle_irq+0x3c/0x60)
> [79612.464599] [<c0008658>] (gic_handle_irq+0x3c/0x60) from [<c048ebc4>] (__irq_svc+0x44/0x58)
> [79612.479644] Exception stack(0xedf5fe20 to 0xedf5fe68)
> [79612.484588] fe20: 00000001 00000110 00000000 ed9b0a00 edf5e000 60000113 000000d0 000000d0
> [79612.489532] fe40: c00e9c64 ece65920 00000001 edf288b8 c0859eb8 edf5fe68 c00881b0 c008aefc
> [79612.494598] fe60: 60000113 ffffffff
> [79612.504638] [<c048ebc4>] (__irq_svc+0x44/0x58) from [<c008aefc>] (lockdep_trace_alloc+0xd0/0xf8)
> [79612.514617] [<c008aefc>] (lockdep_trace_alloc+0xd0/0xf8) from [<c00f39c0>] (kmem_cache_alloc+0x24/0x168)
> [79612.524627] [<c00f39c0>] (kmem_cache_alloc+0x24/0x168) from [<c00e9c64>] (anon_vma_fork+0x54/0x118)
> [79612.534606] [<c00e9c64>] (anon_vma_fork+0x54/0x118) from [<c003c2d8>] (dup_mm+0x180/0x3c0)
> [79612.544097] [<c003c2d8>] (dup_mm+0x180/0x3c0) from [<c003cd68>] (copy_process.part.59+0x808/0xf0c)
> [79612.553649] [<c003cd68>] (copy_process.part.59+0x808/0xf0c) from [<c003d5c4>] (do_fork+0xc0/0x314)
> [79612.555541] [<c003d5c4>] (do_fork+0xc0/0x314) from [<c0012700>] (ret_fast_syscall+0x0/0x48)
> [79675.284637] INFO: rcu_sched self-detected stall on CPU { 0}  (t=27312 jiffies g=4905 c=4904 q=56)
> [79675.294128] CPU: 0 PID: 4228 Comm: perf_fuzzer Not tainted 3.11.0-rc4 #7
> [79675.301269] [<c001a6ac>] (unwind_backtrace+0x0/0xe0) from [<c0016388>] (show_stack+0x10/0x14)
> [79675.310363] [<c0016388>] (show_stack+0x10/0x14) from [<c0489000>] (dump_stack+0x70/0x8c)
> [79675.319000] [<c0489000>] (dump_stack+0x70/0x8c) from [<c00a0800>] (rcu_check_callbacks+0x1e4/0x66c)
> [79675.328643] [<c00a0800>] (rcu_check_callbacks+0x1e4/0x66c) from [<c0049cc4>] (update_process_times+0x38/0x64)
> [79675.339233] [<c0049cc4>] (update_process_times+0x38/0x64) from [<c008429c>] (tick_sched_handle.isra.9+0x48/0x54)
> [79675.350067] [<c008429c>] (tick_sched_handle.isra.9+0x48/0x54) from [<c00842ec>] (tick_sched_timer+0x44/0x74)
> [79675.360534] [<c00842ec>] (tick_sched_timer+0x44/0x74) from [<c005de68>] (__run_hrtimer+0x104/0x1cc)
> [79675.370178] [<c005de68>] (__run_hrtimer+0x104/0x1cc) from [<c005e8a8>] (hrtimer_interrupt+0x120/0x270)
> [79675.380096] [<c005e8a8>] (hrtimer_interrupt+0x120/0x270) from [<c0018fbc>] (twd_handler+0x34/0x48)
> [79675.389617] [<c0018fbc>] (twd_handler+0x34/0x48) from [<c009b508>] (handle_percpu_devid_irq+0xa8/0x114)
> [79675.399658] [<c009b508>] (handle_percpu_devid_irq+0xa8/0x114) from [<c0097ec4>] (generic_handle_irq+0x20/0x30)
> [79675.410308] [<c0097ec4>] (generic_handle_irq+0x20/0x30) from [<c0013664>] (handle_IRQ+0x68/0x90)
> [79675.419677] [<c0013664>] (handle_IRQ+0x68/0x90) from [<c0008658>] (gic_handle_irq+0x3c/0x60)
> [79675.428680] [<c0008658>] (gic_handle_irq+0x3c/0x60) from [<c048ebc4>] (__irq_svc+0x44/0x58)
> [79675.437561] Exception stack(0xedf5fd68 to 0xedf5fdb0)
> [79675.442962] fd60:                   00000001 00000110 00000000 ed9b0a00 00000002 00000000
> [79675.451660] fd80: edf5e030 c06ee0c0 c00428cc ece65920 0000000a 3f911f7c c0859eb8 edf5fdb0
> [79675.460357] fda0: c00881b0 c0042378 60000113 ffffffff
> [79675.465759] [<c048ebc4>] (__irq_svc+0x44/0x58) from [<c0042378>] (__do_softirq+0xa0/0x26c)
> [79675.474548] [<c0042378>] (__do_softirq+0xa0/0x26c) from [<c00428cc>] (irq_exit+0x84/0xd0)
> [79675.483276] [<c00428cc>] (irq_exit+0x84/0xd0) from [<c0013668>] (handle_IRQ+0x6c/0x90)
> [79675.491699] [<c0013668>] (handle_IRQ+0x6c/0x90) from [<c0008658>] (gic_handle_irq+0x3c/0x60)
> [79675.500701] [<c0008658>] (gic_handle_irq+0x3c/0x60) from [<c048ebc4>] (__irq_svc+0x44/0x58)
> 

