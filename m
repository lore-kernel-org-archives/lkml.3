Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaD1Bac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:30:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43037 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812AbaD1B3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:23 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Will Deacon" <will.deacon@arm.com>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.763292975@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 25/94] ARM: 7954/1: mm: remove remaining domain
 support from ARMv6
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit b6ccb9803e90c16b212cf4ed62913a7591e79a39 upstream.

CPU_32v6 currently selects CPU_USE_DOMAINS if CPU_V6 and MMU. This is
because ARM 1136 r0pX CPUs lack the v6k extensions, and therefore do
not have hardware thread registers. The lack of these registers requires
the kernel to update the vectors page at each context switch in order to
write a new TLS pointer. This write must be done via the userspace
mapping, since aliasing caches can lead to expensive flushing when using
kmap. Finally, this requires the vectors page to be mapped r/w for
kernel and r/o for user, which has implications for things like put_user
which must trigger CoW appropriately when targetting user pages.

The upshot of all this is that a v6/v7 kernel makes use of domains to
segregate kernel and user memory accesses. This has the nasty
side-effect of making device mappings executable, which has been
observed to cause subtle bugs on recent cores (e.g. Cortex-A15
performing a speculative instruction fetch from the GIC and acking an
interrupt in the process).

This patch solves this problem by removing the remaining domain support
from ARMv6. A new memory type is added specifically for the vectors page
which allows that page (and only that page) to be mapped as user r/o,
kernel r/w. All other user r/o pages are mapped also as kernel r/o.
Patch co-developed with Russell King.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[bwh: Backported to 3.2:
 - Adjust filename, context
 - Drop condition on CONFIG_ARM_LPAE]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/arm/include/asm/futex.h
+++ b/arch/arm/include/asm/futex.h
@@ -3,11 +3,6 @@
 
 #ifdef __KERNEL__
 
-#if defined(CONFIG_CPU_USE_DOMAINS) && defined(CONFIG_SMP)
-/* ARM doesn't provide unprivileged exclusive memory accessors */
-#include <asm-generic/futex.h>
-#else
-
 #include <linux/futex.h>
 #include <linux/uaccess.h>
 #include <asm/errno.h>
@@ -163,6 +158,5 @@ futex_atomic_op_inuser (int encoded_op,
 	return ret;
 }
 
-#endif /* !(CPU_USE_DOMAINS && SMP) */
 #endif /* __KERNEL__ */
 #endif /* _ASM_ARM_FUTEX_H */
--- a/arch/arm/include/asm/pgtable-2level.h
+++ b/arch/arm/include/asm/pgtable-2level.h
@@ -139,6 +139,7 @@
 #define L_PTE_MT_DEV_NONSHARED	(_AT(pteval_t, 0x0c) << 2)	/* 1100 */
 #define L_PTE_MT_DEV_WC		(_AT(pteval_t, 0x09) << 2)	/* 1001 */
 #define L_PTE_MT_DEV_CACHED	(_AT(pteval_t, 0x0b) << 2)	/* 1011 */
+#define L_PTE_MT_VECTORS	(_AT(pteval_t, 0x0f) << 2)	/* 1111 */
 #define L_PTE_MT_MASK		(_AT(pteval_t, 0x0f) << 2)
 
 #endif /* _ASM_PGTABLE_2LEVEL_H */
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -458,7 +458,6 @@ config CPU_32v5
 config CPU_32v6
 	bool
 	select TLS_REG_EMUL if !CPU_32v6K && !MMU
-	select CPU_USE_DOMAINS if CPU_V6 && MMU
 
 config CPU_32v6K
 	bool
@@ -652,7 +651,7 @@ config ARM_THUMBEE
 
 config SWP_EMULATE
 	bool "Emulate SWP/SWPB instructions"
-	depends on !CPU_USE_DOMAINS && CPU_V7
+	depends on CPU_V7
 	select HAVE_PROC_CPU if PROC_FS
 	default y if SMP
 	help
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -426,6 +426,14 @@ static void __init build_mem_type_table(
 		mem_types[MT_MEMORY_NONCACHED].prot_pte |= L_PTE_SHARED;
 	}
 	/*
+	 * We don't use domains on ARMv6 (since this causes problems with
+	 * v6/v7 kernels), so we must use a separate memory type for user
+	 * r/o, kernel r/w to map the vectors page.
+	 */
+	if (cpu_arch == CPU_ARCH_ARMv6)
+		vecs_pgprot |= L_PTE_MT_VECTORS;
+
+	/*
 	 * ARMv6 and above have extended page tables.
 	 */
 	if (cpu_arch >= CPU_ARCH_ARMv6 && (cr & CR_XP)) {
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -106,13 +106,9 @@
  *  100x   1   0   1	r/o	no acc
  *  10x0   1   0   1	r/o	no acc
  *  1011   0   0   1	r/w	no acc
- *  110x   0   1   0	r/w	r/o
- *  11x0   0   1   0	r/w	r/o
- *  1111   0   1   1	r/w	r/w
- *
- * If !CONFIG_CPU_USE_DOMAINS, the following permissions are changed:
  *  110x   1   1   1	r/o	r/o
  *  11x0   1   1   1	r/o	r/o
+ *  1111   0   1   1	r/w	r/w
  */
 	.macro	armv6_mt_table pfx
 \pfx\()_mt_table:
@@ -131,7 +127,7 @@
 	.long	PTE_EXT_TEX(2)					@ L_PTE_MT_DEV_NONSHARED
 	.long	0x00						@ unused
 	.long	0x00						@ unused
-	.long	0x00						@ unused
+	.long	PTE_CACHEABLE | PTE_BUFFERABLE | PTE_EXT_APX	@ L_PTE_MT_VECTORS
 	.endm
 
 	.macro	armv6_set_pte_ext pfx
@@ -152,24 +148,21 @@
 
 	tst	r1, #L_PTE_USER
 	orrne	r3, r3, #PTE_EXT_AP1
-#ifdef CONFIG_CPU_USE_DOMAINS
-	@ allow kernel read/write access to read-only user pages
 	tstne	r3, #PTE_EXT_APX
-	bicne	r3, r3, #PTE_EXT_APX | PTE_EXT_AP0
-#endif
+
+	@ user read-only -> kernel read-only
+	bicne	r3, r3, #PTE_EXT_AP0
 
 	tst	r1, #L_PTE_XN
 	orrne	r3, r3, #PTE_EXT_XN
 
-	orr	r3, r3, r2
+	eor	r3, r3, r2
 
 	tst	r1, #L_PTE_YOUNG
 	tstne	r1, #L_PTE_PRESENT
 	moveq	r3, #0
-#ifndef CONFIG_CPU_USE_DOMAINS
 	tstne	r1, #L_PTE_NONE
 	movne	r3, #0
-#endif
 
 	str	r3, [r0]
 	mcr	p15, 0, r0, c7, c10, 1		@ flush_pte
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -160,21 +160,14 @@ ENTRY(cpu_v7_set_pte_ext)
 
 	tst	r1, #L_PTE_USER
 	orrne	r3, r3, #PTE_EXT_AP1
-#ifdef CONFIG_CPU_USE_DOMAINS
-	@ allow kernel read/write access to read-only user pages
-	tstne	r3, #PTE_EXT_APX
-	bicne	r3, r3, #PTE_EXT_APX | PTE_EXT_AP0
-#endif
 
 	tst	r1, #L_PTE_XN
 	orrne	r3, r3, #PTE_EXT_XN
 
 	tst	r1, #L_PTE_YOUNG
 	tstne	r1, #L_PTE_PRESENT
-#ifndef CONFIG_CPU_USE_DOMAINS
 	eorne	r1, r1, #L_PTE_NONE
 	tstne	r1, #L_PTE_NONE
-#endif
 	moveq	r3, #0
 
  ARM(	str	r3, [r0, #2048]! )

