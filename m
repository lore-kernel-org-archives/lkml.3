Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276Ab3D3WKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 18:10:18 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51707 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760258Ab3D3WKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 18:10:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH] ACPI / PM: Move processor suspend/resume to syscore_ops
Date: Wed, 01 May 2013 00:18:29 +0200
Message-ID: <31808229.7gRo8k980M@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The system suspend routine of the ACPI processor driver saves
the BUS_MASTER_RLD register and its resume routine restores it.
However, there can be only one such register in the system and it
really should be saved after non-boot CPUs have been offlined and
restored before they are put back online during resume.

For this reason, move the saving and restoration of BUS_MASTER_RLD
to syscore suspend and syscore resume, respectively, and drop the no
longer necessary suspend/resume callbacks from the ACPI processor
driver.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/processor_driver.c |    8 ++++----
 drivers/acpi/processor_idle.c   |   29 +++++++++++++++++++----------
 include/acpi/processor.h        |   10 ++++++++--
 3 files changed, 31 insertions(+), 16 deletions(-)

Index: linux-pm/drivers/acpi/processor_driver.c
===================================================================
--- linux-pm.orig/drivers/acpi/processor_driver.c
+++ linux-pm/drivers/acpi/processor_driver.c
@@ -95,9 +95,6 @@ static const struct acpi_device_id proce
 };
 MODULE_DEVICE_TABLE(acpi, processor_device_ids);
 
-static SIMPLE_DEV_PM_OPS(acpi_processor_pm,
-			 acpi_processor_suspend, acpi_processor_resume);
-
 static struct acpi_driver acpi_processor_driver = {
 	.name = "processor",
 	.class = ACPI_PROCESSOR_CLASS,
@@ -107,7 +104,6 @@ static struct acpi_driver acpi_processor
 		.remove = acpi_processor_remove,
 		.notify = acpi_processor_notify,
 		},
-	.drv.pm = &acpi_processor_pm,
 };
 
 #define INSTALL_NOTIFY_HANDLER		1
@@ -934,6 +930,8 @@ static int __init acpi_processor_init(vo
 	if (result < 0)
 		return result;
 
+	acpi_processor_syscore_init();
+
 	acpi_processor_install_hotplug_notify();
 
 	acpi_thermal_cpufreq_init();
@@ -956,6 +954,8 @@ static void __exit acpi_processor_exit(v
 
 	acpi_processor_uninstall_hotplug_notify();
 
+	acpi_processor_syscore_exit();
+
 	acpi_bus_unregister_driver(&acpi_processor_driver);
 
 	return;
Index: linux-pm/drivers/acpi/processor_idle.c
===================================================================
--- linux-pm.orig/drivers/acpi/processor_idle.c
+++ linux-pm/drivers/acpi/processor_idle.c
@@ -34,6 +34,7 @@
 #include <linux/sched.h>       /* need_resched() */
 #include <linux/clockchips.h>
 #include <linux/cpuidle.h>
+#include <linux/syscore_ops.h>
 
 /*
  * Include the apic definitions for x86 to have the APIC timer related defines
@@ -210,33 +211,41 @@ static void lapic_timer_state_broadcast(
 
 #endif
 
+#ifdef CONFIG_PM_SLEEP
 static u32 saved_bm_rld;
 
-static void acpi_idle_bm_rld_save(void)
+int acpi_processor_suspend(void)
 {
 	acpi_read_bit_register(ACPI_BITREG_BUS_MASTER_RLD, &saved_bm_rld);
+	return 0;
 }
-static void acpi_idle_bm_rld_restore(void)
+
+void acpi_processor_resume(void)
 {
 	u32 resumed_bm_rld;
 
 	acpi_read_bit_register(ACPI_BITREG_BUS_MASTER_RLD, &resumed_bm_rld);
+	if (resumed_bm_rld == saved_bm_rld)
+		return;
 
-	if (resumed_bm_rld != saved_bm_rld)
-		acpi_write_bit_register(ACPI_BITREG_BUS_MASTER_RLD, saved_bm_rld);
+	acpi_write_bit_register(ACPI_BITREG_BUS_MASTER_RLD, saved_bm_rld);
 }
 
-int acpi_processor_suspend(struct device *dev)
+static struct syscore_ops acpi_processor_syscore_ops = {
+	.suspend = acpi_processor_suspend,
+	.resume = acpi_processor_resume,
+};
+
+void acpi_processor_syscore_init(void)
 {
-	acpi_idle_bm_rld_save();
-	return 0;
+	register_syscore_ops(&acpi_processor_syscore_ops);
 }
 
-int acpi_processor_resume(struct device *dev)
+void acpi_processor_syscore_exit(void)
 {
-	acpi_idle_bm_rld_restore();
-	return 0;
+	unregister_syscore_ops(&acpi_processor_syscore_ops);
 }
+#endif /* CONFIG_PM_SLEEP */
 
 #if defined(CONFIG_X86)
 static void tsc_check_state(int state)
Index: linux-pm/include/acpi/processor.h
===================================================================
--- linux-pm.orig/include/acpi/processor.h
+++ linux-pm/include/acpi/processor.h
@@ -329,10 +329,16 @@ int acpi_processor_power_init(struct acp
 int acpi_processor_power_exit(struct acpi_processor *pr);
 int acpi_processor_cst_has_changed(struct acpi_processor *pr);
 int acpi_processor_hotplug(struct acpi_processor *pr);
-int acpi_processor_suspend(struct device *dev);
-int acpi_processor_resume(struct device *dev);
 extern struct cpuidle_driver acpi_idle_driver;
 
+#ifdef CONFIG_PM_SLEEP
+void acpi_processor_syscore_init(void);
+void acpi_processor_syscore_exit(void);
+#else
+static inline void acpi_processor_syscore_init(void) {}
+static inline void acpi_processor_syscore_exit(void) {}
+#endif
+
 /* in processor_thermal.c */
 int acpi_processor_get_limit_info(struct acpi_processor *pr);
 extern const struct thermal_cooling_device_ops processor_cooling_ops;

