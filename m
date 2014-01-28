Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbaA1VHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:07:06 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:40703 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821AbaA1VHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:07:04 -0500
Date: Tue, 28 Jan 2014 16:08:29 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: another perf_fuzzer soft lockup
Message-ID: <alpine.DEB.2.10.1401281554010.8613@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After some idle time I've started running the perf_fuzzer again.

It quickly found this lockup on a core2 system running 3.13 (yes, I should 
probably be running 3.14-git but I'd rather wait for rc1 first).

It looks like it's stuck in a lock in generic_exec_single() while
calling perf_event_task_output()?

I'll try to see if I can come up with a test case.

Vince

[347336.228001] BUG: soft lockup - CPU#1 stuck for 23s! [perf_fuzzer:13175]
[347336.228001] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg acpi_cpufreq mcs7830 usbnet evdev pcspkr video processor thermal_sys coretemp wmi psmouse serio_raw button ohci_pci ohci_hcd i2c_nforce2 sg ehci_pci ehci_hcd sd_mod usbcore usb_common
[347336.228001] CPU: 1 PID: 13175 Comm: perf_fuzzer Not tainted 3.13.0 #126
[347336.228001] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[347336.228001] task: ffff880000086ac0 ti: ffff8800cb2ea000 task.ti: ffff8800cb2ea000
[347336.228001] RIP: 0010:[<ffffffff810869cc>]  [<ffffffff810869cc>] generic_exec_single+0x7b/0x89
[347336.228001] RSP: 0018:ffff8800cb2ebdc8  EFLAGS: 00000202
[347336.228001] RAX: 00000000000008fb RBX: 0000000000000001 RCX: ffff880000086ac0
[347336.228001] RDX: 0000000000000206 RSI: 00000000000000fb RDI: 0000000000000001
[347336.228001] RBP: 0000000000000000 R08: 0000000000000206 R09: 00007fa82042e120
[347336.228001] R10: 00007fa82042e100 R11: 0000000000000246 R12: ffff8800cb2ebdc8
[347336.228001] R13: ffff8800a5e00800 R14: ffffffff810b70e6 R15: 00000000006a7380
[347336.228001] FS:  00007fa820646700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
[347336.228001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[347336.228001] CR2: 00000000006139c0 CR3: 00000000c2ca2000 CR4: 00000000000407e0
[347336.228001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[347336.228001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[347336.228001] Stack:
[347336.228001]  ffff880000086ac0 0000000000000000 ffffffff810b744d 0000000000000001
[347336.228001]  ffff8800cb2ebe68 0000000000000001 000000000000001e ffffffff81086b55
[347336.228001]  ffff88011fc13440 ffff88011fc13440 ffffffff810b744d ffff8800cb2ebe68
[347336.228001] Call Trace:
[347336.228001]  [<ffffffff810b744d>] ? perf_event_task_output+0x117/0x117
[347336.228001]  [<ffffffff81086b55>] ? smp_call_function_single+0xdc/0xf2
[347336.228001]  [<ffffffff810b744d>] ? perf_event_task_output+0x117/0x117
[347336.228001]  [<ffffffff810b74c8>] ? task_function_call+0x42/0x4c
[347336.228001]  [<ffffffff810b55f6>] ? __perf_event_read+0xd8/0xd8
[347336.228001]  [<ffffffff810b780e>] ? perf_event_disable+0x6d/0xb3
[347336.228001]  [<ffffffff814e1d52>] ? mutex_lock+0xd/0x2b
[347336.228001]  [<ffffffff810b77a1>] ? perf_event_refresh+0x2e/0x2e
[347336.228001]  [<ffffffff810b5148>] ? perf_event_for_each_child+0x64/0x88
[347336.228001]  [<ffffffff810b51ab>] ? perf_event_task_disable+0x3f/0x6c
[347336.228001]  [<ffffffff81048b4b>] ? SyS_prctl+0x140/0x339
[347336.228001]  [<ffffffff8100c48d>] ? syscall_trace_leave+0x44/0xa4
[347336.228001]  [<ffffffff814e9f61>] ? tracesys+0xd4/0xd9
[347336.228001] Code: 89 f7 4c 89 23 48 89 53 08 48 89 1a e8 6c cd 45 00 4d 39 e7 75 08 89 ef ff 15 31 77 99 00 45 85 ed 75 04 eb 08 f3 90 f6 43 20 01 <75> f8 5f 5b 5d 41 5c 41 5d 41 5e 41 5f c3 41 54 55 89 fd 53 48 

