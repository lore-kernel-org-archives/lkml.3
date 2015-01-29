Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761664AbbA2J3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:29:13 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:46114 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761249AbbA2JWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:32 -0500
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
Subject: [PATCH v3 11/24] powerpc/powernv/ioda/ioda2: Rework tce_build()/tce_free()
Date: Thu, 29 Jan 2015 20:21:52 +1100
Message-Id: <1422523325-1389-12-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0025-0000-0000-000000FBD907
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pnv_pci_ioda_tce_invalidate() helper invalidates TCE cache. It is
supposed to be called on IODA1/2 and not called on p5ioc2. It receives
start and end host addresses of TCE table. This approach makes it possible
to get pnv_pci_ioda_tce_invalidate() unintentionally called on p5ioc2.
Another issue is that IODA2 needs PCI addresses to invalidate the cache
and those can be calculated from host addresses but since we are going
to implement multi-level TCE tables, calculating PCI address from
a host address might get either tricky or ugly as TCE table remains flat
on PCI bus but not in RAM.

This defines separate iommu_table_ops callbacks for p5ioc2 and IODA1/2
PHBs. They all call common pnv_tce_build/pnv_tce_free/pnv_tce_get helpers
but call PHB specific TCE invalidation helper (when needed).

This changes pnv_pci_ioda2_tce_invalidate() to receives TCE index and
number of pages which are PCI addresses shifted by IOMMU page shift.

The patch is pretty mechanical and behaviour is not expected to change.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/platforms/powernv/pci-ioda.c   | 92 ++++++++++++++++++++++-------
 arch/powerpc/platforms/powernv/pci-p5ioc2.c |  8 ++-
 arch/powerpc/platforms/powernv/pci.c        | 76 +++++++++---------------
 arch/powerpc/platforms/powernv/pci.h        |  7 ++-
 4 files changed, 110 insertions(+), 73 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index a33a116..dfc56fc 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1041,18 +1041,20 @@ static void pnv_ioda_setup_bus_dma(struct pnv_ioda_pe *pe,
 	}
 }
 
-static void pnv_pci_ioda1_tce_invalidate(struct pnv_ioda_pe *pe,
-					 struct iommu_table *tbl,
-					 __be64 *startp, __be64 *endp, bool rm)
+static void pnv_pci_ioda1_tce_invalidate(struct iommu_table *tbl,
+		unsigned long index, unsigned long npages, bool rm)
 {
+	struct pnv_ioda_pe *pe = container_of(tbl->it_iommu,
+			struct pnv_ioda_pe, iommu);
 	__be64 __iomem *invalidate = rm ?
 		(__be64 __iomem *)pe->tce_inval_reg_phys :
 		(__be64 __iomem *)tbl->it_index;
 	unsigned long start, end, inc;
 	const unsigned shift = tbl->it_page_shift;
 
-	start = __pa(startp);
-	end = __pa(endp);
+	start = __pa((__be64 *)tbl->it_base + index - tbl->it_offset);
+	end = __pa((__be64 *)tbl->it_base + index - tbl->it_offset +
+			npages - 1);
 
 	/* BML uses this case for p6/p7/galaxy2: Shift addr and put in node */
 	if (tbl->it_busno) {
@@ -1088,10 +1090,40 @@ static void pnv_pci_ioda1_tce_invalidate(struct pnv_ioda_pe *pe,
 	 */
 }
 
-static void pnv_pci_ioda2_tce_invalidate(struct pnv_ioda_pe *pe,
-					 struct iommu_table *tbl,
-					 __be64 *startp, __be64 *endp, bool rm)
+static int pnv_ioda1_tce_build_vm(struct iommu_table *tbl, long index,
+		long npages, unsigned long uaddr,
+		enum dma_data_direction direction,
+		struct dma_attrs *attrs)
 {
+	long ret = pnv_tce_build(tbl, index, npages, uaddr, direction,
+			attrs);
+
+	if (!ret && (tbl->it_type & TCE_PCI_SWINV_CREATE))
+		pnv_pci_ioda1_tce_invalidate(tbl, index, npages, false);
+
+	return ret;
+}
+
+static void pnv_ioda1_tce_free_vm(struct iommu_table *tbl, long index,
+		long npages)
+{
+	pnv_tce_free(tbl, index, npages);
+
+	if (tbl->it_type & TCE_PCI_SWINV_FREE)
+		pnv_pci_ioda1_tce_invalidate(tbl, index, npages, false);
+}
+
+struct iommu_table_ops pnv_ioda1_iommu_ops = {
+	.set = pnv_ioda1_tce_build_vm,
+	.clear = pnv_ioda1_tce_free_vm,
+	.get = pnv_tce_get,
+};
+
+static void pnv_pci_ioda2_tce_invalidate(struct iommu_table *tbl,
+		unsigned long index, unsigned long npages, bool rm)
+{
+	struct pnv_ioda_pe *pe = container_of(tbl->it_iommu,
+			struct pnv_ioda_pe, iommu);
 	unsigned long start, end, inc;
 	__be64 __iomem *invalidate = rm ?
 		(__be64 __iomem *)pe->tce_inval_reg_phys :
@@ -1104,9 +1136,9 @@ static void pnv_pci_ioda2_tce_invalidate(struct pnv_ioda_pe *pe,
 	end = start;
 
 	/* Figure out the start, end and step */
-	inc = tbl->it_offset + (((u64)startp - tbl->it_base) / sizeof(u64));
+	inc = tbl->it_offset + index / sizeof(u64);
 	start |= (inc << shift);
-	inc = tbl->it_offset + (((u64)endp - tbl->it_base) / sizeof(u64));
+	inc = tbl->it_offset + (index + npages - 1) / sizeof(u64);
 	end |= (inc << shift);
 	inc = (0x1ull << shift);
 	mb();
@@ -1120,19 +1152,35 @@ static void pnv_pci_ioda2_tce_invalidate(struct pnv_ioda_pe *pe,
 	}
 }
 
-void pnv_pci_ioda_tce_invalidate(struct iommu_table *tbl,
-				 __be64 *startp, __be64 *endp, bool rm)
+static int pnv_ioda2_tce_build_vm(struct iommu_table *tbl, long index,
+		long npages, unsigned long uaddr,
+		enum dma_data_direction direction,
+		struct dma_attrs *attrs)
 {
-	struct pnv_ioda_pe *pe = container_of(tbl->it_iommu, struct pnv_ioda_pe,
-					      iommu);
-	struct pnv_phb *phb = pe->phb;
-
-	if (phb->type == PNV_PHB_IODA1)
-		pnv_pci_ioda1_tce_invalidate(pe, tbl, startp, endp, rm);
-	else
-		pnv_pci_ioda2_tce_invalidate(pe, tbl, startp, endp, rm);
+	long ret = pnv_tce_build(tbl, index, npages, uaddr, direction,
+			attrs);
+
+	if (!ret && (tbl->it_type & TCE_PCI_SWINV_CREATE))
+		pnv_pci_ioda2_tce_invalidate(tbl, index, npages, false);
+
+	return ret;
 }
 
+static void pnv_ioda2_tce_free_vm(struct iommu_table *tbl, long index,
+		long npages)
+{
+	pnv_tce_free(tbl, index, npages);
+
+	if (tbl->it_type & TCE_PCI_SWINV_FREE)
+		pnv_pci_ioda2_tce_invalidate(tbl, index, npages, false);
+}
+
+static struct iommu_table_ops pnv_ioda2_iommu_ops = {
+	.set = pnv_ioda2_tce_build_vm,
+	.clear = pnv_ioda2_tce_free_vm,
+	.get = pnv_tce_get,
+};
+
 static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 				      struct pnv_ioda_pe *pe, unsigned int base,
 				      unsigned int segs)
@@ -1212,7 +1260,7 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 				 TCE_PCI_SWINV_FREE   |
 				 TCE_PCI_SWINV_PAIR);
 	}
-	tbl->it_ops = &pnv_iommu_ops;
+	tbl->it_ops = &pnv_ioda1_iommu_ops;
 	iommu_init_table(tbl, phb->hose->node);
 	iommu_register_group(&pe->iommu, phb->hose->global_number,
 			pe->pe_number);
@@ -1363,7 +1411,7 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 				8);
 		tbl->it_type |= (TCE_PCI_SWINV_CREATE | TCE_PCI_SWINV_FREE);
 	}
-	tbl->it_ops = &pnv_iommu_ops;
+	tbl->it_ops = &pnv_ioda2_iommu_ops;
 	iommu_init_table(tbl, phb->hose->node);
 	pe->iommu.ops = &pnv_pci_ioda2_ops;
 	iommu_register_group(&pe->iommu, phb->hose->global_number,
diff --git a/arch/powerpc/platforms/powernv/pci-p5ioc2.c b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
index e8af682..27ddaca 100644
--- a/arch/powerpc/platforms/powernv/pci-p5ioc2.c
+++ b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
@@ -83,11 +83,17 @@ static void pnv_pci_init_p5ioc2_msis(struct pnv_phb *phb)
 static void pnv_pci_init_p5ioc2_msis(struct pnv_phb *phb) { }
 #endif /* CONFIG_PCI_MSI */
 
+static struct iommu_table_ops pnv_p5ioc2_iommu_ops = {
+	.set = pnv_tce_build,
+	.clear = pnv_tce_free,
+	.get = pnv_tce_get,
+};
+
 static void pnv_pci_p5ioc2_dma_dev_setup(struct pnv_phb *phb,
 					 struct pci_dev *pdev)
 {
 	if (phb->p5ioc2.iommu.tables[0].it_map == NULL) {
-		phb->p5ioc2.iommu.tables[0].it_ops = &pnv_iommu_ops;
+		phb->p5ioc2.iommu.tables[0].it_ops = &pnv_p5ioc2_iommu_ops;
 		iommu_init_table(&phb->p5ioc2.iommu.tables[0], phb->hose->node);
 		iommu_register_group(&phb->p5ioc2.iommu,
 				pci_domain_nr(phb->hose->bus), phb->opal_id);
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index e6f2c43..3ab69e2 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -602,70 +602,48 @@ static unsigned long pnv_dmadir_to_flags(enum dma_data_direction direction)
 	}
 }
 
-static int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
-			 unsigned long uaddr, enum dma_data_direction direction,
-			 struct dma_attrs *attrs, bool rm)
+static __be64 *pnv_tce(struct iommu_table *tbl, long index)
+{
+	__be64 *tmp = ((__be64 *)tbl->it_base);
+
+	return tmp + index;
+}
+
+int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
+		unsigned long uaddr, enum dma_data_direction direction,
+		struct dma_attrs *attrs)
 {
 	u64 proto_tce = pnv_dmadir_to_flags(direction);
-	__be64 *tcep, *tces;
-	u64 rpn;
+	u64 rpn = __pa(uaddr) >> tbl->it_page_shift;
+	long i;
 
-	tces = tcep = ((__be64 *)tbl->it_base) + index - tbl->it_offset;
-	rpn = __pa(uaddr) >> tbl->it_page_shift;
+	for (i = 0; i < npages; i++) {
+		unsigned long newtce = proto_tce |
+				((rpn + i) << tbl->it_page_shift);
+		unsigned long idx = index - tbl->it_offset + i;
 
-	while (npages--)
-		*(tcep++) = cpu_to_be64(proto_tce |
-				(rpn++ << tbl->it_page_shift));
-
-	/* Some implementations won't cache invalid TCEs and thus may not
-	 * need that flush. We'll probably turn it_type into a bit mask
-	 * of flags if that becomes the case
-	 */
-	if (tbl->it_type & TCE_PCI_SWINV_CREATE)
-		pnv_pci_ioda_tce_invalidate(tbl, tces, tcep - 1, rm);
+		*(pnv_tce(tbl, idx)) = cpu_to_be64(newtce);
+	}
 
 	return 0;
 }
 
-static int pnv_tce_build_vm(struct iommu_table *tbl, long index, long npages,
-			    unsigned long uaddr,
-			    enum dma_data_direction direction,
-			    struct dma_attrs *attrs)
+void pnv_tce_free(struct iommu_table *tbl, long index, long npages)
 {
-	return pnv_tce_build(tbl, index, npages, uaddr, direction, attrs,
-			false);
-}
-
-static void pnv_tce_free(struct iommu_table *tbl, long index, long npages,
-		bool rm)
-{
-	__be64 *tcep, *tces;
-
-	tces = tcep = ((__be64 *)tbl->it_base) + index - tbl->it_offset;
+	long i;
 
-	while (npages--)
-		*(tcep++) = cpu_to_be64(0);
+	for (i = 0; i < npages; i++) {
+		unsigned long idx = index - tbl->it_offset + i;
 
-	if (tbl->it_type & TCE_PCI_SWINV_FREE)
-		pnv_pci_ioda_tce_invalidate(tbl, tces, tcep - 1, rm);
+		*(pnv_tce(tbl, idx)) = cpu_to_be64(0);
+	}
 }
 
-static void pnv_tce_free_vm(struct iommu_table *tbl, long index, long npages)
+unsigned long pnv_tce_get(struct iommu_table *tbl, long index)
 {
-	pnv_tce_free(tbl, index, npages, false);
+	return *(pnv_tce(tbl, index));
 }
 
-static unsigned long pnv_tce_get(struct iommu_table *tbl, long index)
-{
-	return ((u64 *)tbl->it_base)[index - tbl->it_offset];
-}
-
-struct iommu_table_ops pnv_iommu_ops = {
-	.set = pnv_tce_build_vm,
-	.clear = pnv_tce_free_vm,
-	.get = pnv_tce_get,
-};
-
 void pnv_pci_setup_iommu_table(struct iommu_table *tbl,
 			       void *tce_mem, u64 tce_size,
 			       u64 dma_offset, unsigned page_shift)
@@ -698,7 +676,7 @@ static struct iommu_table *pnv_pci_setup_bml_iommu(struct pci_controller *hose)
 		return NULL;
 	pnv_pci_setup_iommu_table(tbl, __va(be64_to_cpup(basep)),
 				  be32_to_cpup(sizep), 0, IOMMU_PAGE_SHIFT_4K);
-	tbl->it_ops = &pnv_iommu_ops;
+	tbl->it_ops = &pnv_ioda1_iommu_ops;
 	iommu_init_table(tbl, hose->node);
 	iommu_register_group(tbl->it_iommu, pci_domain_nr(hose->bus), 0);
 
diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
index 19f3985..724bce9 100644
--- a/arch/powerpc/platforms/powernv/pci.h
+++ b/arch/powerpc/platforms/powernv/pci.h
@@ -216,7 +216,12 @@ extern struct pci_ops pnv_pci_ops;
 #ifdef CONFIG_EEH
 extern struct pnv_eeh_ops ioda_eeh_ops;
 #endif
-extern struct iommu_table_ops pnv_iommu_ops;
+extern int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
+		unsigned long uaddr, enum dma_data_direction direction,
+		struct dma_attrs *attrs);
+extern void pnv_tce_free(struct iommu_table *tbl, long index, long npages);
+extern unsigned long pnv_tce_get(struct iommu_table *tbl, long index);
+extern struct iommu_table_ops pnv_ioda1_iommu_ops;
 
 void pnv_pci_dump_phb_diag_data(struct pci_controller *hose,
 				unsigned char *log_buff);
-- 
2.0.0

