Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3LMUBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:01:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab3LMUBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:01:17 -0500
From: Mel Gorman <mgorman@suse.de>
To: Alex Shi <alex.shi@linaro.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 4/4] x86: mm: Eliminate redundant page table walk during TLB range flushing
Date: Fri, 13 Dec 2013 20:01:10 +0000
Message-Id: <1386964870-6690-5-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386964870-6690-1-git-send-email-mgorman@suse.de>
References: <1386964870-6690-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When choosing between doing an address space or ranged flush, the x86
implementation of flush_tlb_mm_range takes into account whether there are
any large pages in the range. A per-page flush typically requires fewer
entries than would covered by a single large page and the check is redundant.

There is one potential exception. THP migration flushes single THP entries
and it conceivably would benefit from flushing a single entry instead
of the mm.  However, this flush is after a THP allocation, copy and page
table update potentially with any other threads serialised behind it. In
comparison to that, the flush is noise. It makes more sense to optimise
balancing to require fewer flushes than to optimise the flush itself.

This patch deletes the huge page check.

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
1.8.4

