Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600AbbA2JWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:22:55 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57959 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760616AbbA2JWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:36 -0500
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
Subject: [PATCH v3 17/24] powerpc/powernv/ioda2: Introduce pnv_pci_ioda2_set_window
Date: Thu, 29 Jan 2015 20:21:58 +1100
Message-Id: <1422523325-1389-18-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0033-0000-0000-000000FE0B66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a part of moving DMA window programming to an iommu_ops
callback.

This is a mechanical patch.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 84 ++++++++++++++++++++-----------
 1 file changed, 56 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 95d9119..1f725d4 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1351,6 +1351,57 @@ static void pnv_pci_ioda2_free_table(struct iommu_table *tbl)
 	memset(tbl, 0, sizeof(struct iommu_table));
 }
 
+static long pnv_pci_ioda2_set_window(struct pnv_ioda_pe *pe,
+		struct iommu_table *tbl)
+{
+	struct pnv_phb *phb = pe->phb;
+	const __be64 *swinvp;
+	int64_t rc;
+	const __u64 start_addr = tbl->it_offset << tbl->it_page_shift;
+	const __u64 win_size = tbl->it_size << tbl->it_page_shift;
+
+	pe_info(pe, "Setting up window at %llx..%llx pagesize=0x%x tablesize=0x%lx\n",
+			start_addr, start_addr + win_size - 1,
+			1UL << tbl->it_page_shift, tbl->it_size << 3);
+
+	pe->iommu.tables[0] = *tbl;
+	tbl = &pe->iommu.tables[0];
+	tbl->it_iommu = &pe->iommu;
+
+	/*
+	 * Map TCE table through TVT. The TVE index is the PE number
+	 * shifted by 1 bit for 32-bits DMA space.
+	 */
+	rc = opal_pci_map_pe_dma_window(phb->opal_id, pe->pe_number,
+			pe->pe_number << 1, 1, __pa(tbl->it_base),
+			tbl->it_size << 3, 1ULL << tbl->it_page_shift);
+	if (rc) {
+		pe_err(pe, "Failed to configure TCE table, err %ld\n", rc);
+		goto fail;
+	}
+
+	/* OPAL variant of PHB3 invalidated TCEs */
+	swinvp = of_get_property(phb->hose->dn, "ibm,opal-tce-kill", NULL);
+	if (swinvp) {
+		/* We need a couple more fields -- an address and a data
+		 * to or.  Since the bus is only printed out on table free
+		 * errors, and on the first pass the data will be a relative
+		 * bus number, print that out instead.
+		 */
+		pe->tce_inval_reg_phys = be64_to_cpup(swinvp);
+		tbl->it_index = (unsigned long)ioremap(pe->tce_inval_reg_phys,
+				8);
+		tbl->it_type |= (TCE_PCI_SWINV_CREATE | TCE_PCI_SWINV_FREE);
+	}
+
+	return 0;
+fail:
+	if (pe->tce32_seg >= 0)
+		pe->tce32_seg = -1;
+
+	return rc;
+}
+
 static void pnv_pci_ioda2_set_bypass(struct pnv_ioda_pe *pe, bool enable)
 {
 	uint16_t window_id = (pe->pe_number << 1 ) + 1;
@@ -1421,7 +1472,6 @@ static struct powerpc_iommu_ops pnv_pci_ioda2_ops = {
 static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 				       struct pnv_ioda_pe *pe)
 {
-	const __be64 *swinvp;
 	unsigned int end;
 	struct iommu_table *tbl = &pe->iommu.tables[0];
 	int64_t rc;
@@ -1448,31 +1498,14 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 	pe->iommu.tables[0].it_iommu = &pe->iommu;
 	pe->iommu.ops = &pnv_pci_ioda2_ops;
 
-	/*
-	 * Map TCE table through TVT. The TVE index is the PE number
-	 * shifted by 1 bit for 32-bits DMA space.
-	 */
-	rc = opal_pci_map_pe_dma_window(phb->opal_id, pe->pe_number,
-			pe->pe_number << 1, 1, __pa(tbl->it_base),
-			tbl->it_size << 3, 1ULL << tbl->it_page_shift);
+	rc = pnv_pci_ioda2_set_window(pe, tbl);
 	if (rc) {
 		pe_err(pe, "Failed to configure 32-bit TCE table,"
 		       " err %ld\n", rc);
-		goto fail;
-	}
-
-	/* OPAL variant of PHB3 invalidated TCEs */
-	swinvp = of_get_property(phb->hose->dn, "ibm,opal-tce-kill", NULL);
-	if (swinvp) {
-		/* We need a couple more fields -- an address and a data
-		 * to or.  Since the bus is only printed out on table free
-		 * errors, and on the first pass the data will be a relative
-		 * bus number, print that out instead.
-		 */
-		pe->tce_inval_reg_phys = be64_to_cpup(swinvp);
-		tbl->it_index = (unsigned long)ioremap(pe->tce_inval_reg_phys,
-				8);
-		tbl->it_type |= (TCE_PCI_SWINV_CREATE | TCE_PCI_SWINV_FREE);
+		pnv_pci_ioda2_free_table(tbl);
+		if (pe->tce32_seg >= 0)
+			pe->tce32_seg = -1;
+		return;
 	}
 
 	iommu_register_group(&pe->iommu, phb->hose->global_number,
@@ -1486,11 +1519,6 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 
 	/* Also create a bypass window */
 	pnv_pci_ioda2_setup_bypass_pe(phb, pe);
-	return;
-fail:
-	if (pe->tce32_seg >= 0)
-		pe->tce32_seg = -1;
-	pnv_pci_ioda2_free_table(tbl);
 }
 
 static void pnv_ioda_setup_dma(struct pnv_phb *phb)
-- 
2.0.0

