Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3LALbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 06:31:25 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:53232 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab3LALav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 06:30:51 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v3 1/2] m68k: Add kexec support
Date: Sun,  1 Dec 2013 12:30:34 +0100
Message-Id: <1385897435-18618-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385897435-18618-1-git-send-email-geert@linux-m68k.org>
References: <1385897435-18618-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2:
  - KEXEC depends on M68KCLASSIC,
  - Fix handling of virtual and physical addresses, for machines where
    memory doesn't start at zero,
  - Support for other CPUs than 68040.
v3:
  - Clear '040/'060 transparent translation registers on MMU disable

 arch/m68k/Kconfig                  |   17 ++++
 arch/m68k/include/asm/kexec.h      |   29 +++++++
 arch/m68k/kernel/Makefile          |    2 +
 arch/m68k/kernel/asm-offsets.c     |    3 +
 arch/m68k/kernel/machine_kexec.c   |   58 +++++++++++++
 arch/m68k/kernel/relocate_kernel.S |  159 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kexec.h         |    1 +
 7 files changed, 269 insertions(+)
 create mode 100644 arch/m68k/include/asm/kexec.h
 create mode 100644 arch/m68k/kernel/machine_kexec.c
 create mode 100644 arch/m68k/kernel/relocate_kernel.S

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 75f25a8e3001..178dffa9de80 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -87,6 +87,23 @@ config MMU_SUN3
 	bool
 	depends on MMU && !MMU_MOTOROLA && !MMU_COLDFIRE
 
+config KEXEC
+	bool "kexec system call"
+	depends on M68KCLASSIC
+	help
+	  kexec is a system call that implements the ability to shutdown your
+	  current kernel, and to start another kernel.  It is like a reboot
+	  but it is independent of the system firmware.   And like a reboot
+	  you can start any kernel with it, not just Linux.
+
+	  The name comes from the similarity to the exec system call.
+
+	  It is an ongoing process to be certain the hardware in a machine
+	  is properly shutdown, so do not be surprised if this code does not
+	  initially work for you.  As of this writing the exact hardware
+	  interface is strongly in flux, so no good recommendation can be
+	  made.
+
 menu "Platform setup"
 
 source arch/m68k/Kconfig.cpu
diff --git a/arch/m68k/include/asm/kexec.h b/arch/m68k/include/asm/kexec.h
new file mode 100644
index 000000000000..3df97abac147
--- /dev/null
+++ b/arch/m68k/include/asm/kexec.h
@@ -0,0 +1,29 @@
+#ifndef _ASM_M68K_KEXEC_H
+#define _ASM_M68K_KEXEC_H
+
+#ifdef CONFIG_KEXEC
+
+/* Maximum physical address we can use pages from */
+#define KEXEC_SOURCE_MEMORY_LIMIT (-1UL)
+/* Maximum address we can reach in physical address mode */
+#define KEXEC_DESTINATION_MEMORY_LIMIT (-1UL)
+/* Maximum address we can use for the control code buffer */
+#define KEXEC_CONTROL_MEMORY_LIMIT (-1UL)
+
+#define KEXEC_CONTROL_PAGE_SIZE	4096
+
+#define KEXEC_ARCH KEXEC_ARCH_68K
+
+#ifndef __ASSEMBLY__
+
+static inline void crash_setup_regs(struct pt_regs *newregs,
+				    struct pt_regs *oldregs)
+{
+	/* Dummy implementation for now */
+}
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* CONFIG_KEXEC */
+
+#endif /* _ASM_M68K_KEXEC_H */
diff --git a/arch/m68k/kernel/Makefile b/arch/m68k/kernel/Makefile
index 655347d80780..7ee5f00a9abb 100644
--- a/arch/m68k/kernel/Makefile
+++ b/arch/m68k/kernel/Makefile
@@ -22,3 +22,5 @@ obj-$(CONFIG_PCI) += pcibios.o
 
 obj-$(CONFIG_HAS_DMA)	+= dma.o
 
+obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+
diff --git a/arch/m68k/kernel/asm-offsets.c b/arch/m68k/kernel/asm-offsets.c
index 8b7b22846366..3a386341aa6e 100644
--- a/arch/m68k/kernel/asm-offsets.c
+++ b/arch/m68k/kernel/asm-offsets.c
@@ -98,6 +98,9 @@ int main(void)
 	DEFINE(CIABBASE, &ciab);
 	DEFINE(C_PRA, offsetof(struct CIA, pra));
 	DEFINE(ZTWOBASE, zTwoBase);
+
+	/* enum m68k_fixup_type */
+	DEFINE(M68K_FIXUP_MEMOFFSET, m68k_fixup_memoffset);
 #endif
 
 	return 0;
diff --git a/arch/m68k/kernel/machine_kexec.c b/arch/m68k/kernel/machine_kexec.c
new file mode 100644
index 000000000000..d4affc917d9d
--- /dev/null
+++ b/arch/m68k/kernel/machine_kexec.c
@@ -0,0 +1,58 @@
+/*
+ * machine_kexec.c - handle transition of Linux booting another kernel
+ */
+#include <linux/compiler.h>
+#include <linux/kexec.h>
+#include <linux/mm.h>
+#include <linux/delay.h>
+
+#include <asm/cacheflush.h>
+#include <asm/page.h>
+#include <asm/setup.h>
+
+extern const unsigned char relocate_new_kernel[];
+extern const size_t relocate_new_kernel_size;
+
+int machine_kexec_prepare(struct kimage *kimage)
+{
+	return 0;
+}
+
+void machine_kexec_cleanup(struct kimage *kimage)
+{
+}
+
+void machine_shutdown(void)
+{
+}
+
+void machine_crash_shutdown(struct pt_regs *regs)
+{
+}
+
+typedef void (*relocate_kernel_t)(unsigned long ptr,
+				  unsigned long start,
+				  unsigned long cpu_mmu_flags) __noreturn;
+
+void machine_kexec(struct kimage *image)
+{
+	void *reboot_code_buffer;
+	unsigned long cpu_mmu_flags;
+
+	reboot_code_buffer = page_address(image->control_code_page);
+
+	memcpy(reboot_code_buffer, relocate_new_kernel,
+	       relocate_new_kernel_size);
+
+	/*
+	 * we do not want to be bothered.
+	 */
+	local_irq_disable();
+
+	pr_info("Will call new kernel at 0x%08lx. Bye...\n", image->start);
+	__flush_cache_all();
+	cpu_mmu_flags = m68k_cputype | m68k_mmutype << 8;
+	((relocate_kernel_t) reboot_code_buffer)(image->head & PAGE_MASK,
+						 image->start,
+						 cpu_mmu_flags);
+}
diff --git a/arch/m68k/kernel/relocate_kernel.S b/arch/m68k/kernel/relocate_kernel.S
new file mode 100644
index 000000000000..3e09a89067ad
--- /dev/null
+++ b/arch/m68k/kernel/relocate_kernel.S
@@ -0,0 +1,159 @@
+#include <linux/linkage.h>
+
+#include <asm/asm-offsets.h>
+#include <asm/page.h>
+#include <asm/setup.h>
+
+
+#define MMU_BASE	8		/* MMU flags base in cpu_mmu_flags */
+
+.text
+
+ENTRY(relocate_new_kernel)
+	movel %sp@(4),%a0		/* a0 = ptr */
+	movel %sp@(8),%a1		/* a1 = start */
+	movel %sp@(12),%d1		/* d1 = cpu_mmu_flags */
+	movew #PAGE_MASK,%d2		/* d2 = PAGE_MASK */
+
+	/* Disable MMU */
+
+	btst #MMU_BASE + MMUB_68851,%d1
+	jeq 3f
+
+1:	/* 68851 or 68030 */
+
+	lea %pc@(.Lcopy),%a4
+2:	addl #0x00000000,%a4		/* virt_to_phys() */
+
+	.section ".m68k_fixup","aw"
+	.long M68K_FIXUP_MEMOFFSET, 2b+2
+	.previous
+
+	.chip 68030
+	pmove %tc,%d0			/* Disable MMU */
+	bclr #7,%d0
+	pmove %d0,%tc
+	jmp %a4@			/* Jump to physical .Lcopy */
+	.chip 68k
+
+3:
+	btst #MMU_BASE + MMUB_68030,%d1
+	jne 1b
+
+	btst #MMU_BASE + MMUB_68040,%d1
+	jeq 6f
+
+4:	/* 68040 or 68060 */
+
+	lea %pc@(.Lcont040),%a4
+5:	addl #0x00000000,%a4		/* virt_to_phys() */
+
+	.section ".m68k_fixup","aw"
+	.long M68K_FIXUP_MEMOFFSET, 5b+2
+	.previous
+
+	movel %a4,%d0
+	andl #0xff000000,%d0
+	orw #0xe020,%d0			/* Map 16 MiB, enable, cacheable */
+	.chip 68040
+	movec %d0,%itt0
+	movec %d0,%dtt0
+	.chip 68k
+	jmp %a4@			/* Jump to physical .Lcont040 */
+
+.Lcont040:
+	moveq #0,%d0
+	.chip 68040
+	movec %d0,%tc			/* Disable MMU */
+	movec %d0,%itt0
+	movec %d0,%itt1
+	movec %d0,%dtt0
+	movec %d0,%dtt1
+	.chip 68k
+	jra .Lcopy
+
+6:
+	btst #MMU_BASE + MMUB_68060,%d1
+	jne 4b
+
+.Lcopy:
+	movel %a0@+,%d0			/* d0 = entry = *ptr */
+	jeq .Lflush
+
+	btst #2,%d0			/* entry & IND_DONE? */
+	jne .Lflush
+
+	btst #1,%d0			/* entry & IND_INDIRECTION? */
+	jeq 1f
+	andw %d2,%d0
+	movel %d0,%a0			/* ptr = entry & PAGE_MASK */
+	jra .Lcopy
+
+1:
+	btst #0,%d0			/* entry & IND_DESTINATION? */
+	jeq 2f
+	andw %d2,%d0
+	movel %d0,%a2			/* a2 = dst = entry & PAGE_MASK */
+	jra .Lcopy
+
+2:
+	btst #3,%d0			/* entry & IND_SOURCE? */
+	jeq .Lcopy
+
+	andw %d2,%d0
+	movel %d0,%a3			/* a3 = src = entry & PAGE_MASK */
+	movew #PAGE_SIZE/32 - 1,%d0	/* d0 = PAGE_SIZE/32 - 1 */
+3:
+	movel %a3@+,%a2@+		/* *dst++ = *src++ */
+	movel %a3@+,%a2@+		/* *dst++ = *src++ */
+	movel %a3@+,%a2@+		/* *dst++ = *src++ */
+	movel %a3@+,%a2@+		/* *dst++ = *src++ */
+	movel %a3@+,%a2@+		/* *dst++ = *src++ */
+	movel %a3@+,%a2@+		/* *dst++ = *src++ */
+	movel %a3@+,%a2@+		/* *dst++ = *src++ */
+	movel %a3@+,%a2@+		/* *dst++ = *src++ */
+	dbf %d0, 3b
+	jra .Lcopy
+
+.Lflush:
+	/* Flush all caches */
+
+	btst #CPUB_68020,%d1
+	jeq 2f
+
+1:	/* 68020 or 68030 */
+	.chip 68030
+	movec %cacr,%d0
+	orw #0x808,%d0
+	movec %d0,%cacr
+	.chip 68k
+	jra .Lreincarnate
+
+2:
+	btst #CPUB_68030,%d1
+	jne 1b
+
+	btst #CPUB_68040,%d1
+	jeq 4f
+
+3:	/* 68040 or 68060 */
+	.chip 68040
+	nop
+	cpusha %bc
+	nop
+	cinva %bc
+	nop
+	.chip 68k
+	jra .Lreincarnate
+
+4:
+	btst #CPUB_68060,%d1
+	jne 3b
+
+.Lreincarnate:
+	jmp %a1@
+
+relocate_new_kernel_end:
+
+ENTRY(relocate_new_kernel_size)
+	.long relocate_new_kernel_end - relocate_new_kernel
diff --git a/include/uapi/linux/kexec.h b/include/uapi/linux/kexec.h
index 104838f65bc1..d6629d49a243 100644
--- a/include/uapi/linux/kexec.h
+++ b/include/uapi/linux/kexec.h
@@ -18,6 +18,7 @@
  */
 #define KEXEC_ARCH_DEFAULT ( 0 << 16)
 #define KEXEC_ARCH_386     ( 3 << 16)
+#define KEXEC_ARCH_68K     ( 4 << 16)
 #define KEXEC_ARCH_X86_64  (62 << 16)
 #define KEXEC_ARCH_PPC     (20 << 16)
 #define KEXEC_ARCH_PPC64   (21 << 16)
-- 
1.7.9.5

