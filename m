Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546AbbA2JWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:22:46 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34544 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761317AbbA2JWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:35 -0500
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
Subject: [PATCH v3 16/24] powerpc/powernv/ioda2: Introduce pnv_pci_ioda2_create_table
Date: Thu, 29 Jan 2015 20:21:57 +1100
Message-Id: <1422523325-1389-17-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0029-0000-0000-0000010FD5C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a part of moving TCE table allocation into an iommu_ops
callback to support multiple IOMMU groups per one VFIO container.

This is a mechanical patch.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 88 +++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index ebfea0a..95d9119 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1295,6 +1295,62 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 		__free_pages(tce_mem, get_order(TCE32_TABLE_SIZE * segs));
 }
 
+static long pnv_pci_ioda2_create_table(struct pnv_ioda_pe *pe,
+		__u32 page_shift, __u32 window_shift,
+		struct iommu_table *tbl)
+{
+	int nid = pe->phb->hose->node;
+	struct page *tce_mem = NULL;
+	void *addr;
+	unsigned long tce_table_size;
+	int64_t rc;
+	unsigned order;
+
+	if ((page_shift != 12) && (page_shift != 16) && (page_shift != 24))
+		return -EINVAL;
+
+	if ((1ULL << window_shift) > memory_hotplug_max())
+		return -EINVAL;
+
+	tce_table_size = (1ULL << (window_shift - page_shift)) * 8;
+	tce_table_size = max(0x1000UL, tce_table_size);
+
+	/* Allocate TCE table */
+	order = get_order(tce_table_size);
+
+	tce_mem = alloc_pages_node(nid, GFP_KERNEL, order);
+	if (!tce_mem) {
+		pr_err("Failed to allocate a TCE memory, order=%d\n", order);
+		rc = -ENOMEM;
+		goto fail;
+	}
+	addr = page_address(tce_mem);
+	memset(addr, 0, tce_table_size);
+
+	/* Setup linux iommu table */
+	pnv_pci_setup_iommu_table(tbl, addr, tce_table_size, 0,
+			page_shift);
+
+	tbl->it_ops = &pnv_ioda2_iommu_ops;
+	iommu_init_table(tbl, nid);
+
+	return 0;
+fail:
+	if (tce_mem)
+		__free_pages(tce_mem, get_order(tce_table_size));
+
+	return rc;
+}
+
+static void pnv_pci_ioda2_free_table(struct iommu_table *tbl)
+{
+	if (!tbl->it_size)
+		return;
+
+	free_pages(tbl->it_base, get_order(tbl->it_size << 3));
+	memset(tbl, 0, sizeof(struct iommu_table));
+}
+
 static void pnv_pci_ioda2_set_bypass(struct pnv_ioda_pe *pe, bool enable)
 {
 	uint16_t window_id = (pe->pe_number << 1 ) + 1;
@@ -1365,11 +1421,9 @@ static struct powerpc_iommu_ops pnv_pci_ioda2_ops = {
 static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 				       struct pnv_ioda_pe *pe)
 {
-	struct page *tce_mem = NULL;
-	void *addr;
 	const __be64 *swinvp;
-	struct iommu_table *tbl;
-	unsigned int tce_table_size, end;
+	unsigned int end;
+	struct iommu_table *tbl = &pe->iommu.tables[0];
 	int64_t rc;
 
 	/* We shouldn't already have a 32-bit DMA associated */
@@ -1378,31 +1432,20 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 
 	/* The PE will reserve all possible 32-bits space */
 	pe->tce32_seg = 0;
+
 	end = (1 << ilog2(phb->ioda.m32_pci_base));
-	tce_table_size = (end / 0x1000) * 8;
 	pe_info(pe, "Setting up 32-bit TCE table at 0..%08x\n",
 		end);
 
-	/* Allocate TCE table */
-	tce_mem = alloc_pages_node(phb->hose->node, GFP_KERNEL,
-				   get_order(tce_table_size));
-	if (!tce_mem) {
-		pe_err(pe, "Failed to allocate a 32-bit TCE memory\n");
-		goto fail;
+	rc = pnv_pci_ioda2_create_table(pe, IOMMU_PAGE_SHIFT_4K,
+			ilog2(phb->ioda.m32_pci_base), tbl);
+	if (rc) {
+		pe_err(pe, "Failed to create 32-bit TCE table, err %ld", rc);
+		return;
 	}
-	addr = page_address(tce_mem);
-	memset(addr, 0, tce_table_size);
 
 	/* Setup iommu */
 	pe->iommu.tables[0].it_iommu = &pe->iommu;
-
-	/* Setup linux iommu table */
-	tbl = &pe->iommu.tables[0];
-	pnv_pci_setup_iommu_table(tbl, addr, tce_table_size, 0,
-			IOMMU_PAGE_SHIFT_4K);
-
-	tbl->it_ops = &pnv_ioda2_iommu_ops;
-	iommu_init_table(tbl, phb->hose->node);
 	pe->iommu.ops = &pnv_pci_ioda2_ops;
 
 	/*
@@ -1447,8 +1490,7 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 fail:
 	if (pe->tce32_seg >= 0)
 		pe->tce32_seg = -1;
-	if (tce_mem)
-		__free_pages(tce_mem, get_order(tce_table_size));
+	pnv_pci_ioda2_free_table(tbl);
 }
 
 static void pnv_ioda_setup_dma(struct pnv_phb *phb)
-- 
2.0.0

