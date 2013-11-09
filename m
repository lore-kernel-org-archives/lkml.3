Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab3KIHCp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:02:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877Ab3KIGwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.11 70/94] mm: Wait for THP migrations to complete during NUMA hinting faults
Date: Fri,  8 Nov 2013 22:52:16 -0800
Message-Id: <20131109065209.211637962@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 42836f5f8baa33085f547098b74aa98991ee9216 upstream.

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
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-6-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/huge_memory.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1307,13 +1307,14 @@ int do_huge_pmd_numa_page(struct mm_stru
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
 
@@ -1324,9 +1325,17 @@ int do_huge_pmd_numa_page(struct mm_stru
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


