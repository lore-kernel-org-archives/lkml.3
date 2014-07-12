Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaGLLVA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 07:21:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbaGLLUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 07:20:38 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 2/2] PCI/MSI: Remove arch_msi_check_device()
Date: Sat, 12 Jul 2014 13:21:08 +0200
Message-Id: <1005232855c3af2c0c669818ee63be445389b6ad.1405160163.git.agordeev@redhat.com>
In-Reply-To: <cover.1405160163.git.agordeev@redhat.com>
References: <cover.1405160163.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no archs that override arch_msi_check_device()
hook. Remove it as it is completely redundant.

If an arch would need to check MSI/MSI-X possibility for a
device it should make it within arch_setup_msi_irqs() hook.

Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-pci@vger.kernel.org
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/pci/msi.c   |   49 +++++++++++++------------------------------------
 include/linux/msi.h |    3 ---
 2 files changed, 13 insertions(+), 39 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 13f3d30..19ac058 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -56,16 +56,6 @@ void __weak arch_teardown_msi_irq(unsigned int irq)
 	chip->teardown_irq(chip, irq);
 }
 
-int __weak arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
-{
-	struct msi_chip *chip = dev->bus->msi;
-
-	if (!chip || !chip->check_device)
-		return 0;
-
-	return chip->check_device(chip, dev, nvec, type);
-}
-
 int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	struct msi_desc *entry;
@@ -809,22 +799,23 @@ out_free:
 }
 
 /**
- * pci_msi_check_device - check whether MSI may be enabled on a device
+ * msi_check_device - check whether MSI may be enabled on a device
  * @dev: pointer to the pci_dev data structure of MSI device function
  * @nvec: how many MSIs have been requested ?
- * @type: are we checking for MSI or MSI-X ?
  *
  * Look at global flags, the device itself, and its parent buses
  * to determine if MSI/-X are supported for the device. If MSI/-X is
  * supported return 0, else return an error code.
  **/
-static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
+static int msi_check_device(struct pci_dev *dev, int nvec)
 {
 	struct pci_bus *bus;
-	int ret;
 
 	/* MSI must be globally enabled and supported by the device */
-	if (!pci_msi_enable || !dev || dev->no_msi)
+	if (!pci_msi_enable)
+		return -EINVAL;
+
+	if (!dev || dev->no_msi || dev->current_state != PCI_D0)
 		return -EINVAL;
 
 	/*
@@ -846,10 +837,6 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
 		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
 			return -EINVAL;
 
-	ret = arch_msi_check_device(dev, nvec, type);
-	if (ret)
-		return ret;
-
 	return 0;
 }
 
@@ -954,13 +941,13 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 	int status, nr_entries;
 	int i, j;
 
-	if (!entries || !dev->msix_cap || dev->current_state != PCI_D0)
-		return -EINVAL;
-
-	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSIX);
+	status = msi_check_device(dev, nvec);
 	if (status)
 		return status;
 
+	if (!entries)
+		return -EINVAL;
+
 	nr_entries = pci_msix_vec_count(dev);
 	if (nr_entries < 0)
 		return nr_entries;
@@ -1085,8 +1072,9 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 	int nvec;
 	int rc;
 
-	if (dev->current_state != PCI_D0)
-		return -EINVAL;
+	rc = msi_check_device(dev, minvec);
+	if (rc)
+		return rc;
 
 	WARN_ON(!!dev->msi_enabled);
 
@@ -1109,17 +1097,6 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 		nvec = maxvec;
 
 	do {
-		rc = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSI);
-		if (rc < 0) {
-			return rc;
-		} else if (rc > 0) {
-			if (rc < minvec)
-				return -ENOSPC;
-			nvec = rc;
-		}
-	} while (rc);
-
-	do {
 		rc = msi_capability_init(dev, nvec);
 		if (rc < 0) {
 			return rc;
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 92a2f99..3b873bc 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -59,7 +59,6 @@ int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
 void arch_teardown_msi_irq(unsigned int irq);
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void arch_teardown_msi_irqs(struct pci_dev *dev);
-int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
 void arch_restore_msi_irqs(struct pci_dev *dev);
 
 void default_teardown_msi_irqs(struct pci_dev *dev);
@@ -76,8 +75,6 @@ struct msi_chip {
 	int (*setup_irq)(struct msi_chip *chip, struct pci_dev *dev,
 			 struct msi_desc *desc);
 	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
-	int (*check_device)(struct msi_chip *chip, struct pci_dev *dev,
-			    int nvec, int type);
 };
 
 #endif /* LINUX_MSI_H */
-- 
1.7.7.6

