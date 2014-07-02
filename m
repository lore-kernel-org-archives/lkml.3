Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbaGBQbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:31:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:62341 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbaGBQbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:31:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,589,1400050800"; 
   d="scan'208";a="567355452"
Subject: [PATCH 3/4] x86: add more disabled features
To: bp@alien8.de
Cc: x86@kernel.org, hpa@zytor.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 02 Jul 2014 09:29:29 -0700
References: <20140702162925.B07A3AB9@viggo.jf.intel.com>
In-Reply-To: <20140702162925.B07A3AB9@viggo.jf.intel.com>
Message-Id: <20140702162929.8EEB0019@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

There are a few other features than MPX that we can make
assumptions about at compile-time based on compile options.
Add them to disabled-features.h and check them with
cpu_feature_enabled().

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/include/asm/cpufeature.h        |   16 ----------------
 b/arch/x86/include/asm/disabled-features.h |   16 ++++++++++++++--
 b/arch/x86/kernel/cpu/common.c             |    2 +-
 b/arch/x86/kernel/cpu/mtrr/main.c          |    6 +++---
 4 files changed, 18 insertions(+), 22 deletions(-)

diff -puN arch/x86/include/asm/cpufeature.h~x86-disabled_features-addmore arch/x86/include/asm/cpufeature.h
--- a/arch/x86/include/asm/cpufeature.h~x86-disabled_features-addmore	2014-07-02 09:16:21.437280769 -0700
+++ b/arch/x86/include/asm/cpufeature.h	2014-07-02 09:16:21.446281174 -0700
@@ -310,7 +310,6 @@ extern const char * const x86_power_flag
 } while (0)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
-#define cpu_has_vme		boot_cpu_has(X86_FEATURE_VME)
 #define cpu_has_de		boot_cpu_has(X86_FEATURE_DE)
 #define cpu_has_pse		boot_cpu_has(X86_FEATURE_PSE)
 #define cpu_has_tsc		boot_cpu_has(X86_FEATURE_TSC)
@@ -330,9 +329,6 @@ extern const char * const x86_power_flag
 #define cpu_has_ht		boot_cpu_has(X86_FEATURE_HT)
 #define cpu_has_mp		boot_cpu_has(X86_FEATURE_MP)
 #define cpu_has_nx		boot_cpu_has(X86_FEATURE_NX)
-#define cpu_has_k6_mtrr		boot_cpu_has(X86_FEATURE_K6_MTRR)
-#define cpu_has_cyrix_arr	boot_cpu_has(X86_FEATURE_CYRIX_ARR)
-#define cpu_has_centaur_mcr	boot_cpu_has(X86_FEATURE_CENTAUR_MCR)
 #define cpu_has_xstore		boot_cpu_has(X86_FEATURE_XSTORE)
 #define cpu_has_xstore_enabled	boot_cpu_has(X86_FEATURE_XSTORE_EN)
 #define cpu_has_xcrypt		boot_cpu_has(X86_FEATURE_XCRYPT)
@@ -368,21 +364,9 @@ extern const char * const x86_power_flag
 
 #ifdef CONFIG_X86_64
 
-#undef  cpu_has_vme
-#define cpu_has_vme		0
-
 #undef  cpu_has_mp
 #define cpu_has_mp		1
 
-#undef  cpu_has_k6_mtrr
-#define cpu_has_k6_mtrr		0
-
-#undef  cpu_has_cyrix_arr
-#define cpu_has_cyrix_arr	0
-
-#undef  cpu_has_centaur_mcr
-#define cpu_has_centaur_mcr	0
-
 #endif /* CONFIG_X86_64 */
 
 #if __GNUC__ >= 4
diff -puN arch/x86/include/asm/disabled-features.h~x86-disabled_features-addmore arch/x86/include/asm/disabled-features.h
--- a/arch/x86/include/asm/disabled-features.h~x86-disabled_features-addmore	2014-07-02 09:16:21.439280859 -0700
+++ b/arch/x86/include/asm/disabled-features.h	2014-07-02 09:16:21.447281218 -0700
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
--- a/arch/x86/kernel/cpu/common.c~x86-disabled_features-addmore	2014-07-02 09:16:21.442280992 -0700
+++ b/arch/x86/kernel/cpu/common.c	2014-07-02 09:16:21.447281218 -0700
@@ -1346,7 +1346,7 @@ void cpu_init(void)
 
 	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
 
-	if (cpu_has_vme || cpu_has_tsc || cpu_has_de)
+	if (cpu_feature_enabled(X86_FEATURE_VME) || cpu_has_tsc || cpu_has_de)
 		clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
 
 	load_current_idt();
diff -puN arch/x86/kernel/cpu/mtrr/main.c~x86-disabled_features-addmore arch/x86/kernel/cpu/mtrr/main.c
--- a/arch/x86/kernel/cpu/mtrr/main.c~x86-disabled_features-addmore	2014-07-02 09:16:21.442280992 -0700
+++ b/arch/x86/kernel/cpu/mtrr/main.c	2014-07-02 09:16:21.448281262 -0700
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
