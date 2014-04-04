Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaDDCRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 22:17:20 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38953 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaDDCRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 22:17:16 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, Laura Abbott <lauraa@codeaurora.org>,
        Alexander Holler <holler@ahsoftware.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/2] ARM: mm: mark non-text sections non-executable
Date: Thu,  3 Apr 2014 19:15:18 -0700
Message-Id: <1396577719-14786-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396577719-14786-1-git-send-email-keescook@chromium.org>
References: <1396577719-14786-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds CONFIG_ARM_KERNMEM_PERMS to separate the kernel memory regions
into section-sized areas that can have different permisions. Performs
the NX permission changes during free_initmem, so that init memory can be
reclaimed.

This uses section size instead of PMD size to reduce memory caps on
non-LPAE systems.

Based on work by Brad Spengler, Larry Bassel, and Laura Abbott.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/vmlinux.lds.S |   17 ++++++++
 arch/arm/mm/Kconfig           |    9 ++++
 arch/arm/mm/init.c            |   92 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/mm/mmu.c             |   13 +++++-
 4 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 7bcee5c9b604..08fa667ef2f1 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -8,6 +8,9 @@
 #include <asm/thread_info.h>
 #include <asm/memory.h>
 #include <asm/page.h>
+#ifdef CONFIG_ARM_KERNMEM_PERMS
+#include <asm/pgtable.h>
+#endif
 	
 #define PROC_INFO							\
 	. = ALIGN(4);							\
@@ -90,6 +93,11 @@ SECTIONS
 		_text = .;
 		HEAD_TEXT
 	}
+
+#ifdef CONFIG_ARM_KERNMEM_PERMS
+	. = ALIGN(1<<SECTION_SHIFT);
+#endif
+
 	.text : {			/* Real text segment		*/
 		_stext = .;		/* Text and read-only data	*/
 			__exception_text_start = .;
@@ -145,7 +153,11 @@ SECTIONS
 	_etext = .;			/* End of text and rodata section */
 
 #ifndef CONFIG_XIP_KERNEL
+# ifdef CONFIG_ARM_KERNMEM_PERMS
+	. = ALIGN(1<<SECTION_SHIFT);
+# else
 	. = ALIGN(PAGE_SIZE);
+# endif
 	__init_begin = .;
 #endif
 	/*
@@ -220,7 +232,12 @@ SECTIONS
 	. = PAGE_OFFSET + TEXT_OFFSET;
 #else
 	__init_end = .;
+
+#ifdef CONFIG_ARM_KERNMEM_PERMS
+	. = ALIGN(1<<SECTION_SHIFT);
+#else
 	. = ALIGN(THREAD_SIZE);
+#endif
 	__data_loc = .;
 #endif
 
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 1f8fed94c2a4..8848d7b73e66 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -958,3 +958,12 @@ config ARCH_SUPPORTS_BIG_ENDIAN
 	help
 	  This option specifies the architecture can support big endian
 	  operation.
+
+config ARM_KERNMEM_PERMS
+	bool "Restrict kernel memory permissions"
+	help
+	  If this is set, kernel memory other than kernel text (and rodata)
+	  will be made non-executable. The tradeoff is that each region is
+	  padded to section-size (1MiB) boundaries (because their permissions
+	  are different and splitting the 1M pages into 4K ones causes TLB
+	  performance problems), wasting memory.
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 804d61566a53..8539eb2a01ad 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -31,6 +31,11 @@
 #include <asm/tlb.h>
 #include <asm/fixmap.h>
 
+#ifdef CONFIG_ARM_KERNMEM_PERMS
+#include <asm/system_info.h>
+#include <asm/cp15.h>
+#endif
+
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
@@ -621,11 +626,98 @@ void __init mem_init(void)
 	}
 }
 
+#ifdef CONFIG_ARM_KERNMEM_PERMS
+struct section_perm {
+	unsigned long start;
+	unsigned long end;
+	pmdval_t mask;
+	pmdval_t prot;
+};
+
+struct section_perm section_perms[] = {
+	/* Make pages tables, etc before _stext RW (set NX). */
+	{
+		.start	= PAGE_OFFSET,
+		.end	= (unsigned long)_stext,
+		.mask	= ~PMD_SECT_XN,
+		.prot	= PMD_SECT_XN,
+	},
+	/* Make init RW (set NX). */
+	{
+		.start	= (unsigned long)__init_begin,
+		.end	= (unsigned long)_sdata,
+		.mask	= ~PMD_SECT_XN,
+		.prot	= PMD_SECT_XN,
+	},
+};
+
+static inline void section_update(unsigned long addr, pmdval_t mask,
+				  pmdval_t prot)
+{
+	pmd_t *pmd = pmd_off_k(addr);
+
+#ifdef CONFIG_ARM_LPAE
+	pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
+#else
+	if (addr & SECTION_SIZE)
+		pmd[1] = __pmd((pmd_val(pmd[1]) & mask) | prot);
+	else
+		pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
+#endif
+	flush_pmd_entry(pmd);
+}
+
+static inline bool arch_has_strict_perms(void)
+{
+	unsigned int cr;
+
+	if (cpu_architecture() < CPU_ARCH_ARMv6)
+		return false;
+
+	cr = get_cr();
+	if (!(cr & CR_XP))
+		return false;
+
+	return true;
+}
+
+static inline void fix_kernmem_perms(void)
+{
+	unsigned long addr;
+	unsigned int i;
+
+	if (!arch_has_strict_perms())
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(section_perms); i++) {
+		if (!IS_ALIGNED(section_perms[i].start, SECTION_SIZE) ||
+		    !IS_ALIGNED(section_perms[i].end, SECTION_SIZE)) {
+			pr_err("BUG: section %lx-%lx not aligned to %lx\n",
+				section_perms[i].start, section_perms[i].end,
+				SECTION_SIZE);
+			continue;
+		}
+
+		for (addr = section_perms[i].start;
+		     addr < section_perms[i].end;
+		     addr += SECTION_SIZE)
+			section_update(addr, section_perms[i].mask,
+				       section_perms[i].prot);
+	}
+}
+#else
+static inline void fix_kernmem_perms(void) { }
+#endif /* CONFIG_ARM_KERNMEM_PERMS */
+
 void free_initmem(void)
 {
 #ifdef CONFIG_HAVE_TCM
 	extern char __tcm_start, __tcm_end;
+#endif
+
+	fix_kernmem_perms();
 
+#ifdef CONFIG_HAVE_TCM
 	poison_init_mem(&__tcm_start, &__tcm_end - &__tcm_start);
 	free_reserved_area(&__tcm_start, &__tcm_end, -1, "TCM link");
 #endif
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index a623cb3ad012..9d89de8cc349 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1369,13 +1369,24 @@ static void __init map_lowmem(void)
 		if (start >= end)
 			break;
 
-		if (end < kernel_x_start || start >= kernel_x_end) {
+		if (end < kernel_x_start) {
 			map.pfn = __phys_to_pfn(start);
 			map.virtual = __phys_to_virt(start);
 			map.length = end - start;
 			map.type = MT_MEMORY_RWX;
 
 			create_mapping(&map);
+		} else if (start >= kernel_x_end) {
+			map.pfn = __phys_to_pfn(start);
+			map.virtual = __phys_to_virt(start);
+			map.length = end - start;
+#ifdef CONFIG_ARM_KERNMEM_PERMS
+			map.type = MT_MEMORY_RW;
+#else
+			map.type = MT_MEMORY_RWX;
+#endif
+
+			create_mapping(&map);
 		} else {
 			/* This better cover the entire kernel */
 			if (start < kernel_x_start) {
-- 
1.7.9.5

