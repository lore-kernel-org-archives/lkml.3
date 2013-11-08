Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab3KHCTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:19:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34709 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab3KHCTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:19:10 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 76/91] mm: Prevent parallel splits during THP migration
Date: Thu,  7 Nov 2013 18:15:31 -0800
Message-Id: <1383876946-2396-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 587fe586f44a48f9691001ba6c45b86c8e4ba21f upstream.

THP migrations are serialised by the page lock but on its own that does
not prevent THP splits. If the page is split during THP migration then
the pmd_same checks will prevent page table corruption but the unlock page
and other fix-ups potentially will cause corruption. This patch takes the
anon_vma lock to prevent parallel splits during migration.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-7-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/huge_memory.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e19c209..b698c7b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1297,18 +1297,18 @@ out:
 int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				unsigned long addr, pmd_t pmd, pmd_t *pmdp)
 {
+	struct anon_vma *anon_vma = NULL;
 	struct page *page;
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
 	int target_nid;
 	int current_nid = -1;
-	bool migrated;
+	bool migrated, page_locked;
 
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(pmd, *pmdp)))
 		goto out_unlock;
 
 	page = pmd_page(pmd);
-	get_page(page);
 	current_nid = page_to_nid(page);
 	count_vm_numa_event(NUMA_HINT_FAULTS);
 	if (current_nid == numa_node_id())
@@ -1318,12 +1318,29 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * Acquire the page lock to serialise THP migrations but avoid dropping
 	 * page_table_lock if at all possible
 	 */
-	if (trylock_page(page))
-		goto got_lock;
+	page_locked = trylock_page(page);
+	target_nid = mpol_misplaced(page, vma, haddr);
+	if (target_nid == -1) {
+		/* If the page was locked, there are no parallel migrations */
+		if (page_locked) {
+			unlock_page(page);
+			goto clear_pmdnuma;
+		}
 
-	/* Serialise against migrationa and check placement check placement */
+		/* Otherwise wait for potential migrations and retry fault */
+		spin_unlock(&mm->page_table_lock);
+		wait_on_page_locked(page);
+		goto out;
+	}
+
+	/* Page is misplaced, serialise migrations and parallel THP splits */
+	get_page(page);
 	spin_unlock(&mm->page_table_lock);
-	lock_page(page);
+	if (!page_locked) {
+		lock_page(page);
+		page_locked = true;
+	}
+	anon_vma = page_lock_anon_vma_read(page);
 
 	/* Confirm the PTE did not while locked */
 	spin_lock(&mm->page_table_lock);
@@ -1333,14 +1350,6 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto out_unlock;
 	}
 
-got_lock:
-	target_nid = mpol_misplaced(page, vma, haddr);
-	if (target_nid == -1) {
-		unlock_page(page);
-		put_page(page);
-		goto clear_pmdnuma;
-	}
-
 	/* Migrate the THP to the requested node */
 	spin_unlock(&mm->page_table_lock);
 	migrated = migrate_misplaced_transhuge_page(mm, vma,
@@ -1349,6 +1358,8 @@ got_lock:
 		goto check_same;
 
 	task_numa_fault(target_nid, HPAGE_PMD_NR, true);
+	if (anon_vma)
+		page_unlock_anon_vma_read(anon_vma);
 	return 0;
 
 check_same:
@@ -1362,6 +1373,11 @@ clear_pmdnuma:
 	update_mmu_cache_pmd(vma, addr, pmdp);
 out_unlock:
 	spin_unlock(&mm->page_table_lock);
+
+out:
+	if (anon_vma)
+		page_unlock_anon_vma_read(anon_vma);
+
 	if (current_nid != -1)
 		task_numa_fault(current_nid, HPAGE_PMD_NR, false);
 	return 0;
-- 
1.8.1.2

