Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaCGLkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:40:55 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58468 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaCGLky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:40:54 -0500
Date: Fri, 7 Mar 2014 18:40:42 +0700
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andreas Mohr <andi@lisas.de>,
        Dennis Mungai <dmngaie@gmail.com>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, devzero@web.de, bp@alien8.de
Subject: [PATCH] x86: Add forcepae parameter for booting PAE kernels on
 PAE-disabled Pentium M
Message-ID: <20140307114040.GA4997@localhost>
References: <20140228140043.GA12157@debian.local>
 <20140302205619.GA8676@rhlx01.hs-esslingen.de>
 <20140303080432.GA25489@localhost>
 <20140303192939.GD31265@pd.tnic>
 <20140304050122.GA3740@localhost>
 <5e866e2a-ea92-43f8-ae67-23f6052c91c8@email.android.com>
 <20140304060559.GA547@localhost>
 <20140304104447.GA4891@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304104447.GA4891@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Bainbridge <chris.bainbridge@gmail.com>

Many Pentium M systems disable PAE but may have a functionally usable PAE 
implementation. This adds the "forcepae" parameter which bypasses the boot 
check for PAE, and sets the CPU as being PAE capable. Using this parameter 
will taint the kernel with TAINT_CPU_OUT_OF_SPEC.

Signed-off-by: Chris Bainbridge <chris.bainbridge@gmail.com>
---
This patch depends on Dave Jones's TAINT_CPU_OUT_OF_SPEC patch @ 
https://lkml.org/lkml/2014/2/26/394

diff --git a/Documentation/kernel-parameters.txt 
b/Documentation/kernel-parameters.txt
index 580a60c..67755ea 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1011,6 +1011,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			parameter will force ia64_sal_cache_flush to call
 			ia64_pal_cache_flush instead of SAL_CACHE_FLUSH.
 
+	forcepae [X86-32]
+			Forcefully enable Physical Address Extension (PAE).
+			Many Pentium M systems disable PAE but may have a
+			functionally usable PAE implementation.
+			Warning: use of this parameter will taint the kernel
+			and may cause unknown problems.
+
 	ftrace=[tracer]
 			[FTRACE] will set and start the specified tracer
 			as early as possible in order to facilitate early
diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index 100a9a1..f0d0b20 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -67,6 +67,13 @@ static int is_transmeta(void)
 	       cpu_vendor[2] == A32('M', 'x', '8', '6');
 }
 
+static int is_intel(void)
+{
+	return cpu_vendor[0] == A32('G', 'e', 'n', 'u') &&
+	       cpu_vendor[1] == A32('i', 'n', 'e', 'I') &&
+	       cpu_vendor[2] == A32('n', 't', 'e', 'l');
+}
+
 /* Returns a bitmask of which words we have error bits in */
 static int check_cpuflags(void)
 {
@@ -153,6 +160,19 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 		asm("wrmsr" : : "a" (eax), "d" (edx), "c" (ecx));
 
 		err = check_cpuflags();
+	} else if (err == 0x01 &&
+		   !(err_flags[0] & ~(1 << X86_FEATURE_PAE)) &&
+		   is_intel() && cpu.level == 6 &&
+		   (cpu.model == 9 || cpu.model == 13)) {
+		/* PAE is disabled on this Pentium M but can be forced */
+		if (cmdline_find_option_bool("forcepae")) {
+			puts("WARNING: Forcing PAE in CPU flags\n");
+			set_bit(X86_FEATURE_PAE, cpu.flags);
+			err = check_cpuflags();
+		}
+		else {
+			puts("WARNING: PAE disabled. Use parameter 'forcepae' to enable at your own risk!\n");
+		}
 	}
 
 	if (err_flags_ptr)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ea56e7c..053cb59 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -195,6 +195,14 @@ static void intel_smp_check(struct cpuinfo_x86 *c)
 	}
 }
 
+static int forcepae;
+static int __init forcepae_setup(char *__unused)
+{
+	forcepae = 1;
+	return 1;
+}
+__setup("forcepae", forcepae_setup);
+
 static void intel_workarounds(struct cpuinfo_x86 *c)
 {
 	unsigned long lo, hi;
@@ -225,6 +233,17 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 		clear_cpu_cap(c, X86_FEATURE_SEP);
 
 	/*
+	 * PAE CPUID issue: many Pentium M report no PAE but may have a
+	 * functionally usable PAE implementation.
+	 * Forcefully enable PAE if kernel parameter "forcepae" is present.
+	 */
+	if (forcepae) {
+		printk(KERN_WARNING "PAE forced!\n");
+		set_cpu_cap(c, X86_FEATURE_PAE);
+		add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_NOW_UNRELIABLE);
+	}
+
+	/*
 	 * P4 Xeon errata 037 workaround.
 	 * Hardware prefetcher may cause stale data to be loaded into the cache.
 	 */
