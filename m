Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607Ab3CTAMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:12:47 -0400
Received: from infernal.debian.net ([176.28.9.132]:35840 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab3CTAMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:12:45 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Mar 2013 20:12:45 EDT
Date: Wed, 20 Mar 2013 01:03:36 +0100
From: Andreas Bombe <aeb@debian.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Subject: [Regression] process hangs due to "USB: EHCI: work around silicon
 bug in Intels EHCI controllers"
Message-ID: <20130320000336.GA8912@amos.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The named commit (6402c796d3) causes a process to hang indefinitely in
usb_kill_urb(). Reverting it fixes the problem. The bug also prevents
suspend/shutdown/reboot from completing, presumably due to the hanging
process.

(Cc'ing Stephen Warren because I only found his report after I bisected
it myself. Do you also see a blocked process?)

This is the hanging process on my system:
[  240.364085] INFO: task colord-sane:3619 blocked for more than 120 seconds.
[  240.364090] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.364093] colord-sane     D 0000000000001388     0  3619   3602 0x00000000
[  240.364099]  ffff8801255cd818 0000000000000046 0000000000000296 ffffffff81c11400
[  240.364105]  ffff8801255cd7c8 ffff880127488000 ffff8801255cdfd8 ffff8801255cdfd8
[  240.364112]  0000000000013600 ffff880127488000 ffff8801255cd828 ffff8801234536c0
[  240.364118] Call Trace:
[  240.364127]  [<ffffffff81685af0>] schedule+0x65/0x67
[  240.364132]  [<ffffffff8141a235>] usb_kill_urb+0xb5/0xd3
[  240.364138]  [<ffffffff8109713a>] ? bit_waitqueue+0x7a/0x7a
[  240.364143]  [<ffffffff8141aa37>] usb_start_wait_urb+0xb2/0x173
[  240.364148]  [<ffffffff8141ad21>] usb_control_msg+0xd0/0x102
[  240.364152]  [<ffffffff8141ae07>] ? usb_get_status+0x3d/0xb0
[  240.364158]  [<ffffffff8114fb80>] ? kmem_cache_alloc_trace+0x4b/0xc9
[  240.364163]  [<ffffffff81686ce2>] ? _raw_spin_unlock_irqrestore+0x3f/0x6e
[  240.364167]  [<ffffffff8141ae4e>] usb_get_status+0x84/0xb0
[  240.364172]  [<ffffffff81686d03>] ? _raw_spin_unlock_irqrestore+0x60/0x6e
[  240.364177]  [<ffffffff8141474c>] usb_port_resume+0x37c/0x5b4
[  240.364183]  [<ffffffff810c372a>] ? mark_held_locks+0x55/0x99
[  240.364187]  [<ffffffff81686d3e>] ? _raw_spin_unlock_irq+0x2d/0x5a
[  240.364193]  [<ffffffff81424794>] generic_resume+0x1c/0x1e
[  240.364197]  [<ffffffff8141cd94>] usb_resume_both+0x94/0x106
[  240.364202]  [<ffffffff8141defb>] ? usb_runtime_suspend+0x5d/0x5d
[  240.364206]  [<ffffffff8141df15>] usb_runtime_resume+0x1a/0x1c
[  240.364211]  [<ffffffff813a85bd>] __rpm_callback+0x34/0x5b
[  240.364216]  [<ffffffff813a863a>] rpm_callback+0x56/0x79
[  240.364220]  [<ffffffff813a960b>] rpm_resume+0x38a/0x4a7
[  240.364225]  [<ffffffff816867a8>] ? _raw_spin_lock_irqsave+0x51/0x5c
[  240.364230]  [<ffffffff813a9921>] ? __pm_runtime_resume+0x5d/0x88
[  240.364234]  [<ffffffff813a992f>] __pm_runtime_resume+0x6b/0x88
[  240.364239]  [<ffffffff8141d7ad>] usb_autoresume_device+0x20/0x3f
[  240.364244]  [<ffffffff814244f3>] usbdev_open+0xc7/0x245
[  240.364249]  [<ffffffff8115d14c>] chrdev_open+0x130/0x15b
[  240.364254]  [<ffffffff8109d115>] ? lg_local_unlock+0x3f/0x5e
[  240.364259]  [<ffffffff8115d01c>] ? cdev_put+0x26/0x26
[  240.364264]  [<ffffffff81158182>] do_dentry_open.isra.17+0x16b/0x211
[  240.364268]  [<ffffffff81158249>] finish_open+0x21/0x2d
[  240.364273]  [<ffffffff81164e3e>] do_last.isra.59+0x7dc/0x962
[  240.364278]  [<ffffffff81162c32>] ? inode_permission+0x45/0x47
[  240.364282]  [<ffffffff81162cf6>] ? link_path_walk+0xc2/0x43e
[  240.364287]  [<ffffffff81165089>] path_openat.isra.60+0xc5/0x304
[  240.364292]  [<ffffffff811655c7>] do_filp_open+0x38/0x86
[  240.364297]  [<ffffffff8116f05a>] ? spin_unlock+0x9/0xb
[  240.364302]  [<ffffffff8116fcab>] ? __alloc_fd+0xf3/0x104
[  240.364307]  [<ffffffff81158eb6>] do_sys_open+0x6c/0xf9
[  240.364311]  [<ffffffff81158f64>] sys_open+0x21/0x23
[  240.364316]  [<ffffffff8168d286>] system_call_fastpath+0x1a/0x1f
[  240.364319] INFO: lockdep is turned off.


I tested my USB hardware with Alan's patch/program and it is susceptible
to the bug the problematic commit tries to work around, my hardware is:

00:1a.7 USB controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2 (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. P5Q Deluxe Motherboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fe8ffc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] Vendor Specific Information: Len=06 <?>
	Kernel driver in use: ehci-pci

