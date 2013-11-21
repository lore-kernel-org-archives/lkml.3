Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3KUMre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:47:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:26147 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab3KUMrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:47:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,744,1378882800"; 
   d="scan'208";a="437269831"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] x86, mm: do not leak page->ptl for pmd page tables
Date: Thu, 21 Nov 2013 14:46:47 +0200
Message-Id: <1385038007-29666-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two code paths how page with pmd page table can be freed:
pmd_free() and pmd_free_tlb().

I've missed the second one and didn't add page table destructor call
there. It leads to leak of page->ptl for pmd page tables, if dynamically
allocated page->ptl is in use.

The patch adds the missed destructor and modifies documentation
accordingly.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-and-Tested-by: Andrey Vagin <avagin@openvz.org>
---
 Documentation/vm/split_page_table_lock | 6 +++---
 arch/x86/mm/pgtable.c                  | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/vm/split_page_table_lock b/Documentation/vm/split_page_table_lock
index 7521d367f21d..6dea4fd5c961 100644
--- a/Documentation/vm/split_page_table_lock
+++ b/Documentation/vm/split_page_table_lock
@@ -63,9 +63,9 @@ levels.
 PMD split lock enabling requires pgtable_pmd_page_ctor() call on PMD table
 allocation and pgtable_pmd_page_dtor() on freeing.
 
-Allocation usually happens in pmd_alloc_one(), freeing in pmd_free(), but
-make sure you cover all PMD table allocation / freeing paths: i.e X86_PAE
-preallocate few PMDs on pgd_alloc().
+Allocation usually happens in pmd_alloc_one(), freeing in pmd_free() and
+pmd_free_tlb(), but make sure you cover all PMD table allocation / freeing
+paths: i.e X86_PAE preallocate few PMDs on pgd_alloc().
 
 With everything in place you can set CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK.
 
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index a7cccb6d7fec..7be5809754cf 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -61,6 +61,7 @@ void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 #if PAGETABLE_LEVELS > 2
 void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
+	struct page *page = virt_to_page(pmd);
 	paravirt_release_pmd(__pa(pmd) >> PAGE_SHIFT);
 	/*
 	 * NOTE! For PAE, any changes to the top page-directory-pointer-table
@@ -69,7 +70,8 @@ void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 #ifdef CONFIG_X86_PAE
 	tlb->need_flush_all = 1;
 #endif
-	tlb_remove_page(tlb, virt_to_page(pmd));
+	pgtable_pmd_page_dtor(page);
+	tlb_remove_page(tlb, page);
 }
 
 #if PAGETABLE_LEVELS > 3
-- 
1.8.4.3

