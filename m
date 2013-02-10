Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3BJGCa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 01:02:30 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:56103 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab3BJF6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 00:58:33 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org
Subject: [PATCH 02/16] x86 idle: rename global pm_idle to static x86_idle
Date: Sun, 10 Feb 2013 00:58:09 -0500
Message-Id: <39a3b810d55a353d23043703bcde5c22afa01846.1360475150.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360475903-30007-1-git-send-email-lenb@kernel.org>
References: <1360475903-30007-1-git-send-email-lenb@kernel.org>
In-Reply-To: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
References: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

(pm_idle)() is being removed from linux/pm.h
because Linux does not have such a cross-architecture concept.

x86 uses an idle function pointer in its architecture
specific code as a backup to cpuidle.  So we re-name
x86 use of pm_idle to x86_idle, and make it static to x86.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/process.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f571a6e..ceb05db 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -268,10 +268,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 unsigned long boot_option_idle_override = IDLE_NO_OVERRIDE;
 EXPORT_SYMBOL(boot_option_idle_override);
 
-/*
- * Powermanagement idle function, if any..
- */
-void (*pm_idle)(void);
+static void (*x86_idle)(void);
 
 #ifndef CONFIG_SMP
 static inline void play_dead(void)
@@ -348,7 +345,7 @@ void cpu_idle(void)
 			rcu_idle_enter();
 
 			if (cpuidle_idle_call())
-				pm_idle();
+				x86_idle();
 
 			rcu_idle_exit();
 			start_critical_timings();
@@ -395,9 +392,9 @@ EXPORT_SYMBOL(default_idle);
 
 bool set_pm_idle_to_default(void)
 {
-	bool ret = !!pm_idle;
+	bool ret = !!x86_idle;
 
-	pm_idle = default_idle;
+	x86_idle = default_idle;
 
 	return ret;
 }
@@ -564,11 +561,10 @@ static void amd_e400_idle(void)
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
-	if (pm_idle == poll_idle && smp_num_siblings > 1) {
+	if (x86_idle == poll_idle && smp_num_siblings > 1)
 		pr_warn_once("WARNING: polling idle and HT enabled, performance may degrade\n");
-	}
 #endif
-	if (pm_idle)
+	if (x86_idle)
 		return;
 
 	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
@@ -576,19 +572,19 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 		 * One CPU supports mwait => All CPUs supports mwait
 		 */
 		pr_info("using mwait in idle threads\n");
-		pm_idle = mwait_idle;
+		x86_idle = mwait_idle;
 	} else if (cpu_has_amd_erratum(amd_erratum_400)) {
 		/* E400: APIC timer interrupt does not wake up CPU from C1e */
 		pr_info("using AMD E400 aware idle routine\n");
-		pm_idle = amd_e400_idle;
+		x86_idle = amd_e400_idle;
 	} else
-		pm_idle = default_idle;
+		x86_idle = default_idle;
 }
 
 void __init init_amd_e400_c1e_mask(void)
 {
 	/* If we're using amd_e400_idle, we need to allocate amd_e400_c1e_mask. */
-	if (pm_idle == amd_e400_idle)
+	if (x86_idle == amd_e400_idle)
 		zalloc_cpumask_var(&amd_e400_c1e_mask, GFP_KERNEL);
 }
 
@@ -599,7 +595,7 @@ static int __init idle_setup(char *str)
 
 	if (!strcmp(str, "poll")) {
 		pr_info("using polling idle threads\n");
-		pm_idle = poll_idle;
+		x86_idle = poll_idle;
 		boot_option_idle_override = IDLE_POLL;
 	} else if (!strcmp(str, "mwait")) {
 		boot_option_idle_override = IDLE_FORCE_MWAIT;
@@ -612,7 +608,7 @@ static int __init idle_setup(char *str)
 		 * To continue to load the CPU idle driver, don't touch
 		 * the boot_option_idle_override.
 		 */
-		pm_idle = default_idle;
+		x86_idle = default_idle;
 		boot_option_idle_override = IDLE_HALT;
 	} else if (!strcmp(str, "nomwait")) {
 		/*
-- 
1.8.1.3.535.ga923c31

