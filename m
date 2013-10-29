Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab3J2KnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:43:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43650 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab3J2KnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:43:14 -0400
Date: Tue, 29 Oct 2013 03:42:32 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-42836f5f8baa33085f547098b74aa98991ee9216@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        stable@kernel.org, aarcange@redhat.com, srikar@linux.vnet.ibm.com,
        mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        srikar@linux.vnet.ibm.com, stable@kernel.org, aarcange@redhat.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1381141781-10992-6-git-send-email-mgorman@suse.de>
References: <1381141781-10992-6-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] mm:
  Wait for THP migrations to complete during NUMA hinting faults
Git-Commit-ID: 42836f5f8baa33085f547098b74aa98991ee9216
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 03:42:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42836f5f8baa33085f547098b74aa98991ee9216
Gitweb:     http://git.kernel.org/tip/42836f5f8baa33085f547098b74aa98991ee9216
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:43 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 11:37:19 +0100

mm: Wait for THP migrations to complete during NUMA hinting faults

The locking for migrating THP is unusual. While normal page migration
prevents parallel accesses using a migration PTE, THP migration relies on
a combination of the page_table_lock, the page lock and the existance of
the NUMA hinting PTE to guarantee safety but there is a bug in the scheme.

If a THP page is currently being migrated and another thread traps a
fault on the same page it checks if the page is misplaced. If it is not,
then pmd_numa is cleared. The problem is that it checks if the page is
misplaced without holding the page lock meaning that the racing thread
can be migrating the THP when the second thread clears the NUMA bit
and faults a stale page.

This patch checks if the page is potentially being migrated and stalls
using the lock_page if it is potentially being migrated before checking
if the page is misplaced or not.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-6-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/huge_memory.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 33ee637..e10d780 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1295,13 +1295,14 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (current_nid == numa_node_id())
 		count_vm_numa_event(NUMA_HINT_FAULTS_LOCAL);
 
-	target_nid = mpol_misplaced(page, vma, haddr);
-	if (target_nid == -1) {
-		put_page(page);
-		goto clear_pmdnuma;
-	}
+	/*
+	 * Acquire the page lock to serialise THP migrations but avoid dropping
+	 * page_table_lock if at all possible
+	 */
+	if (trylock_page(page))
+		goto got_lock;
 
-	/* Acquire the page lock to serialise THP migrations */
+	/* Serialise against migrationa and check placement check placement */
 	spin_unlock(&mm->page_table_lock);
 	lock_page(page);
 
@@ -1312,9 +1313,17 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		put_page(page);
 		goto out_unlock;
 	}
-	spin_unlock(&mm->page_table_lock);
+
+got_lock:
+	target_nid = mpol_misplaced(page, vma, haddr);
+	if (target_nid == -1) {
+		unlock_page(page);
+		put_page(page);
+		goto clear_pmdnuma;
+	}
 
 	/* Migrate the THP to the requested node */
+	spin_unlock(&mm->page_table_lock);
 	migrated = migrate_misplaced_transhuge_page(mm, vma,
 				pmdp, pmd, addr, page, target_nid);
 	if (!migrated)
