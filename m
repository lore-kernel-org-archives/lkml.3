Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaLHTKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:10:11 -0500
Received: from smtpauth13.mfg.siteprotect.com ([64.26.60.145]:46221 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751645AbaLHTKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:10:09 -0500
Date: Mon, 8 Dec 2014 14:11:26 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        vincent.weaver@maine.edu
Subject: Re: Linux 3.18 released
In-Reply-To: <alpine.DEB.2.10.1412081331580.28373@pianoman.cluster.toy>
Message-ID: <alpine.DEB.2.10.1412081409180.29946@pianoman.cluster.toy>
References: <CA+55aFwK3XtS32iJna-2uXZUfZQNUGC0Z4FmEFHK4JXB_kyojA@mail.gmail.com> <alpine.DEB.2.10.1412081331580.28373@pianoman.cluster.toy>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020205.5485F790.0112,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2014, Vince Weaver wrote:

> down.  They are borderline heisenbugs that are possibly race conditions, 
> so bisecting doesn't work and even things like enablibg ftrace will make 
> the issue go away (or crash ftrace itself).

For example, just trying to enable some extra printks in the fuzzer to get 
a log of the syscalls causing the problem quickly causes this:

[  398.604507] ------------[ cut here ]------------
[  398.604507] WARNING: CPU: 0 PID: 2889 at kernel/watchdog.c:290 watchdog_overflow_callback+0x9b/0xa6()
[  398.604507] Watchdog detected hard LOCKUP on cpu 0
[  398.604507] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg evdev mcs7830 usbnet ohci_pci psmouse pcspkr serio_raw coretemp ohci_hcd wmi video button i2c_nforce2 acpi_cpufreq processor thermal_sys sg sd_mod ehci_pci ehci_hcd usbcore usb_common
[  398.604507] CPU: 0 PID: 2889 Comm: perf_fuzzer Not tainted 3.18.0+ #166
[  398.604507] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  398.604507]  0000000000000122 ffff88011fc06ba8 ffffffff8155cf3b 0000000000000122
[  398.604507]  ffff88011fc06bf8 ffff88011fc06be8 ffffffff8104361b 0000000000000000
[  398.604507]  ffffffff810b1711 ffff88011f055000 0000000000000000 ffff88011fc06d28
[  398.604507] Call Trace:
[  398.604507]  <NMI>  [<ffffffff8155cf3b>] dump_stack+0x49/0x5e
[  398.604507]  [<ffffffff8104361b>] warn_slowpath_common+0x81/0x9b
[  398.604507]  [<ffffffff810b1711>] ? watchdog_overflow_callback+0x9b/0xa6
[  398.604507]  [<ffffffff810436d8>] warn_slowpath_fmt+0x46/0x48
[  398.604507]  [<ffffffff810b1711>] watchdog_overflow_callback+0x9b/0xa6
[  398.604507]  [<ffffffff810dafbe>] __perf_event_overflow+0x13c/0x1c6
[  398.604507]  [<ffffffff810db684>] perf_event_overflow+0x19/0x1b
[  398.604507]  [<ffffffff8101ab1e>] intel_pmu_handle_irq+0x2e3/0x378
[  398.604507]  [<ffffffff81013dcf>] perf_event_nmi_handler+0x2d/0x4a
[  398.604507]  [<ffffffff8100636f>] nmi_handle+0x5c/0xf9
[  398.604507]  [<ffffffff810065db>] default_do_nmi+0x4e/0xe2
[  398.604507]  [<ffffffff810066d9>] do_nmi+0x6a/0xaf
[  398.604507]  [<ffffffff81561dda>] end_repeat_nmi+0x1e/0x2e
[  398.604507]  [<ffffffff8155fbec>] ? _raw_spin_lock+0x26/0x2a
[  398.604507]  [<ffffffff8155fbec>] ? _raw_spin_lock+0x26/0x2a
[  398.604507]  [<ffffffff8155fbec>] ? _raw_spin_lock+0x26/0x2a
[  398.604507]  <<EOE>>  [<ffffffff810d5fc7>] perf_ctx_lock+0x28/0x2d
[  398.604507]  [<ffffffff810d8854>] perf_event_context_sched_in+0x3d/0xa0
[  398.604507]  [<ffffffff810d8a4e>] __perf_event_task_sched_in+0x3f/0x111
[  398.604507]  [<ffffffff8106570f>] finish_task_switch+0x46/0xad
[  398.604507]  [<ffffffff8155d48d>] __schedule+0x454/0x4a8
[  398.604507]  [<ffffffff8155d64f>] schedule+0x6e/0x70
[  398.604507]  [<ffffffff811ec527>] jbd2_log_wait_commit+0xa5/0xf0
[  398.604507]  [<ffffffff8106e17e>] ? signal_pending_state+0x35/0x35
[  398.604507]  [<ffffffff8114c79b>] ? default_file_splice_read+0x2d1/0x2d1
[  398.604507]  [<ffffffff811c03a9>] ext4_sync_fs+0xd6/0x124
[  398.604507]  [<ffffffff8114c7bb>] sync_fs_one_sb+0x20/0x22
[  398.604507]  [<ffffffff811295cb>] iterate_supers+0x6e/0xbf
[  398.604507]  [<ffffffff8114cb2f>] sys_sync+0x55/0x83
[  398.604507]  [<ffffffff81560016>] system_call_fastpath+0x16/0x1b
[  398.604507] ---[ end trace cb94cd46e328aa66 ]---
[  401.000000] ------------[ cut here ]------------
[  401.000000] WARNING: CPU: 1 PID: 3296 at kernel/watchdog.c:290 watchdog_overflow_callback+0x9b/0xa6()
[  401.000000] Watchdog detected hard LOCKUP on cpu 1
[  401.000000] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg evdev mcs7830 usbnet ohci_pci psmouse pcspkr serio_raw coretemp ohci_hcd wmi video button i2c_nforce2 acpi_cpufreq processor thermal_sys sg sd_mod ehci_pci ehci_hcd usbcore usb_common
[  401.000000] CPU: 1 PID: 3296 Comm: perf_fuzzer Tainted: G        W      3.18.0+ #166
[  401.000000] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  401.000000]  0000000000000122 ffff88011fc86ba8 ffffffff8155cf3b 0000000000000122
[  401.000000]  ffff88011fc86bf8 ffff88011fc86be8 ffffffff8104361b 0000000000000000
[  401.000000]  ffffffff810b1711 ffff88011b3bec00 0000000000000000 ffff88011fc86d28
[  401.000000] Call Trace:
[  401.000000]  <NMI>  [<ffffffff8155cf3b>] dump_stack+0x49/0x5e
[  401.000000]  [<ffffffff8104361b>] warn_slowpath_common+0x81/0x9b
[  401.000000]  [<ffffffff810b1711>] ? watchdog_overflow_callback+0x9b/0xa6
[  401.000000]  [<ffffffff810436d8>] warn_slowpath_fmt+0x46/0x48
[  401.000000]  [<ffffffff810b1711>] watchdog_overflow_callback+0x9b/0xa6
[  401.000000]  [<ffffffff810dafbe>] __perf_event_overflow+0x13c/0x1c6
[  401.000000]  [<ffffffff810db684>] perf_event_overflow+0x19/0x1b
[  401.000000]  [<ffffffff8101ab1e>] intel_pmu_handle_irq+0x2e3/0x378
[  401.000000]  [<ffffffff81013dcf>] perf_event_nmi_handler+0x2d/0x4a
[  401.000000]  [<ffffffff8100636f>] nmi_handle+0x5c/0xf9
[  401.000000]  [<ffffffff810065db>] default_do_nmi+0x4e/0xe2
[  401.000000]  [<ffffffff810066d9>] do_nmi+0x6a/0xaf
[  401.000000]  [<ffffffff81561dda>] end_repeat_nmi+0x1e/0x2e
[  401.000000]  [<ffffffff8155fbe5>] ? _raw_spin_lock+0x1f/0x2a
[  401.000000]  [<ffffffff8155fbe5>] ? _raw_spin_lock+0x1f/0x2a
[  401.000000]  [<ffffffff8155fbe5>] ? _raw_spin_lock+0x1f/0x2a
[  401.000000]  <<EOE>>  <IRQ>  [<ffffffff8106c391>] sched_rt_period_timer+0x8b/0x1f2
[  401.000000]  [<ffffffff8108a6b7>] __run_hrtimer+0xba/0x145
[  401.000000]  [<ffffffff8106c306>] ? init_rt_bandwidth+0x46/0x46
[  401.000000]  [<ffffffff8108a91a>] hrtimer_interrupt+0xd5/0x1c3
[  401.000000]  [<ffffffff8102d209>] local_apic_timer_interrupt+0x58/0x5d
[  401.000000]  [<ffffffff8102d6b0>] smp_apic_timer_interrupt+0x2a/0x3c
[  401.000000]  [<ffffffff81560eaa>] apic_timer_interrupt+0x6a/0x70
[  401.000000]  <EOI> 
[  401.000000] ---[ end trace cb94cd46e328aa67 ]---

