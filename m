Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaLXM2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:28:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:28627 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbaLXMXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="432964940"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Ley Foon Tan <lftan@altera.com>
Subject: [PATCH 26/38] nios2: drop _PAGE_FILE and pte_file()-related helpers
Date: Wed, 24 Dec 2014 14:22:34 +0200
Message-Id: <1419423766-114457-27-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/pgtable-bits.h |  1 -
 arch/nios2/include/asm/pgtable.h      | 10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/nios2/include/asm/pgtable-bits.h b/arch/nios2/include/asm/pgtable-bits.h
index ce9e7069aa96..bfddff383e89 100644
--- a/arch/nios2/include/asm/pgtable-bits.h
+++ b/arch/nios2/include/asm/pgtable-bits.h
@@ -30,6 +30,5 @@
 #define _PAGE_PRESENT	(1<<25)	/* PTE contains a translation */
 #define _PAGE_ACCESSED	(1<<26)	/* page referenced */
 #define _PAGE_DIRTY	(1<<27)	/* dirty page */
-#define _PAGE_FILE	(1<<28)	/* PTE used for file mapping or swap */
 
 #endif /* _ASM_NIOS2_PGTABLE_BITS_H */
diff --git a/arch/nios2/include/asm/pgtable.h b/arch/nios2/include/asm/pgtable.h
index ccbaffd47671..7b292e3a3138 100644
--- a/arch/nios2/include/asm/pgtable.h
+++ b/arch/nios2/include/asm/pgtable.h
@@ -112,8 +112,6 @@ static inline int pte_dirty(pte_t pte)		\
 	{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		\
 	{ return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_file(pte_t pte)		\
-	{ return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_special(pte_t pte)	{ return 0; }
 
 #define pgprot_noncached pgprot_noncached
@@ -272,8 +270,7 @@ static inline void pte_clear(struct mm_struct *mm,
 		__FILE__, __LINE__, pgd_val(e))
 
 /*
- * Encode and decode a swap entry (must be !pte_none(pte) && !pte_present(pte)
- * && !pte_file(pte)):
+ * Encode and decode a swap entry (must be !pte_none(pte) && !pte_present(pte):
  *
  * 31 30 29 28 27 26 25 24 23 22 21 20 19 18 ...  1  0
  *  0  0  0  0 type.  0  0  0  0  0  0 offset.........
@@ -290,11 +287,6 @@ static inline void pte_clear(struct mm_struct *mm,
 #define __swp_entry_to_pte(swp)	((pte_t) { (swp).val })
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 
-/* Encode and decode a nonlinear file mapping entry */
-#define PTE_FILE_MAX_BITS	25
-#define pte_to_pgoff(pte)	(pte_val(pte) & 0x1ffffff)
-#define pgoff_to_pte(off)	__pte(((off) & 0x1ffffff) | _PAGE_FILE)
-
 #define kern_addr_valid(addr)		(1)
 
 #include <asm-generic/pgtable.h>
-- 
2.1.3

