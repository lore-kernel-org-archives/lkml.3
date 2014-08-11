Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaHKLpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:45:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbaHKLpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:45:45 -0400
Date: Mon, 11 Aug 2014 13:45:36 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 2/2] PCI/MSI: Remove arch_msi_check_device()
Message-ID: <20140811114536.GA3427@dhcp-27-160.brq.redhat.com>
References: <cover.1405160163.git.agordeev@redhat.com>
 <1005232855c3af2c0c669818ee63be445389b6ad.1405160163.git.agordeev@redhat.com>
 <20140716222024.GE14366@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716222024.GE14366@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
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
 drivers/pci/msi.c   | 49 +++++++++++++------------------------------------
 include/linux/msi.h |  3 ---
 2 files changed, 13 insertions(+), 39 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 5a40516..6c2cc41 100644
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
@@ -806,22 +796,23 @@ out_free:
 }
 
 /**
- * pci_msi_check_device - check whether MSI may be enabled on a device
+ * pci_msi_supported - check whether MSI may be enabled on a device
  * @dev: pointer to the pci_dev data structure of MSI device function
  * @nvec: how many MSIs have been requested ?
- * @type: are we checking for MSI or MSI-X ?
  *
  * Look at global flags, the device itself, and its parent buses
  * to determine if MSI/-X are supported for the device. If MSI/-X is
  * supported return 0, else return an error code.
  **/
-static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
+static int pci_msi_supported(struct pci_dev *dev, int nvec)
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
@@ -843,10 +834,6 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
 		if (bus->bus_flags & PCI_BUS_FLAGS_NO_MSI)
 			return -EINVAL;
 
-	ret = arch_msi_check_device(dev, nvec, type);
-	if (ret)
-		return ret;
-
 	return 0;
 }
 
@@ -949,13 +936,13 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 	int status, nr_entries;
 	int i, j;
 
-	if (!entries || !dev->msix_cap || dev->current_state != PCI_D0)
-		return -EINVAL;
-
-	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSIX);
+	status = pci_msi_supported(dev, nvec);
 	if (status)
 		return status;
 
+	if (!entries)
+		return -EINVAL;
+
 	nr_entries = pci_msix_vec_count(dev);
 	if (nr_entries < 0)
 		return nr_entries;
@@ -1062,8 +1049,9 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 	int nvec;
 	int rc;
 
-	if (dev->current_state != PCI_D0)
-		return -EINVAL;
+	rc = pci_msi_supported(dev, minvec);
+	if (rc)
+		return rc;
 
 	WARN_ON(!!dev->msi_enabled);
 
@@ -1086,17 +1074,6 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
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
index 8103f32..dbf7cc9 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -60,7 +60,6 @@ int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
 void arch_teardown_msi_irq(unsigned int irq);
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void arch_teardown_msi_irqs(struct pci_dev *dev);
-int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
 void arch_restore_msi_irqs(struct pci_dev *dev);
 
 void default_teardown_msi_irqs(struct pci_dev *dev);
@@ -77,8 +76,6 @@ struct msi_chip {
 	int (*setup_irq)(struct msi_chip *chip, struct pci_dev *dev,
 			 struct msi_desc *desc);
 	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
-	int (*check_device)(struct msi_chip *chip, struct pci_dev *dev,
-			    int nvec, int type);
 };
 
 #endif /* LINUX_MSI_H */
-- 
1.9.3

