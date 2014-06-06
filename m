Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaFFIpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:45:49 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47750 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaFFIoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:44:19 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alistair Popple <alistair@popple.id.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] powerpc/powernv: Add a page size parameter to pnv_pci_setup_iommu_table()
Date: Fri,  6 Jun 2014 18:44:03 +1000
Message-Id: <1402044246-13650-4-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
References: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060608-3568-0000-0000-000005A3371E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since a TCE page size can be other than 4K, make it configurable for
P5IOC2 and IODA PHBs.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/platforms/powernv/pci-ioda.c   | 5 +++--
 arch/powerpc/platforms/powernv/pci-p5ioc2.c | 3 ++-
 arch/powerpc/platforms/powernv/pci.c        | 6 +++---
 arch/powerpc/platforms/powernv/pci.h        | 2 +-
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 8307fe5..29294b1 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -655,7 +655,7 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 	/* Setup linux iommu table */
 	tbl = &pe->tce32_table;
 	pnv_pci_setup_iommu_table(tbl, addr, TCE32_TABLE_SIZE * segs,
-				  base << 28);
+				  base << 28, IOMMU_PAGE_SHIFT_4K);
 
 	/* OPAL variant of P7IOC SW invalidated TCEs */
 	swinvp = of_get_property(phb->hose->dn, "ibm,opal-tce-kill", NULL);
@@ -785,7 +785,8 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 
 	/* Setup linux iommu table */
 	tbl = &pe->tce32_table;
-	pnv_pci_setup_iommu_table(tbl, addr, tce_table_size, 0);
+	pnv_pci_setup_iommu_table(tbl, addr, tce_table_size, 0,
+			IOMMU_PAGE_SHIFT_4K);
 
 	/* OPAL variant of PHB3 invalidated TCEs */
 	swinvp = of_get_property(phb->hose->dn, "ibm,opal-tce-kill", NULL);
diff --git a/arch/powerpc/platforms/powernv/pci-p5ioc2.c b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
index e3807d6..94ce348 100644
--- a/arch/powerpc/platforms/powernv/pci-p5ioc2.c
+++ b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
@@ -172,7 +172,8 @@ static void __init pnv_pci_init_p5ioc2_phb(struct device_node *np, u64 hub_id,
 	/* Setup TCEs */
 	phb->dma_dev_setup = pnv_pci_p5ioc2_dma_dev_setup;
 	pnv_pci_setup_iommu_table(&phb->p5ioc2.iommu_table,
-				  tce_mem, tce_size, 0);
+				  tce_mem, tce_size, 0,
+				  IOMMU_PAGE_SHIFT_4K);
 }
 
 void __init pnv_pci_init_p5ioc2_hub(struct device_node *np)
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index 9f7c556..92d6f5b 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -591,11 +591,11 @@ static void pnv_tce_free_rm(struct iommu_table *tbl, long index, long npages)
 
 void pnv_pci_setup_iommu_table(struct iommu_table *tbl,
 			       void *tce_mem, u64 tce_size,
-			       u64 dma_offset)
+			       u64 dma_offset, unsigned page_shift)
 {
 	tbl->it_blocksize = 16;
 	tbl->it_base = (unsigned long)tce_mem;
-	tbl->it_page_shift = IOMMU_PAGE_SHIFT_4K;
+	tbl->it_page_shift = page_shift;
 	tbl->it_offset = dma_offset >> tbl->it_page_shift;
 	tbl->it_index = 0;
 	tbl->it_size = tce_size >> 3;
@@ -620,7 +620,7 @@ static struct iommu_table *pnv_pci_setup_bml_iommu(struct pci_controller *hose)
 	if (WARN_ON(!tbl))
 		return NULL;
 	pnv_pci_setup_iommu_table(tbl, __va(be64_to_cpup(basep)),
-				  be32_to_cpup(sizep), 0);
+				  be32_to_cpup(sizep), 0, IOMMU_PAGE_SHIFT_4K);
 	iommu_init_table(tbl, hose->node);
 	iommu_register_group(tbl, pci_domain_nr(hose->bus), 0);
 
diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
index cde1694..ca62444 100644
--- a/arch/powerpc/platforms/powernv/pci.h
+++ b/arch/powerpc/platforms/powernv/pci.h
@@ -199,7 +199,7 @@ int pnv_pci_cfg_write(struct device_node *dn,
 		      int where, int size, u32 val);
 extern void pnv_pci_setup_iommu_table(struct iommu_table *tbl,
 				      void *tce_mem, u64 tce_size,
-				      u64 dma_offset);
+				      u64 dma_offset, unsigned page_shift);
 extern void pnv_pci_init_p5ioc2_hub(struct device_node *np);
 extern void pnv_pci_init_ioda_hub(struct device_node *np);
 extern void pnv_pci_init_ioda2_phb(struct device_node *np);
-- 
2.0.0

