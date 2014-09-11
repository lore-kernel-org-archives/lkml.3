Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaIKVer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:34:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44711 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaIKVeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:34:44 -0400
Date: Thu, 11 Sep 2014 14:34:30 -0700
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-381aa07a9b4e1f82969203e9e4863da2a157781d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dave.hansen@linux.intel.com, bp@suse.de,
        hpa@linux.intel.com
In-Reply-To: <20140911211513.9E35E931@viggo.jf.intel.com>
References: <20140911211513.9E35E931@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86: Introduce disabled-features
Git-Commit-ID: 381aa07a9b4e1f82969203e9e4863da2a157781d
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

Commit-ID:  381aa07a9b4e1f82969203e9e4863da2a157781d
Gitweb:     http://git.kernel.org/tip/381aa07a9b4e1f82969203e9e4863da2a157781d
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Thu, 11 Sep 2014 14:15:13 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 11 Sep 2014 14:30:02 -0700

x86: Introduce disabled-features

I believe the REQUIRED_MASK aproach was taken so that it was
easier to consult in assembly (arch/x86/kernel/verify_cpu.S).
DISABLED_MASK does not have the same restriction, but I
implemented it the same way for consistency.

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
checked via a new macro: cpu_feature_enabled().  Note that
for features in DISABLED_MASK, checks with this macro have
all of the benefits of an #ifdef.  Before, we would have done
this in a header:

#ifdef CONFIG_X86_INTEL_MPX
#define cpu_has_mpx cpu_has(X86_FEATURE_MPX)
#else
#define cpu_has_mpx 0
#endif

and this in the code:

	if (cpu_has_mpx)
		do_some_mpx_thing();

Now, just add your feature to DISABLED_MASK and you can do this
everywhere, and get the same benefits you would have from
#ifdefs:

	if (cpu_feature_enabled(X86_FEATURE_MPX))
		do_some_mpx_thing();

We need a new function and *not* a modification to cpu_has()
because there are cases where we actually need to check the CPU
itself, despite what features the kernel supports.  The best
example of this is a hypervisor which has no control over what
features its guests are using and where the guest does not depend
on the host for support.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: http://lkml.kernel.org/r/20140911211513.9E35E931@viggo.jf.intel.com
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/mkcpustr.c                 |  1 +
 arch/x86/include/asm/cpufeature.h        | 28 ++++++++++++++++++++++++++++
 arch/x86/include/asm/disabled-features.h | 27 +++++++++++++++++++++++++++
 3 files changed, 56 insertions(+)

diff --git a/arch/x86/boot/mkcpustr.c b/arch/x86/boot/mkcpustr.c
index 4579eff..637097e 100644
--- a/arch/x86/boot/mkcpustr.c
+++ b/arch/x86/boot/mkcpustr.c
@@ -16,6 +16,7 @@
 #include <stdio.h>
 
 #include "../include/asm/required-features.h"
+#include "../include/asm/disabled-features.h"
 #include "../include/asm/cpufeature.h"
 #include "../kernel/cpu/capflags.c"
 
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 7b50875..1492041 100644
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
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
new file mode 100644
index 0000000..1a9955d
--- /dev/null
+++ b/arch/x86/include/asm/disabled-features.h
@@ -0,0 +1,27 @@
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
+#define DISABLED_MASK9	0
+
+#endif /* _ASM_X86_DISABLED_FEATURES_H */
