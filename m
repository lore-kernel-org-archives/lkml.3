Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaLXMZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:25:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:55472 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbaLXMXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,638,1413270000"; 
   d="scan'208";a="642376414"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
Subject: [PATCH 35/38] um: drop _PAGE_FILE and pte_file()-related helpers
Date: Wed, 24 Dec 2014 14:22:43 +0200
Message-Id: <1419423766-114457-36-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
---
 arch/um/include/asm/pgtable-2level.h |  9 ---------
 arch/um/include/asm/pgtable-3level.h | 20 --------------------
 arch/um/include/asm/pgtable.h        |  9 ---------
 3 files changed, 38 deletions(-)

diff --git a/arch/um/include/asm/pgtable-2level.h b/arch/um/include/asm/pgtable-2level.h
index f534b73e753e..7afe86035fa7 100644
--- a/arch/um/include/asm/pgtable-2level.h
+++ b/arch/um/include/asm/pgtable-2level.h
@@ -41,13 +41,4 @@ static inline void pgd_mkuptodate(pgd_t pgd)	{ }
 #define pfn_pte(pfn, prot) __pte(pfn_to_phys(pfn) | pgprot_val(prot))
 #define pfn_pmd(pfn, prot) __pmd(pfn_to_phys(pfn) | pgprot_val(prot))
 
-/*
- * Bits 0 through 4 are taken
- */
-#define PTE_FILE_MAX_BITS	27
-
-#define pte_to_pgoff(pte) (pte_val(pte) >> 5)
-
-#define pgoff_to_pte(off) ((pte_t) { ((off) << 5) + _PAGE_FILE })
-
 #endif
diff --git a/arch/um/include/asm/pgtable-3level.h b/arch/um/include/asm/pgtable-3level.h
index 0032f9212e74..344c559c0a17 100644
--- a/arch/um/include/asm/pgtable-3level.h
+++ b/arch/um/include/asm/pgtable-3level.h
@@ -112,25 +112,5 @@ static inline pmd_t pfn_pmd(pfn_t page_nr, pgprot_t pgprot)
 	return __pmd((page_nr << PAGE_SHIFT) | pgprot_val(pgprot));
 }
 
-/*
- * Bits 0 through 3 are taken in the low part of the pte,
- * put the 32 bits of offset into the high part.
- */
-#define PTE_FILE_MAX_BITS	32
-
-#ifdef CONFIG_64BIT
-
-#define pte_to_pgoff(p) ((p).pte >> 32)
-
-#define pgoff_to_pte(off) ((pte_t) { ((off) << 32) | _PAGE_FILE })
-
-#else
-
-#define pte_to_pgoff(pte) ((pte).pte_high)
-
-#define pgoff_to_pte(off) ((pte_t) { _PAGE_FILE, (off) })
-
-#endif
-
 #endif
 
diff --git a/arch/um/include/asm/pgtable.h b/arch/um/include/asm/pgtable.h
index bf974f712af7..2324b624f195 100644
--- a/arch/um/include/asm/pgtable.h
+++ b/arch/um/include/asm/pgtable.h
@@ -18,7 +18,6 @@
 #define _PAGE_ACCESSED	0x080
 #define _PAGE_DIRTY	0x100
 /* If _PAGE_PRESENT is clear, we use these: */
-#define _PAGE_FILE	0x008	/* nonlinear file mapping, saved PTE; unset:swap */
 #define _PAGE_PROTNONE	0x010	/* if the user mapped it with PROT_NONE;
 				   pte_present gives true */
 
@@ -151,14 +150,6 @@ static inline int pte_write(pte_t pte)
 	       !(pte_get_bits(pte, _PAGE_PROTNONE)));
 }
 
-/*
- * The following only works if pte_present() is not true.
- */
-static inline int pte_file(pte_t pte)
-{
-	return pte_get_bits(pte, _PAGE_FILE);
-}
-
 static inline int pte_dirty(pte_t pte)
 {
 	return pte_get_bits(pte, _PAGE_DIRTY);
-- 
2.1.3

