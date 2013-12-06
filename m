Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab3LFOGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:06:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43843 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161244Ab3LFNBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:01:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 067/272] arm64: Move PTE_PROT_NONE higher up
Date: Fri,  6 Dec 2013 12:55:56 +0000
Message-Id: <1386334761-25517-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 3676f9ef5481d614f8c5c857f5319755be248268 upstream.

PTE_PROT_NONE means that a pte is present but does not have any
read/write attributes. However, setting the memory type like
pgprot_writecombine() is allowed and such bits overlap with
PTE_PROT_NONE. This causes mmap/munmap issues in drivers that change the
vma->vm_pg_prot on PROT_NONE mappings.

This patch reverts the PTE_FILE/PTE_PROT_NONE shift in commit
59911ca4325d (ARM64: mm: Move PTE_PROT_NONE bit) and moves PTE_PROT_NONE
together with the other software bits.

Signed-off-by: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/include/asm/pgtable.h | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index f0bebc5..0b27b65 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -25,10 +25,11 @@
  * Software defined PTE bits definition.
  */
 #define PTE_VALID		(_AT(pteval_t, 1) << 0)
-#define PTE_PROT_NONE		(_AT(pteval_t, 1) << 2)	/* only when !PTE_VALID */
-#define PTE_FILE		(_AT(pteval_t, 1) << 3)	/* only when !pte_present() */
+#define PTE_FILE		(_AT(pteval_t, 1) << 2)	/* only when !pte_present() */
 #define PTE_DIRTY		(_AT(pteval_t, 1) << 55)
 #define PTE_SPECIAL		(_AT(pteval_t, 1) << 56)
+				/* bit 57 for PMD_SECT_SPLITTING */
+#define PTE_PROT_NONE		(_AT(pteval_t, 1) << 58) /* only when !PTE_VALID */
 
 /*
  * VMALLOC and SPARSEMEM_VMEMMAP ranges.
@@ -357,18 +358,20 @@ extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
 
 /*
  * Encode and decode a swap entry:
- *	bits 0, 2:	present (must both be zero)
- *	bit  3:		PTE_FILE
- *	bits 4-8:	swap type
- *	bits 9-63:	swap offset
+ *	bits 0-1:	present (must be zero)
+ *	bit  2:		PTE_FILE
+ *	bits 3-8:	swap type
+ *	bits 9-57:	swap offset
  */
-#define __SWP_TYPE_SHIFT	4
+#define __SWP_TYPE_SHIFT	3
 #define __SWP_TYPE_BITS		6
+#define __SWP_OFFSET_BITS	49
 #define __SWP_TYPE_MASK		((1 << __SWP_TYPE_BITS) - 1)
 #define __SWP_OFFSET_SHIFT	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT)
+#define __SWP_OFFSET_MASK	((1UL << __SWP_OFFSET_BITS) - 1)
 
 #define __swp_type(x)		(((x).val >> __SWP_TYPE_SHIFT) & __SWP_TYPE_MASK)
-#define __swp_offset(x)		((x).val >> __SWP_OFFSET_SHIFT)
+#define __swp_offset(x)		(((x).val >> __SWP_OFFSET_SHIFT) & __SWP_OFFSET_MASK)
 #define __swp_entry(type,offset) ((swp_entry_t) { ((type) << __SWP_TYPE_SHIFT) | ((offset) << __SWP_OFFSET_SHIFT) })
 
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
@@ -382,15 +385,15 @@ extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
 
 /*
  * Encode and decode a file entry:
- *	bits 0, 2:	present (must both be zero)
- *	bit  3:		PTE_FILE
- *	bits 4-63:	file offset / PAGE_SIZE
+ *	bits 0-1:	present (must be zero)
+ *	bit  2:		PTE_FILE
+ *	bits 3-57:	file offset / PAGE_SIZE
  */
 #define pte_file(pte)		(pte_val(pte) & PTE_FILE)
-#define pte_to_pgoff(x)		(pte_val(x) >> 4)
-#define pgoff_to_pte(x)		__pte(((x) << 4) | PTE_FILE)
+#define pte_to_pgoff(x)		(pte_val(x) >> 3)
+#define pgoff_to_pte(x)		__pte(((x) << 3) | PTE_FILE)
 
-#define PTE_FILE_MAX_BITS	60
+#define PTE_FILE_MAX_BITS	55
 
 extern int kern_addr_valid(unsigned long addr);
 
-- 
1.8.3.2

