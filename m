Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108Ab3K1Hsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:48:30 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59593 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3K1Hql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:46:41 -0500
X-AuditID: 9c93016f-b7b6aae000005fae-d2-5296f4dfab77
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/9] mm/rmap: factor lock function out of rmap_walk_anon()
Date: Thu, 28 Nov 2013 16:48:40 +0900
Message-Id: <1385624926-28883-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385624926-28883-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1385624926-28883-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we traverse anon_vma, we need to take a read-side anon_lock.
But there is subtle difference in the situation so that we can't use
same method to take a lock in each cases. Therefore, we need to make
rmap_walk_anon() taking difference lock function.

This patch is the first step, factoring lock function for anon_lock out
of rmap_walk_anon(). It will be used in case of removing migration entry
and in default of rmap_walk_anon().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/rmap.c b/mm/rmap.c
index e6d532c..916f2ed 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1683,6 +1683,24 @@ void __put_anon_vma(struct anon_vma *anon_vma)
 }
 
 #ifdef CONFIG_MIGRATION
+static struct anon_vma *rmap_walk_anon_lock(struct page *page)
+{
+	struct anon_vma *anon_vma;
+
+	/*
+	 * Note: remove_migration_ptes() cannot use page_lock_anon_vma_read()
+	 * because that depends on page_mapped(); but not all its usages
+	 * are holding mmap_sem. Users without mmap_sem are required to
+	 * take a reference count to prevent the anon_vma disappearing
+	 */
+	anon_vma = page_anon_vma(page);
+	if (!anon_vma)
+		return NULL;
+
+	anon_vma_lock_read(anon_vma);
+	return anon_vma;
+}
+
 /*
  * rmap_walk() and its helpers rmap_walk_anon() and rmap_walk_file():
  * Called by migrate.c to remove migration ptes, but might be used more later.
@@ -1695,16 +1713,10 @@ static int rmap_walk_anon(struct page *page, int (*rmap_one)(struct page *,
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
-	/*
-	 * Note: remove_migration_ptes() cannot use page_lock_anon_vma_read()
-	 * because that depends on page_mapped(); but not all its usages
-	 * are holding mmap_sem. Users without mmap_sem are required to
-	 * take a reference count to prevent the anon_vma disappearing
-	 */
-	anon_vma = page_anon_vma(page);
+	anon_vma = rmap_walk_anon_lock(page);
 	if (!anon_vma)
 		return ret;
-	anon_vma_lock_read(anon_vma);
+
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
-- 
1.7.9.5

