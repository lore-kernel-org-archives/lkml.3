Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbaAMQXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:23:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53563 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaAMQEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 152/208] mm: numa: avoid unnecessary disruption of NUMA hinting during migration
Date: Mon, 13 Jan 2014 15:59:53 +0000
Message-Id: <1389628849-1614-153-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit de466bd628e8d663fdf3f791bc8db318ee85c714 upstream.

do_huge_pmd_numa_page() handles the case where there is parallel THP
migration.  However, by the time it is checked the NUMA hinting
information has already been disrupted.  This patch adds an earlier
check with some helpers.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/migrate.h | 10 +++++++++-
 mm/huge_memory.c        | 22 ++++++++++++++++------
 mm/migrate.c            | 12 ++++++++++++
 3 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index a405d3dc..a7ec0a0 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -92,10 +92,18 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
-extern int migrate_misplaced_page(struct page *page, int node);
+extern bool pmd_trans_migrating(pmd_t pmd);
+extern void wait_migrate_huge_page(struct anon_vma *anon_vma, pmd_t *pmd);
 extern int migrate_misplaced_page(struct page *page, int node);
 extern bool migrate_ratelimited(int node);
 #else
+static inline bool pmd_trans_migrating(pmd_t pmd)
+{
+	return false;
+}
+static inline void wait_migrate_huge_page(struct anon_vma *anon_vma, pmd_t *pmd)
+{
+}
 static inline int migrate_misplaced_page(struct page *page, int node)
 {
 	return -EAGAIN; /* can't migrate now */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1385bf9..31950d6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -899,6 +899,10 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		ret = 0;
 		goto out_unlock;
 	}
+
+	/* mmap_sem prevents this happening but warn if that changes */
+	WARN_ON(pmd_trans_migrating(pmd));
+
 	if (unlikely(pmd_trans_splitting(pmd))) {
 		/* split huge page running from under us */
 		spin_unlock(&src_mm->page_table_lock);
@@ -1306,6 +1310,17 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (unlikely(!pmd_same(pmd, *pmdp)))
 		goto out_unlock;
 
+	/*
+	 * If there are potential migrations, wait for completion and retry
+	 * without disrupting NUMA hinting information. Do not relock and
+	 * check_same as the page may no longer be mapped.
+	 */
+	if (unlikely(pmd_trans_migrating(*pmdp))) {
+		spin_unlock(&mm->page_table_lock);
+		wait_migrate_huge_page(vma->anon_vma, pmdp);
+		goto out;
+	}
+
 	page = pmd_page(pmd);
 	page_nid = page_to_nid(page);
 	count_vm_numa_event(NUMA_HINT_FAULTS);
@@ -1324,12 +1339,7 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			goto clear_pmdnuma;
 	}
 
-	/*
-	 * If there are potential migrations, wait for completion and retry. We
-	 * do not relock and check_same as the page may no longer be mapped.
-	 * Furtermore, even if the page is currently misplaced, there is no
-	 * guarantee it is still misplaced after the migration completes.
-	 */
+	/* Migration could have started since the pmd_trans_migrating check */
 	if (!page_locked) {
 		spin_unlock(&mm->page_table_lock);
 		wait_on_page_locked(page);
diff --git a/mm/migrate.c b/mm/migrate.c
index cde4b34..c033a04 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1594,6 +1594,18 @@ int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
 	return 1;
 }
 
+bool pmd_trans_migrating(pmd_t pmd)
+{
+	struct page *page = pmd_page(pmd);
+	return PageLocked(page);
+}
+
+void wait_migrate_huge_page(struct anon_vma *anon_vma, pmd_t *pmd)
+{
+	struct page *page = pmd_page(*pmd);
+	wait_on_page_locked(page);
+}
+
 /*
  * Attempt to migrate a misplaced page to the specified destination
  * node. Caller is expected to have an elevated reference count on
-- 
1.8.3.2

