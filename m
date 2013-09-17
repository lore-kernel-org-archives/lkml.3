Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab3IQKCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:02:18 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:53333 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab3IQKCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:02:15 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/3] m68k: Add preliminary kexec support
Date: Tue, 17 Sep 2013 12:01:31 +0200
Message-Id: <1379412095-7213-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379412095-7213-1-git-send-email-geert@linux-m68k.org>
References: <1379412095-7213-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig                  |   17 ++++++++
 arch/m68k/include/asm/kexec.h      |   29 +++++++++++++
 arch/m68k/kernel/Makefile          |    2 +
 arch/m68k/kernel/machine_kexec.c   |   71 ++++++++++++++++++++++++++++++++
 arch/m68k/kernel/relocate_kernel.S |   79 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kexec.h         |    1 +
 6 files changed, 199 insertions(+)
 create mode 100644 arch/m68k/include/asm/kexec.h
 create mode 100644 arch/m68k/kernel/machine_kexec.c
 create mode 100644 arch/m68k/kernel/relocate_kernel.S

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 311a300..d60497f 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -86,6 +86,23 @@ config MMU_SUN3
 	bool
 	depends on MMU && !MMU_MOTOROLA && !MMU_COLDFIRE
 
+config KEXEC
+	bool "kexec system call"
+	depends on MMU # FIXME
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
index 0000000..3df97ab
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
index 655347d..7ee5f00 100644
--- a/arch/m68k/kernel/Makefile
+++ b/arch/m68k/kernel/Makefile
@@ -22,3 +22,5 @@ obj-$(CONFIG_PCI) += pcibios.o
 
 obj-$(CONFIG_HAS_DMA)	+= dma.o
 
+obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+
diff --git a/arch/m68k/kernel/machine_kexec.c b/arch/m68k/kernel/machine_kexec.c
new file mode 100644
index 0000000..c775da3
--- /dev/null
+++ b/arch/m68k/kernel/machine_kexec.c
@@ -0,0 +1,71 @@
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
+				  unsigned long start) __noreturn;
+
+void machine_kexec(struct kimage *image)
+{
+	void *reboot_code_buffer;
+	unsigned long kexec_indirection_page;
+
+	unsigned long entry;
+	unsigned long *ptr;
+
+	reboot_code_buffer = page_address(image->control_code_page);
+
+	memcpy(reboot_code_buffer, relocate_new_kernel,
+	       relocate_new_kernel_size);
+
+	/*
+	 * The generic kexec code builds a page list with physical
+	 * addresses, while we need virtual addresses
+	 */
+	for (ptr = &image->head; (entry = *ptr) && !(entry & IND_DONE);
+	     ptr = (entry & IND_INDIRECTION) ?
+	       phys_to_virt(entry & PAGE_MASK) : ptr + 1) {
+		if (*ptr & IND_SOURCE || *ptr & IND_INDIRECTION ||
+		    *ptr & IND_DESTINATION)
+			*ptr = (unsigned long) phys_to_virt(*ptr);
+	}
+
+	kexec_indirection_page = image->head & PAGE_MASK;
+
+	/*
+	 * we do not want to be bothered.
+	 */
+	local_irq_disable();
+
+	pr_info("Will call new kernel at 0x%08lx. Bye...\n", image->start);
+	__flush_cache_all();
+	((relocate_kernel_t) reboot_code_buffer)(kexec_indirection_page,
+						 image->start);
+}
diff --git a/arch/m68k/kernel/relocate_kernel.S b/arch/m68k/kernel/relocate_kernel.S
new file mode 100644
index 0000000..8d45d9c
--- /dev/null
+++ b/arch/m68k/kernel/relocate_kernel.S
@@ -0,0 +1,79 @@
+#include <linux/linkage.h>
+
+#include <asm/page.h>
+
+
+.globl relocate_new_kernel
+
+.text
+ENTRY(relocate_new_kernel)
+	moveq #0,%d0
+	.chip 68040	/* FIXME */
+	/* Disable MMU */
+	/* FIXME Keep caches enabled? */
+	movec %d0,%tc
+	movec %d0,%itt0
+	movec %d0,%itt1
+	movec %d0,%dtt0
+	movec %d0,%dtt1
+	.chip 68k
+
+	movel 4(%sp),%a0		/* a0 = ptr */
+	movel 8(%sp),%a1		/* a1 = start */
+	movew #PAGE_MASK,%d2		/* d2 = PAGE_MASK */
+
+1:
+	movel (%a0)+,%d0		/* d0 = entry = *ptr */
+	jeq 5f
+
+	btst #2,%d0			/* entry & IND_DONE? */
+	jne 5f
+
+	btst #1,%d0			/* entry & IND_INDIRECTION? */
+	jeq 2f
+	andw %d2,%d0
+	movel %d0,%a0			/* ptr = entry & PAGE_MASK */
+	bra 1b
+
+2:
+	btst #0,%d0			/* entry & IND_DESTINATION? */
+	jeq 3f
+	andw %d2,%d0
+	movel %d0,%a2			/* a2 = dst = entry & PAGE_MASK */
+	bra 1b
+
+3:
+	btst #3,%d0			/* entry & IND_SOURCE? */
+	jeq 1b
+
+	andw %d2,%d0
+	movel %d0,%a3			/* a3 = src = entry & PAGE_MASK */
+	movew #PAGE_SIZE/32 - 1,%d0	/* d0 = PAGE_SIZE/32 - 1 */
+4:
+	movel (%a3)+,(%a2)+		/* *dst++ = *src++ */
+	movel (%a3)+,(%a2)+		/* *dst++ = *src++ */
+	movel (%a3)+,(%a2)+		/* *dst++ = *src++ */
+	movel (%a3)+,(%a2)+		/* *dst++ = *src++ */
+	movel (%a3)+,(%a2)+		/* *dst++ = *src++ */
+	movel (%a3)+,(%a2)+		/* *dst++ = *src++ */
+	movel (%a3)+,(%a2)+		/* *dst++ = *src++ */
+	movel (%a3)+,(%a2)+		/* *dst++ = *src++ */
+	dbf %d0, 4b
+	bra 1b
+
+5:
+	.chip 68040	/* FIXME */
+	/* Flush all caches */
+	nop
+	cpusha %bc
+	nop
+	cinva %bc
+	nop
+	.chip 68k
+
+	jmp (%a1)
+
+relocate_new_kernel_end:
+
+ENTRY(relocate_new_kernel_size)
+	.long relocate_new_kernel_end - relocate_new_kernel
diff --git a/include/uapi/linux/kexec.h b/include/uapi/linux/kexec.h
index 104838f..d6629d4 100644
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

