Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaCCIEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:04:52 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56013 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaCCIEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:04:50 -0500
Date: Mon, 3 Mar 2014 15:04:35 +0700
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Dennis Mungai <dmngaie@gmail.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        devzero@web.de
Subject: Re: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140303080432.GA25489@localhost>
References: <20140228140043.GA12157@debian.local>
 <20140302205619.GA8676@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140302205619.GA8676@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2014 at 09:56:19PM +0100, Andreas Mohr wrote:
> Hi,
> 
> >  	/*
> > +	 * PAE CPUID bug: Pentium M reports no PAE but has PAE
> > +	 */
> 
> Ain't that a tad strongly/incorrectly worded?

I've updated the wording.

On 3 March 2014 02:05, Roland Kletzing <devzero@web.de> wrote:
> i would recommend adding the newly introduced param to
> Documentation/kernel-
> parameters.txt , though.

Done.

Signed-off-by: Chris Bainbridge <chris.bainbridge@gmail.com>
---
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b9e9bd8..388b5e9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -962,6 +962,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			parameter will force ia64_sal_cache_flush to call
 			ia64_pal_cache_flush instead of SAL_CACHE_FLUSH.
 
+	forcepae [X86-32]
+			Forcefully enable Physical Address Extension (PAE).
+			Many Pentium M systems disable PAE but may have a
+			functionally usable PAE implementation.
+			Note: This parameter is unsupported, may cause unknown
+			problems, and will taint the kernel.
+
 	ftrace=[tracer]
 			[FTRACE] will set and start the specified tracer
 			as early as possible in order to facilitate early
diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index 4d3ff03..93ba160 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -69,6 +69,13 @@ static int is_transmeta(void)
 	       cpu_vendor[2] == A32('M', 'x', '8', '6');
 }
 
+static int is_intel(void)
+{
+	return cpu_vendor[0] == A32('G', 'e', 'n', 'u') &&
+	       cpu_vendor[1] == A32('i', 'n', 'e', 'I') &&
+	       cpu_vendor[2] == A32('n', 't', 'e', 'l');
+}
+
 static int has_fpu(void)
 {
 	u16 fcw = -1, fsw = -1;
@@ -239,6 +246,24 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
 		asm("wrmsr" : : "a" (eax), "d" (edx), "c" (ecx));
 
 		err = check_flags();
+	} else if (err == 0x01 &&
+		   !(err_flags[0] & ~(1 << X86_FEATURE_PAE)) &&
+		   is_intel() && cpu.level == 6 &&
+		   (cpu.model == 9 || cpu.model == 13)) {
+		/* PAE is disabled on this Pentium M but can be forced */
+		if (cmdline_find_option_bool("forcepae")) {
+			puts("WARNING: Forcing PAE in CPU flags\n");
+			set_bit(X86_FEATURE_PAE, cpu.flags);
+			err = check_flags();
+		}
+		else {
+			puts("ERROR: PAE is disabled on this Pentium M\n"
+				"(PAE can potentially be enabled with "
+				"kernel parameter\n"
+				"\"forcepae\" - this is unsupported, may "
+				"cause unknown\n"
+				"problems, and will taint the kernel)\n");
+		}
 	}
 
 	if (err_flags_ptr)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index bbe1b8b..271686d 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -196,6 +196,14 @@ static void intel_smp_check(struct cpuinfo_x86 *c)
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
@@ -226,6 +234,17 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
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
