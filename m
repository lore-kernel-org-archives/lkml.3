Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbaCRTXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:23:22 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:59713 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412AbaCRTXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:23:20 -0400
Date: Tue, 18 Mar 2014 15:25:55 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.02.1403181921010.18573@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.10.1403181523360.15687@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403041620390.15963@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403181250110.14816@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403181921010.18573@ionos.tec.linutronix.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Thomas Gleixner wrote:

> On Tue, 18 Mar 2014, Vince Weaver wrote:
> 
> > 
> > The perf_fuzzer can quickly cause a machine to lockup with an hrtimer 
> > related rb tree related oops.  I've had a hard time debugging this in any 
> > useful manner, but I can trigger it on both core2 and haswell test systems 
> > on 3.14-rc7.
> > 
> > This involves making a large number of perf_event events of all types and 
> > then forking a lot.
> 
> Can you enable debugobjects please? The should give us an hint what
> corrupts the rbtree.

I enabled debugobjects and then said Y to most of the questions brought up 
by make oldconfig but now the system crashes at boot:

[    3.678040] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018                                                                        
[    3.686776] IP: [<ffffffff8106d7a8>] get_next_timer_interrupt+0x168/0x250    
[    3.694289] PGD 0                                                            
[    3.696642] Oops: 0000 [#1] SMP                                              
[    3.700394] Modules linked in: sg sd_mod sr_mod crc_t10dif crct10dif_common cdrom hid_generic usbhid hid ahci e1000e libahci ehci_pci ptp ehci_hcd xhci_hcd libata pps_core usbcore crc32c_intel scsi_mod usb_common fan thermal thermal_sys 
[    3.725377] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc7 #2          
[    3.732217] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014                                                                             
[    3.740296] task: ffff880118e989a0 ti: ffff880118e9e000 task.ti: ffff880118e9e000                                                                            
[    3.748447] RIP: 0010:[<ffffffff8106d7a8>]  [<ffffffff8106d7a8>] get_next_timer_interrupt+0x168/0x250                                                        
[    3.758601] RSP: 0018:ffff880118e9fe58  EFLAGS: 00010017                     
[    3.764413] RAX: 0000000000000000 RBX: 000000013ffede62 RCX: 0000000000000000
[    3.772162] RDX: 0000000000000000 RSI: ffff880118ecd228 RDI: 0000000000fffedf
[    3.779863] RBP: ffff880118e9fea0 R08: 0000000000000001 R09: 0000000000000020
[    3.787553] R10: 000000000000001f R11: ffff880118ecd028 R12: ffff880118ecc000
[    3.795295] R13: 00000000fffede63 R14: ffff880118e9fe60 R15: ffff880118e9fe78
[    3.803003] FS:  0000000000000000(0000) GS:ffff88011ea40000(0000) knlGS:0000000000000000                                                                     
[    3.811760] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                
[    3.818042] CR2: 0000000000000018 CR3: 000000000180e000 CR4: 00000000001407e0
[    3.825772] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.833506] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    3.841257] Stack:                                                           
[    3.843536]  ffff880118ecd028 ffff880118ecd428 ffff880118ecd828 ffff880118ecdc28                                                                             
[    3.851967]  0000000000000001 00000000cc902a00 ffff88011ea4de00 0000000000000000                                                                             
[    3.860406]  ffff88011ea4eda0 00000000cc91c17c ffffffff810c5525 00000000fffede63                                                                             
[    3.868786] Call Trace:                                                      
[    3.871512]  [<ffffffff810c5525>] ? __tick_nohz_idle_enter+0x2c5/0x460       
[    3.878634]  [<ffffffff810c56f4>] ? tick_nohz_idle_enter+0x34/0x60           
[    3.885374]  [<ffffffff810b089e>] ? cpu_startup_entry+0x3e/0x230             
[    3.891895] Code: 24 18 41 89 fa 41 83 e2 3f 45 89 d1 0f 1f 80 00 00 00 00 49 63 f1 48 c1 e6 04 4c 01 de 48 8b 06 48 39 f0 74 25 66 0f 1f 44 00 00 <f6> 40 18 01 75 11 48 8b 48 10 41 b8 01 00 00 00 48 39 d1 48 0f                          
[    3.918182] RIP  [<ffffffff8106d7a8>] get_next_timer_interrupt+0x168/0x250   
[    3.925697]  RSP <ffff880118e9fe58>                                          
[    3.929514] CR2: 0000000000000018                                            
[    3.933151] ---[ end trace aff36205690b9b9e ]---                             
[    3.938191] Kernel panic - not syncing: Attempted to kill the idle task!     
[    3.945483] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

this is a haswell system, 3.14-rc7

Vince
