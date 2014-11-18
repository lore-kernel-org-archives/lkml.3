Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaKRSYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:24:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:33655 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbaKRSX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:23:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="418259588"
Subject: [PATCH 2/3] x86: cleanly separate use of asm-generic/mm_hooks.h
To: tglx@linutronix.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Tue, 18 Nov 2014 10:23:49 -0800
References: <20141118182342.64D1B3A5@viggo.jf.intel.com>
In-Reply-To: <20141118182342.64D1B3A5@viggo.jf.intel.com>
Message-Id: <20141118182349.14567FA5@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

asm-generic/mm_hooks.h provides some generic fillers for the 90%
of architectures that do not need to hook some mmap-mainipulation
functions.  A comment inside says:

> Define generic no-op hooks for arch_dup_mmap and
> arch_exit_mmap, to be included in asm-FOO/mmu_context.h
> for any arch FOO which doesn't need to hook these.

So, does x86 need to hook these?  It depends on CONFIG_PARAVIRT.
We *conditionally* include this generic header if we have
CONFIG_PARAVIRT=n.  That's madness.

With this patch, x86 stops using asm-generic/mmu_hooks.h entirely.
We use our own copies of the functions.  The paravirt code
provides some stubs if it is disabled, and we always call those
stubs in our x86-private versions of arch_exit_mmap() and
arch_dup_mmap().

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
---

 b/arch/x86/include/asm/mmu_context.h |   13 +++++++++++--
 b/arch/x86/include/asm/paravirt.h    |   16 +++++++++++++---
 2 files changed, 24 insertions(+), 5 deletions(-)

diff -puN arch/x86/include/asm/mmu_context.h~dmess-x86-mmu_hooks arch/x86/include/asm/mmu_context.h
--- a/arch/x86/include/asm/mmu_context.h~dmess-x86-mmu_hooks	2014-11-18 09:14:18.998070191 -0800
+++ b/arch/x86/include/asm/mmu_context.h	2014-11-18 09:14:19.002070371 -0800
@@ -12,8 +12,6 @@
 #include <asm/paravirt.h>
 #include <asm/mpx.h>
 #ifndef CONFIG_PARAVIRT
-#include <asm-generic/mm_hooks.h>
-
 static inline void paravirt_activate_mm(struct mm_struct *prev,
 					struct mm_struct *next)
 {
@@ -103,6 +101,17 @@ do {						\
 } while (0)
 #endif
 
+static inline void arch_dup_mmap(struct mm_struct *oldmm,
+				 struct mm_struct *mm)
+{
+	paravirt_arch_dup_mmap(oldmm, mm);
+}
+
+static inline void arch_exit_mmap(struct mm_struct *mm)
+{
+	paravirt_arch_exit_mmap(mm);
+}
+
 static inline void arch_bprm_mm_init(struct mm_struct *mm,
 		struct vm_area_struct *vma)
 {
diff -puN arch/x86/include/asm/paravirt.h~dmess-x86-mmu_hooks arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h~dmess-x86-mmu_hooks	2014-11-18 09:14:18.999070236 -0800
+++ b/arch/x86/include/asm/paravirt.h	2014-11-18 09:14:19.003070416 -0800
@@ -330,13 +330,13 @@ static inline void paravirt_activate_mm(
 	PVOP_VCALL2(pv_mmu_ops.activate_mm, prev, next);
 }
 
-static inline void arch_dup_mmap(struct mm_struct *oldmm,
-				 struct mm_struct *mm)
+static inline void paravirt_arch_dup_mmap(struct mm_struct *oldmm,
+					  struct mm_struct *mm)
 {
 	PVOP_VCALL2(pv_mmu_ops.dup_mmap, oldmm, mm);
 }
 
-static inline void arch_exit_mmap(struct mm_struct *mm)
+static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
 {
 	PVOP_VCALL1(pv_mmu_ops.exit_mmap, mm);
 }
@@ -986,5 +986,15 @@ extern void default_banner(void);
 #endif /* __ASSEMBLY__ */
 #else  /* CONFIG_PARAVIRT */
 # define default_banner x86_init_noop
+#ifndef __ASSEMBLY__
+static inline void paravirt_arch_dup_mmap(struct mm_struct *oldmm,
+					  struct mm_struct *mm)
+{
+}
+
+static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
+{
+}
+#endif /* __ASSEMBLY__ */
 #endif /* !CONFIG_PARAVIRT */
 #endif /* _ASM_X86_PARAVIRT_H */
_
