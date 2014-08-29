Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaH2IEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:04:51 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:35285 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaH2H71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:59:27 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        cbe-oss-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH 02/13] powerpc/powernv: Make invalidate() a callback
Date: Fri, 29 Aug 2014 17:59:05 +1000
Message-Id: <1409299156-618-3-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
References: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082907-0017-0000-0000-00000025CB50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment pnv_pci_ioda_tce_invalidate() gets the PE pointer via
container_of(tbl). Since we are going to have to add Dynamic DMA windows
and that means having 2 IOMMU tables per PE, this is not going to work.

This implements pnv_pci_ioda(1|2)_tce_invalidate as a pnv_ioda_pe callback.

This adds a pnv_iommu_table wrapper around iommu_table and stores a pointer
to PE there. PNV's ppc_md.tce_build() call uses this to find PE and
do the invalidation. This will be used later for Dynamic DMA windows too.

This registers invalidate() callbacks for IODA1 and IODA2:
- pnv_pci_ioda1_tce_invalidate;
- pnv_pci_ioda2_tce_invalidate.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 35 ++++++++++++-------------------
 arch/powerpc/platforms/powernv/pci.c      | 31 ++++++++++++++++++++-------
 arch/powerpc/platforms/powernv/pci.h      | 13 +++++++++++-
 3 files changed, 48 insertions(+), 31 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index df241b1..136e765 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -857,7 +857,7 @@ static void pnv_pci_ioda_dma_dev_setup(struct pnv_phb *phb, struct pci_dev *pdev
 
 	pe = &phb->ioda.pe_array[pdn->pe_number];
 	WARN_ON(get_dma_ops(&pdev->dev) != &dma_iommu_ops);
-	set_iommu_table_base_and_group(&pdev->dev, &pe->tce32_table);
+	set_iommu_table_base_and_group(&pdev->dev, &pe->tce32.table);
 }
 
 static int pnv_pci_ioda_dma_set_mask(struct pnv_phb *phb,
@@ -884,7 +884,7 @@ static int pnv_pci_ioda_dma_set_mask(struct pnv_phb *phb,
 	} else {
 		dev_info(&pdev->dev, "Using 32-bit DMA via iommu\n");
 		set_dma_ops(&pdev->dev, &dma_iommu_ops);
-		set_iommu_table_base(&pdev->dev, &pe->tce32_table);
+		set_iommu_table_base(&pdev->dev, &pe->tce32.table);
 	}
 	*pdev->dev.dma_mask = dma_mask;
 	return 0;
@@ -899,9 +899,9 @@ static void pnv_ioda_setup_bus_dma(struct pnv_ioda_pe *pe,
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		if (add_to_iommu_group)
 			set_iommu_table_base_and_group(&dev->dev,
-						       &pe->tce32_table);
+						       &pe->tce32.table);
 		else
-			set_iommu_table_base(&dev->dev, &pe->tce32_table);
+			set_iommu_table_base(&dev->dev, &pe->tce32.table);
 
 		if (dev->subordinate)
 			pnv_ioda_setup_bus_dma(pe, dev->subordinate,
@@ -988,19 +988,6 @@ static void pnv_pci_ioda2_tce_invalidate(struct pnv_ioda_pe *pe,
 	}
 }
 
-void pnv_pci_ioda_tce_invalidate(struct iommu_table *tbl,
-				 __be64 *startp, __be64 *endp, bool rm)
-{
-	struct pnv_ioda_pe *pe = container_of(tbl, struct pnv_ioda_pe,
-					      tce32_table);
-	struct pnv_phb *phb = pe->phb;
-
-	if (phb->type == PNV_PHB_IODA1)
-		pnv_pci_ioda1_tce_invalidate(pe, tbl, startp, endp, rm);
-	else
-		pnv_pci_ioda2_tce_invalidate(pe, tbl, startp, endp, rm);
-}
-
 static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 				      struct pnv_ioda_pe *pe, unsigned int base,
 				      unsigned int segs)
@@ -1058,9 +1045,11 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 	}
 
 	/* Setup linux iommu table */
-	tbl = &pe->tce32_table;
+	tbl = &pe->tce32.table;
 	pnv_pci_setup_iommu_table(tbl, addr, TCE32_TABLE_SIZE * segs,
 				  base << 28, IOMMU_PAGE_SHIFT_4K);
+	pe->tce32.pe = pe;
+	pe->tce32.invalidate_fn = pnv_pci_ioda1_tce_invalidate;
 
 	/* OPAL variant of P7IOC SW invalidated TCEs */
 	swinvp = of_get_property(phb->hose->dn, "ibm,opal-tce-kill", NULL);
@@ -1097,7 +1086,7 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 static void pnv_pci_ioda2_set_bypass(struct iommu_table *tbl, bool enable)
 {
 	struct pnv_ioda_pe *pe = container_of(tbl, struct pnv_ioda_pe,
-					      tce32_table);
+					      tce32.table);
 	uint16_t window_id = (pe->pe_number << 1 ) + 1;
 	int64_t rc;
 
@@ -1142,10 +1131,10 @@ static void pnv_pci_ioda2_setup_bypass_pe(struct pnv_phb *phb,
 	pe->tce_bypass_base = 1ull << 59;
 
 	/* Install set_bypass callback for VFIO */
-	pe->tce32_table.set_bypass = pnv_pci_ioda2_set_bypass;
+	pe->tce32.table.set_bypass = pnv_pci_ioda2_set_bypass;
 
 	/* Enable bypass by default */
-	pnv_pci_ioda2_set_bypass(&pe->tce32_table, true);
+	pnv_pci_ioda2_set_bypass(&pe->tce32.table, true);
 }
 
 static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
@@ -1193,9 +1182,11 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 	}
 
 	/* Setup linux iommu table */
-	tbl = &pe->tce32_table;
+	tbl = &pe->tce32.table;
 	pnv_pci_setup_iommu_table(tbl, addr, tce_table_size, 0,
 			IOMMU_PAGE_SHIFT_4K);
+	pe->tce32.pe = pe;
+	pe->tce32.invalidate_fn = pnv_pci_ioda2_tce_invalidate;
 
 	/* OPAL variant of PHB3 invalidated TCEs */
 	swinvp = of_get_property(phb->hose->dn, "ibm,opal-tce-kill", NULL);
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index b854b57..97895d4 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -599,6 +599,27 @@ struct pci_ops pnv_pci_ops = {
 	.write = pnv_pci_write_config,
 };
 
+static void pnv_tce_invalidate(struct iommu_table *tbl, __be64 *startp,
+	__be64 *endp, bool rm)
+{
+	struct pnv_iommu_table *ptbl = container_of(tbl,
+			struct pnv_iommu_table, table);
+	struct pnv_ioda_pe *pe = ptbl->pe;
+
+	/*
+	 * Some implementations won't cache invalid TCEs and thus may not
+	 * need that flush. We'll probably turn it_type into a bit mask
+	 * of flags if that becomes the case
+	 */
+	if (!(tbl->it_type & TCE_PCI_SWINV_FREE))
+		return;
+
+	if (!pe || !ptbl->invalidate_fn)
+		return;
+
+	ptbl->invalidate_fn(pe, tbl, startp, endp, rm);
+}
+
 static int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
 			 unsigned long uaddr, enum dma_data_direction direction,
 			 struct dma_attrs *attrs, bool rm)
@@ -619,12 +640,7 @@ static int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
 		*(tcep++) = cpu_to_be64(proto_tce |
 				(rpn++ << tbl->it_page_shift));
 
-	/* Some implementations won't cache invalid TCEs and thus may not
-	 * need that flush. We'll probably turn it_type into a bit mask
-	 * of flags if that becomes the case
-	 */
-	if (tbl->it_type & TCE_PCI_SWINV_CREATE)
-		pnv_pci_ioda_tce_invalidate(tbl, tces, tcep - 1, rm);
+	pnv_tce_invalidate(tbl, tces, tcep - 1, rm);
 
 	return 0;
 }
@@ -648,8 +664,7 @@ static void pnv_tce_free(struct iommu_table *tbl, long index, long npages,
 	while (npages--)
 		*(tcep++) = cpu_to_be64(0);
 
-	if (tbl->it_type & TCE_PCI_SWINV_FREE)
-		pnv_pci_ioda_tce_invalidate(tbl, tces, tcep - 1, rm);
+	pnv_tce_invalidate(tbl, tces, tcep - 1, rm);
 }
 
 static void pnv_tce_free_vm(struct iommu_table *tbl, long index, long npages)
diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
index 48494d4..095db43 100644
--- a/arch/powerpc/platforms/powernv/pci.h
+++ b/arch/powerpc/platforms/powernv/pci.h
@@ -24,6 +24,17 @@ enum pnv_phb_model {
 #define PNV_IODA_PE_MASTER	(1 << 3)	/* Master PE in compound case	*/
 #define PNV_IODA_PE_SLAVE	(1 << 4)	/* Slave PE in compound case	*/
 
+struct pnv_ioda_pe;
+typedef void (*pnv_invalidate_fn)(struct pnv_ioda_pe *pe,
+		struct iommu_table *tbl,
+		__be64 *startp, __be64 *endp, bool rm);
+
+struct pnv_iommu_table {
+	struct iommu_table	table;
+	struct pnv_ioda_pe	*pe;
+	pnv_invalidate_fn	invalidate_fn;
+};
+
 /* Data associated with a PE, including IOMMU tracking etc.. */
 struct pnv_phb;
 struct pnv_ioda_pe {
@@ -53,7 +64,7 @@ struct pnv_ioda_pe {
 	/* "Base" iommu table, ie, 4K TCEs, 32-bit DMA */
 	int			tce32_seg;
 	int			tce32_segcount;
-	struct iommu_table	tce32_table;
+	struct pnv_iommu_table	tce32;
 	phys_addr_t		tce_inval_reg_phys;
 
 	/* 64-bit TCE bypass region */
-- 
2.0.0

