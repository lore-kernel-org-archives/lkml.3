Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558Ab3BNShR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 13:37:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758463Ab3BNShP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 13:37:15 -0500
Subject: [PATCH] pci: Disable slot presence detection around bus reset
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 11:37:13 -0700
Message-ID: <20130214183640.16220.33060.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bus reset can trigger a presence detection change and result in a
suprise hotplug.  This is generally not what we want to happen when
trying to reset a device.  Disable the presence detection control on
on bridges around bus reset.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 5cb5820..c1f7d77 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3229,8 +3229,8 @@ static int pci_pm_reset(struct pci_dev *dev, int probe)
 
 static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
 {
-	u16 ctrl;
-	struct pci_dev *pdev;
+	u16 ctrl, flags, sltctl = 0;
+	struct pci_dev *pdev, *bridge;
 
 	if (pci_is_root_bus(dev->bus) || dev->subordinate || !dev->bus->self)
 		return -ENOTTY;
@@ -3242,15 +3242,34 @@ static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
 	if (probe)
 		return 0;
 
-	pci_read_config_word(dev->bus->self, PCI_BRIDGE_CONTROL, &ctrl);
+	bridge = dev->bus->self;
+
+	/*
+	 * If the parent device supports a slot with presence detection
+	 * change enabled, holding the bus in reset can trigger that and
+	 * cause an unwanted surprise removal.  Disable presence detection
+	 * around the bus reset.
+	 */
+	pcie_capability_read_word(bridge, PCI_EXP_FLAGS, &flags);
+	if (flags & PCI_EXP_FLAGS_SLOT) {
+		pcie_capability_read_word(bridge, PCI_EXP_SLTCTL, &sltctl);
+		if (sltctl & PCI_EXP_SLTCTL_PDCE)
+			pcie_capability_write_word(bridge, PCI_EXP_SLTCTL,
+						sltctl & ~PCI_EXP_SLTCTL_PDCE);
+	}
+
+	pci_read_config_word(bridge, PCI_BRIDGE_CONTROL, &ctrl);
 	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
-	pci_write_config_word(dev->bus->self, PCI_BRIDGE_CONTROL, ctrl);
+	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, ctrl);
 	msleep(100);
 
 	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
-	pci_write_config_word(dev->bus->self, PCI_BRIDGE_CONTROL, ctrl);
+	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, ctrl);
 	msleep(100);
 
+	if (sltctl & PCI_EXP_SLTCTL_PDCE)
+		pcie_capability_write_word(bridge, PCI_EXP_SLTCTL, sltctl);
+
 	return 0;
 }
 

