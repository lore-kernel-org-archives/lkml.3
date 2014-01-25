Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaAYOZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:25:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52551 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaAYOZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:25:48 -0500
Date: Sat, 25 Jan 2014 06:25:08 -0800
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-71b54f8263860a37dd9f50f81880a9d681fd9c10@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        alex.shi@linaro.org, akpm@linux-foundation.org, mgorman@suse.de,
        tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        alex.shi@linaro.org, akpm@linux-foundation.org, mgorman@suse.de,
        tglx@linutronix.de, davidlohr@hp.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm:
  Eliminate redundant page table walk during TLB range flushing
Git-Commit-ID: 71b54f8263860a37dd9f50f81880a9d681fd9c10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:25:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71b54f8263860a37dd9f50f81880a9d681fd9c10
Gitweb:     http://git.kernel.org/tip/71b54f8263860a37dd9f50f81880a9d681fd9c10
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Tue, 21 Jan 2014 14:33:19 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 25 Jan 2014 09:10:43 +0100

x86/mm: Eliminate redundant page table walk during TLB range flushing

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
