Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3I0NjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:39:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab3I0N2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:28:18 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 27/63] mm: numa: Scan pages with elevated page_mapcount
Date: Fri, 27 Sep 2013 14:27:12 +0100
Message-Id: <1380288468-5551-28-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380288468-5551-1-git-send-email-mgorman@suse.de>
References: <1380288468-5551-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently automatic NUMA balancing is unable to distinguish between false
shared versus private pages except by ignoring pages with an elevated
page_mapcount entirely. This avoids shared pages bouncing between the
nodes whose task is using them but that is ignored quite a lot of data.

This patch kicks away the training wheels in preparation for adding support
for identifying shared/private pages is now in place. The ordering is so
that the impact of the shared/private detection can be easily measured. Note
that the patch does not migrate shared, file-backed within vmas marked
VM_EXEC as these are generally shared library pages. Migrating such pages
is not beneficial as there is an expectation they are read-shared between
caches and iTLB and iCache pressure is generally low.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/migrate.h |  7 ++++---
 mm/huge_memory.c        | 12 +++++-------
 mm/memory.c             |  7 ++-----
 mm/migrate.c            | 17 ++++++-----------
 mm/mprotect.c           |  4 +---
 5 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index a405d3dc..e7e26af 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -92,11 +92,12 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
-extern int migrate_misplaced_page(struct page *page, int node);
-extern int migrate_misplaced_page(struct page *page, int node);
+extern int migrate_misplaced_page(struct page *page,
+				  struct vm_area_struct *vma, int node);
 extern bool migrate_ratelimited(int node);
 #else
-static inline int migrate_misplaced_page(struct page *page, int node)
+static inline int migrate_misplaced_page(struct page *page,
+					 struct vm_area_struct *vma, int node)
 {
 	return -EAGAIN; /* can't migrate now */
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9f3e008..1f006d0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1496,14 +1496,12 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			struct page *page = pmd_page(*pmd);
 
 			/*
-			 * Only check non-shared pages. Do not trap faults
-			 * against the zero page. The read-only data is likely
-			 * to be read-cached on the local CPU cache and it is
-			 * less useful to know about local vs remote hits on
-			 * the zero page.
+			 * Do not trap faults against the zero page. The
+			 * read-only data is likely to be read-cached on the
+			 * local CPU cache and it is less useful to know about
+			 * local vs remote hits on the zero page.
 			 */
-			if (page_mapcount(page) == 1 &&
-			    !is_huge_zero_page(page) &&
+			if (!is_huge_zero_page(page) &&
 			    !pmd_numa(*pmd)) {
 				entry = pmdp_get_and_clear(mm, addr, pmd);
 				entry = pmd_mknuma(entry);
diff --git a/mm/memory.c b/mm/memory.c
index bd016c2..e335ec0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3588,7 +3588,7 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 
 	/* Migrate to the requested node */
-	migrated = migrate_misplaced_page(page, target_nid);
+	migrated = migrate_misplaced_page(page, vma, target_nid);
 	if (migrated)
 		page_nid = target_nid;
 
@@ -3653,16 +3653,13 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		page = vm_normal_page(vma, addr, pteval);
 		if (unlikely(!page))
 			continue;
-		/* only check non-shared pages */
-		if (unlikely(page_mapcount(page) != 1))
-			continue;
 
 		last_nid = page_nid_last(page);
 		page_nid = page_to_nid(page);
 		target_nid = numa_migrate_prep(page, vma, addr, page_nid);
 		pte_unmap_unlock(pte, ptl);
 		if (target_nid != -1) {
-			migrated = migrate_misplaced_page(page, target_nid);
+			migrated = migrate_misplaced_page(page, vma, target_nid);
 			if (migrated)
 				page_nid = target_nid;
 		} else {
diff --git a/mm/migrate.c b/mm/migrate.c
index a7146a0..e7191a3 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1596,7 +1596,8 @@ int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
  * node. Caller is expected to have an elevated reference count on
  * the page that will be dropped by this function before returning.
  */
-int migrate_misplaced_page(struct page *page, int node)
+int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
+			   int node)
 {
 	pg_data_t *pgdat = NODE_DATA(node);
 	int isolated;
@@ -1604,10 +1605,11 @@ int migrate_misplaced_page(struct page *page, int node)
 	LIST_HEAD(migratepages);
 
 	/*
-	 * Don't migrate pages that are mapped in multiple processes.
-	 * TODO: Handle false sharing detection instead of this hammer
+	 * Don't migrate file pages that are mapped in multiple processes
+	 * with execute permissions as they are probably shared libraries.
 	 */
-	if (page_mapcount(page) != 1)
+	if (page_mapcount(page) != 1 && page_is_file_cache(page) &&
+	    (vma->vm_flags & VM_EXEC))
 		goto out;
 
 	/*
@@ -1658,13 +1660,6 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	int page_lru = page_is_file_cache(page);
 
 	/*
-	 * Don't migrate pages that are mapped in multiple processes.
-	 * TODO: Handle false sharing detection instead of this hammer
-	 */
-	if (page_mapcount(page) != 1)
-		goto out_dropref;
-
-	/*
 	 * Rate-limit the amount of data that is being migrated to a node.
 	 * Optimal placement is no good if the memory bus is saturated and
 	 * all the time is being spent migrating!
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2da33dc..41e0292 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -69,9 +69,7 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 					if (last_nid != this_nid)
 						all_same_node = false;
 
-					/* only check non-shared pages */
-					if (!pte_numa(oldpte) &&
-					    page_mapcount(page) == 1) {
+					if (!pte_numa(oldpte)) {
 						ptent = pte_mknuma(ptent);
 						updated = true;
 					}
-- 
1.8.1.4

