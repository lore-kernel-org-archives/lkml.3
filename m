Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbaIWDFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 23:05:42 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:57932 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaIWDBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 23:01:13 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 01/13] powerpc/iommu: Check that TCE page size is equal to it_page_size
Date: Tue, 23 Sep 2014 13:00:50 +1000
Message-Id: <1411441262-11025-2-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1411441262-11025-1-git-send-email-aik@ozlabs.ru>
References: <1411441262-11025-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092303-0013-0000-0000-00000041E4F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This checks that the TCE table page size is not bigger that the size of
a page we just pinned and going to put its physical address to the table.

Otherwise the hardware gets unwanted access to physical memory between
the end of the actual page and the end of the aligned up TCE page.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/kernel/iommu.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index a10642a..b378f78 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -38,6 +38,7 @@
 #include <linux/pci.h>
 #include <linux/iommu.h>
 #include <linux/sched.h>
+#include <linux/hugetlb.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/iommu.h>
@@ -1059,16 +1060,37 @@ int iommu_put_tce_user_mode(struct iommu_table *tbl, unsigned long entry,
 				tce, entry << tbl->it_page_shift, ret); */
 		return -EFAULT;
 	}
+
+	/*
+	 * Check that the TCE table granularity is not bigger than the size of
+	 * a page we just found. Otherwise the hardware can get access to
+	 * a bigger memory chunk that it should.
+	 */
+	if (PageHuge(page)) {
+		struct page *head = compound_head(page);
+		long shift = PAGE_SHIFT + compound_order(head);
+
+		if (shift < tbl->it_page_shift) {
+			ret = -EINVAL;
+			goto put_page_exit;
+		}
+
+	}
+
 	hwaddr = (unsigned long) page_address(page) + offset;
 
 	ret = iommu_tce_build(tbl, entry, hwaddr, direction);
 	if (ret)
-		put_page(page);
+		goto put_page_exit;
 
-	if (ret < 0)
-		pr_err("iommu_tce: %s failed ioba=%lx, tce=%lx, ret=%d\n",
+	return 0;
+
+put_page_exit:
+	pr_err("iommu_tce: %s failed ioba=%lx, tce=%lx, ret=%d\n",
 			__func__, entry << tbl->it_page_shift, tce, ret);
 
+	put_page(page);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_put_tce_user_mode);
-- 
2.0.0

