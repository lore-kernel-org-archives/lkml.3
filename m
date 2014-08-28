Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbaH1Syp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:54:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbaH1Sgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:42 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 53/97] mm, migration: add destination page freeing callback
Date: Thu, 28 Aug 2014 19:35:01 +0100
Message-Id: <1409250945-30874-54-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

commit 68711a746345c44ae00c64d8dbac6a9ce13ac54a upstream.

Memory migration uses a callback defined by the caller to determine how to
allocate destination pages.  When migration fails for a source page,
however, it frees the destination page back to the system.

This patch adds a memory migration callback defined by the caller to
determine how to free destination pages.  If a caller, such as memory
compaction, builds its own freelist for migration targets, this can reuse
already freed memory instead of scanning additional memory.

If the caller provides a function to handle freeing of destination pages,
it is called when page migration fails.  If the caller passes NULL then
freeing back to the system will be handled as usual.  This patch
introduces no functional change.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/migrate.h | 11 ++++++----
 mm/compaction.c         |  2 +-
 mm/memory-failure.c     |  4 ++--
 mm/memory_hotplug.c     |  2 +-
 mm/mempolicy.c          |  4 ++--
 mm/migrate.c            | 55 +++++++++++++++++++++++++++++++++++--------------
 mm/page_alloc.c         |  2 +-
 7 files changed, 53 insertions(+), 27 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index ee8b14a..449905e 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -5,7 +5,9 @@
 #include <linux/mempolicy.h>
 #include <linux/migrate_mode.h>
 
-typedef struct page *new_page_t(struct page *, unsigned long private, int **);
+typedef struct page *new_page_t(struct page *page, unsigned long private,
+				int **reason);
+typedef void free_page_t(struct page *page, unsigned long private);
 
 /*
  * Return values from addresss_space_operations.migratepage():
@@ -39,7 +41,7 @@ extern void putback_lru_pages(struct list_head *l);
 extern void putback_movable_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *, enum migrate_mode);
-extern int migrate_pages(struct list_head *l, new_page_t x,
+extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
 		unsigned long private, enum migrate_mode mode, int reason);
 
 extern int fail_migrate_page(struct address_space *,
@@ -61,8 +63,9 @@ extern int migrate_page_move_mapping(struct address_space *mapping,
 
 static inline void putback_lru_pages(struct list_head *l) {}
 static inline void putback_movable_pages(struct list_head *l) {}
-static inline int migrate_pages(struct list_head *l, new_page_t x,
-		unsigned long private, enum migrate_mode mode, int reason)
+static inline int migrate_pages(struct list_head *l, new_page_t new,
+		free_page_t free, unsigned long private, enum migrate_mode mode,
+		int reason)
 	{ return -ENOSYS; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
diff --git a/mm/compaction.c b/mm/compaction.c
index 43d37cd..fae59ea 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1014,7 +1014,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 		}
 
 		nr_migrate = cc->nr_migratepages;
-		err = migrate_pages(&cc->migratepages, compaction_alloc,
+		err = migrate_pages(&cc->migratepages, compaction_alloc, NULL,
 				(unsigned long)cc,
 				cc->sync ? MIGRATE_SYNC_LIGHT : MIGRATE_ASYNC,
 				MR_COMPACTION);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 6e3f9c3..4ab233d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1554,7 +1554,7 @@ static int soft_offline_huge_page(struct page *page, int flags)
 
 	/* Keep page count to indicate a given hugepage is isolated. */
 	list_move(&hpage->lru, &pagelist);
-	ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
+	ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 				MIGRATE_SYNC, MR_MEMORY_FAILURE);
 	if (ret) {
 		pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
@@ -1635,7 +1635,7 @@ static int __soft_offline_page(struct page *page, int flags)
 		inc_zone_page_state(page, NR_ISOLATED_ANON +
 					page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
-		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
+		ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
 		if (ret) {
 			putback_lru_pages(&pagelist);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index ed85fe3..d317305 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1321,7 +1321,7 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		 * alloc_migrate_target should be improooooved!!
 		 * migrate_pages returns # of failed pages.
 		 */
-		ret = migrate_pages(&source, alloc_migrate_target, 0,
+		ret = migrate_pages(&source, alloc_migrate_target, NULL, 0,
 					MIGRATE_SYNC, MR_MEMORY_HOTPLUG);
 		if (ret)
 			putback_movable_pages(&source);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0bf6476..cc61c7a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1060,7 +1060,7 @@ static int migrate_to_node(struct mm_struct *mm, int source, int dest,
 			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
 
 	if (!list_empty(&pagelist)) {
-		err = migrate_pages(&pagelist, new_node_page, dest,
+		err = migrate_pages(&pagelist, new_node_page, NULL, dest,
 					MIGRATE_SYNC, MR_SYSCALL);
 		if (err)
 			putback_movable_pages(&pagelist);
@@ -1306,7 +1306,7 @@ static long do_mbind(unsigned long start, unsigned long len,
 
 		if (!list_empty(&pagelist)) {
 			WARN_ON_ONCE(flags & MPOL_MF_LAZY);
-			nr_failed = migrate_pages(&pagelist, new_page,
+			nr_failed = migrate_pages(&pagelist, new_page, NULL,
 				start, MIGRATE_SYNC, MR_MEMPOLICY_MBIND);
 			if (nr_failed)
 				putback_movable_pages(&pagelist);
diff --git a/mm/migrate.c b/mm/migrate.c
index e3cf71d..e397bd2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -867,8 +867,9 @@ out:
  * Obtain the lock on page, remove all ptes and migrate the page
  * to the newly allocated page in newpage.
  */
-static int unmap_and_move(new_page_t get_new_page, unsigned long private,
-			struct page *page, int force, enum migrate_mode mode)
+static int unmap_and_move(new_page_t get_new_page, free_page_t put_new_page,
+			unsigned long private, struct page *page, int force,
+			enum migrate_mode mode)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -912,11 +913,17 @@ out:
 				page_is_file_cache(page));
 		putback_lru_page(page);
 	}
+
 	/*
-	 * Move the new page to the LRU. If migration was not successful
-	 * then this will free the page.
+	 * If migration was not successful and there's a freeing callback, use
+	 * it.  Otherwise, putback_lru_page() will drop the reference grabbed
+	 * during isolation.
 	 */
-	putback_lru_page(newpage);
+	if (rc != MIGRATEPAGE_SUCCESS && put_new_page)
+		put_new_page(newpage, private);
+	else
+		putback_lru_page(newpage);
+
 	if (result) {
 		if (rc)
 			*result = rc;
@@ -945,8 +952,9 @@ out:
  * will wait in the page fault for migration to complete.
  */
 static int unmap_and_move_huge_page(new_page_t get_new_page,
-				unsigned long private, struct page *hpage,
-				int force, enum migrate_mode mode)
+				free_page_t put_new_page, unsigned long private,
+				struct page *hpage, int force,
+				enum migrate_mode mode)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -982,20 +990,30 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 	if (!page_mapped(hpage))
 		rc = move_to_new_page(new_hpage, hpage, 1, mode);
 
-	if (rc)
+	if (rc != MIGRATEPAGE_SUCCESS)
 		remove_migration_ptes(hpage, hpage);
 
 	if (anon_vma)
 		put_anon_vma(anon_vma);
 
-	if (!rc)
+	if (rc == MIGRATEPAGE_SUCCESS)
 		hugetlb_cgroup_migrate(hpage, new_hpage);
 
 	unlock_page(hpage);
 out:
 	if (rc != -EAGAIN)
 		putback_active_hugepage(hpage);
-	put_page(new_hpage);
+
+	/*
+	 * If migration was not successful and there's a freeing callback, use
+	 * it.  Otherwise, put_page() will drop the reference grabbed during
+	 * isolation.
+	 */
+	if (rc != MIGRATEPAGE_SUCCESS && put_new_page)
+		put_new_page(new_hpage, private);
+	else
+		put_page(new_hpage);
+
 	if (result) {
 		if (rc)
 			*result = rc;
@@ -1012,6 +1030,8 @@ out:
  * @from:		The list of pages to be migrated.
  * @get_new_page:	The function used to allocate free pages to be used
  *			as the target of the page migration.
+ * @put_new_page:	The function used to free target pages if migration
+ *			fails, or NULL if no special handling is necessary.
  * @private:		Private data to be passed on to get_new_page()
  * @mode:		The migration mode that specifies the constraints for
  *			page migration, if any.
@@ -1025,7 +1045,8 @@ out:
  * Returns the number of pages that were not migrated, or an error code.
  */
 int migrate_pages(struct list_head *from, new_page_t get_new_page,
-		unsigned long private, enum migrate_mode mode, int reason)
+		free_page_t put_new_page, unsigned long private,
+		enum migrate_mode mode, int reason)
 {
 	int retry = 1;
 	int nr_failed = 0;
@@ -1047,10 +1068,11 @@ int migrate_pages(struct list_head *from, new_page_t get_new_page,
 
 			if (PageHuge(page))
 				rc = unmap_and_move_huge_page(get_new_page,
-						private, page, pass > 2, mode);
+						put_new_page, private, page,
+						pass > 2, mode);
 			else
-				rc = unmap_and_move(get_new_page, private,
-						page, pass > 2, mode);
+				rc = unmap_and_move(get_new_page, put_new_page,
+						private, page, pass > 2, mode);
 
 			switch(rc) {
 			case -ENOMEM:
@@ -1194,7 +1216,7 @@ set_status:
 
 	err = 0;
 	if (!list_empty(&pagelist)) {
-		err = migrate_pages(&pagelist, new_page_node,
+		err = migrate_pages(&pagelist, new_page_node, NULL,
 				(unsigned long)pm, MIGRATE_SYNC, MR_SYSCALL);
 		if (err)
 			putback_movable_pages(&pagelist);
@@ -1643,7 +1665,8 @@ int migrate_misplaced_page(struct page *page, int node)
 
 	list_add(&page->lru, &migratepages);
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_page,
-				     node, MIGRATE_ASYNC, MR_NUMA_MISPLACED);
+				     NULL, node, MIGRATE_ASYNC,
+				     MR_NUMA_MISPLACED);
 	if (nr_remaining) {
 		putback_lru_pages(&migratepages);
 		isolated = 0;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 74bf3e0..bfbe0db 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6204,7 +6204,7 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 		cc->nr_migratepages -= nr_reclaimed;
 
 		ret = migrate_pages(&cc->migratepages, alloc_migrate_target,
-				    0, MIGRATE_SYNC, MR_CMA);
+				    NULL, 0, MIGRATE_SYNC, MR_CMA);
 	}
 	if (ret < 0) {
 		putback_movable_pages(&cc->migratepages);
-- 
1.8.4.5

