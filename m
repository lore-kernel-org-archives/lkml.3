Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaDKILJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:11:09 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:58206 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaDKIKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:10:12 -0400
From: Liu Hua <sdu.liu@huawei.com>
To: <nicolas.pitre@linaro.org>
CC: <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wangnan0@huawei.com>, <peifeiyue@huawei.com>, <liusdu@126.com>,
        <m.szyprowski@samsung.com>, Liu Hua <sdu.liu@huawei.com>
Subject: [PATCH v2 2/2] ARM : change fixmap mapping region to support 32 CPUs
Date: Fri, 11 Apr 2014 16:00:52 +0800
Message-ID: <1397203252-22977-3-git-send-email-sdu.liu@huawei.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397203252-22977-1-git-send-email-sdu.liu@huawei.com>
References: <1397203252-22977-1-git-send-email-sdu.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 32-bit ARM systems, the fixmap mapping region can support
no more than 14 CPUs(total: 896k; one CPU: 64K). And we can
configure NR_CPUS up to 32. So there is a mismatch.

This patch moves fixmapping region downwards to region
0xffc00000-0xffe00000 . Then the fixmap mapping region can
support up to 32 CPUs.

Signed-off-by: Liu Hua <sdu.liu@huawei.com>
---
 Documentation/arm/memory.txt   |  2 +-
 arch/arm/include/asm/fixmap.h  |  4 ++--
 arch/arm/include/asm/highmem.h |  1 +
 arch/arm/mm/highmem.c          | 10 +++++-----
 arch/arm/mm/mm.h               |  7 +++++++
 arch/arm/mm/mmu.c              |  4 ++++
 mm/highmem.c                   |  1 +
 7 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/Documentation/arm/memory.txt b/Documentation/arm/memory.txt
index 8a361c0..4bca737 100644
--- a/Documentation/arm/memory.txt
+++ b/Documentation/arm/memory.txt
@@ -41,7 +41,7 @@ fffe8000	fffeffff	DTCM mapping area for platforms with
 fffe0000	fffe7fff	ITCM mapping area for platforms with
 				ITCM mounted inside the CPU.
 
-fff00000	fffdffff	Fixmap mapping region.  Addresses provided
+ffc00000	ffdfffff	Fixmap mapping region.  Addresses provided
 				by fix_to_virt() will be located here.
 
 ff000000	ffbfffff	Reserved for future expansion of DMA
diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index bbae919..014a70d 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -13,8 +13,8 @@
  * 0xfffe0000 and 0xfffeffff.
  */
 
-#define FIXADDR_START		0xfff00000UL
-#define FIXADDR_TOP		0xfffe0000UL
+#define FIXADDR_START		0xffc00000UL
+#define FIXADDR_TOP		0xffe00000UL
 #define FIXADDR_SIZE		(FIXADDR_TOP - FIXADDR_START)
 
 #define FIX_KMAP_BEGIN		0
diff --git a/arch/arm/include/asm/highmem.h b/arch/arm/include/asm/highmem.h
index 91b99ab..5355795 100644
--- a/arch/arm/include/asm/highmem.h
+++ b/arch/arm/include/asm/highmem.h
@@ -18,6 +18,7 @@
 	} while (0)
 
 extern pte_t *pkmap_page_table;
+extern pte_t *fixmap_page_table;
 
 extern void *kmap_high(struct page *page);
 extern void kunmap_high(struct page *page);
diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
index 21b9e1b..9bc8988 100644
--- a/arch/arm/mm/highmem.c
+++ b/arch/arm/mm/highmem.c
@@ -69,14 +69,14 @@ void *kmap_atomic(struct page *page)
 	 * With debugging enabled, kunmap_atomic forces that entry to 0.
 	 * Make sure it was indeed properly unmapped.
 	 */
-	BUG_ON(!pte_none(get_top_pte(vaddr)));
+	BUG_ON(!pte_none(*(fixmap_page_table + idx)));
 #endif
 	/*
 	 * When debugging is off, kunmap_atomic leaves the previous mapping
 	 * in place, so the contained TLB flush ensures the TLB is updated
 	 * with the new mapping.
 	 */
-	set_top_pte(vaddr, mk_pte(page, kmap_prot));
+	set_fixmap_pte(idx, mk_pte(page, kmap_prot));
 
 	return (void *)vaddr;
 }
@@ -95,7 +95,7 @@ void __kunmap_atomic(void *kvaddr)
 			__cpuc_flush_dcache_area((void *)vaddr, PAGE_SIZE);
 #ifdef CONFIG_DEBUG_HIGHMEM
 		BUG_ON(vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
-		set_top_pte(vaddr, __pte(0));
+		set_fixmap_pte(idx, __pte(0));
 #else
 		(void) idx;  /* to kill a warning */
 #endif
@@ -119,9 +119,9 @@ void *kmap_atomic_pfn(unsigned long pfn)
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
-	BUG_ON(!pte_none(get_top_pte(vaddr)));
+	BUG_ON(!pte_none(*(fixmap_page_table + idx)));
 #endif
-	set_top_pte(vaddr, pfn_pte(pfn, kmap_prot));
+	set_fixmap_pte(idx, pfn_pte(pfn, kmap_prot));
 
 	return (void *)vaddr;
 }
diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
index 7ea641b..3460d73 100644
--- a/arch/arm/mm/mm.h
+++ b/arch/arm/mm/mm.h
@@ -1,6 +1,7 @@
 #ifdef CONFIG_MMU
 #include <linux/list.h>
 #include <linux/vmalloc.h>
+#include <asm/fixmap.h>
 
 /* the upper-most page table pointer */
 extern pmd_t *top_pmd;
@@ -25,6 +26,12 @@ static inline void set_top_pte(unsigned long va, pte_t pte)
 	local_flush_tlb_kernel_page(va);
 }
 
+static inline void set_fixmap_pte(int idx, pte_t pte)
+{
+	unsigned long vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+	set_pte_ext(fixmap_page_table + idx, pte, 0);
+	local_flush_tlb_kernel_page(vaddr);
+}
 static inline pte_t get_top_pte(unsigned long va)
 {
 	pte_t *ptep = pte_offset_kernel(top_pmd, va);
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index b68c6b2..09c0a16 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -35,6 +35,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/pci.h>
+#include <asm/fixmap.h>
 
 #include "mm.h"
 #include "tcm.h"
@@ -1359,6 +1360,9 @@ static void __init kmap_init(void)
 #ifdef CONFIG_HIGHMEM
 	pkmap_page_table = early_pte_alloc(pmd_off_k(PKMAP_BASE),
 		PKMAP_BASE, _PAGE_KERNEL_TABLE);
+
+	fixmap_page_table = early_pte_alloc(pmd_off_k(FIXADDR_START),
+		FIXADDR_START, _PAGE_KERNEL_TABLE);
 #endif
 }
 
diff --git a/mm/highmem.c b/mm/highmem.c
index b32b70c..d0094ba 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -72,6 +72,7 @@ static unsigned int last_pkmap_nr;
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kmap_lock);
 
 pte_t * pkmap_page_table;
+pte_t *fixmap_page_table;
 
 static DECLARE_WAIT_QUEUE_HEAD(pkmap_map_wait);
 
-- 
1.9.0

