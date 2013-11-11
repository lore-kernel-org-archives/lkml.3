Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3KKWUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 17:20:10 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:46557 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3KKWUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 17:20:05 -0500
Date: Mon, 11 Nov 2013 17:28:21 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint yet another lockup
In-Reply-To: <alpine.DEB.2.10.1311111158420.25509@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1311111720190.26895@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1311111158420.25509@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, managed to capture a crash, not sure if it was the same as the 
previous one in the thread.

In this case it looks like it is tracepoint event 0x25 which I think is
  vsyscall/emulate_vsyscall/id:37
Although I can't get this to trigger in a standalone workload (it seems to 
trigger best under some sort of load).

So are all tracepoints unsafe?  Or just a subset?

[18367.468004] ------------[ cut here ]------------
[18367.468004] WARNING: CPU: 0 PID: 17541 at kernel/watchdog.c:245 watchdog_ove)
[18367.468004] Watchdog detected hard LOCKUP on cpu 0
[18367.468004] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powern
[18367.468004] CPU: 0 PID: 17541 Comm: perf_fuzzer Not tainted 3.12.0 #2
[18367.468004] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[18367.468004]  00000000000000f5 ffff88011fc07c48 ffffffff8151aad6 ffff88011fc08
[18367.468004]  ffffffff8103cd68 ffff88011fc07c78 ffffffff810a101c ffff88011b310
[18367.468004]  ffff88011fc07ef8 ffff88011fc07d58 0000000000000000 ffff88011fc08
[18367.468004] Call Trace:
[18367.468004]  <NMI>  [<ffffffff8151aad6>] ? dump_stack+0x41/0x53
[18367.468004]  [<ffffffff8103cd68>] ? warn_slowpath_common+0x81/0x9c
[18367.468004]  [<ffffffff810a101c>] ? watchdog_overflow_callback+0x9b/0xa6
[18367.468004]  [<ffffffff8103ce25>] ? warn_slowpath_fmt+0x46/0x48
[18367.468004]  [<ffffffff810c9df2>] ? perf_prepare_sample+0x167/0x2f4
[18367.468004]  [<ffffffff810a101c>] ? watchdog_overflow_callback+0x9b/0xa6
[18367.468004]  [<ffffffff810ca4a2>] ? __perf_event_overflow+0x12e/0x1ab
[18367.468004]  [<ffffffff810167d3>] ? intel_pmu_lbr_read+0x253/0x349
[18367.468004]  [<ffffffff81018c95>] ? intel_pmu_handle_irq+0x2b8/0x34d
[18367.468004]  [<ffffffff8151dc88>] ? _raw_spin_lock+0x12/0x2a
[18367.468004]  [<ffffffff8151edfc>] ? nmi_handle+0xa8/0x13a
[18367.468004]  [<ffffffff8151f473>] ? perf_event_nmi_handler+0x24/0x3d
[18367.468004]  [<ffffffff8151edb2>] ? nmi_handle+0x5e/0x13a
[18367.468004]  [<ffffffff8151ef35>] ? do_nmi+0xa7/0x2bd
[18367.468004]  [<ffffffff8151e537>] ? end_repeat_nmi+0x1e/0x2e
[18367.468004]  [<ffffffff81049a6f>] ? __lock_task_sighand+0x4a/0x6a
[18367.468004]  [<ffffffff81049a6f>] ? __lock_task_sighand+0x4a/0x6a
[18367.468004]  [<ffffffff81049a6f>] ? __lock_task_sighand+0x4a/0x6a
[18367.468004]  <<EOE>>  <IRQ>  [<ffffffff8104b055>] ? do_send_sig_info+0x2c/0x5
[18367.468004]  [<ffffffff8111f683>] ? send_sigio_to_task+0xeb/0xf5
[18367.468004]  [<ffffffff8111f737>] ? send_sigio+0xaa/0xdd
[18367.468004]  [<ffffffff8111f7d3>] ? kill_fasync+0x69/0x86
[18367.468004]  [<ffffffff810cabf9>] ? perf_event_wakeup+0x8c/0xa1
[18367.468004]  [<ffffffff810c494d>] ? __irq_work_run+0x5f/0x7b
[18367.468004]  [<ffffffff81005f82>] ? smp_trace_irq_work_interrupt+0x4b/0x7e
[18367.468004]  [<ffffffff815261ca>] ? trace_irq_work_interrupt+0x6a/0x70
[18367.468004]  [<ffffffff8151da07>] ? _raw_spin_unlock_irqrestore+0xf/0x11
[18367.468004]  [<ffffffff810a3a89>] ? rcu_process_callbacks+0x4a4/0x4b8
[18367.468004]  [<ffffffff8105b8f3>] ? enqueue_hrtimer+0x51/0x7b
[18367.468004]  [<ffffffff81041027>] ? __do_softirq+0x102/0x208
[18367.468004]  [<ffffffff81027608>] ? lapic_next_event+0x1d/0x21
[18367.468004]  [<ffffffff8105c187>] ? hrtimer_interrupt+0x119/0x1c6
[18367.468004]  [<ffffffff815263dc>] ? call_softirq+0x1c/0x30
[18367.468004]  [<ffffffff810041b9>] ? do_softirq+0x38/0x6d
[18367.468004]  [<ffffffff81040d1c>] ? irq_exit+0x45/0xa1
[18367.468004]  [<ffffffff81526a14>] ? smp_trace_apic_timer_interrupt+0x83/0x91
[18367.468004]  [<ffffffff8152597a>] ? trace_apic_timer_interrupt+0x6a/0x70
[18367.468004]  <EOI>  [<ffffffff8151dc88>] ? _raw_spin_lock+0x12/0x2a
[18367.468004]  [<ffffffff81133680>] ? sync_inodes_sb+0x10a/0x1a0
[18367.468004]  [<ffffffff811373d3>] ? fdatawrite_one_bdev+0x17/0x17
[18367.468004]  [<ffffffff8111446f>] ? iterate_supers+0x6e/0xc0
[18367.468004]  [<ffffffff8113741f>] ? sys_sync+0x35/0x83
[18367.468004]  [<ffffffff81524c96>] ? system_call_fastpath+0x1a/0x1f
[18367.468004] ---[ end trace 73e6e6b3ff98085b ]---
[18367.468004] perf samples too long (8137810 > 20000), lowering kernel.perf_ev0
[18367.468004] INFO: NMI handler (perf_event_nmi_handler) took too long to run:s
[18378.460001] perf samples too long (8074239 > 40000), lowering kernel.perf_ev0
[18379.284001] perf samples too long (8011165 > 76923), lowering kernel.perf_ev0
[18380.132001] perf samples too long (7948583 > 142857), lowering kernel.perf_e0
[18380.980001] perf samples too long (7886490 > 250000), lowering kernel.perf_e0
[18381.828001] perf samples too long (7824882 > 500000), lowering kernel.perf_e0

