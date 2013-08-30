Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab3H3Q6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:58:31 -0400
Received: from relay2.sgi.com ([192.48.179.30]:49783 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756309Ab3H3Q63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:58:29 -0400
From: Alex Thorlton <athorlton@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robin Holt <robinmholt@gmail.com>, Alex Thorlton <athorlton@sgi.com>,
        linux-mm@kvack.org
Subject: [RFC PATCH] Change THP code to use pud_page(pud)->ptl lock page_table_lock
Date: Fri, 30 Aug 2013 11:58:17 -0500
Message-Id: <1377881897-138063-2-git-send-email-athorlton@sgi.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1377881897-138063-1-git-send-email-athorlton@sgi.com>
References: <1377881897-138063-1-git-send-email-athorlton@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes out the page_table_lock for the pud_page ptl in the
THP fault path; pretty self-explanatory.  I got lazy and commented out
the spinlock assertion in follow_trans_huge_pmd instead of digging up
the pud_page ptl in this function.  This is just a proof of concept, so
I didn't feel that it was too important to keep around for now. 

---
 mm/huge_memory.c | 4 ++--
 mm/memory.c      | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a92012a..d3b34e2f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1240,10 +1240,10 @@ struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
 				   pmd_t *pmd,
 				   unsigned int flags)
 {
-	struct mm_struct *mm = vma->vm_mm;
+//	struct mm_struct *mm = vma->vm_mm;
 	struct page *page = NULL;
 
-	assert_spin_locked(&mm->page_table_lock);
+//	assert_spin_locked(&mm->page_table_lock);
 
 	if (flags & FOLL_WRITE && !pmd_write(*pmd))
 		goto out;
diff --git a/mm/memory.c b/mm/memory.c
index af84bc0..5b4e910 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1527,15 +1527,15 @@ struct page *follow_page_mask(struct vm_area_struct *vma,
 			split_huge_page_pmd(vma, address, pmd);
 			goto split_fallthrough;
 		}
-		spin_lock(&mm->page_table_lock);
+		spin_lock(&pud_page(*pud)->ptl);
 		if (likely(pmd_trans_huge(*pmd))) {
 			if (unlikely(pmd_trans_splitting(*pmd))) {
-				spin_unlock(&mm->page_table_lock);
+				spin_unlock(&pud_page(*pud)->ptl);
 				wait_split_huge_page(vma->anon_vma, pmd);
 			} else {
 				page = follow_trans_huge_pmd(vma, address,
 							     pmd, flags);
-				spin_unlock(&mm->page_table_lock);
+				spin_unlock(&pud_page(*pud)->ptl);
 				*page_mask = HPAGE_PMD_NR - 1;
 				goto out;
 			}
-- 
1.7.12.4

