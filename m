Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaKLNoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:44:44 -0500
Received: from www.linutronix.de ([62.245.132.108]:41697 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaKLNnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:43:11 -0500
Message-Id: <20141112134120.840546893@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 12 Nov 2014 13:43:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [patch 12/16] PCI/MSI: Simplify PCI MSI code by initializing
 msi_desc.nvec_used earlier
References: <20141112133941.647950773@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=pci-msi-simplify-pci-msi-code-by-initializing-msi_desc-nvec_used-earlier.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@linux.intel.com>

Simplify PCI MSI code by initializing msi_desc.nvec_used and
msi_desc.msi_attrib.multiple when creating MSI descriptors.

Also remove redundant checks in IRQ remapping drivers, PCI MSI core
already guarantees these.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/irq_remapping.c |    8 --------
 drivers/pci/msi.c             |   40 +++++++++++++++-------------------------
 2 files changed, 15 insertions(+), 33 deletions(-)

Index: tip/drivers/iommu/irq_remapping.c
===================================================================
--- tip.orig/drivers/iommu/irq_remapping.c
+++ tip/drivers/iommu/irq_remapping.c
@@ -56,19 +56,13 @@ static int do_setup_msi_irqs(struct pci_
 	unsigned int irq;
 	struct msi_desc *msidesc;
 
-	WARN_ON(!list_is_singular(&dev->msi_list));
 	msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
-	WARN_ON(msidesc->irq);
-	WARN_ON(msidesc->msi_attrib.multiple);
-	WARN_ON(msidesc->nvec_used);
 
 	irq = irq_alloc_hwirqs(nvec, dev_to_node(&dev->dev));
 	if (irq == 0)
 		return -ENOSPC;
 
 	nvec_pow2 = __roundup_pow_of_two(nvec);
-	msidesc->nvec_used = nvec;
-	msidesc->msi_attrib.multiple = ilog2(nvec_pow2);
 	for (sub_handle = 0; sub_handle < nvec; sub_handle++) {
 		if (!sub_handle) {
 			index = msi_alloc_remapped_irq(dev, irq, nvec_pow2);
@@ -96,8 +90,6 @@ error:
 	 * IRQs from tearing down again in default_teardown_msi_irqs()
 	 */
 	msidesc->irq = 0;
-	msidesc->nvec_used = 0;
-	msidesc->msi_attrib.multiple = 0;
 
 	return ret;
 }
Index: tip/drivers/pci/msi.c
===================================================================
--- tip.orig/drivers/pci/msi.c
+++ tip/drivers/pci/msi.c
@@ -85,19 +85,13 @@ int __weak arch_setup_msi_irqs(struct pc
  */
 void default_teardown_msi_irqs(struct pci_dev *dev)
 {
+	int i;
 	struct msi_desc *entry;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		int i, nvec;
-		if (entry->irq == 0)
-			continue;
-		if (entry->nvec_used)
-			nvec = entry->nvec_used;
-		else
-			nvec = 1 << entry->msi_attrib.multiple;
-		for (i = 0; i < nvec; i++)
-			arch_teardown_msi_irq(entry->irq + i);
-	}
+	list_for_each_entry(entry, &dev->msi_list, list)
+		if (entry->irq)
+			for (i = 0; i < entry->nvec_used; i++)
+				arch_teardown_msi_irq(entry->irq + i);
 }
 
 void __weak arch_teardown_msi_irqs(struct pci_dev *dev)
@@ -335,19 +329,12 @@ static void free_msi_irqs(struct pci_dev
 	struct msi_desc *entry, *tmp;
 	struct attribute **msi_attrs;
 	struct device_attribute *dev_attr;
-	int count = 0;
+	int i, count = 0;
 
-	list_for_each_entry(entry, &dev->msi_list, list) {
-		int i, nvec;
-		if (!entry->irq)
-			continue;
-		if (entry->nvec_used)
-			nvec = entry->nvec_used;
-		else
-			nvec = 1 << entry->msi_attrib.multiple;
-		for (i = 0; i < nvec; i++)
-			BUG_ON(irq_has_action(entry->irq + i));
-	}
+	list_for_each_entry(entry, &dev->msi_list, list)
+		if (entry->irq)
+			for (i = 0; i < entry->nvec_used; i++)
+				BUG_ON(irq_has_action(entry->irq + i));
 
 	arch_teardown_msi_irqs(dev);
 
@@ -538,7 +525,7 @@ error_attrs:
 	return ret;
 }
 
-static struct msi_desc *msi_setup_entry(struct pci_dev *dev)
+static struct msi_desc *msi_setup_entry(struct pci_dev *dev, int nvec)
 {
 	u16 control;
 	struct msi_desc *entry;
@@ -556,6 +543,8 @@ static struct msi_desc *msi_setup_entry(
 	entry->msi_attrib.maskbit	= !!(control & PCI_MSI_FLAGS_MASKBIT);
 	entry->msi_attrib.default_irq	= dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.multi_cap	= (control & PCI_MSI_FLAGS_QMASK) >> 1;
+	entry->msi_attrib.multiple	= ilog2(__roundup_pow_of_two(nvec));
+	entry->nvec_used		= nvec;
 
 	if (control & PCI_MSI_FLAGS_64BIT)
 		entry->mask_pos = dev->msi_cap + PCI_MSI_MASK_64;
@@ -588,7 +577,7 @@ static int msi_capability_init(struct pc
 
 	msi_set_enable(dev, 0);	/* Disable MSI during set up */
 
-	entry = msi_setup_entry(dev);
+	entry = msi_setup_entry(dev, nvec);
 	if (!entry)
 		return -ENOMEM;
 
@@ -659,6 +648,7 @@ static int msix_setup_entries(struct pci
 		entry->msi_attrib.entry_nr	= entries[i].entry;
 		entry->msi_attrib.default_irq	= dev->irq;
 		entry->mask_base		= base;
+		entry->nvec_used		= 1;
 
 		list_add_tail(&entry->list, &dev->msi_list);
 	}


