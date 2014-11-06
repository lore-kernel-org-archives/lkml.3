Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaKFWld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:41:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58734 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaKFWlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:24 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 051/162] sparc64: Adjust vmalloc region size based upon available virtual address bits.
Date: Thu,  6 Nov 2014 14:35:15 -0800
Message-Id: <1415313426-9622-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit bb4e6e85daa52a9f6210fa06a5ec6269598a202b ]

In order to accomodate embedded per-cpu allocation with large numbers
of cpus and numa nodes, we have to use as much virtual address space
as possible for the vmalloc region.  Otherwise we can get things like:

PERCPU: max_distance=0x380001c10000 too large for vmalloc space 0xff00000000

So, once we select a value for PAGE_OFFSET, derive the size of the
vmalloc region based upon that.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Bob Picco <bob.picco@oracle.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/include/asm/page_64.h    |  1 -
 arch/sparc/include/asm/pgtable_64.h |  9 +++++----
 arch/sparc/kernel/ktlb.S            |  8 ++++----
 arch/sparc/mm/init_64.c             | 30 +++++++++++++++++++-----------
 4 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/arch/sparc/include/asm/page_64.h b/arch/sparc/include/asm/page_64.h
index 275fc6c..b18e602 100644
--- a/arch/sparc/include/asm/page_64.h
+++ b/arch/sparc/include/asm/page_64.h
@@ -117,7 +117,6 @@ extern unsigned long sparc64_va_hole_bottom;
 
 #include <asm-generic/memory_model.h>
 
-#define PAGE_OFFSET_BY_BITS(X)	(-(_AC(1,UL) << (X)))
 extern unsigned long PAGE_OFFSET;
 
 #endif /* !(__ASSEMBLY__) */
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 58547f7..ad1def4 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -40,10 +40,7 @@
 #define LOW_OBP_ADDRESS		_AC(0x00000000f0000000,UL)
 #define HI_OBP_ADDRESS		_AC(0x0000000100000000,UL)
 #define VMALLOC_START		_AC(0x0000000100000000,UL)
-#define VMALLOC_END		_AC(0x0000010000000000,UL)
-#define VMEMMAP_BASE		_AC(0x0000010000000000,UL)
-
-#define vmemmap			((struct page *)VMEMMAP_BASE)
+#define VMEMMAP_BASE		VMALLOC_END
 
 /* PMD_SHIFT determines the size of the area a second-level page
  * table can map
@@ -81,6 +78,10 @@
 
 #ifndef __ASSEMBLY__
 
+extern unsigned long VMALLOC_END;
+
+#define vmemmap			((struct page *)VMEMMAP_BASE)
+
 #include <linux/sched.h>
 
 bool kern_addr_valid(unsigned long addr);
diff --git a/arch/sparc/kernel/ktlb.S b/arch/sparc/kernel/ktlb.S
index 2627a7f..ef0d8e9 100644
--- a/arch/sparc/kernel/ktlb.S
+++ b/arch/sparc/kernel/ktlb.S
@@ -199,8 +199,8 @@ kvmap_dtlb_nonlinear:
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 	/* Do not use the TSB for vmemmap.  */
-	mov		(VMEMMAP_BASE >> 40), %g5
-	sllx		%g5, 40, %g5
+	sethi		%hi(VMEMMAP_BASE), %g5
+	ldx		[%g5 + %lo(VMEMMAP_BASE)], %g5
 	cmp		%g4,%g5
 	bgeu,pn		%xcc, kvmap_vmemmap
 	 nop
@@ -212,8 +212,8 @@ kvmap_dtlb_tsbmiss:
 	sethi		%hi(MODULES_VADDR), %g5
 	cmp		%g4, %g5
 	blu,pn		%xcc, kvmap_dtlb_longpath
-	 mov		(VMALLOC_END >> 40), %g5
-	sllx		%g5, 40, %g5
+	 sethi		%hi(VMALLOC_END), %g5
+	ldx		[%g5 + %lo(VMALLOC_END)], %g5
 	cmp		%g4, %g5
 	bgeu,pn		%xcc, kvmap_dtlb_longpath
 	 nop
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 9565f4d..ca634b3 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1362,25 +1362,24 @@ static unsigned long max_phys_bits = 40;
 
 bool kern_addr_valid(unsigned long addr)
 {
-	unsigned long above = ((long)addr) >> max_phys_bits;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 
-	if (above != 0 && above != -1UL)
-		return false;
-
-	if (addr >= (unsigned long) KERNBASE &&
-	    addr < (unsigned long)&_end)
-		return true;
-
-	if (addr >= PAGE_OFFSET) {
+	if ((long)addr < 0L) {
 		unsigned long pa = __pa(addr);
 
+		if ((addr >> max_phys_bits) != 0UL)
+			return false;
+
 		return pfn_valid(pa >> PAGE_SHIFT);
 	}
 
+	if (addr >= (unsigned long) KERNBASE &&
+	    addr < (unsigned long)&_end)
+		return true;
+
 	pgd = pgd_offset_k(addr);
 	if (pgd_none(*pgd))
 		return 0;
@@ -1649,6 +1648,9 @@ unsigned long __init find_ecache_flush_span(unsigned long size)
 unsigned long PAGE_OFFSET;
 EXPORT_SYMBOL(PAGE_OFFSET);
 
+unsigned long VMALLOC_END   = 0x0000010000000000UL;
+EXPORT_SYMBOL(VMALLOC_END);
+
 unsigned long sparc64_va_hole_top =    0xfffff80000000000UL;
 unsigned long sparc64_va_hole_bottom = 0x0000080000000000UL;
 
@@ -1705,10 +1707,16 @@ static void __init setup_page_offset(void)
 		prom_halt();
 	}
 
-	PAGE_OFFSET = PAGE_OFFSET_BY_BITS(max_phys_bits);
+	PAGE_OFFSET = sparc64_va_hole_top;
+	VMALLOC_END = ((sparc64_va_hole_bottom >> 1) +
+		       (sparc64_va_hole_bottom >> 2));
 
-	pr_info("PAGE_OFFSET is 0x%016lx (max_phys_bits == %lu)\n",
+	pr_info("MM: PAGE_OFFSET is 0x%016lx (max_phys_bits == %lu)\n",
 		PAGE_OFFSET, max_phys_bits);
+	pr_info("MM: VMALLOC [0x%016lx --> 0x%016lx]\n",
+		VMALLOC_START, VMALLOC_END);
+	pr_info("MM: VMEMMAP [0x%016lx --> 0x%016lx]\n",
+		VMEMMAP_BASE, VMEMMAP_BASE << 1);
 }
 
 static void __init tsb_phys_patch(void)
-- 
1.9.1

