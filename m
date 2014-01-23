Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaAWWKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:10:45 -0500
Received: from relay2.sgi.com ([192.48.179.30]:43377 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750826AbaAWWKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:10:43 -0500
Date: Thu, 23 Jan 2014 16:11:08 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@suse.de>, Matt Fleming <matt.fleming@intel.com>
Subject: [BUG] Linux 3.14 fails to boot with new EFI changes
Message-ID: <20140123221108.GL18196@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been hitting the following bug in the latest kernel, during boot:

kernel BUG at arch/x86/mm/init_64.c:351!
invalid opcode: 0000 [#1] SMP
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-medusa-04156-g90804ed-dirty #750
Hardware name: Intel Corp. Stoutland Platform, BIOS 2.0 UEFI2.10 PI1.0 X64 2013-09-16
task: ffff88107c96c010 ti: ffff88107c96e000 task.ti: ffff88107c96e000
RIP: 0010:[<ffffffff818aa6d8>]  [<ffffffff818aa6d8>] __init_extra_mapping+0x111/0x143
RSP: 0000:ffff88107c96fd18  EFLAGS: 00010206
RAX: 0000000000000e00 RBX: ffff880001c4a018 RCX: 0000000000000002
RDX: ffff88107fcd1e00 RSI: 0000000004000000 RDI: 00000000f8000000
RBP: ffff88107c96fd48 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000007e3b3c R11: 0000000000000000 R12: 00000000f8000000
R13: 0000000004000000 R14: ffff8800f8000000 R15: 0000000080000000
FS:  0000000000000000(0000) GS:ffff880073200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff8827fefff000 CR3: 00000000017d7000 CR4: 00000000000006f0
Stack:
 80000000000001fb 0000000000000000 0000000000000040 000000000000b018
 000000000000b010 000000000000b008 ffff88107c96fd58 ffffffff818aa71d
 ffff88107c96fe28 ffffffff818a5e20 00000000000cb748 0000000000000282
Call Trace:
 [<ffffffff818aa71d>] init_extra_mapping_uc+0x13/0x15
 [<ffffffff818a5e20>] uv_system_init+0x22b/0x124b
 [<ffffffff8108b886>] ? clockevents_register_device+0x138/0x13d
 [<ffffffff81028dbb>] ? setup_APIC_timer+0xc5/0xc7
 [<ffffffff8108b620>] ? clockevent_delta2ns+0xb/0xd
 [<ffffffff818a3a92>] ? setup_boot_APIC_clock+0x4a8/0x4b7
 [<ffffffff8153d955>] ? printk+0x72/0x74
 [<ffffffff818a1757>] native_smp_prepare_cpus+0x389/0x3d6
 [<ffffffff818957bc>] kernel_init_freeable+0xb7/0x1fb
 [<ffffffff81535530>] ? rest_init+0x74/0x74
 [<ffffffff81535539>] kernel_init+0x9/0xff
 [<ffffffff81541dfc>] ret_from_fork+0x7c/0xb0
 [<ffffffff81535530>] ? rest_init+0x74/0x74
Code: ff ff ff 3f 00 00 48 23 13 48 b8 00 00 00 00 00 88 ff ff 48 01 c2 4c 89 e0 48 c1 e8 12 25 f8 0f 00 00 48 01 c2 48 83 3a 00 74 04 <0f> 0b eb fe 48 8b 45 d0 49 81 ed 00 00 20 00 4c 09 e0 49 81 c4
RIP  [<ffffffff818aa6d8>] __init_extra_mapping+0x111/0x143
 RSP <ffff88107c96fd18>

I've bisected the issue down to this commit:

commit d2f7cbe7b26a74dbbbf8f325b2a6fd01bc34032c                                                                                                                                                                                                                                                                              
Author: Borislav Petkov <bp@suse.de>                                                                                                                                                                                                                                                                                         
Date:   Thu Oct 31 17:25:08 2013 +0100                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                             
    x86/efi: Runtime services virtual mapping                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                             
    We map the EFI regions needed for runtime services non-contiguously,                                                                                                                                                                                                                                                     
    with preserved alignment on virtual addresses starting from -4G down                                                                                                                                                                                                                                                     
    for a total max space of 64G. This way, we provide for stable runtime                                                                                                                                                                                                                                                    
    services addresses across kernels so that a kexec'd kernel can still use                                                                                                                                                                                                                                                 
    them.                                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                             
    Thus, they're mapped in a separate pagetable so that we don't pollute                                                                                                                                                                                                                                                    
    the kernel namespace.                                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                                                             
    Add an efi= kernel command line parameter for passing miscellaneous                                                                                                                                                                                                                                                      
    options and chicken bits from the command line.                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                                                             
    While at it, add a chicken bit called "efi=old_map" which can be used as                                                                                                                                                                                                                                                 
    a fallback to the old runtime services mapping method in case there's                                                                                                                                                                                                                                                    
    some b0rkage with a particular EFI implementation (haha, it is hard to                                                                                                                                                                                                                                                   
    hold up the sarcasm here...).                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                                                             
    Also, add the UEFI RT VA space to Documentation/x86/x86_64/mm.txt.                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                             
    Signed-off-by: Borislav Petkov <bp@suse.de>                                                                                                                                                                                                                                                                              
    Signed-off-by: Matt Fleming <matt.fleming@intel.com>

Running with the efi=old_map does seem to remedy the problem.  One
solution, proposed by Mike Travis (travis@sgi.com), is to switch the
behavior over so that you have to provide a command line parameter to
activate the new behavior, instead of one to deactivate it.

Any input on the issue would be greatly appreciated.  Thanks!

- Alex
