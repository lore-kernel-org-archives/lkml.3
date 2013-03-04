Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab3CDDog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:44:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33039 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756786Ab3CDDoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:23 -0500
Message-Id: <20130304033713.138819679@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:03 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 056/153] PCI/PM: Clean up PME state when removing a device
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/remove.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -19,6 +19,8 @@ static void pci_free_resources(struct pc
 
 static void pci_stop_dev(struct pci_dev *dev)
 {
+	pci_pme_active(dev, false);
+
 	if (dev->is_added) {
 		pci_proc_detach_device(dev);
 		pci_remove_sysfs_dev_files(dev);


