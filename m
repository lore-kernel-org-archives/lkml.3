Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaBUOfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:35:19 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:64663 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbaBUOfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:35:16 -0500
Date: Fri, 21 Feb 2014 09:37:14 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: x86_pmu_start WARN_ON.
In-Reply-To: <alpine.DEB.2.10.1402201438480.24360@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1402210931410.6395@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu> <20140217152859.GF15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu> <20140219101949.GG15586@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
 <20140220100830.GN6835@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1402201302150.24360@vincent-weaver-1.um.maine.edu> <20140220182300.GN9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402201352010.24360@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402201414380.24360@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402201438480.24360@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


and the perf_fuzzer overnight triggered this possibly related warning
in x86_pmu_stop()

I assume it's this code (the line numbers don't match up for some reason).

        if (__test_and_clear_bit(hwc->idx, cpuc->active_mask)) {
                x86_pmu.disable(event);
                cpuc->events[hwc->idx] = NULL;
                WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
                hwc->state |= PERF_HES_STOPPED;
        }

so possibly also related to PERF_HES_STOPPED?


[25526.987821] ------------[ cut here ]------------
[25526.988047] WARNING: CPU: 1 PID: 3849 at arch/x86/kernel/cpu/perf_event.c:1221 x86_pmu_stop+0x71/0xa6()
[25526.988047] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg mcs7830 usbnet ohci_pci evdev video wmi psmouse serio_raw coretemp i2c_nforce2 ohci_hcd acpi_cpufreq processor pcspkr thermal_sys button sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[25526.988047] CPU: 1 PID: 3849 Comm: perf_fuzzer Tainted: G        W    3.14.0-rc3+ #17
[25526.988047] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[25526.988047]  00000000000004c5 ffff88011fc83ca8 ffffffff81530d11 00000000000004c5
[25526.988047]  0000000000000000 ffff88011fc83ce8 ffffffff8103fce4 ffff88011fc83d28
[25526.988047]  ffffffff81012ca0 ffff8800c9be6000 0000000000000004 ffff88011fc8b940
[25526.988047] Call Trace:
[25526.988047]  <IRQ>  [<ffffffff81530d11>] dump_stack+0x49/0x60
[25526.988047]  [<ffffffff8103fce4>] warn_slowpath_common+0x81/0x9b
[25526.988047]  [<ffffffff81012ca0>] ? x86_pmu_stop+0x71/0xa6
[25526.988047]  [<ffffffff8103fd18>] warn_slowpath_null+0x1a/0x1c
[25526.988047]  [<ffffffff81012ca0>] x86_pmu_stop+0x71/0xa6
[25526.988047]  [<ffffffff81012e7b>] x86_pmu_del+0x3d/0xb8
[25526.988047]  [<ffffffff810ca936>] event_sched_out+0x92/0x121
[25526.988047]  [<ffffffff810cd124>] group_sched_in+0xf7/0x147
[25526.988047]  [<ffffffff810cd2d2>] ctx_sched_in+0x15e/0x185
[25526.988047]  [<ffffffff810cd362>] perf_event_sched_in+0x69/0x71
[25526.988047]  [<ffffffff810cd594>] perf_cpu_hrtimer_handler+0x13a/0x1b0
[25526.988047]  [<ffffffff8105e5b5>] __run_hrtimer+0xba/0x145
[25526.988047]  [<ffffffff810cd45a>] ? __perf_install_in_context+0xf0/0xf0
[25526.988047]  [<ffffffff8105e88a>] hrtimer_interrupt+0xd5/0x1c3
[25526.988047]  [<ffffffff8102b593>] local_apic_timer_interrupt+0x58/0x5d
[25526.988047]  [<ffffffff8102bf4f>] smp_trace_apic_timer_interrupt+0x53/0x91
[25526.988047]  [<ffffffff8153bafa>] trace_apic_timer_interrupt+0x6a/0x70
[25526.988047]  <EOI>  [<ffffffff8153ade6>] ? system_call_fastpath+0x1a/0x1f
[25526.988047] ---[ end trace d5252ca58550eb43 ]---

