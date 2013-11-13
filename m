Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab3KMWhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 17:37:47 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:49700 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3KMWhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 17:37:38 -0500
Date: Wed, 13 Nov 2013 17:45:59 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: perf sw_event related lockup
Message-ID: <alpine.DEB.2.10.1311131739560.5706@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

so with the perf_fuzzer modified to avoid the tracepoint issues, I've 
triggered this software-event related soft lockup.

>From what I can gather from the backtraces, they all map to the loop
in do_perf_sw_event() in kernel/events/core.c

        hlist_for_each_entry_rcu(event, head, hlist_entry) {
                if (perf_swevent_match(event, type, event_id, data, regs))
                        perf_swevent_event(event, nr, data, regs);
        }

is it possible to get stuck in that as an infinite loop?

below is the dmesg from the lockup, I eventually had to reboot to clear 
the problem:

[  345.354950] NOHZ: local_softirq_pending 100
[  416.043831] ------------[ cut here ]------------
[  416.047607] WARNING: CPU: 0 PID: 2853 at arch/x86/kernel/cpu/perf_event.c:1076 x86_pmu_start+0x46/0xee()
[  416.047607] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg acpi_cpufreq mcs7830 psmouse usbnet evdev serio_raw coretemp pcspkr video wmi processor ohci_pci thermal_sys ohci_hcd button i2c_nforce2 sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[  416.047607] CPU: 0 PID: 2853 Comm: perf_fuzzer Not tainted 3.12.0 #2
[  416.047607] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  416.047607]  0000000000000434 ffff88011ad81bc8 ffffffff8151aad6 0000000000000000
[  416.047607]  ffffffff8103cd68 ffff88011fc15b38 ffffffff810127b3 ffff88011b313400
[  416.047607]  0000000000000021 0000000000000000 0000000000000000 ffff88011fc0b940
[  416.047607] Call Trace:
[  416.047607]  [<ffffffff8151aad6>] ? dump_stack+0x41/0x53
[  416.047607]  [<ffffffff8103cd68>] ? warn_slowpath_common+0x81/0x9c
[  416.047607]  [<ffffffff810127b3>] ? x86_pmu_start+0x46/0xee
[  416.047607]  [<ffffffff810127b3>] ? x86_pmu_start+0x46/0xee
[  416.047607]  [<ffffffff81012a2e>] ? x86_pmu_enable+0x1d3/0x285
[  416.047607]  [<ffffffff810c79e0>] ? perf_event_context_sched_in+0x6d/0x8d
[  416.047607]  [<ffffffff810c7a21>] ? __perf_event_task_sched_in+0x21/0x108
[  416.047607]  [<ffffffff8106657b>] ? finish_task_switch+0x46/0x98
[  416.047607]  [<ffffffff8151c9ee>] ? __schedule+0x4f7/0x54b
[  416.047607]  [<ffffffff810667ad>] ? __cond_resched+0x2a/0x35
[  416.047607]  [<ffffffff8151cabd>] ? _cond_resched+0x2c/0x37
[  416.047607]  [<ffffffff8151afc1>] ? mutex_lock+0x16/0x37
[  416.047607]  [<ffffffff8131575b>] ? n_tty_write+0x2aa/0x3eb
[  416.047607]  [<ffffffff810664d6>] ? try_to_wake_up+0x1ab/0x1ab
[  416.047607]  [<ffffffff81312de6>] ? tty_write+0x19c/0x22e
[  416.047607]  [<ffffffff813154b1>] ? n_tty_ioctl+0xc5/0xc5
[  416.047607]  [<ffffffff81112a67>] ? vfs_write+0xb9/0x132
[  416.047607]  [<ffffffff81112bc2>] ? SyS_write+0x59/0x86
[  416.047607]  [<ffffffff81524e11>] ? tracesys+0xd4/0xd9
[  416.047607] ---[ end trace ce7dd64597479b92 ]---
[  416.755310] NOHZ: local_softirq_pending 100
[  452.232000] BUG: soft lockup - CPU#1 stuck for 23s! [perf_fuzzer:7211]
[  452.232000] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg acpi_cpufreq mcs7830 psmouse usbnet evdev serio_raw coretemp pcspkr video wmi processor ohci_pci thermal_sys ohci_hcd button i2c_nforce2 sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[  452.232000] CPU: 1 PID: 7211 Comm: perf_fuzzer Tainted: G        W    3.12.0 #2
[  452.232000] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  452.232000] task: ffff8800c4bd6100 ti: ffff8800c42fa000 task.ti: ffff8800c42fa000
[  452.232000] RIP: 0010:[<ffffffff810caa4c>]  [<ffffffff810caa4c>] __perf_sw_event+0x9a/0x1a5
[  452.232000] RSP: 0018:ffff8800c42fbc98  EFLAGS: 00000286
[  452.232000] RAX: ffff880037f5ec16 RBX: ffff88011fc92ac0 RCX: ffff8800c42fbe88
[  452.232000] RDX: ffff8800c42fbc98 RSI: 0000000000000001 RDI: ffff880037f5ec00
[  452.232000] RBP: 0000000000000001 R08: 0000000000000018 R09: 0140000000000000
[  452.232000] R10: ffff88011fc92ac0 R11: ffff88011b348010 R12: bf4bf357febfceb5
[  452.232000] R13: 0000000000000001 R14: f9eed3fcf7377feb R15: fdd3ff677744feef
[  452.232000] FS:  00007f01b4263700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
[  452.232000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  452.232000] CR2: 00007f01b42639d0 CR3: 00000000c40f1000 CR4: 00000000000407e0
[  452.232000] DR0: 0000000001404010 DR1: 0000000080002706 DR2: 0000000100000000
[  452.232000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  452.232000] Stack:
[  452.232000]  79d2f9f7ffffefff bfb7cedef5dbdfee ffdfefcf57ffbf76 dcfe7f7fdddbef2f
[  452.232000]  00007f01b42639d0 fed7dbefff6ef7dd f7ffffeef7bbf7f8 dbdf9f0fdf7ffff3
[  452.232000]  0000000000000000 0000000000000000 afaecfbfbbe5eefb 0000000000000000
[  452.232000] Call Trace:
[  452.232000]  [<ffffffff81520fa3>] ? __do_page_fault+0x191/0x3f5
[  452.232000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
[  452.232000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
[  452.232000]  [<ffffffff8151e232>] ? page_fault+0x22/0x30
[  452.232000]  [<ffffffff8129cfe0>] ? __put_user_4+0x20/0x30
[  452.232000]  [<ffffffff81066629>] ? schedule_tail+0x5c/0x60
[  452.232000]  [<ffffffff81524b7f>] ? ret_from_fork+0xf/0xb0
[  452.232000] Code: 48 c7 84 24 80 00 00 00 00 00 00 00 48 c7 44 24 48 00 00 00 00 65 48 03 04 25 78 cd 00 00 48 8b 08 48 85 c9 75 68 e9 c9 00 00 00 <41> 83 bc 24 b0 00 00 00 01 75 48 4d 39 b4 24 b8 00 00 00 75 3e 
[  480.231999] BUG: soft lockup - CPU#1 stuck for 23s! [perf_fuzzer:7211]
[  480.232000] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg acpi_cpufreq mcs7830 psmouse usbnet evdev serio_raw coretemp pcspkr video wmi processor ohci_pci thermal_sys ohci_hcd button i2c_nforce2 sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[  480.232000] CPU: 1 PID: 7211 Comm: perf_fuzzer Tainted: G        W    3.12.0 #2
[  480.232000] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  480.232000] task: ffff8800c4bd6100 ti: ffff8800c42fa000 task.ti: ffff8800c42fa000
[  480.232000] RIP: 0010:[<ffffffff810cab0c>]  [<ffffffff810cab0c>] __perf_sw_event+0x15a/0x1a5
[  480.232000] RSP: 0018:ffff8800c42fbc98  EFLAGS: 00000286
[  480.232000] RAX: ffff880037f5ec16 RBX: ffff88011fc92ac0 RCX: ffff8800c42fbe88
[  480.232000] RDX: ffff8800c42fbc98 RSI: 0000000000000001 RDI: ffff880037f5ec00
[  480.232000] RBP: 0000000000000001 R08: 0000000000000018 R09: 0140000000000000
[  480.232000] R10: ffff88011fc92ac0 R11: ffff88011b348010 R12: bf4bf357febfceb5
[  480.232000] R13: 0000000000000001 R14: f9eed3fcf7377feb R15: fdd3ff677744feef
[  480.232000] FS:  00007f01b4263700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
[  480.232000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  480.232000] CR2: 00007f01b42639d0 CR3: 00000000c40f1000 CR4: 00000000000407e0
[  480.232000] DR0: 0000000001404010 DR1: 0000000080002706 DR2: 0000000100000000
[  480.232000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  480.232000] Stack:
[  480.232000]  79d2f9f7ffffefff bfb7cedef5dbdfee ffdfefcf57ffbf76 dcfe7f7fdddbef2f
[  480.232000]  00007f01b42639d0 fed7dbefff6ef7dd f7ffffeef7bbf7f8 dbdf9f0fdf7ffff3
[  480.232000]  0000000000000000 0000000000000000 afaecfbfbbe5eefb 0000000000000000
[  480.232000] Call Trace:
[  480.232000]  [<ffffffff81520fa3>] ? __do_page_fault+0x191/0x3f5
[  480.232000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
[  480.232000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
[  480.232000]  [<ffffffff8151e232>] ? page_fault+0x22/0x30
[  480.232000]  [<ffffffff8129cfe0>] ? __put_user_4+0x20/0x30
[  480.232000]  [<ffffffff81066629>] ? schedule_tail+0x5c/0x60
[  480.232000]  [<ffffffff81524b7f>] ? ret_from_fork+0xf/0xb0
[  480.232000] Code: 48 c1 e6 39 48 c1 e0 3f 4c 29 c2 48 01 fa 48 29 f2 48 8d 04 02 48 c1 e8 38 48 8d 04 c1 48 8b 00 48 8d 50 c0 48 85 c0 4c 0f 45 e2 <4d> 85 e4 0f 85 37 ff ff ff 48 c7 c0 90 ed 00 00 65 48 03 04 25 
[  486.527998] INFO: rcu_sched self-detected stall on CPU
[  486.531999] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=15002 jiffies, g=6562, c=6561, q=96)
[  486.532000] sending NMI to all CPUs:
[  486.528000] NMI backtrace for cpu 1
[  486.528000] CPU: 1 PID: 7211 Comm: perf_fuzzer Tainted: G        W    3.12.0 #2
[  486.528000] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  486.528000] task: ffff8800c4bd6100 ti: ffff8800c42fa000 task.ti: ffff8800c42fa000
[  486.528000] RIP: 0010:[<ffffffff8129c063>]  [<ffffffff8129c063>] delay_tsc+0x23/0x50
[  486.528000] RSP: 0018:ffff88011fc83ba8  EFLAGS: 00000046
[  486.528000] RAX: 0000000018e375ef RBX: ffffffff81c86d40 RCX: 0000000018e3731d
[  486.528000] RDX: 000000000000012b RSI: 0000000000000001 RDI: 00000000000009d2
[  486.528000] RBP: ffff88011fc83ba8 R08: 0000000000000001 R09: 0000000300000003
[  486.528000] R10: 0000000000000005 R11: ffff88011fc83f00 R12: 00000000000026f2
[  486.528000] R13: 0000000000000020 R14: ffffffff81c04982 R15: ffffffff8132c081
[  486.528000] FS:  00007f01b4263700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
[  486.528000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  486.528000] CR2: 00007f01b42639d0 CR3: 00000000c40f1000 CR4: 00000000000407e0
[  486.528000] DR0: 0000000001404010 DR1: 0000000080002706 DR2: 0000000100000000
[  486.528000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  486.528000] Stack:
[  486.528000]  ffff88011fc83bd8 ffffffff8132c039 0000000300000003 ffffffff81c86d40
[  486.528000]  0000000000000046 0000000000000039 ffff88011fc83bf8 ffffffff8132c09d
[  486.528000]  ffffffff81c04970 ffffffff81c86d40 ffff88011fc83c38 ffffffff813284f9
[  486.528000] Call Trace:
[  486.528000]  <IRQ>  [<ffffffff8132c039>] ? wait_for_xmitr+0x4b/0x93
[  486.528000]  [<ffffffff8132c09d>] ? serial8250_console_putchar+0x1c/0x2e
[  486.528000]  [<ffffffff813284f9>] ? uart_console_write+0x45/0x5b
[  486.528000]  [<ffffffff8132deab>] ? serial8250_console_write+0xb4/0x102
[  486.528000]  [<ffffffff810779f8>] ? T.924+0xb9/0xcb
[  486.528000]  [<ffffffff81077b36>] ? console_unlock+0x12c/0x32c
[  486.528000]  [<ffffffff810782f5>] ? vprintk_emit+0x3ca/0x3f3
[  486.528000]  [<ffffffff8151a94d>] ? printk+0x4d/0x4f
[  486.528000]  [<ffffffff81067bd7>] ? sched_slice+0x80/0x82
[  486.528000]  [<ffffffff810a3beb>] ? rcu_check_callbacks+0x14e/0x5bf
[  486.528000]  [<ffffffff810471e8>] ? update_process_times+0x41/0x71
[  486.528000]  [<ffffffff8108729a>] ? tick_sched_handle+0x4a/0x58
[  486.528000]  [<ffffffff81087465>] ? tick_sched_timer+0x5d/0x7c
[  486.528000]  [<ffffffff8105be6e>] ? __run_hrtimer+0xba/0x145
[  486.528000]  [<ffffffff81087408>] ? tick_nohz_handler+0xb0/0xb0
[  486.528000]  [<ffffffff8105c143>] ? hrtimer_interrupt+0xd5/0x1c6
[  486.528000]  [<ffffffff815269e4>] ? smp_trace_apic_timer_interrupt+0x53/0x91
[  486.528000]  [<ffffffff8152597a>] ? trace_apic_timer_interrupt+0x6a/0x70
[  486.528000]  <EOI>  [<ffffffff810cab38>] ? __perf_sw_event+0x186/0x1a5
[  486.528000]  [<ffffffff810cab40>] ? __perf_sw_event+0x18e/0x1a5
[  486.528000]  [<ffffffff81520fa3>] ? __do_page_fault+0x191/0x3f5
[  486.528000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
[  486.528000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
[  486.528000]  [<ffffffff8151e232>] ? page_fault+0x22/0x30
[  486.528000]  [<ffffffff8129cfe0>] ? __put_user_4+0x20/0x30
[  486.528000]  [<ffffffff81066629>] ? schedule_tail+0x5c/0x60
[  486.528000]  [<ffffffff81524b7f>] ? ret_from_fork+0xf/0xb0
[  486.528000] Code: 8d 3c bf e9 ae ff ff ff 55 48 89 e5 66 66 66 66 90 65 8b 34 25 d0 b0 00 00 66 66 90 0f ae e8 0f 31 89 c1 66 66 90 0f ae e8 0f 31 <89> c2 29 ca 39 fa 73 23 f3 90 65 44 8b 04 25 d0 b0 00 00 44 39 
[  486.532000] NMI backtrace for cpu 0
[  486.532000] CPU: 0 PID: 7215 Comm: perf_fuzzer Tainted: G        W    3.12.0 #2
[  486.532000] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  486.532000] task: ffff8800c425a180 ti: ffff8800c4316000 task.ti: ffff8800c4316000
[  486.532000] RIP: 0010:[<ffffffff8129c003>]  [<ffffffff8129c003>] __const_udelay+0x15/0x29
[  486.532000] RSP: 0000:ffff88011fc03da8  EFLAGS: 00000092
[  486.532000] RAX: 0000000001062560 RBX: 0000000000000001 RCX: 0000000000000003
[  486.532000] RDX: 00000000009aa0a0 RSI: 0000000000000200 RDI: 0000000000418958
[  486.532000] RBP: ffff88011fc03dc8 R08: 0000000000000000 R09: 0000000000000008
[  486.532000] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88011fc0d9d0
[  486.532000] R13: ffffffff81a39780 R14: 0000000000000001 R15: ffff8800c4316010
[  486.532000] FS:  00007f01b4263700(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
[  486.532000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  486.532000] CR2: 00007f9cc6ece188 CR3: 00000000c4780000 CR4: 00000000000407f0
[  486.532000] DR0: 0000000100000000 DR1: 0000000080002706 DR2: 0000000100000000
[  486.532000] DR3: 0000000080000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  486.532000] Stack:
[  486.532000]  ffffffff81a39780 ffffffff81028fa0 00000000000019a1 ffffffff81a39780
[  486.532000]  ffff88011fc03e38 ffffffff810a3ee2 00000000008efa7e ffffffff81a39780
[  486.532000]  0000000000000060 ffffffff81a9bd70 0000000000000000 0000000000000083
[  486.532000] Call Trace:
[  486.532000]  <IRQ>  [<ffffffff81028fa0>] ? arch_trigger_all_cpu_backtrace+0x78/0x8c
[  486.532000]  [<ffffffff810a3ee2>] ? rcu_check_callbacks+0x445/0x5bf
[  486.532000]  [<ffffffff810471e8>] ? update_process_times+0x41/0x71
[  486.532000]  [<ffffffff8108729a>] ? tick_sched_handle+0x4a/0x58
[  486.532000]  [<ffffffff81087465>] ? tick_sched_timer+0x5d/0x7c
[  486.532000]  [<ffffffff8105be6e>] ? __run_hrtimer+0xba/0x145
[  486.532000]  [<ffffffff81087408>] ? tick_nohz_handler+0xb0/0xb0
[  486.532000]  [<ffffffff8105c143>] ? hrtimer_interrupt+0xd5/0x1c6
[  486.532000]  [<ffffffff815269e4>] ? smp_trace_apic_timer_interrupt+0x53/0x91
[  486.532000]  [<ffffffff8152597a>] ? trace_apic_timer_interrupt+0x6a/0x70
[  486.532000]  <EOI> Code: 17 c9 c3 55 48 89 e5 66 66 66 66 90 48 8b 05 ad 42 7c 00 c9 ff e0 48 83 ec 08 48 8d 04 bd 00 00 00 00 65 48 8b 14 25 e0 22 01 00 <48> 6b d2 3e f7 e2 48 8b 05 88 42 7c 00 48 8d 7a 01 5a ff e0 55 
[  486.528000]  { 1}  (t=15424 jiffies g=6562 c=6561 q=96)
[  486.528000] sending NMI to all CPUs:
[  486.528000] NMI backtrace for cpu 1
[  486.528000] CPU: 1 PID: 7211 Comm: perf_fuzzer Tainted: G        W    3.12.0 #2
[  486.528000] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  486.528000] task: ffff8800c4bd6100 ti: ffff8800c42fa000 task.ti: ffff8800c42fa000
[  486.528000] RIP: 0010:[<ffffffff8129c063>]  [<ffffffff8129c063>] delay_tsc+0x23/0x50
[  486.528000] RSP: 0018:ffff88011fc83da8  EFLAGS: 00000893
[  486.528000] RAX: 000000001b2ef428 RBX: 0000000000000001 RCX: 000000001b2ef402
[  486.528000] RDX: 000000000000012c RSI: 0000000000000001 RDI: 0000000000265910
[  486.528000] RBP: ffff88011fc83da8 R08: 0000000000000000 R09: 0000000000000008
[  486.528000] R10: ffff88011fc83be8 R11: ffff88011f01f400 R12: ffff88011fc8d9d0
[  486.528000] R13: ffffffff81a39780 R14: ffffffff81a3b088 R15: ffff8800c42fa010
[  486.528000] FS:  00007f01b4263700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
[  486.528000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  486.528000] CR2: 00007f01b42639d0 CR3: 00000000c40f1000 CR4: 00000000000407e0
[  486.528000] DR0: 0000000001404010 DR1: 0000000080002706 DR2: 0000000100000000
[  486.528000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  486.528000] Stack:
[  486.528000]  ffff88011fc83dc8 ffffffff81028fa0 0000000000000060 ffffffff81a39780
[  486.528000]  ffff88011fc83e38 ffffffff810a3c8e ffffffff81a14b60 0000000000000000
[  486.528000]  0000000000000060 ffffffff81a9bd70 0000000000000001 0000000000000000
[  486.528000] Call Trace:
[  486.528000]  <IRQ> 
[  486.528000]  [<ffffffff81028fa0>] ? arch_trigger_all_cpu_backtrace+0x78/0x8c
[  486.528000]  [<ffffffff810a3c8e>] ? rcu_check_callbacks+0x1f1/0x5bf
[  486.528000]  [<ffffffff810471e8>] ? update_process_times+0x41/0x71
[  486.528000]  [<ffffffff8108729a>] ? tick_sched_handle+0x4a/0x58
[  486.528000]  [<ffffffff81087465>] ? tick_sched_timer+0x5d/0x7c
[  486.528000]  [<ffffffff8105be6e>] ? __run_hrtimer+0xba/0x145
[  486.528000]  [<ffffffff81087408>] ? tick_nohz_handler+0xb0/0xb0
[  486.528000]  [<ffffffff8105c143>] ? hrtimer_interrupt+0xd5/0x1c6
[  486.528000]  [<ffffffff815269e4>] ? smp_trace_apic_timer_interrupt+0x53/0x91
[  486.528000]  [<ffffffff8152597a>] ? trace_apic_timer_interrupt+0x6a/0x70
[  486.528000]  <EOI> 
[  486.528000]  [<ffffffff810cab38>] ? __perf_sw_event+0x186/0x1a5
[  486.528000]  [<ffffffff810cab40>] ? __perf_sw_event+0x18e/0x1a5
[  486.528000]  [<ffffffff81520fa3>] ? __do_page_fault+0x191/0x3f5
[  486.528000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
[  486.528000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
[  486.528000]  [<ffffffff8151e232>] ? page_fault+0x22/0x30
[  486.528000]  [<ffffffff8129cfe0>] ? __put_user_4+0x20/0x30
[  486.528000]  [<ffffffff81066629>] ? schedule_tail+0x5c/0x60
[  486.528000]  [<ffffffff81524b7f>] ? ret_from_fork+0xf/0xb0
[  486.528000] Code: 8d 3c bf e9 ae ff ff ff 55 48 89 e5 66 66 66 66 90 65 8b 34 25 d0 b0 00 00 66 66 90 0f ae e8 0f 31 89 c1 66 66 90 0f ae e8 0f 31 <89> c2 29 ca 39 fa 73 23 f3 90 65 44 8b 04 25 d0 b0 00 00 44 39 
[  488.244000] NMI backtrace for cpu 0
[  486.528000] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 828.947 msecs
[  488.244000] CPU: 0 PID: 7215 Comm: perf_fuzzer Tainted: G        W    3.12.0 #2
[  488.244000] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  488.244000] task: ffff8800c425a180 ti: ffff8800c4316000 task.ti: ffff8800c4316000
[  488.244000] RIP: 0033:[<0000000000406c67>]  [<0000000000406c67>] 0x406c66
[  488.244000] RSP: 002b:00007fff569a7dd8  EFLAGS: 00000206
[  488.244000] RAX: 0000000000000000 RBX: 346dc5d63886594b RCX: 000000000000a7ca
[  488.244000] RDX: 0000000000000000 RSI: 00007f01b404b640 RDI: 00007f01b404c240
[  488.244000] RBP: 00000000ffffffff R08: 0000000000000000 R09: 00007f01b4263700
[  488.244000] R10: 00007f01b42639d0 R11: 0000000000000246 R12: ffffffffffffffff
[  488.244000] R13: 0000000000000033 R14: 0000000000000053 R15: 0000000000694a68
[  488.244000] FS:  00007f01b4263700(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
[  488.244000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  488.244000] CR2: 00007f9cc6ece188 CR3: 00000000c4780000 CR4: 00000000000407f0
[  488.244000] DR0: 0000000100000000 DR1: 0000000080002706 DR2: 0000000100000000
[  488.244000] DR3: 0000000080000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  488.244000] 
[  488.244000] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 1192.664 msecs
[  512.231999] BUG: soft lockup - CPU#1 stuck for 22s! [perf_fuzzer:7211]
[  512.232000] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg acpi_cpufreq mcs7830 psmouse usbnet evdev serio_raw coretemp pcspkr video wmi processor ohci_pci thermal_sys ohci_hcd button i2c_nforce2 sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[  512.232000] CPU: 1 PID: 7211 Comm: perf_fuzzer Tainted: G        W    3.12.0 #2
[  512.232000] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  512.232000] task: ffff8800c4bd6100 ti: ffff8800c42fa000 task.ti: ffff8800c42fa000
[  512.232000] RIP: 0010:[<ffffffff810caa8a>]  [<ffffffff810caa8a>] __perf_sw_event+0xd8/0x1a5
[  512.232000] RSP: 0018:ffff8800c42fbc98  EFLAGS: 00000246
[  512.232000] RAX: ffff880037f5ec16 RBX: ffff88011fc92ac0 RCX: ffff8800c42fbe88
[  512.232000] RDX: ffff8800c42fbc98 RSI: 0000000000000001 RDI: ffff880037f5ec00
[  512.232000] RBP: 0000000000000001 R08: 0000000000000018 R09: 0140000000000000
[  512.232000] R10: ffff88011fc92ac0 R11: ffff88011b348010 R12: bf4bf357febfceb5
[  512.232000] R13: 0000000000000001 R14: f9eed3fcf7377feb R15: fdd3ff677744feef
[  512.232000] FS:  00007f01b4263700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
[  512.232000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  512.232000] CR2: 00007f01b42639d0 CR3: 00000000c40f1000 CR4: 00000000000407e0
[  512.232000] DR0: 0000000001404010 DR1: 0000000080002706 DR2: 0000000100000000
[  512.232000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  512.232000] Stack:
[  512.232000]  79d2f9f7ffffefff bfb7cedef5dbdfee ffdfefcf57ffbf76 dcfe7f7fdddbef2f
[  512.232000]  00007f01b42639d0 fed7dbefff6ef7dd f7ffffeef7bbf7f8 dbdf9f0fdf7ffff3
[  512.232000]  0000000000000000 0000000000000000 afaecfbfbbe5eefb 0000000000000000
[  512.232000] Call Trace:
[  512.232000]  [<ffffffff81520fa3>] ? __do_page_fault+0x191/0x3f5
[  512.232000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
[  512.232000]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
[  512.232000]  [<ffffffff8151e232>] ? page_fault+0x22/0x30
[  512.232000]  [<ffffffff8129cfe0>] ? __put_user_4+0x20/0x30
[  512.232000]  [<ffffffff81066629>] ? schedule_tail+0x5c/0x60
[  512.232000]  [<ffffffff81524b7f>] ? ret_from_fork+0xf/0xb0
[  512.232000] Code: 75 3e 41 f6 84 24 80 01 00 00 01 75 33 48 85 db 0f 84 ba 00 00 00 41 8a 84 24 d8 00 00 00 a8 10 74 09 f6 83 88 00 00 00 03 75 15 <a8> 20 0f 84 9d 00 00 00 f6 83 88 00 00 00 03 0f 85 90 00 00 00 
[  540.232001] BUG: soft lockup - CPU#1 stuck for 23s! [perf_fuzzer:7211]
[  540.232001] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg acpi_cpufreq mcs7830 psmouse usbnet evdev serio_raw coretemp pcspkr video wmi processor ohci_pci thermal_sys ohci_hcd button i2c_nforce2 sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[  540.232001] CPU: 1 PID: 7211 Comm: perf_fuzzer Tainted: G        W    3.12.0 #2
[  540.232001] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  540.232001] task: ffff8800c4bd6100 ti: ffff8800c42fa000 task.ti: ffff8800c42fa000
[  540.232001] RIP: 0010:[<ffffffff810caaad>]  [<ffffffff810caaad>] __perf_sw_event+0xfb/0x1a5
[  540.232001] RSP: 0018:ffff8800c42fbc98  EFLAGS: 00000286
[  540.232001] RAX: ffff880037f5ec16 RBX: ffff88011fc92ac0 RCX: ffff8800c42fbe88
[  540.232001] RDX: ffff8800c42fbc98 RSI: 0000000000000001 RDI: ffff880037f5ec00
[  540.232001] RBP: 0000000000000001 R08: 0000000000000018 R09: 0140000000000000
[  540.232001] R10: ffff88011fc92ac0 R11: ffff88011b348010 R12: bf4bf357febfceb5
[  540.232001] R13: 0000000000000001 R14: f9eed3fcf7377feb R15: fdd3ff677744feef
[  540.232001] FS:  00007f01b4263700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
[  540.232001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  540.232001] CR2: 00007f01b42639d0 CR3: 00000000c40f1000 CR4: 00000000000407e0
[  540.232001] DR0: 0000000001404010 DR1: 0000000080002706 DR2: 0000000100000000
[  540.232001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  540.232001] Stack:
[  540.232001]  79d2f9f7ffffefff bfb7cedef5dbdfee ffdfefcf57ffbf76 dcfe7f7fdddbef2f
[  540.232001]  00007f01b42639d0 fed7dbefff6ef7dd f7ffffeef7bbf7f8 dbdf9f0fdf7ffff3
[  540.232001]  0000000000000000 0000000000000000 afaecfbfbbe5eefb 0000000000000000
[  540.232001] Call Trace:
[  540.232001]  [<ffffffff81520fa3>] ? __do_page_fault+0x191/0x3f5
[  540.232001]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
[  540.232001]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
[  540.232001]  [<ffffffff8151e232>] ? page_fault+0x22/0x30
[  540.232001]  [<ffffffff8129cfe0>] ? __put_user_4+0x20/0x30
[  540.232001]  [<ffffffff81066629>] ? schedule_tail+0x5c/0x60
[  540.232001]  [<ffffffff81524b7f>] ? ret_from_fork+0xf/0xb0
[  540.232001] Code: 83 88 00 00 00 03 75 15 a8 20 0f 84 9d 00 00 00 f6 83 88 00 00 00 03 0f 85 90 00 00 00 4d 8b 64 24 40 4d 85 e4 74 6c 49 83 ec 40 <eb> 5d 45 89 f6 48 b8 00 00 00 00 01 00 00 00 48 ba 01 00 fc ff 
[  568.232001] BUG: soft lockup - CPU#1 stuck for 23s! [perf_fuzzer:7211]
[  568.232001] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg acpi_cpufreq mcs7830 psmouse usbnet evdev serio_raw coretemp pcspkr video wmi processor ohci_pci thermal_sys ohci_hcd button i2c_nforce2 sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[  568.232001] CPU: 1 PID: 7211 Comm: perf_fuzzer Tainted: G        W    3.12.0 #2
[  568.232001] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  568.232001] task: ffff8800c4bd6100 ti: ffff8800c42fa000 task.ti: ffff8800c42fa000
[  568.232001] RIP: 0010:[<ffffffff810ca6a4>]  [<ffffffff810ca6a4>] perf_swevent_overflow+0x58/0x58
[  568.232001] RSP: 0018:ffff8800c42fbc90  EFLAGS: 00000246
[  568.232001] RAX: ffff880037f5ec16 RBX: ffff88011fc92ac0 RCX: ffff8800c42fbe88
[  568.232001] RDX: ffff8800c42fbc98 RSI: 0000000000000001 RDI: ffff880037f5ec00
[  568.232001] RBP: 0000000000000001 R08: 0000000000000018 R09: 0140000000000000
[  568.232001] R10: ffff88011fc92ac0 R11: ffff88011b348010 R12: bf4bf357febfceb5
[  568.232001] R13: 0000000000000001 R14: f9eed3fcf7377feb R15: fdd3ff677744feef
[  568.232001] FS:  00007f01b4263700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
[  568.232001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  568.232001] CR2: 00007f01b42639d0 CR3: 00000000c40f1000 CR4: 00000000000407e0
[  568.232001] DR0: 0000000001404010 DR1: 0000000080002706 DR2: 0000000100000000
[  568.232001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  568.232001] Stack:
[  568.232001]  ffffffff810cab40 79d2f9f7ffffefff bfb7cedef5dbdfee ffdfefcf57ffbf76
[  568.232001]  dcfe7f7fdddbef2f 00007f01b42639d0 fed7dbefff6ef7dd f7ffffeef7bbf7f8
[  568.232001]  dbdf9f0fdf7ffff3 0000000000000000 0000000000000000 afaecfbfbbe5eefb
[  568.232001] Call Trace:
[  568.232001]  [<ffffffff810cab40>] ? __perf_sw_event+0x18e/0x1a5
[  568.232001]  [<ffffffff81520fa3>] ? __do_page_fault+0x191/0x3f5
[  568.232001]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
[  568.232001]  [<ffffffff81066edb>] ? sched_clock_local+0x13/0x76
[  568.232001]  [<ffffffff8151e232>] ? page_fault+0x22/0x30
[  568.232001]  [<ffffffff8129cfe0>] ? __put_user_4+0x20/0x30
[  568.232001]  [<ffffffff81066629>] ? schedule_tail+0x5c/0x60
[  568.232001]  [<ffffffff81524b7f>] ? ret_from_fork+0xf/0xb0
[  568.232001] Code: 75 1c eb 1f 4c 89 e9 4c 89 e2 48 89 ef e8 e9 fc ff ff 85 c0 75 0d 48 ff cb be 01 00 00 00 48 85 db 75 e1 5d 5b 5d 41 5c 41 5d c3 <48> 83 ec 08 48 01 77 70 48 85 c9 74 64 48 83 bf c0 00 00 00 00 
