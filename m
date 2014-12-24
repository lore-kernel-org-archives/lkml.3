Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaLXM27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:28:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:50935 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbaLXMXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,638,1413270000"; 
   d="scan'208";a="642376391"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 27/38] openrisc: drop _PAGE_FILE and pte_file()-related helpers
Date: Wed, 24 Dec 2014 14:22:35 +0200
Message-Id: <1419423766-114457-28-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/include/asm/pgtable.h | 8 --------
 arch/openrisc/kernel/head.S         | 5 -----
 2 files changed, 13 deletions(-)

diff --git a/arch/openrisc/include/asm/pgtable.h b/arch/openrisc/include/asm/pgtable.h
index 37bf6a3ef8f4..18994ccb1185 100644
--- a/arch/openrisc/include/asm/pgtable.h
+++ b/arch/openrisc/include/asm/pgtable.h
@@ -125,7 +125,6 @@ extern void paging_init(void);
 #define _PAGE_CC       0x001 /* software: pte contains a translation */
 #define _PAGE_CI       0x002 /* cache inhibit          */
 #define _PAGE_WBC      0x004 /* write back cache       */
-#define _PAGE_FILE     0x004 /* set: pagecache, unset: swap (when !PRESENT) */
 #define _PAGE_WOM      0x008 /* weakly ordered memory  */
 
 #define _PAGE_A        0x010 /* accessed               */
@@ -240,7 +239,6 @@ static inline int pte_write(pte_t pte) { return pte_val(pte) & _PAGE_WRITE; }
 static inline int pte_exec(pte_t pte)  { return pte_val(pte) & _PAGE_EXEC; }
 static inline int pte_dirty(pte_t pte) { return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte) { return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_file(pte_t pte)  { return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_special(pte_t pte) { return 0; }
 static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
 
@@ -438,12 +436,6 @@ static inline void update_mmu_cache(struct vm_area_struct *vma,
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-/* Encode and decode a nonlinear file mapping entry */
-
-#define PTE_FILE_MAX_BITS               26
-#define pte_to_pgoff(x)	                (pte_val(x) >> 6)
-#define pgoff_to_pte(x)	                __pte(((x) << 6) | _PAGE_FILE)
-
 #define kern_addr_valid(addr)           (1)
 
 #include <asm-generic/pgtable.h>
diff --git a/arch/openrisc/kernel/head.S b/arch/openrisc/kernel/head.S
index 1d3c9c28ac25..f14793306b03 100644
--- a/arch/openrisc/kernel/head.S
+++ b/arch/openrisc/kernel/head.S
@@ -754,11 +754,6 @@ _dc_enable:
 
 /* ===============================================[ page table masks ]=== */
 
-/* bit 4 is used in hardware as write back cache bit. we never use this bit
- * explicitly, so we can reuse it as _PAGE_FILE bit and mask it out when
- * writing into hardware pte's
- */
-
 #define DTLB_UP_CONVERT_MASK  0x3fa
 #define ITLB_UP_CONVERT_MASK  0x3a
 
-- 
2.1.3

