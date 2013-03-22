Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422957Ab3CVUZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:25:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422900Ab3CVUZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:25:17 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] migrate: add migrate_entry_wait_huge()
Date: Fri, 22 Mar 2013 16:23:46 -0400
Message-Id: <1363983835-20184-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we have a page fault for the address which is backed by a hugepage
under migration, the kernel can't wait correctly until the migration
finishes. This is because pte_offset_map_lock() can't get a correct
migration entry for hugepage. This patch adds migration_entry_wait_huge()
to separate code path between normal pages and hugepages.

ChangeLog v2:
 - remove dup in migrate_entry_wait_huge()

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 include/linux/swapops.h |  4 ++++
 mm/hugetlb.c            |  2 +-
 mm/migrate.c            | 25 ++++++++++++++++++++-----
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git v3.9-rc3.orig/include/linux/swapops.h v3.9-rc3/include/linux/swapops.h
index 47ead51..f68efdd 100644
--- v3.9-rc3.orig/include/linux/swapops.h
+++ v3.9-rc3/include/linux/swapops.h
@@ -137,6 +137,8 @@ static inline void make_migration_entry_read(swp_entry_t *entry)
 
 extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address);
+extern void migration_entry_wait_huge(struct mm_struct *mm, pmd_t *pmd,
+					unsigned long address);
 #else
 
 #define make_migration_entry(page, write) swp_entry(0, 0)
@@ -148,6 +150,8 @@ static inline int is_migration_entry(swp_entry_t swp)
 static inline void make_migration_entry_read(swp_entry_t *entryp) { }
 static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					 unsigned long address) { }
+static inline void migration_entry_wait_huge(struct mm_struct *mm, pmd_t *pmd,
+					 unsigned long address) { }
 static inline int is_write_migration_entry(swp_entry_t entry)
 {
 	return 0;
diff --git v3.9-rc3.orig/mm/hugetlb.c v3.9-rc3/mm/hugetlb.c
index 0a0be33..98a478e 100644
--- v3.9-rc3.orig/mm/hugetlb.c
+++ v3.9-rc3/mm/hugetlb.c
@@ -2819,7 +2819,7 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (ptep) {
 		entry = huge_ptep_get(ptep);
 		if (unlikely(is_hugetlb_entry_migration(entry))) {
-			migration_entry_wait(mm, (pmd_t *)ptep, address);
+			migration_entry_wait_huge(mm, (pmd_t *)ptep, address);
 			return 0;
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
 			return VM_FAULT_HWPOISON_LARGE |
diff --git v3.9-rc3.orig/mm/migrate.c v3.9-rc3/mm/migrate.c
index 3bbaf5d..ec692a3 100644
--- v3.9-rc3.orig/mm/migrate.c
+++ v3.9-rc3/mm/migrate.c
@@ -200,15 +200,14 @@ static void remove_migration_ptes(struct page *old, struct page *new)
  * get to the page and wait until migration is finished.
  * When we return from this function the fault will be retried.
  */
-void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
-				unsigned long address)
+static void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
+				spinlock_t *ptl)
 {
-	pte_t *ptep, pte;
-	spinlock_t *ptl;
+	pte_t pte;
 	swp_entry_t entry;
 	struct page *page;
 
-	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	spin_lock(ptl);
 	pte = *ptep;
 	if (!is_swap_pte(pte))
 		goto out;
@@ -236,6 +235,22 @@ void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 	pte_unmap_unlock(ptep, ptl);
 }
 
+void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
+				unsigned long address)
+{
+	pte_t *ptep;
+	spinlock_t *ptl = pte_lockptr(mm, pmd);
+	ptep = pte_offset_map(pmd, address);
+	__migration_entry_wait(mm, ptep, ptl);
+}
+
+void migration_entry_wait_huge(struct mm_struct *mm, pmd_t *pmd,
+				unsigned long address)
+{
+	spinlock_t *ptl = pte_lockptr(mm, pmd);
+	__migration_entry_wait(mm, (pte_t *)pmd, ptl);
+}
+
 #ifdef CONFIG_BLOCK
 /* Returns true if all buffers are successfully locked */
 static bool buffer_migrate_lock_buffers(struct buffer_head *head,
-- 
1.7.11.7

