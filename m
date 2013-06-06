Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab3FFSQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:16:03 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:10687 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3FFSP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:15:59 -0400
From: Betty Dall <betty.dall@hp.com>
To: rjw@sisk.pl, bhelgaas@google.com, gong.chen@linux.intel.com,
        greg.pearson@hp.com
Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Betty Dall <betty.dall@hp.com>
Subject: [PATCH v3 6/6] PCI/AER: Provide reset_link for firmware first root port
Date: Thu,  6 Jun 2013 12:10:51 -0600
Message-Id: <1370542251-27387-7-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1370542251-27387-1-git-send-email-betty.dall@hp.com>
References: <1370542251-27387-1-git-send-email-betty.dall@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firmware first path does not install the aerdrv root port
service driver, so the firmware first root port does not have
a reset_link callback. When a firmware first root port does not have
a reset_link callback, use a new default reset_link similar to what
we already do for the default_downstream_reset_link(). The firmware
first default reset_link brings the root port out of SBR if firmware
left it in SBR.

Changes since v1:
Removed incorrect setting of p2p_ctrl after the read.

Changes since v2:
Treat the default case for a Root Port the same as the existing
default case for a Downstream Link.

Signed-off-by: Betty Dall <betty.dall@hp.com>
---

 drivers/pci/pcie/aer/aerdrv_core.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)


diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 8ec8b4f..cb29c04 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -400,16 +400,16 @@ void aer_do_secondary_bus_reset(struct pci_dev *dev)
 }
 
 /**
- * default_downstream_reset_link - default reset function for Downstream Port
- * @dev: pointer to downstream port's pci_dev data structure
+ * default_reset_link - default reset function
+ * @dev: pointer to pci_dev data structure
  *
- * Invoked when performing link reset at Downstream Port w/ no aer driver.
+ * Invoked when performing link reset on a Downstream Port or a
+ * Root Port with no aer driver.
  */
-static pci_ers_result_t default_downstream_reset_link(struct pci_dev *dev)
+static pci_ers_result_t default_reset_link(struct pci_dev *dev)
 {
 	aer_do_secondary_bus_reset(dev);
-	dev_printk(KERN_DEBUG, &dev->dev,
-		"Downstream Port link has been reset\n");
+	dev_dbg(&dev->dev, "Link has been reset\n");
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
@@ -458,8 +458,9 @@ static pci_ers_result_t reset_link(struct pci_dev *dev)
 
 	if (driver && driver->reset_link) {
 		status = driver->reset_link(udev);
-	} else if (pci_pcie_type(udev) == PCI_EXP_TYPE_DOWNSTREAM) {
-		status = default_downstream_reset_link(udev);
+	} else if (pci_pcie_type(udev) == PCI_EXP_TYPE_DOWNSTREAM ||
+		pci_pcie_type(udev) == PCI_EXP_TYPE_ROOT_PORT) {
+		status = default_reset_link(udev);
 	} else {
 		dev_printk(KERN_DEBUG, &dev->dev,
 			"no link-reset support at upstream device %s\n",
