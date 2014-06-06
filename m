Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaFFIol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:44:41 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:37862 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaFFIoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:44:21 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alistair Popple <alistair@popple.id.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] powerpc/powernv: Make invalidate() callback an iommu_table callback
Date: Fri,  6 Jun 2014 18:44:06 +1000
Message-Id: <1402044246-13650-7-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
References: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060608-1396-0000-0000-000004F947C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements pnv_pci_ioda(1|2)_tce_invalidate as a callback
of iommu_table to simplify code structure.

This registers invalidate() callbacks for IODA1 and IODA2.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h            |  4 ++++
 arch/powerpc/platforms/powernv/pci-ioda.c   | 28 ++++++++----------------
 arch/powerpc/platforms/powernv/pci-p5ioc2.c |  2 +-
 arch/powerpc/platforms/powernv/pci.c        | 33 ++++++++++++++++++++---------
 arch/powerpc/platforms/powernv/pci.h        |  5 ++---
 5 files changed, 39 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 2bc8f8c..5326030 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -66,6 +66,9 @@ struct iommu_owner {
 };
 
 typedef void (*iommu_set_bypass_fn)(struct iommu_table *tbl, bool enable);
+typedef void (*iommu_invalidate_fn)(struct iommu_table *tbl,
+		__be64 *startp, __be64 *endp, bool rm);
+
 struct iommu_table {
 	unsigned long  it_busno;     /* Bus number this table belongs to */
 	unsigned long  it_size;      /* Size of iommu table in entries */
@@ -84,6 +87,7 @@ struct iommu_table {
 	struct iommu_group *it_group;
 #endif
 	iommu_set_bypass_fn set_bypass;
+	iommu_invalidate_fn invalidate;
 	struct iommu_owner *it_owner;
 };
 
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 1f307ef..ca09457 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -504,10 +504,11 @@ static void pnv_ioda_setup_bus_dma(struct pnv_ioda_pe *pe, struct pci_bus *bus)
 	}
 }
 
-static void pnv_pci_ioda1_tce_invalidate(struct pnv_ioda_pe *pe,
-					 struct iommu_table *tbl,
+static void pnv_pci_ioda1_tce_invalidate(struct iommu_table *tbl,
 					 __be64 *startp, __be64 *endp, bool rm)
 {
+	struct pnv_ioda_pe *pe = container_of(tbl->it_owner, struct pnv_ioda_pe,
+					      owner);
 	__be64 __iomem *invalidate = rm ?
 		(__be64 __iomem *)pe->tce_inval_reg_phys :
 		(__be64 __iomem *)tbl->it_index;
@@ -551,10 +552,11 @@ static void pnv_pci_ioda1_tce_invalidate(struct pnv_ioda_pe *pe,
 	 */
 }
 
-static void pnv_pci_ioda2_tce_invalidate(struct pnv_ioda_pe *pe,
-					 struct iommu_table *tbl,
+static void pnv_pci_ioda2_tce_invalidate(struct iommu_table *tbl,
 					 __be64 *startp, __be64 *endp, bool rm)
 {
+	struct pnv_ioda_pe *pe = container_of(tbl->it_owner, struct pnv_ioda_pe,
+					      owner);
 	unsigned long start, end, inc;
 	__be64 __iomem *invalidate = rm ?
 		(__be64 __iomem *)pe->tce_inval_reg_phys :
@@ -583,19 +585,6 @@ static void pnv_pci_ioda2_tce_invalidate(struct pnv_ioda_pe *pe,
 	}
 }
 
-void pnv_pci_ioda_tce_invalidate(struct iommu_table *tbl,
-				 __be64 *startp, __be64 *endp, bool rm)
-{
-	struct pnv_ioda_pe *pe = container_of(tbl->it_owner, struct pnv_ioda_pe,
-					      owner);
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
@@ -656,7 +645,7 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 	tbl = &pe->tce32_table;
 	pnv_pci_setup_iommu_table(tbl, addr, TCE32_TABLE_SIZE * segs,
 				  base << 28, IOMMU_PAGE_SHIFT_4K,
-				  &pe->owner);
+				  &pe->owner, pnv_pci_ioda1_tce_invalidate);
 
 	/* OPAL variant of P7IOC SW invalidated TCEs */
 	swinvp = of_get_property(phb->hose->dn, "ibm,opal-tce-kill", NULL);
@@ -790,7 +779,8 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 	/* Setup linux iommu table */
 	tbl = &pe->tce32_table;
 	pnv_pci_setup_iommu_table(tbl, addr, tce_table_size, 0,
-			IOMMU_PAGE_SHIFT_4K, &pe->owner);
+			IOMMU_PAGE_SHIFT_4K, &pe->owner,
+			pnv_pci_ioda2_tce_invalidate);
 
 	/* OPAL variant of PHB3 invalidated TCEs */
 	swinvp = of_get_property(phb->hose->dn, "ibm,opal-tce-kill", NULL);
diff --git a/arch/powerpc/platforms/powernv/pci-p5ioc2.c b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
index cf02c14..ea80ef7 100644
--- a/arch/powerpc/platforms/powernv/pci-p5ioc2.c
+++ b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
@@ -173,7 +173,7 @@ static void __init pnv_pci_init_p5ioc2_phb(struct device_node *np, u64 hub_id,
 	phb->dma_dev_setup = pnv_pci_p5ioc2_dma_dev_setup;
 	pnv_pci_setup_iommu_table(&phb->p5ioc2.iommu_table,
 				  tce_mem, tce_size, 0,
-				  IOMMU_PAGE_SHIFT_4K, NULL);
+				  IOMMU_PAGE_SHIFT_4K, NULL, NULL);
 }
 
 void __init pnv_pci_init_p5ioc2_hub(struct device_node *np)
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index aa88c94..f2635c6 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -513,6 +513,23 @@ struct pci_ops pnv_pci_ops = {
 	.write = pnv_pci_write_config,
 };
 
+static void pnv_tce_invalidate(struct iommu_table *tbl, __be64 *startp,
+	__be64 *endp, bool rm)
+{
+	/*
+	 * Some implementations won't cache invalid TCEs and thus may not
+	 * need that flush. We'll probably turn it_type into a bit mask
+	 * of flags if that becomes the case
+	 */
+	if (!(tbl->it_type & TCE_PCI_SWINV_FREE))
+		return;
+
+	if (!tbl->it_owner || !tbl->invalidate)
+		return;
+
+	tbl->invalidate(tbl, startp, endp, rm);
+}
+
 static int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
 			 unsigned long uaddr, enum dma_data_direction direction,
 			 struct dma_attrs *attrs, bool rm)
@@ -533,12 +550,7 @@ static int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
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
@@ -562,8 +574,7 @@ static void pnv_tce_free(struct iommu_table *tbl, long index, long npages,
 	while (npages--)
 		*(tcep++) = cpu_to_be64(0);
 
-	if (tbl->it_type & TCE_PCI_SWINV_FREE)
-		pnv_pci_ioda_tce_invalidate(tbl, tces, tcep - 1, rm);
+	pnv_tce_invalidate(tbl, tces, tcep - 1, rm);
 }
 
 static void pnv_tce_free_vm(struct iommu_table *tbl, long index, long npages)
@@ -592,7 +603,8 @@ static void pnv_tce_free_rm(struct iommu_table *tbl, long index, long npages)
 void pnv_pci_setup_iommu_table(struct iommu_table *tbl,
 			       void *tce_mem, u64 tce_size,
 			       u64 dma_offset, unsigned page_shift,
-			       struct iommu_owner *owner)
+			       struct iommu_owner *owner,
+			       iommu_invalidate_fn invalidate)
 {
 	tbl->it_blocksize = 16;
 	tbl->it_base = (unsigned long)tce_mem;
@@ -603,6 +615,7 @@ void pnv_pci_setup_iommu_table(struct iommu_table *tbl,
 	tbl->it_busno = 0;
 	tbl->it_type = TCE_PCI;
 	tbl->it_owner = owner;
+	tbl->invalidate = invalidate;
 }
 
 static struct iommu_table *pnv_pci_setup_bml_iommu(struct pci_controller *hose)
@@ -623,7 +636,7 @@ static struct iommu_table *pnv_pci_setup_bml_iommu(struct pci_controller *hose)
 		return NULL;
 	pnv_pci_setup_iommu_table(tbl, __va(be64_to_cpup(basep)),
 				  be32_to_cpup(sizep), 0, IOMMU_PAGE_SHIFT_4K,
-				  NULL);
+				  NULL, NULL);
 	iommu_init_table(tbl, hose->node);
 	iommu_register_group(tbl, pci_domain_nr(hose->bus), 0);
 
diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
index d05eae3..110f8b8 100644
--- a/arch/powerpc/platforms/powernv/pci.h
+++ b/arch/powerpc/platforms/powernv/pci.h
@@ -201,11 +201,10 @@ int pnv_pci_cfg_write(struct device_node *dn,
 extern void pnv_pci_setup_iommu_table(struct iommu_table *tbl,
 				      void *tce_mem, u64 tce_size,
 				      u64 dma_offset, unsigned page_shift,
-				      struct iommu_owner *owner);
+				      struct iommu_owner *owner,
+				      iommu_invalidate_fn invalidate);
 extern void pnv_pci_init_p5ioc2_hub(struct device_node *np);
 extern void pnv_pci_init_ioda_hub(struct device_node *np);
 extern void pnv_pci_init_ioda2_phb(struct device_node *np);
-extern void pnv_pci_ioda_tce_invalidate(struct iommu_table *tbl,
-					__be64 *startp, __be64 *endp, bool rm);
 
 #endif /* __POWERNV_PCI_H */
-- 
2.0.0

