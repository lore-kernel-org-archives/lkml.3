Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3EASoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 14:44:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab3EASnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 14:43:45 -0400
Subject: [RFC PATCH 8/8] pci: Add reset probe functions
To: bhelgaas@google.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 01 May 2013 12:43:43 -0600
Message-ID: <20130501184343.28515.50042.stgit@bling.home>
In-Reply-To: <20130501181828.28515.68783.stgit@bling.home>
References: <20130501181828.28515.68783.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it's not enough to call pci_reset_function() and hope for the
best.  We may actually want to know which resets the device supports in
order to determine if pci_reset_function is sufficient or we should
call pci_reset_slot/bus.  Expose some helpers for this.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c   |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    3 +++
 2 files changed, 42 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6d17807..798e5bd 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3123,6 +3123,18 @@ clear:
 	return 0;
 }
 
+/**
+ * pci_probe_pcie_flr - Probe if device supports PCIe FLR
+ * @dev: PCI device to probe
+ *
+ * Return 0 if device supports PCIe FLR, non-zero otherwise.
+ */
+int pci_probe_pcie_flr(struct pci_dev *dev)
+{
+	return pcie_flr(dev, 1);
+}
+EXPORT_SYMBOL_GPL(pci_probe_pcie_flr);
+
 static int pci_af_flr(struct pci_dev *dev, int probe)
 {
 	int i;
@@ -3162,6 +3174,19 @@ clear:
 }
 
 /**
+ * pci_probe_af_flr - Probe if device supports PCI AF FLR
+ * @dev: PCI device to probe
+ *
+ * Return 0 if device supports FLR through a PCI Advanced Features capability,
+ * non-zero otherwise.
+ */
+int pci_probe_af_flr(struct pci_dev *dev)
+{
+	return pci_af_flr(dev, 1);
+}
+EXPORT_SYMBOL_GPL(pci_probe_af_flr);
+
+/**
  * pci_pm_reset - Put device into PCI_D3 and back into PCI_D0.
  * @dev: Device to reset.
  * @probe: If set, only check if the device can be reset this way.
@@ -3207,6 +3232,20 @@ static int pci_pm_reset(struct pci_dev *dev, int probe)
 }
 
 /**
+ * pci_probe_pm_reset - Probe if device supports PM reset
+ * @dev: PCI device to probe
+ *
+ * Return 0 if device claims to support a soft reset on D3hot->D0 transition,
+ * non-zero otherwise.  Note that "soft reset" isn't well defined and may not
+ * do much of any reset, depending on the device.
+ */
+int pci_probe_pm_reset(struct pci_dev *dev)
+{
+	return pci_pm_reset(dev, 1);
+}
+EXPORT_SYMBOL_GPL(pci_probe_pm_reset);
+
+/**
  * pci_reset_bridge_secondary_bus - Reset the secondary bus on a PCI bridge.
  * @dev: Bridge device
  *
diff --git a/include/linux/pci.h b/include/linux/pci.h
index cf4cf10..f6196a3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -922,6 +922,9 @@ int pcie_set_mps(struct pci_dev *dev, int mps);
 int __pci_reset_function(struct pci_dev *dev);
 int __pci_reset_function_locked(struct pci_dev *dev);
 int pci_reset_function(struct pci_dev *dev);
+int pci_probe_pcie_flr(struct pci_dev *dev);
+int pci_probe_af_flr(struct pci_dev *dev);
+int pci_probe_pm_reset(struct pci_dev *dev);
 int pci_reset_slot(struct pci_slot *slot);
 int pci_reset_bus(struct pci_bus *bus);
 void pci_reset_bridge_secondary_bus(struct pci_dev *dev);

