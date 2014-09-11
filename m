Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbaIKVQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:16:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:39425 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbaIKVPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:15:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,507,1406617200"; 
   d="scan'208";a="598291747"
Subject: [PATCH 3/3] x86: add more disabled features
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        fenghua.yu@intel.com, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com, bp@suse.de
From: Dave Hansen <dave@sr71.net>
Date: Thu, 11 Sep 2014 14:15:24 -0700
References: <20140911211510.D032EC3B@viggo.jf.intel.com>
In-Reply-To: <20140911211510.D032EC3B@viggo.jf.intel.com>
Message-Id: <20140911211524.C0EC332A@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The original motivation for these patches was for an Intel CPU
feature called MPX.  The patch to add a disabled feature for it
will go in with the other parts of the support.

But, in the meantime, there are a few other features than MPX
that we can make assumptions about at compile-time based on
compile options.  Add them to disabled-features.h and check them
with cpu_feature_enabled().

Note that this gets rid of the last things that needed an #ifdef
CONFIG_X86_64 in cpufeature.h.  Yay!

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Borislav Petkov <bp@suse.de>
---

 b/arch/x86/include/asm/cpufeature.h        |   20 --------------------
 b/arch/x86/include/asm/disabled-features.h |   16 ++++++++++++++--
 b/arch/x86/kernel/cpu/common.c             |    2 +-
 b/arch/x86/kernel/cpu/mtrr/main.c          |    6 +++---
 4 files changed, 18 insertions(+), 26 deletions(-)

diff -puN arch/x86/include/asm/cpufeature.h~x86-disabled_features-addmore arch/x86/include/asm/cpufeature.h
--- a/arch/x86/include/asm/cpufeature.h~x86-disabled_features-addmore	2014-09-11 14:11:32.541086689 -0700
+++ b/arch/x86/include/asm/cpufeature.h	2014-09-11 14:11:32.550087101 -0700
@@ -324,7 +324,6 @@ extern const char * const x86_bug_flags[
 } while (0)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
-#define cpu_has_vme		boot_cpu_has(X86_FEATURE_VME)
 #define cpu_has_de		boot_cpu_has(X86_FEATURE_DE)
 #define cpu_has_pse		boot_cpu_has(X86_FEATURE_PSE)
 #define cpu_has_tsc		boot_cpu_has(X86_FEATURE_TSC)
@@ -343,9 +342,6 @@ extern const char * const x86_bug_flags[
 #define cpu_has_avx2		boot_cpu_has(X86_FEATURE_AVX2)
 #define cpu_has_ht		boot_cpu_has(X86_FEATURE_HT)
 #define cpu_has_nx		boot_cpu_has(X86_FEATURE_NX)
-#define cpu_has_k6_mtrr		boot_cpu_has(X86_FEATURE_K6_MTRR)
-#define cpu_has_cyrix_arr	boot_cpu_has(X86_FEATURE_CYRIX_ARR)
-#define cpu_has_centaur_mcr	boot_cpu_has(X86_FEATURE_CENTAUR_MCR)
 #define cpu_has_xstore		boot_cpu_has(X86_FEATURE_XSTORE)
 #define cpu_has_xstore_enabled	boot_cpu_has(X86_FEATURE_XSTORE_EN)
 #define cpu_has_xcrypt		boot_cpu_has(X86_FEATURE_XCRYPT)
@@ -380,22 +376,6 @@ extern const char * const x86_bug_flags[
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
 #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
 
-#ifdef CONFIG_X86_64
-
-#undef  cpu_has_vme
-#define cpu_has_vme		0
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
diff -puN arch/x86/include/asm/disabled-features.h~x86-disabled_features-addmore arch/x86/include/asm/disabled-features.h
--- a/arch/x86/include/asm/disabled-features.h~x86-disabled_features-addmore	2014-09-11 14:11:32.543086781 -0700
+++ b/arch/x86/include/asm/disabled-features.h	2014-09-11 14:11:32.550087101 -0700
@@ -10,13 +10,25 @@
  * cpu_feature_enabled().
  */
 
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
 /*
  * Make sure to add features to the correct mask
  */
-#define DISABLED_MASK0	0
+#define DISABLED_MASK0	(DISABLE_VME)
 #define DISABLED_MASK1	0
 #define DISABLED_MASK2	0
-#define DISABLED_MASK3	0
+#define DISABLED_MASK3	(DISABLE_CYRIX_ARR|DISABLE_CENTAUR_MCR|DISABLE_K6_MTRR)
 #define DISABLED_MASK4	0
 #define DISABLED_MASK5	0
 #define DISABLED_MASK6	0
diff -puN arch/x86/kernel/cpu/common.c~x86-disabled_features-addmore arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~x86-disabled_features-addmore	2014-09-11 14:11:32.545086872 -0700
+++ b/arch/x86/kernel/cpu/common.c	2014-09-11 14:11:32.562087651 -0700
@@ -1391,7 +1391,7 @@ void cpu_init(void)
 
 	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
 
-	if (cpu_has_vme || cpu_has_tsc || cpu_has_de)
+	if (cpu_feature_enabled(X86_FEATURE_VME) || cpu_has_tsc || cpu_has_de)
 		clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
 
 	load_current_idt();
diff -puN arch/x86/kernel/cpu/mtrr/main.c~x86-disabled_features-addmore arch/x86/kernel/cpu/mtrr/main.c
--- a/arch/x86/kernel/cpu/mtrr/main.c~x86-disabled_features-addmore	2014-09-11 14:11:32.546086917 -0700
+++ b/arch/x86/kernel/cpu/mtrr/main.c	2014-09-11 14:11:32.563087697 -0700
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
_
