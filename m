Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3CZWd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:33:58 -0400
Received: from 8bytes.org ([85.214.48.195]:46343 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab3CZWd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:33:57 -0400
From: Joerg Roedel <joro@8bytes.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] staging: zsmalloc: Fix link error on ARM
Date: Tue, 26 Mar 2013 23:33:52 +0100
Message-Id: <1364337232-3513-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Mar 26 23:33:55 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5152225323671180521336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Testing the arm chromebook config against the upstream
kernel produces a linker error for the zsmalloc module from
staging. The symbol flush_tlb_kernel_range is not available
there. Fix this by removing the reimplementation of
unmap_kernel_range in the zsmalloc module and using the
function directly.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |    5 +----
 mm/vmalloc.c                             |    1 +
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index e78d262..324e123 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -656,11 +656,8 @@ static inline void __zs_unmap_object(struct mapping_area *area,
 				struct page *pages[2], int off, int size)
 {
 	unsigned long addr = (unsigned long)area->vm_addr;
-	unsigned long end = addr + (PAGE_SIZE * 2);
 
-	flush_cache_vunmap(addr, end);
-	unmap_kernel_range_noflush(addr, PAGE_SIZE * 2);
-	flush_tlb_kernel_range(addr, end);
+	unmap_kernel_range(addr, PAGE_SIZE * 2);
 }
 
 #else /* USE_PGTABLE_MAPPING */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0f751f2..f7cba11 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1266,6 +1266,7 @@ void unmap_kernel_range(unsigned long addr, unsigned long size)
 	vunmap_page_range(addr, end);
 	flush_tlb_kernel_range(addr, end);
 }
+EXPORT_SYMBOL_GPL(unmap_kernel_range);
 
 int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page ***pages)
 {
-- 
1.7.9.5


