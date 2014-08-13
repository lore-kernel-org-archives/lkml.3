Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaHMRHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:07:38 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43669 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbaHMRHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:07:34 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Rob Herring <robh@kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Rabin Vincent <rabin@rab.in>, Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: [PATCH v4 2/8] ARM: expand fixmap region to 3MB
Date: Wed, 13 Aug 2014 10:06:27 -0700
Message-Id: <1407949593-16121-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407949593-16121-1-git-send-email-keescook@chromium.org>
References: <1407949593-16121-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

With commit a05e54c103b0 ("ARM: 8031/2: change fixmap mapping region to
support 32 CPUs"), the fixmap region was expanded to 2MB, but it
precluded any other uses of the fixmap region. In order to support other
uses the fixmap region needs to be expanded beyond 2MB. Fortunately, the
adjacent 1MB range 0xffe00000-0xfff00000 is availabe.

Remove fixmap_page_table ptr and lookup the page table via the virtual
address so that the fixmap region can span more that one pmd. The 2nd
pmd is already created since it is shared with the vector page.

Signed-off-by: Rob Herring <robh@kernel.org>
[kees: fixed CONFIG_DEBUG_HIGHMEM get_fixmap() calls]
[kees: moved pte allocation outside of CONFIG_HIGHMEM]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/arm/memory.txt  |  2 +-
 arch/arm/include/asm/fixmap.h |  2 +-
 arch/arm/mm/highmem.c         | 15 ++++++++-------
 arch/arm/mm/mmu.c             |  6 +++---
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/Documentation/arm/memory.txt b/Documentation/arm/memory.txt
index 38dc06d0a791..4178ebda6e66 100644
--- a/Documentation/arm/memory.txt
+++ b/Documentation/arm/memory.txt
@@ -41,7 +41,7 @@ fffe8000	fffeffff	DTCM mapping area for platforms with
 fffe0000	fffe7fff	ITCM mapping area for platforms with
 				ITCM mounted inside the CPU.
 
-ffc00000	ffdfffff	Fixmap mapping region.  Addresses provided
+ffc00000	ffefffff	Fixmap mapping region.  Addresses provided
 				by fix_to_virt() will be located here.
 
 fee00000	feffffff	Mapping of PCI I/O space. This is a static
diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index a7add6f9315d..d984ca69ce19 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -2,7 +2,7 @@
 #define _ASM_FIXMAP_H
 
 #define FIXADDR_START		0xffc00000UL
-#define FIXADDR_END		0xffe00000UL
+#define FIXADDR_END		0xfff00000UL
 #define FIXADDR_TOP		(FIXADDR_END - PAGE_SIZE)
 
 #include <asm/kmap_types.h>
diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
index 45aeaaca9052..81061987ac45 100644
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
+	pte_t *ptep = pte_offset_kernel(pmd_off_k(vaddr), vaddr);
+
+	set_pte_ext(ptep, pte, 0);
 	local_flush_tlb_kernel_page(vaddr);
 }
 
 static inline pte_t get_fixmap_pte(unsigned long vaddr)
 {
-	unsigned long idx = __virt_to_fix(vaddr);
-	return *(fixmap_page_table + idx);
+	pte_t *ptep = pte_offset_kernel(pmd_off_k(vaddr), vaddr);
+
+	return *ptep;
 }
 
 void *kmap(struct page *page)
@@ -84,7 +85,7 @@ void *kmap_atomic(struct page *page)
 	 * With debugging enabled, kunmap_atomic forces that entry to 0.
 	 * Make sure it was indeed properly unmapped.
 	 */
-	BUG_ON(!pte_none(*(fixmap_page_table + idx)));
+	BUG_ON(!pte_none(get_fixmap_pte(vaddr)));
 #endif
 	/*
 	 * When debugging is off, kunmap_atomic leaves the previous mapping
@@ -134,7 +135,7 @@ void *kmap_atomic_pfn(unsigned long pfn)
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(idx);
 #ifdef CONFIG_DEBUG_HIGHMEM
-	BUG_ON(!pte_none(*(fixmap_page_table + idx)));
+	BUG_ON(!pte_none(get_fixmap_pte(vaddr)));
 #endif
 	set_fixmap_pte(idx, pfn_pte(pfn, kmap_prot));
 
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

