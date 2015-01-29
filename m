Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbbA2JZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:25:33 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:42925 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761382AbbA2JWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:39 -0500
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
Subject: [PATCH v3 21/24] powerpc/powernv/ioda: Define and implement DMA table/window management callbacks
Date: Thu, 29 Jan 2015 20:22:02 +1100
Message-Id: <1422523325-1389-22-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0005-0000-0000-00000143629F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends powerpc_iommu_ops by a set of callbacks to support dynamic
DMA windows management.

query() returns IOMMU capabilities such as default DMA window address and
supported number of DMA windows and TCE table levels.

create_table() creates a TCE table with specific parameters. For now
it receives powerpc_iommu to know nodeid in order to allocate TCE table
memory closer to the PHB. The exact format of allocated multi-level table
might be also specific to the PHB model (not the case now though).

set_window() sets the window at specified TVT index on PHB.

unset_window() unsets the window from specified TVT.

free_table() frees the memory occupied by a table.

The purpose of this separation is that we need to be able to create
one table and assign it to a set of PHB. This way we can support multiple
IOMMU groups in one VFIO container and make use of VFIO on SPAPR closer
to the way it works on x86.

This uses new helpers to remove the default TCE table if the ownership is
being taken and create it otherwise. So once an external user (such as
VFIO) obtained the ownership over a group, it does not have any DMA
windows, neither default 32bit not bypass window. The external user is
expected to unprogram DMA windows on PHBs before returning ownership
back to the kernel.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h          | 31 ++++++++++
 arch/powerpc/platforms/powernv/pci-ioda.c | 98 ++++++++++++++++++++++++++-----
 2 files changed, 113 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 283f70f..8393822 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -147,12 +147,43 @@ struct powerpc_iommu_ops {
 	 */
 	void (*set_ownership)(struct powerpc_iommu *iommu,
 			bool enable);
+
+	long (*create_table)(struct powerpc_iommu *iommu,
+			int num,
+			__u32 page_shift,
+			__u32 window_shift,
+			__u32 levels,
+			struct iommu_table *tbl);
+	long (*set_window)(struct powerpc_iommu *iommu,
+			int num,
+			struct iommu_table *tblnew);
+	long (*unset_window)(struct powerpc_iommu *iommu,
+			int num);
+	void (*free_table)(struct iommu_table *tbl);
 };
 
+/* Page size flags for ibm,query-pe-dma-window */
+#define DDW_PGSIZE_4K           0x01
+#define DDW_PGSIZE_64K          0x02
+#define DDW_PGSIZE_16M          0x04
+#define DDW_PGSIZE_32M          0x08
+#define DDW_PGSIZE_64M          0x10
+#define DDW_PGSIZE_128M         0x20
+#define DDW_PGSIZE_256M         0x40
+#define DDW_PGSIZE_16G          0x80
+#define DDW_PGSIZE_MASK         0xFF
+
 struct powerpc_iommu {
 #ifdef CONFIG_IOMMU_API
 	struct iommu_group *group;
 #endif
+	/* Some key properties of IOMMU */
+	__u32 tce32_start;
+	__u32 tce32_size;
+	__u32 windows_supported;
+	__u32 levels;
+	__u32 flags;
+
 	struct iommu_table tables[POWERPC_IOMMU_MAX_TABLES];
 	struct powerpc_iommu_ops *ops;
 };
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 29bd7a4..cf63ebb 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1360,7 +1360,7 @@ static __be64 *pnv_alloc_tce_table(int nid,
 	return addr;
 }
 
-static long pnv_pci_ioda2_create_table(struct powerpc_iommu *iommu,
+static long pnv_pci_ioda2_create_table(struct powerpc_iommu *iommu, int num,
 		__u32 page_shift, __u32 window_shift, __u32 levels,
 		struct iommu_table *tbl)
 {
@@ -1388,8 +1388,8 @@ static long pnv_pci_ioda2_create_table(struct powerpc_iommu *iommu,
 	shift = ROUND_UP(window_shift - page_shift, levels) / levels;
 	shift += 3;
 	shift = max_t(unsigned, shift, IOMMU_PAGE_SHIFT_4K);
-	pr_info("Creating TCE table %08llx, %d levels, TCE table size = %lx\n",
-			1ULL << window_shift, levels, 1UL << shift);
+	pr_info("Creating TCE table #%d %08llx, %d levels, TCE table size = %lx\n",
+			num, 1ULL << window_shift, levels, 1UL << shift);
 
 	tbl->it_level_size = 1ULL << (shift - 3);
 	left = tce_table_size;
@@ -1400,11 +1400,10 @@ static long pnv_pci_ioda2_create_table(struct powerpc_iommu *iommu,
 	tbl->it_indirect_levels = levels - 1;
 
 	/* Setup linux iommu table */
-	pnv_pci_setup_iommu_table(tbl, addr, tce_table_size, 0,
-			page_shift);
+	pnv_pci_setup_iommu_table(tbl, addr, tce_table_size,
+			num ? pe->tce_bypass_base : 0, page_shift);
 
 	tbl->it_ops = &pnv_ioda2_iommu_ops;
-	iommu_init_table(tbl, nid);
 
 	return 0;
 }
@@ -1421,8 +1420,18 @@ static void pnv_pci_ioda2_free_table(struct iommu_table *tbl)
 	iommu_reset_table(tbl, "ioda2");
 }
 
+static inline void pnv_pci_ioda2_tvt_invalidate(unsigned int pe_number,
+		unsigned long it_index)
+{
+	__be64 __iomem *invalidate = (__be64 __iomem *)it_index;
+	/* 01xb - invalidate TCEs that match the specified PE# */
+	unsigned long addr = (0x4ull << 60) | (pe_number & 0xFF);
+
+	__raw_writeq(cpu_to_be64(addr), invalidate);
+}
+
 static long pnv_pci_ioda2_set_window(struct powerpc_iommu *iommu,
-		struct iommu_table *tbl)
+		int num, struct iommu_table *tbl)
 {
 	struct pnv_ioda_pe *pe = container_of(iommu, struct pnv_ioda_pe,
 						iommu);
@@ -1439,8 +1448,8 @@ static long pnv_pci_ioda2_set_window(struct powerpc_iommu *iommu,
 			1UL << tbl->it_page_shift, tbl->it_size,
 			tbl->it_indirect_levels + 1, tbl->it_level_size);
 
-	pe->iommu.tables[0] = *tbl;
-	tbl = &pe->iommu.tables[0];
+	pe->iommu.tables[num] = *tbl;
+	tbl = &pe->iommu.tables[num];
 	tbl->it_iommu = &pe->iommu;
 
 	/*
@@ -1448,7 +1457,8 @@ static long pnv_pci_ioda2_set_window(struct powerpc_iommu *iommu,
 	 * shifted by 1 bit for 32-bits DMA space.
 	 */
 	rc = opal_pci_map_pe_dma_window(phb->opal_id, pe->pe_number,
-			pe->pe_number << 1, tbl->it_indirect_levels + 1,
+			(pe->pe_number << 1) + num,
+			tbl->it_indirect_levels + 1,
 			__pa(tbl->it_base),
 			size << 3, 1ULL << tbl->it_page_shift);
 	if (rc) {
@@ -1470,6 +1480,8 @@ static long pnv_pci_ioda2_set_window(struct powerpc_iommu *iommu,
 		tbl->it_type |= (TCE_PCI_SWINV_CREATE | TCE_PCI_SWINV_FREE);
 	}
 
+	pnv_pci_ioda2_tvt_invalidate(pe->pe_number, tbl->it_index);
+
 	return 0;
 fail:
 	if (pe->tce32_seg >= 0)
@@ -1478,6 +1490,28 @@ fail:
 	return rc;
 }
 
+static long pnv_pci_ioda2_unset_window(struct powerpc_iommu *iommu, int num)
+{
+	struct pnv_ioda_pe *pe = container_of(iommu, struct pnv_ioda_pe,
+						iommu);
+	struct pnv_phb *phb = pe->phb;
+	long ret;
+
+	pe_info(pe, "Removing DMA window\n");
+
+	ret = opal_pci_map_pe_dma_window(phb->opal_id, pe->pe_number,
+			(pe->pe_number << 1) + num,
+			0/* levels */, 0/* table address */,
+			0/* table size */, 0/* page size */);
+	if (ret)
+		pe_warn(pe, "Unmapping failed, ret = %ld\n", ret);
+
+	pnv_pci_ioda2_tvt_invalidate(pe->pe_number,
+			iommu->tables[num].it_index);
+
+	return ret;
+}
+
 static void pnv_pci_ioda2_set_bypass(struct pnv_ioda_pe *pe, bool enable)
 {
 	uint16_t window_id = (pe->pe_number << 1 ) + 1;
@@ -1533,16 +1567,42 @@ static void pnv_ioda2_set_ownership(struct powerpc_iommu *iommu,
 {
 	struct pnv_ioda_pe *pe = container_of(iommu, struct pnv_ioda_pe,
 						iommu);
-	if (enable)
-		iommu_take_ownership(iommu);
-	else
-		iommu_release_ownership(iommu);
+	if (enable) {
+		pnv_pci_ioda2_unset_window(&pe->iommu, 0);
+		pnv_pci_ioda2_free_table(&pe->iommu.tables[0]);
+	} else {
+		struct iommu_table *tbl = &pe->iommu.tables[0];
+		int64_t rc;
 
+		rc = pnv_pci_ioda2_create_table(&pe->iommu, 0,
+				IOMMU_PAGE_SHIFT_4K,
+				ilog2(pe->phb->ioda.m32_pci_base),
+				POWERPC_IOMMU_DEFAULT_LEVELS, tbl);
+		if (rc) {
+			pe_err(pe, "Failed to create 32-bit TCE table, err %ld",
+					rc);
+			return;
+		}
+
+		iommu_init_table(tbl, pe->phb->hose->node);
+
+		rc = pnv_pci_ioda2_set_window(&pe->iommu, 0, tbl);
+		if (rc) {
+			pe_err(pe, "Failed to configure 32-bit TCE table, err %ld\n",
+					rc);
+			pnv_pci_ioda2_free_table(tbl);
+			return;
+		}
+	}
 	pnv_pci_ioda2_set_bypass(pe, !enable);
 }
 
 static struct powerpc_iommu_ops pnv_pci_ioda2_ops = {
 	.set_ownership = pnv_ioda2_set_ownership,
+	.create_table = pnv_pci_ioda2_create_table,
+	.set_window = pnv_pci_ioda2_set_window,
+	.unset_window = pnv_pci_ioda2_unset_window,
+	.free_table = pnv_pci_ioda2_free_table
 };
 
 static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
@@ -1562,7 +1622,7 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 	pe_info(pe, "Setting up 32-bit TCE table at 0..%08x\n",
 		end);
 
-	rc = pnv_pci_ioda2_create_table(&pe->iommu, IOMMU_PAGE_SHIFT_4K,
+	rc = pnv_pci_ioda2_create_table(&pe->iommu, 0, IOMMU_PAGE_SHIFT_4K,
 			ilog2(phb->ioda.m32_pci_base),
 			POWERPC_IOMMU_DEFAULT_LEVELS, tbl);
 	if (rc) {
@@ -1571,10 +1631,16 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 	}
 
 	/* Setup iommu */
+	pe->iommu.tce32_start = 0;
+	pe->iommu.tce32_size = phb->ioda.m32_pci_base;
+	pe->iommu.windows_supported = POWERPC_IOMMU_MAX_TABLES;
+	pe->iommu.levels = 5;
+	pe->iommu.flags = DDW_PGSIZE_4K | DDW_PGSIZE_64K | DDW_PGSIZE_16M;
+	iommu_init_table(tbl, pe->phb->hose->node);
 	pe->iommu.tables[0].it_iommu = &pe->iommu;
 	pe->iommu.ops = &pnv_pci_ioda2_ops;
 
-	rc = pnv_pci_ioda2_set_window(&pe->iommu, tbl);
+	rc = pnv_pci_ioda2_set_window(&pe->iommu, 0, tbl);
 	if (rc) {
 		pe_err(pe, "Failed to configure 32-bit TCE table,"
 		       " err %ld\n", rc);
-- 
2.0.0

