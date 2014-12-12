Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965794AbaLLTMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:12:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:23464 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965607AbaLLTMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:12:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,565,1413270000"; 
   d="scan'208";a="646793505"
Subject: [RFC][PATCH 1/8] x86: make is_64bit_mm() widely available
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com, oleg@redhat.com
From: Dave Hansen <dave@sr71.net>
Date: Fri, 12 Dec 2014 11:12:14 -0800
References: <20141212191213.579887D2@viggo.jf.intel.com>
In-Reply-To: <20141212191213.579887D2@viggo.jf.intel.com>
Message-Id: <20141212191214.E767D364@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The uprobes code has a nice helper, is_64bit_mm(), that consults both
the runtime and compile-time flags for 32-bit support.  Instead of
reinventing the wheel, pull it in to an x86 header so we can use it
for MPX.

I prefer passing the mm around to test_thread_flag(TIF_IA32) beacuse
it makes it explicit where the context is coming from.  It will also
make it easier if we ever need to access the MPX structures from
another process.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---

 b/arch/x86/include/asm/mmu_context.h |   13 +++++++++++++
 b/arch/x86/kernel/uprobes.c          |   10 +---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff -puN arch/x86/include/asm/mmu_context.h~x86-make-is_64bit_mm-available arch/x86/include/asm/mmu_context.h
--- a/arch/x86/include/asm/mmu_context.h~x86-make-is_64bit_mm-available	2014-12-12 11:11:39.086947548 -0800
+++ b/arch/x86/include/asm/mmu_context.h	2014-12-12 11:11:39.091947773 -0800
@@ -121,6 +121,19 @@ static inline void arch_exit_mmap(struct
 	paravirt_arch_exit_mmap(mm);
 }
 
+#ifdef CONFIG_X86_64
+static inline bool is_64bit_mm(struct mm_struct *mm)
+{
+	return	!config_enabled(CONFIG_IA32_EMULATION) ||
+		!(mm->context.ia32_compat == TIF_IA32);
+}
+#else
+static inline bool is_64bit_mm(struct mm_struct *mm)
+{
+	return false;
+}
+#endif
+
 static inline void arch_bprm_mm_init(struct mm_struct *mm,
 		struct vm_area_struct *vma)
 {
diff -puN arch/x86/kernel/uprobes.c~x86-make-is_64bit_mm-available arch/x86/kernel/uprobes.c
--- a/arch/x86/kernel/uprobes.c~x86-make-is_64bit_mm-available	2014-12-12 11:11:39.087947593 -0800
+++ b/arch/x86/kernel/uprobes.c	2014-12-12 11:11:39.091947773 -0800
@@ -29,6 +29,7 @@
 #include <linux/kdebug.h>
 #include <asm/processor.h>
 #include <asm/insn.h>
+#include <asm/mmu_context.h>
 
 /* Post-execution fixups. */
 
@@ -245,11 +246,6 @@ static int uprobe_init_insn(struct arch_
 }
 
 #ifdef CONFIG_X86_64
-static inline bool is_64bit_mm(struct mm_struct *mm)
-{
-	return	!config_enabled(CONFIG_IA32_EMULATION) ||
-		!(mm->context.ia32_compat == TIF_IA32);
-}
 /*
  * If arch_uprobe->insn doesn't use rip-relative addressing, return
  * immediately.  Otherwise, rewrite the instruction so that it accesses
@@ -430,10 +426,6 @@ static void riprel_post_xol(struct arch_
 	}
 }
 #else /* 32-bit: */
-static inline bool is_64bit_mm(struct mm_struct *mm)
-{
-	return false;
-}
 /*
  * No RIP-relative addressing on 32-bit
  */
_
