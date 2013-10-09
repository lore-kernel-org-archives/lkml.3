Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3JIRZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:25:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55930 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab3JIRZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:25:50 -0400
Date: Wed, 9 Oct 2013 10:25:12 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-a54a407fbf7735fd8f7841375574f5d9b0375f93@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-9-git-send-email-mgorman@suse.de>
References: <1381141781-10992-9-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] mm:
  Close races between THP migration and PMD numa clearing
Git-Commit-ID: a54a407fbf7735fd8f7841375574f5d9b0375f93
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:25:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a54a407fbf7735fd8f7841375574f5d9b0375f93
Gitweb:     http://git.kernel.org/tip/a54a407fbf7735fd8f7841375574f5d9b0375f93
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:46 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:39:45 +0200

mm: Close races between THP migration and PMD numa clearing

THP migration uses the page lock to guard against parallel allocations
but there are cases like this still open

  Task A					Task B
  ---------------------				---------------------
  do_huge_pmd_numa_page				do_huge_pmd_numa_page
  lock_page
  mpol_misplaced == -1
  unlock_page
  goto clear_pmdnuma
						lock_page
						mpol_misplaced == 2
						migrate_misplaced_transhuge
  pmd = pmd_mknonnuma
  set_pmd_at

During hours of testing, one crashed with weird errors and while I have
no direct evidence, I suspect something like the race above happened.
This patch extends the page lock to being held until the pmd_numa is
cleared to prevent migration starting in parallel while the pmd_numa is
being cleared. It also flushes the old pmd entry and orders pagetable
insertion before rmap insertion.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-9-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/huge_memory.c | 33 +++++++++++++++------------------
 mm/migrate.c     | 19 +++++++++++--------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c3bb65f..d4928769 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1304,24 +1304,25 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	target_nid = mpol_misplaced(page, vma, haddr);
 	if (target_nid == -1) {
 		/* If the page was locked, there are no parallel migrations */
-		if (page_locked) {
-			unlock_page(page);
+		if (page_locked)
 			goto clear_pmdnuma;
-		}
 
-		/* Otherwise wait for potential migrations and retry fault */
+		/*
+		 * Otherwise wait for potential migrations and retry. We do
+		 * relock and check_same as the page may no longer be mapped.
+		 * As the fault is being retried, do not account for it.
+		 */
 		spin_unlock(&mm->page_table_lock);
 		wait_on_page_locked(page);
+		page_nid = -1;
 		goto out;
 	}
 
 	/* Page is misplaced, serialise migrations and parallel THP splits */
 	get_page(page);
 	spin_unlock(&mm->page_table_lock);
-	if (!page_locked) {
+	if (!page_locked)
 		lock_page(page);
-		page_locked = true;
-	}
 	anon_vma = page_lock_anon_vma_read(page);
 
 	/* Confirm the PMD did not change while page_table_lock was released */
@@ -1329,32 +1330,28 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (unlikely(!pmd_same(pmd, *pmdp))) {
 		unlock_page(page);
 		put_page(page);
+		page_nid = -1;
 		goto out_unlock;
 	}
 
-	/* Migrate the THP to the requested node */
+	/*
+	 * Migrate the THP to the requested node, returns with page unlocked
+	 * and pmd_numa cleared.
+	 */
 	spin_unlock(&mm->page_table_lock);
 	migrated = migrate_misplaced_transhuge_page(mm, vma,
 				pmdp, pmd, addr, page, target_nid);
 	if (migrated)
 		page_nid = target_nid;
-	else
-		goto check_same;
 
 	goto out;
-
-check_same:
-	spin_lock(&mm->page_table_lock);
-	if (unlikely(!pmd_same(pmd, *pmdp))) {
-		/* Someone else took our fault */
-		page_nid = -1;
-		goto out_unlock;
-	}
 clear_pmdnuma:
+	BUG_ON(!PageLocked(page));
 	pmd = pmd_mknonnuma(pmd);
 	set_pmd_at(mm, haddr, pmdp, pmd);
 	VM_BUG_ON(pmd_numa(*pmdp));
 	update_mmu_cache_pmd(vma, addr, pmdp);
+	unlock_page(page);
 out_unlock:
 	spin_unlock(&mm->page_table_lock);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index a26bccd..7bd90d3 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1713,12 +1713,12 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 		unlock_page(new_page);
 		put_page(new_page);		/* Free it */
 
-		unlock_page(page);
+		/* Retake the callers reference and putback on LRU */
+		get_page(page);
 		putback_lru_page(page);
-
-		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
-		isolated = 0;
-		goto out;
+		mod_zone_page_state(page_zone(page),
+			 NR_ISOLATED_ANON + page_lru, -HPAGE_PMD_NR);
+		goto out_fail;
 	}
 
 	/*
@@ -1735,9 +1735,9 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 	entry = pmd_mkhuge(entry);
 
-	page_add_new_anon_rmap(new_page, vma, haddr);
-
+	pmdp_clear_flush(vma, haddr, pmd);
 	set_pmd_at(mm, haddr, pmd, entry);
+	page_add_new_anon_rmap(new_page, vma, haddr);
 	update_mmu_cache_pmd(vma, address, &entry);
 	page_remove_rmap(page);
 	/*
@@ -1756,7 +1756,6 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	count_vm_events(PGMIGRATE_SUCCESS, HPAGE_PMD_NR);
 	count_vm_numa_events(NUMA_PAGE_MIGRATE, HPAGE_PMD_NR);
 
-out:
 	mod_zone_page_state(page_zone(page),
 			NR_ISOLATED_ANON + page_lru,
 			-HPAGE_PMD_NR);
@@ -1765,6 +1764,10 @@ out:
 out_fail:
 	count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
 out_dropref:
+	entry = pmd_mknonnuma(entry);
+	set_pmd_at(mm, haddr, pmd, entry);
+	update_mmu_cache_pmd(vma, address, &entry);
+
 	unlock_page(page);
 	put_page(page);
 	return 0;
