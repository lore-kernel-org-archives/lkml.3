Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778AbaF3Vyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:54:43 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45600 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbaF3VyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:54:02 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, hpa@zytor.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 10/10] x86_64,vsyscall: Make vsyscall emulation configurable
Date: Mon, 30 Jun 2014 14:53:21 -0700
Message-Id: <442aba0c6131f0c41dfc5edb6bfb88335556523f.1404164803.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1404164803.git.luto@amacapital.net>
References: <cover.1404164803.git.luto@amacapital.net>
In-Reply-To: <cover.1404164803.git.luto@amacapital.net>
References: <cover.1404164803.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds CONFIG_X86_VSYSCALL_EMULATION, guarded by CONFIG_EXPERT.
Turning it off completely disables vsyscall emulation, saving ~3.5k
for vsyscall_64.c, 4k for vsyscall_emu_64.S (the fake vsyscall
page), some tiny amount of core mm code that supports a gate area,
and possibly 4k for a wasted pagetable.  The latter is because the
vsyscall addresses are misaligned and fit poorly in the fixmap.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/Kconfig                | 18 ++++++++++++++++++
 arch/x86/include/asm/fixmap.h   |  2 ++
 arch/x86/include/asm/page_64.h  |  4 +++-
 arch/x86/include/asm/vsyscall.h |  8 ++++++++
 arch/x86/kernel/Makefile        |  3 +--
 arch/x86/kernel/setup.c         |  2 --
 arch/x86/xen/mmu.c              |  6 ++++--
 7 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749e..a571cb4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -935,6 +935,24 @@ config X86_ESPFIX64
 	def_bool y
 	depends on X86_16BIT && X86_64
 
+config X86_VSYSCALL_EMULATION
+       bool "Enable vsyscall emulation" if EXPERT
+       default y
+       depends on X86_64
+       ---help---
+	 This enables emulation of the legacy vsyscall page.  Disabling
+	 it is roughly equivalent to booting with vsyscall=none, except
+	 that it will also disable the helpful warning if a program
+	 tries to use a vsyscall.  With this option set to N, offending
+	 program will just segfault, citing addresses of the form
+	 0xffffffffff600?00.
+
+         This option is required by many programs built before 2013, and
+	 care should be used even with newer programs if set to N.
+
+	 Disabling this option saves about 7K of kernel size and
+	 possibly 4K of additional runtime pagetable memory.
+
 config TOSHIBA
 	tristate "Toshiba Laptop support"
 	depends on X86_32
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index b0910f9..4568e6c 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -69,7 +69,9 @@ enum fixed_addresses {
 #ifdef CONFIG_X86_32
 	FIX_HOLE,
 #else
+#ifdef CONFIG_X86_VSYSCALL_EMULATION
 	VSYSCALL_PAGE = (FIXADDR_TOP - VSYSCALL_ADDR) >> PAGE_SHIFT,
+#endif
 #ifdef CONFIG_PARAVIRT_CLOCK
 	PVCLOCK_FIXMAP_BEGIN,
 	PVCLOCK_FIXMAP_END = PVCLOCK_FIXMAP_BEGIN+PVCLOCK_VSYSCALL_NR_PAGES-1,
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index f408caf..b3bebf9 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -39,6 +39,8 @@ void copy_page(void *to, void *from);
 
 #endif	/* !__ASSEMBLY__ */
 
-#define __HAVE_ARCH_GATE_AREA 1
+#ifdef CONFIG_X86_VSYSCALL_EMULATION
+# define __HAVE_ARCH_GATE_AREA 1
+#endif
 
 #endif /* _ASM_X86_PAGE_64_H */
diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
index 34f7d88..6ba66ee 100644
--- a/arch/x86/include/asm/vsyscall.h
+++ b/arch/x86/include/asm/vsyscall.h
@@ -4,6 +4,7 @@
 #include <linux/seqlock.h>
 #include <uapi/asm/vsyscall.h>
 
+#ifdef CONFIG_X86_VSYSCALL_EMULATION
 extern void map_vsyscall(void);
 
 /*
@@ -11,5 +12,12 @@ extern void map_vsyscall(void);
  * Returns true if handled.
  */
 extern bool emulate_vsyscall(struct pt_regs *regs, unsigned long address);
+#else
+static inline void map_vsyscall(void) {}
+static inline bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
+{
+	return false;
+}
+#endif
 
 #endif /* _ASM_X86_VSYSCALL_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 047f9ff..2f71845 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -28,8 +28,7 @@ obj-$(CONFIG_X86_32)	+= i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= mcount_64.o
 obj-y			+= syscall_$(BITS).o vsyscall_gtod.o
-obj-$(CONFIG_X86_64)	+= vsyscall_64.o
-obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
+obj-$(CONFIG_X86_VSYSCALL_EMULATION)	+= vsyscall_64.o vsyscall_emu_64.o
 obj-$(CONFIG_X86_ESPFIX64)	+= espfix_64.o
 obj-$(CONFIG_SYSFS)	+= ksysfs.o
 obj-y			+= bootflag.o e820.o
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 78a0e62..86eabe8 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1181,9 +1181,7 @@ void __init setup_arch(char **cmdline_p)
 
 	tboot_probe();
 
-#ifdef CONFIG_X86_64
 	map_vsyscall();
-#endif
 
 	generic_apic_probe();
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e8a1201..8e4a96b 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1493,11 +1493,13 @@ static int xen_pgd_alloc(struct mm_struct *mm)
 		user_pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 		page->private = (unsigned long)user_pgd;
 
+#ifdef CONFIG_X86_VSYSCALL_EMULATION
 		if (user_pgd != NULL) {
 			user_pgd[pgd_index(VSYSCALL_ADDR)] =
 				__pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
 			ret = 0;
 		}
+#endif
 
 		BUG_ON(PagePinned(virt_to_page(xen_get_user_pgd(pgd))));
 	}
@@ -2061,7 +2063,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 # ifdef CONFIG_HIGHMEM
 	case FIX_KMAP_BEGIN ... FIX_KMAP_END:
 # endif
-#else
+#elif defined(CONFIG_X86_VSYSCALL_EMULATION)
 	case VSYSCALL_PAGE:
 #endif
 	case FIX_TEXT_POKE0:
@@ -2100,7 +2102,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 
 	__native_set_fixmap(idx, pte);
 
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_VSYSCALL_EMULATION
 	/* Replicate changes to map the vsyscall page into the user
 	   pagetable vsyscall mapping. */
 	if (idx == VSYSCALL_PAGE) {
-- 
1.9.3

