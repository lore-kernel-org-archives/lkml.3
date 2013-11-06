Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab3KFUEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:04:40 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:59670 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754823Ab3KFUEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:04:39 -0500
Date: Wed, 6 Nov 2013 15:04:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kees Cook <keescook@google.com>
Subject: Re: [GIT PULL][PATCH] perf/ftrace: Fix paranoid level for enabling
 function tracer
Message-ID: <20131106150437.7bccfb68@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1311061501450.26837@vincent-weaver-1.um.maine.edu>
References: <20131105162407.59393ee1@gandalf.local.home>
	<alpine.DEB.2.10.1311061444160.26837@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1311061501450.26837@vincent-weaver-1.um.maine.edu>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 15:04:17 -0500 (EST)
Vince Weaver <vincent.weaver@maine.edu> wrote:

> On Wed, 6 Nov 2013, Vince Weaver wrote:
>  
> > I've run this patch on top of 3.12 and it seems pretty solid.
> > I've run my perf_fuzzer for hours (which wasn't possible w/o 
> > quickly crashing on a stock kernel).
> 
> It turns out there are still tracepoint issues though.

This is a different bug.

> 
> I managed to lock my machine hard, even with the patch, but it took a few 
> hours to trigger:
> 
> [11559.476002] WARNING: CPU: 0 PID: 2994 at kernel/watchdog.c:245 watchdog_overflow_callback+0x9b/0xa6()
> [11559.476002] Watchdog detected hard LOCKUP on cpu 0
> [11559.476002] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg evdev coretemp acpi_cpufreq psmouse serio_raw video wmi pcspkr processor thermal_sys button mcs7830 i2c_nforce2 ohci_pci usbnet ohci_hcd sg ehci_pci ehci_hcd sd_mod usbcore usb_common
> [11559.476002] CPU: 0 PID: 2994 Comm: perf_fuzzer Tainted: G        W    3.12.0 #2
> [11559.476002] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
> [11559.476002]  00000000000000f5 ffff88011fc07c48 ffffffff8151aad6 ffff88011fc07c58
> [11559.476002]  ffffffff8103cd68 ffff88011fc07c78 ffffffff810a101c ffff88011b313400
> [11559.476002]  ffff88011fc07ef8 ffff88011fc07d58 0000000000000000 ffff88011fc07ca8
> [11559.476002] Call Trace:
> [11559.476002]  <NMI>  [<ffffffff8151aad6>] ? dump_stack+0x41/0x53
> [11559.476002]  [<ffffffff8103cd68>] ? warn_slowpath_common+0x81/0x9c
> [11559.476002]  [<ffffffff810a101c>] ? watchdog_overflow_callback+0x9b/0xa6
> [11559.476002]  [<ffffffff8103ce25>] ? warn_slowpath_fmt+0x46/0x48
> [11559.476002]  [<ffffffff810c9e5b>] ? perf_prepare_sample+0x1d0/0x2f4
> [11559.476002]  [<ffffffff810a101c>] ? watchdog_overflow_callback+0x9b/0xa6
> [11559.476002]  [<ffffffff810ca4a2>] ? __perf_event_overflow+0x12e/0x1ab
> [11559.476002]  [<ffffffff810167d3>] ? intel_pmu_lbr_read+0x253/0x349
> [11559.476002]  [<ffffffff81018c95>] ? intel_pmu_handle_irq+0x2b8/0x34d
> [11559.476002]  [<ffffffff8101866a>] ? intel_pmu_enable_all+0x4e/0xa7
> [11559.476002]  [<ffffffff8151edfc>] ? nmi_handle+0xa8/0x13a
> [11559.476002]  [<ffffffff8151f473>] ? perf_event_nmi_handler+0x24/0x3d
> [11559.476002]  [<ffffffff8151edb2>] ? nmi_handle+0x5e/0x13a
> [11559.476002]  [<ffffffff8151ef35>] ? do_nmi+0xa7/0x2bd
> [11559.476002]  [<ffffffff8151e537>] ? end_repeat_nmi+0x1e/0x2e
> [11559.476002]  [<ffffffff81049982>] ? __sigqueue_alloc+0x9e/0xc4
> [11559.476002]  [<ffffffff81049982>] ? __sigqueue_alloc+0x9e/0xc4
> [11559.476002]  [<ffffffff81049982>] ? __sigqueue_alloc+0x9e/0xc4
> [11559.476002]  <<EOE>>  <IRQ>  [<ffffffff8104acaa>] ? __send_signal+0xd8/0x26f

Can you find the exact location of __send_signal()?

-- Steve

> [11559.476002]  [<ffffffff8104b074>] ? do_send_sig_info+0x4b/0x75
> [11559.476002]  [<ffffffff810ca8a5>] ? perf_tp_event+0xe9/0x1f6
> [11559.476002]  [<ffffffff8111f65e>] ? send_sigio_to_task+0xc6/0xf5
> [11559.476002]  [<ffffffff8111f737>] ? send_sigio+0xaa/0xdd
> [11559.476002]  [<ffffffff8111f7d3>] ? kill_fasync+0x69/0x86
> [11559.476002]  [<ffffffff810cabf9>] ? perf_event_wakeup+0x8c/0xa1
> [11559.476002]  [<ffffffff810c494d>] ? __irq_work_run+0x5f/0x7b
> [11559.476002]  [<ffffffff81005f82>] ? smp_trace_irq_work_interrupt+0x4b/0x7e
> [11559.476002]  [<ffffffff815261ca>] ? trace_irq_work_interrupt+0x6a/0x70
> [11559.476002]  [<ffffffff810461bf>] ? perf_trace_timer_class+0x39/0x98
> [11559.476002]  [<ffffffff8151da07>] ? _raw_spin_unlock_irqrestore+0xf/0x11
> [11559.476002]  [<ffffffff810a3a89>] ? rcu_process_callbacks+0x4a4/0x4b8
> [11559.476002]  [<ffffffff8105b8f3>] ? enqueue_hrtimer+0x51/0x7b
> [11559.476002]  [<ffffffff81041027>] ? __do_softirq+0x102/0x208
> [11559.476002]  [<ffffffff81027608>] ? lapic_next_event+0x1d/0x21
> [11559.476002]  [<ffffffff8105c187>] ? hrtimer_interrupt+0x119/0x1c6
> [11559.476002]  [<ffffffff815263dc>] ? call_softirq+0x1c/0x30
> [11559.476002]  [<ffffffff810041b9>] ? do_softirq+0x38/0x6d
> [11559.476002]  [<ffffffff81040d1c>] ? irq_exit+0x45/0xa1
> [11559.476002]  [<ffffffff81526a14>] ? smp_trace_apic_timer_interrupt+0x83/0x91
> [11559.476002]  [<ffffffff8152597a>] ? trace_apic_timer_interrupt+0x6a/0x70
> [11559.476002]  <EOI> 
> [11559.476002] ---[ end trace 1274fa8d9fb13c66 ]---
> [11559.476002] perf samples too long (7791497 > 10000), lowering kernel.perf_event_max_sample_rate to 12500
> [11559.476002] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 1025.396 msecs
> [11570.756001] perf samples too long (7730632 > 20000), lowering kernel.perf_event_max_sample_rate to 6250
> [11571.580001] perf samples too long (7670242 > 40000), lowering kernel.perf_event_max_sample_rate to 3250
> [11572.428001] perf samples too long (7610324 > 76923), lowering kernel.perf_event_max_sample_rate to 1750
> [11573.276001] perf samples too long (7550874 > 142857), lowering kernel.perf_event_max_sample_rate to 1000
> [11574.124001] perf samples too long (7491888 > 250000), lowering kernel.perf_event_max_sample_rate to 500
> [11574.968001] perf samples too long (7433363 > 500000), lowering kernel.perf_event_max_sample_rate to 250

