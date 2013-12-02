Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3LBTqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:46:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab3LBTSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.12 152/212] arm64: Move PTE_PROT_NONE higher up
Date: Mon,  2 Dec 2013 11:15:43 -0800
Message-Id: <20131202191304.406301199@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/pgtable.h |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

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
 


