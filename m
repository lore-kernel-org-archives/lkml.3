Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbaFTQRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:17:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:16743 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbaFTQRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:17:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,514,1400050800"; 
   d="scan'208";a="448013036"
Subject: [RFC][PATCH 1/3] x86: introduce disabled-features
To: linux-kernel@vger.kernel.org
Cc: bp@alien8.de, x86@kernel.org, hpa@zytor.com, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Fri, 20 Jun 2014 09:17:36 -0700
Message-Id: <20140620161736.D6AC16FD@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I believe the REQUIRED_MASK aproach was taken so that it was
easier to consult in assembly (arch/x86/kernel/verify_cpu.S).
DISABLED_MASK does not have the same restriction, but I
implemented it the same way for consistency.

--

We have a REQUIRED_MASK... which does two things:
1. Keeps a list of cpuid bits to check in very early boot and
   refuse to boot if those are not present.
2. Consulted during cpu_has() checks, which allows us to
   optimize out things at compile-time.  In other words, if we
   *KNOW* we will not boot with the feature off, then we can
   safely assume that it will be present forever.

But, we don't have a similar mechanism for CPU features which
may be present but that we know we will not use.  We simply
use our existing mechanisms to repeatedly check the status of
the bit at runtime (well, the alternatives patching helps here
but it does not provide compile-time optimization).

Adding a feature to disabled-features.h allows the bit to be
checked via cpu_has(), and all of the benefits of an #ifdef.
Before, we would have done this in a header:

#ifdef CONFIG_X86_INTEL_MPX
#define cpu_has_mpx cpu_has(X86_FEATURE_MPX
#else
#define cpu_has_mpx 0
#endif

and this in the code:

	if (cpu_has_mpx)
		do_some_mpx_thing();

Now, just add your feature to DISABLED_MASK and you can do this
everywhere, and get the same benefits you would have from
#ifdefs:

	if (cpu_has(X86_FEATURE_MPX))
		do_some_mpx_thing();

---

 b/arch/x86/boot/mkcpustr.c                 |    1 
 b/arch/x86/include/asm/cpufeature.h        |   18 +++++++++++++++
 b/arch/x86/include/asm/disabled-features.h |   33 +++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+)

diff -puN arch/x86/boot/mkcpustr.c~x86-disabled_features arch/x86/boot/mkcpustr.c
--- a/arch/x86/boot/mkcpustr.c~x86-disabled_features	2014-06-20 09:12:25.511247513 -0700
+++ b/arch/x86/boot/mkcpustr.c	2014-06-20 09:12:25.517247783 -0700
@@ -16,6 +16,7 @@
 #include <stdio.h>
 
 #include "../include/asm/required-features.h"
+#include "../include/asm/disabled-features.h"
 #include "../include/asm/cpufeature.h"
 #include "../kernel/cpu/capflags.c"
 
diff -puN arch/x86/include/asm/cpufeature.h~x86-disabled_features arch/x86/include/asm/cpufeature.h
--- a/arch/x86/include/asm/cpufeature.h~x86-disabled_features	2014-06-20 09:12:25.513247603 -0700
+++ b/arch/x86/include/asm/cpufeature.h	2014-06-20 09:15:38.967987107 -0700
@@ -8,6 +8,10 @@
 #include <asm/required-features.h>
 #endif
 
+#ifndef _ASM_X86_DISABLED_FEATURES_H
+#include <asm/disabled-features.h>
+#endif
+
 #define NCAPINTS	10	/* N 32-bit words worth of info */
 #define NBUGINTS	1	/* N 32-bit bug flags */
 
@@ -260,12 +264,26 @@ extern const char * const x86_power_flag
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
+	 __builtin_constant_p(bit) && DISABLED_MASK_BIT_SET(bit) ? 0 :	\
 	 test_cpu_cap(c, bit))
 
 #define this_cpu_has(bit)						\
 	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 : 	\
+	 __builtin_constant_p(bit) && DISABLED_MASK_BIT_SET(bit) ? 0 : 	\
 	 x86_this_cpu_test_bit(bit, (unsigned long *)&cpu_info.x86_capability))
 
 #define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)
diff -puN /dev/null arch/x86/include/asm/disabled-features.h
--- /dev/null	2014-04-10 11:28:14.066815724 -0700
+++ b/arch/x86/include/asm/disabled-features.h	2014-06-20 09:15:38.968987152 -0700
@@ -0,0 +1,33 @@
+#ifndef _ASM_X86_DISABLED_FEATURES_H
+#define _ASM_X86_DISABLED_FEATURES_H
+
+/* These features, although they might be available in a CPU
+ * will not be used because the compile options to support
+ * them are not present.
+ *
+ * This code allows them to be checked and disabled at
+ * compile time withut an explicit #ifdef.  Simply call
+ * cpu_has() or this_cpu_has().
+ * */
+
+#ifdef CONFIG_X86_INTEL_MPX
+# define HAVE_MPX	(1<<(X86_FEATURE_MPX & 31))
+#else
+# define HAVE_MPX	0
+#endif
+
+/*
+ * Make sure to add features to the correct mask
+ */
+#define DISABLED_MASK0	0
+#define DISABLED_MASK1	0
+#define DISABLED_MASK2	0
+#define DISABLED_MASK3	0
+#define DISABLED_MASK4	0
+#define DISABLED_MASK5	0
+#define DISABLED_MASK6	0
+#define DISABLED_MASK7	0
+#define DISABLED_MASK8	0
+#define DISABLED_MASK9	(HAVE_MPX)
+
+#endif /* _ASM_X86_DISABLED_FEATURES_H */
_
