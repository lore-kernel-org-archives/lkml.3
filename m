Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278AbaCSRCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:02:09 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:50688 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbaCSRCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:02:06 -0400
Date: Wed, 19 Mar 2014 13:04:39 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.02.1403191552570.18573@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.10.1403191300540.18754@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403041620390.15963@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403181250110.14816@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403181921010.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403181523360.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182149540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403181705000.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182218170.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403190941170.18343@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403191456120.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403191039560.18652@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403191552570.18573@ionos.tec.linutronix.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014, Thomas Gleixner wrote:

> Good, we have at least a point where we can gather useful
> information. The timer belongs to a delayed work. The work itself is
> tracked via debug objects as well. So we can get that as well. Delta
> patch below.

with that patch applied:

[    4.314095] Invalid timer base: tmr ffff880117738150 tmr->base           (null) base ffffffff81a3edc0
[    4.324216] ------------[ cut here ]------------
[    4.329326] WARNING: CPU: 0 PID: 0 at lib/debugobjects.c:261 debug_print_object+0x8c/0xb0()
[    4.338495] ODEBUG: Info active (active state 0) object type: timer_list hint:           (null) delayed_work_timer_fn+0x0/0x20
[    4.350889] Modules linked in: sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common hid_generic usbhid hid ahci libahci ehci_pci e1000e xhci_hcd libata ehci_hcd ptp crc32c_intel scsi_mod pps_core usbcore usb_common fan thermal thermal_sys
[    4.375911] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc7+ #7
[    4.382820] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[    4.390947]  0000000000000009 ffff88011ea03d60 ffffffff8155b253 ffff88011ea03da8
[    4.399428]  ffff88011ea03d98 ffffffff810661ad ffff8801179696d8 ffffffff8183a7e0
[    4.407889]  ffffffff8173de38 00000000000291b0 ffffffff818774d0 ffff88011ea03df8
[    4.416347] Call Trace:
[    4.419102]  <IRQ>  [<ffffffff8155b253>] dump_stack+0x45/0x56
[    4.425545]  [<ffffffff810661ad>] warn_slowpath_common+0x7d/0xa0
[    4.432085]  [<ffffffff8106621c>] warn_slowpath_fmt+0x4c/0x50
[    4.438391]  [<ffffffff8131d1ec>] debug_print_object+0x8c/0xb0
[    4.444799]  [<ffffffff8107fc30>] ? __queue_work+0x320/0x320
[    4.451012]  [<ffffffff8131da2c>] debug_object_info+0x1cc/0x1e0
[    4.457488]  [<ffffffff81071904>] cascade+0xc4/0xd0
[    4.462847]  [<ffffffff81072d7c>] run_timer_softirq+0x21c/0x2a0
[    4.469338]  [<ffffffff810cf5db>] ? clockevents_program_event+0x6b/0xf0
[    4.476553]  [<ffffffff8106b5a5>] __do_softirq+0xf5/0x290
[    4.482483]  [<ffffffff8106b98d>] irq_exit+0xad/0xc0
[    4.487946]  [<ffffffff8156c1b5>] smp_apic_timer_interrupt+0x45/0x60
[    4.494920]  [<ffffffff8156ab1d>] apic_timer_interrupt+0x6d/0x80
[    4.501446]  <EOI>  [<ffffffff81433232>] ? cpuidle_enter_state+0x52/0xc0
[    4.508936]  [<ffffffff81433359>] cpuidle_idle_call+0xb9/0x1f0
[    4.515367]  [<ffffffff8101e48e>] arch_cpu_idle+0xe/0x30
[    4.521218]  [<ffffffff810bb57e>] cpu_startup_entry+0x9e/0x240
[    4.527624]  [<ffffffff8154c8c7>] rest_init+0x77/0x80
[    4.533205]  [<ffffffff818d4f67>] start_kernel+0x42f/0x43a
[    4.539210]  [<ffffffff818d4941>] ? repair_env_string+0x5c/0x5c
[    4.545659]  [<ffffffff818d4120>] ? early_idt_handlers+0x120/0x120
[    4.552386]  [<ffffffff818d45ee>] x86_64_start_reservations+0x2a/0x2c
[    4.559454]  [<ffffffff818d4733>] x86_64_start_kernel+0x143/0x152
[    4.566119] ---[ end trace 18d31e7b09fba1ee ]---
[    4.571194] ------------[ cut here ]------------
[    4.576258] WARNING: CPU: 0 PID: 0 at lib/debugobjects.c:261 debug_print_object+0x8c/0xb0()
[    4.585399] ODEBUG: Info initialized (active state 0) object type: work_struct hint:           (null)           (null)
[    4.597013] Modules linked in: sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common hid_generic usbhid hid ahci libahci ehci_pci e1000e xhci_hcd libata ehci_hcd ptp crc32c_intel scsi_mod pps_core usbcore usb_common fan thermal thermal_sys
[    4.622133] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.14.0-rc7+ #7
[    4.630166] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[    4.638228]  0000000000000009 ffff88011ea03d60 ffffffff8155b253 ffff88011ea03da8
[    4.646702]  ffff88011ea03d98 ffffffff810661ad ffff880117a4cee8 ffffffff8183b920
[    4.655159]  ffffffff8173de38 00000000000291b0 ffffffff818774d0 ffff88011ea03df8
[    4.663587] Call Trace:
[    4.666345]  <IRQ>  [<ffffffff8155b253>] dump_stack+0x45/0x56
[    4.672835]  [<ffffffff810661ad>] warn_slowpath_common+0x7d/0xa0
[    4.679422]  [<ffffffff8106621c>] warn_slowpath_fmt+0x4c/0x50
[    4.685657]  [<ffffffff8131d1ec>] debug_print_object+0x8c/0xb0
[    4.692070]  [<ffffffff8131da14>] debug_object_info+0x1b4/0x1e0
[    4.698515]  [<ffffffff81071904>] cascade+0xc4/0xd0
[    4.703868]  [<ffffffff81072d7c>] run_timer_softirq+0x21c/0x2a0
[    4.710359]  [<ffffffff810cf5db>] ? clockevents_program_event+0x6b/0xf0
[    4.717575]  [<ffffffff8106b5a5>] __do_softirq+0xf5/0x290
[    4.723523]  [<ffffffff8106b98d>] irq_exit+0xad/0xc0
[    4.728954]  [<ffffffff8156c1b5>] smp_apic_timer_interrupt+0x45/0x60
[    4.735887]  [<ffffffff8156ab1d>] apic_timer_interrupt+0x6d/0x80
[    4.742470]  <EOI>  [<ffffffff81433232>] ? cpuidle_enter_state+0x52/0xc0
[    4.750033]  [<ffffffff81433359>] cpuidle_idle_call+0xb9/0x1f0
[    4.756406]  [<ffffffff8101e48e>] arch_cpu_idle+0xe/0x30
[    4.762233]  [<ffffffff810bb57e>] cpu_startup_entry+0x9e/0x240
[    4.768669]  [<ffffffff8154c8c7>] rest_init+0x77/0x80
[    4.774215]  [<ffffffff818d4f67>] start_kernel+0x42f/0x43a
[    4.780267]  [<ffffffff818d4941>] ? repair_env_string+0x5c/0x5c
[    4.786719]  [<ffffffff818d4120>] ? early_idt_handlers+0x120/0x120
[    4.793484]  [<ffffffff818d45ee>] x86_64_start_reservations+0x2a/0x2c
[    4.800540]  [<ffffffff818d4733>] x86_64_start_kernel+0x143/0x152
[    4.807186] ---[ end trace 18d31e7b09fba1ef ]---
[    4.812254] ------------[ cut here ]------------
[    4.817350] kernel BUG at kernel/timer.c:1088!
[    4.822227] invalid opcode: 0000 [#1] SMP 
[    4.826884] Dumping ftrace buffer:
[    4.830644]    (ftrace buffer empty)
[    4.834617] Modules linked in: sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common hid_generic usbhid hid ahci libahci ehci_pci e1000e xhci_hcd libata ehci_hcd ptp crc32c_intel scsi_mod pps_core usbcore usb_common fan thermal thermal_sys
[    4.859699] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.14.0-rc7+ #7
[    4.867705] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[    4.875771] task: ffffffff81815460 ti: ffffffff81800000 task.ti: ffffffff81800000
[    4.883928] RIP: 0010:[<ffffffff81071904>]  [<ffffffff81071904>] cascade+0xc4/0xd0
[    4.892320] RSP: 0018:ffff88011ea03e78  EFLAGS: 00010002
[    4.898134] RAX: 0000000000000024 RBX: ffff880117738150 RCX: 0000000000000854
[    4.905885] RDX: 0000000000001462 RSI: 0000000000000002 RDI: 0000000000000002
[    4.913698] RBP: ffff88011ea03ea8 R08: 0000000000000000 R09: 00000000000002d7
[    4.921440] R10: ffffffff8165a580 R11: ffff88011ea03a9e R12: ffffffff81a3edc0
[    4.929190] R13: ffff88011ea03e78 R14: 000000000000001f R15: ffffffff818774d0
[    4.936983] FS:  0000000000000000(0000) GS:ffff88011ea00000(0000) knlGS:0000000000000000
[    4.945826] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.952134] CR2: 00007fe0f44a39d8 CR3: 000000000180e000 CR4: 00000000001407f0
[    4.959929] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.967728] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    4.975473] Stack:
[    4.977744]  ffff8801176f7060 ffff88011ea10740 ffffffff81a3edc0 0000000000000000
[    4.986202]  0000000000000001 0000000000000100 ffff88011ea03f18 ffffffff81072d7c
[    4.994649]  ffffffff81a409e8 ffffffff81a405e8 ffffffff81a401e8 ffffffff81a3fde8
[    5.003114] Call Trace:
[    5.005838]  <IRQ> 
[    5.007979]  [<ffffffff81072d7c>] run_timer_softirq+0x21c/0x2a0
[    5.014893]  [<ffffffff810cf5db>] ? clockevents_program_event+0x6b/0xf0
[    5.022102]  [<ffffffff8106b5a5>] __do_softirq+0xf5/0x290
[    5.028027]  [<ffffffff8106b98d>] irq_exit+0xad/0xc0
[    5.033464]  [<ffffffff8156c1b5>] smp_apic_timer_interrupt+0x45/0x60
[    5.040410]  [<ffffffff8156ab1d>] apic_timer_interrupt+0x6d/0x80
[    5.046956]  <EOI> 
[    5.049095]  [<ffffffff81433232>] ? cpuidle_enter_state+0x52/0xc0
[    5.056119]  [<ffffffff81433359>] cpuidle_idle_call+0xb9/0x1f0
[    5.062487]  [<ffffffff8101e48e>] arch_cpu_idle+0xe/0x30
[    5.070787]  [<ffffffff810bb57e>] cpu_startup_entry+0x9e/0x240
[    5.077142]  [<ffffffff8154c8c7>] rest_init+0x77/0x80
[    5.082670]  [<ffffffff818d4f67>] start_kernel+0x42f/0x43a
[    5.088685]  [<ffffffff818d4941>] ? repair_env_string+0x5c/0x5c
[    5.095155]  [<ffffffff818d4120>] ? early_idt_handlers+0x120/0x120
[    5.101910]  [<ffffffff818d45ee>] x86_64_start_reservations+0x2a/0x2c
[    5.108979]  [<ffffffff818d4733>] x86_64_start_kernel+0x143/0x152
[    5.115630] Code: 5d 41 5e 5d c3 48 89 f3 4c 89 e1 48 89 de 48 c7 c7 f8 05 71 81 31 c0 e8 be 6d 4e 00 48 c7 c6 e0 a7 83 81 48 89 df e8 5c bf 2a 00 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 
[    5.141945] RIP  [<ffffffff81071904>] cascade+0xc4/0xd0
[    5.147774]  RSP <ffff88011ea03e78>
[    5.151625] ---[ end trace 18d31e7b09fba1f0 ]---
[    5.156707] Kernel panic - not syncing: Fatal exception in interrupt
[    5.163725] Dumping ftrace buffer:
[    5.167535]    (ftrace buffer empty)
[    5.171488] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

