Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbaHFTfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:35:45 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38513 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756414AbaHFTfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:35:43 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Liu hua <sdu.liu@huawei.com>,
        Mark Salter <msalter@redhat.com>, Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Rob Herring <robh@kernel.org>,
        Doug Anderson <dianders@google.com>, Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/7] arm: mm: reduce fixmap kmap from 32 to 16 CPUS
Date: Wed,  6 Aug 2014 12:32:40 -0700
Message-Id: <1407353564-21478-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407353564-21478-1-git-send-email-keescook@chromium.org>
References: <1407353564-21478-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More room is needed in the fixmap range for non-kmap fixmap entries. This
reduces the kmap range from 32 to 16 CPUs. Additionally, add PTE entry for
fixmap regardless of CONFIG_HIGHMEM.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/include/asm/fixmap.h | 12 ++++++++++--
 arch/arm/mm/highmem.c         |  2 --
 arch/arm/mm/mm.h              |  3 +++
 arch/arm/mm/mmu.c             |  5 ++++-
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index 8ee7cb4f62ca..3ed08232be55 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -1,16 +1,24 @@
 #ifndef _ASM_FIXMAP_H
 #define _ASM_FIXMAP_H
 
+/*
+ * The fixmap uses 2MB. The KMAP fixmap needs 64k per CPU, so make room for
+ * 16 CPUs (taking 1MB) and leave the rest for additional fixmap areas.
+ */
 #define FIXADDR_START		0xffc00000UL
 #define FIXADDR_END		0xffe00000UL
 #define FIXADDR_TOP		(FIXADDR_END - PAGE_SIZE)
 #define FIXADDR_SIZE		(FIXADDR_END - FIXADDR_START)
 
-#define FIX_KMAP_NR_PTES	(FIXADDR_SIZE >> PAGE_SHIFT)
+/* 16 PTEs per CPU (64k of 4k pages). */
+#define FIX_KMAP_NR_PTES	16
+#define FIX_KMAP_NR_CPUS	16
 
 enum fixed_addresses {
+	/* Support 16 CPUs for kmap as the first region of fixmap entries. */
 	FIX_KMAP_BEGIN,
-	FIX_KMAP_END = FIX_KMAP_NR_PTES - 1,
+	FIX_KMAP_END = (FIX_KMAP_NR_PTES * FIX_KMAP_NR_CPUS) - 1,
+
 	__end_of_fixed_addresses
 };
 
diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
index 45aeaaca9052..cbbef0b533d6 100644
--- a/arch/arm/mm/highmem.c
+++ b/arch/arm/mm/highmem.c
@@ -18,8 +18,6 @@
 #include <asm/tlbflush.h>
 #include "mm.h"
 
-pte_t *fixmap_page_table;
-
 static inline void set_fixmap_pte(int idx, pte_t pte)
 {
 	unsigned long vaddr = __fix_to_virt(idx);
diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
index ce727d47275c..c8b5b2d05b55 100644
--- a/arch/arm/mm/mm.h
+++ b/arch/arm/mm/mm.h
@@ -7,6 +7,9 @@
 /* the upper-most page table pointer */
 extern pmd_t *top_pmd;
 
+/* The fixmap PTE. */
+extern pte_t *fixmap_page_table;
+
 /*
  * 0xffff8000 to 0xffffffff is reserved for any ARM architecture
  * specific hacks for copying pages efficiently, while 0xffff4000
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index b005a3337bc1..8dbdadc42d75 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -53,6 +53,9 @@ EXPORT_SYMBOL(empty_zero_page);
  */
 pmd_t *top_pmd;
 
+/* The fixmap PTE. */
+pte_t *fixmap_page_table;
+
 #define CPOLICY_UNCACHED	0
 #define CPOLICY_BUFFERED	1
 #define CPOLICY_WRITETHROUGH	2
@@ -1342,10 +1345,10 @@ static void __init kmap_init(void)
 #ifdef CONFIG_HIGHMEM
 	pkmap_page_table = early_pte_alloc(pmd_off_k(PKMAP_BASE),
 		PKMAP_BASE, _PAGE_KERNEL_TABLE);
+#endif
 
 	fixmap_page_table = early_pte_alloc(pmd_off_k(FIXADDR_START),
 		FIXADDR_START, _PAGE_KERNEL_TABLE);
-#endif
 }
 
 static void __init map_lowmem(void)
-- 
1.9.1

