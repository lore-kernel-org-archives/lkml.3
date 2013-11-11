Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3KKQzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:55:14 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:56647 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3KKQzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:55:07 -0500
Date: Mon, 11 Nov 2013 12:03:21 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: LKML <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>
Subject: perf/tracepoint yet another lockup
Message-ID: <alpine.DEB.2.10.1311111158420.25509@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

so I modified my perf_fuzzer to not try tracepoint event 0x18 
(irq_work_exit which is the event causing problems in the other thread).

But I got another lockup, presumbaly with a different trace event.  
I'll try to narrow down which one caused it.

Should we just be disabling the perf/tracepoint interface if not run as 
root at this point?

Vince


[243573.968001] ------------[ cut here ]------------
[243573.968001] WARNING: CPU: 0 PID: 4159 at kernel/watchdog.c:245 watchdog_ove)
[243573.968001] Watchdog detected hard LOCKUP on cpu 0
[243573.968001] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powen
[243573.968001] CPU: 0 PID: 4159 Comm: perf_fuzzer Tainted: G        W    3.12.2
[243573.968001] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, B2
[243573.968001]  00000000000000f5 ffff88011fc07c48 ffffffff8151aad6 ffff88011fc8
[243573.968001]  ffffffff8103cd68 0000000100000000 ffffffff810a101c ffff88011b30
[243573.968001]  ffff88011fc07ef8 ffff88011fc07d58 0000000000000000 ffff88011fc8
[243573.968001] Call Trace:
[243573.968001]  <NMI>  [<ffffffff8151aad6>] ? dump_stack+0x41/0x53
[243573.968001]  [<ffffffff8103cd68>] ? warn_slowpath_common+0x81/0x9c
[243573.968001]  [<ffffffff810a101c>] ? watchdog_overflow_callback+0x9b/0xa6
[243573.968001]  [<ffffffff8103ce25>] ? warn_slowpath_fmt+0x46/0x48
[243573.968001]  [<ffffffff810c9ced>] ? perf_prepare_sample+0x62/0x2f4
[243573.968001]  [<ffffffff810a101c>] ? watchdog_overflow_callback+0x9b/0xa6
[243573.968001]  [<ffffffff810ca4a2>] ? __perf_event_overflow+0x12e/0x1ab
[243573.968001]  [<ffffffff810167d3>] ? intel_pmu_lbr_read+0x253/0x349
[243573.968001]  [<ffffffff81018c95>] ? intel_pmu_handle_irq+0x2b8/0x34d
[243573.968001]  [<ffffffff810c79e3>] ? perf_event_context_sched_in+0x70/0x8d
[243573.968001]  [<ffffffff8151edfc>] ? nmi_handle+0xa8/0x13a
[243573.968001]  [<ffffffff8151f473>] ? perf_event_nmi_handler+0x24/0x3d
[243573.968001]  [<ffffffff8151edb2>] ? nmi_handle+0x5e/0x13a
[243573.968001]  [<ffffffff8151ef35>] ? do_nmi+0xa7/0x2bd
[243573.968001]  [<ffffffff8151e537>] ? end_repeat_nmi+0x1e/0x2e
[243573.968001]  [<ffffffff81526160>] ? irq_work_interrupt+0x70/0x70
[243573.968001]  [<ffffffff81526160>] ? irq_work_interrupt+0x70/0x70
[243573.968001]  [<ffffffff81526160>] ? irq_work_interrupt+0x70/0x70
[243573.968001]  <<EOE>>  [<ffffffff8106658c>] ? finish_task_switch+0x57/0x98
[243573.968001]  [<ffffffff8106657b>] ? finish_task_switch+0x46/0x98
[243573.968001]  [<ffffffff8151c9ee>] ? __schedule+0x4f7/0x54b
[243573.968001]  [<ffffffff8151ab1e>] ? schedule_timeout+0x36/0xe5
[243573.968001]  [<ffffffff8106657b>] ? finish_task_switch+0x46/0x98
[243573.968001]  [<ffffffff8151ca13>] ? __schedule+0x51c/0x54b
[243573.968001]  [<ffffffff8151aae8>] ? dump_stack+0x53/0x53
[243573.968001]  [<ffffffff8151cb96>] ? __wait_for_common+0xce/0x14a
[243573.968001]  [<ffffffff810664d6>] ? try_to_wake_up+0x1ab/0x1ab
[243573.968001]  [<ffffffff810a2fff>] ? T.901+0x1e4/0x1e4
[243573.968001]  [<ffffffff810561db>] ? wait_rcu_gp+0x4b/0x54
[243573.968001]  [<ffffffff810561e4>] ? wait_rcu_gp+0x54/0x54
[243573.968001]  [<ffffffff810be94a>] ? perf_trace_event_unreg+0x2e/0xbd
[243573.968001]  [<ffffffff810bea07>] ? perf_trace_destroy+0x2e/0x3b
[243573.968001]  [<ffffffff810c6f9e>] ? __free_event+0x2d/0x52
[243573.968001]  [<ffffffff810c8116>] ? perf_event_release_kernel+0x74/0x7b
[243573.968001]  [<ffffffff810c8358>] ? perf_release+0x10/0x14
[243573.968001]  [<ffffffff811133c5>] ? __fput+0xfa/0x1be
[243573.968001]  [<ffffffff81055ebd>] ? task_work_run+0x88/0xa0
[243573.968001]  [<ffffffff81524ea0>] ? int_signal+0x12/0x17
[243573.968001] ---[ end trace 199b386ed4ca91db ]---
[243573.968001] perf samples too long (7436949 > 10000), lowering kernel.perf_e0
[243573.968001] INFO: NMI handler (perf_event_nmi_handler) took too long to runs
[243589.024001] perf samples too long (7378854 > 20000), lowering kernel.perf_e0
[243589.844001] perf samples too long (7321212 > 40000), lowering kernel.perf_e0
[243590.692001] perf samples too long (7264020 > 76923), lowering kernel.perf_e0
[243591.540001] perf samples too long (7207276 > 142857), lowering kernel.perf_0
[243592.388001] perf samples too long (7150974 > 250000), lowering kernel.perf_0
[243593.236001] perf samples too long (7095112 > 500000), lowering kernel.perf_0

