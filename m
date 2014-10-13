Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaJMHc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:32:28 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51631 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaJMHc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:32:27 -0400
Date: Mon, 13 Oct 2014 09:32:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpufeature tree changes for v3.18
Message-ID: <20141013073222.GA14581@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpufeature-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpufeature-for-linus

   # HEAD: 9298b815efe500b272e4084ed05eeae7a92b5340 x86: Add more disabled features

This tree includes the following changes:

 - Introduce DISABLED_MASK to list disabled CPU features, to
   simplify CPU feature handling and avoid excessive #ifdefs

 - Remove the lightly used cpu_has_pae() primitive

 Thanks,

	Ingo

------------------>
Dave Hansen (3):
      x86: Axe the lightly-used cpu_has_pae
      x86: Introduce disabled-features
      x86: Add more disabled features


 arch/x86/boot/mkcpustr.c                 |  1 +
 arch/x86/include/asm/cpufeature.h        | 52 +++++++++++++++++---------------
 arch/x86/include/asm/disabled-features.h | 39 ++++++++++++++++++++++++
 arch/x86/kernel/cpu/common.c             |  2 +-
 arch/x86/kernel/cpu/mtrr/main.c          |  6 ++--
 arch/x86/kernel/machine_kexec_32.c       |  3 +-
 6 files changed, 74 insertions(+), 29 deletions(-)
 create mode 100644 arch/x86/include/asm/disabled-features.h

diff --git a/arch/x86/boot/mkcpustr.c b/arch/x86/boot/mkcpustr.c
index 4579eff0ef4d..637097e66a62 100644
--- a/arch/x86/boot/mkcpustr.c
+++ b/arch/x86/boot/mkcpustr.c
@@ -16,6 +16,7 @@
 #include <stdio.h>
 
 #include "../include/asm/required-features.h"
+#include "../include/asm/disabled-features.h"
 #include "../include/asm/cpufeature.h"
 #include "../kernel/cpu/capflags.c"
 
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb9b258d60e7..42db503b61fb 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -8,6 +8,10 @@
 #include <asm/required-features.h>
 #endif
 
+#ifndef _ASM_X86_DISABLED_FEATURES_H
+#include <asm/disabled-features.h>
+#endif
+
 #define NCAPINTS	11	/* N 32-bit words worth of info */
 #define NBUGINTS	1	/* N 32-bit bug flags */
 
@@ -274,6 +278,18 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 	   (((bit)>>5)==8 && (1UL<<((bit)&31) & REQUIRED_MASK8)) ||	\
 	   (((bit)>>5)==9 && (1UL<<((bit)&31) & REQUIRED_MASK9)) )
 
+#define DISABLED_MASK_BIT_SET(bit)					\
+	 ( (((bit)>>5)==0 && (1UL<<((bit)&31) & DISABLED_MASK0)) ||	\
+	   (((bit)>>5)==1 && (1UL<<((bit)&31) & DISABLED_MASK1)) ||	\
+	   (((bit)>>5)==2 && (1UL<<((bit)&31) & DISABLED_MASK2)) ||	\
+	   (((bit)>>5)==3 && (1UL<<((bit)&31) & DISABLED_MASK3)) ||	\
+	   (((bit)>>5)==4 && (1UL<<((bit)&31) & DISABLED_MASK4)) ||	\
+	   (((bit)>>5)==5 && (1UL<<((bit)&31) & DISABLED_MASK5)) ||	\
+	   (((bit)>>5)==6 && (1UL<<((bit)&31) & DISABLED_MASK6)) ||	\
+	   (((bit)>>5)==7 && (1UL<<((bit)&31) & DISABLED_MASK7)) ||	\
+	   (((bit)>>5)==8 && (1UL<<((bit)&31) & DISABLED_MASK8)) ||	\
+	   (((bit)>>5)==9 && (1UL<<((bit)&31) & DISABLED_MASK9)) )
+
 #define cpu_has(c, bit)							\
 	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
 	 test_cpu_cap(c, bit))
@@ -282,6 +298,18 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 : 	\
 	 x86_this_cpu_test_bit(bit, (unsigned long *)&cpu_info.x86_capability))
 
+/*
+ * This macro is for detection of features which need kernel
+ * infrastructure to be used.  It may *not* directly test the CPU
+ * itself.  Use the cpu_has() family if you want true runtime
+ * testing of CPU features, like in hypervisor code where you are
+ * supporting a possible guest feature where host support for it
+ * is not relevant.
+ */
+#define cpu_feature_enabled(bit)	\
+	(__builtin_constant_p(bit) && DISABLED_MASK_BIT_SET(bit) ? 0 :	\
+	 cpu_has(&boot_cpu_data, bit))
+
 #define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)
 
 #define set_cpu_cap(c, bit)	set_bit(bit, (unsigned long *)((c)->x86_capability))
@@ -296,11 +324,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 } while (0)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
-#define cpu_has_vme		boot_cpu_has(X86_FEATURE_VME)
 #define cpu_has_de		boot_cpu_has(X86_FEATURE_DE)
 #define cpu_has_pse		boot_cpu_has(X86_FEATURE_PSE)
 #define cpu_has_tsc		boot_cpu_has(X86_FEATURE_TSC)
-#define cpu_has_pae		boot_cpu_has(X86_FEATURE_PAE)
 #define cpu_has_pge		boot_cpu_has(X86_FEATURE_PGE)
 #define cpu_has_apic		boot_cpu_has(X86_FEATURE_APIC)
 #define cpu_has_sep		boot_cpu_has(X86_FEATURE_SEP)
@@ -316,9 +342,6 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 #define cpu_has_avx2		boot_cpu_has(X86_FEATURE_AVX2)
 #define cpu_has_ht		boot_cpu_has(X86_FEATURE_HT)
 #define cpu_has_nx		boot_cpu_has(X86_FEATURE_NX)
-#define cpu_has_k6_mtrr		boot_cpu_has(X86_FEATURE_K6_MTRR)
-#define cpu_has_cyrix_arr	boot_cpu_has(X86_FEATURE_CYRIX_ARR)
-#define cpu_has_centaur_mcr	boot_cpu_has(X86_FEATURE_CENTAUR_MCR)
 #define cpu_has_xstore		boot_cpu_has(X86_FEATURE_XSTORE)
 #define cpu_has_xstore_enabled	boot_cpu_has(X86_FEATURE_XSTORE_EN)
 #define cpu_has_xcrypt		boot_cpu_has(X86_FEATURE_XCRYPT)
@@ -353,25 +376,6 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
 #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
 
-#ifdef CONFIG_X86_64
-
-#undef  cpu_has_vme
-#define cpu_has_vme		0
-
-#undef  cpu_has_pae
-#define cpu_has_pae		___BUG___
-
-#undef  cpu_has_k6_mtrr
-#define cpu_has_k6_mtrr		0
-
-#undef  cpu_has_cyrix_arr
-#define cpu_has_cyrix_arr	0
-
-#undef  cpu_has_centaur_mcr
-#define cpu_has_centaur_mcr	0
-
-#endif /* CONFIG_X86_64 */
-
 #if __GNUC__ >= 4
 extern void warn_pre_alternatives(void);
 extern bool __static_cpu_has_safe(u16 bit);
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
new file mode 100644
index 000000000000..97534a7d38e3
--- /dev/null
+++ b/arch/x86/include/asm/disabled-features.h
@@ -0,0 +1,39 @@
+#ifndef _ASM_X86_DISABLED_FEATURES_H
+#define _ASM_X86_DISABLED_FEATURES_H
+
+/* These features, although they might be available in a CPU
+ * will not be used because the compile options to support
+ * them are not present.
+ *
+ * This code allows them to be checked and disabled at
+ * compile time without an explicit #ifdef.  Use
+ * cpu_feature_enabled().
+ */
+
+#ifdef CONFIG_X86_64
+# define DISABLE_VME		(1<<(X86_FEATURE_VME & 31))
+# define DISABLE_K6_MTRR	(1<<(X86_FEATURE_K6_MTRR & 31))
+# define DISABLE_CYRIX_ARR	(1<<(X86_FEATURE_CYRIX_ARR & 31))
+# define DISABLE_CENTAUR_MCR	(1<<(X86_FEATURE_CENTAUR_MCR & 31))
+#else
+# define DISABLE_VME		0
+# define DISABLE_K6_MTRR	0
+# define DISABLE_CYRIX_ARR	0
+# define DISABLE_CENTAUR_MCR	0
+#endif /* CONFIG_X86_64 */
+
+/*
+ * Make sure to add features to the correct mask
+ */
+#define DISABLED_MASK0	(DISABLE_VME)
+#define DISABLED_MASK1	0
+#define DISABLED_MASK2	0
+#define DISABLED_MASK3	(DISABLE_CYRIX_ARR|DISABLE_CENTAUR_MCR|DISABLE_K6_MTRR)
+#define DISABLED_MASK4	0
+#define DISABLED_MASK5	0
+#define DISABLED_MASK6	0
+#define DISABLED_MASK7	0
+#define DISABLED_MASK8	0
+#define DISABLED_MASK9	0
+
+#endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e4ab2b42bd6f..724d221107eb 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1391,7 +1391,7 @@ void cpu_init(void)
 
 	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
 
-	if (cpu_has_vme || cpu_has_tsc || cpu_has_de)
+	if (cpu_feature_enabled(X86_FEATURE_VME) || cpu_has_tsc || cpu_has_de)
 		clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
 
 	load_current_idt();
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index f961de9964c7..ea5f363a1948 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -707,7 +707,7 @@ void __init mtrr_bp_init(void)
 	} else {
 		switch (boot_cpu_data.x86_vendor) {
 		case X86_VENDOR_AMD:
-			if (cpu_has_k6_mtrr) {
+			if (cpu_feature_enabled(X86_FEATURE_K6_MTRR)) {
 				/* Pre-Athlon (K6) AMD CPU MTRRs */
 				mtrr_if = mtrr_ops[X86_VENDOR_AMD];
 				size_or_mask = SIZE_OR_MASK_BITS(32);
@@ -715,14 +715,14 @@ void __init mtrr_bp_init(void)
 			}
 			break;
 		case X86_VENDOR_CENTAUR:
-			if (cpu_has_centaur_mcr) {
+			if (cpu_feature_enabled(X86_FEATURE_CENTAUR_MCR)) {
 				mtrr_if = mtrr_ops[X86_VENDOR_CENTAUR];
 				size_or_mask = SIZE_OR_MASK_BITS(32);
 				size_and_mask = 0;
 			}
 			break;
 		case X86_VENDOR_CYRIX:
-			if (cpu_has_cyrix_arr) {
+			if (cpu_feature_enabled(X86_FEATURE_CYRIX_ARR)) {
 				mtrr_if = mtrr_ops[X86_VENDOR_CYRIX];
 				size_or_mask = SIZE_OR_MASK_BITS(32);
 				size_and_mask = 0;
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 1667b1de8d5d..72e8e310258d 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -247,7 +247,8 @@ void machine_kexec(struct kimage *image)
 	/* now call it */
 	image->start = relocate_kernel_ptr((unsigned long)image->head,
 					   (unsigned long)page_list,
-					   image->start, cpu_has_pae,
+					   image->start,
+					   boot_cpu_has(X86_FEATURE_PAE),
 					   image->preserve_context);
 
 #ifdef CONFIG_KEXEC_JUMP
