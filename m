Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161200Ab3LFXa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:30:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48913 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422945Ab3LFXUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:02 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 102/152] mm: Only flush TLBs if a transhuge PMD is modified for NUMA pte scanning
Date: Fri,  6 Dec 2013 15:10:26 -0800
Message-Id: <1386371476-2477-103-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit f123d74abf91574837d14e5ea58f6a779a387bf5 upstream.

NUMA PTE scanning is expensive both in terms of the scanning itself and
the TLB flush if there are any updates. The TLB flush is avoided if no
PTEs are updated but there is a bug where transhuge PMDs are considered
to be updated even if they were already pmd_numa. This patch addresses
the problem and TLB flushes should be reduced.

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-12-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[ kamal: 3.8 stable prereq for
  72403b4 mm: numa: return the number of base pages altered by protection changes ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/huge_memory.c | 19 ++++++++++++++++---
 mm/mprotect.c    | 14 ++++++++++----
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c37776..9d0b5f5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1472,6 +1472,12 @@ out:
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
@@ -1480,9 +1486,11 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 
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
@@ -1490,12 +1498,17 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
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
index 2bbb648..16a42b2 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -143,10 +143,16 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
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
1.8.3.2

