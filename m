Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965417AbaCSOjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:39:31 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:47460 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964914AbaCSOj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:39:29 -0400
Date: Wed, 19 Mar 2014 10:42:02 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.02.1403191456120.18573@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.10.1403191039560.18652@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403041620390.15963@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403181250110.14816@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403181921010.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403181523360.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182149540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403181705000.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182218170.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403190941170.18343@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403191456120.18573@ionos.tec.linutronix.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014, Thomas Gleixner wrote:

> On Wed, 19 Mar 2014, Vince Weaver wrote:
> > On Tue, 18 Mar 2014, Thomas Gleixner wrote:
> > your patch didn't seem to print anything additional the first time throug.
> > 
> > I then tried the trace command you suggested, but I'm getting an empty
> > ftrace buffer which possibly means I don't have enough ftrace kernel 
> > options enabled.
> > 
> > Here's the most recent boot crash.
> > 
> > [    5.367069] ODEBUG: Info active (active state 0) object type: timer_list hint:           (null)
> 
> Stupid me. We get the hint from the wreckaged object ....
> 
> A hopefully better approach is the delta patch below.

with that applied on top:

[    5.342681] Invalid timer base: tmr ffff880117740150 tmr->base           (null) base ffff880118618000
[    5.352786] ------------[ cut here ]------------
[    5.357911] WARNING: CPU: 4 PID: 0 at lib/debugobjects.c:260 debug_print_object+0x8c/0xb0()
[    5.367023] ODEBUG: Info active (active state 0) object type: timer_list hint:           (null) delayed_work_timer_fn+0x0/0x20
[    5.379430] Modules linked in: sg sd_mod sr_mod crc_t10dif crct10dif_common cdrom hid_generic usbhid hid ehci_pci xhci_hcd ehci_hcd ahci libahci e1000e libata usbcore ptp crc32c_intel usb_common scsi_mod pps_core fan thermal thermal_sys
[    5.404562] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 3.14.0-rc7+ #6
[    5.411527] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[    5.419604]  0000000000000009 ffff88011eb03d60 ffffffff8155b173 ffff88011eb03da8
[    5.428072]  ffff88011eb03d98 ffffffff810661ad ffff880117a51828 ffffffff8183a7e0
[    5.436571]  ffffffff8173de38 00000000000258b0 ffffffff818774d0 ffff88011eb03df8
[    5.445017] Call Trace:
[    5.447777]  <IRQ>  [<ffffffff8155b173>] dump_stack+0x45/0x56
[    5.454257]  [<ffffffff810661ad>] warn_slowpath_common+0x7d/0xa0
[    5.460820]  [<ffffffff8106621c>] warn_slowpath_fmt+0x4c/0x50
[    5.467103]  [<ffffffff8131d1ec>] debug_print_object+0x8c/0xb0
[    5.473485]  [<ffffffff8107fc30>] ? __queue_work+0x320/0x320
[    5.479710]  [<ffffffff8131d954>] debug_object_info+0xf4/0x100
[    5.486082]  [<ffffffff81071904>] cascade+0xc4/0xd0
[    5.491489]  [<ffffffff81072d7c>] run_timer_softirq+0x21c/0x2a0
[    5.497965]  [<ffffffff810cf5db>] ? clockevents_program_event+0x6b/0xf0
[    5.505203]  [<ffffffff8106b5a5>] __do_softirq+0xf5/0x290
[    5.511108]  [<ffffffff8106b98d>] irq_exit+0xad/0xc0
[    5.516530]  [<ffffffff8156c0f5>] smp_apic_timer_interrupt+0x45/0x60
[    5.523488]  [<ffffffff8156aa5d>] apic_timer_interrupt+0x6d/0x80
[    5.530048]  <EOI>  [<ffffffff81433152>] ? cpuidle_enter_state+0x52/0xc0
[    5.537601]  [<ffffffff81433279>] cpuidle_idle_call+0xb9/0x1f0
[    5.543967]  [<ffffffff8101e48e>] arch_cpu_idle+0xe/0x30
[    5.549798]  [<ffffffff810bb57e>] cpu_startup_entry+0x9e/0x240
[    5.556220]  [<ffffffff81044af0>] start_secondary+0x1a0/0x1f0
[    5.562492] ---[ end trace e60b62481a1a0611 ]---
[    5.567568] ------------[ cut here ]------------
[    5.572623] kernel BUG at kernel/timer.c:1088!
[    5.577511] invalid opcode: 0000 [#1] SMP 
[    5.582190] Dumping ftrace buffer:
[    5.585956]    (ftrace buffer empty)
[    5.589941] Modules linked in: sg sd_mod sr_mod crc_t10dif crct10dif_common cdrom hid_generic usbhid hid ehci_pci xhci_hcd ehci_hcd ahci libahci e1000e libata usbcore ptp crc32c_intel usb_common scsi_mod pps_core fan thermal thermal_sys
[    5.615094] CPU: 4 PID: 0 Comm: swapper/4 Tainted: G        W    3.14.0-rc7+ #6
[    5.623062] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[    5.631142] task: ffff88011886ea00 ti: ffff880118872000 task.ti: ffff880118872000
[    5.639286] RIP: 0010:[<ffffffff81071904>]  [<ffffffff81071904>] cascade+0xc4/0xd0
[    5.647630] RSP: 0018:ffff88011eb03e78  EFLAGS: 00010002
[    5.653456] RAX: 0000000000000024 RBX: ffff880117740150 RCX: 00000000000007d4
[    5.661261] RDX: 0000000000001369 RSI: 0000000000000002 RDI: 0000000000000002
[    5.668990] RBP: ffff88011eb03ea8 R08: 0000000000000000 R09: 00000000000002b2
[    5.676785] R10: ffffffff8165a580 R11: ffff88011eb03a9e R12: ffff880118618000
[    5.684590] R13: ffff88011eb03e78 R14: 0000000000000020 R15: ffffffff818774d0
[    5.692366] FS:  0000000000000000(0000) GS:ffff88011eb00000(0000) knlGS:0000000000000000
[    5.701150] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.707459] CR2: 00007f8ec214b214 CR3: 000000000180e000 CR4: 00000000001407e0
[    5.715222] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    5.723008] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    5.730767] Stack:
[    5.733020]  ffff88011772b470 ffff88011eb10740 ffff880118618000 0000000000000000
[    5.741497]  0000000000000001 0000000000000100 ffff88011eb03f18 ffffffff81072d7c
[    5.749956]  ffff880118619c28 ffff880118619828 ffff880118619428 ffff880118619028
[    5.758481] Call Trace:
[    5.761210]  <IRQ> 
[    5.763390]  [<ffffffff81072d7c>] run_timer_softirq+0x21c/0x2a0
[    5.770310]  [<ffffffff810cf5db>] ? clockevents_program_event+0x6b/0xf0
[    5.777520]  [<ffffffff8106b5a5>] __do_softirq+0xf5/0x290
[    5.783440]  [<ffffffff8106b98d>] irq_exit+0xad/0xc0
[    5.788888]  [<ffffffff8156c0f5>] smp_apic_timer_interrupt+0x45/0x60
[    5.795830]  [<ffffffff8156aa5d>] apic_timer_interrupt+0x6d/0x80
[    5.802380]  <EOI> 
[    5.804559]  [<ffffffff81433152>] ? cpuidle_enter_state+0x52/0xc0
[    5.811624]  [<ffffffff81433279>] cpuidle_idle_call+0xb9/0x1f0
[    5.818009]  [<ffffffff8101e48e>] arch_cpu_idle+0xe/0x30
[    5.823838]  [<ffffffff810bb57e>] cpu_startup_entry+0x9e/0x240
[    5.830235]  [<ffffffff81044af0>] start_secondary+0x1a0/0x1f0
[    5.836523] Code: 5d 41 5e 5d c3 48 89 f3 4c 89 e1 48 89 de 48 c7 c7 f8 05 71 81 31 c0 e8 de 6c 4e 00 48 c7 c6 e0 a7 83 81 48 89 df e8 5c bf 2a 00 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 
[    5.862939] RIP  [<ffffffff81071904>] cascade+0xc4/0xd0
[    5.868769]  RSP <ffff88011eb03e78>
[    5.872662] ---[ end trace e60b62481a1a0612 ]---
[    5.877728] Kernel panic - not syncing: Fatal exception in interrupt
[    5.884701] Dumping ftrace buffer:
[    5.888452]    (ftrace buffer empty)
[    5.892407] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

