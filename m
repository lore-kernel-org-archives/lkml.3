Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab3HZPj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:39:27 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59502 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab3HZPjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:39:25 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v3] ACPI: Fix osc flag setup ordering to allow pcie hotplug use when available
Date: Mon, 26 Aug 2013 11:39:13 -0400
Message-Id: <1377531553-17716-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377278379-9054-1-git-send-email-nhorman@tuxdriver.com>
References: <1377278379-9054-1-git-send-email-nhorman@tuxdriver.com>
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
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-acpi@vger.kernel.org
CC: linux-pci@vger.kernel.org

---
Change notes:
v2) eferred the disabling of aspm until after the acpi scan of the pci bus is
complete.  This was done to allow proper handling of pcie 1.1 devices, as per:

commit b8178f130e25c1bdac1c33e0996f1ff6e20ec08e
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Mon Apr 1 15:47:39 2013 -0600

    Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"

As discussed previously in the thread the disable logic for aspm needs to be
untangled and refactored, which is not something I'm sufficently versed in teh
hotplug code to do right now, but this fixes the problem above, and prevents the
problem that necessitated the revert without adding any visible complexity to
the user, so I think its ok.

v3) Fixup stupid authorship error
---
 drivers/acpi/pci_root.c | 54 +++++++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 5917839..1e80a90 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -378,6 +378,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	struct acpi_pci_root *root;
 	u32 flags, base_flags;
 	acpi_handle handle = device->handle;
+	bool no_aspm = false;
 
 	root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
 	if (!root)
@@ -437,27 +438,6 @@ static int acpi_pci_root_add(struct acpi_device *device,
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
@@ -512,7 +492,14 @@ static int acpi_pci_root_add(struct acpi_device *device,
 				acpi_format_exception(status), flags);
 			dev_info(&device->dev,
 				 "ACPI _OSC control for PCIe not granted, disabling ASPM\n");
-			pcie_no_aspm();
+			/*
+			 * We want to disable aspm here, but aspm_disabled
+			 * needs to remain in its state from boot so that we
+			 * properly handle pcie 1.1 devices.  So we set this
+			 * flag here, to defer the action until after the acpi
+			 * root scan
+			 */
+			no_aspm = true;
 		}
 	} else {
 		dev_info(&device->dev,
@@ -520,6 +507,29 @@ static int acpi_pci_root_add(struct acpi_device *device,
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
+	if (no_aspm)
+		pcie_no_aspm();
+
 	pci_acpi_add_bus_pm_notifier(device, root->bus);
 	if (device->wakeup.flags.run_wake)
 		device_set_run_wake(root->bus->bridge, true);
-- 
1.8.1.4

