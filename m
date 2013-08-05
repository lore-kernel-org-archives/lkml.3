Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3HEThV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:37:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab3HEThN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:37:13 -0400
Subject: [PATCH v4 1/9] pci: Create pci_reset_bridge_secondary_bus()
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: ddutile@redhat.com, indou.takao@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Date: Mon, 05 Aug 2013 13:37:10 -0600
Message-ID: <20130805193709.9260.2424.stgit@bling.home>
In-Reply-To: <20130805193200.9260.38729.stgit@bling.home>
References: <20130805193200.9260.38729.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the secondary bus reset code from pci_parent_bus_reset() into its own
function.  Export it as we'll later be calling it from hotplug controllers
and elsewhere.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c   |   32 +++++++++++++++++++++++---------
 include/linux/pci.h |    1 +
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e37fea6..d468608 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3215,9 +3215,30 @@ static int pci_pm_reset(struct pci_dev *dev, int probe)
 	return 0;
 }
 
-static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
+/**
+ * pci_reset_bridge_secondary_bus - Reset the secondary bus on a PCI bridge.
+ * @dev: Bridge device
+ *
+ * Use the bridge control register to assert reset on the secondary bus.
+ * Devices on the secondary bus are left in power-on state.
+ */
+void pci_reset_bridge_secondary_bus(struct pci_dev *dev)
 {
 	u16 ctrl;
+
+	pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &ctrl);
+	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
+	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
+	msleep(100);
+
+	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
+	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
+	msleep(100);
+}
+EXPORT_SYMBOL_GPL(pci_reset_bridge_secondary_bus);
+
+static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
+{
 	struct pci_dev *pdev;
 
 	if (pci_is_root_bus(dev->bus) || dev->subordinate || !dev->bus->self)
@@ -3230,14 +3251,7 @@ static int pci_parent_bus_reset(struct pci_dev *dev, int probe)
 	if (probe)
 		return 0;
 
-	pci_read_config_word(dev->bus->self, PCI_BRIDGE_CONTROL, &ctrl);
-	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
-	pci_write_config_word(dev->bus->self, PCI_BRIDGE_CONTROL, ctrl);
-	msleep(100);
-
-	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
-	pci_write_config_word(dev->bus->self, PCI_BRIDGE_CONTROL, ctrl);
-	msleep(100);
+	pci_reset_bridge_secondary_bus(dev->bus->self);
 
 	return 0;
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0fd1f15..35c1bc4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -924,6 +924,7 @@ int pcie_set_mps(struct pci_dev *dev, int mps);
 int __pci_reset_function(struct pci_dev *dev);
 int __pci_reset_function_locked(struct pci_dev *dev);
 int pci_reset_function(struct pci_dev *dev);
+void pci_reset_bridge_secondary_bus(struct pci_dev *dev);
 void pci_update_resource(struct pci_dev *dev, int resno);
 int __must_check pci_assign_resource(struct pci_dev *dev, int i);
 int __must_check pci_reassign_resource(struct pci_dev *dev, int i, resource_size_t add_size, resource_size_t align);

