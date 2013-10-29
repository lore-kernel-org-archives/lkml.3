Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3J2KnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:43:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43661 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab3J2KnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:43:19 -0400
Date: Tue, 29 Oct 2013 03:42:40 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-587fe586f44a48f9691001ba6c45b86c8e4ba21f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        stable@kernel.org, aarcange@redhat.com, srikar@linux.vnet.ibm.com,
        mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        srikar@linux.vnet.ibm.com, stable@kernel.org, aarcange@redhat.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1381141781-10992-7-git-send-email-mgorman@suse.de>
References: <1381141781-10992-7-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] mm:
  Prevent parallel splits during THP migration
Git-Commit-ID: 587fe586f44a48f9691001ba6c45b86c8e4ba21f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 03:42:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  587fe586f44a48f9691001ba6c45b86c8e4ba21f
Gitweb:     http://git.kernel.org/tip/587fe586f44a48f9691001ba6c45b86c8e4ba21f
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:44 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 11:37:39 +0100

mm: Prevent parallel splits during THP migration

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
Cc: <stable@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-7-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/huge_memory.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e10d780..d8534b3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1278,18 +1278,18 @@ out:
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
@@ -1299,12 +1299,29 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
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
@@ -1314,14 +1331,6 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
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
@@ -1330,6 +1339,8 @@ got_lock:
 		goto check_same;
 
 	task_numa_fault(target_nid, HPAGE_PMD_NR, true);
+	if (anon_vma)
+		page_unlock_anon_vma_read(anon_vma);
 	return 0;
 
 check_same:
@@ -1346,6 +1357,11 @@ clear_pmdnuma:
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
