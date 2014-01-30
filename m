Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaA3TDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:03:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbaA3TDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:03:34 -0500
Date: Thu, 30 Jan 2014 14:02:53 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, vincent.weaver@maine.edu
Subject: x86_pmu_start WARN_ON.
Message-ID: <20140130190253.GA11819@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, vincent.weaver@maine.edu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I gave Vince's perf_fuzzer a run, hoping to trigger a different perf bug
that I've been seeing. Instead I hit a different bug.

WARNING: CPU: 1 PID: 9277 at arch/x86/kernel/cpu/perf_event.c:1076 x86_pmu_start+0xd1/0x110()
CPU: 1 PID: 9277 Comm: perf_fuzzer Not tainted 3.13.0+ #101
 0000000000000009 0000000047887442 ffff88024d043da8 ffffffffbd7387ba
 0000000000000000 ffff88024d043de0 ffffffffbd06d28d ffff88024d04bba0
 ffff880104c9ef60 0000000000000004 0000000000000002 ffff88024d04bddc
Call Trace:
 <IRQ>  [<ffffffffbd7387ba>] dump_stack+0x4e/0x7a
 [<ffffffffbd06d28d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffffbd06d3ba>] warn_slowpath_null+0x1a/0x20
 [<ffffffffbd018421>] x86_pmu_start+0xd1/0x110
 [<ffffffffbd018b9f>] x86_pmu_enable+0x22f/0x320
 [<ffffffffbd150bca>] perf_pmu_enable+0x2a/0x30
 [<ffffffffbd152711>] perf_cpu_hrtimer_handler+0xe1/0x1f0
 [<ffffffffbd097582>] __run_hrtimer+0x72/0x250
 [<ffffffffbd152630>] ? perf_event_context_sched_in.isra.85+0xc0/0xc0
 [<ffffffffbd097e97>] hrtimer_interrupt+0x107/0x260
 [<ffffffffbd030744>] local_apic_timer_interrupt+0x34/0x60
 [<ffffffffbd74deba>] smp_trace_apic_timer_interrupt+0x4a/0x125
 [<ffffffffbd74cb2f>] trace_apic_timer_interrupt+0x6f/0x80
 <EOI>  [<ffffffffbd743e4d>] ? retint_swapgs+0xe/0x13

1076         if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
1077                 return;


It reproduces pretty quickly for me (within a minute or two of runtime).
Oddly the generated test case from the log file doesn't reproduce.

	Dave

