Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3LDAKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:10:34 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54050 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3LDAKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:10:24 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-50-529e72eb30d7
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 9/9] mm/rmap: use rmap_walk() in page_mkclean()
Date: Wed,  4 Dec 2013 09:12:20 +0900
Message-Id: <1386115940-21425-10-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386115940-21425-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1386115940-21425-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we have an infrastructure in rmap_walk() to handle difference
from variants of rmap traversing functions.

So, just use it in page_mkclean().

In this patch, I change following things.

1. remove some variants of rmap traversing functions.
    cf> page_mkclean_file
2. mechanical change to use rmap_walk() in page_mkclean().

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/rmap.c b/mm/rmap.c
index 7944d4b..d792e71 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -808,12 +808,13 @@ int page_referenced(struct page *page,
 }
 
 static int page_mkclean_one(struct page *page, struct vm_area_struct *vma,
-			    unsigned long address)
+			    unsigned long address, void *arg)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte;
 	spinlock_t *ptl;
 	int ret = 0;
+	int *cleaned = arg;
 
 	pte = page_check_address(page, mm, address, &ptl, 1);
 	if (!pte)
@@ -832,44 +833,44 @@ static int page_mkclean_one(struct page *page, struct vm_area_struct *vma,
 
 	pte_unmap_unlock(pte, ptl);
 
-	if (ret)
+	if (ret) {
 		mmu_notifier_invalidate_page(mm, address);
+		(*cleaned)++;
+	}
 out:
-	return ret;
+	return SWAP_AGAIN;
 }
 
-static int page_mkclean_file(struct address_space *mapping, struct page *page)
+static bool invalid_mkclean_vma(struct vm_area_struct *vma, void *arg)
 {
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
-	struct vm_area_struct *vma;
-	int ret = 0;
-
-	BUG_ON(PageAnon(page));
+	if (vma->vm_flags & VM_SHARED)
+		return 0;
 
-	mutex_lock(&mapping->i_mmap_mutex);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
-		if (vma->vm_flags & VM_SHARED) {
-			unsigned long address = vma_address(page, vma);
-			ret += page_mkclean_one(page, vma, address);
-		}
-	}
-	mutex_unlock(&mapping->i_mmap_mutex);
-	return ret;
+	return 1;
 }
 
 int page_mkclean(struct page *page)
 {
-	int ret = 0;
+	int cleaned = 0;
+	struct address_space *mapping;
+	struct rmap_walk_control rwc = {
+		.arg = (void *)&cleaned,
+		.rmap_one = page_mkclean_one,
+		.invalid_vma = invalid_mkclean_vma,
+	};
 
 	BUG_ON(!PageLocked(page));
 
-	if (page_mapped(page)) {
-		struct address_space *mapping = page_mapping(page);
-		if (mapping)
-			ret = page_mkclean_file(mapping, page);
-	}
+	if (!page_mapped(page))
+		return 0;
 
-	return ret;
+	mapping = page_mapping(page);
+	if (!mapping)
+		return 0;
+
+	rmap_walk(page, &rwc);
+
+	return cleaned;
 }
 EXPORT_SYMBOL_GPL(page_mkclean);
 
-- 
1.7.9.5

