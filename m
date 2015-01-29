Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430AbbA2JWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:22:35 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37573 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761225AbbA2JW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:28 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/24] powerpc/spapr: vfio: Switch from iommu_table to new powerpc_iommu
Date: Thu, 29 Jan 2015 20:21:49 +1100
Message-Id: <1422523325-1389-9-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0013-0000-0000-000000BF16BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modern IBM POWERPC systems support multiple (currently two) TCE tables
per IOMMU group (a.k.a. PE). This adds a powerpc_iommu container
for TCE tables. Right now just one table is supported.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h            |  18 ++--
 arch/powerpc/kernel/eeh.c                   |   2 +-
 arch/powerpc/kernel/iommu.c                 |  34 ++++----
 arch/powerpc/platforms/powernv/pci-ioda.c   |  37 +++++---
 arch/powerpc/platforms/powernv/pci-p5ioc2.c |  16 ++--
 arch/powerpc/platforms/powernv/pci.c        |   2 +-
 arch/powerpc/platforms/powernv/pci.h        |   4 +-
 arch/powerpc/platforms/pseries/iommu.c      |   9 +-
 drivers/vfio/vfio_iommu_spapr_tce.c         | 131 ++++++++++++++++++++--------
 9 files changed, 170 insertions(+), 83 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 335e3d4..4fe5555 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -90,9 +90,7 @@ struct iommu_table {
 	struct iommu_pool pools[IOMMU_NR_POOLS];
 	unsigned long *it_map;       /* A simple allocation bitmap for now */
 	unsigned long  it_page_shift;/* table iommu page size */
-#ifdef CONFIG_IOMMU_API
-	struct iommu_group *it_group;
-#endif
+	struct powerpc_iommu *it_iommu;
 	struct iommu_table_ops *it_ops;
 	void (*set_bypass)(struct iommu_table *tbl, bool enable);
 };
@@ -126,13 +124,23 @@ extern void iommu_free_table(struct iommu_table *tbl, const char *node_name);
  */
 extern struct iommu_table *iommu_init_table(struct iommu_table * tbl,
 					    int nid);
+
+#define POWERPC_IOMMU_MAX_TABLES	1
+
+struct powerpc_iommu {
 #ifdef CONFIG_IOMMU_API
-extern void iommu_register_group(struct iommu_table *tbl,
+	struct iommu_group *group;
+#endif
+	struct iommu_table tables[POWERPC_IOMMU_MAX_TABLES];
+};
+
+#ifdef CONFIG_IOMMU_API
+extern void iommu_register_group(struct powerpc_iommu *iommu,
 				 int pci_domain_number, unsigned long pe_num);
 extern int iommu_add_device(struct device *dev);
 extern void iommu_del_device(struct device *dev);
 #else
-static inline void iommu_register_group(struct iommu_table *tbl,
+static inline void iommu_register_group(struct powerpc_iommu *iommu,
 					int pci_domain_number,
 					unsigned long pe_num)
 {
diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index e1b6d8e..319eae3 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1360,7 +1360,7 @@ static int dev_has_iommu_table(struct device *dev, void *data)
 		return 0;
 
 	tbl = get_iommu_table_base(dev);
-	if (tbl && tbl->it_group) {
+	if (tbl && tbl->it_iommu) {
 		*ppdev = pdev;
 		return 1;
 	}
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 2f7e92b..952939f 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -712,17 +712,20 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 
 struct iommu_table *iommu_table_alloc(int node)
 {
-	struct iommu_table *tbl;
+	struct powerpc_iommu *iommu;
 
-	tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL, node);
+	iommu = kzalloc_node(sizeof(struct powerpc_iommu), GFP_KERNEL,
+			   node);
+	iommu->tables[0].it_iommu = iommu;
 
-	return tbl;
+	return &iommu->tables[0];
 }
 
 void iommu_free_table(struct iommu_table *tbl, const char *node_name)
 {
 	unsigned long bitmap_sz;
 	unsigned int order;
+	struct powerpc_iommu *iommu = tbl->it_iommu;
 
 	if (!tbl || !tbl->it_map) {
 		printk(KERN_ERR "%s: expected TCE map for %s\n", __func__,
@@ -738,9 +741,9 @@ void iommu_free_table(struct iommu_table *tbl, const char *node_name)
 		clear_bit(0, tbl->it_map);
 
 #ifdef CONFIG_IOMMU_API
-	if (tbl->it_group) {
-		iommu_group_put(tbl->it_group);
-		BUG_ON(tbl->it_group);
+	if (iommu->group) {
+		iommu_group_put(iommu->group);
+		BUG_ON(iommu->group);
 	}
 #endif
 
@@ -756,7 +759,7 @@ void iommu_free_table(struct iommu_table *tbl, const char *node_name)
 	free_pages((unsigned long) tbl->it_map, order);
 
 	/* free table */
-	kfree(tbl);
+	kfree(iommu);
 }
 
 /* Creates TCEs for a user provided buffer.  The user buffer must be
@@ -888,11 +891,12 @@ void iommu_free_coherent(struct iommu_table *tbl, size_t size,
  */
 static void group_release(void *iommu_data)
 {
-	struct iommu_table *tbl = iommu_data;
-	tbl->it_group = NULL;
+	struct powerpc_iommu *iommu = iommu_data;
+
+	iommu->group = NULL;
 }
 
-void iommu_register_group(struct iommu_table *tbl,
+void iommu_register_group(struct powerpc_iommu *iommu,
 		int pci_domain_number, unsigned long pe_num)
 {
 	struct iommu_group *grp;
@@ -904,8 +908,8 @@ void iommu_register_group(struct iommu_table *tbl,
 				PTR_ERR(grp));
 		return;
 	}
-	tbl->it_group = grp;
-	iommu_group_set_iommudata(grp, tbl, group_release);
+	iommu->group = grp;
+	iommu_group_set_iommudata(grp, iommu, group_release);
 	name = kasprintf(GFP_KERNEL, "domain%d-pe%lx",
 			pci_domain_number, pe_num);
 	if (!name)
@@ -1080,7 +1084,7 @@ int iommu_add_device(struct device *dev)
 	}
 
 	tbl = get_iommu_table_base(dev);
-	if (!tbl || !tbl->it_group) {
+	if (!tbl || !tbl->it_iommu || !tbl->it_iommu->group) {
 		pr_debug("%s: Skipping device %s with no tbl\n",
 			 __func__, dev_name(dev));
 		return 0;
@@ -1088,7 +1092,7 @@ int iommu_add_device(struct device *dev)
 
 	pr_debug("%s: Adding %s to iommu group %d\n",
 		 __func__, dev_name(dev),
-		 iommu_group_id(tbl->it_group));
+		 iommu_group_id(tbl->it_iommu->group));
 
 	if (PAGE_SIZE < IOMMU_PAGE_SIZE(tbl)) {
 		pr_err("%s: Invalid IOMMU page size %lx (%lx) on %s\n",
@@ -1097,7 +1101,7 @@ int iommu_add_device(struct device *dev)
 		return -EINVAL;
 	}
 
-	return iommu_group_add_device(tbl->it_group, dev);
+	return iommu_group_add_device(tbl->it_iommu->group, dev);
 }
 EXPORT_SYMBOL_GPL(iommu_add_device);
 
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index af7a689..8ab00e3 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/msi.h>
 #include <linux/memblock.h>
+#include <linux/iommu.h>
 
 #include <asm/sections.h>
 #include <asm/io.h>
@@ -966,7 +967,7 @@ static void pnv_pci_ioda_dma_dev_setup(struct pnv_phb *phb, struct pci_dev *pdev
 
 	pe = &phb->ioda.pe_array[pdn->pe_number];
 	WARN_ON(get_dma_ops(&pdev->dev) != &dma_iommu_ops);
-	set_iommu_table_base_and_group(&pdev->dev, &pe->tce32_table);
+	set_iommu_table_base_and_group(&pdev->dev, &pe->iommu.tables[0]);
 }
 
 static int pnv_pci_ioda_dma_set_mask(struct pnv_phb *phb,
@@ -993,7 +994,7 @@ static int pnv_pci_ioda_dma_set_mask(struct pnv_phb *phb,
 	} else {
 		dev_info(&pdev->dev, "Using 32-bit DMA via iommu\n");
 		set_dma_ops(&pdev->dev, &dma_iommu_ops);
-		set_iommu_table_base(&pdev->dev, &pe->tce32_table);
+		set_iommu_table_base(&pdev->dev, &pe->iommu.tables[0]);
 	}
 	*pdev->dev.dma_mask = dma_mask;
 	return 0;
@@ -1030,9 +1031,9 @@ static void pnv_ioda_setup_bus_dma(struct pnv_ioda_pe *pe,
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		if (add_to_iommu_group)
 			set_iommu_table_base_and_group(&dev->dev,
-						       &pe->tce32_table);
+						       &pe->iommu.tables[0]);
 		else
-			set_iommu_table_base(&dev->dev, &pe->tce32_table);
+			set_iommu_table_base(&dev->dev, &pe->iommu.tables[0]);
 
 		if (dev->subordinate)
 			pnv_ioda_setup_bus_dma(pe, dev->subordinate,
@@ -1122,8 +1123,8 @@ static void pnv_pci_ioda2_tce_invalidate(struct pnv_ioda_pe *pe,
 void pnv_pci_ioda_tce_invalidate(struct iommu_table *tbl,
 				 __be64 *startp, __be64 *endp, bool rm)
 {
-	struct pnv_ioda_pe *pe = container_of(tbl, struct pnv_ioda_pe,
-					      tce32_table);
+	struct pnv_ioda_pe *pe = container_of(tbl->it_iommu, struct pnv_ioda_pe,
+					      iommu);
 	struct pnv_phb *phb = pe->phb;
 
 	if (phb->type == PNV_PHB_IODA1)
@@ -1188,8 +1189,11 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 		}
 	}
 
+	/* Setup iommu */
+	pe->iommu.tables[0].it_iommu = &pe->iommu;
+
 	/* Setup linux iommu table */
-	tbl = &pe->tce32_table;
+	tbl = &pe->iommu.tables[0];
 	pnv_pci_setup_iommu_table(tbl, addr, TCE32_TABLE_SIZE * segs,
 				  base << 28, IOMMU_PAGE_SHIFT_4K);
 
@@ -1210,7 +1214,8 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 	}
 	tbl->it_ops = &pnv_iommu_ops;
 	iommu_init_table(tbl, phb->hose->node);
-	iommu_register_group(tbl, phb->hose->global_number, pe->pe_number);
+	iommu_register_group(&pe->iommu, phb->hose->global_number,
+			pe->pe_number);
 
 	if (pe->pdev)
 		set_iommu_table_base_and_group(&pe->pdev->dev, tbl);
@@ -1228,8 +1233,8 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 
 static void pnv_pci_ioda2_set_bypass(struct iommu_table *tbl, bool enable)
 {
-	struct pnv_ioda_pe *pe = container_of(tbl, struct pnv_ioda_pe,
-					      tce32_table);
+	struct pnv_ioda_pe *pe = container_of(tbl->it_iommu, struct pnv_ioda_pe,
+					      iommu);
 	uint16_t window_id = (pe->pe_number << 1 ) + 1;
 	int64_t rc;
 
@@ -1274,10 +1279,10 @@ static void pnv_pci_ioda2_setup_bypass_pe(struct pnv_phb *phb,
 	pe->tce_bypass_base = 1ull << 59;
 
 	/* Install set_bypass callback for VFIO */
-	pe->tce32_table.set_bypass = pnv_pci_ioda2_set_bypass;
+	pe->iommu.tables[0].set_bypass = pnv_pci_ioda2_set_bypass;
 
 	/* Enable bypass by default */
-	pnv_pci_ioda2_set_bypass(&pe->tce32_table, true);
+	pnv_pci_ioda2_set_bypass(&pe->iommu.tables[0], true);
 }
 
 static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
@@ -1324,8 +1329,11 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 		goto fail;
 	}
 
+	/* Setup iommu */
+	pe->iommu.tables[0].it_iommu = &pe->iommu;
+
 	/* Setup linux iommu table */
-	tbl = &pe->tce32_table;
+	tbl = &pe->iommu.tables[0];
 	pnv_pci_setup_iommu_table(tbl, addr, tce_table_size, 0,
 			IOMMU_PAGE_SHIFT_4K);
 
@@ -1344,7 +1352,8 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 	}
 	tbl->it_ops = &pnv_iommu_ops;
 	iommu_init_table(tbl, phb->hose->node);
-	iommu_register_group(tbl, phb->hose->global_number, pe->pe_number);
+	iommu_register_group(&pe->iommu, phb->hose->global_number,
+			pe->pe_number);
 
 	if (pe->pdev)
 		set_iommu_table_base_and_group(&pe->pdev->dev, tbl);
diff --git a/arch/powerpc/platforms/powernv/pci-p5ioc2.c b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
index 0256fcc..e8af682 100644
--- a/arch/powerpc/platforms/powernv/pci-p5ioc2.c
+++ b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
@@ -86,14 +86,15 @@ static void pnv_pci_init_p5ioc2_msis(struct pnv_phb *phb) { }
 static void pnv_pci_p5ioc2_dma_dev_setup(struct pnv_phb *phb,
 					 struct pci_dev *pdev)
 {
-	if (phb->p5ioc2.iommu_table.it_map == NULL) {
-		phb->p5ioc2.iommu_table.it_ops = &pnv_iommu_ops;
-		iommu_init_table(&phb->p5ioc2.iommu_table, phb->hose->node);
-		iommu_register_group(&phb->p5ioc2.iommu_table,
+	if (phb->p5ioc2.iommu.tables[0].it_map == NULL) {
+		phb->p5ioc2.iommu.tables[0].it_ops = &pnv_iommu_ops;
+		iommu_init_table(&phb->p5ioc2.iommu.tables[0], phb->hose->node);
+		iommu_register_group(&phb->p5ioc2.iommu,
 				pci_domain_nr(phb->hose->bus), phb->opal_id);
 	}
 
-	set_iommu_table_base_and_group(&pdev->dev, &phb->p5ioc2.iommu_table);
+	set_iommu_table_base_and_group(&pdev->dev,
+			&phb->p5ioc2.iommu.tables[0]);
 }
 
 static void __init pnv_pci_init_p5ioc2_phb(struct device_node *np, u64 hub_id,
@@ -167,9 +168,12 @@ static void __init pnv_pci_init_p5ioc2_phb(struct device_node *np, u64 hub_id,
 	/* Setup MSI support */
 	pnv_pci_init_p5ioc2_msis(phb);
 
+	/* Setup iommu */
+	phb->p5ioc2.iommu.tables[0].it_iommu = &phb->p5ioc2.iommu;
+
 	/* Setup TCEs */
 	phb->dma_dev_setup = pnv_pci_p5ioc2_dma_dev_setup;
-	pnv_pci_setup_iommu_table(&phb->p5ioc2.iommu_table,
+	pnv_pci_setup_iommu_table(&phb->p5ioc2.iommu.tables[0],
 				  tce_mem, tce_size, 0,
 				  IOMMU_PAGE_SHIFT_4K);
 }
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index bbe529b..e6f2c43 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -700,7 +700,7 @@ static struct iommu_table *pnv_pci_setup_bml_iommu(struct pci_controller *hose)
 				  be32_to_cpup(sizep), 0, IOMMU_PAGE_SHIFT_4K);
 	tbl->it_ops = &pnv_iommu_ops;
 	iommu_init_table(tbl, hose->node);
-	iommu_register_group(tbl, pci_domain_nr(hose->bus), 0);
+	iommu_register_group(tbl->it_iommu, pci_domain_nr(hose->bus), 0);
 
 	/* Deal with SW invalidated TCEs when needed (BML way) */
 	swinvp = of_get_property(hose->dn, "linux,tce-sw-invalidate-info",
diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
index f726700..19f3985 100644
--- a/arch/powerpc/platforms/powernv/pci.h
+++ b/arch/powerpc/platforms/powernv/pci.h
@@ -53,7 +53,7 @@ struct pnv_ioda_pe {
 	/* "Base" iommu table, ie, 4K TCEs, 32-bit DMA */
 	int			tce32_seg;
 	int			tce32_segcount;
-	struct iommu_table	tce32_table;
+	struct powerpc_iommu    iommu;
 	phys_addr_t		tce_inval_reg_phys;
 
 	/* 64-bit TCE bypass region */
@@ -138,7 +138,7 @@ struct pnv_phb {
 
 	union {
 		struct {
-			struct iommu_table iommu_table;
+			struct powerpc_iommu iommu;
 		} p5ioc2;
 
 		struct {
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index bc14299..f537e6e 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -622,7 +622,7 @@ static void pci_dma_bus_setup_pSeries(struct pci_bus *bus)
 	iommu_table_setparms(pci->phb, dn, tbl);
 	tbl->it_ops = &iommu_table_pseries_ops;
 	pci->iommu_table = iommu_init_table(tbl, pci->phb->node);
-	iommu_register_group(tbl, pci_domain_nr(bus), 0);
+	iommu_register_group(tbl->it_iommu, pci_domain_nr(bus), 0);
 
 	/* Divide the rest (1.75GB) among the children */
 	pci->phb->dma_window_size = 0x80000000ul;
@@ -672,7 +672,7 @@ static void pci_dma_bus_setup_pSeriesLP(struct pci_bus *bus)
 		iommu_table_setparms_lpar(ppci->phb, pdn, tbl, dma_window);
 		tbl->it_ops = &iommu_table_lpar_multi_ops;
 		ppci->iommu_table = iommu_init_table(tbl, ppci->phb->node);
-		iommu_register_group(tbl, pci_domain_nr(bus), 0);
+		iommu_register_group(tbl->it_iommu, pci_domain_nr(bus), 0);
 		pr_debug("  created table: %p\n", ppci->iommu_table);
 	}
 }
@@ -699,7 +699,7 @@ static void pci_dma_dev_setup_pSeries(struct pci_dev *dev)
 		iommu_table_setparms(phb, dn, tbl);
 		tbl->it_ops = &iommu_table_pseries_ops;
 		PCI_DN(dn)->iommu_table = iommu_init_table(tbl, phb->node);
-		iommu_register_group(tbl, pci_domain_nr(phb->bus), 0);
+		iommu_register_group(tbl->it_iommu, pci_domain_nr(phb->bus), 0);
 		set_iommu_table_base_and_group(&dev->dev,
 					       PCI_DN(dn)->iommu_table);
 		return;
@@ -1121,7 +1121,8 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 		iommu_table_setparms_lpar(pci->phb, pdn, tbl, dma_window);
 		tbl->it_ops = &iommu_table_lpar_multi_ops;
 		pci->iommu_table = iommu_init_table(tbl, pci->phb->node);
-		iommu_register_group(tbl, pci_domain_nr(pci->phb->bus), 0);
+		iommu_register_group(tbl->it_iommu,
+				pci_domain_nr(pci->phb->bus), 0);
 		pr_debug("  created table: %p\n", pci->iommu_table);
 	} else {
 		pr_debug("  found DMA window, table: %p\n", pci->iommu_table);
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 29d5708..28909e1 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -84,7 +84,7 @@ static void decrement_locked_vm(long npages)
  */
 struct tce_container {
 	struct mutex lock;
-	struct iommu_table *tbl;
+	struct iommu_group *grp;
 	bool enabled;
 };
 
@@ -104,16 +104,40 @@ static bool tce_check_page_size(struct page *page, unsigned page_shift)
 	return false;
 }
 
+static struct iommu_table *spapr_tce_find_table(
+		struct tce_container *container,
+		phys_addr_t ioba)
+{
+	long i;
+	struct iommu_table *ret = NULL;
+	struct powerpc_iommu *iommu = iommu_group_get_iommudata(container->grp);
+
+	mutex_lock(&container->lock);
+	for (i = 0; i < POWERPC_IOMMU_MAX_TABLES; ++i) {
+		struct iommu_table *tbl = &iommu->tables[i];
+		unsigned long entry = ioba >> tbl->it_page_shift;
+		unsigned long start = tbl->it_offset;
+		unsigned long end = start + tbl->it_size;
+
+		if ((start <= entry) && (entry < end)) {
+			ret = tbl;
+			break;
+		}
+	}
+	mutex_unlock(&container->lock);
+
+	return ret;
+}
+
 static int tce_iommu_enable(struct tce_container *container)
 {
 	int ret = 0;
+	struct powerpc_iommu *iommu;
+	struct iommu_table *tbl;
 
-	if (!container->tbl)
+	if (!container->grp)
 		return -ENXIO;
 
-	if (!current->mm)
-		return -ESRCH; /* process exited */
-
 	if (container->enabled)
 		return -EBUSY;
 
@@ -142,7 +166,12 @@ static int tce_iommu_enable(struct tce_container *container)
 	 * as this information is only available from KVM and VFIO is
 	 * KVM agnostic.
 	 */
-	ret = try_increment_locked_vm(IOMMU_TABLE_PAGES(container->tbl));
+	iommu = iommu_group_get_iommudata(container->grp);
+	if (!iommu)
+		return -EFAULT;
+
+	tbl = &iommu->tables[0];
+	ret = try_increment_locked_vm(IOMMU_TABLE_PAGES(tbl));
 	if (ret)
 		return ret;
 
@@ -153,15 +182,23 @@ static int tce_iommu_enable(struct tce_container *container)
 
 static void tce_iommu_disable(struct tce_container *container)
 {
+	struct powerpc_iommu *iommu;
+	struct iommu_table *tbl;
+
 	if (!container->enabled)
 		return;
 
 	container->enabled = false;
 
-	if (!container->tbl || !current->mm)
+	if (!container->grp || !current->mm)
 		return;
 
-	decrement_locked_vm(IOMMU_TABLE_PAGES(container->tbl));
+	iommu = iommu_group_get_iommudata(container->grp);
+	if (!iommu)
+		return;
+
+	tbl = &iommu->tables[0];
+	decrement_locked_vm(IOMMU_TABLE_PAGES(tbl));
 }
 
 static void *tce_iommu_open(unsigned long arg)
@@ -186,11 +223,11 @@ static void tce_iommu_release(void *iommu_data)
 {
 	struct tce_container *container = iommu_data;
 
-	WARN_ON(container->tbl && !container->tbl->it_group);
+	WARN_ON(container->grp);
 	tce_iommu_disable(container);
 
-	if (container->tbl && container->tbl->it_group)
-		tce_iommu_detach_group(iommu_data, container->tbl->it_group);
+	if (container->grp)
+		tce_iommu_detach_group(iommu_data, container->grp);
 
 	mutex_destroy(&container->lock);
 
@@ -297,9 +334,16 @@ static long tce_iommu_ioctl(void *iommu_data,
 
 	case VFIO_IOMMU_SPAPR_TCE_GET_INFO: {
 		struct vfio_iommu_spapr_tce_info info;
-		struct iommu_table *tbl = container->tbl;
+		struct iommu_table *tbl;
+		struct powerpc_iommu *iommu;
 
-		if (WARN_ON(!tbl))
+		if (WARN_ON(!container->grp))
+			return -ENXIO;
+
+		iommu = iommu_group_get_iommudata(container->grp);
+
+		tbl = &iommu->tables[0];
+		if (WARN_ON_ONCE(!tbl))
 			return -ENXIO;
 
 		minsz = offsetofend(struct vfio_iommu_spapr_tce_info,
@@ -322,14 +366,13 @@ static long tce_iommu_ioctl(void *iommu_data,
 	}
 	case VFIO_IOMMU_MAP_DMA: {
 		struct vfio_iommu_type1_dma_map param;
-		struct iommu_table *tbl = container->tbl;
+		struct iommu_table *tbl;
 		unsigned long tce;
 
-		if (!tbl)
+		if (WARN_ON(!container->grp ||
+				!iommu_group_get_iommudata(container->grp)))
 			return -ENXIO;
 
-		BUG_ON(!tbl->it_group);
-
 		minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
 		if (copy_from_user(&param, (void __user *)arg, minsz))
@@ -342,6 +385,10 @@ static long tce_iommu_ioctl(void *iommu_data,
 				VFIO_DMA_MAP_FLAG_WRITE))
 			return -EINVAL;
 
+		tbl = spapr_tce_find_table(container, param.iova);
+		if (!tbl)
+			return -ENXIO;
+
 		if ((param.size & ~IOMMU_PAGE_MASK(tbl)) ||
 				(param.vaddr & ~IOMMU_PAGE_MASK(tbl)))
 			return -EINVAL;
@@ -367,9 +414,10 @@ static long tce_iommu_ioctl(void *iommu_data,
 	}
 	case VFIO_IOMMU_UNMAP_DMA: {
 		struct vfio_iommu_type1_dma_unmap param;
-		struct iommu_table *tbl = container->tbl;
+		struct iommu_table *tbl;
 
-		if (WARN_ON(!tbl))
+		if (WARN_ON(!container->grp ||
+				!iommu_group_get_iommudata(container->grp)))
 			return -ENXIO;
 
 		minsz = offsetofend(struct vfio_iommu_type1_dma_unmap,
@@ -385,6 +433,10 @@ static long tce_iommu_ioctl(void *iommu_data,
 		if (param.flags)
 			return -EINVAL;
 
+		tbl = spapr_tce_find_table(container, param.iova);
+		if (!tbl)
+			return -ENXIO;
+
 		if (param.size & ~IOMMU_PAGE_MASK(tbl))
 			return -EINVAL;
 
@@ -413,10 +465,10 @@ static long tce_iommu_ioctl(void *iommu_data,
 		mutex_unlock(&container->lock);
 		return 0;
 	case VFIO_EEH_PE_OP:
-		if (!container->tbl || !container->tbl->it_group)
+		if (!container->grp)
 			return -ENODEV;
 
-		return vfio_spapr_iommu_eeh_ioctl(container->tbl->it_group,
+		return vfio_spapr_iommu_eeh_ioctl(container->grp,
 						  cmd, arg);
 	}
 
@@ -428,16 +480,15 @@ static int tce_iommu_attach_group(void *iommu_data,
 {
 	int ret;
 	struct tce_container *container = iommu_data;
-	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
+	struct powerpc_iommu *iommu;
 
-	BUG_ON(!tbl);
 	mutex_lock(&container->lock);
 
 	/* pr_debug("tce_vfio: Attaching group #%u to iommu %p\n",
 			iommu_group_id(iommu_group), iommu_group); */
-	if (container->tbl) {
+	if (container->grp) {
 		pr_warn("tce_vfio: Only one group per IOMMU container is allowed, existing id=%d, attaching id=%d\n",
-				iommu_group_id(container->tbl->it_group),
+				iommu_group_id(container->grp),
 				iommu_group_id(iommu_group));
 		ret = -EBUSY;
 	} else if (container->enabled) {
@@ -445,9 +496,13 @@ static int tce_iommu_attach_group(void *iommu_data,
 				iommu_group_id(iommu_group));
 		ret = -EBUSY;
 	} else {
-		ret = iommu_take_ownership(tbl);
+		iommu = iommu_group_get_iommudata(iommu_group);
+		if (WARN_ON_ONCE(!iommu))
+			return -ENXIO;
+
+		ret = iommu_take_ownership(&iommu->tables[0]);
 		if (!ret)
-			container->tbl = tbl;
+			container->grp = iommu_group;
 	}
 
 	mutex_unlock(&container->lock);
@@ -459,26 +514,32 @@ static void tce_iommu_detach_group(void *iommu_data,
 		struct iommu_group *iommu_group)
 {
 	struct tce_container *container = iommu_data;
-	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
+	struct powerpc_iommu *iommu;
 
-	BUG_ON(!tbl);
 	mutex_lock(&container->lock);
-	if (tbl != container->tbl) {
+	if (iommu_group != container->grp) {
 		pr_warn("tce_vfio: detaching group #%u, expected group is #%u\n",
 				iommu_group_id(iommu_group),
-				iommu_group_id(tbl->it_group));
+				iommu_group_id(container->grp));
 	} else {
 		if (container->enabled) {
 			pr_warn("tce_vfio: detaching group #%u from enabled container, forcing disable\n",
-					iommu_group_id(tbl->it_group));
+					iommu_group_id(container->grp));
 			tce_iommu_disable(container);
 		}
 
 		/* pr_debug("tce_vfio: detaching group #%u from iommu %p\n",
 				iommu_group_id(iommu_group), iommu_group); */
-		container->tbl = NULL;
-		tce_iommu_clear(container, tbl, tbl->it_offset, tbl->it_size);
-		iommu_release_ownership(tbl);
+		container->grp = NULL;
+
+		iommu = iommu_group_get_iommudata(iommu_group);
+		BUG_ON(!iommu);
+
+		tce_iommu_clear(container, &iommu->tables[0],
+				iommu->tables[0].it_offset,
+				iommu->tables[0].it_size);
+
+		iommu_release_ownership(&iommu->tables[0]);
 	}
 	mutex_unlock(&container->lock);
 }
-- 
2.0.0

