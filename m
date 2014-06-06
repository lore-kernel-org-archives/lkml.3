Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaFFIpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:45:15 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:48344 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaFFIoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:44:20 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alistair Popple <alistair@popple.id.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] powerpc/powernv: Add @it_owner to iommu_table struct
Date: Fri,  6 Jun 2014 18:44:04 +1000
Message-Id: <1402044246-13650-5-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
References: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060608-1618-0000-0000-0000005BD06E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modern IBM POWERPC systems support multiple IOMMU tables per PHB
so we need a more reliable way (compared to container_of()) to get
a PE pointer from the iommu_table struct pointer used in IOMMU functions.

This also provides better way of getting a PE handle from iommu_table
pointer.

This defines an empty iommu_owner struct. This adds it to pnv_ioda_pe
struct and replaces container_of(tbl) with container_of(tbl->it_owner).

This adds an @owner parameter to pnv_pci_setup_iommu_table().

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h            |  6 ++++++
 arch/powerpc/platforms/powernv/pci-ioda.c   | 18 +++++++++++-------
 arch/powerpc/platforms/powernv/pci-p5ioc2.c |  2 +-
 arch/powerpc/platforms/powernv/pci.c        |  7 +++++--
 arch/powerpc/platforms/powernv/pci.h        |  4 +++-
 5 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 42632c7..f503a5c 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -60,6 +60,11 @@ struct iommu_pool {
 	spinlock_t lock;
 } ____cacheline_aligned_in_smp;
 
+/* This is to use with container_of() */
+struct iommu_owner {
+	unsigned char __unused[0];
+};
+
 struct iommu_table {
 	unsigned long  it_busno;     /* Bus number this table belongs to */
 	unsigned long  it_size;      /* Size of iommu table in entries */
@@ -78,6 +83,7 @@ struct iommu_table {
 	struct iommu_group *it_group;
 #endif
 	void (*set_bypass)(struct iommu_table *tbl, bool enable);
+	struct iommu_owner *it_owner;
 };
 
 /* Pure 2^n version of get_order */
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 29294b1..1f307ef 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -586,8 +586,8 @@ static void pnv_pci_ioda2_tce_invalidate(struct pnv_ioda_pe *pe,
 void pnv_pci_ioda_tce_invalidate(struct iommu_table *tbl,
 				 __be64 *startp, __be64 *endp, bool rm)
 {
-	struct pnv_ioda_pe *pe = container_of(tbl, struct pnv_ioda_pe,
-					      tce32_table);
+	struct pnv_ioda_pe *pe = container_of(tbl->it_owner, struct pnv_ioda_pe,
+					      owner);
 	struct pnv_phb *phb = pe->phb;
 
 	if (phb->type == PNV_PHB_IODA1)
@@ -655,7 +655,8 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 	/* Setup linux iommu table */
 	tbl = &pe->tce32_table;
 	pnv_pci_setup_iommu_table(tbl, addr, TCE32_TABLE_SIZE * segs,
-				  base << 28, IOMMU_PAGE_SHIFT_4K);
+				  base << 28, IOMMU_PAGE_SHIFT_4K,
+				  &pe->owner);
 
 	/* OPAL variant of P7IOC SW invalidated TCEs */
 	swinvp = of_get_property(phb->hose->dn, "ibm,opal-tce-kill", NULL);
@@ -691,11 +692,14 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 
 static void pnv_pci_ioda2_set_bypass(struct iommu_table *tbl, bool enable)
 {
-	struct pnv_ioda_pe *pe = container_of(tbl, struct pnv_ioda_pe,
-					      tce32_table);
-	uint16_t window_id = (pe->pe_number << 1 ) + 1;
+	struct pnv_ioda_pe *pe;
+	uint16_t window_id;
 	int64_t rc;
 
+	BUG_ON(!tbl->it_owner);
+	pe = container_of(tbl->it_owner, struct pnv_ioda_pe, owner);
+	window_id = (pe->pe_number << 1) + 1;
+
 	pe_info(pe, "%sabling 64-bit DMA bypass\n", enable ? "En" : "Dis");
 	if (enable) {
 		phys_addr_t top = memblock_end_of_DRAM();
@@ -786,7 +790,7 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 	/* Setup linux iommu table */
 	tbl = &pe->tce32_table;
 	pnv_pci_setup_iommu_table(tbl, addr, tce_table_size, 0,
-			IOMMU_PAGE_SHIFT_4K);
+			IOMMU_PAGE_SHIFT_4K, &pe->owner);
 
 	/* OPAL variant of PHB3 invalidated TCEs */
 	swinvp = of_get_property(phb->hose->dn, "ibm,opal-tce-kill", NULL);
diff --git a/arch/powerpc/platforms/powernv/pci-p5ioc2.c b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
index 94ce348..cf02c14 100644
--- a/arch/powerpc/platforms/powernv/pci-p5ioc2.c
+++ b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
@@ -173,7 +173,7 @@ static void __init pnv_pci_init_p5ioc2_phb(struct device_node *np, u64 hub_id,
 	phb->dma_dev_setup = pnv_pci_p5ioc2_dma_dev_setup;
 	pnv_pci_setup_iommu_table(&phb->p5ioc2.iommu_table,
 				  tce_mem, tce_size, 0,
-				  IOMMU_PAGE_SHIFT_4K);
+				  IOMMU_PAGE_SHIFT_4K, NULL);
 }
 
 void __init pnv_pci_init_p5ioc2_hub(struct device_node *np)
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index 92d6f5b..aa88c94 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -591,7 +591,8 @@ static void pnv_tce_free_rm(struct iommu_table *tbl, long index, long npages)
 
 void pnv_pci_setup_iommu_table(struct iommu_table *tbl,
 			       void *tce_mem, u64 tce_size,
-			       u64 dma_offset, unsigned page_shift)
+			       u64 dma_offset, unsigned page_shift,
+			       struct iommu_owner *owner)
 {
 	tbl->it_blocksize = 16;
 	tbl->it_base = (unsigned long)tce_mem;
@@ -601,6 +602,7 @@ void pnv_pci_setup_iommu_table(struct iommu_table *tbl,
 	tbl->it_size = tce_size >> 3;
 	tbl->it_busno = 0;
 	tbl->it_type = TCE_PCI;
+	tbl->it_owner = owner;
 }
 
 static struct iommu_table *pnv_pci_setup_bml_iommu(struct pci_controller *hose)
@@ -620,7 +622,8 @@ static struct iommu_table *pnv_pci_setup_bml_iommu(struct pci_controller *hose)
 	if (WARN_ON(!tbl))
 		return NULL;
 	pnv_pci_setup_iommu_table(tbl, __va(be64_to_cpup(basep)),
-				  be32_to_cpup(sizep), 0, IOMMU_PAGE_SHIFT_4K);
+				  be32_to_cpup(sizep), 0, IOMMU_PAGE_SHIFT_4K,
+				  NULL);
 	iommu_init_table(tbl, hose->node);
 	iommu_register_group(tbl, pci_domain_nr(hose->bus), 0);
 
diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
index ca62444..d05eae3 100644
--- a/arch/powerpc/platforms/powernv/pci.h
+++ b/arch/powerpc/platforms/powernv/pci.h
@@ -49,6 +49,7 @@ struct pnv_ioda_pe {
 	unsigned int		dma_weight;
 
 	/* "Base" iommu table, ie, 4K TCEs, 32-bit DMA */
+	struct iommu_owner	owner;
 	int			tce32_seg;
 	int			tce32_segcount;
 	struct iommu_table	tce32_table;
@@ -199,7 +200,8 @@ int pnv_pci_cfg_write(struct device_node *dn,
 		      int where, int size, u32 val);
 extern void pnv_pci_setup_iommu_table(struct iommu_table *tbl,
 				      void *tce_mem, u64 tce_size,
-				      u64 dma_offset, unsigned page_shift);
+				      u64 dma_offset, unsigned page_shift,
+				      struct iommu_owner *owner);
 extern void pnv_pci_init_p5ioc2_hub(struct device_node *np);
 extern void pnv_pci_init_ioda_hub(struct device_node *np);
 extern void pnv_pci_init_ioda2_phb(struct device_node *np);
-- 
2.0.0

