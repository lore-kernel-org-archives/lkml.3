Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbbA2J0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:26:31 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37614 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761342AbbA2JWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:38 -0500
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
Subject: [PATCH v3 19/24] powerpc/powernv: Implement multilevel TCE tables
Date: Thu, 29 Jan 2015 20:22:00 +1100
Message-Id: <1422523325-1389-20-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0013-0000-0000-000000BF16DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds multi-level TCE tables support to pnv_pci_ioda2_create_table()
and pnv_pci_ioda2_free_table() callbacks.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h          |   4 +
 arch/powerpc/platforms/powernv/pci-ioda.c | 125 +++++++++++++++++++++++-------
 arch/powerpc/platforms/powernv/pci.c      |  19 +++++
 3 files changed, 122 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index cc26eca..283f70f 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -85,6 +85,8 @@ struct iommu_pool {
 struct iommu_table {
 	unsigned long  it_busno;     /* Bus number this table belongs to */
 	unsigned long  it_size;      /* Size of iommu table in entries */
+	unsigned long  it_indirect_levels;
+	unsigned long  it_level_size;
 	unsigned long  it_offset;    /* Offset into global table */
 	unsigned long  it_base;      /* mapped address of tce table */
 	unsigned long  it_index;     /* which iommu table this is */
@@ -133,6 +135,8 @@ extern struct iommu_table *iommu_init_table(struct iommu_table * tbl,
 
 #define POWERPC_IOMMU_MAX_TABLES	1
 
+#define POWERPC_IOMMU_DEFAULT_LEVELS	1
+
 struct powerpc_iommu;
 
 struct powerpc_iommu_ops {
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 1f725d4..f542819 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1295,16 +1295,79 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 		__free_pages(tce_mem, get_order(TCE32_TABLE_SIZE * segs));
 }
 
+static void pnv_free_tce_table(unsigned long addr, unsigned size,
+		unsigned level)
+{
+	addr &= ~(TCE_PCI_READ | TCE_PCI_WRITE);
+
+	if (level) {
+		long i;
+		u64 *tmp = (u64 *) addr;
+
+		for (i = 0; i < size; ++i) {
+			unsigned long hpa = be64_to_cpu(tmp[i]);
+
+			if (!(hpa & (TCE_PCI_READ | TCE_PCI_WRITE)))
+				continue;
+
+			pnv_free_tce_table((unsigned long) __va(hpa),
+					size, level - 1);
+		}
+	}
+
+	free_pages(addr, get_order(size << 3));
+}
+
+static __be64 *pnv_alloc_tce_table(int nid,
+		unsigned shift, unsigned levels, unsigned long *left)
+{
+	struct page *tce_mem = NULL;
+	__be64 *addr, *tmp;
+	unsigned order = max_t(unsigned, shift, PAGE_SHIFT) - PAGE_SHIFT;
+	unsigned long chunk = 1UL << shift, i;
+
+	tce_mem = alloc_pages_node(nid, GFP_KERNEL, order);
+	if (!tce_mem) {
+		pr_err("Failed to allocate a TCE memory\n");
+		return NULL;
+	}
+
+	if (!*left)
+		return NULL;
+
+	addr = page_address(tce_mem);
+	memset(addr, 0, chunk);
+
+	--levels;
+	if (!levels) {
+		/* This is last level, actual TCEs */
+		*left -= min(*left, chunk);
+		return addr;
+	}
+
+	for (i = 0; i < (chunk >> 3); ++i) {
+		/* We allocated required TCEs, mark the rest "page fault" */
+		if (!*left) {
+			addr[i] = cpu_to_be64(0);
+			continue;
+		}
+
+		tmp = pnv_alloc_tce_table(nid, shift, levels, left);
+		addr[i] = cpu_to_be64(__pa(tmp) |
+				TCE_PCI_READ | TCE_PCI_WRITE);
+	}
+
+	return addr;
+}
+
 static long pnv_pci_ioda2_create_table(struct pnv_ioda_pe *pe,
-		__u32 page_shift, __u32 window_shift,
+		__u32 page_shift, __u32 window_shift, __u32 levels,
 		struct iommu_table *tbl)
 {
 	int nid = pe->phb->hose->node;
-	struct page *tce_mem = NULL;
 	void *addr;
-	unsigned long tce_table_size;
-	int64_t rc;
-	unsigned order;
+	unsigned long tce_table_size, left;
+	unsigned shift;
 
 	if ((page_shift != 12) && (page_shift != 16) && (page_shift != 24))
 		return -EINVAL;
@@ -1312,20 +1375,27 @@ static long pnv_pci_ioda2_create_table(struct pnv_ioda_pe *pe,
 	if ((1ULL << window_shift) > memory_hotplug_max())
 		return -EINVAL;
 
+	if (!levels || (levels > 5))
+		return -EINVAL;
+
 	tce_table_size = (1ULL << (window_shift - page_shift)) * 8;
 	tce_table_size = max(0x1000UL, tce_table_size);
 
 	/* Allocate TCE table */
-	order = get_order(tce_table_size);
+#define ROUND_UP(x, n) (((x) + (n) - 1u) & ~((n) - 1u))
+	shift = ROUND_UP(window_shift - page_shift, levels) / levels;
+	shift += 3;
+	shift = max_t(unsigned, shift, IOMMU_PAGE_SHIFT_4K);
+	pr_info("Creating TCE table %08llx, %d levels, TCE table size = %lx\n",
+			1ULL << window_shift, levels, 1UL << shift);
 
-	tce_mem = alloc_pages_node(nid, GFP_KERNEL, order);
-	if (!tce_mem) {
-		pr_err("Failed to allocate a TCE memory, order=%d\n", order);
-		rc = -ENOMEM;
-		goto fail;
-	}
-	addr = page_address(tce_mem);
-	memset(addr, 0, tce_table_size);
+	tbl->it_level_size = 1ULL << (shift - 3);
+	left = tce_table_size;
+	addr = pnv_alloc_tce_table(nid, shift, levels, &left);
+	if (!addr)
+		return -ENOMEM;
+
+	tbl->it_indirect_levels = levels - 1;
 
 	/* Setup linux iommu table */
 	pnv_pci_setup_iommu_table(tbl, addr, tce_table_size, 0,
@@ -1335,20 +1405,18 @@ static long pnv_pci_ioda2_create_table(struct pnv_ioda_pe *pe,
 	iommu_init_table(tbl, nid);
 
 	return 0;
-fail:
-	if (tce_mem)
-		__free_pages(tce_mem, get_order(tce_table_size));
-
-	return rc;
 }
 
 static void pnv_pci_ioda2_free_table(struct iommu_table *tbl)
 {
+	const unsigned size = tbl->it_indirect_levels ?
+			tbl->it_level_size : tbl->it_size;
+
 	if (!tbl->it_size)
 		return;
 
-	free_pages(tbl->it_base, get_order(tbl->it_size << 3));
-	memset(tbl, 0, sizeof(struct iommu_table));
+	pnv_free_tce_table(tbl->it_base, size, tbl->it_indirect_levels);
+	iommu_reset_table(tbl, "ioda2");
 }
 
 static long pnv_pci_ioda2_set_window(struct pnv_ioda_pe *pe,
@@ -1357,12 +1425,15 @@ static long pnv_pci_ioda2_set_window(struct pnv_ioda_pe *pe,
 	struct pnv_phb *phb = pe->phb;
 	const __be64 *swinvp;
 	int64_t rc;
+	const unsigned size = tbl->it_indirect_levels ?
+			tbl->it_level_size : tbl->it_size;
 	const __u64 start_addr = tbl->it_offset << tbl->it_page_shift;
 	const __u64 win_size = tbl->it_size << tbl->it_page_shift;
 
-	pe_info(pe, "Setting up window at %llx..%llx pagesize=0x%x tablesize=0x%lx\n",
+	pe_info(pe, "Setting up window at %llx..%llx pagesize=0x%x tablesize=0x%lx levels=%d levelsize=%x\n",
 			start_addr, start_addr + win_size - 1,
-			1UL << tbl->it_page_shift, tbl->it_size << 3);
+			1UL << tbl->it_page_shift, tbl->it_size,
+			tbl->it_indirect_levels + 1, tbl->it_level_size);
 
 	pe->iommu.tables[0] = *tbl;
 	tbl = &pe->iommu.tables[0];
@@ -1373,8 +1444,9 @@ static long pnv_pci_ioda2_set_window(struct pnv_ioda_pe *pe,
 	 * shifted by 1 bit for 32-bits DMA space.
 	 */
 	rc = opal_pci_map_pe_dma_window(phb->opal_id, pe->pe_number,
-			pe->pe_number << 1, 1, __pa(tbl->it_base),
-			tbl->it_size << 3, 1ULL << tbl->it_page_shift);
+			pe->pe_number << 1, tbl->it_indirect_levels + 1,
+			__pa(tbl->it_base),
+			size << 3, 1ULL << tbl->it_page_shift);
 	if (rc) {
 		pe_err(pe, "Failed to configure TCE table, err %ld\n", rc);
 		goto fail;
@@ -1488,7 +1560,8 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 		end);
 
 	rc = pnv_pci_ioda2_create_table(pe, IOMMU_PAGE_SHIFT_4K,
-			ilog2(phb->ioda.m32_pci_base), tbl);
+			ilog2(phb->ioda.m32_pci_base),
+			POWERPC_IOMMU_DEFAULT_LEVELS, tbl);
 	if (rc) {
 		pe_err(pe, "Failed to create 32-bit TCE table, err %ld", rc);
 		return;
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index cf8206b..e98495a 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -605,6 +605,25 @@ static unsigned long pnv_dmadir_to_flags(enum dma_data_direction direction)
 static __be64 *pnv_tce(struct iommu_table *tbl, long index)
 {
 	__be64 *tmp = ((__be64 *)tbl->it_base);
+	int  level = tbl->it_indirect_levels;
+	const long shift = ilog2(tbl->it_level_size);
+	unsigned long mask = (tbl->it_level_size - 1) << (level * shift);
+
+	if (index >= tbl->it_size)
+		return NULL;
+
+	while (level) {
+		int n = (index & mask) >> (level * shift);
+		unsigned long tce = be64_to_cpu(tmp[n]);
+
+		if (!(tce & (TCE_PCI_READ | TCE_PCI_WRITE)))
+			return NULL;
+
+		tmp = __va(tce & ~(TCE_PCI_READ | TCE_PCI_WRITE));
+		index &= ~mask;
+		mask >>= shift;
+		--level;
+	}
 
 	return tmp + index;
 }
-- 
2.0.0

