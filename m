Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab3H2URZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:17:25 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52569 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3H2URX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:17:23 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v4] ACPI: Fix osc flag setup ordering to allow pcie hotplug use when available
Date: Thu, 29 Aug 2013 16:17:05 -0400
Message-Id: <1377807425-27423-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377278379-9054-1-git-send-email-nhorman@tuxdriver.com>
References: <1377278379-9054-1-git-send-email-nhorman@tuxdriver.com>
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fix for:
https://bugzilla.kernel.org/show_bug.cgi?id=60736

During the 3.8 devel cycle:

commit 8c33f51df406e1a1f7fa4e9b244845b7ebd61fa6
Author: Taku Izumi <izumi.taku@jp.fujitsu.com>
Date:   Tue Oct 30 15:27:13 2012 +0900

    PCI/ACPI: Request _OSC control before scanning PCI root bus

went in to allow us to query the pcie hotplug flags during the acpi bus scan.
It however caused problems with the disabling of pcie aspm, and so:
commit b8178f130e25c1bdac1c33e0996f1ff6e20ec08e
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Mon Apr 1 15:47:39 2013 -0600

    Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"

Backed it out.  This of course brought back the problem in which acpi took over
hotplug ports that were meant to be controlled by pcie.

This patch gives us both items.  It lets us request _OSC control before scanning
the pci root bus, but defers any disabling of aspm until after the scan is
complete, allowing us to properly handle old pcie 1.1 devices aspm settings
properly, as b8178f130e documents.

Tested successfully by myself.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Len Brown <lenb@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-acpi@vger.kernel.org
CC: linux-pci@vger.kernel.org
---
 drivers/acpi/pci_root.c | 62 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 5917839..6110fd2 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -378,6 +378,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	struct acpi_pci_root *root;
 	u32 flags, base_flags;
 	acpi_handle handle = device->handle;
+	bool no_aspm = false, clear_aspm = false;
 
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
@@ -471,7 +451,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 		if (ACPI_FAILURE(status)) {
 			dev_info(&device->dev, "ACPI _OSC support "
 				"notification failed, disabling PCIe ASPM\n");
-			pcie_no_aspm();
+			no_aspm = true;
 			flags = base_flags;
 		}
 	}
@@ -503,7 +483,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 				 * We have ASPM control, but the FADT indicates
 				 * that it's unsupported. Clear it.
 				 */
-				pcie_clear_aspm(root->bus);
+				clear_aspm = true;
 			}
 		} else {
 			dev_info(&device->dev,
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
@@ -520,6 +507,33 @@ static int acpi_pci_root_add(struct acpi_device *device,
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
+	if (clear_aspm) {
+		dev_info(&device->dev, "Disabling ASPM (FADT indicates it is unsupported)\n");
+		pcie_clear_aspm(root->bus);
+	}
+	if (no_aspm)
+		pcie_no_aspm();
+
 	pci_acpi_add_bus_pm_notifier(device, root->bus);
 	if (device->wakeup.flags.run_wake)
 		device_set_run_wake(root->bus->bridge, true);
-- 
1.8.1.4

