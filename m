Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaKZP0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:26:20 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41830 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaKZP0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:26:19 -0500
Date: Wed, 26 Nov 2014 17:26:15 +0200
From: Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        pgynther@google.com, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: bluetooth related firmware loader spew on resume.
Message-ID: <20141126172615.7b6e2cdb@mdontu-l.dsd.ro>
In-Reply-To: <s5hoaruvvje.wl-tiwai@suse.de>
References: <20141111181228.GA27815@redhat.com>
	<20141126165609.41ee0c24@mdontu-l.dsd.ro>
	<s5hoaruvvje.wl-tiwai@suse.de>
Organization: Home
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014 16:19:49 +0100
Takashi Iwai <tiwai@suse.de> wrote:

> At Wed, 26 Nov 2014 16:56:09 +0200,
> Mihai Donțu wrote:
> > 
> > On Tue, 11 Nov 2014 13:12:28 -0500 Dave Jones wrote:
> > > Since the addition of 10d4c6736ea "Bluetooth: btusb: Add Broadcom patch
> > > RAM support", I (and a number of other people[*]) have been seeing
> > > this trace on resume from suspend.
> > > 
> > > WARNING: CPU: 1 PID: 8565 at drivers/base/firmware_class.c:1127 _request_firmware+0x4c1/0x7c0()
> > > CPU: 1 PID: 8565 Comm: kworker/u17:0 Not tainted 3.17.2-200.fc20.x86_64 #1
> > > Hardware name: LENOVO 2356JK8/2356JK8, BIOS G7ET94WW (2.54 ) 04/30/2013
> > > Workqueue: hci0 hci_power_on [bluetooth]
> > > 0000000000000000 00000000f52a564b ffff8800a8c63be8 ffffffff817271cc
> > > 0000000000000000 ffff8800a8c63c20 ffffffff81094ced ffff8800a8c63d10
> > > ffff8801365ddf00 ffff8801387b4b00 ffff8800a8c63d08 00000000fffffff5
> > > Call Trace:
> > > [<ffffffff817271cc>] dump_stack+0x45/0x56
> > > [<ffffffff81094ced>] warn_slowpath_common+0x7d/0xa0
> > > [<ffffffff81094e1a>] warn_slowpath_null+0x1a/0x20
> > > [<ffffffff814965c1>] _request_firmware+0x4c1/0x7c0
> > > [<ffffffff8137b9b9>] ? snprintf+0x49/0x70
> > > [<ffffffff814968f1>] request_firmware+0x31/0x50
> > > [<ffffffffa0943bf3>] btusb_setup_bcm_patchram+0x83/0x550 [btusb]
> > > [<ffffffff8148ecf6>] ? rpm_idle+0xd6/0x2b0
> > > [<ffffffffa0649051>] hci_dev_do_open+0xe1/0xa60 [bluetooth]
> > > ACPI: \_SB_.PCI0.LPC_.EC__.BAT1: docking
> > > Restarting tasks ... 
> > > [<ffffffff810bcb3d>] ? ttwu_do_activate.constprop.90+0x5d/0x70
> > > [<ffffffffa064a1c0>] hci_power_on+0x40/0x1e0 [bluetooth]
> > > [<ffffffff810f53fb>] ? lock_timer_base.isra.34+0x2b/0x50
> > > [<ffffffff810acc39>] process_one_work+0x149/0x3d0
> > > [<ffffffff810ad2bb>] worker_thread+0x11b/0x490
> > > [<ffffffff810ad1a0>] ? rescuer_thread+0x2e0/0x2e0
> > > [<ffffffff810b2318>] kthread+0xd8/0xf0
> > > [<ffffffff810b2240>] ? kthread_create_on_node+0x190/0x190
> > > [<ffffffff8172e7bc>] ret_from_fork+0x7c/0xb0
> > > [<ffffffff810b2240>] ? kthread_create_on_node+0x190/0x190
> > > ---[ end trace 75a0e9c7f33ebb4c ]---
> > > bluetooth hci0: firmware: brcm/BCM20702A0-0a5c-21e6.hcd will not be loaded
> > > Bluetooth: hci0: BCM: patch brcm/BCM20702A0-0a5c-21e6.hcd not found
> > > 
> > > 
> > > At first I thought it was just over-reaction to the file being missing, but
> > > looking at the WARN_ON, it appears that we're trying to invoke the firmware
> > > loader before userspace is back up ?
> > > 
> > > In this (and probably other related) kernel, CONFIG_FW_LOADER_USER_HELPER is unset,
> > > in case that matters at all.
> > > 
> > > 	Dave
> > > 
> > > [*] https://bugzilla.kernel.org/show_bug.cgi?id=81821
> > >     https://bugzilla.redhat.com/show_bug.cgi?id=1133378
> > 
> > I have the following during normal boot:
> > 
> > [    5.620796] Bluetooth: hci0: read Intel version: 370710018002030d00
> > [    5.620822] bluetooth hci0: Direct firmware load for intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq failed with error -2
> > [    5.620827] Bluetooth: hci0 failed to open Intel firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq(-2)
> > [    5.620920] bluetooth hci0: Direct firmware load for intel/ibt-hw-37.7.bseq failed with error -2
> > [    5.620922] Bluetooth: hci0 failed to open default Intel fw file: intel/ibt-hw-37.7.bseq
> > [    5.629910] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
> > [    5.629916] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
> > 
> > The driver is trying to load the firmware before root is mounted. Do I
> > really need an initramfs?
> 
> If btusb driver is loaded in initrd, you'd need the corresponding
> firmware in initrd, too.

The driver is built into the kernel and I don't use an initrd. I could
probably create one, but it's a bit tricky with UEFI and a tad harder
to maintain.

-- 
Mihai Donțu
