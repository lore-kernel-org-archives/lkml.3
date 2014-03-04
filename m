Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbaCDV36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:29:58 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:51453 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508AbaCDV3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:29:53 -0500
Date: Tue, 4 Mar 2014 16:32:09 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: perf_fuzzer: lockup/reboot bug
In-Reply-To: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1403041620390.15963@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I patched the kernel with the cr2 save/restore bug to make sure this 
wasn't related to that problem.  It seems like it's not.

Somehow my perf_fuzzer can quickly cause the machine to lockup due to some 
sort of hrtimer queue corruption?  It's proving really hard to isolate 
this as the machine locks hard very quickly.

This is a core2 machine, 3.14-rc5

The code in question is:
/home/vince/research/linux-kernel/linux-2.6/lib/rbtree.c:89

   } else if (rb_is_black(parent))

=>	mov    (%rdx),%rax
	test   $0x1,%al
	jne    <rb_insert_color+0x12b>

Though it sometimes also crashes here instead:

/home/vince/research/linux-kernel/linux-2.6/lib/rbtree.c:94

 tmp = gparent->rb_right;

=>	mov    0x8(%rax),%rcx
	cmp    %rcx,%rdx
	je     ffffffff812a38e1 <rb_insert_color+0x92>



[  107.100035] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
[  107.109164] IP: [<ffffffff812a3867>] rb_insert_color+0x18/0x12d
[  107.129085] PGD 0 
[  107.129085] Oops: 0000 [#1] SMP 
[  107.129085] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg mcs7830 usbnet ohci_pci pcspkr i2c_nforce2 psmouse ohci_hcd serio_raw evdev coretemp wmi video button acpi_cpufreq processor thermal_sys ehci_pci sg ehci_hcd sd_mod usbcore usb_common
[  107.129085] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc5+ #33
[  107.129085] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
[  107.129085] task: ffffffff81a11450 ti: ffffffff81a00000 task.ti: ffffffff81a00000
[  107.129085] RIP: 0010:[<ffffffff812a3867>]  [<ffffffff812a3867>] rb_insert_color+0x18/0x12d
[  107.129085] RSP: 0000:ffff88011fc03de8  EFLAGS: 00010002
[  107.129085] RAX: ffff880037dc77e0 RBX: ffff88011fc0da60 RCX: ffff880037dc0000
[  107.129085] RDX: 0000000000000040 RSI: ffff88011fc0d060 RDI: ffff880037dc77e0
[  107.129085] RBP: ffff88011fc03de8 R08: ffff88011fc03d98 R09: 0000000000000002
[  107.129085] R10: 0000000000000001 R11: ffffffff81c090a8 R12: ffff88011fc0d060
[  107.129085] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88011fc0d050
[  107.129085] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
[  107.129085] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  107.129085] CR2: 0000000000000040 CR3: 0000000001a0c000 CR4: 00000000000407f0
[  107.129085] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  107.129085] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  107.129085] Stack:
[  107.129085]  ffff88011fc03e08 ffffffff812a447e ffff88011fc0da60 ffff88011fc0d050
[  107.129085]  ffff88011fc03e38 ffffffff8105e022 0000000000000286 ffff88011fc0da60
[  107.129085]  0000001965e9bf00 0000000000000000 ffff88011fc03ed8 ffffffff8105e265
[  107.129085] Call Trace:
[  107.129085]  <IRQ> 
[  107.129085]  [<ffffffff812a447e>] timerqueue_add+0x7a/0x98
[  107.129085]  [<ffffffff8105e022>] enqueue_hrtimer+0x51/0x7c
[  107.129085]  [<ffffffff8105e265>] __hrtimer_start_range_ns+0x218/0x2ff
[  107.129085]  [<ffffffff8105e364>] hrtimer_start+0x18/0x1a
[  107.129085]  [<ffffffff81091885>] __tick_nohz_idle_enter+0x2ce/0x387
[  107.129085]  [<ffffffff81091962>] tick_nohz_irq_exit+0x24/0x26
[  107.129085]  [<ffffffff81044582>] irq_exit+0x95/0x9c
[  107.129085]  [<ffffffff8102bc9f>] smp_trace_apic_timer_interrupt+0x83/0x91
[  107.129085]  [<ffffffff8153cc3a>] trace_apic_timer_interrupt+0x6a/0x70
[  107.129085]  <EOI> 
[  107.129085]  [<ffffffff8106a13c>] ? sched_clock_idle_sleep_event+0x11/0x13
[  107.129085]  [<ffffffff8100a7a3>] ? default_idle+0x1d/0x2f
[  107.129085]  [<ffffffff8100a7a1>] ? default_idle+0x1b/0x2f
[  107.129085]  [<ffffffff8100a290>] arch_cpu_idle+0x18/0x1d
[  107.129085]  [<ffffffff8107fb82>] cpu_startup_entry+0xd1/0x133
[  107.129085]  [<ffffffff8152a1d3>] rest_init+0x77/0x79
[  107.129085]  [<ffffffff81abbf19>] start_kernel+0x3f0/0x3fd
[  107.129085]  [<ffffffff81abb95e>] ? repair_env_string+0x58/0x58
[  107.129085]  [<ffffffff81530ad5>] ? memblock_reserve+0x49/0x4e
[  107.129085]  [<ffffffff81abb47e>] x86_64_start_reservations+0x2a/0x2c
[  107.129085]  [<ffffffff81abb5c5>] x86_64_start_kernel+0x145/0x14c
[  107.129085] Code: 24 48 89 de 4c 89 ef 41 ff d6 5b 41 5c 41 5d 41 5e c9 c3 55 48 8b 17 48 89 e5 48 85 d2 75 0c 48 c7 07 01 00 00 00 e9 13 01 00 00 <48> 8b 02 a8 01 0f 85 08 01 00 00 48 8b 48 08 48 39 ca 74 66 48 
[  107.129085] RIP  [<ffffffff812a3867>] rb_insert_color+0x18/0x12d
[  107.129085]  RSP <ffff88011fc03de8>
[  107.129085] CR2: 0000000000000040
[  107.129085] ---[ end trace 05819cea8e48bcd9 ]---
[  107.129085] Kernel panic - not syncing: Attempted to kill the idle task!
[  107.129085] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

> [ 4330.676015] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> [ 4330.684003] IP: [<ffffffff812a3867>] rb_insert_color+0x18/0x12d
> [ 4330.684003] PGD bd2e1067 PUD adffa067 PMD 0 
> [ 4330.684003] Oops: 0000 [#1] SMP 
> [ 4330.684003] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg acpi_cpufreq evdev mcs7830 usbnet coretemp psmouse serio_raw pcspkr video wmi processor button thermal_sys ohci_pci ohci_hcd i2c_nforce2 sg ehci_pci ehci_hcd sd_mod usbcore usb_common
> [ 4330.684003] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.14.0-rc5 #32
> [ 4330.684003] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012
> [ 4330.684003] task: ffff88011b2b37e0 ti: ffff88011b340000 task.ti: ffff88011b340000
> [ 4330.684003] RIP: 0010:[<ffffffff812a3867>]  [<ffffffff812a3867>] rb_insert_color+0x18/0x12d
> [ 4330.684003] RSP: 0018:ffff88011fc83de8  EFLAGS: 00010002
> [ 4330.684003] RAX: ffff8800cb3b0010 RBX: ffff88011fc8da60 RCX: ffff8800b799c000
> [ 4330.684003] RDX: 0000000000000040 RSI: ffff88011fc8d060 RDI: ffff8800cb3b0010
> [ 4330.684003] RBP: ffff88011fc83de8 R08: ffff88011fc8dbd0 R09: 0000000000000002
> [ 4330.684003] R10: 0000000000000001 R11: ffff88011b359028 R12: ffff88011fc8d060
> [ 4330.684003] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88011fc8d050
> [ 4330.684003] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
> [ 4330.684003] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 4330.684003] CR2: 0000000000000040 CR3: 00000000adff8000 CR4: 00000000000407e0
> [ 4330.684003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000001cfd000
> [ 4330.684003] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000ff00628
> [ 4330.684003] Stack:
> [ 4330.684003]  ffff88011fc83e08 ffffffff812a447e ffff88011fc8da60 ffff88011fc8d050
> [ 4330.684003]  ffff88011fc83e38 ffffffff8105e022 ffff8800c7b27340 ffff88011fc8da60
> [ 4330.684003]  000003f57aac8f00 0000000000000000 ffff88011fc83ed8 ffffffff8105e265
> [ 4330.684003] Call Trace:
> [ 4330.684003]  <IRQ> 
> [ 4330.684003]  [<ffffffff812a447e>] timerqueue_add+0x7a/0x98
> [ 4330.684003]  [<ffffffff8105e022>] enqueue_hrtimer+0x51/0x7c
> [ 4330.684003]  [<ffffffff8105e265>] __hrtimer_start_range_ns+0x218/0x2ff
> [ 4330.684003]  [<ffffffff8105e364>] hrtimer_start+0x18/0x1a
> [ 4330.684003]  [<ffffffff81091885>] __tick_nohz_idle_enter+0x2ce/0x387
> [ 4330.684003]  [<ffffffff81091962>] tick_nohz_irq_exit+0x24/0x26
> [ 4330.684003]  [<ffffffff81044582>] irq_exit+0x95/0x9c
> [ 4330.684003]  [<ffffffff8102b85e>] smp_apic_timer_interrupt+0x2f/0x3c
> [ 4330.684003]  [<ffffffff8153cbca>] apic_timer_interrupt+0x6a/0x70
> [ 4330.684003]  <EOI> 
> [ 4330.684003]  [<ffffffff8106a13c>] ? sched_clock_idle_sleep_event+0x11/0x13
> [ 4330.684003]  [<ffffffff8100a7a3>] ? default_idle+0x1d/0x2f
> [ 4330.684003]  [<ffffffff8100a7a1>] ? default_idle+0x1b/0x2f
> [ 4330.684003]  [<ffffffff8100a290>] arch_cpu_idle+0x18/0x1d
> [ 4330.684003]  [<ffffffff8107fb82>] cpu_startup_entry+0xd1/0x133
> [ 4330.684003]  [<ffffffff8102a34d>] start_secondary+0x196/0x19b
> [ 4330.684003] Code: 24 48 89 de 4c 89 ef 41 ff d6 5b 41 5c 41 5d 41 5e c9 c3 55 48 8b 17 48 89 e5 48 85 d2 75 0c 48 c7 07 01 00 00 00 e9 13 01 00 00 <48> 8b 02 a8 01 0f 85 08 01 00 00 48 8b 48 08 48 39 ca 74 66 48 
> [ 4330.684003] RIP  [<ffffffff812a3867>] rb_insert_color+0x18/0x12d
> [ 4330.684003]  RSP <ffff88011fc83de8>
> [ 4330.684003] CR2: 0000000000000040
> [ 4330.684003] ---[ end trace 680f8979aa2ba0dc ]---
> [ 4330.684003] Kernel panic - not syncing: Attempted to kill the idle task!
> [ 4330.684003] Shutting down cpus with NMI
> [ 4330.684003] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
