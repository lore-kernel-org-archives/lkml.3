Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaKRSXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:23:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:29964 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbaKRSXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:23:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,411,1413270000"; 
   d="scan'208";a="609932790"
Subject: [PATCH 3/3] make arch_unmap()/etc... available to all architectures.
To: tglx@linutronix.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com, linux-arch@vger.kernel.org
From: Dave Hansen <dave@sr71.net>
Date: Tue, 18 Nov 2014 10:23:50 -0800
References: <20141118182342.64D1B3A5@viggo.jf.intel.com>
In-Reply-To: <20141118182342.64D1B3A5@viggo.jf.intel.com>
Message-Id: <20141118182350.8B4AA2C2@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The x86 MPX patch set calls arch_unmap() and arch_bprm_mm_init()
from fs/exec.c, so we need at least a stub for them in all
architectures.  They are only called under an #ifdef for
CONFIG_MMU=y, so we can at least restict this to architectures
with MMU support.

blackfin/c6x have no MMU support, so do not call arch_unmap().
They also do not include mm_hooks.h or mmu_context.h at all and
do not need to be touched.

s390, um and unicore32 do not use asm-generic/mm_hooks.h, so got
their own arch_unmap() versions.  (I also moved um's
arch_dup_mmap() to be closer to the other mm_hooks.h functions).

xtensa only includs mm_hooks when MMU=y, which should be fine
since arch_unmap() is called only from MMU=y code.

For the rest, we use the stub copies of these functions in
asm-generic/mm_hook.h.

I cross compiled defconfigs for cris (to check NOMMU) and s390
to make sure that this works.  I also checked a 64-bit build
of UML and all my normal x86 builds including PARAVIRT on and
off.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
---

 b/arch/s390/include/asm/mmu_context.h      |   11 +++++++++++
 b/arch/um/include/asm/mmu_context.h        |   24 +++++++++++++++++++-----
 b/arch/unicore32/include/asm/mmu_context.h |   11 +++++++++++
 b/include/asm-generic/mm_hooks.h           |   17 ++++++++++++++---
 b/include/asm-generic/mmu_context.h        |    6 ------
 5 files changed, 55 insertions(+), 14 deletions(-)

diff -puN arch/s390/include/asm/mmu_context.h~mm_hooks arch/s390/include/asm/mmu_context.h
--- a/arch/s390/include/asm/mmu_context.h~mm_hooks	2014-11-18 09:14:19.914111506 -0800
+++ b/arch/s390/include/asm/mmu_context.h	2014-11-18 09:14:19.924111957 -0800
@@ -120,4 +120,15 @@ static inline void arch_exit_mmap(struct
 {
 }
 
+static inline void arch_unmap(struct mm_struct *mm,
+			struct vm_area_struct *vma,
+			unsigned long start, unsigned long end)
+{
+}
+
+static inline void arch_bprm_mm_init(struct mm_struct *mm,
+				     struct vm_area_struct *vma)
+{
+}
+
 #endif /* __S390_MMU_CONTEXT_H */
diff -puN arch/um/include/asm/mmu_context.h~mm_hooks arch/um/include/asm/mmu_context.h
--- a/arch/um/include/asm/mmu_context.h~mm_hooks	2014-11-18 09:14:19.916111596 -0800
+++ b/arch/um/include/asm/mmu_context.h	2014-11-18 09:14:19.924111957 -0800
@@ -10,7 +10,26 @@
 #include <asm/mmu.h>
 
 extern void uml_setup_stubs(struct mm_struct *mm);
+/*
+ * Needed since we do not use the asm-generic/mm_hooks.h:
+ */
+static inline void arch_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
+{
+	uml_setup_stubs(mm);
+}
 extern void arch_exit_mmap(struct mm_struct *mm);
+static inline void arch_unmap(struct mm_struct *mm,
+			struct vm_area_struct *vma,
+			unsigned long start, unsigned long end)
+{
+}
+static inline void arch_bprm_mm_init(struct mm_struct *mm,
+				     struct vm_area_struct *vma)
+{
+}
+/*
+ * end asm-generic/mm_hooks.h functions
+ */
 
 #define deactivate_mm(tsk,mm)	do { } while (0)
 
@@ -41,11 +60,6 @@ static inline void switch_mm(struct mm_s
 	}
 }
 
-static inline void arch_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
-{
-	uml_setup_stubs(mm);
-}
-
 static inline void enter_lazy_tlb(struct mm_struct *mm, 
 				  struct task_struct *tsk)
 {
diff -puN arch/unicore32/include/asm/mmu_context.h~mm_hooks arch/unicore32/include/asm/mmu_context.h
--- a/arch/unicore32/include/asm/mmu_context.h~mm_hooks	2014-11-18 09:14:19.918111686 -0800
+++ b/arch/unicore32/include/asm/mmu_context.h	2014-11-18 09:14:19.924111957 -0800
@@ -86,4 +86,15 @@ static inline void arch_dup_mmap(struct
 {
 }
 
+static inline void arch_unmap(struct mm_struct *mm,
+			struct vm_area_struct *vma,
+			unsigned long start, unsigned long end)
+{
+}
+
+static inline void arch_bprm_mm_init(struct mm_struct *mm,
+				     struct vm_area_struct *vma)
+{
+}
+
 #endif
diff -puN include/asm-generic/mm_hooks.h~mm_hooks include/asm-generic/mm_hooks.h
--- a/include/asm-generic/mm_hooks.h~mm_hooks	2014-11-18 09:14:19.919111732 -0800
+++ b/include/asm-generic/mm_hooks.h	2014-11-18 09:14:19.925112002 -0800
@@ -1,7 +1,7 @@
 /*
- * Define generic no-op hooks for arch_dup_mmap and arch_exit_mmap, to
- * be included in asm-FOO/mmu_context.h for any arch FOO which doesn't
- * need to hook these.
+ * Define generic no-op hooks for arch_dup_mmap, arch_exit_mmap
+ * and arch_unmap to be included in asm-FOO/mmu_context.h for any
+ * arch FOO which doesn't need to hook these.
  */
 #ifndef _ASM_GENERIC_MM_HOOKS_H
 #define _ASM_GENERIC_MM_HOOKS_H
@@ -15,4 +15,15 @@ static inline void arch_exit_mmap(struct
 {
 }
 
+static inline void arch_unmap(struct mm_struct *mm,
+			struct vm_area_struct *vma,
+			unsigned long start, unsigned long end)
+{
+}
+
+static inline void arch_bprm_mm_init(struct mm_struct *mm,
+				     struct vm_area_struct *vma)
+{
+}
+
 #endif	/* _ASM_GENERIC_MM_HOOKS_H */
diff -puN include/asm-generic/mmu_context.h~mm_hooks include/asm-generic/mmu_context.h
--- a/include/asm-generic/mmu_context.h~mm_hooks	2014-11-18 09:14:19.921111822 -0800
+++ b/include/asm-generic/mmu_context.h	2014-11-18 09:14:19.925112002 -0800
@@ -47,10 +47,4 @@ static inline void arch_bprm_mm_init(str
 {
 }
 
-static inline void arch_unmap(struct mm_struct *mm,
-			struct vm_area_struct *vma,
-			unsigned long start, unsigned long end)
-{
-}
-
 #endif /* __ASM_GENERIC_MMU_CONTEXT_H */
_
