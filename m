Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab3FDXST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:18:19 -0400
Received: from 1wt.eu ([62.212.114.60]:35339 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab3FDWl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:56 -0400
Message-Id: <20130604172132.836205446@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 061/184] PCI/PM: Clean up PME state when removing a device
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit 249bfb83cf8ba658955f0245ac3981d941f746ee upstream.

Devices are added to pci_pme_list when drivers use pci_enable_wake()
or pci_wake_from_d3(), but they aren't removed from the list unless
the driver explicitly disables wakeup.  Many drivers never disable
wakeup, so their devices remain on the list even after they are
removed, e.g., via hotplug.  A subsequent PME poll will oops when
it tries to touch the device.

This patch disables PME# on a device before removing it, which removes
the device from pci_pme_list.  This is safe even if the device never
had PME# enabled.

This oops can be triggered by unplugging a Thunderbolt ethernet adapter
on a Macbook Pro, as reported by Daniel below.

[bhelgaas: changelog]
Reference: http://lkml.kernel.org/r/CAMVG2svG21yiM1wkH4_2pen2n+cr2-Zv7TbH3Gj+8MwevZjDbw@mail.gmail.com
Reported-and-tested-by: Daniel J Blueman <daniel@quora.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/pci/remove.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 176615e..27ae1f9 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -19,6 +19,8 @@ static void pci_free_resources(struct pci_dev *dev)
 
 static void pci_stop_dev(struct pci_dev *dev)
 {
+	pci_pme_active(dev, false);
+
 	if (dev->is_added) {
 		pci_proc_detach_device(dev);
 		pci_remove_sysfs_dev_files(dev);
-- 
1.7.12.2.21.g234cd45.dirty



