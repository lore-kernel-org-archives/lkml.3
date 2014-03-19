Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031AbaCSNnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:43:37 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:57894 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933771AbaCSNnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:43:35 -0400
Date: Wed, 19 Mar 2014 09:46:07 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.02.1403182218170.18573@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.10.1403190941170.18343@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403041620390.15963@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403181250110.14816@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403181921010.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403181523360.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182149540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403181705000.15687@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403182218170.18573@ionos.tec.linutronix.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Thomas Gleixner wrote:

> On Tue, 18 Mar 2014, Vince Weaver wrote:
> 
> > On Tue, 18 Mar 2014, Thomas Gleixner wrote:
> > > 
> > > > [    3.678040] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018                                                                        
> > > > [    3.686776] IP: [<ffffffff8106d7a8>] get_next_timer_interrupt+0x168/0x250    
> > > 
> > > The back trace is not really helpful. Is there anything before that
> > > BUG in dmesg?
> > 
> > no, just normal boot messages.
> > 
> > I re-compiled with the frame pointer enabled and here's an updated 
> > version:
> > 
> > [    3.722836] sd 1:0:0:0: [sda] 4096-byte physical blocks                      
> > [    3.728682] sd 1:0:0:0: [sda] Write Protect is off                           
> > [    3.728826] sr 0:0:0:0: Attached scsi generic sg0 type 5                     
> > [    3.728992] sd 1:0:0:0: Attached scsi generic sg1 type 0                     
> > [    3.745700] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA                                                          
> > [    3.787096]  sda: sda1 sda2 sda3 sda4                                        
> > [    3.792169] sd 1:0:0:0: [sda] Attached SCSI disk                             
> > [    4.312111] ------------[ cut here ]------------                             
> > [    4.317176] kernel BUG at kernel/timer.c:1084!                               
> 
> Wow. That's in the cascade code. So it looks like the timer got
> corrupted without using the timer api wrong. That might be a memset or
> a stray pointer. Can you apply the following patch?
> 
> That really should give us a hint.
> 
> If that fails, enable the tracer in your config and add the following
> to your commandline
> 
>    trace_event=timer_* ftrace_dump_on_oops
> 
> That will spill out a lot of crap over serial, but it should tell us
> which timer is corrupted.
> 
> Thanks,

your patch didn't seem to print anything additional the first time throug.

I then tried the trace command you suggested, but I'm getting an empty
ftrace buffer which possibly means I don't have enough ftrace kernel 
options enabled.

Here's the most recent boot crash.

[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.14.0-rc7+ root=UUID=ec527b30-713c-47c1-bf23-9df8681afab7 ro console=tty0 console=ttyS0,115200n8 trace_event=timer_* ftrace_dump_on_oops
...
[    5.342788] Invalid timer base: tmr ffff880117740150 tmr->base           (null) base ffff880118894000
[    5.352842] ------------[ cut here ]------------
[    5.357938] WARNING: CPU: 1 PID: 0 at lib/debugobjects.c:260 debug_print_object+0x83/0xa0()
[    5.367069] ODEBUG: Info active (active state 0) object type: timer_list hint:           (null)
[    5.376559] Modules linked in: sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common hid_generic usbhid hid ahci libahci e1000e libata ehci_pci ptp xhci_hcd ehci_hcd pps_core scsi_mod crc32c_intel usbcore usb_common thermal fan thermal_sys
[    5.401708] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc7+ #5
[    5.408653] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[    5.416781]  0000000000000009 ffff88011ea43d68 ffffffff8155b113 ffff88011ea43db0
[    5.425271]  ffff88011ea43da0 ffffffff810661ad ffff880117a3af88 ffffffff8183a7e0
[    5.433768]  ffffffff8173de38 00000000000258b0 ffffffff818774d0 ffff88011ea43e00
[    5.442264] Call Trace:
[    5.445021]  <IRQ>  [<ffffffff8155b113>] dump_stack+0x45/0x56
[    5.451533]  [<ffffffff810661ad>] warn_slowpath_common+0x7d/0xa0
[    5.458165]  [<ffffffff8106621c>] warn_slowpath_fmt+0x4c/0x50
[    5.464499]  [<ffffffff8131d1e3>] debug_print_object+0x83/0xa0
[    5.470919]  [<ffffffff8131d904>] debug_object_info+0xf4/0x100
[    5.477310]  [<ffffffff81071904>] cascade+0xc4/0xd0
[    5.482664]  [<ffffffff81072d7c>] run_timer_softirq+0x21c/0x2a0
[    5.489123]  [<ffffffff810cf5db>] ? clockevents_program_event+0x6b/0xf0
[    5.496362]  [<ffffffff8106b5a5>] __do_softirq+0xf5/0x290
[    5.502288]  [<ffffffff8106b98d>] irq_exit+0xad/0xc0
[    5.507758]  [<ffffffff8156c075>] smp_apic_timer_interrupt+0x45/0x60
[    5.514694]  [<ffffffff8156a9dd>] apic_timer_interrupt+0x6d/0x80
[    5.521291]  <EOI>  [<ffffffff814330f2>] ? cpuidle_enter_state+0x52/0xc0
[    5.528865]  [<ffffffff81433219>] cpuidle_idle_call+0xb9/0x1f0
[    5.535305]  [<ffffffff8101e48e>] arch_cpu_idle+0xe/0x30
[    5.541152]  [<ffffffff810bb57e>] cpu_startup_entry+0x9e/0x240
[    5.547572]  [<ffffffff81044af0>] start_secondary+0x1a0/0x1f0
[    5.553844] ---[ end trace 32b995b31388939e ]---
[    5.558927] ------------[ cut here ]------------
[    5.563994] kernel BUG at kernel/timer.c:1088!
[    5.568922] invalid opcode: 0000 [#1] SMP 
[    5.573614] Dumping ftrace buffer:
[    5.577383]    (ftrace buffer empty)
[    5.581373] Modules linked in: sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common hid_generic usbhid hid ahci libahci e1000e libata ehci_pci ptp xhci_hcd ehci_hcd pps_core scsi_mod crc32c_intel usbcore usb_common thermal fan thermal_sys
[    5.606612] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.14.0-rc7+ #5
[    5.614634] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[    5.622701] task: ffff8801188609c0 ti: ffff880118866000 task.ti: ffff880118866000
[    5.630944] RIP: 0010:[<ffffffff81071904>]  [<ffffffff81071904>] cascade+0xc4/0xd0
[    5.639315] RSP: 0018:ffff88011ea43e78  EFLAGS: 00010002
[    5.645132] RAX: 0000000000000024 RBX: ffff880117740150 RCX: 000000000000079f
[    5.652919] RDX: 00000000000012d0 RSI: 0000000000000002 RDI: 0000000000000002
[    5.660704] RBP: ffff88011ea43ea8 R08: 0000000000000000 R09: 00000000000002b1
[    5.668470] R10: ffffffff8165a580 R11: ffff88011ea43aa6 R12: ffff880118894000
[    5.676255] R13: ffff88011ea43e78 R14: 0000000000000020 R15: ffffffff818774d0
[    5.684061] FS:  0000000000000000(0000) GS:ffff88011ea40000(0000) knlGS:0000000000000000
[    5.692928] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.699184] CR2: 0000000000bc5304 CR3: 000000000180e000 CR4: 00000000001407e0
[    5.706984] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    5.714744] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    5.722511] Stack:
[    5.724768]  ffff880117740150 ffff88011ea50740 ffff880118894000 0000000000000000
[    5.733264]  0000000000000001 0000000000000100 ffff88011ea43f18 ffffffff81072d7c
[    5.741748]  ffff880118895c28 ffff880118895828 ffff880118895428 ffff880118895028
[    5.750236] Call Trace:
[    5.752992]  <IRQ> 
[    5.755142]  [<ffffffff81072d7c>] run_timer_softirq+0x21c/0x2a0
[    5.762074]  [<ffffffff810cf5db>] ? clockevents_program_event+0x6b/0xf0
[    5.769362]  [<ffffffff8106b5a5>] __do_softirq+0xf5/0x290
[    5.775279]  [<ffffffff8106b98d>] irq_exit+0xad/0xc0
[    5.780721]  [<ffffffff8156c075>] smp_apic_timer_interrupt+0x45/0x60
[    5.787676]  [<ffffffff8156a9dd>] apic_timer_interrupt+0x6d/0x80
[    5.794270]  <EOI> 
[    5.796439]  [<ffffffff814330f2>] ? cpuidle_enter_state+0x52/0xc0
[    5.803559]  [<ffffffff81433219>] cpuidle_idle_call+0xb9/0x1f0
[    5.809934]  [<ffffffff8101e48e>] arch_cpu_idle+0xe/0x30
[    5.815794]  [<ffffffff810bb57e>] cpu_startup_entry+0x9e/0x240
[    5.822160]  [<ffffffff81044af0>] start_secondary+0x1a0/0x1f0
[    5.828463] Code: 5d 41 5e 5d c3 48 89 f3 4c 89 e1 48 89 de 48 c7 c7 f8 05 71 81 31 c0 e8 7e 6c 4e 00 48 c7 c6 e0 a7 83 81 48 89 df e8 0c bf 2a 00 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 
[    5.854807] RIP  [<ffffffff81071904>] cascade+0xc4/0xd0
[    5.860662]  RSP <ffff88011ea43e78>
[    5.864547] ---[ end trace 32b995b31388939f ]---
[    5.869596] Kernel panic - not syncing: Fatal exception in interrupt
[    5.876532] Dumping ftrace buffer:
[    5.880352]    (ftrace buffer empty)
[    5.884368] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

