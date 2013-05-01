Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab3EAR5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:57:50 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:33985 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3EAR5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:57:43 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 01 May 2013 23:20:30 +0530
Message-Id: <20130501175030.7229.32043.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20130501174950.7229.15267.sendpatchset@srdronam.in.ibm.com>
References: <20130501174950.7229.15267.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH 2/2] x86, mm: Prevent gcc to re-read the pagetables
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050117-9264-0000-0000-000003A6C68A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH 2/2] x86, mm: Prevent gcc to re-read the pagetables

GCC is very likely to read the pagetables just once and cache them in
the local stack or in a register, but it is can also decide to re-read
the pagetables. The problem is that the pagetable in those places can
change from under gcc.

In the page fault we only hold the ->mmap_sem for reading and both the
page fault and MADV_DONTNEED only take the ->mmap_sem for reading and we
don't hold any PT lock yet.

In get_user_pages_fast() the TLB shootdown code can clear the pagetables
before firing any TLB flush (the page can't be freed until the TLB
flushing IPI has been delivered but the pagetables will be cleared well
before sending any TLB flushing IPI).

With THP/hugetlbfs the pmd (and pud for hugetlbfs giga pages) can
change as well under gup_fast, it won't just be cleared for the same
reasons described above for the pte in the page fault case.

[ This patch was picked up from the AutoNUMA tree. ]

Originally-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
[ Ported to this tree, because we are modifying the page tables
  at a high rate here, so this problem is potentially more
  likely to show up in practice. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[ mostly unchanged except rebase to 3.9 ]
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/x86/mm/gup.c |   23 ++++++++++++++++++++---
 mm/memory.c       |    2 +-
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index dd74e46..6dc9921 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -150,7 +150,13 @@ static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
 
 	pmdp = pmd_offset(&pud, addr);
 	do {
-		pmd_t pmd = *pmdp;
+		/*
+		 * With THP and hugetlbfs the pmd can change from
+		 * under us and it can be cleared as well by the TLB
+		 * shootdown, so read it with ACCESS_ONCE to do all
+		 * computations on the same sampling.
+		 */
+		pmd_t pmd = ACCESS_ONCE(*pmdp);
 
 		next = pmd_addr_end(addr, end);
 		/*
@@ -220,7 +226,13 @@ static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 
 	pudp = pud_offset(&pgd, addr);
 	do {
-		pud_t pud = *pudp;
+		/*
+		 * With hugetlbfs giga pages the pud can change from
+		 * under us and it can be cleared as well by the TLB
+		 * shootdown, so read it with ACCESS_ONCE to do all
+		 * computations on the same sampling.
+		 */
+		pud_t pud = ACCESS_ONCE(*pudp);
 
 		next = pud_addr_end(addr, end);
 		if (pud_none(pud))
@@ -280,7 +292,12 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	local_irq_save(flags);
 	pgdp = pgd_offset(mm, addr);
 	do {
-		pgd_t pgd = *pgdp;
+		/*
+		 * The pgd could be cleared by the TLB shootdown from
+		 * under us so read it with ACCESS_ONCE to do all
+		 * computations on the same sampling.
+		 */
+		pgd_t pgd = ACCESS_ONCE(*pgdp);
 
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
diff --git a/mm/memory.c b/mm/memory.c
index e819b3e..5701b0f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3703,7 +3703,7 @@ int handle_pte_fault(struct mm_struct *mm,
 	pte_t entry;
 	spinlock_t *ptl;
 
-	entry = *pte;
+	entry = ACCESS_ONCE(*pte);
 	if (!pte_present(entry)) {
 		if (pte_none(entry)) {
 			if (vma->vm_ops) {
-- 
1.7.1


-- 
Thanks and Regards
Srikar Dronamraju

