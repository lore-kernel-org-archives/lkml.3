Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbbA2J1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:27:13 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:57953 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761336AbbA2JWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:37 -0500
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
Subject: [PATCH v3 10/24] powerpc/powernv/ioda2: Rework IOMMU ownership control
Date: Thu, 29 Jan 2015 20:21:51 +1100
Message-Id: <1422523325-1389-11-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0033-0000-0000-000000FE0B63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment the iommu_table struct has a set_bypass() which enables/
disables DMA bypass on IODA2 PHB. This is exposed to POWERPC IOMMU code
which calls this callback when external IOMMU users such as VFIO are
about to get over a PHB.

The set_bypass() callback is not really an iommu_table function but
IOMMU/PE function. This introduces a powerpc_iommu_ops struct and
adds a set_ownership() callback to it which is called when an external
user takes control over the IOMMU.

This renames set_bypass() to set_ownership() as it is not necessarily
just enabling bypassing, it can be something else/more so let's give it
more generic name. The bool parameter is inverted.

The callback is implemented for IODA2 only.

This replaces iommu_take_ownership()/iommu_release_ownership() calls
with the callback calls and it is up to the platform code to call
iommu_take_ownership()/iommu_release_ownership() if needed. Next patches
will remove these calls from IODA2 code.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h          | 18 +++++++++--
 arch/powerpc/kernel/iommu.c               | 53 +++++++++++++++++++++++--------
 arch/powerpc/platforms/powernv/pci-ioda.c | 30 ++++++++++++-----
 drivers/vfio/vfio_iommu_spapr_tce.c       | 19 ++++++++---
 4 files changed, 90 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 4fe5555..ba16aa0 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -92,7 +92,6 @@ struct iommu_table {
 	unsigned long  it_page_shift;/* table iommu page size */
 	struct powerpc_iommu *it_iommu;
 	struct iommu_table_ops *it_ops;
-	void (*set_bypass)(struct iommu_table *tbl, bool enable);
 };
 
 /* Pure 2^n version of get_order */
@@ -127,11 +126,24 @@ extern struct iommu_table *iommu_init_table(struct iommu_table * tbl,
 
 #define POWERPC_IOMMU_MAX_TABLES	1
 
+struct powerpc_iommu;
+
+struct powerpc_iommu_ops {
+	/*
+	 * Switches ownership from the kernel itself to an external
+	 * user. While onwership is enabled, the kernel cannot use IOMMU
+	 * for itself.
+	 */
+	void (*set_ownership)(struct powerpc_iommu *iommu,
+			bool enable);
+};
+
 struct powerpc_iommu {
 #ifdef CONFIG_IOMMU_API
 	struct iommu_group *group;
 #endif
 	struct iommu_table tables[POWERPC_IOMMU_MAX_TABLES];
+	struct powerpc_iommu_ops *ops;
 };
 
 #ifdef CONFIG_IOMMU_API
@@ -219,8 +231,8 @@ extern unsigned long iommu_clear_tce(struct iommu_table *tbl,
 		unsigned long entry);
 
 extern void iommu_flush_tce(struct iommu_table *tbl);
-extern int iommu_take_ownership(struct iommu_table *tbl);
-extern void iommu_release_ownership(struct iommu_table *tbl);
+extern int iommu_take_ownership(struct powerpc_iommu *iommu);
+extern void iommu_release_ownership(struct powerpc_iommu *iommu);
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_IOMMU_H */
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 407d0d6..9d06425 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1022,7 +1022,7 @@ int iommu_tce_build(struct iommu_table *tbl, unsigned long entry,
 }
 EXPORT_SYMBOL_GPL(iommu_tce_build);
 
-int iommu_take_ownership(struct iommu_table *tbl)
+static int iommu_table_take_ownership(struct iommu_table *tbl)
 {
 	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
 	int ret = 0;
@@ -1047,19 +1047,36 @@ int iommu_take_ownership(struct iommu_table *tbl)
 		spin_unlock(&tbl->pools[i].lock);
 	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
 
-	/*
-	 * Disable iommu bypass, otherwise the user can DMA to all of
-	 * our physical memory via the bypass window instead of just
-	 * the pages that has been explicitly mapped into the iommu
-	 */
-	if (!ret && tbl->set_bypass)
-		tbl->set_bypass(tbl, false);
-
-	return ret;
+	return 0;
+}
+
+static void iommu_table_release_ownership(struct iommu_table *tbl);
+
+int iommu_take_ownership(struct powerpc_iommu *iommu)
+{
+	int i, j, rc = 0;
+
+	for (i = 0; i < POWERPC_IOMMU_MAX_TABLES; ++i) {
+		struct iommu_table *tbl = &iommu->tables[i];
+
+		if (!tbl->it_map)
+			continue;
+
+		rc = iommu_table_take_ownership(tbl);
+		if (rc) {
+			for (j = 0; j < i; ++j)
+				iommu_table_release_ownership(
+						&iommu->tables[j]);
+
+			return rc;
+		}
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(iommu_take_ownership);
 
-void iommu_release_ownership(struct iommu_table *tbl)
+static void iommu_table_release_ownership(struct iommu_table *tbl)
 {
 	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
 
@@ -1076,10 +1093,18 @@ void iommu_release_ownership(struct iommu_table *tbl)
 	for (i = 0; i < tbl->nr_pools; i++)
 		spin_unlock(&tbl->pools[i].lock);
 	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
+}
 
-	/* The kernel owns the device now, we can restore the iommu bypass */
-	if (tbl->set_bypass)
-		tbl->set_bypass(tbl, true);
+extern void iommu_release_ownership(struct powerpc_iommu *iommu)
+{
+	int i;
+
+	for (i = 0; i < POWERPC_IOMMU_MAX_TABLES; ++i) {
+		struct iommu_table *tbl = &iommu->tables[i];
+
+		if (tbl->it_map)
+			iommu_table_release_ownership(tbl);
+	}
 }
 EXPORT_SYMBOL_GPL(iommu_release_ownership);
 
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 8ab00e3..a33a116 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1231,10 +1231,8 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
 		__free_pages(tce_mem, get_order(TCE32_TABLE_SIZE * segs));
 }
 
-static void pnv_pci_ioda2_set_bypass(struct iommu_table *tbl, bool enable)
+static void pnv_pci_ioda2_set_bypass(struct pnv_ioda_pe *pe, bool enable)
 {
-	struct pnv_ioda_pe *pe = container_of(tbl->it_iommu, struct pnv_ioda_pe,
-					      iommu);
 	uint16_t window_id = (pe->pe_number << 1 ) + 1;
 	int64_t rc;
 
@@ -1262,7 +1260,8 @@ static void pnv_pci_ioda2_set_bypass(struct iommu_table *tbl, bool enable)
 		 * host side.
 		 */
 		if (pe->pdev)
-			set_iommu_table_base(&pe->pdev->dev, tbl);
+			set_iommu_table_base(&pe->pdev->dev,
+					&pe->iommu.tables[0]);
 		else
 			pnv_ioda_setup_bus_dma(pe, pe->pbus, false);
 	}
@@ -1278,13 +1277,27 @@ static void pnv_pci_ioda2_setup_bypass_pe(struct pnv_phb *phb,
 	/* TVE #1 is selected by PCI address bit 59 */
 	pe->tce_bypass_base = 1ull << 59;
 
-	/* Install set_bypass callback for VFIO */
-	pe->iommu.tables[0].set_bypass = pnv_pci_ioda2_set_bypass;
-
 	/* Enable bypass by default */
-	pnv_pci_ioda2_set_bypass(&pe->iommu.tables[0], true);
+	pnv_pci_ioda2_set_bypass(pe, true);
 }
 
+static void pnv_ioda2_set_ownership(struct powerpc_iommu *iommu,
+				     bool enable)
+{
+	struct pnv_ioda_pe *pe = container_of(iommu, struct pnv_ioda_pe,
+						iommu);
+	if (enable)
+		iommu_take_ownership(iommu);
+	else
+		iommu_release_ownership(iommu);
+
+	pnv_pci_ioda2_set_bypass(pe, !enable);
+}
+
+static struct powerpc_iommu_ops pnv_pci_ioda2_ops = {
+	.set_ownership = pnv_ioda2_set_ownership,
+};
+
 static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 				       struct pnv_ioda_pe *pe)
 {
@@ -1352,6 +1365,7 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
 	}
 	tbl->it_ops = &pnv_iommu_ops;
 	iommu_init_table(tbl, phb->hose->node);
+	pe->iommu.ops = &pnv_pci_ioda2_ops;
 	iommu_register_group(&pe->iommu, phb->hose->global_number,
 			pe->pe_number);
 
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 28909e1..bcde2ef 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -478,7 +478,7 @@ static long tce_iommu_ioctl(void *iommu_data,
 static int tce_iommu_attach_group(void *iommu_data,
 		struct iommu_group *iommu_group)
 {
-	int ret;
+	int ret = 0;
 	struct tce_container *container = iommu_data;
 	struct powerpc_iommu *iommu;
 
@@ -499,10 +499,17 @@ static int tce_iommu_attach_group(void *iommu_data,
 		iommu = iommu_group_get_iommudata(iommu_group);
 		if (WARN_ON_ONCE(!iommu))
 			return -ENXIO;
-
-		ret = iommu_take_ownership(&iommu->tables[0]);
-		if (!ret)
+		/*
+		 * Disable iommu bypass, otherwise the user can DMA to all of
+		 * our physical memory via the bypass window instead of just
+		 * the pages that has been explicitly mapped into the iommu
+		 */
+		if (iommu->ops && iommu->ops->set_ownership) {
+			iommu->ops->set_ownership(iommu, true);
 			container->grp = iommu_group;
+		} else {
+			return -ENODEV;
+		}
 	}
 
 	mutex_unlock(&container->lock);
@@ -539,7 +546,9 @@ static void tce_iommu_detach_group(void *iommu_data,
 				iommu->tables[0].it_offset,
 				iommu->tables[0].it_size);
 
-		iommu_release_ownership(&iommu->tables[0]);
+		/* Kernel owns the device now, we can restore bypass */
+		if (iommu->ops && iommu->ops->set_ownership)
+			iommu->ops->set_ownership(iommu, false);
 	}
 	mutex_unlock(&container->lock);
 }
-- 
2.0.0

