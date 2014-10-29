Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbaJ2VeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:34:07 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34554 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbaJ2VeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:34:03 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Ingo Molnar <mingo@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 3/3] x86_64,vsyscall: Make vsyscall emulation configurable
Date: Wed, 29 Oct 2014 14:33:47 -0700
Message-Id: <406db88b8dd5f0cbbf38216d11be34bbb43c7eae.1414618407.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1414618407.git.luto@amacapital.net>
References: <cover.1414618407.git.luto@amacapital.net>
In-Reply-To: <cover.1414618407.git.luto@amacapital.net>
References: <cover.1414618407.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds CONFIG_X86_VSYSCALL_EMULATION, guarded by CONFIG_EXPERT.
Turning it off completely disables vsyscall emulation, saving ~3.5k
for vsyscall_64.c, 4k for vsyscall_emu_64.S (the fake vsyscall
page), some tiny amount of core mm code that supports a gate area,
and possibly 4k for a wasted pagetable.  The latter is because the
vsyscall addresses are misaligned and fit poorly in the fixmap.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
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
index f2327e88e07c..cd10436d7d1c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -984,6 +984,24 @@ config X86_ESPFIX64
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
+	 programs will just segfault, citing addresses of the form
+	 0xffffffffff600?00.
+
+	 This option is required by many programs built before 2013, and
+	 care should be used even with newer programs if set to N.
+
+	 Disabling this option saves about 7K of kernel size and
+	 possibly 4K of additional runtime pagetable memory.
+
 config TOSHIBA
 	tristate "Toshiba Laptop support"
 	depends on X86_32
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index ffb1733ac91f..d8d5bcb2a0b5 100644
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
index f408caf73430..b3bebf9e5746 100644
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
index 34f7d8857542..6ba66ee79710 100644
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
index 8f1e77440b2b..5d4502c8b983 100644
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
index 235cfd39e0d7..59a6f884fdad 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1190,9 +1190,7 @@ void __init setup_arch(char **cmdline_p)
 
 	tboot_probe();
 
-#ifdef CONFIG_X86_64
 	map_vsyscall();
-#endif
 
 	generic_apic_probe();
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index a8a1a3d08d4d..8906cf0e536f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1457,8 +1457,10 @@ static int xen_pgd_alloc(struct mm_struct *mm)
 		page->private = (unsigned long)user_pgd;
 
 		if (user_pgd != NULL) {
+#ifdef CONFIG_X86_VSYSCALL_EMULATION
 			user_pgd[pgd_index(VSYSCALL_ADDR)] =
 				__pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
+#endif
 			ret = 0;
 		}
 
@@ -2021,7 +2023,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 # ifdef CONFIG_HIGHMEM
 	case FIX_KMAP_BEGIN ... FIX_KMAP_END:
 # endif
-#else
+#elif defined(CONFIG_X86_VSYSCALL_EMULATION)
 	case VSYSCALL_PAGE:
 #endif
 	case FIX_TEXT_POKE0:
@@ -2060,7 +2062,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 
 	__native_set_fixmap(idx, pte);
 
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_VSYSCALL_EMULATION
 	/* Replicate changes to map the vsyscall page into the user
 	   pagetable vsyscall mapping. */
 	if (idx == VSYSCALL_PAGE) {
-- 
1.9.3

