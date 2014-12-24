Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaLXMcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:32:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:50935 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbaLXMXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,638,1413270000"; 
   d="scan'208";a="642376370"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 13/38] avr32: drop _PAGE_FILE and pte_file()-related helpers
Date: Wed, 24 Dec 2014 14:22:21 +0200
Message-Id: <1419423766-114457-14-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
 arch/avr32/include/asm/pgtable.h | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/arch/avr32/include/asm/pgtable.h b/arch/avr32/include/asm/pgtable.h
index 4beff97e2033..ac7a817e2126 100644
--- a/arch/avr32/include/asm/pgtable.h
+++ b/arch/avr32/include/asm/pgtable.h
@@ -86,9 +86,6 @@ extern struct page *empty_zero_page;
 #define _PAGE_BIT_PRESENT	10
 #define _PAGE_BIT_ACCESSED	11 /* software: page was accessed */
 
-/* The following flags are only valid when !PRESENT */
-#define _PAGE_BIT_FILE		0 /* software: pagecache or swap? */
-
 #define _PAGE_WT		(1 << _PAGE_BIT_WT)
 #define _PAGE_DIRTY		(1 << _PAGE_BIT_DIRTY)
 #define _PAGE_EXECUTE		(1 << _PAGE_BIT_EXECUTE)
@@ -101,7 +98,6 @@ extern struct page *empty_zero_page;
 /* Software flags */
 #define _PAGE_ACCESSED		(1 << _PAGE_BIT_ACCESSED)
 #define _PAGE_PRESENT		(1 << _PAGE_BIT_PRESENT)
-#define _PAGE_FILE		(1 << _PAGE_BIT_FILE)
 
 /*
  * Page types, i.e. sizes. _PAGE_TYPE_NONE corresponds to what is
@@ -210,14 +206,6 @@ static inline int pte_special(pte_t pte)
 	return 0;
 }
 
-/*
- * The following only work if pte_present() is not true.
- */
-static inline int pte_file(pte_t pte)
-{
-	return pte_val(pte) & _PAGE_FILE;
-}
-
 /* Mutator functions for PTE bits */
 static inline pte_t pte_wrprotect(pte_t pte)
 {
@@ -329,7 +317,6 @@ extern void update_mmu_cache(struct vm_area_struct * vma,
  * Encode and decode a swap entry
  *
  * Constraints:
- *   _PAGE_FILE at bit 0
  *   _PAGE_TYPE_* at bits 2-3 (for emulating _PAGE_PROTNONE)
  *   _PAGE_PRESENT at bit 10
  *
@@ -346,18 +333,6 @@ extern void update_mmu_cache(struct vm_area_struct * vma,
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
 
-/*
- * Encode and decode a nonlinear file mapping entry. We have to
- * preserve _PAGE_FILE and _PAGE_PRESENT here. _PAGE_TYPE_* isn't
- * necessary, since _PAGE_FILE implies !_PAGE_PROTNONE (?)
- */
-#define PTE_FILE_MAX_BITS	30
-#define pte_to_pgoff(pte)	(((pte_val(pte) >> 1) & 0x1ff)		\
-				 | ((pte_val(pte) >> 11) << 9))
-#define pgoff_to_pte(off)	((pte_t) { ((((off) & 0x1ff) << 1)	\
-					    | (((off) >> 9) << 11)	\
-					    | _PAGE_FILE) })
-
 typedef pte_t *pte_addr_t;
 
 #define kern_addr_valid(addr)	(1)
-- 
2.1.3

