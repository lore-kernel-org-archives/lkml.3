Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaLXMcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:32:50 -0500
Received: from mga14.intel.com ([192.55.52.115]:61029 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbaLXMXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,638,1413270000"; 
   d="scan'208";a="628669822"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 11/38] arm64: drop PTE_FILE and pte_file()-related helpers
Date: Wed, 24 Dec 2014 14:22:19 +0200
Message-Id: <1419423766-114457-12-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

This patch also adjust __SWP_TYPE_SHIFT and increase number of bits
availble for swap offset.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 22e6157fe8d0..854d051f5fd4 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -25,7 +25,6 @@
  * Software defined PTE bits definition.
  */
 #define PTE_VALID		(_AT(pteval_t, 1) << 0)
-#define PTE_FILE		(_AT(pteval_t, 1) << 2)	/* only when !pte_present() */
 #define PTE_DIRTY		(_AT(pteval_t, 1) << 55)
 #define PTE_SPECIAL		(_AT(pteval_t, 1) << 56)
 #define PTE_WRITE		(_AT(pteval_t, 1) << 57)
@@ -470,13 +469,12 @@ extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
 /*
  * Encode and decode a swap entry:
  *	bits 0-1:	present (must be zero)
- *	bit  2:		PTE_FILE
- *	bits 3-8:	swap type
- *	bits 9-57:	swap offset
+ *	bits 2-7:	swap type
+ *	bits 8-57:	swap offset
  */
-#define __SWP_TYPE_SHIFT	3
+#define __SWP_TYPE_SHIFT	2
 #define __SWP_TYPE_BITS		6
-#define __SWP_OFFSET_BITS	49
+#define __SWP_OFFSET_BITS	50
 #define __SWP_TYPE_MASK		((1 << __SWP_TYPE_BITS) - 1)
 #define __SWP_OFFSET_SHIFT	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT)
 #define __SWP_OFFSET_MASK	((1UL << __SWP_OFFSET_BITS) - 1)
@@ -494,18 +492,6 @@ extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
  */
 #define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > __SWP_TYPE_BITS)
 
-/*
- * Encode and decode a file entry:
- *	bits 0-1:	present (must be zero)
- *	bit  2:		PTE_FILE
- *	bits 3-57:	file offset / PAGE_SIZE
- */
-#define pte_file(pte)		(pte_val(pte) & PTE_FILE)
-#define pte_to_pgoff(x)		(pte_val(x) >> 3)
-#define pgoff_to_pte(x)		__pte(((x) << 3) | PTE_FILE)
-
-#define PTE_FILE_MAX_BITS	55
-
 extern int kern_addr_valid(unsigned long addr);
 
 #include <asm-generic/pgtable.h>
-- 
2.1.3

