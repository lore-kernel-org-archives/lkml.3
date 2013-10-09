Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab3JIR0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:26:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55947 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab3JIR0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:26:01 -0400
Date: Wed, 9 Oct 2013 10:24:52 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-b8916634b77bffb233d8f2f45703c80343457cc1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-7-git-send-email-mgorman@suse.de>
References: <1381141781-10992-7-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] mm: Prevent parallel splits during THP migration
Git-Commit-ID: b8916634b77bffb233d8f2f45703c80343457cc1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:24:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8916634b77bffb233d8f2f45703c80343457cc1
Gitweb:     http://git.kernel.org/tip/b8916634b77bffb233d8f2f45703c80343457cc1
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:44 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:39:43 +0200

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
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-7-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/huge_memory.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f362363..1d6334f 100644
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
 
 	/* Confirm the PMD did not change while page_table_lock was released */
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
