Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab3FZGVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:21:13 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54436 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3FZGVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:21:12 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] powerpc/vfio: Add missing locks for take/release TCE table ownership
Date: Wed, 26 Jun 2013 16:21:02 +1000
Message-Id: <1372227662-28302-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO IOMMU driver for sPAPR TCE locks the whole DMA window by setting
ones to iommu_table.it_map. However this was not protected by the locks
which other clients of iommu_table use.

The patch fixes this.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

v1->v2:
* Fixed a potential warning from lockdep.

---
 arch/powerpc/kernel/iommu.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index b20ff17..5c1fc89 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1076,25 +1076,42 @@ EXPORT_SYMBOL_GPL(iommu_put_tce_user_mode);
 int iommu_take_ownership(struct iommu_table *tbl)
 {
 	unsigned long sz = (tbl->it_size + 7) >> 3;
+	unsigned long i, flags;
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
+		goto unlock_exit;
 	}
 
 	memset(tbl->it_map, 0xff, sz);
 	iommu_clear_tces_and_put_pages(tbl, tbl->it_offset, tbl->it_size);
 
-	return 0;
+unlock_exit:
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_unlock(&tbl->pools[i].lock);
+	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_take_ownership);
 
 void iommu_release_ownership(struct iommu_table *tbl)
 {
 	unsigned long sz = (tbl->it_size + 7) >> 3;
+	unsigned long i, flags;
+
+	spin_lock_irqsave(&tbl->large_pool.lock, flags);
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_lock(&tbl->pools[i].lock);
 
 	iommu_clear_tces_and_put_pages(tbl, tbl->it_offset, tbl->it_size);
 	memset(tbl->it_map, 0, sz);
@@ -1102,6 +1119,10 @@ void iommu_release_ownership(struct iommu_table *tbl)
 	/* Restore bit#0 set by iommu_init_table() */
 	if (tbl->it_offset == 0)
 		set_bit(0, tbl->it_map);
+
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_unlock(&tbl->pools[i].lock);
+	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
 }
 EXPORT_SYMBOL_GPL(iommu_release_ownership);
 
-- 
1.7.10.4

