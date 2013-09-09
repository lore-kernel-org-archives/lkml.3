Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab3IIP2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:28:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994Ab3IIP16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:27:58 -0400
Date: Mon, 9 Sep 2013 17:29:53 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: [PATCH 9/9] PCI/MSI: Make return values only 0/-errno when MSIs
 allocated
Message-ID: <20130909152953.GK24962@dhcp-26-207.brq.redhat.com>
References: <20130905150259.GA30984@dhcp-26-207.brq.redhat.com>
 <20130905150442.GA24148@htj.dyndns.org>
 <20130905154041.GD30984@dhcp-26-207.brq.redhat.com>
 <20130905154436.GC24148@htj.dyndns.org>
 <20130905185440.GA13175@dhcp-26-207.brq.redhat.com>
 <20130905200608.GA3846@htj.dyndns.org>
 <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/pci/msi.c |   87 +++++++++++++++++++----------------------------------
 1 files changed, 31 insertions(+), 56 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 21e6471..f5fcb74 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -702,7 +702,7 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
 	if (ret)
-		goto out_avail;
+		goto error;
 
 	/*
 	 * Some devices require MSI-X to be enabled before we can touch the
@@ -716,7 +716,7 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	ret = populate_msi_sysfs(dev);
 	if (ret)
-		goto out_free;
+		goto error;
 
 	/* Set MSI-X enabled bits and unmask the function */
 	pci_intx_for_msi(dev, 0);
@@ -727,24 +727,7 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	return 0;
 
-out_avail:
-	if (ret < 0) {
-		/*
-		 * If we had some success, report the number of irqs
-		 * we succeeded in setting up.
-		 */
-		struct msi_desc *entry;
-		int avail = 0;
-
-		list_for_each_entry(entry, &dev->msi_list, list) {
-			if (entry->irq != 0)
-				avail++;
-		}
-		if (avail != 0)
-			ret = avail;
-	}
-
-out_free:
+error:
 	free_msi_irqs(dev);
 
 	return ret;
@@ -800,17 +783,15 @@ static int pci_msi_check_device(struct pci_dev *dev, int nvec, int type)
  * @dev: device to configure
  * @nvec: number of interrupts to configure
  *
- * Allocate IRQs for a device with the MSI capability.
- * This function returns a negative errno if an error occurs.  If it
- * is unable to allocate the number of interrupts requested, it returns
- * the number of interrupts it might be able to allocate.  If it successfully
- * allocates at least the number of interrupts requested, it returns 0 and
- * updates the @dev's irq member to the lowest new interrupt number; the
- * other interrupt numbers allocated to this device are consecutive.
+ * Allocate IRQs for a device with the MSI capability. This function returns
+ * a negative errno if an error occurs. If it successfully allocates at least
+ * the number of interrupts requested, it returns 0 and updates the @dev's
+ * irq member to the lowest new interrupt number; the other interrupt numbers
+ * allocated to this device are consecutive.
  */
 int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 {
-	int status, maxvec;
+	int ret, maxvec;
 	u16 msgctl;
 
 	if (!dev->msi_cap)
@@ -819,11 +800,11 @@ int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
 	maxvec = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
 	if (nvec > maxvec)
-		return maxvec;
+		return -EINVAL;
 
-	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSI);
-	if (status)
-		return status;
+	ret = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSI);
+	if (ret)
+		return ret;
 
 	WARN_ON(!!dev->msi_enabled);
 
@@ -834,33 +815,30 @@ int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
 		return -EINVAL;
 	}
 
-	status = msi_capability_init(dev, nvec);
-	return status;
+	ret = msi_capability_init(dev, nvec);
+	return ret;
 }
 EXPORT_SYMBOL(pci_enable_msi_block);
 
-int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec)
+int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec_ptr)
 {
-	int ret, nvec;
+	int ret, maxvec;
 	u16 msgctl;
 
 	if (!dev->msi_cap)
 		return -EINVAL;
 
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &msgctl);
-	ret = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
-
-	if (maxvec)
-		*maxvec = ret;
+	maxvec = 1 << ((msgctl & PCI_MSI_FLAGS_QMASK) >> 1);
 
-	do {
-		nvec = ret;
-		ret = pci_enable_msi_block(dev, nvec);
-	} while (ret > 0);
+	if (maxvec_ptr)
+		*maxvec_ptr = maxvec;
 
-	if (ret < 0)
+	ret = pci_enable_msi_block(dev, maxvec);
+	if (ret)
 		return ret;
-	return nvec;
+
+	return maxvec;
 }
 EXPORT_SYMBOL(pci_enable_msi_block_auto);
 
@@ -928,25 +906,22 @@ int pci_msix_table_size(struct pci_dev *dev)
  * MSI-X mode enabled on its hardware device function. A return of zero
  * indicates the successful configuration of MSI-X capability structure
  * with new allocated MSI-X irqs. A return of < 0 indicates a failure.
- * Or a return of > 0 indicates that driver request is exceeding the number
- * of irqs or MSI-X vectors available. Driver should use the returned value to
- * re-send its request.
  **/
 int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 {
-	int status, nr_entries;
+	int ret, nr_entries;
 	int i, j;
 
 	if (!entries || !dev->msix_cap)
 		return -EINVAL;
 
-	status = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSIX);
-	if (status)
-		return status;
+	ret = pci_msi_check_device(dev, nvec, PCI_CAP_ID_MSIX);
+	if (ret)
+		return ret;
 
 	nr_entries = pci_msix_table_size(dev);
 	if (nvec > nr_entries)
-		return nr_entries;
+		return -EINVAL;
 
 	/* Check for any invalid entries */
 	for (i = 0; i < nvec; i++) {
@@ -965,8 +940,8 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 		       "(MSI IRQ already assigned)\n");
 		return -EINVAL;
 	}
-	status = msix_capability_init(dev, entries, nvec);
-	return status;
+	ret = msix_capability_init(dev, entries, nvec);
+	return ret;
 }
 EXPORT_SYMBOL(pci_enable_msix);
 
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
