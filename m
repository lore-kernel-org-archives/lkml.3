Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaBNBHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:07:34 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52624 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbaBNBHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 20:07:02 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: keescook@chromium.org, Russell King <linux@arm.linux.org.uk>,
        Laura Abbott <lauraa@codeaurora.org>,
        Larry Bassel <lbassel@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Simon Baatz <gmbnomis@gmail.com>, Nicolas Pitre <nico@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>, Will Deacon <will.deacon@arm.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jiang Liu <liuj97@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Vitaly Andrianov <vitalya@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: mm: allow for stricter kernel memory perms
Date: Thu, 13 Feb 2014 17:04:09 -0800
Message-Id: <1392339850-18686-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392339850-18686-1-git-send-email-keescook@chromium.org>
References: <1392339850-18686-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds CONFIG_ARM_KERNMEM_PERMS to separate the kernel memory regions
into section-sized areas that can have different permisions. Performs
the permission changes during free_initmem.

This uses section size instead of PMD size to reduce memory caps on
non-LPAE systems.

Based on work by Brad Spengler, Larry Bassel, and Laura Abbott.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/kernel/vmlinux.lds.S |   17 +++++++++
 arch/arm/mm/Kconfig           |   10 +++++
 arch/arm/mm/init.c            |   84 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+)

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
index 1f8fed94c2a4..999eb505faee 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -958,3 +958,13 @@ config ARCH_SUPPORTS_BIG_ENDIAN
 	help
 	  This option specifies the architecture can support big endian
 	  operation.
+
+config ARM_KERNMEM_PERMS
+	bool "Restrict kernel memory permissions"
+	help
+	  If this is set, kernel text will be made RX, kernel data and stack
+	  RW (otherwise all of the regions of the kernel 1-to-1 mapping
+	  outside section boundaries remains RWX). The tradeoff is that each
+	  region is padded to section-size (1MiB) boundaries (because their
+	  permissions are different and splitting the 1M pages into 4K ones
+	  causes TLB performance problems), wasting memory.
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 804d61566a53..f0b1df53f436 100644
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
 
@@ -621,11 +626,90 @@ void __init mem_init(void)
 	}
 }
 
+#ifdef CONFIG_ARM_KERNMEM_PERMS
+struct section_perm {
+	unsigned long start;
+	unsigned long end;
+	pmdval_t prot;
+};
+
+struct section_perm __initdata section_perms[] = {
+	/* Make pages tables, etc before _stext RW (set NX). */
+	{
+		.start	= PAGE_OFFSET,
+		.end	= (unsigned long)_stext,
+		.prot	= PMD_SECT_XN,
+	},
+	/* Make init RW (set NX). */
+	{
+		.start	= (unsigned long)__init_begin,
+		.end	= (unsigned long)_sdata,
+		.prot	= PMD_SECT_XN,
+	},
+	/* Make kernel code and rodata RX (set RO). */
+	{
+		.start	= (unsigned long)_stext,
+		.end	= (unsigned long)__init_begin,
+#ifdef CONFIG_ARM_LPAE
+		.prot	= PMD_SECT_RDONLY,
+#else
+		.prot	= PMD_SECT_APX | PMD_SECT_AP_WRITE,
+#endif
+	},
+};
+
+static inline void section_update(unsigned long addr, pmdval_t prot)
+{
+	pmd_t *pmd = pmd_off_k(addr);
+
+#ifdef CONFIG_ARM_LPAE
+	pmd[0] = __pmd(pmd_val(pmd[0]) | prot);
+#else
+	if (addr & SECTION_SIZE)
+		pmd[1] = __pmd(pmd_val(pmd[1]) | prot);
+	else
+		pmd[0] = __pmd(pmd_val(pmd[0]) | prot);
+#endif
+	flush_pmd_entry(pmd);
+}
+
+static inline void fix_kernmem_perms(void)
+{
+	unsigned long addr;
+	int cpu_arch = cpu_architecture();
+	unsigned int i, cr = get_cr();
+
+	if (cpu_arch < CPU_ARCH_ARMv6 || !(cr & CR_XP))
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
+			section_update(addr, section_perms[i].prot);
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
-- 
1.7.9.5

