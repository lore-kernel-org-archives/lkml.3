Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaLXMX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:23:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:17823 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbaLXMXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,638,1413270000"; 
   d="scan'208";a="628669906"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 28/38] parisc: drop _PAGE_FILE and pte_file()-related helpers
Date: Wed, 24 Dec 2014 14:22:36 +0200
Message-Id: <1419423766-114457-29-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
---
 arch/parisc/include/asm/pgtable.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index 22b89d1edba7..1d49a4a7749b 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -146,7 +146,6 @@ extern void purge_tlb_entries(struct mm_struct *, unsigned long);
 #define _PAGE_GATEWAY_BIT  28   /* (0x008) privilege promotion allowed */
 #define _PAGE_DMB_BIT      27   /* (0x010) Data Memory Break enable (B bit) */
 #define _PAGE_DIRTY_BIT    26   /* (0x020) Page Dirty (D bit) */
-#define _PAGE_FILE_BIT	_PAGE_DIRTY_BIT	/* overload this bit */
 #define _PAGE_REFTRAP_BIT  25   /* (0x040) Page Ref. Trap enable (T bit) */
 #define _PAGE_NO_CACHE_BIT 24   /* (0x080) Uncached Page (U bit) */
 #define _PAGE_ACCESSED_BIT 23   /* (0x100) Software: Page Accessed */
@@ -167,13 +166,6 @@ extern void purge_tlb_entries(struct mm_struct *, unsigned long);
 /* PFN_PTE_SHIFT defines the shift of a PTE value to access the PFN field */
 #define PFN_PTE_SHIFT		12
 
-
-/* this is how many bits may be used by the file functions */
-#define PTE_FILE_MAX_BITS	(BITS_PER_LONG - PTE_SHIFT)
-
-#define pte_to_pgoff(pte) (pte_val(pte) >> PTE_SHIFT)
-#define pgoff_to_pte(off) ((pte_t) { ((off) << PTE_SHIFT) | _PAGE_FILE })
-
 #define _PAGE_READ     (1 << xlate_pabit(_PAGE_READ_BIT))
 #define _PAGE_WRITE    (1 << xlate_pabit(_PAGE_WRITE_BIT))
 #define _PAGE_RW       (_PAGE_READ | _PAGE_WRITE)
@@ -186,7 +178,6 @@ extern void purge_tlb_entries(struct mm_struct *, unsigned long);
 #define _PAGE_ACCESSED (1 << xlate_pabit(_PAGE_ACCESSED_BIT))
 #define _PAGE_PRESENT  (1 << xlate_pabit(_PAGE_PRESENT_BIT))
 #define _PAGE_USER     (1 << xlate_pabit(_PAGE_USER_BIT))
-#define _PAGE_FILE     (1 << xlate_pabit(_PAGE_FILE_BIT))
 
 #define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_READ | _PAGE_WRITE |  _PAGE_DIRTY | _PAGE_ACCESSED)
 #define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
@@ -344,7 +335,6 @@ static inline void pgd_clear(pgd_t * pgdp)	{ }
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_WRITE; }
-static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_special(pte_t pte)	{ return 0; }
 
 static inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
-- 
2.1.3

