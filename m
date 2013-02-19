Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab3BSPDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:03:43 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:43218 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932982Ab3BSPDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:03:41 -0500
Date: Tue, 19 Feb 2013 16:03:36 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm changes for v3.9
Message-ID: <20130219150336.GA13962@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asm-for-linus

   HEAD: 5e2a044daf0c6f897eb69de931e3b29020e874a9 x86, head_32: Give the 6 label a real name

The biggest change (by line count) is the unification of the XOR 
code and then the introduction of an additional SSE based XOR 
assembly method.

The other bigger change is the head_32.S rework/cleanup by 
Borislav Petkov.

Last but not least there's the usual laundry list of small but 
dangerous (and hopefully perfectly tested) changes to subtle low 
level x86 code, plus cleanups.

 Thanks,

	Ingo

------------------>
Borislav Petkov (4):
      x86, head_32: Remove i386 pieces
      x86: Detect CPUID support early at boot
      x86, head_32: Remove second CPUID detection from default_entry
      x86, head_32: Give the 6 label a real name

David Woodhouse (2):
      x86: Enable ARCH_USE_BUILTIN_BSWAP
      x86: Require MOVBE feature in cpuid when we use it

Jan Beulich (3):
      ix86: Tighten asmlinkage_protect() constraints
      x86/xor: Unify SSE-base xor-block routines
      x86/xor: Add alternative SSE implementation only prefetching once per 64-byte line

Kirill A. Shutemov (1):
      x86/mm: Convert update_mmu_cache() and update_mmu_cache_pmd() to functions

Wen Congyang (1):
      x86/mm: Fix the argument passed to sync_global_pgds()

Yuanhan Liu (1):
      x86: Fix a typo


 arch/x86/Kconfig                         |   1 +
 arch/x86/include/asm/linkage.h           |  18 +-
 arch/x86/include/asm/pgtable.h           |  12 +
 arch/x86/include/asm/pgtable_32.h        |   7 -
 arch/x86/include/asm/pgtable_64.h        |   3 -
 arch/x86/include/asm/required-features.h |   8 +-
 arch/x86/include/asm/xor.h               | 491 ++++++++++++++++++++++++++++++-
 arch/x86/include/asm/xor_32.h            | 309 +------------------
 arch/x86/include/asm/xor_64.h            | 305 +------------------
 arch/x86/kernel/head_32.S                |  93 +++---
 arch/x86/kernel/sys_x86_64.c             |   2 +-
 arch/x86/mm/init_64.c                    |   4 +-
 12 files changed, 574 insertions(+), 679 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 225543b..430204c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -114,6 +114,7 @@ config X86
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
 	select GENERIC_SIGALTSTACK
+	select ARCH_USE_BUILTIN_BSWAP
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 4814297..79327e9 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -27,20 +27,20 @@
 #define __asmlinkage_protect0(ret) \
 	__asmlinkage_protect_n(ret)
 #define __asmlinkage_protect1(ret, arg1) \
-	__asmlinkage_protect_n(ret, "g" (arg1))
+	__asmlinkage_protect_n(ret, "m" (arg1))
 #define __asmlinkage_protect2(ret, arg1, arg2) \
-	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2))
+	__asmlinkage_protect_n(ret, "m" (arg1), "m" (arg2))
 #define __asmlinkage_protect3(ret, arg1, arg2, arg3) \
-	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2), "g" (arg3))
+	__asmlinkage_protect_n(ret, "m" (arg1), "m" (arg2), "m" (arg3))
 #define __asmlinkage_protect4(ret, arg1, arg2, arg3, arg4) \
-	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2), "g" (arg3), \
-			      "g" (arg4))
+	__asmlinkage_protect_n(ret, "m" (arg1), "m" (arg2), "m" (arg3), \
+			      "m" (arg4))
 #define __asmlinkage_protect5(ret, arg1, arg2, arg3, arg4, arg5) \
-	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2), "g" (arg3), \
-			      "g" (arg4), "g" (arg5))
+	__asmlinkage_protect_n(ret, "m" (arg1), "m" (arg2), "m" (arg3), \
+			      "m" (arg4), "m" (arg5))
 #define __asmlinkage_protect6(ret, arg1, arg2, arg3, arg4, arg5, arg6) \
-	__asmlinkage_protect_n(ret, "g" (arg1), "g" (arg2), "g" (arg3), \
-			      "g" (arg4), "g" (arg5), "g" (arg6))
+	__asmlinkage_protect_n(ret, "m" (arg1), "m" (arg2), "m" (arg3), \
+			      "m" (arg4), "m" (arg5), "m" (arg6))
 
 #endif /* CONFIG_X86_32 */
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 5199db2..512ec6b 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -781,6 +781,18 @@ static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
        memcpy(dst, src, count * sizeof(pgd_t));
 }
 
+/*
+ * The x86 doesn't have any external MMU info: the kernel page
+ * tables contain all the necessary information.
+ */
+static inline void update_mmu_cache(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep)
+{
+}
+static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmd)
+{
+}
 
 #include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLY__ */
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index 8faa215..9ee3221 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -66,13 +66,6 @@ do {						\
 	__flush_tlb_one((vaddr));		\
 } while (0)
 
-/*
- * The i386 doesn't have any external MMU info: the kernel page
- * tables contain all the necessary information.
- */
-#define update_mmu_cache(vma, address, ptep) do { } while (0)
-#define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
-
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 47356f9..615b0c7 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -142,9 +142,6 @@ static inline int pgd_large(pgd_t pgd) { return 0; }
 #define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
 #define pte_unmap(pte) ((void)(pte))/* NOP */
 
-#define update_mmu_cache(vma, address, ptep) do { } while (0)
-#define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
-
 /* Encode and de-code a swap entry */
 #if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
 #define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index 6c7fc25..5c6e4fb 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -47,6 +47,12 @@
 # define NEED_NOPL	0
 #endif
 
+#ifdef CONFIG_MATOM
+# define NEED_MOVBE	(1<<(X86_FEATURE_MOVBE & 31))
+#else
+# define NEED_MOVBE	0
+#endif
+
 #ifdef CONFIG_X86_64
 #ifdef CONFIG_PARAVIRT
 /* Paravirtualized systems may not have PSE or PGE available */
@@ -80,7 +86,7 @@
 
 #define REQUIRED_MASK2	0
 #define REQUIRED_MASK3	(NEED_NOPL)
-#define REQUIRED_MASK4	0
+#define REQUIRED_MASK4	(NEED_MOVBE)
 #define REQUIRED_MASK5	0
 #define REQUIRED_MASK6	0
 #define REQUIRED_MASK7	0
diff --git a/arch/x86/include/asm/xor.h b/arch/x86/include/asm/xor.h
index f8fde90..d882975 100644
--- a/arch/x86/include/asm/xor.h
+++ b/arch/x86/include/asm/xor.h
@@ -1,10 +1,499 @@
 #ifdef CONFIG_KMEMCHECK
 /* kmemcheck doesn't handle MMX/SSE/SSE2 instructions */
 # include <asm-generic/xor.h>
+#elif !defined(_ASM_X86_XOR_H)
+#define _ASM_X86_XOR_H
+
+/*
+ * Optimized RAID-5 checksumming functions for SSE.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * (for example /usr/src/linux/COPYING); if not, write to the Free
+ * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/*
+ * Cache avoiding checksumming functions utilizing KNI instructions
+ * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
+ */
+
+/*
+ * Based on
+ * High-speed RAID5 checksumming functions utilizing SSE instructions.
+ * Copyright (C) 1998 Ingo Molnar.
+ */
+
+/*
+ * x86-64 changes / gcc fixes from Andi Kleen.
+ * Copyright 2002 Andi Kleen, SuSE Labs.
+ *
+ * This hasn't been optimized for the hammer yet, but there are likely
+ * no advantages to be gotten from x86-64 here anyways.
+ */
+
+#include <asm/i387.h>
+
+#ifdef CONFIG_X86_32
+/* reduce register pressure */
+# define XOR_CONSTANT_CONSTRAINT "i"
 #else
+# define XOR_CONSTANT_CONSTRAINT "re"
+#endif
+
+#define OFFS(x)		"16*("#x")"
+#define PF_OFFS(x)	"256+16*("#x")"
+#define PF0(x)		"	prefetchnta "PF_OFFS(x)"(%[p1])		;\n"
+#define LD(x, y)	"	movaps "OFFS(x)"(%[p1]), %%xmm"#y"	;\n"
+#define ST(x, y)	"	movaps %%xmm"#y", "OFFS(x)"(%[p1])	;\n"
+#define PF1(x)		"	prefetchnta "PF_OFFS(x)"(%[p2])		;\n"
+#define PF2(x)		"	prefetchnta "PF_OFFS(x)"(%[p3])		;\n"
+#define PF3(x)		"	prefetchnta "PF_OFFS(x)"(%[p4])		;\n"
+#define PF4(x)		"	prefetchnta "PF_OFFS(x)"(%[p5])		;\n"
+#define XO1(x, y)	"	xorps "OFFS(x)"(%[p2]), %%xmm"#y"	;\n"
+#define XO2(x, y)	"	xorps "OFFS(x)"(%[p3]), %%xmm"#y"	;\n"
+#define XO3(x, y)	"	xorps "OFFS(x)"(%[p4]), %%xmm"#y"	;\n"
+#define XO4(x, y)	"	xorps "OFFS(x)"(%[p5]), %%xmm"#y"	;\n"
+#define NOP(x)
+
+#define BLK64(pf, op, i)				\
+		pf(i)					\
+		op(i, 0)				\
+			op(i + 1, 1)			\
+				op(i + 2, 2)		\
+					op(i + 3, 3)
+
+static void
+xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)					\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+		PF1(i)					\
+				PF1(i + 2)		\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines),
+	  [p1] "+r" (p1), [p2] "+r" (p2)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_2_pf64(unsigned long bytes, unsigned long *p1, unsigned long *p2)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(NOP, ST, i)	\
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines),
+	  [p1] "+r" (p1), [p2] "+r" (p2)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	  unsigned long *p3)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i) \
+		PF1(i)					\
+				PF1(i + 2)		\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF2(i)					\
+				PF2(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines),
+	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_3_pf64(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	       unsigned long *p3)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(PF2, XO2, i)	\
+		BLK64(NOP, ST, i)	\
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines),
+	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	  unsigned long *p3, unsigned long *p4)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i) \
+		PF1(i)					\
+				PF1(i + 2)		\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF2(i)					\
+				PF2(i + 2)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		PF3(i)					\
+				PF3(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
+		XO3(i, 0)				\
+			XO3(i + 1, 1)			\
+				XO3(i + 2, 2)		\
+					XO3(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       add %[inc], %[p4]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines), [p1] "+r" (p1),
+	  [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_4_pf64(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	       unsigned long *p3, unsigned long *p4)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(PF2, XO2, i)	\
+		BLK64(PF3, XO3, i)	\
+		BLK64(NOP, ST, i)	\
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       add %[inc], %[p4]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines), [p1] "+r" (p1),
+	  [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i) \
+		PF1(i)					\
+				PF1(i + 2)		\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF2(i)					\
+				PF2(i + 2)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		PF3(i)					\
+				PF3(i + 2)		\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
+		PF4(i)					\
+				PF4(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO3(i, 0)				\
+			XO3(i + 1, 1)			\
+				XO3(i + 2, 2)		\
+					XO3(i + 3, 3)	\
+		XO4(i, 0)				\
+			XO4(i + 1, 1)			\
+				XO4(i + 2, 2)		\
+					XO4(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       add %[inc], %[p4]       ;\n"
+	"       add %[inc], %[p5]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines), [p1] "+r" (p1), [p2] "+r" (p2),
+	  [p3] "+r" (p3), [p4] "+r" (p4), [p5] "+r" (p5)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_5_pf64(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	       unsigned long *p3, unsigned long *p4, unsigned long *p5)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(PF2, XO2, i)	\
+		BLK64(PF3, XO3, i)	\
+		BLK64(PF4, XO4, i)	\
+		BLK64(NOP, ST, i)	\
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       add %[inc], %[p4]       ;\n"
+	"       add %[inc], %[p5]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines), [p1] "+r" (p1), [p2] "+r" (p2),
+	  [p3] "+r" (p3), [p4] "+r" (p4), [p5] "+r" (p5)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static struct xor_block_template xor_block_sse_pf64 = {
+	.name = "prefetch64-sse",
+	.do_2 = xor_sse_2_pf64,
+	.do_3 = xor_sse_3_pf64,
+	.do_4 = xor_sse_4_pf64,
+	.do_5 = xor_sse_5_pf64,
+};
+
+#undef LD
+#undef XO1
+#undef XO2
+#undef XO3
+#undef XO4
+#undef ST
+#undef NOP
+#undef BLK64
+#undef BLOCK
+
+#undef XOR_CONSTANT_CONSTRAINT
+
 #ifdef CONFIG_X86_32
 # include <asm/xor_32.h>
 #else
 # include <asm/xor_64.h>
 #endif
-#endif
+
+#define XOR_SELECT_TEMPLATE(FASTEST) \
+	AVX_SELECT(FASTEST)
+
+#endif /* _ASM_X86_XOR_H */
diff --git a/arch/x86/include/asm/xor_32.h b/arch/x86/include/asm/xor_32.h
index f79cb7e..ce05722 100644
--- a/arch/x86/include/asm/xor_32.h
+++ b/arch/x86/include/asm/xor_32.h
@@ -2,7 +2,7 @@
 #define _ASM_X86_XOR_32_H
 
 /*
- * Optimized RAID-5 checksumming functions for MMX and SSE.
+ * Optimized RAID-5 checksumming functions for MMX.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -529,290 +529,6 @@ static struct xor_block_template xor_block_p5_mmx = {
 	.do_5 = xor_p5_mmx_5,
 };
 
-/*
- * Cache avoiding checksumming functions utilizing KNI instructions
- * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
- */
-
-#define OFFS(x)		"16*("#x")"
-#define PF_OFFS(x)	"256+16*("#x")"
-#define	PF0(x)		"	prefetchnta "PF_OFFS(x)"(%1)		;\n"
-#define LD(x, y)	"       movaps   "OFFS(x)"(%1), %%xmm"#y"	;\n"
-#define ST(x, y)	"       movaps %%xmm"#y",   "OFFS(x)"(%1)	;\n"
-#define PF1(x)		"	prefetchnta "PF_OFFS(x)"(%2)		;\n"
-#define PF2(x)		"	prefetchnta "PF_OFFS(x)"(%3)		;\n"
-#define PF3(x)		"	prefetchnta "PF_OFFS(x)"(%4)		;\n"
-#define PF4(x)		"	prefetchnta "PF_OFFS(x)"(%5)		;\n"
-#define PF5(x)		"	prefetchnta "PF_OFFS(x)"(%6)		;\n"
-#define XO1(x, y)	"       xorps   "OFFS(x)"(%2), %%xmm"#y"	;\n"
-#define XO2(x, y)	"       xorps   "OFFS(x)"(%3), %%xmm"#y"	;\n"
-#define XO3(x, y)	"       xorps   "OFFS(x)"(%4), %%xmm"#y"	;\n"
-#define XO4(x, y)	"       xorps   "OFFS(x)"(%5), %%xmm"#y"	;\n"
-#define XO5(x, y)	"       xorps   "OFFS(x)"(%6), %%xmm"#y"	;\n"
-
-
-static void
-xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)					\
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-		PF1(i)					\
-				PF1(i + 2)		\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addl $256, %1           ;\n"
-	"       addl $256, %2           ;\n"
-	"       decl %0                 ;\n"
-	"       jnz 1b                  ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2)
-	:
-	: "memory");
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i,0)					\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO1(i,0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		XO2(i,0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		ST(i,0)					\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addl $256, %1           ;\n"
-	"       addl $256, %2           ;\n"
-	"       addl $256, %3           ;\n"
-	"       decl %0                 ;\n"
-	"       jnz 1b                  ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r"(p2), "+r"(p3)
-	:
-	: "memory" );
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3, unsigned long *p4)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i,0)					\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		XO1(i,0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		PF3(i)					\
-				PF3(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO2(i,0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		XO3(i,0)				\
-			XO3(i + 1, 1)			\
-				XO3(i + 2, 2)		\
-					XO3(i + 3, 3)	\
-		ST(i,0)					\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addl $256, %1           ;\n"
-	"       addl $256, %2           ;\n"
-	"       addl $256, %3           ;\n"
-	"       addl $256, %4           ;\n"
-	"       decl %0                 ;\n"
-	"       jnz 1b                  ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3), "+r" (p4)
-	:
-	: "memory" );
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	/* Make sure GCC forgets anything it knows about p4 or p5,
-	   such that it won't pass to the asm volatile below a
-	   register that is shared with any other variable.  That's
-	   because we modify p4 and p5 there, but we can't mark them
-	   as read/write, otherwise we'd overflow the 10-asm-operands
-	   limit of GCC < 3.1.  */
-	asm("" : "+r" (p4), "+r" (p5));
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i,0)					\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		XO1(i,0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		PF3(i)					\
-				PF3(i + 2)		\
-		XO2(i,0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		PF4(i)					\
-				PF4(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO3(i,0)				\
-			XO3(i + 1, 1)			\
-				XO3(i + 2, 2)		\
-					XO3(i + 3, 3)	\
-		XO4(i,0)				\
-			XO4(i + 1, 1)			\
-				XO4(i + 2, 2)		\
-					XO4(i + 3, 3)	\
-		ST(i,0)					\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addl $256, %1           ;\n"
-	"       addl $256, %2           ;\n"
-	"       addl $256, %3           ;\n"
-	"       addl $256, %4           ;\n"
-	"       addl $256, %5           ;\n"
-	"       decl %0                 ;\n"
-	"       jnz 1b                  ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3)
-	: "r" (p4), "r" (p5)
-	: "memory");
-
-	/* p4 and p5 were modified, and now the variables are dead.
-	   Clobber them just to be sure nobody does something stupid
-	   like assuming they have some legal value.  */
-	asm("" : "=r" (p4), "=r" (p5));
-
-	kernel_fpu_end();
-}
-
 static struct xor_block_template xor_block_pIII_sse = {
 	.name = "pIII_sse",
 	.do_2 = xor_sse_2,
@@ -827,26 +543,25 @@ static struct xor_block_template xor_block_pIII_sse = {
 /* Also try the generic routines.  */
 #include <asm-generic/xor.h>
 
+/* We force the use of the SSE xor block because it can write around L2.
+   We may also be able to load into the L1 only depending on how the cpu
+   deals with a load to a line that is being prefetched.  */
 #undef XOR_TRY_TEMPLATES
 #define XOR_TRY_TEMPLATES				\
 do {							\
-	xor_speed(&xor_block_8regs);			\
-	xor_speed(&xor_block_8regs_p);			\
-	xor_speed(&xor_block_32regs);			\
-	xor_speed(&xor_block_32regs_p);			\
 	AVX_XOR_SPEED;					\
-	if (cpu_has_xmm)				\
+	if (cpu_has_xmm) {				\
 		xor_speed(&xor_block_pIII_sse);		\
-	if (cpu_has_mmx) {				\
+		xor_speed(&xor_block_sse_pf64);		\
+	} else if (cpu_has_mmx) {			\
 		xor_speed(&xor_block_pII_mmx);		\
 		xor_speed(&xor_block_p5_mmx);		\
+	} else {					\
+		xor_speed(&xor_block_8regs);		\
+		xor_speed(&xor_block_8regs_p);		\
+		xor_speed(&xor_block_32regs);		\
+		xor_speed(&xor_block_32regs_p);		\
 	}						\
 } while (0)
 
-/* We force the use of the SSE xor block because it can write around L2.
-   We may also be able to load into the L1 only depending on how the cpu
-   deals with a load to a line that is being prefetched.  */
-#define XOR_SELECT_TEMPLATE(FASTEST)			\
-	AVX_SELECT(cpu_has_xmm ? &xor_block_pIII_sse : FASTEST)
-
 #endif /* _ASM_X86_XOR_32_H */
diff --git a/arch/x86/include/asm/xor_64.h b/arch/x86/include/asm/xor_64.h
index 87ac522..546f1e3 100644
--- a/arch/x86/include/asm/xor_64.h
+++ b/arch/x86/include/asm/xor_64.h
@@ -1,301 +1,6 @@
 #ifndef _ASM_X86_XOR_64_H
 #define _ASM_X86_XOR_64_H
 
-/*
- * Optimized RAID-5 checksumming functions for MMX and SSE.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * You should have received a copy of the GNU General Public License
- * (for example /usr/src/linux/COPYING); if not, write to the Free
- * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-
-/*
- * Cache avoiding checksumming functions utilizing KNI instructions
- * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
- */
-
-/*
- * Based on
- * High-speed RAID5 checksumming functions utilizing SSE instructions.
- * Copyright (C) 1998 Ingo Molnar.
- */
-
-/*
- * x86-64 changes / gcc fixes from Andi Kleen.
- * Copyright 2002 Andi Kleen, SuSE Labs.
- *
- * This hasn't been optimized for the hammer yet, but there are likely
- * no advantages to be gotten from x86-64 here anyways.
- */
-
-#include <asm/i387.h>
-
-#define OFFS(x)		"16*("#x")"
-#define PF_OFFS(x)	"256+16*("#x")"
-#define	PF0(x)		"	prefetchnta "PF_OFFS(x)"(%[p1])		;\n"
-#define LD(x, y)	"       movaps   "OFFS(x)"(%[p1]), %%xmm"#y"	;\n"
-#define ST(x, y)	"       movaps %%xmm"#y",   "OFFS(x)"(%[p1])	;\n"
-#define PF1(x)		"	prefetchnta "PF_OFFS(x)"(%[p2])		;\n"
-#define PF2(x)		"	prefetchnta "PF_OFFS(x)"(%[p3])		;\n"
-#define PF3(x)		"	prefetchnta "PF_OFFS(x)"(%[p4])		;\n"
-#define PF4(x)		"	prefetchnta "PF_OFFS(x)"(%[p5])		;\n"
-#define PF5(x)		"	prefetchnta "PF_OFFS(x)"(%[p6])		;\n"
-#define XO1(x, y)	"       xorps   "OFFS(x)"(%[p2]), %%xmm"#y"	;\n"
-#define XO2(x, y)	"       xorps   "OFFS(x)"(%[p3]), %%xmm"#y"	;\n"
-#define XO3(x, y)	"       xorps   "OFFS(x)"(%[p4]), %%xmm"#y"	;\n"
-#define XO4(x, y)	"       xorps   "OFFS(x)"(%[p5]), %%xmm"#y"	;\n"
-#define XO5(x, y)	"       xorps   "OFFS(x)"(%[p6]), %%xmm"#y"	;\n"
-
-
-static void
-xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
-{
-	unsigned int lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-		PF1(i)					\
-				PF1(i + 2)		\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addq %[inc], %[p1]           ;\n"
-	"       addq %[inc], %[p2]           ;\n"
-		"		decl %[cnt] ; jnz 1b"
-	: [p1] "+r" (p1), [p2] "+r" (p2), [cnt] "+r" (lines)
-	: [inc] "r" (256UL)
-	: "memory");
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3)
-{
-	unsigned int lines = bytes >> 8;
-
-	kernel_fpu_begin();
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i, 0)					\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		XO2(i, 0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addq %[inc], %[p1]           ;\n"
-	"       addq %[inc], %[p2]          ;\n"
-	"       addq %[inc], %[p3]           ;\n"
-		"		decl %[cnt] ; jnz 1b"
-	: [cnt] "+r" (lines),
-	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
-	: [inc] "r" (256UL)
-	: "memory");
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3, unsigned long *p4)
-{
-	unsigned int lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		PF3(i)					\
-				PF3(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO2(i, 0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		XO3(i, 0)				\
-			XO3(i + 1, 1)			\
-				XO3(i + 2, 2)		\
-					XO3(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addq %[inc], %[p1]           ;\n"
-	"       addq %[inc], %[p2]           ;\n"
-	"       addq %[inc], %[p3]           ;\n"
-	"       addq %[inc], %[p4]           ;\n"
-	"	decl %[cnt] ; jnz 1b"
-	: [cnt] "+c" (lines),
-	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4)
-	: [inc] "r" (256UL)
-	: "memory" );
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
-{
-	unsigned int lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		PF3(i)					\
-				PF3(i + 2)		\
-		XO2(i, 0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		PF4(i)					\
-				PF4(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO3(i, 0)				\
-			XO3(i + 1, 1)			\
-				XO3(i + 2, 2)		\
-					XO3(i + 3, 3)	\
-		XO4(i, 0)				\
-			XO4(i + 1, 1)			\
-				XO4(i + 2, 2)		\
-					XO4(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addq %[inc], %[p1]           ;\n"
-	"       addq %[inc], %[p2]           ;\n"
-	"       addq %[inc], %[p3]           ;\n"
-	"       addq %[inc], %[p4]           ;\n"
-	"       addq %[inc], %[p5]           ;\n"
-	"	decl %[cnt] ; jnz 1b"
-	: [cnt] "+c" (lines),
-	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4),
-	  [p5] "+r" (p5)
-	: [inc] "r" (256UL)
-	: "memory");
-
-	kernel_fpu_end();
-}
-
 static struct xor_block_template xor_block_sse = {
 	.name = "generic_sse",
 	.do_2 = xor_sse_2,
@@ -308,17 +13,15 @@ static struct xor_block_template xor_block_sse = {
 /* Also try the AVX routines */
 #include <asm/xor_avx.h>
 
+/* We force the use of the SSE xor block because it can write around L2.
+   We may also be able to load into the L1 only depending on how the cpu
+   deals with a load to a line that is being prefetched.  */
 #undef XOR_TRY_TEMPLATES
 #define XOR_TRY_TEMPLATES			\
 do {						\
 	AVX_XOR_SPEED;				\
+	xor_speed(&xor_block_sse_pf64);		\
 	xor_speed(&xor_block_sse);		\
 } while (0)
 
-/* We force the use of the SSE xor block because it can write around L2.
-   We may also be able to load into the L1 only depending on how the cpu
-   deals with a load to a line that is being prefetched.  */
-#define XOR_SELECT_TEMPLATE(FASTEST) \
-	AVX_SELECT(&xor_block_sse)
-
 #endif /* _ASM_X86_XOR_64_H */
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index c8932c7..3c3f58a 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -307,36 +307,45 @@ default_entry:
 	movl %eax,%cr0
 
 /*
- *	New page tables may be in 4Mbyte page mode and may
- *	be using the global pages. 
+ * We want to start out with EFLAGS unambiguously cleared. Some BIOSes leave
+ * bits like NT set. This would confuse the debugger if this code is traced. So
+ * initialize them properly now before switching to protected mode. That means
+ * DF in particular (even though we have cleared it earlier after copying the
+ * command line) because GCC expects it.
+ */
+	pushl $0
+	popfl
+
+/*
+ * New page tables may be in 4Mbyte page mode and may be using the global pages.
  *
- *	NOTE! If we are on a 486 we may have no cr4 at all!
- *	Specifically, cr4 exists if and only if CPUID exists
- *	and has flags other than the FPU flag set.
+ * NOTE! If we are on a 486 we may have no cr4 at all! Specifically, cr4 exists
+ * if and only if CPUID exists and has flags other than the FPU flag set.
  */
+	movl $-1,pa(X86_CPUID)		# preset CPUID level
 	movl $X86_EFLAGS_ID,%ecx
 	pushl %ecx
-	popfl
+	popfl				# set EFLAGS=ID
 	pushfl
-	popl %eax
-	pushl $0
-	popfl
-	pushfl
-	popl %edx
-	xorl %edx,%eax
-	testl %ecx,%eax
-	jz 6f			# No ID flag = no CPUID = no CR4
+	popl %eax			# get EFLAGS
+	testl $X86_EFLAGS_ID,%eax	# did EFLAGS.ID remained set?
+	jz enable_paging		# hw disallowed setting of ID bit
+					# which means no CPUID and no CR4
+
+	xorl %eax,%eax
+	cpuid
+	movl %eax,pa(X86_CPUID)		# save largest std CPUID function
 
 	movl $1,%eax
 	cpuid
-	andl $~1,%edx		# Ignore CPUID.FPU
-	jz 6f			# No flags or only CPUID.FPU = no CR4
+	andl $~1,%edx			# Ignore CPUID.FPU
+	jz enable_paging		# No flags or only CPUID.FPU = no CR4
 
 	movl pa(mmu_cr4_features),%eax
 	movl %eax,%cr4
 
 	testb $X86_CR4_PAE, %al		# check if PAE is enabled
-	jz 6f
+	jz enable_paging
 
 	/* Check if extended functions are implemented */
 	movl $0x80000000, %eax
@@ -344,7 +353,7 @@ default_entry:
 	/* Value must be in the range 0x80000001 to 0x8000ffff */
 	subl $0x80000001, %eax
 	cmpl $(0x8000ffff-0x80000001), %eax
-	ja 6f
+	ja enable_paging
 
 	/* Clear bogus XD_DISABLE bits */
 	call verify_cpu
@@ -353,7 +362,7 @@ default_entry:
 	cpuid
 	/* Execute Disable bit supported? */
 	btl $(X86_FEATURE_NX & 31), %edx
-	jnc 6f
+	jnc enable_paging
 
 	/* Setup EFER (Extended Feature Enable Register) */
 	movl $MSR_EFER, %ecx
@@ -363,7 +372,7 @@ default_entry:
 	/* Make changes effective */
 	wrmsr
 
-6:
+enable_paging:
 
 /*
  * Enable paging
@@ -378,14 +387,6 @@ default_entry:
 	addl $__PAGE_OFFSET, %esp
 
 /*
- * Initialize eflags.  Some BIOS's leave bits like NT set.  This would
- * confuse the debugger if this code is traced.
- * XXX - best to initialize before switching to protected mode.
- */
-	pushl $0
-	popfl
-
-/*
  * start system 32-bit setup. We need to re-do some of the things done
  * in 16-bit mode for the "real" operations.
  */
@@ -394,31 +395,11 @@ default_entry:
 	jz 1f				# Did we do this already?
 	call *%eax
 1:
-	
-/* check if it is 486 or 386. */
+
 /*
- * XXX - this does a lot of unnecessary setup.  Alignment checks don't
- * apply at our cpl of 0 and the stack ought to be aligned already, and
- * we don't need to preserve eflags.
+ * Check if it is 486
  */
-	movl $-1,X86_CPUID	# -1 for no CPUID initially
-	movb $3,X86		# at least 386
-	pushfl			# push EFLAGS
-	popl %eax		# get EFLAGS
-	movl %eax,%ecx		# save original EFLAGS
-	xorl $0x240000,%eax	# flip AC and ID bits in EFLAGS
-	pushl %eax		# copy to EFLAGS
-	popfl			# set EFLAGS
-	pushfl			# get new EFLAGS
-	popl %eax		# put it in eax
-	xorl %ecx,%eax		# change in flags
-	pushl %ecx		# restore original EFLAGS
-	popfl
-	testl $0x40000,%eax	# check if AC bit changed
-	je is386
-
-	movb $4,X86		# at least 486
-	testl $0x200000,%eax	# check if ID bit changed
+	cmpl $-1,X86_CPUID
 	je is486
 
 	/* get vendor info */
@@ -444,11 +425,10 @@ default_entry:
 	movb %cl,X86_MASK
 	movl %edx,X86_CAPABILITY
 
-is486:	movl $0x50022,%ecx	# set AM, WP, NE and MP
-	jmp 2f
-
-is386:	movl $2,%ecx		# set MP
-2:	movl %cr0,%eax
+is486:
+	movb $4,X86
+	movl $0x50022,%ecx	# set AM, WP, NE and MP
+	movl %cr0,%eax
 	andl $0x80000011,%eax	# Save PG,PE,ET
 	orl %ecx,%eax
 	movl %eax,%cr0
@@ -473,7 +453,6 @@ is386:	movl $2,%ecx		# set MP
 	xorl %eax,%eax			# Clear LDT
 	lldt %ax
 
-	cld			# gcc2 wants the direction flag cleared at all times
 	pushl $0		# fake return address for unwinder
 	jmp *(initial_code)
 
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 97ef74b..dbded5a 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -157,7 +157,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	if (flags & MAP_FIXED)
 		return addr;
 
-	/* for MAP_32BIT mappings we force the legact mmap base */
+	/* for MAP_32BIT mappings we force the legacy mmap base */
 	if (!test_thread_flag(TIF_ADDR32) && (flags & MAP_32BIT))
 		goto bottomup;
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 2ead3c8..e779e0b 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -605,7 +605,7 @@ kernel_physical_mapping_init(unsigned long start,
 	}
 
 	if (pgd_changed)
-		sync_global_pgds(addr, end);
+		sync_global_pgds(addr, end - 1);
 
 	__flush_tlb_all();
 
@@ -981,7 +981,7 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
 		}
 
 	}
-	sync_global_pgds((unsigned long)start_page, end);
+	sync_global_pgds((unsigned long)start_page, end - 1);
 	return 0;
 }
 
