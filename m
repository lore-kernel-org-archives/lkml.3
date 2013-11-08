Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab3KHTgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:36:52 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:57141 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab3KHTgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:36:50 -0500
Date: Fri, 8 Nov 2013 14:45:05 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: perf/tracepoint: another fuzzer generated lockup
Message-ID: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The perf_fuzzer hits this bug pretty reliably within about an hour, but 
unfortunately after a large number of syscalls so not easy to isolate.

This is against stock 3.12 with the no-ftrace-function-tracing-unless-root
patch applied.

I can trigger this is a normal user, no root involved.

[106657.412003] ------------[ cut here ]------------
[106657.412003] WARNING: CPU: 1 PID: 4131 at kernel/watchdog.c:245 watchdog_ove)
[106657.412003] Watchdog detected hard LOCKUP on cpu 1
[106657.412003] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powed
[106657.412003] CPU: 1 PID: 4131 Comm: perf_fuzzer Not tainted 3.12.0 #2
[106657.412003] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, B2
[106657.412003]  00000000000000f5 ffff88011fc87c48 ffffffff8151aad6 ffff88011fc8
[106657.412003]  ffffffff8103cd68 0000000100000000 ffffffff810a101c ffff88011b30
[106657.412003]  ffff88011fc87ef8 ffff88011fc87d58 0000000000000000 ffff88011fc8
[106657.412003] Call Trace:
[106657.412003]  <NMI>  [<ffffffff8151aad6>] ? dump_stack+0x41/0x53
[106657.412003]  [<ffffffff8103cd68>] ? warn_slowpath_common+0x81/0x9c
[106657.412003]  [<ffffffff810a101c>] ? watchdog_overflow_callback+0x9b/0xa6
[106657.412003]  [<ffffffff8103ce25>] ? warn_slowpath_fmt+0x46/0x48
[106657.412003]  [<ffffffff810a101c>] ? watchdog_overflow_callback+0x9b/0xa6
[106657.412003]  [<ffffffff810ca4a2>] ? __perf_event_overflow+0x12e/0x1ab
[106657.412003]  [<ffffffff810167d3>] ? intel_pmu_lbr_read+0x253/0x349
[106657.412003]  [<ffffffff81018c95>] ? intel_pmu_handle_irq+0x2b8/0x34d
[106657.412003]  [<ffffffff8151edfc>] ? nmi_handle+0xa8/0x13a
[106657.412003]  [<ffffffff8151f473>] ? perf_event_nmi_handler+0x24/0x3d
[106657.412003]  [<ffffffff8151edb2>] ? nmi_handle+0x5e/0x13a
[106657.412003]  [<ffffffff8151ef35>] ? do_nmi+0xa7/0x2bd
[106657.412003]  [<ffffffff8151e537>] ? end_repeat_nmi+0x1e/0x2e
[106657.412003]  [<ffffffff8104b09c>] ? do_send_sig_info+0x73/0x75
[106657.412003]  [<ffffffff8104b09c>] ? do_send_sig_info+0x73/0x75
[106657.412003]  [<ffffffff8104b09c>] ? do_send_sig_info+0x73/0x75
[106657.412003]  <<EOE>>  <IRQ>  [<ffffffff8111f683>] ? send_sigio_to_task+0xeb5
[106657.412003]  [<ffffffff8111f737>] ? send_sigio+0xaa/0xdd
[106657.412003]  [<ffffffff8111f7d3>] ? kill_fasync+0x69/0x86
[106657.412003]  [<ffffffff810cabf9>] ? perf_event_wakeup+0x8c/0xa1
[106657.412003]  [<ffffffff810c494d>] ? __irq_work_run+0x5f/0x7b
[106657.412003]  [<ffffffff81005f82>] ? smp_trace_irq_work_interrupt+0x4b/0x7e
[106657.412003]  [<ffffffff815261ca>] ? trace_irq_work_interrupt+0x6a/0x70
[106657.412003]  [<ffffffff8151da07>] ? _raw_spin_unlock_irqrestore+0xf/0x11
[106657.412003]  [<ffffffff810a3a89>] ? rcu_process_callbacks+0x4a4/0x4b8
[106657.412003]  [<ffffffff81041027>] ? __do_softirq+0x102/0x208
[106657.412003]  [<ffffffff815263dc>] ? call_softirq+0x1c/0x30
[106657.412003]  [<ffffffff810041b9>] ? do_softirq+0x38/0x6d
[106657.412003]  [<ffffffff81040d1c>] ? irq_exit+0x45/0xa1
[106657.412003]  [<ffffffff81526a14>] ? smp_trace_apic_timer_interrupt+0x83/0x91
[106657.412003]  [<ffffffff8152597a>] ? trace_apic_timer_interrupt+0x6a/0x70
[106657.412003]  <EOI> 
[106657.412003] ---[ end trace ff266ee4a75ddbbf ]---
[106657.412003] perf samples too long (6605838 > 10000), lowering kernel.perf_e0
[106657.412003] INFO: NMI handler (perf_event_nmi_handler) took too long to runs
[106678.192001] perf samples too long (6554240 > 20000), lowering kernel.perf_e0
[106679.508002] perf samples too long (6503044 > 40000), lowering kernel.perf_e0
[106680.852001] perf samples too long (6452247 > 76923), lowering kernel.perf_e0
[106682.192001] perf samples too long (6401848 > 142857), lowering kernel.perf_0
[106683.536001] perf samples too long (6351842 > 250000), lowering kernel.perf_0
[106684.876001] perf samples too long (6302227 > 500000), lowering kernel.perf_0

