Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaLXM1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:27:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:55472 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbaLXMXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,638,1413270000"; 
   d="scan'208";a="642376399"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Chen Liqin <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 31/38] score: drop _PAGE_FILE and pte_file()-related helpers
Date: Wed, 24 Dec 2014 14:22:39 +0200
Message-Id: <1419423766-114457-32-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

This patch also increase number of bits availble for swap offset.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
---
 arch/score/include/asm/pgtable-bits.h |  1 -
 arch/score/include/asm/pgtable.h      | 18 ++----------------
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/score/include/asm/pgtable-bits.h b/arch/score/include/asm/pgtable-bits.h
index 7d65a96a82e5..0e5c6f466520 100644
--- a/arch/score/include/asm/pgtable-bits.h
+++ b/arch/score/include/asm/pgtable-bits.h
@@ -6,7 +6,6 @@
 #define _PAGE_WRITE			(1<<7)	/* implemented in software */
 #define _PAGE_PRESENT			(1<<9)	/* implemented in software */
 #define _PAGE_MODIFIED			(1<<10)	/* implemented in software */
-#define _PAGE_FILE			(1<<10)
 
 #define _PAGE_GLOBAL			(1<<0)
 #define _PAGE_VALID			(1<<1)
diff --git a/arch/score/include/asm/pgtable.h b/arch/score/include/asm/pgtable.h
index db96ad9afc03..5170ffdea643 100644
--- a/arch/score/include/asm/pgtable.h
+++ b/arch/score/include/asm/pgtable.h
@@ -90,15 +90,6 @@ static inline void pmd_clear(pmd_t *pmdp)
 	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
 #define pte_unmap(pte) ((void)(pte))
 
-/*
- * Bits 9(_PAGE_PRESENT) and 10(_PAGE_FILE)are taken,
- * split up 30 bits of offset into this range:
- */
-#define PTE_FILE_MAX_BITS	30
-#define pte_to_pgoff(_pte)		\
-	(((_pte).pte & 0x1ff) | (((_pte).pte >> 11) << 9))
-#define pgoff_to_pte(off)		\
-	((pte_t) {((off) & 0x1ff) | (((off) >> 9) << 11) | _PAGE_FILE})
 #define __pte_to_swp_entry(pte)		\
 	((swp_entry_t) { pte_val(pte)})
 #define __swp_entry_to_pte(x)	((pte_t) {(x).val})
@@ -169,8 +160,8 @@ static inline pgprot_t pgprot_noncached(pgprot_t _prot)
 }
 
 #define __swp_type(x)		((x).val & 0x1f)
-#define __swp_offset(x) 	((x).val >> 11)
-#define __swp_entry(type, offset) ((swp_entry_t){(type) | ((offset) << 11)})
+#define __swp_offset(x) 	((x).val >> 10)
+#define __swp_entry(type, offset) ((swp_entry_t){(type) | ((offset) << 10)})
 
 extern unsigned long empty_zero_page;
 extern unsigned long zero_page_mask;
@@ -198,11 +189,6 @@ static inline int pte_young(pte_t pte)
 	return pte_val(pte) & _PAGE_ACCESSED;
 }
 
-static inline int pte_file(pte_t pte)
-{
-	return pte_val(pte) & _PAGE_FILE;
-}
-
 #define pte_special(pte)	(0)
 
 static inline pte_t pte_wrprotect(pte_t pte)
-- 
2.1.3

