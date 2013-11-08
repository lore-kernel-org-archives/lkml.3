Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab3KHCTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:19:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34691 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab3KHCSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:18:55 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Simon Jeons <simon.jeons@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 75/91] mm: numa: cleanup flow of transhuge page migration
Date: Thu,  7 Nov 2013 18:15:30 -0800
Message-Id: <1383876946-2396-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 340ef3902cf20cec43cdcd1e72ae5cb518be7328 upstream.

When correcting commit 04fa5d6a6547 ("mm: migrate: check page_count of
THP before migrating") Hugh Dickins noted that the control flow for
transhuge migration was difficult to follow.  Unconditionally calling
put_page() in numamigrate_isolate_page() made the failure paths of both
migrate_misplaced_transhuge_page() and migrate_misplaced_page() more
complex that they should be.  Further, he was extremely wary that an
unlock_page() should ever happen after a put_page() even if the
put_page() should never be the final put_page.

Hugh implemented the following cleanup to simplify the path by calling
putback_lru_page() inside numamigrate_isolate_page() if it failed to
isolate and always calling unlock_page() within
migrate_misplaced_transhuge_page().

There is no functional change after this patch is applied but the code
is easier to follow and unlock_page() always happens before put_page().

[mgorman@suse.de: changelog only]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Simon Jeons <simon.jeons@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: 3.8-stable prereq for various ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/huge_memory.c | 28 ++++++-----------
 mm/migrate.c     | 95 +++++++++++++++++++++++++-------------------------------
 2 files changed, 52 insertions(+), 71 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f3868de..e19c209 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1302,7 +1302,6 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	int target_nid;
 	int current_nid = -1;
 	bool migrated;
-	bool page_locked = false;
 
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(pmd, *pmdp)))
@@ -1325,7 +1324,6 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	/* Serialise against migrationa and check placement check placement */
 	spin_unlock(&mm->page_table_lock);
 	lock_page(page);
-	page_locked = true;
 
 	/* Confirm the PTE did not while locked */
 	spin_lock(&mm->page_table_lock);
@@ -1346,34 +1344,26 @@ got_lock:
 	/* Migrate the THP to the requested node */
 	spin_unlock(&mm->page_table_lock);
 	migrated = migrate_misplaced_transhuge_page(mm, vma,
-				pmdp, pmd, addr,
-				page, target_nid);
-	if (migrated)
-		current_nid = target_nid;
-	else {
-		spin_lock(&mm->page_table_lock);
-		if (unlikely(!pmd_same(pmd, *pmdp))) {
-			unlock_page(page);
-			goto out_unlock;
-		}
-		goto clear_pmdnuma;
-	}
+				pmdp, pmd, addr, page, target_nid);
+	if (!migrated)
+		goto check_same;
 
-	task_numa_fault(current_nid, HPAGE_PMD_NR, migrated);
+	task_numa_fault(target_nid, HPAGE_PMD_NR, true);
 	return 0;
 
+check_same:
+	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(pmd, *pmdp)))
+		goto out_unlock;
 clear_pmdnuma:
 	pmd = pmd_mknonnuma(pmd);
 	set_pmd_at(mm, haddr, pmdp, pmd);
 	VM_BUG_ON(pmd_numa(*pmdp));
 	update_mmu_cache_pmd(vma, addr, pmdp);
-	if (page_locked)
-		unlock_page(page);
-
 out_unlock:
 	spin_unlock(&mm->page_table_lock);
 	if (current_nid != -1)
-		task_numa_fault(current_nid, HPAGE_PMD_NR, migrated);
+		task_numa_fault(current_nid, HPAGE_PMD_NR, false);
 	return 0;
 }
 
diff --git a/mm/migrate.c b/mm/migrate.c
index ba30b16..811a2ca 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1570,39 +1570,38 @@ bool numamigrate_update_ratelimit(pg_data_t *pgdat, unsigned long nr_pages)
 
 int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
 {
-	int ret = 0;
+	int page_lru;
 
 	/* Avoid migrating to a node that is nearly full */
-	if (migrate_balanced_pgdat(pgdat, 1)) {
-		int page_lru;
+	if (!migrate_balanced_pgdat(pgdat, 1))
+		return 0;
 
-		if (isolate_lru_page(page)) {
-			put_page(page);
-			return 0;
-		}
+	if (isolate_lru_page(page))
+		return 0;
 
-		/* Page is isolated */
-		ret = 1;
-		page_lru = page_is_file_cache(page);
-		if (!PageTransHuge(page))
-			inc_zone_page_state(page, NR_ISOLATED_ANON + page_lru);
-		else
-			mod_zone_page_state(page_zone(page),
-					NR_ISOLATED_ANON + page_lru,
-					HPAGE_PMD_NR);
+	/*
+	 * migrate_misplaced_transhuge_page() skips page migration's usual
+	 * check on page_count(), so we must do it here, now that the page
+	 * has been isolated: a GUP pin, or any other pin, prevents migration.
+	 * The expected page count is 3: 1 for page's mapcount and 1 for the
+	 * caller's pin and 1 for the reference taken by isolate_lru_page().
+	 */
+	if (PageTransHuge(page) && page_count(page) != 3) {
+		putback_lru_page(page);
+		return 0;
 	}
 
+	page_lru = page_is_file_cache(page);
+	mod_zone_page_state(page_zone(page), NR_ISOLATED_ANON + page_lru,
+				hpage_nr_pages(page));
+
 	/*
-	 * Page is either isolated or there is not enough space on the target
-	 * node. If isolated, then it has taken a reference count and the
-	 * callers reference can be safely dropped without the page
-	 * disappearing underneath us during migration. Otherwise the page is
-	 * not to be migrated but the callers reference should still be
-	 * dropped so it does not leak.
+	 * Isolating the page has taken another reference, so the
+	 * caller's reference can be safely dropped without the page
+	 * disappearing underneath us during migration.
 	 */
 	put_page(page);
-
-	return ret;
+	return 1;
 }
 
 /*
@@ -1613,7 +1612,7 @@ int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
 int migrate_misplaced_page(struct page *page, int node)
 {
 	pg_data_t *pgdat = NODE_DATA(node);
-	int isolated = 0;
+	int isolated;
 	int nr_remaining;
 	LIST_HEAD(migratepages);
 
@@ -1621,20 +1620,16 @@ int migrate_misplaced_page(struct page *page, int node)
 	 * Don't migrate pages that are mapped in multiple processes.
 	 * TODO: Handle false sharing detection instead of this hammer
 	 */
-	if (page_mapcount(page) != 1) {
-		put_page(page);
+	if (page_mapcount(page) != 1)
 		goto out;
-	}
 
 	/*
 	 * Rate-limit the amount of data that is being migrated to a node.
 	 * Optimal placement is no good if the memory bus is saturated and
 	 * all the time is being spent migrating!
 	 */
-	if (numamigrate_update_ratelimit(pgdat, 1)) {
-		put_page(page);
+	if (numamigrate_update_ratelimit(pgdat, 1))
 		goto out;
-	}
 
 	isolated = numamigrate_isolate_page(pgdat, page);
 	if (!isolated)
@@ -1651,12 +1646,19 @@ int migrate_misplaced_page(struct page *page, int node)
 	} else
 		count_vm_numa_event(NUMA_PAGE_MIGRATE);
 	BUG_ON(!list_empty(&migratepages));
-out:
 	return isolated;
+
+out:
+	put_page(page);
+	return 0;
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
 #if defined(CONFIG_NUMA_BALANCING) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+/*
+ * Migrates a THP to a given target node. page must be locked and is unlocked
+ * before returning.
+ */
 int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 				struct vm_area_struct *vma,
 				pmd_t *pmd, pmd_t entry,
@@ -1687,29 +1689,15 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 
 	new_page = alloc_pages_node(node,
 		(GFP_TRANSHUGE | GFP_THISNODE) & ~__GFP_WAIT, HPAGE_PMD_ORDER);
-	if (!new_page) {
-		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
-		goto out_dropref;
-	}
+	if (!new_page)
+		goto out_fail;
+
 	page_xchg_last_nid(new_page, page_last_nid(page));
 
 	isolated = numamigrate_isolate_page(pgdat, page);
-
-	/*
-	 * Failing to isolate or a GUP pin prevents migration. The expected
-	 * page count is 2. 1 for anonymous pages without a mapping and 1
-	 * for the callers pin. If the page was isolated, the page will
-	 * need to be put back on the LRU.
-	 */
-	if (!isolated || page_count(page) != 2) {
-		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
+	if (!isolated) {
 		put_page(new_page);
-		if (isolated) {
-			putback_lru_page(page);
-			isolated = 0;
-			goto out;
-		}
-		goto out_keep_locked;
+		goto out_fail;
 	}
 
 	/* Prepare a page as a migration target */
@@ -1741,6 +1729,7 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 		putback_lru_page(page);
 
 		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
+		isolated = 0;
 		goto out;
 	}
 
@@ -1785,9 +1774,11 @@ out:
 			-HPAGE_PMD_NR);
 	return isolated;
 
+out_fail:
+	count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
 out_dropref:
+	unlock_page(page);
 	put_page(page);
-out_keep_locked:
 	return 0;
 }
 #endif /* CONFIG_NUMA_BALANCING */
-- 
1.8.1.2

