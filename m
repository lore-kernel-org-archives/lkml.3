Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaBRSfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:35:52 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:64125 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaBRSfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:35:50 -0500
Date: Tue, 18 Feb 2014 13:30:21 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: x86_pmu_start WARN_ON.
In-Reply-To: <20140217152859.GF15586@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
References: <20140130190253.GA11819@redhat.com> <alpine.DEB.2.10.1402101620170.29602@vincent-weaver-1.um.maine.edu> <20140211132956.GY9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402121559350.20738@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
 <20140217152859.GF15586@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014, Peter Zijlstra wrote:

> Enable CONFIG_FRAME_POINTER for better stack traces; I suspect the
> list_del_event() is just random stack garbage. The path that makes sense
> is:
>   wait_rcu()->__wait_for_common()->schedule_timeout()

Here's an updated stack trace on 3.14-rc3 with CONFIG_FRAME_POINTER 
enabled, in case it's helpful:

[  237.004035] ------------[ cut here ]------------
[  237.008016] WARNING: CPU: 1 PID: 2791 at arch/x86/kernel/cpu/perf_event.c:1076 x86_pmu_start+0x41/0x113()
[  237.008016] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg mcs7830 usbnet evdev wmi acpi_cpufreq video coretemp psmouse processor thermal_sys button ohci_pci ohci_hcd serio_raw pcspkr i2c_nforce2 sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[  237.008016] CPU: 1 PID: 2791 Comm: pec_1076_warn Not tainted 3.14.0-rc3+ #10
[  237.008016] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  237.008016]  0000000000000434 ffff8800cae6b9d8 ffffffff8150e4ff 0000000000000434
[  237.008016]  0000000000000000 ffff8800cae6ba18 ffffffff8103d64e ffff8800cae6ba48
[  237.008016]  ffffffff81012b10 0000000000000021 ffff88011b31dc00 ffff88011fc8b940
[  237.008016] Call Trace:
[  237.008016]  [<ffffffff8150e4ff>] dump_stack+0x49/0x62
[  237.008016]  [<ffffffff8103d64e>] warn_slowpath_common+0x7c/0x96
[  237.008016]  [<ffffffff81012b10>] ? x86_pmu_start+0x41/0x113
[  237.008016]  [<ffffffff8103d67d>] warn_slowpath_null+0x15/0x17
[  237.008016]  [<ffffffff81012b10>] x86_pmu_start+0x41/0x113
[  237.008016]  [<ffffffff81012dba>] x86_pmu_enable+0x1d8/0x27d
[  237.008016]  [<ffffffff810bff5b>] perf_pmu_enable+0x21/0x23
[  237.008016]  [<ffffffff810c3073>] perf_event_context_sched_in+0x79/0x9a
[  237.008016]  [<ffffffff810c30ba>] __perf_event_task_sched_in+0x26/0x10f
[  237.008016]  [<ffffffff81069913>] ? idle_balance+0x125/0x161
[  237.008016]  [<ffffffff81065937>] finish_task_switch+0x41/0xa8
[  237.008016]  [<ffffffff8150ef2c>] __schedule+0x48f/0x4e3
[  237.008016]  [<ffffffff8105aec3>] ? __hrtimer_start_range_ns+0x2e8/0x2fa
[  237.008016]  [<ffffffff8150f0df>] schedule+0x6e/0x70
[  237.008016]  [<ffffffff8150e53a>] schedule_timeout+0x22/0xbd
[  237.008016]  [<ffffffff8150e518>] ? dump_stack+0x62/0x62
[  237.008016]  [<ffffffff8150f685>] __wait_for_common+0xc6/0x142
[  237.008016]  [<ffffffff810658a3>] ? try_to_wake_up+0x1a8/0x1a8
[  237.008016]  [<ffffffff81082d21>] ? T.944+0x1de/0x1de
[  237.008016]  [<ffffffff8150f7ce>] wait_for_completion+0x1f/0x21
[  237.008016]  [<ffffffff81080b99>] wait_rcu_gp+0x46/0x4f
[  237.008016]  [<ffffffff81080ba2>] ? wait_rcu_gp+0x4f/0x4f
[  237.008016]  [<ffffffff81082773>] synchronize_sched+0x29/0x2b
[  237.008016]  [<ffffffff810b8031>] perf_trace_event_unreg+0x36/0xc8
[  237.008016]  [<ffffffff810b80f9>] perf_trace_destroy+0x36/0x46
[  237.008016]  [<ffffffff810c2079>] tp_perf_event_destroy+0x9/0xb
[  237.008016]  [<ffffffff810c26f2>] __free_event+0x35/0x5d
[  237.008016]  [<ffffffff810c64ca>] free_event+0x10d/0x116
[  237.008016]  [<ffffffff810c6550>] perf_event_release_kernel+0x7d/0x88
[  237.008016]  [<ffffffff810c65fe>] put_event+0xa3/0xac
[  237.008016]  [<ffffffff810c6617>] perf_release+0x10/0x14
[  237.008016]  [<ffffffff8110e08a>] __fput+0xeb/0x1b0
[  237.008016]  [<ffffffff8110e1b7>] ____fput+0x9/0xb
[  237.008016]  [<ffffffff81055e21>] task_work_run+0x83/0x9b
[  237.008016]  [<ffffffff81002ac6>] do_notify_resume+0x58/0x5f
[  237.008016]  [<ffffffff81517f30>] int_signal+0x12/0x17
[  237.008016] ---[ end trace a07d99177587379f ]---
[  237.008016] IN: VMW: idx=33 state=0 type=0 config=0 samp_per=5e619d890

