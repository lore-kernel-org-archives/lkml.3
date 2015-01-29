Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760840AbbA2J0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:26:33 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:49017 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761377AbbA2JWi (ORCPT
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
Subject: [PATCH v3 20/24] powerpc/powernv: Change prototypes to receive iommu
Date: Thu, 29 Jan 2015 20:22:01 +1100
Message-Id: <1422523325-1389-21-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0009-0000-0000-000000DE6C56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes few functions to receive a powerpc_iommu pointer
rather than PE as they are going to be a part of upcoming
powerpc_iommu_ops callback set.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index f542819..29bd7a4 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1360,10 +1360,12 @@ static __be64 *pnv_alloc_tce_table(int nid,
 	return addr;
 }
 
-static long pnv_pci_ioda2_create_table(struct pnv_ioda_pe *pe,
+static long pnv_pci_ioda2_create_table(struct powerpc_iommu *iommu,
 		__u32 page_shift, __u32 window_shift, __u32 levels,
 		struct iommu_table *tbl)
 {
+	struct pnv_ioda_pe *pe = container_of(iommu, struct pnv_ioda_pe,
+						iommu);
 	int nid = pe->phb->hose->node;
 	void *addr;
 	unsigned long tce_table_size, left;
@@ -1419,9 +1421,11 @@ static void pnv_pci_ioda2_free_table(struct iommu_table *tbl)
 	iommu_reset_table(tbl, "ioda2");
 }
 
-static long pnv_pci_ioda2_set_window(struct pnv_ioda_pe *pe,
+static long pnv_pci_ioda2_set_window(struct powerpc_iommu *iommu,
 		struct iommu_table *tbl)
 {
+	struct pnv_ioda_pe *pe = container_of(iommu, struct pnv_ioda_pe,
+						iommu);
 	struct pnv_phb *phb = pe->phb;
 	const __be64 *swinvp;
 	int64_t rc;
@@ -1554,12 +1558,11 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 
 	/* The PE will reserve all possible 32-bits space */
 	pe->tce32_seg = 0;
-
 	end = (1 << ilog2(phb->ioda.m32_pci_base));
 	pe_info(pe, "Setting up 32-bit TCE table at 0..%08x\n",
 		end);
 
-	rc = pnv_pci_ioda2_create_table(pe, IOMMU_PAGE_SHIFT_4K,
+	rc = pnv_pci_ioda2_create_table(&pe->iommu, IOMMU_PAGE_SHIFT_4K,
 			ilog2(phb->ioda.m32_pci_base),
 			POWERPC_IOMMU_DEFAULT_LEVELS, tbl);
 	if (rc) {
@@ -1571,7 +1574,7 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 	pe->iommu.tables[0].it_iommu = &pe->iommu;
 	pe->iommu.ops = &pnv_pci_ioda2_ops;
 
-	rc = pnv_pci_ioda2_set_window(pe, tbl);
+	rc = pnv_pci_ioda2_set_window(&pe->iommu, tbl);
 	if (rc) {
 		pe_err(pe, "Failed to configure 32-bit TCE table,"
 		       " err %ld\n", rc);
-- 
2.0.0

