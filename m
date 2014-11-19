Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbaKSK6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:58:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35705 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaKSK56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:57:58 -0500
Date: Wed, 19 Nov 2014 02:57:47 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-a1ea1c032b8f8c23d86ef4db6d061527e9417f19@git.kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        dave@sr71.net, mingo@kernel.org, tglx@linutronix.de
Reply-To: hpa@zytor.com, dave.hansen@linux.intel.com,
        linux-kernel@vger.kernel.org, dave@sr71.net, tglx@linutronix.de,
        mingo@kernel.org
In-Reply-To: <20141118182349.14567FA5@viggo.jf.intel.com>
References: <20141118182349.14567FA5@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] x86: Cleanly separate use of asm-generic/mm_hooks.h
Git-Commit-ID: a1ea1c032b8f8c23d86ef4db6d061527e9417f19
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

Commit-ID:  a1ea1c032b8f8c23d86ef4db6d061527e9417f19
Gitweb:     http://git.kernel.org/tip/a1ea1c032b8f8c23d86ef4db6d061527e9417f19
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Tue, 18 Nov 2014 10:23:49 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Nov 2014 11:54:13 +0100

x86: Cleanly separate use of asm-generic/mm_hooks.h

asm-generic/mm_hooks.h provides some generic fillers for the 90%
of architectures that do not need to hook some mmap-manipulation
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
Cc: Dave Hansen <dave@sr71.net>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20141118182349.14567FA5@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/mmu_context.h | 13 +++++++++++--
 arch/x86/include/asm/paravirt.h    | 16 +++++++++++++---
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 00d4575..be91d57 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
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
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index cd6e161..32444ae 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -330,13 +330,13 @@ static inline void paravirt_activate_mm(struct mm_struct *prev,
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
