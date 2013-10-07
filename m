Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab3JGKoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:44:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab3JGK3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:29:53 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 11/63] mm: Only flush TLBs if a transhuge PMD is modified for NUMA pte scanning
Date: Mon,  7 Oct 2013 11:28:49 +0100
Message-Id: <1381141781-10992-12-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381141781-10992-1-git-send-email-mgorman@suse.de>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUMA PTE scanning is expensive both in terms of the scanning itself and
the TLB flush if there are any updates. The TLB flush is avoided if no
PTEs are updated but there is a bug where transhuge PMDs are considered
to be updated even if they were already pmd_numa. This patch addresses
the problem and TLB flushes should be reduced.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 19 ++++++++++++++++---
 mm/mprotect.c    | 14 ++++++++++----
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d4928769..de8d5cf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1458,6 +1458,12 @@ out:
 	return ret;
 }
 
+/*
+ * Returns
+ *  - 0 if PMD could not be locked
+ *  - 1 if PMD was locked but protections unchange and TLB flush unnecessary
+ *  - HPAGE_PMD_NR is protections changed and TLB flush necessary
+ */
 int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, pgprot_t newprot, int prot_numa)
 {
@@ -1466,9 +1472,11 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 
 	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		pmd_t entry;
-		entry = pmdp_get_and_clear(mm, addr, pmd);
+		ret = 1;
 		if (!prot_numa) {
+			entry = pmdp_get_and_clear(mm, addr, pmd);
 			entry = pmd_modify(entry, newprot);
+			ret = HPAGE_PMD_NR;
 			BUG_ON(pmd_write(entry));
 		} else {
 			struct page *page = pmd_page(*pmd);
@@ -1476,12 +1484,17 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			/* only check non-shared pages */
 			if (page_mapcount(page) == 1 &&
 			    !pmd_numa(*pmd)) {
+				entry = pmdp_get_and_clear(mm, addr, pmd);
 				entry = pmd_mknuma(entry);
+				ret = HPAGE_PMD_NR;
 			}
 		}
-		set_pmd_at(mm, addr, pmd, entry);
+
+		/* Set PMD if cleared earlier */
+		if (ret == HPAGE_PMD_NR)
+			set_pmd_at(mm, addr, pmd, entry);
+
 		spin_unlock(&vma->vm_mm->page_table_lock);
-		ret = 1;
 	}
 
 	return ret;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 7bdbd4b..2da33dc 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -144,10 +144,16 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				split_huge_page_pmd(vma, addr, pmd);
-			else if (change_huge_pmd(vma, pmd, addr, newprot,
-						 prot_numa)) {
-				pages++;
-				continue;
+			else {
+				int nr_ptes = change_huge_pmd(vma, pmd, addr,
+						newprot, prot_numa);
+
+				if (nr_ptes) {
+					if (nr_ptes == HPAGE_PMD_NR)
+						pages++;
+
+					continue;
+				}
 			}
 			/* fall through */
 		}
-- 
1.8.4

