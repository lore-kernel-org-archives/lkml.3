Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3I0NnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:43:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab3I0N2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:28:04 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 12/63] mm: numa: Do not migrate or account for hinting faults on the zero page
Date: Fri, 27 Sep 2013 14:26:57 +0100
Message-Id: <1380288468-5551-13-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380288468-5551-1-git-send-email-mgorman@suse.de>
References: <1380288468-5551-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The zero page is not replicated between nodes and is often shared between
processes. The data is read-only and likely to be cached in local CPUs
if heavily accessed meaning that the remote memory access cost is less
of a concern. This patch prevents trapping faults on the zero pages. For
tasks using the zero page this will reduce the number of PTE updates,
TLB flushes and hinting faults.

[peterz@infradead.org: Correct use of is_huge_zero_page]
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 10 +++++++++-
 mm/memory.c      |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ac5af18..dd94f4e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1303,6 +1303,7 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto out_unlock;
 
 	page = pmd_page(pmd);
+	BUG_ON(is_huge_zero_page(page));
 	page_nid = page_to_nid(page);
 	count_vm_numa_event(NUMA_HINT_FAULTS);
 	if (page_nid == this_nid)
@@ -1493,8 +1494,15 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		} else {
 			struct page *page = pmd_page(*pmd);
 
-			/* only check non-shared pages */
+			/*
+			 * Only check non-shared pages. Do not trap faults
+			 * against the zero page. The read-only data is likely
+			 * to be read-cached on the local CPU cache and it is
+			 * less useful to know about local vs remote hits on
+			 * the zero page.
+			 */
 			if (page_mapcount(page) == 1 &&
+			    !is_huge_zero_page(page) &&
 			    !pmd_numa(*pmd)) {
 				entry = pmdp_get_and_clear(mm, addr, pmd);
 				entry = pmd_mknuma(entry);
diff --git a/mm/memory.c b/mm/memory.c
index c20f872..86c3caf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3575,6 +3575,7 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		pte_unmap_unlock(ptep, ptl);
 		return 0;
 	}
+	BUG_ON(is_zero_pfn(page_to_pfn(page)));
 
 	page_nid = page_to_nid(page);
 	target_nid = numa_migrate_prep(page, vma, addr, page_nid);
-- 
1.8.1.4

