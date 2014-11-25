Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbaKYMjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:39:51 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:43424 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaKYMix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:38:53 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "linux-arch@vger.kernel.org, linux-mips@linux-mips.org, linux-x86_64@vger.kernel.org, linux-s390"@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCHv2 03/10] mm: replace ACCESS_ONCE with READ_ONCE
Date: Tue, 25 Nov 2014 13:38:30 +0100
Message-Id: <1416919117-50652-4-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416919117-50652-1-git-send-email-borntraeger@de.ibm.com>
References: <1416919117-50652-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112512-0017-0000-0000-000001F84CA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)

Let's change the code to access the page table elements with
READ_ONCE that does implicit scalar accesses.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 mm/gup.c    | 2 +-
 mm/memory.c | 2 +-
 mm/rmap.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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
index 3e50383..9e0c84e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3202,7 +3202,7 @@ static int handle_pte_fault(struct mm_struct *mm,
 	pte_t entry;
 	spinlock_t *ptl;
 
-	entry = ACCESS_ONCE(*pte);
+	entry = READ_ONCE(*pte);
 	if (!pte_present(entry)) {
 		if (pte_none(entry)) {
 			if (vma->vm_ops) {
diff --git a/mm/rmap.c b/mm/rmap.c
index 19886fb..3152a9c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -581,7 +581,7 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
 	 * without holding anon_vma lock for write.  So when looking for a
 	 * genuine pmde (in which to find pte), test present and !THP together.
 	 */
-	pmde = ACCESS_ONCE(*pmd);
+	pmde = READ_ONCE(*pmd);
 	if (!pmd_present(pmde) || pmd_trans_huge(pmde))
 		pmd = NULL;
 out:
-- 
1.9.3

