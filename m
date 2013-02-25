Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab3BYWUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:20:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417Ab3BYWUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 54/58] sparc64: Fix get_user_pages_fast() wrt. THP.
Date: Mon, 25 Feb 2013 14:19:50 -0800
Message-Id: <20130225221647.806519639@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 89a77915e0f56dc7b9f9082ba787895b6a83f809 ]

Mostly mirrors the s390 logic, as unlike x86 we don't need the
SetPageReferenced() bits.

On sparc64 we also lack a user/privileged bit in the huge PMDs.

In order to make this work for THP and non-THP builds, some header
file adjustments were necessary.  Namely, provide the PMD_HUGE_* bit
defines and the pmd_large() inline unconditionally rather than
protected by TRANSPARENT_HUGEPAGE.

Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/pgtable_64.h |   14 +++-----
 arch/sparc/mm/gup.c                 |   59 ++++++++++++++++++++++++++++++++++--
 2 files changed, 63 insertions(+), 10 deletions(-)

--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -71,7 +71,6 @@
 #define PMD_PADDR	_AC(0xfffffffe,UL)
 #define PMD_PADDR_SHIFT	_AC(11,UL)
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define PMD_ISHUGE	_AC(0x00000001,UL)
 
 /* This is the PMD layout when PMD_ISHUGE is set.  With 4MB huge
@@ -86,7 +85,6 @@
 #define PMD_HUGE_ACCESSED	_AC(0x00000080,UL)
 #define PMD_HUGE_EXEC		_AC(0x00000040,UL)
 #define PMD_HUGE_SPLITTING	_AC(0x00000020,UL)
-#endif
 
 /* PGDs point to PMD tables which are 8K aligned.  */
 #define PGD_PADDR	_AC(0xfffffffc,UL)
@@ -622,6 +620,12 @@ static inline unsigned long pte_special(
 	return pte_val(pte) & _PAGE_SPECIAL;
 }
 
+static inline int pmd_large(pmd_t pmd)
+{
+	return (pmd_val(pmd) & (PMD_ISHUGE | PMD_HUGE_PRESENT)) ==
+		(PMD_ISHUGE | PMD_HUGE_PRESENT);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_young(pmd_t pmd)
 {
@@ -640,12 +644,6 @@ static inline unsigned long pmd_pfn(pmd_
 	return val >> (PAGE_SHIFT - PMD_PADDR_SHIFT);
 }
 
-static inline int pmd_large(pmd_t pmd)
-{
-	return (pmd_val(pmd) & (PMD_ISHUGE | PMD_HUGE_PRESENT)) ==
-		(PMD_ISHUGE | PMD_HUGE_PRESENT);
-}
-
 static inline int pmd_trans_splitting(pmd_t pmd)
 {
 	return (pmd_val(pmd) & (PMD_ISHUGE|PMD_HUGE_SPLITTING)) ==
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -66,6 +66,56 @@ static noinline int gup_pte_range(pmd_t
 	return 1;
 }
 
+static int gup_huge_pmd(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
+			unsigned long end, int write, struct page **pages,
+			int *nr)
+{
+	struct page *head, *page, *tail;
+	u32 mask;
+	int refs;
+
+	mask = PMD_HUGE_PRESENT;
+	if (write)
+		mask |= PMD_HUGE_WRITE;
+	if ((pmd_val(pmd) & mask) != mask)
+		return 0;
+
+	refs = 0;
+	head = pmd_page(pmd);
+	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
+	tail = page;
+	do {
+		VM_BUG_ON(compound_head(page) != head);
+		pages[*nr] = page;
+		(*nr)++;
+		page++;
+		refs++;
+	} while (addr += PAGE_SIZE, addr != end);
+
+	if (!page_cache_add_speculative(head, refs)) {
+		*nr -= refs;
+		return 0;
+	}
+
+	if (unlikely(pmd_val(pmd) != pmd_val(*pmdp))) {
+		*nr -= refs;
+		while (refs--)
+			put_page(head);
+		return 0;
+	}
+
+	/* Any tail page need their mapcount reference taken before we
+	 * return.
+	 */
+	while (refs--) {
+		if (PageTail(tail))
+			get_huge_page_tail(tail);
+		tail++;
+	}
+
+	return 1;
+}
+
 static int gup_pmd_range(pud_t pud, unsigned long addr, unsigned long end,
 		int write, struct page **pages, int *nr)
 {
@@ -77,9 +127,14 @@ static int gup_pmd_range(pud_t pud, unsi
 		pmd_t pmd = *pmdp;
 
 		next = pmd_addr_end(addr, end);
-		if (pmd_none(pmd))
+		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
 			return 0;
-		if (!gup_pte_range(pmd, addr, next, write, pages, nr))
+		if (unlikely(pmd_large(pmd))) {
+			if (!gup_huge_pmd(pmdp, pmd, addr, next,
+					  write, pages, nr))
+				return 0;
+		} else if (!gup_pte_range(pmd, addr, next, write,
+					  pages, nr))
 			return 0;
 	} while (pmdp++, addr = next, addr != end);
 


