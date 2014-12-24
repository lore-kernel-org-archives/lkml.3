Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaLXMbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:31:00 -0500
Received: from mga14.intel.com ([192.55.52.115]:61029 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbaLXMXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,638,1413270000"; 
   d="scan'208";a="628669828"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 17/38] frv: drop _PAGE_FILE and pte_file()-related helpers
Date: Wed, 24 Dec 2014 14:22:25 +0200
Message-Id: <1419423766-114457-18-git-send-email-kirill.shutemov@linux.intel.com>
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
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/include/asm/pgtable.h | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/arch/frv/include/asm/pgtable.h b/arch/frv/include/asm/pgtable.h
index eb0110acd19b..c49699d5902d 100644
--- a/arch/frv/include/asm/pgtable.h
+++ b/arch/frv/include/asm/pgtable.h
@@ -62,10 +62,6 @@ typedef pte_t *pte_addr_t;
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
 
-#ifndef __ASSEMBLY__
-static inline int pte_file(pte_t pte) { return 0; }
-#endif
-
 #define ZERO_PAGE(vaddr)	({ BUG(); NULL; })
 
 #define swapper_pg_dir		((pgd_t *) NULL)
@@ -298,7 +294,6 @@ static inline pmd_t *pmd_offset(pud_t *dir, unsigned long address)
 
 #define _PAGE_RESERVED_MASK	(xAMPRx_RESERVED8 | xAMPRx_RESERVED13)
 
-#define _PAGE_FILE		0x002	/* set:pagecache unset:swap */
 #define _PAGE_PROTNONE		0x000	/* If not present */
 
 #define _PAGE_CHG_MASK		(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
@@ -463,27 +458,15 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
  * Handle swap and file entries
  * - the PTE is encoded in the following format:
  *	bit 0:		Must be 0 (!_PAGE_PRESENT)
- *	bit 1:		Type: 0 for swap, 1 for file (_PAGE_FILE)
- *	bits 2-7:	Swap type
- *	bits 8-31:	Swap offset
- *	bits 2-31:	File pgoff
+ *	bits 1-6:	Swap type
+ *	bits 7-31:	Swap offset
  */
-#define __swp_type(x)			(((x).val >> 2) & 0x1f)
-#define __swp_offset(x)			((x).val >> 8)
-#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 2) | ((offset) << 8) })
+#define __swp_type(x)			(((x).val >> 1) & 0x1f)
+#define __swp_offset(x)			((x).val >> 7)
+#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 1) | ((offset) << 7) })
 #define __pte_to_swp_entry(_pte)	((swp_entry_t) { (_pte).pte })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-static inline int pte_file(pte_t pte)
-{
-	return pte.pte & _PAGE_FILE;
-}
-
-#define PTE_FILE_MAX_BITS	29
-
-#define pte_to_pgoff(PTE)	((PTE).pte >> 2)
-#define pgoff_to_pte(off)	__pte((off) << 2 | _PAGE_FILE)
-
 /* Needs to be defined here and not in linux/mm.h, as it is arch dependent */
 #define PageSkip(page)		(0)
 #define kern_addr_valid(addr)	(1)
-- 
2.1.3

