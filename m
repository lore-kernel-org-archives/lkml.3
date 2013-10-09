Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab3JIR3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:29:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56175 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3JIR3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:29:00 -0400
Date: Wed, 9 Oct 2013 10:28:22 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-1bc115d87dffd1c43bdc3c9c9d1e3a51c195d18e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-28-git-send-email-mgorman@suse.de>
References: <1381141781-10992-28-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] mm: numa: Scan pages with elevated page_mapcount
Git-Commit-ID: 1bc115d87dffd1c43bdc3c9c9d1e3a51c195d18e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:28:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1bc115d87dffd1c43bdc3c9c9d1e3a51c195d18e
Gitweb:     http://git.kernel.org/tip/1bc115d87dffd1c43bdc3c9c9d1e3a51c195d18e
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:29:05 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:32 +0200

mm: numa: Scan pages with elevated page_mapcount

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
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-28-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/migrate.h |  7 ++++---
 mm/huge_memory.c        | 12 +++++-------
 mm/memory.c             |  7 ++-----
 mm/migrate.c            | 17 ++++++-----------
 mm/mprotect.c           |  4 +---
 5 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 8d3c57f..f5096b5 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -90,11 +90,12 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
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
index 9142167..2a28c2c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1484,14 +1484,12 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
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
index 24bc9b8..3e3b4b8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3577,7 +3577,7 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 
 	/* Migrate to the requested node */
-	migrated = migrate_misplaced_page(page, target_nid);
+	migrated = migrate_misplaced_page(page, vma, target_nid);
 	if (migrated)
 		page_nid = target_nid;
 
@@ -3642,16 +3642,13 @@ static int do_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
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
index 7bd90d3..fcba2f4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1599,7 +1599,8 @@ int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
  * node. Caller is expected to have an elevated reference count on
  * the page that will be dropped by this function before returning.
  */
-int migrate_misplaced_page(struct page *page, int node)
+int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
+			   int node)
 {
 	pg_data_t *pgdat = NODE_DATA(node);
 	int isolated;
@@ -1607,10 +1608,11 @@ int migrate_misplaced_page(struct page *page, int node)
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
@@ -1661,13 +1663,6 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
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
