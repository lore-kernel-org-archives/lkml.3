Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaBUX4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:56:53 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:42000 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaBUX4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:56:51 -0500
Date: Fri, 21 Feb 2014 18:58:50 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Linux Kernel <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: perf_fuzzer: WARNING arch/x86/kernel/cpu/perf_event.c:1158
 x86_pmu_stop
Message-ID: <alpine.DEB.2.10.1402211852500.17216@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I got this while perf_fuzzing, same core2 machine, this
is 3.14-rc3 *with* Peter's patch to fix the other WARNING applied.

I can try to isolate a test case, though not until after the weekend.

Vince

        if (__test_and_clear_bit(hwc->idx, cpuc->active_mask)) {
                x86_pmu.disable(event);
                cpuc->events[hwc->idx] = NULL;
===>            WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
                hwc->state |= PERF_HES_STOPPED;
        }


[13044.385262] ------------[ cut here ]------------
[13044.388007] WARNING: CPU: 1 PID: 6274 at arch/x86/kernel/cpu/perf_event.c:1158 x86_pmu_stop+0x71/0xa6()
[13044.388007] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg mcs7830 usbnet wmi ohci_pci acpi_cpufreq video evdev pcspkr psmouse processor coretemp thermal_sys serio_raw button ohci_hcd i2c_nforce2 ehci_pci ehci_hcd sg sd_mod usbcore usb_common
[13044.388007] CPU: 1 PID: 6274 Comm: perf_fuzzer Not tainted 3.14.0-rc3+ #18
[13044.388007] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[13044.388007]  0000000000000486 ffff88011fc83ca8 ffffffff81530d11 0000000000000486
[13044.388007]  0000000000000000 ffff88011fc83ce8 ffffffff8103fce4 ffffffff810691ac
[13044.388007]  ffffffff81012ce3 ffff8800cae0e800 0000000000000004 ffff88011fc8b940
[13044.388007] Call Trace:
[13044.388007]  <IRQ>  [<ffffffff81530d11>] dump_stack+0x49/0x60
[13044.388007]  [<ffffffff8103fce4>] warn_slowpath_common+0x81/0x9b
[13044.388007]  [<ffffffff810691ac>] ? default_wake_function+0x12/0x14
[13044.388007]  [<ffffffff81012ce3>] ? x86_pmu_stop+0x71/0xa6
[13044.388007]  [<ffffffff8103fd18>] warn_slowpath_null+0x1a/0x1c
[13044.388007]  [<ffffffff81012ce3>] x86_pmu_stop+0x71/0xa6
[13044.388007]  [<ffffffff81012fd2>] x86_pmu_del+0x41/0xd2
[13044.388007]  [<ffffffff810ca936>] event_sched_out+0x92/0x121
[13044.388007]  [<ffffffff810cd124>] group_sched_in+0xf7/0x147
[13044.388007]  [<ffffffff810cd2d2>] ctx_sched_in+0x15e/0x185
[13044.388007]  [<ffffffff810cd362>] perf_event_sched_in+0x69/0x71
[13044.388007]  [<ffffffff810cd594>] perf_cpu_hrtimer_handler+0x13a/0x1b0
[13044.388007]  [<ffffffff8105e5b5>] __run_hrtimer+0xba/0x145
[13044.388007]  [<ffffffff810cd45a>] ? __perf_install_in_context+0xf0/0xf0
[13044.388007]  [<ffffffff8105e88a>] hrtimer_interrupt+0xd5/0x1c3
[13044.388007]  [<ffffffff8102b2d3>] local_apic_timer_interrupt+0x58/0x5d
[13044.388007]  [<ffffffff8102bc8f>] smp_trace_apic_timer_interrupt+0x53/0x91
[13044.388007]  [<ffffffff8153bafa>] trace_apic_timer_interrupt+0x6a/0x70
[13044.388007]  <EOI>  [<ffffffff8153ade6>] ? system_call_fastpath+0x1a/0x1f
[13044.388007] ---[ end trace 8007361335c0fe73 ]---

