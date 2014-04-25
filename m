Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbaDYToL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:44:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46107 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbaDYTnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:43:55 -0400
Date: Fri, 25 Apr 2014 15:43:54 -0400 (EDT)
Message-Id: <20140425.154354.575760952778725388.davem@davemloft.net>
To: sparclinux@vger.kernel.org
CC: mroos@linux.ee, aaro.koskinen@iki.fi, hughd@google.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] sparc64: Fix bugs in get_user_pages_fast() wrt. THP.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Apr 2014 12:43:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


First of all, we were blocking the wrong kind of interrupts
over the page table scan.

%pil based interrupts (the ones blocked by local_irq_disable) are not
the type which are used to deliver remote TLB flushes.  Rather,
interrupt vectors are used for that.

And interrupt vector delivery can only be blocked by turning off
PSTATE_IE in the %pstate register.

So use that instead of local_irq_{disable,enable}().

Secondly, the large PMD path needs to check _PAGE_VALID not
_PAGE_PRESENT, to decide if it needs to bail and return 0.

pmd_large() should therefore just check _PAGE_PMD_HUGE.

Calls to gup_huge_pmd() are guarded with a check of pmd_large(), so we
just need to add a valid bit check.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/pgtable_64.h |  2 +-
 arch/sparc/mm/gup.c                 | 19 +++++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index e3db4b8..1f28103 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -633,7 +633,7 @@ static inline unsigned long pmd_large(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
 
-	return (pte_val(pte) & _PAGE_PMD_HUGE) && pte_present(pte);
+	return pte_val(pte) & _PAGE_PMD_HUGE;
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/arch/sparc/mm/gup.c b/arch/sparc/mm/gup.c
index c4d3da6..97fb4fc 100644
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -73,7 +73,7 @@ static int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 	struct page *head, *page, *tail;
 	int refs;
 
-	if (!pmd_large(pmd))
+	if (!(pmd_val(pmd) & _PAGE_VALID))
 		return 0;
 
 	if (write && !pmd_write(pmd))
@@ -165,7 +165,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long addr, len, end;
-	unsigned long next;
+	unsigned long next, pstate;
 	pgd_t *pgdp;
 	int nr = 0;
 
@@ -191,7 +191,12 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 * So long as we atomically load page table pointers versus teardown,
 	 * we can follow the address down to the the page and take a ref on it.
 	 */
-	local_irq_disable();
+	__asm__ __volatile__(
+		"rdpr %%pstate, %0\n\t"
+		"andn %0, %1, %0\n\t"
+		"wrpr %0, %%g0, %%pstate"
+		: "=&r" (pstate)
+		: "i" (PSTATE_IE));
 
 	pgdp = pgd_offset(mm, addr);
 	do {
@@ -204,7 +209,13 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			goto slow;
 	} while (pgdp++, addr = next, addr != end);
 
-	local_irq_enable();
+	/* Re-enable interrupts. */
+	__asm__ __volatile__(
+		"rdpr %%pstate, %0\n\t"
+		"or %0, %1, %0\n\t"
+		"wrpr %0, %%g0, %%pstate"
+		: "=&r" (pstate)
+		: "i" (PSTATE_IE));
 
 	VM_BUG_ON(nr != (end - start) >> PAGE_SHIFT);
 	return nr;
-- 
1.9.0

