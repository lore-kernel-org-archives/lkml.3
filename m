Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaLXMXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:23:17 -0500
Received: from mga14.intel.com ([192.55.52.115]:61029 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbaLXMXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,638,1413270000"; 
   d="scan'208";a="628669838"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michal Simek <monstr@monstr.eu>
Subject: [PATCH 23/38] microblaze: drop _PAGE_FILE and pte_file()-related helpers
Date: Wed, 24 Dec 2014 14:22:31 +0200
Message-Id: <1419423766-114457-24-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/pgtable.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/microblaze/include/asm/pgtable.h b/arch/microblaze/include/asm/pgtable.h
index df19d0c47be8..91b9b46fbb5d 100644
--- a/arch/microblaze/include/asm/pgtable.h
+++ b/arch/microblaze/include/asm/pgtable.h
@@ -40,10 +40,6 @@ extern int mem_init_done;
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
 
-#ifndef __ASSEMBLY__
-static inline int pte_file(pte_t pte) { return 0; }
-#endif /* __ASSEMBLY__ */
-
 #define ZERO_PAGE(vaddr)	({ BUG(); NULL; })
 
 #define swapper_pg_dir ((pgd_t *) NULL)
@@ -207,7 +203,6 @@ static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
 
 /* Definitions for MicroBlaze. */
 #define	_PAGE_GUARDED	0x001	/* G: page is guarded from prefetch */
-#define _PAGE_FILE	0x001	/* when !present: nonlinear file mapping */
 #define _PAGE_PRESENT	0x002	/* software: PTE contains a translation */
 #define	_PAGE_NO_CACHE	0x004	/* I: caching is inhibited */
 #define	_PAGE_WRITETHRU	0x008	/* W: caching is write-through */
@@ -337,7 +332,6 @@ static inline int pte_write(pte_t pte) { return pte_val(pte) & _PAGE_RW; }
 static inline int pte_exec(pte_t pte)  { return pte_val(pte) & _PAGE_EXEC; }
 static inline int pte_dirty(pte_t pte) { return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte) { return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_file(pte_t pte)  { return pte_val(pte) & _PAGE_FILE; }
 
 static inline void pte_uncache(pte_t pte) { pte_val(pte) |= _PAGE_NO_CACHE; }
 static inline void pte_cache(pte_t pte)   { pte_val(pte) &= ~_PAGE_NO_CACHE; }
@@ -499,11 +493,6 @@ static inline pmd_t *pmd_offset(pgd_t *dir, unsigned long address)
 
 #define pte_unmap(pte)		kunmap_atomic(pte)
 
-/* Encode and decode a nonlinear file mapping entry */
-#define PTE_FILE_MAX_BITS	29
-#define pte_to_pgoff(pte)	(pte_val(pte) >> 3)
-#define pgoff_to_pte(off)	((pte_t) { ((off) << 3) | _PAGE_FILE })
-
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
 /*
-- 
2.1.3

