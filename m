Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaH2H7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:59:33 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:54363 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbaH2H72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:59:28 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        cbe-oss-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH 04/13] powerpc/powernv: Convert/move set_bypass() callback to take_ownership()
Date: Fri, 29 Aug 2014 17:59:07 +1000
Message-Id: <1409299156-618-5-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
References: <1409299156-618-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082907-0013-0000-0000-0000002A8F60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment the iommu_table struct has a set_bypass() which enables/
disables DMA bypass on IODA2 PHB. This is exposed to POWERPC IOMMU code
which calls this callback when external IOMMU users such as VFIO are
about to get over a PHB.

Since the set_bypass() is not really an iommu_table function but PE's
function, and we have an ops struct per IOMMU owner, let's move
set_bypass() to the spapr_tce_iommu_ops struct.

As arch/powerpc/kernel/iommu.c is more about POWERPC IOMMU tables and
has very little to do with PEs, this moves take_ownership() calls to
the VFIO SPAPR TCE driver.

This renames set_bypass() to take_ownership() as it is not necessarily
just enabling bypassing, it can be something else/more so let's give it
a generic name. The bool parameter is inverted.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/iommu.h          |  1 -
 arch/powerpc/include/asm/tce.h            |  2 ++
 arch/powerpc/kernel/iommu.c               | 12 ------------
 arch/powerpc/platforms/powernv/pci-ioda.c | 20 ++++++++++++--------
 drivers/vfio/vfio_iommu_spapr_tce.c       | 16 ++++++++++++++++
 5 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 84ee339..2b0b01d 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -77,7 +77,6 @@ struct iommu_table {
 #ifdef CONFIG_IOMMU_API
 	struct iommu_group *it_group;
 #endif
-	void (*set_bypass)(struct iommu_table *tbl, bool enable);
 };
 
 /* Pure 2^n version of get_order */
diff --git a/arch/powerpc/include/asm/tce.h b/arch/powerpc/include/asm/tce.h
index 9f159eb..e6355f9 100644
--- a/arch/powerpc/include/asm/tce.h
+++ b/arch/powerpc/include/asm/tce.h
@@ -56,6 +56,8 @@ struct spapr_tce_iommu_ops {
 	struct iommu_table *(*get_table)(
 			struct spapr_tce_iommu_group *data,
 			int num);
+	void (*take_ownership)(struct spapr_tce_iommu_group *data,
+			bool enable);
 };
 
 struct spapr_tce_iommu_group {
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 1c5dae7..c2c8d9d 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1139,14 +1139,6 @@ int iommu_take_ownership(struct iommu_table *tbl)
 	memset(tbl->it_map, 0xff, sz);
 	iommu_clear_tces_and_put_pages(tbl, tbl->it_offset, tbl->it_size);
 
-	/*
-	 * Disable iommu bypass, otherwise the user can DMA to all of
-	 * our physical memory via the bypass window instead of just
-	 * the pages that has been explicitly mapped into the iommu
-	 */
-	if (tbl->set_bypass)
-		tbl->set_bypass(tbl, false);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iommu_take_ownership);
@@ -1161,10 +1153,6 @@ void iommu_release_ownership(struct iommu_table *tbl)
 	/* Restore bit#0 set by iommu_init_table() */
 	if (tbl->it_offset == 0)
 		set_bit(0, tbl->it_map);
-
-	/* The kernel owns the device now, we can restore the iommu bypass */
-	if (tbl->set_bypass)
-		tbl->set_bypass(tbl, true);
 }
 EXPORT_SYMBOL_GPL(iommu_release_ownership);
 
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 2d32a1c..8cb2f31 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1105,10 +1105,8 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 		__free_pages(tce_mem, get_order(TCE32_TABLE_SIZE * segs));
 }
 
-static void pnv_pci_ioda2_set_bypass(struct iommu_table *tbl, bool enable)
+static void pnv_pci_ioda2_set_bypass(struct pnv_ioda_pe *pe, bool enable)
 {
-	struct pnv_ioda_pe *pe = container_of(tbl, struct pnv_ioda_pe,
-					      tce32.table);
 	uint16_t window_id = (pe->pe_number << 1 ) + 1;
 	int64_t rc;
 
@@ -1136,7 +1134,7 @@ static void pnv_pci_ioda2_set_bypass(struct iommu_table *tbl, bool enable)
 		 * host side.
 		 */
 		if (pe->pdev)
-			set_iommu_table_base(&pe->pdev->dev, tbl);
+			set_iommu_table_base(&pe->pdev->dev, &pe->tce32.table);
 		else
 			pnv_ioda_setup_bus_dma(pe, pe->pbus, false);
 	}
@@ -1152,15 +1150,21 @@ static void pnv_pci_ioda2_setup_bypass_pe(struct pnv_phb *phb,
 	/* TVE #1 is selected by PCI address bit 59 */
 	pe->tce_bypass_base = 1ull << 59;
 
-	/* Install set_bypass callback for VFIO */
-	pe->tce32.table.set_bypass = pnv_pci_ioda2_set_bypass;
-
 	/* Enable bypass by default */
-	pnv_pci_ioda2_set_bypass(&pe->tce32.table, true);
+	pnv_pci_ioda2_set_bypass(pe, true);
+}
+
+static void pnv_ioda2_take_ownership(struct spapr_tce_iommu_group *data,
+				     bool enable)
+{
+	struct pnv_ioda_pe *pe = data->iommu_owner;
+
+	pnv_pci_ioda2_set_bypass(pe, !enable);
 }
 
 static struct spapr_tce_iommu_ops pnv_pci_ioda2_ops = {
 	.get_table = pnv_ioda1_iommu_get_table,
+	.take_ownership = pnv_ioda2_take_ownership,
 };
 
 static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index a8adfbd..1c1a9c4 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -76,6 +76,13 @@ static struct iommu_table *spapr_tce_find_table(
 	return ret;
 }
 
+static void tce_iommu_take_ownership_notify(struct spapr_tce_iommu_group *data,
+		bool enable)
+{
+	if (data && data->ops && data->ops->take_ownership)
+		data->ops->take_ownership(data, enable);
+}
+
 static int tce_iommu_enable(struct tce_container *container)
 {
 	int ret = 0;
@@ -413,6 +420,12 @@ static int tce_iommu_attach_group(void *iommu_data,
 		ret = iommu_take_ownership(tbl);
 		if (!ret)
 			container->grp = iommu_group;
+		/*
+		 * Disable iommu bypass, otherwise the user can DMA to all of
+		 * our physical memory via the bypass window instead of just
+		 * the pages that has been explicitly mapped into the iommu
+		 */
+		tce_iommu_take_ownership_notify(data, true);
 	}
 
 	mutex_unlock(&container->lock);
@@ -450,6 +463,9 @@ static void tce_iommu_detach_group(void *iommu_data,
 		BUG_ON(!tbl);
 
 		iommu_release_ownership(tbl);
+
+		/* Kernel owns the device now, we can restore bypass */
+		tce_iommu_take_ownership_notify(data, false);
 	}
 	mutex_unlock(&container->lock);
 }
-- 
2.0.0

