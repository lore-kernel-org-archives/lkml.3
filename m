Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaB1OBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 09:01:00 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:57532 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaB1OA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:00:58 -0500
Date: Fri, 28 Feb 2014 21:00:45 +0700
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: Dennis Mungai <dmngaie@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140228140043.GA12157@debian.local>
References: <20140225060146.GA4339@debian.local>
 <530C7465.2080600@zytor.com>
 <20140225162611.GA31902@redhat.com>
 <530CCFD2.3050007@zytor.com>
 <20140226121256.GA8494@debian.local>
 <20140226131852.GA22690@pd.tnic>
 <20140226154949.GA770@redhat.com>
 <20140228073011.GA26449@debian.local>
 <CAKKYfmFgVjYwvThpB0FBB+ggOwULWKLpz7ADT1eojno_KtD9yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKKYfmFgVjYwvThpB0FBB+ggOwULWKLpz7ADT1eojno_KtD9yw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 03:27:50PM +0300, Dennis Mungai wrote:
> Hello people,
> 
> Note that revisions of the Dothan core were released in the first quarter
> of 2005 with the *Sonoma* chipsets and supported a 533 MT/s FSB and NX-bit
> (and PAE support required for it was enabled, unlike earlier Pentium Ms
> that had it disabled). These processors include the 730M (1.6 GHz), 740M
> (1.73 GHz), 750M (1.86 GHz), 760M (2.0 GHz) and 770M (2.13 GHz). These
> models all have a TDP of 27 W and a 2 MB L2 cache.
> 
> These CPUs should have PAE enabled. Only earlier versions of the Pentium M
> ( Older Dothans and the Banias core) do not have PAE support, officially.
> 
> -Dennis.

Good point, patch updated to not show the warning if PAE is already
enabled.

Signed-off-by: Chris Bainbridge <chris.bainbridge@gmail.com>
---
diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index 4d3ff03..3fd12bc 100644
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
@@ -239,6 +246,21 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
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
+			puts("Pentium M: PAE is disabled, "
+			     "enable it with kernel argument \"forcepae\"\n"
+			     "(this will taint the kernel)\n");
+		}
 	}
 
 	if (err_flags_ptr)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index bbe1b8b..873cf3b 100644
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
@@ -226,6 +234,15 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 		clear_cpu_cap(c, X86_FEATURE_SEP);
 
 	/*
+	 * PAE CPUID bug: Pentium M reports no PAE but has PAE
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
