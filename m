Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab3KUNBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:01:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:13400 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345Ab3KUNBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:01:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,744,1378882800"; 
   d="scan'208";a="431470814"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] mm: place page->pmd_huge_pte to right union
Date: Thu, 21 Nov 2013 15:00:10 +0200
Message-Id: <1385038810-15513-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know what went wrong, mis-merge or something, but ->pmd_huge_pte
placed in wrong union within struct page.

In original patch[1] it's placed to union with ->lru and ->slab, but in
commit e009bb30c8df it's in union with ->index and ->freelist.

That union seems also unused for pages with table tables and safe to
re-use, but it's not what I've tested.

Let's move it to original place. It fixes indentation at least. :)

[1] https://lkml.org/lkml/2013/10/7/288

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm_types.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 10f5a7272b80..011eb85d7b0f 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -65,9 +65,6 @@ struct page {
 						 * this page is only used to
 						 * free other pages.
 						 */
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
-		pgtable_t pmd_huge_pte; /* protected by page->ptl */
-#endif
 		};
 
 		union {
@@ -135,6 +132,9 @@ struct page {
 
 		struct list_head list;	/* slobs list of pages */
 		struct slab *slab_page; /* slab fields */
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && USE_SPLIT_PMD_PTLOCKS
+		pgtable_t pmd_huge_pte; /* protected by page->ptl */
+#endif
 	};
 
 	/* Remainder is not double word aligned */
-- 
1.8.4.3

