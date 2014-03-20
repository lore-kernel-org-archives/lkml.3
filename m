Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbaCTXdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 19:33:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57226 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759420AbaCTXds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 19:33:48 -0400
Date: Thu, 20 Mar 2014 16:33:25 -0700
From: tip-bot for Chris Bainbridge <tipbot@zytor.com>
Message-ID: <tip-69f2366c9456d0ce784cf5aba87ee77eeadc1d5e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de, chris.bainbridge@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, chris.bainbridge@gmail.com
In-Reply-To: <20140307114040.GA4997@localhost>
References: <20140307114040.GA4997@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu:
  Add forcepae parameter for booting PAE kernels on PAE-disabled Pentium M
Git-Commit-ID: 69f2366c9456d0ce784cf5aba87ee77eeadc1d5e
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

Commit-ID:  69f2366c9456d0ce784cf5aba87ee77eeadc1d5e
Gitweb:     http://git.kernel.org/tip/69f2366c9456d0ce784cf5aba87ee77eeadc1d5e
Author:     Chris Bainbridge <chris.bainbridge@gmail.com>
AuthorDate: Fri, 7 Mar 2014 18:40:42 +0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 20 Mar 2014 16:31:54 -0700

x86, cpu: Add forcepae parameter for booting PAE kernels on PAE-disabled Pentium M

Many Pentium M systems disable PAE but may have a functionally usable PAE
implementation. This adds the "forcepae" parameter which bypasses the boot
check for PAE, and sets the CPU as being PAE capable. Using this parameter
will taint the kernel with TAINT_CPU_OUT_OF_SPEC.

Signed-off-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Link: http://lkml.kernel.org/r/20140307114040.GA4997@localhost
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/kernel-parameters.txt |  7 +++++++
 arch/x86/boot/cpucheck.c            | 20 ++++++++++++++++++++
 arch/x86/kernel/cpu/intel.c         | 19 +++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda..06600cc 100644
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
index 34bbb55..897d620 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -186,6 +186,14 @@ static void intel_smp_check(struct cpuinfo_x86 *c)
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
 #ifdef CONFIG_X86_F00F_BUG
@@ -214,6 +222,17 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
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
