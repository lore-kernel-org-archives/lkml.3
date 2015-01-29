Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbbA2J1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:27:11 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37617 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761344AbbA2JWh (ORCPT
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
Subject: [PATCH v3 18/24] powerpc/iommu: Split iommu_free_table into 2 helpers
Date: Thu, 29 Jan 2015 20:21:59 +1100
Message-Id: <1422523325-1389-19-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0013-0000-0000-000000BF16DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iommu_free_table helper release memory it is using (the TCE table and
@it_map) and release the iommu_table struct as well. We might not want
the very last step as we store iommu_table in parent structures.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h |  1 +
 arch/powerpc/kernel/iommu.c      | 57 ++++++++++++++++++++++++----------------
 2 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index bf26d47..cc26eca 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -122,6 +122,7 @@ static inline void *get_iommu_table_base(struct device *dev)
 
 extern struct iommu_table *iommu_table_alloc(int node);
 /* Frees table for an individual device node */
+extern void iommu_reset_table(struct iommu_table *tbl, const char *node_name);
 extern void iommu_free_table(struct iommu_table *tbl, const char *node_name);
 
 /* Initializes an iommu_table based in values set in the passed-in
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 26feaff..5f87076 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -721,24 +721,46 @@ struct iommu_table *iommu_table_alloc(int node)
 	return &iommu->tables[0];
 }
 
+void iommu_reset_table(struct iommu_table *tbl, const char *node_name)
+{
+	if (!tbl)
+		return;
+
+	if (tbl->it_map) {
+		unsigned long bitmap_sz;
+		unsigned int order;
+
+		/*
+		 * In case we have reserved the first bit, we should not emit
+		 * the warning below.
+		 */
+		if (tbl->it_offset == 0)
+			clear_bit(0, tbl->it_map);
+
+		/* verify that table contains no entries */
+		if (!bitmap_empty(tbl->it_map, tbl->it_size))
+			pr_warn("%s: Unexpected TCEs for %s\n", __func__,
+					node_name);
+
+		/* calculate bitmap size in bytes */
+		bitmap_sz = BITS_TO_LONGS(tbl->it_size) * sizeof(unsigned long);
+
+		/* free bitmap */
+		order = get_order(bitmap_sz);
+		free_pages((unsigned long) tbl->it_map, order);
+	}
+
+	memset(tbl, 0, sizeof(*tbl));
+}
+
 void iommu_free_table(struct iommu_table *tbl, const char *node_name)
 {
-	unsigned long bitmap_sz;
-	unsigned int order;
 	struct powerpc_iommu *iommu = tbl->it_iommu;
 
-	if (!tbl || !tbl->it_map) {
-		printk(KERN_ERR "%s: expected TCE map for %s\n", __func__,
-				node_name);
+	if (!tbl)
 		return;
-	}
 
-	/*
-	 * In case we have reserved the first bit, we should not emit
-	 * the warning below.
-	 */
-	if (tbl->it_offset == 0)
-		clear_bit(0, tbl->it_map);
+	iommu_reset_table(tbl, node_name);
 
 #ifdef CONFIG_IOMMU_API
 	if (iommu->group) {
@@ -747,17 +769,6 @@ void iommu_free_table(struct iommu_table *tbl, const char *node_name)
 	}
 #endif
 
-	/* verify that table contains no entries */
-	if (!bitmap_empty(tbl->it_map, tbl->it_size))
-		pr_warn("%s: Unexpected TCEs for %s\n", __func__, node_name);
-
-	/* calculate bitmap size in bytes */
-	bitmap_sz = BITS_TO_LONGS(tbl->it_size) * sizeof(unsigned long);
-
-	/* free bitmap */
-	order = get_order(bitmap_sz);
-	free_pages((unsigned long) tbl->it_map, order);
-
 	/* free table */
 	kfree(iommu);
 }
-- 
2.0.0

