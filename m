Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190Ab3BKXDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:03:23 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:49226 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760090Ab3BKXDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:03:21 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH v2] APM idle: register apm_cpu_idle via cpuidle
Date: Mon, 11 Feb 2013 18:03:09 -0500
Message-Id: <17242de27db147c4f828d6089016e1f485c038fb.1360623445.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360623789-12247-1-git-send-email-lenb@kernel.org>
References: <5118B776.6090604@linaro.org>
 <1360623789-12247-1-git-send-email-lenb@kernel.org>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Update APM to register its local idle routine with cpuidle.

This allows us to stop exporting pm_idle to modules on x86.

The Kconfig sub-option, APM_CPU_IDLE, now depends on on CPU_IDLE.

Compile-tested only.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>
---
v2: updates from Daniel Lezcano's review
---
 arch/x86/Kconfig          |  1 +
 arch/x86/kernel/apm_32.c  | 60 +++++++++++++++++++++++++++++------------------
 arch/x86/kernel/process.c |  3 ---
 3 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 225543b..1b63586 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1912,6 +1912,7 @@ config APM_DO_ENABLE
 	  this feature.
 
 config APM_CPU_IDLE
+	depends on CPU_IDLE
 	bool "Make CPU Idle calls when idle"
 	---help---
 	  Enable calls to APM CPU Idle/CPU Busy inside the kernel's idle loop.
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index d65464e..f9f8afc 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -232,6 +232,7 @@
 #include <linux/acpi.h>
 #include <linux/syscore_ops.h>
 #include <linux/i8253.h>
+#include <linux/cpuidle.h>
 
 #include <asm/uaccess.h>
 #include <asm/desc.h>
@@ -360,13 +361,38 @@ struct apm_user {
  * idle percentage above which bios idle calls are done
  */
 #ifdef CONFIG_APM_CPU_IDLE
-#warning deprecated CONFIG_APM_CPU_IDLE will be deleted in 2012
 #define DEFAULT_IDLE_THRESHOLD	95
 #else
 #define DEFAULT_IDLE_THRESHOLD	100
 #endif
 #define DEFAULT_IDLE_PERIOD	(100 / 3)
 
+static int apm_cpu_idle(struct cpuidle_device *dev,
+			struct cpuidle_driver *drv, int index);
+
+static struct cpuidle_driver apm_idle_driver = {
+	.name = "apm_idle",
+	.owner = THIS_MODULE,
+	.en_core_tk_irqen = 1,
+	.states = {
+		{ /* entry 0 is for polling */ },
+		{ /* entry 1 is for APM idle */
+			.name = "APM",
+			.desc = "APM idle",
+			.flags = CPUIDLE_FLAG_TIME_VALID,
+			.exit_latency = 250,	/* WAG */
+			.target_residency = 500,	/* WAG */
+			.enter = &apm_cpu_idle
+		},
+	},
+	.state_count = 2,
+};
+
+static struct cpuidle_device apm_cpuidle_device = {
+	.state_count = 2,
+};
+
+
 /*
  * Local variables
  */
@@ -377,7 +403,6 @@ static struct {
 static int clock_slowed;
 static int idle_threshold __read_mostly = DEFAULT_IDLE_THRESHOLD;
 static int idle_period __read_mostly = DEFAULT_IDLE_PERIOD;
-static int set_pm_idle;
 static int suspends_pending;
 static int standbys_pending;
 static int ignore_sys_suspend;
@@ -884,8 +909,6 @@ static void apm_do_busy(void)
 #define IDLE_CALC_LIMIT	(HZ * 100)
 #define IDLE_LEAKY_MAX	16
 
-static void (*original_pm_idle)(void) __read_mostly;
-
 /**
  * apm_cpu_idle		-	cpu idling for APM capable Linux
  *
@@ -894,7 +917,8 @@ static void (*original_pm_idle)(void) __read_mostly;
  * Furthermore it calls the system default idle routine.
  */
 
-static void apm_cpu_idle(void)
+static int apm_cpu_idle(struct cpuidle_device *dev,
+	struct cpuidle_driver *drv, int index)
 {
 	static int use_apm_idle; /* = 0 */
 	static unsigned int last_jiffies; /* = 0 */
@@ -904,7 +928,6 @@ static void apm_cpu_idle(void)
 	unsigned int jiffies_since_last_check = jiffies - last_jiffies;
 	unsigned int bucket;
 
-	WARN_ONCE(1, "deprecated apm_cpu_idle will be deleted in 2012");
 recalc:
 	if (jiffies_since_last_check > IDLE_CALC_LIMIT) {
 		use_apm_idle = 0;
@@ -950,10 +973,7 @@ recalc:
 				break;
 			}
 		}
-		if (original_pm_idle)
-			original_pm_idle();
-		else
-			default_idle();
+		default_idle();
 		local_irq_disable();
 		jiffies_since_last_check = jiffies - last_jiffies;
 		if (jiffies_since_last_check > idle_period)
@@ -963,7 +983,7 @@ recalc:
 	if (apm_idle_done)
 		apm_do_busy();
 
-	local_irq_enable();
+	return index;
 }
 
 /**
@@ -2381,9 +2401,9 @@ static int __init apm_init(void)
 	if (HZ != 100)
 		idle_period = (idle_period * HZ) / 100;
 	if (idle_threshold < 100) {
-		original_pm_idle = pm_idle;
-		pm_idle  = apm_cpu_idle;
-		set_pm_idle = 1;
+		if (!cpuidle_register_driver(&apm_idle_driver))
+			if (cpuidle_register_device(&apm_cpuidle_device))
+				cpuidle_unregister_driver(&apm_idle_driver);
 	}
 
 	return 0;
@@ -2393,15 +2413,9 @@ static void __exit apm_exit(void)
 {
 	int error;
 
-	if (set_pm_idle) {
-		pm_idle = original_pm_idle;
-		/*
-		 * We are about to unload the current idle thread pm callback
-		 * (pm_idle), Wait for all processors to update cached/local
-		 * copies of pm_idle before proceeding.
-		 */
-		kick_all_cpus_sync();
-	}
+	cpuidle_unregister_device(&apm_cpuidle_device);
+	cpuidle_unregister_driver(&apm_idle_driver);
+
 	if (((apm_info.bios.flags & APM_BIOS_DISENGAGED) == 0)
 	    && (apm_info.connection_version > 0x0100)) {
 		error = apm_engage_power_management(APM_DEVICE_ALL, 0);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 2ed787f..f571a6e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -272,9 +272,6 @@ EXPORT_SYMBOL(boot_option_idle_override);
  * Powermanagement idle function, if any..
  */
 void (*pm_idle)(void);
-#ifdef CONFIG_APM_MODULE
-EXPORT_SYMBOL(pm_idle);
-#endif
 
 #ifndef CONFIG_SMP
 static inline void play_dead(void)
-- 
1.8.1.3.535.ga923c31

