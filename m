Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030233Ab3HIGGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:06:52 -0400
Received: from hydra.rus.uni-stuttgart.de ([129.69.1.55]:52056 "EHLO
	hydra.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966964Ab3HIGGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:06:47 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Aug 2013 02:06:47 EDT
Message-ID: <52048567.6020704@rus.uni-stuttgart.de>
Date: Fri, 09 Aug 2013 08:00:07 +0200
From: Thomas Richter <richter@rus.uni-stuttgart.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: stern@rowland.harvard.edu, linux@brodo.de, linux-kernel@vger.kernel.org
Subject: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on E7110
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan, hi Dominik,

maybe you want me to help out a bit - I'm having trouble getting a 
Delock PCMCIA to USB-2 adapter to work under linux, with strange 
behavior in some situations. The trouble is that while I can *read* via 
fast (usb 2.0) transfers from the port, an ehci-triggered write just 
locks up (it does not Oops, though) and I'm pretty much stuck narrowing 
down the problem.

Here are some more details on the machine:

The USB 2 adapter chip is from NEC: 03:00.1 0c03: 1033:00e0 (rev 05)
and so is its ohci companion: 03:00.0 0c03: 1033:0035.

Both of them sit on a delock PMCCIA card, which hangs on a O2 Micro 
OZ6933/711E1 cardbus bridge:

02:0a.0 0607: 1217:6933 (rev 02)
02:0a.1 0607: 1217:6933 (rev 02)

The trouble is as follows: A read from a USB stick or an external 
harddisk through the scsi subsystem issues a SCSI command 28 (read 
block), and this works fine. A write (SCSI command 2A) locks up. The 
machine remains usable, but the command never completes. Some time later 
first the subsystem tries to reset the bus, does not succeed and then 
gives up. The harddisk on the USB even worse seems to "believe" to 
receive some data, and then thankfully erases the superblock of the ext2 
partition on it as soon as I try to mount it r/w. Read-only mounts work 
(no write commands involved). Happy happy joy joy!

It *also* works to disable the ehci portion of the NEC chip and just go 
through the companion. Transfer through ohci is fine (but, of course, 
slow, and besides the point since that's exactly what I need the adapter 
for).

The problem appears on various kernels, I've tested 3.10.5 (build 
myself), 3.2.0-4-686-pae (vanilly debian wheezy kernel), 2.6.32-5-686
(vanilla debian squeeze kernel). Interestingly, the chip *does* work 
under an older Knoppix (knoppix 5.0.1) with a 2.6.19.1 kernel. As far as 
I can read the notes, the ehci and cardbus interfaces have not been 
altered and are as they came with 2.6.19.1. I also checked I/O goes 
through high speed and not usb 1 (unloaded ohci, loaded ehci, inserted 
the stick - writing works!)

What is also strange (but an unrelated problem) is that I cannot make 
grub2 boot from the knoppix kernel. It just resets after having loaded 
kernel and initrd, immediately. I neither can build 2.6.19.1 manually 
unaltered as it depends on older userspace tools. After a bit of 
patching, I could get it to compile with gcc-4.7, but the kernel 
otherwise behaves as the Knoppix kernel: Just reboots after grub 2 
loaded it.

I also tried a newer knoppix with a 3.5 kernel, but this again locks up 
on writing, so something must have changed between 2.6.19.1 and 
2.6.32.5. Or something changed in knoppix or debian userland which I 
cannot test for because the 2.6.19.1 does not run here from the disk.

The system is an old Fujitsu E7110 with a debian wheezy userland with 
1GB of memory and an 80GB harddisk, with a Pentium 4-M dinosaur 
processor at 1.7Ghz featuring speedstep. Whether speedstep is enabled or 
disabled does not matter as far as the "stuck write" is concerned, the 
p4-clockmodulation module *is not* loaded and hence not the culprit.

Greetings,
	Thomas

PS: Dear LKLM readers, please set me CC on any responses that would 
otherwise go through the mailing list only.

