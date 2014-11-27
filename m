Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaK0VpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:45:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60054 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751046AbaK0VpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:45:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [Update][PATCH 3/4] ACPI / PM: Drop CONFIG_PM_RUNTIME from the ACPI core
Date: Thu, 27 Nov 2014 23:06:35 +0100
Message-ID: <1861012.tSNCe7tbeK@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2305225.e81AdzJbgi@vostro.rjw.lan>
References: <37310416.jZXoh5nfSC@vostro.rjw.lan> <2305225.e81AdzJbgi@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / PM: Drop CONFIG_PM_RUNTIME from the ACPI core

After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
selected) PM_RUNTIME is always set if PM is set, so quite a few
#ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
depend on CONFIG_PM.

Replace CONFIG_PM_RUNTIME with CONFIG_PM in the ACPI core code.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

I missed include/acpi/acpi_bus.h in the previous version.

---
 drivers/acpi/acpi_lpss.c |    4 +---
 drivers/acpi/device_pm.c |    8 ++------
 drivers/acpi/pci_irq.c   |    2 +-
 include/acpi/acpi_bus.h  |    6 +-----
 include/linux/acpi.h     |   26 +++++++++++---------------
 5 files changed, 16 insertions(+), 30 deletions(-)

Index: linux-pm/drivers/acpi/acpi_lpss.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_lpss.c
+++ linux-pm/drivers/acpi/acpi_lpss.c
@@ -588,7 +588,6 @@ static int acpi_lpss_resume_early(struct
 }
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_PM_RUNTIME
 static int acpi_lpss_runtime_suspend(struct device *dev)
 {
 	struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
@@ -631,11 +630,11 @@ static int acpi_lpss_runtime_resume(stru
 
 	return pm_generic_runtime_resume(dev);
 }
-#endif /* CONFIG_PM_RUNTIME */
 #endif /* CONFIG_PM */
 
 static struct dev_pm_domain acpi_lpss_pm_domain = {
 	.ops = {
+#ifdef CONFIG_PM
 #ifdef CONFIG_PM_SLEEP
 		.prepare = acpi_subsys_prepare,
 		.complete = acpi_subsys_complete,
@@ -647,7 +646,6 @@ static struct dev_pm_domain acpi_lpss_pm
 		.poweroff_late = acpi_lpss_suspend_late,
 		.restore_early = acpi_lpss_resume_early,
 #endif
-#ifdef CONFIG_PM_RUNTIME
 		.runtime_suspend = acpi_lpss_runtime_suspend,
 		.runtime_resume = acpi_lpss_runtime_resume,
 #endif
Index: linux-pm/drivers/acpi/pci_irq.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_irq.c
+++ linux-pm/drivers/acpi/pci_irq.c
@@ -484,7 +484,7 @@ void acpi_pci_irq_disable(struct pci_dev
 	/* Keep IOAPIC pin configuration when suspending */
 	if (dev->dev.power.is_prepared)
 		return;
-#ifdef	CONFIG_PM_RUNTIME
+#ifdef	CONFIG_PM
 	if (dev->dev.power.runtime_status == RPM_SUSPENDING)
 		return;
 #endif
Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -692,7 +692,6 @@ static int acpi_device_wakeup(struct acp
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
 /**
  * acpi_pm_device_run_wake - Enable/disable remote wakeup for given device.
  * @dev: Device to enable/disable the platform to wake up.
@@ -714,7 +713,6 @@ int acpi_pm_device_run_wake(struct devic
 	return acpi_device_wakeup(adev, ACPI_STATE_S0, enable);
 }
 EXPORT_SYMBOL(acpi_pm_device_run_wake);
-#endif /* CONFIG_PM_RUNTIME */
 
 #ifdef CONFIG_PM_SLEEP
 /**
@@ -773,7 +771,6 @@ static int acpi_dev_pm_full_power(struct
 		acpi_device_set_power(adev, ACPI_STATE_D0) : 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
 /**
  * acpi_dev_runtime_suspend - Put device into a low-power state using ACPI.
  * @dev: Device to put into a low-power state.
@@ -855,7 +852,6 @@ int acpi_subsys_runtime_resume(struct de
 	return ret ? ret : pm_generic_runtime_resume(dev);
 }
 EXPORT_SYMBOL_GPL(acpi_subsys_runtime_resume);
-#endif /* CONFIG_PM_RUNTIME */
 
 #ifdef CONFIG_PM_SLEEP
 /**
@@ -1023,10 +1019,9 @@ EXPORT_SYMBOL_GPL(acpi_subsys_freeze);
 
 static struct dev_pm_domain acpi_general_pm_domain = {
 	.ops = {
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 		.runtime_suspend = acpi_subsys_runtime_suspend,
 		.runtime_resume = acpi_subsys_runtime_resume,
-#endif
 #ifdef CONFIG_PM_SLEEP
 		.prepare = acpi_subsys_prepare,
 		.complete = acpi_subsys_complete,
@@ -1038,6 +1033,7 @@ static struct dev_pm_domain acpi_general
 		.poweroff_late = acpi_subsys_suspend_late,
 		.restore_early = acpi_subsys_resume_early,
 #endif
+#endif
 	},
 };
 
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -567,16 +567,26 @@ static inline void arch_reserve_mem_area
 #define acpi_os_set_prepare_sleep(func, pm1a_ctrl, pm1b_ctrl) do { } while (0)
 #endif
 
-#if defined(CONFIG_ACPI) && defined(CONFIG_PM_RUNTIME)
+#if defined(CONFIG_ACPI) && defined(CONFIG_PM)
 int acpi_dev_runtime_suspend(struct device *dev);
 int acpi_dev_runtime_resume(struct device *dev);
 int acpi_subsys_runtime_suspend(struct device *dev);
 int acpi_subsys_runtime_resume(struct device *dev);
+struct acpi_device *acpi_dev_pm_get_node(struct device *dev);
+int acpi_dev_pm_attach(struct device *dev, bool power_on);
 #else
 static inline int acpi_dev_runtime_suspend(struct device *dev) { return 0; }
 static inline int acpi_dev_runtime_resume(struct device *dev) { return 0; }
 static inline int acpi_subsys_runtime_suspend(struct device *dev) { return 0; }
 static inline int acpi_subsys_runtime_resume(struct device *dev) { return 0; }
+static inline struct acpi_device *acpi_dev_pm_get_node(struct device *dev)
+{
+	return NULL;
+}
+static inline int acpi_dev_pm_attach(struct device *dev, bool power_on)
+{
+	return -ENODEV;
+}
 #endif
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_PM_SLEEP)
@@ -599,20 +609,6 @@ static inline int acpi_subsys_suspend(st
 static inline int acpi_subsys_freeze(struct device *dev) { return 0; }
 #endif
 
-#if defined(CONFIG_ACPI) && defined(CONFIG_PM)
-struct acpi_device *acpi_dev_pm_get_node(struct device *dev);
-int acpi_dev_pm_attach(struct device *dev, bool power_on);
-#else
-static inline struct acpi_device *acpi_dev_pm_get_node(struct device *dev)
-{
-	return NULL;
-}
-static inline int acpi_dev_pm_attach(struct device *dev, bool power_on)
-{
-	return -ENODEV;
-}
-#endif
-
 #ifdef CONFIG_ACPI
 __printf(3, 4)
 void acpi_handle_printk(const char *level, acpi_handle handle,
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -544,6 +544,7 @@ acpi_status acpi_add_pm_notifier(struct
 				 void (*work_func)(struct work_struct *work));
 acpi_status acpi_remove_pm_notifier(struct acpi_device *adev);
 int acpi_pm_device_sleep_state(struct device *, int *, int);
+int acpi_pm_device_run_wake(struct device *, bool);
 #else
 static inline acpi_status acpi_add_pm_notifier(struct acpi_device *adev,
 					       struct device *dev,
@@ -563,11 +564,6 @@ static inline int acpi_pm_device_sleep_s
 	return (m >= ACPI_STATE_D0 && m <= ACPI_STATE_D3_COLD) ?
 		m : ACPI_STATE_D0;
 }
-#endif
-
-#ifdef CONFIG_PM_RUNTIME
-int acpi_pm_device_run_wake(struct device *, bool);
-#else
 static inline int acpi_pm_device_run_wake(struct device *dev, bool enable)
 {
 	return -ENODEV;

