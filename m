Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3HNJYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:24:52 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:49993 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3HNJYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:24:50 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: PPC: POWERNV: move iommu_add_device earlier
Date: Wed, 14 Aug 2013 19:24:41 +1000
Message-Id: <1376472281-12663-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of IOMMU on sPAPR does not use iommu_ops
and therefore does not call IOMMU API's bus_set_iommu() which
1) sets iommu_ops for a bus
2) registers a bus notifier
Instead, PCI devices are added to IOMMU groups from
subsys_initcall_sync(tce_iommu_init) which does basically the same
thing without using iommu_ops callbacks.

However Freescale PAMU driver (https://lkml.org/lkml/2013/7/1/158)
implements iommu_ops and when tce_iommu_init is called, every PCI device
is already added to some group so there is a conflict.

This patch does 2 things:
1. removes the loop in which PCI devices were added to groups and
adds explicit iommu_add_device() calls to add devices as soon as they get
the iommu_table pointer assigned to them.
2. moves a bus notifier to powernv code in order to avoid conflict with
the notifier from Freescale driver.

iommu_add_device() and iommu_del_device() are public now.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h            |  2 ++
 arch/powerpc/kernel/iommu.c                 | 41 +++--------------------------
 arch/powerpc/platforms/powernv/pci-ioda.c   | 12 ++++++---
 arch/powerpc/platforms/powernv/pci-p5ioc2.c |  1 +
 arch/powerpc/platforms/powernv/pci.c        | 31 ++++++++++++++++++++++
 arch/powerpc/platforms/pseries/iommu.c      |  7 +++--
 6 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index c34656a..ba74329 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -103,6 +103,8 @@ extern struct iommu_table *iommu_init_table(struct iommu_table * tbl,
 					    int nid);
 extern void iommu_register_group(struct iommu_table *tbl,
 				 int pci_domain_number, unsigned long pe_num);
+extern int iommu_add_device(struct device *dev);
+extern void iommu_del_device(struct device *dev);
 
 extern int iommu_map_sg(struct device *dev, struct iommu_table *tbl,
 			struct scatterlist *sglist, int nelems,
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index b20ff17..15f8ca8 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1105,7 +1105,7 @@ void iommu_release_ownership(struct iommu_table *tbl)
 }
 EXPORT_SYMBOL_GPL(iommu_release_ownership);
 
-static int iommu_add_device(struct device *dev)
+int iommu_add_device(struct device *dev)
 {
 	struct iommu_table *tbl;
 	int ret = 0;
@@ -1134,46 +1134,13 @@ static int iommu_add_device(struct device *dev)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(iommu_add_device);
 
-static void iommu_del_device(struct device *dev)
+void iommu_del_device(struct device *dev)
 {
 	iommu_group_remove_device(dev);
 }
-
-static int iommu_bus_notifier(struct notifier_block *nb,
-			      unsigned long action, void *data)
-{
-	struct device *dev = data;
-
-	switch (action) {
-	case BUS_NOTIFY_ADD_DEVICE:
-		return iommu_add_device(dev);
-	case BUS_NOTIFY_DEL_DEVICE:
-		iommu_del_device(dev);
-		return 0;
-	default:
-		return 0;
-	}
-}
-
-static struct notifier_block tce_iommu_bus_nb = {
-	.notifier_call = iommu_bus_notifier,
-};
-
-static int __init tce_iommu_init(void)
-{
-	struct pci_dev *pdev = NULL;
-
-	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
-
-	for_each_pci_dev(pdev)
-		iommu_add_device(&pdev->dev);
-
-	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);
-	return 0;
-}
-
-subsys_initcall_sync(tce_iommu_init);
+EXPORT_SYMBOL_GPL(iommu_del_device);
 
 #else
 
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index d8140b1..a9f8fef 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -441,6 +441,7 @@ static void pnv_pci_ioda_dma_dev_setup(struct pnv_phb *phb, struct pci_dev *pdev
 
 	pe = &phb->ioda.pe_array[pdn->pe_number];
 	set_iommu_table_base(&pdev->dev, &pe->tce32_table);
+	iommu_add_device(&pdev->dev);
 }
 
 static void pnv_ioda_setup_bus_dma(struct pnv_ioda_pe *pe, struct pci_bus *bus)
@@ -449,6 +450,7 @@ static void pnv_ioda_setup_bus_dma(struct pnv_ioda_pe *pe, struct pci_bus *bus)
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		set_iommu_table_base(&dev->dev, &pe->tce32_table);
+		iommu_add_device(&dev->dev);
 		if (dev->subordinate)
 			pnv_ioda_setup_bus_dma(pe, dev->subordinate);
 	}
@@ -610,9 +612,10 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 	iommu_init_table(tbl, phb->hose->node);
 	iommu_register_group(tbl, pci_domain_nr(pe->pbus), pe->pe_number);
 
-	if (pe->pdev)
+	if (pe->pdev) {
 		set_iommu_table_base(&pe->pdev->dev, tbl);
-	else
+		iommu_add_device(&pe->pdev->dev);
+	} else
 		pnv_ioda_setup_bus_dma(pe, pe->pbus);
 
 	return;
@@ -686,9 +689,10 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 	}
 	iommu_init_table(tbl, phb->hose->node);
 
-	if (pe->pdev)
+	if (pe->pdev) {
 		set_iommu_table_base(&pe->pdev->dev, tbl);
-	else
+		iommu_add_device(&pe->pdev->dev);
+	} else
 		pnv_ioda_setup_bus_dma(pe, pe->pbus);
 
 	return;
diff --git a/arch/powerpc/platforms/powernv/pci-p5ioc2.c b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
index b68db63..8d1b501 100644
--- a/arch/powerpc/platforms/powernv/pci-p5ioc2.c
+++ b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
@@ -93,6 +93,7 @@ static void pnv_pci_p5ioc2_dma_dev_setup(struct pnv_phb *phb,
 	}
 
 	set_iommu_table_base(&pdev->dev, &phb->p5ioc2.iommu_table);
+	iommu_add_device(&pdev->dev);
 }
 
 static void __init pnv_pci_init_p5ioc2_phb(struct device_node *np, u64 hub_id,
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index a28d3b5..55447e6 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -505,6 +505,7 @@ static void pnv_pci_dma_fallback_setup(struct pci_controller *hose,
 	if (!pdn->iommu_table)
 		return;
 	set_iommu_table_base(&pdev->dev, pdn->iommu_table);
+	iommu_add_device(&pdev->dev);
 }
 
 static void pnv_pci_dma_dev_setup(struct pci_dev *pdev)
@@ -623,3 +624,33 @@ void __init pnv_pci_init(void)
 	ppc_md.teardown_msi_irqs = pnv_teardown_msi_irqs;
 #endif
 }
+
+static int tce_iommu_bus_notifier(struct notifier_block *nb,
+		unsigned long action, void *data)
+{
+	struct device *dev = data;
+
+	switch (action) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		return iommu_add_device(dev);
+	case BUS_NOTIFY_DEL_DEVICE:
+		iommu_del_device(dev);
+		return 0;
+	default:
+		return 0;
+	}
+}
+
+static struct notifier_block tce_iommu_bus_nb = {
+	.notifier_call = tce_iommu_bus_notifier,
+};
+
+static int __init tce_iommu_bus_notifier_init(void)
+{
+	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
+
+	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);
+	return 0;
+}
+
+subsys_initcall_sync(tce_iommu_bus_notifier_init);
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 23fc1dc..9c6dc29 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -688,6 +688,7 @@ static void pci_dma_dev_setup_pSeries(struct pci_dev *dev)
 		PCI_DN(dn)->iommu_table = iommu_init_table(tbl, phb->node);
 		iommu_register_group(tbl, pci_domain_nr(phb->bus), 0);
 		set_iommu_table_base(&dev->dev, PCI_DN(dn)->iommu_table);
+		iommu_add_device(&dev->dev);
 		return;
 	}
 
@@ -698,9 +699,10 @@ static void pci_dma_dev_setup_pSeries(struct pci_dev *dev)
 	while (dn && PCI_DN(dn) && PCI_DN(dn)->iommu_table == NULL)
 		dn = dn->parent;
 
-	if (dn && PCI_DN(dn))
+	if (dn && PCI_DN(dn)) {
 		set_iommu_table_base(&dev->dev, PCI_DN(dn)->iommu_table);
-	else
+		iommu_add_device(&dev->dev);
+	} else
 		printk(KERN_WARNING "iommu: Device %s has no iommu table\n",
 		       pci_name(dev));
 }
@@ -1194,6 +1196,7 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 	}
 
 	set_iommu_table_base(&dev->dev, pci->iommu_table);
+	iommu_add_device(&dev->dev);
 }
 
 static int dma_set_mask_pSeriesLP(struct device *dev, u64 dma_mask)
-- 
1.8.3.2

