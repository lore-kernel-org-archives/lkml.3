Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbbA2JWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:22:43 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:49010 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761319AbbA2JWf (ORCPT
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
Subject: [PATCH v3 15/24] poweppc/powernv/ioda2: Rework iommu_table creation
Date: Thu, 29 Jan 2015 20:21:56 +1100
Message-Id: <1422523325-1389-16-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0009-0000-0000-000000DE6C52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves iommu_table creation to the beginning. This is a mechanical
patch.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 6d279d5..ebfea0a 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1393,27 +1393,31 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 	addr = page_address(tce_mem);
 	memset(addr, 0, tce_table_size);
 
+	/* Setup iommu */
+	pe->iommu.tables[0].it_iommu = &pe->iommu;
+
+	/* Setup linux iommu table */
+	tbl = &pe->iommu.tables[0];
+	pnv_pci_setup_iommu_table(tbl, addr, tce_table_size, 0,
+			IOMMU_PAGE_SHIFT_4K);
+
+	tbl->it_ops = &pnv_ioda2_iommu_ops;
+	iommu_init_table(tbl, phb->hose->node);
+	pe->iommu.ops = &pnv_pci_ioda2_ops;
+
 	/*
 	 * Map TCE table through TVT. The TVE index is the PE number
 	 * shifted by 1 bit for 32-bits DMA space.
 	 */
 	rc = opal_pci_map_pe_dma_window(phb->opal_id, pe->pe_number,
-					pe->pe_number << 1, 1, __pa(addr),
-					tce_table_size, 0x1000);
+			pe->pe_number << 1, 1, __pa(tbl->it_base),
+			tbl->it_size << 3, 1ULL << tbl->it_page_shift);
 	if (rc) {
 		pe_err(pe, "Failed to configure 32-bit TCE table,"
 		       " err %ld\n", rc);
 		goto fail;
 	}
 
-	/* Setup iommu */
-	pe->iommu.tables[0].it_iommu = &pe->iommu;
-
-	/* Setup linux iommu table */
-	tbl = &pe->iommu.tables[0];
-	pnv_pci_setup_iommu_table(tbl, addr, tce_table_size, 0,
-			IOMMU_PAGE_SHIFT_4K);
-
 	/* OPAL variant of PHB3 invalidated TCEs */
 	swinvp = of_get_property(phb->hose->dn, "ibm,opal-tce-kill", NULL);
 	if (swinvp) {
@@ -1427,14 +1431,13 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 				8);
 		tbl->it_type |= (TCE_PCI_SWINV_CREATE | TCE_PCI_SWINV_FREE);
 	}
-	tbl->it_ops = &pnv_ioda2_iommu_ops;
-	iommu_init_table(tbl, phb->hose->node);
-	pe->iommu.ops = &pnv_pci_ioda2_ops;
+
 	iommu_register_group(&pe->iommu, phb->hose->global_number,
 			pe->pe_number);
 
 	if (pe->pdev)
-		set_iommu_table_base_and_group(&pe->pdev->dev, tbl);
+		set_iommu_table_base_and_group(&pe->pdev->dev,
+				&pe->iommu.tables[0]);
 	else
 		pnv_ioda_setup_bus_dma(pe, pe->pbus, true);
 
-- 
2.0.0

