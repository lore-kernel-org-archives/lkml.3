Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965375AbaGPQ2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:28:14 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60991 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965341AbaGPQ2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:28:11 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: memcontrol: rewrite charge API fix - hugetlb charging
Date: Wed, 16 Jul 2014 12:28:00 -0400
Message-Id: <1405528080-2975-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya-san reports that hugetlb pages now get charged as file cache,
which wreaks all kinds of havoc during migration, uncharge etc.

The file-specific charge path used to filter PageCompound(), but it
wasn't commented and so it got lost when unifying the charge paths.

We can't add PageCompound() back into a unified charge path because of
THP, so filter huge pages directly in add_to_page_cache().

Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/filemap.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 114cd89c1cc2..c088ac01e856 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -31,6 +31,7 @@
 #include <linux/security.h>
 #include <linux/cpuset.h>
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
+#include <linux/hugetlb.h>
 #include <linux/memcontrol.h>
 #include <linux/cleancache.h>
 #include <linux/rmap.h>
@@ -560,19 +561,24 @@ static int __add_to_page_cache_locked(struct page *page,
 				      pgoff_t offset, gfp_t gfp_mask,
 				      void **shadowp)
 {
+	int huge = PageHuge(page);
 	struct mem_cgroup *memcg;
 	int error;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageSwapBacked(page), page);
 
-	error = mem_cgroup_try_charge(page, current->mm, gfp_mask, &memcg);
-	if (error)
-		return error;
+	if (!huge) {
+		error = mem_cgroup_try_charge(page, current->mm,
+					      gfp_mask, &memcg);
+		if (error)
+			return error;
+	}
 
 	error = radix_tree_maybe_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (error) {
-		mem_cgroup_cancel_charge(page, memcg);
+		if (!huge)
+			mem_cgroup_cancel_charge(page, memcg);
 		return error;
 	}
 
@@ -587,14 +593,16 @@ static int __add_to_page_cache_locked(struct page *page,
 		goto err_insert;
 	__inc_zone_page_state(page, NR_FILE_PAGES);
 	spin_unlock_irq(&mapping->tree_lock);
-	mem_cgroup_commit_charge(page, memcg, false);
+	if (!huge)
+		mem_cgroup_commit_charge(page, memcg, false);
 	trace_mm_filemap_add_to_page_cache(page);
 	return 0;
 err_insert:
 	page->mapping = NULL;
 	/* Leave page->index set: truncation relies upon it */
 	spin_unlock_irq(&mapping->tree_lock);
-	mem_cgroup_cancel_charge(page, memcg);
+	if (!huge)
+		mem_cgroup_cancel_charge(page, memcg);
 	page_cache_release(page);
 	return error;
 }
-- 
2.0.0

