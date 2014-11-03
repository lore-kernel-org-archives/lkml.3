Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaKCUt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:49:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51895 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbaKCUtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:49:23 -0500
Date: Mon, 3 Nov 2014 12:49:07 -0800
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-1ad83c858c7d4ea210429142c99a1548e6715a35@git.kernel.org>
Cc: mingo@kernel.org, tglx@linutronix.de, luto@amacapital.net, hpa@zytor.com,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        konrad.wilk@oracle.com
Reply-To: luto@amacapital.net, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, konrad.wilk@oracle.com
In-Reply-To: <406db88b8dd5f0cbbf38216d11be34bbb43c7eae.1414618407.git.luto@amacapital.net>
References: <406db88b8dd5f0cbbf38216d11be34bbb43c7eae.1414618407.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86_64,vsyscall:
  Make vsyscall emulation configurable
Git-Commit-ID: 1ad83c858c7d4ea210429142c99a1548e6715a35
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ad83c858c7d4ea210429142c99a1548e6715a35
Gitweb:     http://git.kernel.org/tip/1ad83c858c7d4ea210429142c99a1548e6715a35
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Wed, 29 Oct 2014 14:33:47 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 21:44:57 +0100

x86_64,vsyscall: Make vsyscall emulation configurable

This adds CONFIG_X86_VSYSCALL_EMULATION, guarded by CONFIG_EXPERT.
Turning it off completely disables vsyscall emulation, saving ~3.5k
for vsyscall_64.c, 4k for vsyscall_emu_64.S (the fake vsyscall
page), some tiny amount of core mm code that supports a gate area,
and possibly 4k for a wasted pagetable.  The latter is because the
vsyscall addresses are misaligned and fit poorly in the fixmap.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/406db88b8dd5f0cbbf38216d11be34bbb43c7eae.1414618407.git.luto@amacapital.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
index f2327e8..cd10436 100644
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
index ffb1733..d8d5bcb 100644
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
index 8f1e774..5d4502c 100644
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
index 235cfd3..59a6f884 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1190,9 +1190,7 @@ void __init setup_arch(char **cmdline_p)
 
 	tboot_probe();
 
-#ifdef CONFIG_X86_64
 	map_vsyscall();
-#endif
 
 	generic_apic_probe();
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index a8a1a3d..8906cf0 100644
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
