Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaKDMFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:05:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:60207 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbaKDMDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:03:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="616767249"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Joerg Roedel <joro@8bytes.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [Patch Part2 v4 19/31] PCI/MSI: Simplify PCI MSI code by initializing msi_desc.nvec_used earlier
Date: Tue,  4 Nov 2014 20:01:53 +0800
Message-Id: <1415102525-9898-20-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify PCI MSI code by initializing msi_desc.nvec_used and
msi_desc.msi_attrib.mutiple when create MSI descriptors.

Also remove redundant checks in IRQ remapping drivers, PCI MSI core
already guarattees these.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/irq_remapping.c |    8 --------
 drivers/pci/msi.c             |   40 +++++++++++++++-------------------------
 2 files changed, 15 insertions(+), 33 deletions(-)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 176ff4372b7d..32fe5b1322d0 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -69,19 +69,13 @@ static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
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
@@ -109,8 +103,6 @@ error:
 	 * IRQs from tearing down again in default_teardown_msi_irqs()
 	 */
 	msidesc->irq = 0;
-	msidesc->nvec_used = 0;
-	msidesc->msi_attrib.multiple = 0;
 
 	return ret;
 }
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index fb2ccb536324..afe974600c7d 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -85,19 +85,13 @@ int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
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
@@ -353,19 +347,12 @@ static void free_msi_irqs(struct pci_dev *dev)
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
 
@@ -556,7 +543,7 @@ error_attrs:
 	return ret;
 }
 
-static struct msi_desc *msi_setup_entry(struct pci_dev *dev)
+static struct msi_desc *msi_setup_entry(struct pci_dev *dev, int nvec)
 {
 	u16 control;
 	struct msi_desc *entry;
@@ -574,6 +561,8 @@ static struct msi_desc *msi_setup_entry(struct pci_dev *dev)
 	entry->msi_attrib.maskbit	= !!(control & PCI_MSI_FLAGS_MASKBIT);
 	entry->msi_attrib.default_irq	= dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.multi_cap	= (control & PCI_MSI_FLAGS_QMASK) >> 1;
+	entry->msi_attrib.multiple	= ilog2(__roundup_pow_of_two(nvec));
+	entry->nvec_used		= nvec;
 
 	if (control & PCI_MSI_FLAGS_64BIT)
 		entry->mask_pos = dev->msi_cap + PCI_MSI_MASK_64;
@@ -606,7 +595,7 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 
 	msi_set_enable(dev, 0);	/* Disable MSI during set up */
 
-	entry = msi_setup_entry(dev);
+	entry = msi_setup_entry(dev, nvec);
 	if (!entry)
 		return -ENOMEM;
 
@@ -677,6 +666,7 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 		entry->msi_attrib.entry_nr	= entries[i].entry;
 		entry->msi_attrib.default_irq	= dev->irq;
 		entry->mask_base		= base;
+		entry->nvec_used		= 1;
 
 		list_add_tail(&entry->list, &dev->msi_list);
 	}
-- 
1.7.10.4

