Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbbAEKyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:54:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbbAEKyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:54:16 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 01/10] mm: numa: Do not dereference pmd outside of the lock during NUMA hinting fault
Date: Mon,  5 Jan 2015 10:54:02 +0000
Message-Id: <1420455251-13644-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1420455251-13644-1-git-send-email-mgorman@suse.de>
References: <1420455251-13644-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A transhuge NUMA hinting fault may find the page is migrating and should
wait until migration completes. The check is race-prone because the pmd
is deferenced outside of the page lock and while the race is tiny, it'll
be larger if the PMD is cleared while marking PMDs for hinting fault.
This patch closes the race.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/migrate.h | 4 ----
 mm/huge_memory.c        | 3 ++-
 mm/migrate.c            | 6 ------
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index fab9b32..78baed5 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -67,7 +67,6 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 
 #ifdef CONFIG_NUMA_BALANCING
 extern bool pmd_trans_migrating(pmd_t pmd);
-extern void wait_migrate_huge_page(struct anon_vma *anon_vma, pmd_t *pmd);
 extern int migrate_misplaced_page(struct page *page,
 				  struct vm_area_struct *vma, int node);
 extern bool migrate_ratelimited(int node);
@@ -76,9 +75,6 @@ static inline bool pmd_trans_migrating(pmd_t pmd)
 {
 	return false;
 }
-static inline void wait_migrate_huge_page(struct anon_vma *anon_vma, pmd_t *pmd)
-{
-}
 static inline int migrate_misplaced_page(struct page *page,
 					 struct vm_area_struct *vma, int node)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 817a875..a2cd021 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1283,8 +1283,9 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * check_same as the page may no longer be mapped.
 	 */
 	if (unlikely(pmd_trans_migrating(*pmdp))) {
+		page = pmd_page(*pmdp);
 		spin_unlock(ptl);
-		wait_migrate_huge_page(vma->anon_vma, pmdp);
+		wait_on_page_locked(page);
 		goto out;
 	}
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 344cdf6..e6a5ff1 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1685,12 +1685,6 @@ bool pmd_trans_migrating(pmd_t pmd)
 	return PageLocked(page);
 }
 
-void wait_migrate_huge_page(struct anon_vma *anon_vma, pmd_t *pmd)
-{
-	struct page *page = pmd_page(*pmd);
-	wait_on_page_locked(page);
-}
-
 /*
  * Attempt to migrate a misplaced page to the specified destination
  * node. Caller is expected to have an elevated reference count on
-- 
2.1.2

