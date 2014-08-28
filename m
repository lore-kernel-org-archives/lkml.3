Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaH1Sgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:36:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbaH1SgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:05 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 18/97] x86/mm: Eliminate redundant page table walk during TLB range flushing
Date: Thu, 28 Aug 2014 19:34:26 +0100
Message-Id: <1409250945-30874-19-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 71b54f8263860a37dd9f50f81880a9d681fd9c10 upstream.

When choosing between doing an address space or ranged flush,
the x86 implementation of flush_tlb_mm_range takes into account
whether there are any large pages in the range.  A per-page
flush typically requires fewer entries than would covered by a
single large page and the check is redundant.

There is one potential exception.  THP migration flushes single
THP entries and it conceivably would benefit from flushing a
single entry instead of the mm.  However, this flush is after a
THP allocation, copy and page table update potentially with any
other threads serialised behind it.  In comparison to that, the
flush is noise.  It makes more sense to optimise balancing to
require fewer flushes than to optimise the flush itself.

This patch deletes the redundant huge page check.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-sgei1drpOcburujPsfh6ovmo@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/x86/mm/tlb.c | 28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 5176526..dd8dda1 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -158,32 +158,6 @@ void flush_tlb_current_task(void)
 	preempt_enable();
 }
 
-/*
- * It can find out the THP large page, or
- * HUGETLB page in tlb_flush when THP disabled
- */
-static inline unsigned long has_large_page(struct mm_struct *mm,
-				 unsigned long start, unsigned long end)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	unsigned long addr = ALIGN(start, HPAGE_SIZE);
-	for (; addr < end; addr += HPAGE_SIZE) {
-		pgd = pgd_offset(mm, addr);
-		if (likely(!pgd_none(*pgd))) {
-			pud = pud_offset(pgd, addr);
-			if (likely(!pud_none(*pud))) {
-				pmd = pmd_offset(pud, addr);
-				if (likely(!pmd_none(*pmd)))
-					if (pmd_large(*pmd))
-						return addr;
-			}
-		}
-	}
-	return 0;
-}
-
 void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned long vmflag)
 {
@@ -218,7 +192,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 	nr_base_pages = (end - start) >> PAGE_SHIFT;
 
 	/* tlb_flushall_shift is on balance point, details in commit log */
-	if (nr_base_pages > act_entries || has_large_page(mm, start, end)) {
+	if (nr_base_pages > act_entries) {
 		count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 		local_flush_tlb();
 	} else {
-- 
1.8.4.5

