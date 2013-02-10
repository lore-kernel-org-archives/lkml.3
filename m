Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3BJVhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 16:37:32 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:59790 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab3BJVha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 16:37:30 -0500
Message-ID: <51181317.1080905@kernel.org>
Date: Sun, 10 Feb 2013 16:37:27 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, x86@kernel.org
Subject: [PATCH 2/2 v2] x86 idle: remove 32-bit-only "no-hlt" parameter, hlt_works_ok
 flag
References: <1360483829-16349-1-git-send-email-lenb@kernel.org> <c1647586af985fefe95a36e4924493f950ffe5e6.1360483568.git.len.brown@intel.com>
In-Reply-To: <c1647586af985fefe95a36e4924493f950ffe5e6.1360483568.git.len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Remove 32-bit x86 a cmdline param "no-hlt",
and the cpuinfo_x86.hlt_works_ok that it sets.

If a user wants to avoid HLT, then "idle=poll"
is much more useful, as it avoids invocation of HLT
in idle, while "no-hlt" failed to do so.

Indeed, hlt_works_ok was consulted in only 3 places.

First, in /proc/cpuinfo where "hlt_bug yes"
would be printed if and only if the user booted
the system with "no-hlt" -- as there was no other code
to set that flag.

Second, check_hlt() would not invoke halt() if "no-hlt"
were on the cmdline.

Third, it was consulted in stop_this_cpu(), which is invoked
by native_machine_halt()/reboot_interrupt()/smp_stop_nmi_callback() --
all cases where the machine is being shutdown/reset.
The flag was not consulted in the more frequently invoked
play_dead()/hlt_play_dead() used in processor offline and suspend.

Since Linux-3.0 there has been a run-time notice upon "no-hlt" invocations
indicating that it would be removed in 2012.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
---
v2: remove also check_hlt()
---
 Documentation/kernel-parameters.txt |  4 ----
 arch/x86/include/asm/processor.h    | 10 ----------
 arch/x86/kernel/cpu/bugs.c          | 27 ---------------------------
 arch/x86/kernel/cpu/proc.c          |  2 --
 arch/x86/kernel/process.c           |  6 ++----
 arch/x86/xen/setup.c                |  3 ---
 6 files changed, 2 insertions(+), 50 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 3b0cd1e..109ee45 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1881,10 +1881,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			wfi(ARM) instruction doesn't work correctly and not to
 			use it. This is also useful when using JTAG debugger.
 
-	no-hlt		[BUGS=X86-32] Tells the kernel that the hlt
-			instruction doesn't work correctly and not to
-			use it.
-
 	no_file_caps	Tells the kernel not to honor file capabilities.  The
 			only way then for a file to be executed with privilege
 			is to be setuid root or executed by root.
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 8a28fea..b9e7d27 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -89,7 +89,6 @@ struct cpuinfo_x86 {
 	char			wp_works_ok;	/* It doesn't on 386's */
 
 	/* Problems on some 486Dx4's and old 386's: */
-	char			hlt_works_ok;
 	char			hard_math;
 	char			rfu;
 	char			fdiv_bug;
@@ -165,15 +164,6 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 
 extern const struct seq_operations cpuinfo_op;
 
-static inline int hlt_works(int cpu)
-{
-#ifdef CONFIG_X86_32
-	return cpu_data(cpu).hlt_works_ok;
-#else
-	return 1;
-#endif
-}
-
 #define cache_line_size()	(boot_cpu_data.x86_cache_alignment)
 
 extern void cpu_detect(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 92dfec9..af6455e 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -17,15 +17,6 @@
 #include <asm/paravirt.h>
 #include <asm/alternative.h>
 
-static int __init no_halt(char *s)
-{
-	WARN_ONCE(1, "\"no-hlt\" is deprecated, please use \"idle=poll\"\n");
-	boot_cpu_data.hlt_works_ok = 0;
-	return 1;
-}
-
-__setup("no-hlt", no_halt);
-
 static int __init no_387(char *s)
 {
 	boot_cpu_data.hard_math = 0;
@@ -89,23 +80,6 @@ static void __init check_fpu(void)
 		pr_warn("Hmm, FPU with FDIV bug\n");
 }
 
-static void __init check_hlt(void)
-{
-	if (boot_cpu_data.x86 >= 5 || paravirt_enabled())
-		return;
-
-	pr_info("Checking 'hlt' instruction... ");
-	if (!boot_cpu_data.hlt_works_ok) {
-		pr_cont("disabled\n");
-		return;
-	}
-	halt();
-	halt();
-	halt();
-	halt();
-	pr_cont("OK\n");
-}
-
 /*
  * Check whether we are able to run this kernel safely on SMP.
  *
@@ -129,7 +103,6 @@ void __init check_bugs(void)
 	print_cpu_info(&boot_cpu_data);
 #endif
 	check_config();
-	check_hlt();
 	init_utsname()->machine[1] =
 		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
 	alternative_instructions();
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 3286a92..e280253 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -28,7 +28,6 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 {
 	seq_printf(m,
 		   "fdiv_bug\t: %s\n"
-		   "hlt_bug\t\t: %s\n"
 		   "f00f_bug\t: %s\n"
 		   "coma_bug\t: %s\n"
 		   "fpu\t\t: %s\n"
@@ -36,7 +35,6 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   "cpuid level\t: %d\n"
 		   "wp\t\t: %s\n",
 		   c->fdiv_bug ? "yes" : "no",
-		   c->hlt_works_ok ? "no" : "yes",
 		   c->f00f_bug ? "yes" : "no",
 		   c->coma_bug ? "yes" : "no",
 		   c->hard_math ? "yes" : "no",
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index cd5a4c9..aef852e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -415,10 +415,8 @@ void stop_this_cpu(void *dummy)
 	set_cpu_online(smp_processor_id(), false);
 	disable_local_APIC();
 
-	for (;;) {
-		if (hlt_works(smp_processor_id()))
-			halt();
-	}
+	for (;;)
+		halt();
 }
 
 /*
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 2b73b5c..94eac5c 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -556,9 +556,6 @@ void __init xen_arch_setup(void)
 	       COMMAND_LINE_SIZE : MAX_GUEST_CMDLINE);
 
 	/* Set up idle, making sure it calls safe_halt() pvop */
-#ifdef CONFIG_X86_32
-	boot_cpu_data.hlt_works_ok = 1;
-#endif
 	disable_cpuidle();
 	disable_cpufreq();
 	WARN_ON(xen_set_default_idle());
-- 
1.8.1.3.535.ga923c31


