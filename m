Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbaKSK6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:58:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35712 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbaKSK6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:58:13 -0500
Date: Wed, 19 Nov 2014 02:58:02 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-62e88b1c00de9cb30d937841ed5debed871070b8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, dave@sr71.net, hpa@zytor.com,
        dave.hansen@linux.intel.com, tglx@linutronix.de, mingo@kernel.org
Reply-To: dave.hansen@linux.intel.com, tglx@linutronix.de, mingo@kernel.org,
        linux-kernel@vger.kernel.org, dave@sr71.net, hpa@zytor.com
In-Reply-To: <20141118182350.8B4AA2C2@viggo.jf.intel.com>
References: <20141118182350.8B4AA2C2@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] mm: Make arch_unmap()/bprm_mm_init()
  available to all architectures
Git-Commit-ID: 62e88b1c00de9cb30d937841ed5debed871070b8
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

Commit-ID:  62e88b1c00de9cb30d937841ed5debed871070b8
Gitweb:     http://git.kernel.org/tip/62e88b1c00de9cb30d937841ed5debed871070b8
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Tue, 18 Nov 2014 10:23:50 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Nov 2014 11:54:13 +0100

mm: Make arch_unmap()/bprm_mm_init() available to all architectures

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

xtensa only includes mm_hooks when MMU=y, which should be fine
since arch_unmap() is called only from MMU=y code.

For the rest, we use the stub copies of these functions in
asm-generic/mm_hook.h.

I cross compiled defconfigs for cris (to check NOMMU) and s390
to make sure that this works.  I also checked a 64-bit build
of UML and all my normal x86 builds including PARAVIRT on and
off.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20141118182350.8B4AA2C2@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/s390/include/asm/mmu_context.h      | 11 +++++++++++
 arch/um/include/asm/mmu_context.h        | 24 +++++++++++++++++++-----
 arch/unicore32/include/asm/mmu_context.h | 11 +++++++++++
 include/asm-generic/mm_hooks.h           | 17 ++++++++++++++---
 include/asm-generic/mmu_context.h        |  6 ------
 5 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index 3815bfe..f49b719 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -120,4 +120,15 @@ static inline void arch_exit_mmap(struct mm_struct *mm)
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
diff --git a/arch/um/include/asm/mmu_context.h b/arch/um/include/asm/mmu_context.h
index aa4a743..941527e 100644
--- a/arch/um/include/asm/mmu_context.h
+++ b/arch/um/include/asm/mmu_context.h
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
 
@@ -41,11 +60,6 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
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
diff --git a/arch/unicore32/include/asm/mmu_context.h b/arch/unicore32/include/asm/mmu_context.h
index ef470a7..1cb5220 100644
--- a/arch/unicore32/include/asm/mmu_context.h
+++ b/arch/unicore32/include/asm/mmu_context.h
@@ -86,4 +86,15 @@ static inline void arch_dup_mmap(struct mm_struct *oldmm,
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
diff --git a/include/asm-generic/mm_hooks.h b/include/asm-generic/mm_hooks.h
index 67dea81..866aa46 100644
--- a/include/asm-generic/mm_hooks.h
+++ b/include/asm-generic/mm_hooks.h
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
@@ -15,4 +15,15 @@ static inline void arch_exit_mmap(struct mm_struct *mm)
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
diff --git a/include/asm-generic/mmu_context.h b/include/asm-generic/mmu_context.h
index aa2d8ba..1f2a8f9 100644
--- a/include/asm-generic/mmu_context.h
+++ b/include/asm-generic/mmu_context.h
@@ -47,10 +47,4 @@ static inline void arch_bprm_mm_init(struct mm_struct *mm,
 {
 }
 
-static inline void arch_unmap(struct mm_struct *mm,
-			struct vm_area_struct *vma,
-			unsigned long start, unsigned long end)
-{
-}
-
 #endif /* __ASM_GENERIC_MMU_CONTEXT_H */
