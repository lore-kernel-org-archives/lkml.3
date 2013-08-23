Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab3HWRT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:19:58 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36720 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab3HWRTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:19:55 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI: Fix osc flag setup ordering to allow pcie hotplug use when available
Date: Fri, 23 Aug 2013 13:19:39 -0400
Message-Id: <1377278379-9054-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.1.4
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somewhere between 3.9 and 3.10 it seems the order in which pcie and acpi probed
slots for hotplug capabilites got reversed.  While this isn't a big deal, it did
uncover a bug in the ACPI bus setup path.  Specifically, acpi_pci_root_add calls
pci_acpi_scan_root before setting the osc flags for the device handle.
pci_acpi_scan_root, among other things uses device_is_managed_by_native_pciehp()
to determine if a given slot has pcie hotplug capabilties, whcih checks the
devices OSC_PCI_EXPRESS_NATIVE_HP_CONTROL flag.  Since that flag is not set
until after pci_acpi_scan_root_completes, the acpi code never sees that pcie
slots are hotplug capable and configures them all to use acpi instead.

Fix is pretty simple, just defer the scan until after the osc flags have been
set on the device.  Tested by myself and it seems to work well.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Len Brown <lenb@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-acpi@vger.kernel.org
---
 drivers/acpi/pci_root.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 5917839..a2c2661 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -437,27 +437,6 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	flags = base_flags = OSC_PCI_SEGMENT_GROUPS_SUPPORT;
 	acpi_pci_osc_support(root, flags);
 
-	/*
-	 * TBD: Need PCI interface for enumeration/configuration of roots.
-	 */
-
-	/*
-	 * Scan the Root Bridge
-	 * --------------------
-	 * Must do this prior to any attempt to bind the root device, as the
-	 * PCI namespace does not get created until this call is made (and
-	 * thus the root bridge's pci_dev does not exist).
-	 */
-	root->bus = pci_acpi_scan_root(root);
-	if (!root->bus) {
-		dev_err(&device->dev,
-			"Bus %04x:%02x not present in PCI namespace\n",
-			root->segment, (unsigned int)root->secondary.start);
-		result = -ENODEV;
-		goto end;
-	}
-
-	/* Indicate support for various _OSC capabilities. */
 	if (pci_ext_cfg_avail())
 		flags |= OSC_EXT_PCI_CONFIG_SUPPORT;
 	if (pcie_aspm_support_enabled()) {
@@ -520,6 +499,26 @@ static int acpi_pci_root_add(struct acpi_device *device,
 			 "(_OSC support mask: 0x%02x)\n", flags);
 	}
 
+	/*
+	 * TBD: Need PCI interface for enumeration/configuration of roots.
+	 */
+
+	/*
+	 * Scan the Root Bridge
+	 * --------------------
+	 * Must do this prior to any attempt to bind the root device, as the
+	 * PCI namespace does not get created until this call is made (and
+	 * thus the root bridge's pci_dev does not exist).
+	 */
+	root->bus = pci_acpi_scan_root(root);
+	if (!root->bus) {
+		dev_err(&device->dev,
+			"Bus %04x:%02x not present in PCI namespace\n",
+			root->segment, (unsigned int)root->secondary.start);
+		result = -ENODEV;
+		goto end;
+	}
+
 	pci_acpi_add_bus_pm_notifier(device, root->bus);
 	if (device->wakeup.flags.run_wake)
 		device_set_run_wake(root->bus->bridge, true);
-- 
1.8.1.4

