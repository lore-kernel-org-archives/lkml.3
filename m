Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761300AbbA2JaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:30:19 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37579 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761241AbbA2JWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:30 -0500
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
Subject: [PATCH v3 09/24] powerpc/iommu: Fix IOMMU ownership control functions
Date: Thu, 29 Jan 2015 20:21:50 +1100
Message-Id: <1422523325-1389-10-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0013-0000-0000-000000BF16BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds missing locks in iommu_take_ownership()/
iommu_release_ownership().

This marks all pages busy in iommu_table::it_map in order to catch
errors if there is an attempt to use this table while ownership over it
is taken.

This only clears TCE content if there is no page marked busy in it_map.
Clearing must be done outside of the table locks as iommu_clear_tce()
called from iommu_clear_tces_and_put_pages() does this.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
Note: we might want to get rid of it as this patchset removes it_map
from tables passed to VFIO.

Changes:
v5:
* do not store bit#0 value, it has to be set for zero-based table
anyway
* removed test_and_clear_bit
* only disable bypass if succeeded
---
 arch/powerpc/kernel/iommu.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 952939f..407d0d6 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1024,33 +1024,48 @@ EXPORT_SYMBOL_GPL(iommu_tce_build);
 
 int iommu_take_ownership(struct iommu_table *tbl)
 {
-	unsigned long sz = (tbl->it_size + 7) >> 3;
+	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
+	int ret = 0;
+
+	spin_lock_irqsave(&tbl->large_pool.lock, flags);
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_lock(&tbl->pools[i].lock);
 
 	if (tbl->it_offset == 0)
 		clear_bit(0, tbl->it_map);
 
 	if (!bitmap_empty(tbl->it_map, tbl->it_size)) {
 		pr_err("iommu_tce: it_map is not empty");
-		return -EBUSY;
+		ret = -EBUSY;
+		if (tbl->it_offset == 0)
+			set_bit(0, tbl->it_map);
+	} else {
+		memset(tbl->it_map, 0xff, sz);
 	}
 
-	memset(tbl->it_map, 0xff, sz);
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_unlock(&tbl->pools[i].lock);
+	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
 
 	/*
 	 * Disable iommu bypass, otherwise the user can DMA to all of
 	 * our physical memory via the bypass window instead of just
 	 * the pages that has been explicitly mapped into the iommu
 	 */
-	if (tbl->set_bypass)
+	if (!ret && tbl->set_bypass)
 		tbl->set_bypass(tbl, false);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_take_ownership);
 
 void iommu_release_ownership(struct iommu_table *tbl)
 {
-	unsigned long sz = (tbl->it_size + 7) >> 3;
+	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
+
+	spin_lock_irqsave(&tbl->large_pool.lock, flags);
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_lock(&tbl->pools[i].lock);
 
 	memset(tbl->it_map, 0, sz);
 
@@ -1058,6 +1073,10 @@ void iommu_release_ownership(struct iommu_table *tbl)
 	if (tbl->it_offset == 0)
 		set_bit(0, tbl->it_map);
 
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_unlock(&tbl->pools[i].lock);
+	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
+
 	/* The kernel owns the device now, we can restore the iommu bypass */
 	if (tbl->set_bypass)
 		tbl->set_bypass(tbl, true);
-- 
2.0.0

