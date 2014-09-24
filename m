Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaIXP0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:26:31 -0400
Received: from rs04.intra2net.com ([85.214.66.2]:53540 "EHLO
	rs04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaIXP03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:26:29 -0400
X-Greylist: delayed 1044 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 11:26:29 EDT
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
To: artem_fetishev@epam.com
Cc: linux-kernel@vger.kernel.org
Subject: 3.14.19: Oops on boot in rapl_cpu_prepare()
Date: Wed, 24 Sep 2014 17:09:01 +0200
Message-ID: <10317150.0hmJcKxvss@storm>
Organization: Intra2net AG
User-Agent: KMail/4.13.3 (Linux/3.16.2-201.fc20.x86_64; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

I just upgraded from kernel 3.4.101 to 3.14.19. 
Now the system fails to boot using qemu (kernel Oops):

------------------------------------------------------
...
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1             
pci 0000:00:00.0: Limiting direct PCI/PCI transfers   
pci 0000:00:01.0: PIIX3: Enabling Passive Release     
pci 0000:00:01.0: Activating ISA DMA hang workarounds         
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 16688K (f67b2000 - f77fe000)
general protection fault: 0000 [#1] SMP
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.19-1.i2n.i686 #1
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: f58779a0 ti: f5878000 task.ti: f5878000  
EIP: 0060:[<c101f9b2>] EFLAGS: 00000282 CPU: 0
EIP is at rapl_cpu_prepare+0x62/0xf0   
EAX: 00000606 EBX: c14ef3e4 ECX: 00000606 EDX: 00000000
ESI: 00000000 EDI: f5918280 EBP: f5879ec4 ESP: f5879eb4
    DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 80050033 CR2: ffe16000 CR3: 014fb000 CR4: 000406d0
Stack:                            
    00000006 c1491784 00000000 00000000 f5879efc c149e670 c14ee5c0 c146a000
    00000008 f5879ee0 c103b45d f5879eec c132100e c1491784 f5879efc 00000006
    0000009e 00000000 f5879f70 c1000366 00000000 f58ab300 f58ab080 0000000f
Call Trace:
    [<c149e670>] rapl_pmu_init+0x88/0x1af
    [<c103b45d>] ? cpu_maps_update_done+0xd/0x10
    [<c132100e>] ? register_cpu_notifier+0x1e/0x30    
    [<c1000366>] do_one_initcall+0x36/0x150
    [<c149e5e8>] ? intel_uncore_init+0x332/0x332
    [<c1495600>] ? kernel_init_freeable+0x143/0x18c
    [<c1051f23>] ? parse_args+0x1a3/0x330
    [<c106aba0>] ? __wake_up+0x40/0x50
    [<c14955a4>] kernel_init_freeable+0xe7/0x18c
    [<c1495649>] ? kernel_init_freeable+0x18c/0x18c
    [<c132087b>] kernel_init+0xb/0xe0
    [<c13279b7>] ret_from_kernel_thread+0x1b/0x28          
    [<c1320870>] ? rest_init+0x60/0x60
Code: c1 ba d0 80 00 00 e8 8e 5b 0b 00 89 c7 b8 ff ff ff ff 85 ff 74 d9 8d 47 0c
    89 47 0c 89 47 10 b8 06 06 00 00 66 c7 07 00 00 89 c1 <0f> 32 c1 f8 08 66 b9 1f
    00 83 e0 1f 31 d2 29 c1 89 47 04 b8 05
EIP: [<c101f9b2>] rapl_cpu_prepare+0x62/0xf0 SS:ESP 0068:f5879eb4
---[ end trace 52657a58a39d7b04 ]---
------------------------------------------------------

The kernel is 32bit with SMP + PAE, qemu is invoked like this:

/usr/bin/qemu-kvm \
    -name 'vm1' \
    -M pc  \
    -nodefaults  \
    -vga std  \
    -display curses \
    -curses \
    -drive id=drive_image1,if=none,cache=none,file=/mnt/local/vm1/vm1.qcow2 \
    -device virtio-blk-pci,id=image1,drive=drive_image1,bus=pci.0,addr=03 \
    -m 1024  \
    -smp 2,cores=1,threads=1,sockets=2  \
    -cpu 'SandyBridge' \
    -drive media=cdrom,file=/mnt/local/isos/latest.iso,bus=0,unit=0  \
    -rtc base=utc,clock=host,driftfix=none  \
    -boot order=cdn,once=dcn,menu=off \
    -enable-kvm


qemu version is 1.6.2 from Fedora 20.

I tried reverting commit 825600c0f20e595daaa7a6dd8970f84fa2a2ee57
but the issue remained. So it doesn't seem to be related to your patch :)

A workaround is to change the guest CPU type
from 'SandyBridge' to 'qemu32'.

Any idea what could be going on?
I can run debug output patches if needed.


The problem is similar to this previous report from 2014-07-31:
https://groups.google.com/forum/#!topic/fa.linux.kernel/sizx3cmxj0k
"RE: [x86] BUG: unable to handle kernel paging request at ffff880012770000"

Cheers,
Thomas

