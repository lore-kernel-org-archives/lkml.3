Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaCGOdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:33:54 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:55549 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaCGOdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:33:53 -0500
MIME-Version: 1.0
From: Andreas Noever <andreas.noever@gmail.com>
Date: Fri, 7 Mar 2014 15:33:31 +0100
Message-ID: <CAMxnaaXd9-VbxSYa9q1YVT+fwfDFYKGG2Hq-1jkc-awLX-HwtQ@mail.gmail.com>
Subject: [Bug] PCI: Enable INTx if BIOS left them disabled - triggers during rescan
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After upgrading to the latest RC I noticed that suprise removal
stopped working. Linux did not notice that the devices where gone.
Bisection points to

1f42db786b14a31bf807fc41ee5583a00c08fcb1 PCI: Enable INTx if BIOS left
them disabled
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=1f42db786b14a31bf807fc41ee5583a00c08fcb1

It seems that the above patch is triggered on the bridge itself (!)
when a new device is added below it. At this point the hotplug driver
for the bridge has already enabled MSI. Reenabling INTX kills MSI and
prevents later suprise removal notifications.

The following stacktrace is from a "echo 1 > rescan" on the bridge:
do_pci_enable_device+0x59/0x140
pci_reenable_device+0x1f/0x30
pci_assign_unassigned_bridge_resources+0x123/0x160
pci_rescan_bus_bridge_resize+0x28/0x40
dev_bus_rescan_store+0x85/0xa0
dev_attr_store+0x18/0x30
sysfs_kf_write+0x3d/0x50
kernfs_fop_write+0xd2/0x140
vfs_write+0xba/0x1e0
SyS_write+0x49/0xa0
system_call_fastpath+0x1a/0x1f

Similarly for a hotplug event:
do_pci_enable_device+0x59/0x140
pci_reenable_device+0x1f/0x30
pci_assign_unassigned_bridge_resources+0x123/0x160
pciehp_configure_device+0x90/0x160
pciehp_enable_slot+0x163/0x280
pciehp_power_thread+0xb8/0xe0
process_one_work+0x167/0x420
worker_thread+0x121/0x3a0

In both cases DisINTx is turned off and the hotplug driver stops
reacting to events.

Andreas
