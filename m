Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3JIR0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:26:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55981 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3JIR03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:26:29 -0400
Date: Wed, 9 Oct 2013 10:25:52 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-a1a46184e34cfd0764f06a54870defa052b0a094@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-13-git-send-email-mgorman@suse.de>
References: <1381141781-10992-13-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] mm: numa:
  Do not migrate or account for hinting faults on the zero page
Git-Commit-ID: a1a46184e34cfd0764f06a54870defa052b0a094
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:26:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1a46184e34cfd0764f06a54870defa052b0a094
Gitweb:     http://git.kernel.org/tip/a1a46184e34cfd0764f06a54870defa052b0a094
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:50 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:39:50 +0200

mm: numa: Do not migrate or account for hinting faults on the zero page

The zero page is not replicated between nodes and is often shared between
processes. The data is read-only and likely to be cached in local CPUs
if heavily accessed meaning that the remote memory access cost is less
of a concern. This patch prevents trapping faults on the zero pages. For
tasks using the zero page this will reduce the number of PTE updates,
TLB flushes and hinting faults.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
[ Correct use of is_huge_zero_page]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-13-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/huge_memory.c | 10 +++++++++-
 mm/memory.c      |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index de8d5cf..8677dbf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1291,6 +1291,7 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto out_unlock;
 
 	page = pmd_page(pmd);
+	BUG_ON(is_huge_zero_page(page));
 	page_nid = page_to_nid(page);
 	count_vm_numa_event(NUMA_HINT_FAULTS);
 	if (page_nid == this_nid)
@@ -1481,8 +1482,15 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
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
index 42ae82e..ed51f15 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3564,6 +3564,7 @@ int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		pte_unmap_unlock(ptep, ptl);
 		return 0;
 	}
+	BUG_ON(is_zero_pfn(page_to_pfn(page)));
 
 	page_nid = page_to_nid(page);
 	target_nid = numa_migrate_prep(page, vma, addr, page_nid);
