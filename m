Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab3GOPU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:20:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461Ab3GOPU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:20:27 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 03/18] mm: numa: Account for THP numa hinting faults on the correct node
Date: Mon, 15 Jul 2013 16:20:05 +0100
Message-Id: <1373901620-2021-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373901620-2021-1-git-send-email-mgorman@suse.de>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

THP NUMA hinting fault on pages that are not migrated are being
accounted for incorrectly. Currently the fault will be counted as if the
task was running on a node local to the page which is not necessarily
true.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e2f7f5aa..e4a79fa 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1293,7 +1293,7 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct page *page;
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
 	int target_nid;
-	int current_nid = -1;
+	int src_nid = -1;
 	bool migrated;
 
 	spin_lock(&mm->page_table_lock);
@@ -1302,9 +1302,9 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	page = pmd_page(pmd);
 	get_page(page);
-	current_nid = page_to_nid(page);
+	src_nid = numa_node_id();
 	count_vm_numa_event(NUMA_HINT_FAULTS);
-	if (current_nid == numa_node_id())
+	if (src_nid == page_to_nid(page))
 		count_vm_numa_event(NUMA_HINT_FAULTS_LOCAL);
 
 	target_nid = mpol_misplaced(page, vma, haddr);
@@ -1346,8 +1346,8 @@ clear_pmdnuma:
 	update_mmu_cache_pmd(vma, addr, pmdp);
 out_unlock:
 	spin_unlock(&mm->page_table_lock);
-	if (current_nid != -1)
-		task_numa_fault(current_nid, HPAGE_PMD_NR, false);
+	if (src_nid != -1)
+		task_numa_fault(src_nid, HPAGE_PMD_NR, false);
 	return 0;
 }
 
-- 
1.8.1.4

