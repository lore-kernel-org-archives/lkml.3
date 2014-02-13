Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaBMWLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:11:48 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36059 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaBMWLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:11:32 -0500
Date: Thu, 13 Feb 2014 17:13:20 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: x86_pmu_start WARN_ON.
In-Reply-To: <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
References: <20140130190253.GA11819@redhat.com> <alpine.DEB.2.10.1402101620170.29602@vincent-weaver-1.um.maine.edu> <20140211132956.GY9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402121559350.20738@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014, Vince Weaver wrote:

> The plot thickens.  The WARN_ON is not caused by the cycles event that we 
> open, but it's caused by the NMI Watchdog cycles event.

The WARN_ON_ONCE at line 1076 in perf_event.c is triggering because
in x86_pmu_enable() is calling x86_pmu_start() for all of the active x86 
events (three plus the NMI watchdog) the NMI watchdog is unexpectedly
not having PERF_HES_STOPPED set (it's hw.state is 0).

What's the deal with the PERF_HES_STOPPED name?  Is HES an acronym?
Or is it just a male event?  
Also it's not really clear what PERF_HES_ARCH indicates.

Things rapidly get complicated beyond that, as the NMI watchdog is a 
kernel-created event bound to the CPU, wheras 2 of the events are x86 hw 
events with a breakpoint-event groupleader (and the fact one of the events 
has precise set).

>From the stacktrace it looks like it is the close of a completely 
unrelated tracepoint event that triggers this all off, but I'm not
sure why a list_del_event() call of the tracepoint name would
trigger a schedule_timeout() and an ensuing __perf_event_task_sched_in()
which is what eventually triggers the problem.

Scattering printks around doesn't see to work because a lot of the related 
calls are happening in contexts where printks don't really work.

Anyway I just wanted to summarize my findings as I might not have a chance 
to look at this again for a while.  For completion I'm including the 
backtrace below.

Vince

[   49.972034] ------------[ cut here ]------------
[   49.976014] WARNING: CPU: 1 PID: 2867 at arch/x86/kernel/cpu/perf_event.c:1076 x86_pmu_start+0x38/0x102()
[   49.976014] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg evdev mcs7830 usbnet ohci_pci video acpi_cpufreq processor thermal_sys wmi psmouse serio_raw pcspkr coretemp button ohci_hcd i2c_nforce2 ehci_pci ehci_hcd sg sd_mod usbcore usb_common
[   49.976014] CPU: 1 PID: 2867 Comm: pec_1076_warn Not tainted 3.14.0-rc2+ #7
[   49.976014] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[   49.976014]  0000000000000000 ffffffff817f256d ffffffff814e750b 0000000000000000
[   49.976014]  ffffffff8103bf2c ffff8800ca005820 ffffffff81012119 ffff88011fc93400
[   49.976014]  0000000000000021 ffff88011b31dc00 ffff88011fc8b940 0000000000000000
[   49.976014] Call Trace:
[   49.976014]  [<ffffffff814e750b>] ? dump_stack+0x41/0x56
[   49.976014]  [<ffffffff8103bf2c>] ? warn_slowpath_common+0x79/0x92
[   49.976014]  [<ffffffff81012119>] ? x86_pmu_start+0x38/0x102
[   49.976014]  [<ffffffff81012119>] ? x86_pmu_start+0x38/0x102
[   49.976014]  [<ffffffff810123b6>] ? x86_pmu_enable+0x1d3/0x285
[   49.976014]  [<ffffffff810bca20>] ? perf_event_context_sched_in+0x6d/0x8d
[   49.976014]  [<ffffffff810bca61>] ? __perf_event_task_sched_in+0x21/0x108
[   49.976014]  [<ffffffff810666cc>] ? idle_balance+0x11a/0x157
[   49.976014]  [<ffffffff81062905>] ? finish_task_switch+0x40/0xa5
[   49.976014]  [<ffffffff814e7ee5>] ? __schedule+0x46a/0x4bd
[   49.976014]  [<ffffffff814e753d>] ? schedule_timeout+0x1d/0xb4
[   49.976014]  [<ffffffff810b9d96>] ? list_del_event+0x78/0x8f
[   49.976014]  [<ffffffff814e7520>] ? dump_stack+0x56/0x56
[   49.976014]  [<ffffffff814e8627>] ? __wait_for_common+0xce/0x14a
[   49.976014]  [<ffffffff8106287d>] ? try_to_wake_up+0x19a/0x19a
[   49.976014]  [<ffffffff810a1b5a>] ? get_tracepoint+0x20/0x53
[   49.976014]  [<ffffffff8107ea5a>] ? T.944+0x1c8/0x1c8
[   49.976014]  [<ffffffff8107ca0c>] ? wait_rcu_gp+0x3f/0x46
[   49.976014]  [<ffffffff8107ca13>] ? wait_rcu_gp+0x46/0x46
[   49.976014]  [<ffffffff810b2027>] ? perf_trace_event_unreg+0x2e/0xbd
[   49.976014]  [<ffffffff810b20e4>] ? perf_trace_destroy+0x2e/0x3b
[   49.976014]  [<ffffffff810bc0d2>] ? __free_event+0x2d/0x52
[   49.976014]  [<ffffffff810bfdff>] ? perf_event_release_kernel+0x74/0x7b
[   49.976014]  [<ffffffff810bfeb0>] ? perf_release+0x10/0x14
[   49.976014]  [<ffffffff81105b17>] ? __fput+0xdf/0x1a4
[   49.976014]  [<ffffffff810538e9>] ? task_work_run+0x7f/0x96
[   49.976014]  [<ffffffff814f0a70>] ? int_signal+0x12/0x17
[   49.976014] ---[ end trace 0b1abb2bc23cc0c5 ]---
[   49.976014] VMW: idx=33 state=0 type=0 config=0 samp_per=5e5fc1760

