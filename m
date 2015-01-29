Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761061AbbA2J2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:28:45 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57946 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759676AbbA2JWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:34 -0500
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
Subject: [PATCH v3 07/24] powerpc/iommu: Introduce iommu_table_alloc() helper
Date: Thu, 29 Jan 2015 20:21:48 +1100
Message-Id: <1422523325-1389-8-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0033-0000-0000-000000FE0B54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces multiple calls of kzalloc_node() with a new
iommu_table_alloc() helper. Right now it calls kzalloc_node() but
later it will be modified to allocate a powerpc_iommu struct with
a single iommu_table in it.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h       |  1 +
 arch/powerpc/kernel/iommu.c            |  9 +++++++++
 arch/powerpc/platforms/powernv/pci.c   |  2 +-
 arch/powerpc/platforms/pseries/iommu.c | 12 ++++--------
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index eb5822d..335e3d4 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -117,6 +117,7 @@ static inline void *get_iommu_table_base(struct device *dev)
 	return dev->archdata.dma_data.iommu_table_base;
 }
 
+extern struct iommu_table *iommu_table_alloc(int node);
 /* Frees table for an individual device node */
 extern void iommu_free_table(struct iommu_table *tbl, const char *node_name);
 
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index c51ad3e..2f7e92b 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -710,6 +710,15 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 	return tbl;
 }
 
+struct iommu_table *iommu_table_alloc(int node)
+{
+	struct iommu_table *tbl;
+
+	tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL, node);
+
+	return tbl;
+}
+
 void iommu_free_table(struct iommu_table *tbl, const char *node_name)
 {
 	unsigned long bitmap_sz;
diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index c4782b1..bbe529b 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -693,7 +693,7 @@ static struct iommu_table *pnv_pci_setup_bml_iommu(struct pci_controller *hose)
 		       hose->dn->full_name);
 		return NULL;
 	}
-	tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL, hose->node);
+	tbl = iommu_table_alloc(hose->node);
 	if (WARN_ON(!tbl))
 		return NULL;
 	pnv_pci_setup_iommu_table(tbl, __va(be64_to_cpup(basep)),
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 1aa1815..bc14299 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -617,8 +617,7 @@ static void pci_dma_bus_setup_pSeries(struct pci_bus *bus)
 	pci->phb->dma_window_size = 0x8000000ul;
 	pci->phb->dma_window_base_cur = 0x8000000ul;
 
-	tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL,
-			   pci->phb->node);
+	tbl = iommu_table_alloc(pci->phb->node);
 
 	iommu_table_setparms(pci->phb, dn, tbl);
 	tbl->it_ops = &iommu_table_pseries_ops;
@@ -669,8 +668,7 @@ static void pci_dma_bus_setup_pSeriesLP(struct pci_bus *bus)
 		 pdn->full_name, ppci->iommu_table);
 
 	if (!ppci->iommu_table) {
-		tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL,
-				   ppci->phb->node);
+		tbl = iommu_table_alloc(ppci->phb->node);
 		iommu_table_setparms_lpar(ppci->phb, pdn, tbl, dma_window);
 		tbl->it_ops = &iommu_table_lpar_multi_ops;
 		ppci->iommu_table = iommu_init_table(tbl, ppci->phb->node);
@@ -697,8 +695,7 @@ static void pci_dma_dev_setup_pSeries(struct pci_dev *dev)
 		struct pci_controller *phb = PCI_DN(dn)->phb;
 
 		pr_debug(" --> first child, no bridge. Allocating iommu table.\n");
-		tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL,
-				   phb->node);
+		tbl = iommu_table_alloc(phb->node);
 		iommu_table_setparms(phb, dn, tbl);
 		tbl->it_ops = &iommu_table_pseries_ops;
 		PCI_DN(dn)->iommu_table = iommu_init_table(tbl, phb->node);
@@ -1120,8 +1117,7 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 
 	pci = PCI_DN(pdn);
 	if (!pci->iommu_table) {
-		tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL,
-				   pci->phb->node);
+		tbl = iommu_table_alloc(pci->phb->node);
 		iommu_table_setparms_lpar(pci->phb, pdn, tbl, dma_window);
 		tbl->it_ops = &iommu_table_lpar_multi_ops;
 		pci->iommu_table = iommu_init_table(tbl, pci->phb->node);
-- 
2.0.0

