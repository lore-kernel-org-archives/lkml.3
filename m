Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaHLS1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:27:47 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36163 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbaHLS1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:27:24 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Mark Salter <msalter@redhat.com>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh@kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>, Rabin Vincent <rabin@rab.in>,
        Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 1/7] arm: use generic fixmap.h
Date: Tue, 12 Aug 2014 11:24:23 -0700
Message-Id: <1407867869-5194-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407867869-5194-1-git-send-email-keescook@chromium.org>
References: <1407867869-5194-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

ARM is different from other architectures in that fixmap pages are indexed
with a positive offset from FIXADDR_START.  Other architectures index with
a negative offset from FIXADDR_TOP.  In order to use the generic fixmap.h
definitions, this patch redefines FIXADDR_TOP to be inclusive of the
useable range.  That is, FIXADDR_TOP is the virtual address of the topmost
fixed page.  The newly defined FIXADDR_END is the first virtual address
past the fixed mappings.

Signed-off-by: Mark Salter <msalter@redhat.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
[kees: update for a05e54c103b0b8 "ARM: 8031/2: change fixmap ..."]
[kees: fixed highmem usage, thanks to Laura Abbott and Rob Herring]
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Rob Herring <robh@kernel.org>
---
 arch/arm/include/asm/fixmap.h  | 27 +++++++++------------------
 arch/arm/include/asm/highmem.h |  1 -
 arch/arm/mm/highmem.c          | 15 ++++++++-------
 arch/arm/mm/init.c             |  2 +-
 arch/arm/mm/mmu.c              |  6 +++---
 5 files changed, 21 insertions(+), 30 deletions(-)

diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index 74124b0d0d79..a7add6f9315d 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -2,27 +2,18 @@
 #define _ASM_FIXMAP_H
 
 #define FIXADDR_START		0xffc00000UL
-#define FIXADDR_TOP		0xffe00000UL
-#define FIXADDR_SIZE		(FIXADDR_TOP - FIXADDR_START)
+#define FIXADDR_END		0xffe00000UL
+#define FIXADDR_TOP		(FIXADDR_END - PAGE_SIZE)
 
-#define FIX_KMAP_NR_PTES	(FIXADDR_SIZE >> PAGE_SHIFT)
+#include <asm/kmap_types.h>
 
-#define __fix_to_virt(x)	(FIXADDR_START + ((x) << PAGE_SHIFT))
-#define __virt_to_fix(x)	(((x) - FIXADDR_START) >> PAGE_SHIFT)
+enum fixed_addresses {
+	FIX_KMAP_BEGIN,
+	FIX_KMAP_END = FIX_KMAP_BEGIN + (KM_TYPE_NR * NR_CPUS) - 1,
 
-extern void __this_fixmap_does_not_exist(void);
+	__end_of_fixed_addresses
+};
 
-static inline unsigned long fix_to_virt(const unsigned int idx)
-{
-	if (idx >= FIX_KMAP_NR_PTES)
-		__this_fixmap_does_not_exist();
-	return __fix_to_virt(idx);
-}
-
-static inline unsigned int virt_to_fix(const unsigned long vaddr)
-{
-	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
-	return __virt_to_fix(vaddr);
-}
+#include <asm-generic/fixmap.h>
 
 #endif
diff --git a/arch/arm/include/asm/highmem.h b/arch/arm/include/asm/highmem.h
index 535579511ed0..91b99abe7a95 100644
--- a/arch/arm/include/asm/highmem.h
+++ b/arch/arm/include/asm/highmem.h
@@ -18,7 +18,6 @@
 	} while (0)
 
 extern pte_t *pkmap_page_table;
-extern pte_t *fixmap_page_table;
 
 extern void *kmap_high(struct page *page);
 extern void kunmap_high(struct page *page);
diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
index 45aeaaca9052..f87e0b89b738 100644
--- a/arch/arm/mm/highmem.c
+++ b/arch/arm/mm/highmem.c
@@ -18,19 +18,20 @@
 #include <asm/tlbflush.h>
 #include "mm.h"
 
-pte_t *fixmap_page_table;
-
 static inline void set_fixmap_pte(int idx, pte_t pte)
 {
 	unsigned long vaddr = __fix_to_virt(idx);
-	set_pte_ext(fixmap_page_table + idx, pte, 0);
+	pte_t *ppte = pte_offset_kernel(pmd_off_k(FIXADDR_START), vaddr);
+
+	set_pte_ext(ppte, pte, 0);
 	local_flush_tlb_kernel_page(vaddr);
 }
 
 static inline pte_t get_fixmap_pte(unsigned long vaddr)
 {
-	unsigned long idx = __virt_to_fix(vaddr);
-	return *(fixmap_page_table + idx);
+	pte_t *ppte = pte_offset_kernel(pmd_off_k(FIXADDR_START), vaddr);
+
+	return *ppte;
 }
 
 void *kmap(struct page *page)
@@ -84,7 +85,7 @@ void *kmap_atomic(struct page *page)
 	 * With debugging enabled, kunmap_atomic forces that entry to 0.
 	 * Make sure it was indeed properly unmapped.
 	 */
-	BUG_ON(!pte_none(*(fixmap_page_table + idx)));
+	BUG_ON(!pte_none(*get_fixmap_pte(vaddr)));
 #endif
 	/*
 	 * When debugging is off, kunmap_atomic leaves the previous mapping
@@ -134,7 +135,7 @@ void *kmap_atomic_pfn(unsigned long pfn)
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
-	BUG_ON(!pte_none(*(fixmap_page_table + idx)));
+	BUG_ON(!pte_none(*get_fixmap_pte(vaddr)));
 #endif
 	set_fixmap_pte(idx, pfn_pte(pfn, kmap_prot));
 
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 659c75d808dc..ad82c05bfc3a 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -570,7 +570,7 @@ void __init mem_init(void)
 			MLK(DTCM_OFFSET, (unsigned long) dtcm_end),
 			MLK(ITCM_OFFSET, (unsigned long) itcm_end),
 #endif
-			MLK(FIXADDR_START, FIXADDR_TOP),
+			MLK(FIXADDR_START, FIXADDR_END),
 			MLM(VMALLOC_START, VMALLOC_END),
 			MLM(PAGE_OFFSET, (unsigned long)high_memory),
 #ifdef CONFIG_HIGHMEM
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 8348ed6b2efe..7fa0966cd15f 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1326,10 +1326,10 @@ static void __init kmap_init(void)
 #ifdef CONFIG_HIGHMEM
 	pkmap_page_table = early_pte_alloc(pmd_off_k(PKMAP_BASE),
 		PKMAP_BASE, _PAGE_KERNEL_TABLE);
-
-	fixmap_page_table = early_pte_alloc(pmd_off_k(FIXADDR_START),
-		FIXADDR_START, _PAGE_KERNEL_TABLE);
 #endif
+
+	early_pte_alloc(pmd_off_k(FIXADDR_START), FIXADDR_START,
+			_PAGE_KERNEL_TABLE);
 }
 
 static void __init map_lowmem(void)
-- 
1.9.1

