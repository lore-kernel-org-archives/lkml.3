Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbbA2JZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:25:31 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:49021 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761403AbbA2JWj (ORCPT
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
Subject: [PATCH v3 22/24] powerpc/iommu: Get rid of ownership helpers
Date: Thu, 29 Jan 2015 20:22:03 +1100
Message-Id: <1422523325-1389-23-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0009-0000-0000-000000DE6C58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu_take_ownership/iommu_release_ownership used to be used to mark
bits in iommu_table::it_map. Since the IOMMU tables are recreated for
VFIO, it_map is always NULL.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h |  2 -
 arch/powerpc/kernel/iommu.c      | 96 ----------------------------------------
 2 files changed, 98 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 8393822..33009f9 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -272,8 +272,6 @@ extern long iommu_tce_xchg(struct iommu_table *tbl, unsigned long entry,
 		enum dma_data_direction direction);
 
 extern void iommu_flush_tce(struct iommu_table *tbl);
-extern int iommu_take_ownership(struct powerpc_iommu *iommu);
-extern void iommu_release_ownership(struct powerpc_iommu *iommu);
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_IOMMU_H */
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 5f87076..6987115 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1007,102 +1007,6 @@ long iommu_tce_xchg(struct iommu_table *tbl, unsigned long entry,
 }
 EXPORT_SYMBOL_GPL(iommu_tce_xchg);
 
-static int iommu_table_take_ownership(struct iommu_table *tbl)
-{
-	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
-	int ret = 0;
-
-	/*
-	 * VFIO does not control TCE entries allocation and the guest
-	 * can write new TCEs on top of existing ones so iommu_tce_build()
-	 * must be able to release old pages. This functionality
-	 * requires exchange() callback defined so if it is not
-	 * implemented, we disallow taking ownership over the table.
-	 */
-	if (!tbl->it_ops->exchange)
-		return -EINVAL;
-
-	spin_lock_irqsave(&tbl->large_pool.lock, flags);
-	for (i = 0; i < tbl->nr_pools; i++)
-		spin_lock(&tbl->pools[i].lock);
-
-	if (tbl->it_offset == 0)
-		clear_bit(0, tbl->it_map);
-
-	if (!bitmap_empty(tbl->it_map, tbl->it_size)) {
-		pr_err("iommu_tce: it_map is not empty");
-		ret = -EBUSY;
-		if (tbl->it_offset == 0)
-			set_bit(0, tbl->it_map);
-	} else {
-		memset(tbl->it_map, 0xff, sz);
-	}
-
-	for (i = 0; i < tbl->nr_pools; i++)
-		spin_unlock(&tbl->pools[i].lock);
-	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
-
-	return 0;
-}
-
-static void iommu_table_release_ownership(struct iommu_table *tbl);
-
-int iommu_take_ownership(struct powerpc_iommu *iommu)
-{
-	int i, j, rc = 0;
-
-	for (i = 0; i < POWERPC_IOMMU_MAX_TABLES; ++i) {
-		struct iommu_table *tbl = &iommu->tables[i];
-
-		if (!tbl->it_map)
-			continue;
-
-		rc = iommu_table_take_ownership(tbl);
-		if (rc) {
-			for (j = 0; j < i; ++j)
-				iommu_table_release_ownership(
-						&iommu->tables[j]);
-
-			return rc;
-		}
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(iommu_take_ownership);
-
-static void iommu_table_release_ownership(struct iommu_table *tbl)
-{
-	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
-
-	spin_lock_irqsave(&tbl->large_pool.lock, flags);
-	for (i = 0; i < tbl->nr_pools; i++)
-		spin_lock(&tbl->pools[i].lock);
-
-	memset(tbl->it_map, 0, sz);
-
-	/* Restore bit#0 set by iommu_init_table() */
-	if (tbl->it_offset == 0)
-		set_bit(0, tbl->it_map);
-
-	for (i = 0; i < tbl->nr_pools; i++)
-		spin_unlock(&tbl->pools[i].lock);
-	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
-}
-
-extern void iommu_release_ownership(struct powerpc_iommu *iommu)
-{
-	int i;
-
-	for (i = 0; i < POWERPC_IOMMU_MAX_TABLES; ++i) {
-		struct iommu_table *tbl = &iommu->tables[i];
-
-		if (tbl->it_map)
-			iommu_table_release_ownership(tbl);
-	}
-}
-EXPORT_SYMBOL_GPL(iommu_release_ownership);
-
 int iommu_add_device(struct device *dev)
 {
 	struct iommu_table *tbl;
-- 
2.0.0

