Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965064AbaLKOH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:07:58 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:53414 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032AbaLKOF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:05:27 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, George Spelvin <linux@horizon.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org
Subject: [PATCH 2/8] mm: replace ACCESS_ONCE with READ_ONCE or barriers
Date: Thu, 11 Dec 2014 15:05:05 +0100
Message-Id: <1418306712-17245-3-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418306712-17245-1-git-send-email-borntraeger@de.ibm.com>
References: <1418306712-17245-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121114-0013-0000-0000-0000022E3D8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)

Let's change the code to access the page table elements with
READ_ONCE that does implicit scalar accesses for the gup code.

mm_find_pmd is tricky, because m68k and sparc(32bit) define pmd_t
as array of longs. This code requires just that the pmd_present
and pmd_trans_huge check are done on the same value, so a barrier
is sufficent.

A similar case is in handle_pte_fault. On ppc44x the word size is
32 bit, but a pte is 64 bit. A barrier is ok as well.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-mm@kvack.org
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 mm/gup.c    |  2 +-
 mm/memory.c | 11 ++++++++++-
 mm/rmap.c   |  3 ++-
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index cd62c8c..f2305de 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -917,7 +917,7 @@ static int gup_pud_range(pgd_t *pgdp, unsigned long addr, unsigned long end,
 
 	pudp = pud_offset(pgdp, addr);
 	do {
-		pud_t pud = ACCESS_ONCE(*pudp);
+		pud_t pud = READ_ONCE(*pudp);
 
 		next = pud_addr_end(addr, end);
 		if (pud_none(pud))
diff --git a/mm/memory.c b/mm/memory.c
index 3e50383..d86aa88 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3202,7 +3202,16 @@ static int handle_pte_fault(struct mm_struct *mm,
 	pte_t entry;
 	spinlock_t *ptl;
 
-	entry = ACCESS_ONCE(*pte);
+	/*
+	 * some architectures can have larger ptes than wordsize,
+	 * e.g.ppc44x-defconfig has CONFIG_PTE_64BIT=y and CONFIG_32BIT=y,
+	 * so READ_ONCE or ACCESS_ONCE cannot guarantee atomic accesses.
+	 * The code below just needs a consistent view for the ifs and
+	 * we later double check anyway with the ptl lock held. So here
+	 * a barrier will do.
+	 */
+	entry = *pte;
+	barrier();
 	if (!pte_present(entry)) {
 		if (pte_none(entry)) {
 			if (vma->vm_ops) {
diff --git a/mm/rmap.c b/mm/rmap.c
index 19886fb..1e54274 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -581,7 +581,8 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
 	 * without holding anon_vma lock for write.  So when looking for a
 	 * genuine pmde (in which to find pte), test present and !THP together.
 	 */
-	pmde = ACCESS_ONCE(*pmd);
+	pmde = *pmd;
+	barrier();
 	if (!pmd_present(pmde) || pmd_trans_huge(pmde))
 		pmd = NULL;
 out:
-- 
1.9.3

