Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3BJILA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 03:11:00 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:39472 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab3BJIKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 03:10:41 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org
Subject: [PATCH 1/2] x86 idle: remove mwait_idle() and "idle=mwait" cmdline param
Date: Sun, 10 Feb 2013 03:10:28 -0500
Message-Id: <69fb3676df3329a7142803bb3502fa59dc0db2e3.1360483568.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360483829-16349-1-git-send-email-lenb@kernel.org>
References: <1360483829-16349-1-git-send-email-lenb@kernel.org>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

mwait_idle() is a C1-only idle loop intended to be more efficient
than HLT, starting on Pentium-4 HT-enabled processors.

But mwait_idle() has been replaced by the more general
mwait_idle_with_hints(), which handles both C1 and deeper C-states.
ACPI processor_idle and intel_idle use only mwait_idle_with_hints(),
and no longer use mwait_idle().

Here we simplify the x86 native idle code by removing mwait_idle(),
and the "idle=mwait" bootparam used to invoke it.

Since Linux 3.0 there has been a boot-time warning when "idle=mwait"
was invoked saying it would be removed in 2012.  This removal
was also noted in the (now removed:-) feature-removal-schedule.txt.

After this change, kernels configured with
(CONFIG_ACPI=n && CONFIG_INTEL_IDLE=n) when run on hardware
that supports MWAIT will simply use HLT.  If MWAIT is desired
on those systems, cpuidle and the cpuidle drivers above
can be enabled.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
---
 Documentation/kernel-parameters.txt |  7 +---
 arch/x86/include/asm/processor.h    |  2 +-
 arch/x86/kernel/process.c           | 79 +------------------------------------
 arch/x86/kernel/smpboot.c           |  2 +-
 drivers/acpi/processor_idle.c       |  1 -
 5 files changed, 4 insertions(+), 87 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 363e348..3b0cd1e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1039,16 +1039,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Claim all unknown PCI IDE storage controllers.
 
 	idle=		[X86]
-			Format: idle=poll, idle=mwait, idle=halt, idle=nomwait
+			Format: idle=poll, idle=halt, idle=nomwait
 			Poll forces a polling idle loop that can slightly
 			improve the performance of waking up a idle CPU, but
 			will use a lot of power and make the system run hot.
 			Not recommended.
-			idle=mwait: On systems which support MONITOR/MWAIT but
-			the kernel chose to not use it because it doesn't save
-			as much power as a normal idle loop, use the
-			MONITOR/MWAIT idle loop anyways. Performance should be
-			the same as idle=poll.
 			idle=halt: Halt is forced to be used for CPU idle.
 			In such case C2/C3 won't be used again.
 			idle=nomwait: Disable mwait for CPU C-states
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c2f7f47..8a28fea 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -725,7 +725,7 @@ extern unsigned long		boot_option_idle_override;
 extern bool			amd_e400_c1e_detected;
 
 enum idle_boot_override {IDLE_NO_OVERRIDE=0, IDLE_HALT, IDLE_NOMWAIT,
-			 IDLE_POLL, IDLE_FORCE_MWAIT};
+			 IDLE_POLL};
 
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 7ed9f6b0..cd5a4c9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -421,27 +421,6 @@ void stop_this_cpu(void *dummy)
 	}
 }
 
-/* Default MONITOR/MWAIT with no hints, used for default C1 state */
-static void mwait_idle(void)
-{
-	if (!need_resched()) {
-		trace_power_start_rcuidle(POWER_CSTATE, 1, smp_processor_id());
-		trace_cpu_idle_rcuidle(1, smp_processor_id());
-		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
-			clflush((void *)&current_thread_info()->flags);
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
-		if (!need_resched())
-			__sti_mwait(0, 0);
-		else
-			local_irq_enable();
-		trace_power_end_rcuidle(smp_processor_id());
-		trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
-	} else
-		local_irq_enable();
-}
-
 /*
  * On SMP it's slightly faster (but much more power-consuming!)
  * to poll the ->work.need_resched flag instead of waiting for the
@@ -458,53 +437,6 @@ static void poll_idle(void)
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }
 
-/*
- * mwait selection logic:
- *
- * It depends on the CPU. For AMD CPUs that support MWAIT this is
- * wrong. Family 0x10 and 0x11 CPUs will enter C1 on HLT. Powersavings
- * then depend on a clock divisor and current Pstate of the core. If
- * all cores of a processor are in halt state (C1) the processor can
- * enter the C1E (C1 enhanced) state. If mwait is used this will never
- * happen.
- *
- * idle=mwait overrides this decision and forces the usage of mwait.
- */
-
-#define MWAIT_INFO			0x05
-#define MWAIT_ECX_EXTENDED_INFO		0x01
-#define MWAIT_EDX_C1			0xf0
-
-int mwait_usable(const struct cpuinfo_x86 *c)
-{
-	u32 eax, ebx, ecx, edx;
-
-	/* Use mwait if idle=mwait boot option is given */
-	if (boot_option_idle_override == IDLE_FORCE_MWAIT)
-		return 1;
-
-	/*
-	 * Any idle= boot option other than idle=mwait means that we must not
-	 * use mwait. Eg: idle=halt or idle=poll or idle=nomwait
-	 */
-	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
-		return 0;
-
-	if (c->cpuid_level < MWAIT_INFO)
-		return 0;
-
-	cpuid(MWAIT_INFO, &eax, &ebx, &ecx, &edx);
-	/* Check, whether EDX has extended info about MWAIT */
-	if (!(ecx & MWAIT_ECX_EXTENDED_INFO))
-		return 1;
-
-	/*
-	 * edx enumeratios MONITOR/MWAIT extensions. Check, whether
-	 * C1  supports MWAIT
-	 */
-	return (edx & MWAIT_EDX_C1);
-}
-
 bool amd_e400_c1e_detected;
 EXPORT_SYMBOL(amd_e400_c1e_detected);
 
@@ -576,13 +508,7 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 	if (pm_idle)
 		return;
 
-	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
-		/*
-		 * One CPU supports mwait => All CPUs supports mwait
-		 */
-		pr_info("using mwait in idle threads\n");
-		pm_idle = mwait_idle;
-	} else if (cpu_has_amd_erratum(amd_erratum_400)) {
+	if (cpu_has_amd_erratum(amd_erratum_400)) {
 		/* E400: APIC timer interrupt does not wake up CPU from C1e */
 		pr_info("using AMD E400 aware idle routine\n");
 		pm_idle = amd_e400_idle;
@@ -606,9 +532,6 @@ static int __init idle_setup(char *str)
 		pr_info("using polling idle threads\n");
 		pm_idle = poll_idle;
 		boot_option_idle_override = IDLE_POLL;
-	} else if (!strcmp(str, "mwait")) {
-		boot_option_idle_override = IDLE_FORCE_MWAIT;
-		WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012\n");
 	} else if (!strcmp(str, "halt")) {
 		/*
 		 * When the boot option of idle=halt is added, halt is
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ed0fe38..a6ceaed 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1369,7 +1369,7 @@ static inline void mwait_play_dead(void)
 	void *mwait_ptr;
 	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
 
-	if (!(this_cpu_has(X86_FEATURE_MWAIT) && mwait_usable(c)))
+	if (!this_cpu_has(X86_FEATURE_MWAIT))
 		return;
 	if (!this_cpu_has(X86_FEATURE_CLFLSH))
 		return;
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index ed9a1cc..52a5e3a 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -84,7 +84,6 @@ static DEFINE_PER_CPU(struct cpuidle_device *, acpi_cpuidle_device);
 static int disabled_by_idle_boot_param(void)
 {
 	return boot_option_idle_override == IDLE_POLL ||
-		boot_option_idle_override == IDLE_FORCE_MWAIT ||
 		boot_option_idle_override == IDLE_HALT;
 }
 
-- 
1.8.1.3.535.ga923c31

