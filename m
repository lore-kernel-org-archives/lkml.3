Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbbAUAzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:55:09 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51531 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752375AbbAUAzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:55:06 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH][v3] PCI / PM: Avoid resuming PCI devices during system suspend
Date: Wed, 21 Jan 2015 02:17:42 +0100
Message-ID: <20035664.sy5Q5n4bIK@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1520491.dCOodSBFV9@vostro.rjw.lan>
References: <1460212.bInrzeZle0@vostro.rjw.lan> <1520491.dCOodSBFV9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Commit f25c0ae2b4c4 (ACPI / PM: Avoid resuming devices in ACPI PM
domain during system suspend) modified the ACPI PM domain's system
suspend callbacks to allow devices attached to it to be left in the
runtime-suspended state during system suspend so as to optimize
the suspend process.

This was based on the general mechanism introduced by commit
aae4518b3124 (PM / sleep: Mechanism to avoid resuming runtime-suspended
devices unnecessarily).

Extend that approach to PCI devices by modifying the PCI bus type's
->prepare callback to return 1 for devices that are runtime-suspended
when it is being executed and that are in a suitable power state and
need not be resumed going forward.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

This version actually builds and need not be an RFC any more I suppose.

---
 drivers/pci/pci-acpi.c   |   17 +++++++++++++++++
 drivers/pci/pci-driver.c |   11 ++++++-----
 drivers/pci/pci.c        |   26 ++++++++++++++++++++++++++
 drivers/pci/pci.h        |    6 ++++++
 4 files changed, 55 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/pci/pci.c
===================================================================
--- linux-pm.orig/drivers/pci/pci.c
+++ linux-pm/drivers/pci/pci.c
@@ -521,6 +521,11 @@ static inline int platform_pci_run_wake(
 			pci_platform_pm->run_wake(dev, enable) : -ENODEV;
 }
 
+static inline bool platform_pci_need_resume(struct pci_dev *dev)
+{
+	return pci_platform_pm ? pci_platform_pm->need_resume(dev) : false;
+}
+
 /**
  * pci_raw_set_power_state - Use PCI PM registers to set the power state of
  *                           given PCI device
@@ -1999,6 +2004,27 @@ bool pci_dev_run_wake(struct pci_dev *de
 }
 EXPORT_SYMBOL_GPL(pci_dev_run_wake);
 
+/**
+ * pci_dev_keep_suspended - Check if the device can stay in the suspended state.
+ * @pci_dev: Device to check.
+ *
+ * Return 'true' if the device is runtime-suspended, it doesn't have to be
+ * reconfigured due to wakeup settings difference between system and runtime
+ * suspend and the current power state of it is suitable for the upcoming
+ * (system) transition.
+ */
+bool pci_dev_keep_suspended(struct pci_dev *pci_dev)
+{
+	struct device *dev = &pci_dev->dev;
+
+	if (!pm_runtime_suspended(dev)
+	    || (device_can_wakeup(dev) && !device_may_wakeup(dev))
+	    || platform_pci_need_resume(pci_dev))
+		return false;
+
+	return pci_target_state(pci_dev) == pci_dev->current_state;
+}
+
 void pci_config_pm_runtime_get(struct pci_dev *pdev)
 {
 	struct device *dev = &pdev->dev;
Index: linux-pm/drivers/pci/pci.h
===================================================================
--- linux-pm.orig/drivers/pci/pci.h
+++ linux-pm/drivers/pci/pci.h
@@ -50,6 +50,10 @@ int pci_probe_reset_function(struct pci_
  *		for given device (the device's wake-up capability has to be
  *		enabled by @sleep_wake for this feature to work)
  *
+ * @need_resume: returns 'true' if the given device (which is currently
+ *		suspended) needs to be resumed to be configured for system
+ *		wakeup.
+ *
  * If given platform is generally capable of power managing PCI devices, all of
  * these callbacks are mandatory.
  */
@@ -59,6 +63,7 @@ struct pci_platform_pm_ops {
 	pci_power_t (*choose_state)(struct pci_dev *dev);
 	int (*sleep_wake)(struct pci_dev *dev, bool enable);
 	int (*run_wake)(struct pci_dev *dev, bool enable);
+	bool (*need_resume)(struct pci_dev *dev);
 };
 
 int pci_set_platform_pm(struct pci_platform_pm_ops *ops);
@@ -67,6 +72,7 @@ void pci_power_up(struct pci_dev *dev);
 void pci_disable_enabled_device(struct pci_dev *dev);
 int pci_finish_runtime_suspend(struct pci_dev *dev);
 int __pci_pme_wakeup(struct pci_dev *dev, void *ign);
+bool pci_dev_keep_suspended(struct pci_dev *dev);
 void pci_config_pm_runtime_get(struct pci_dev *dev);
 void pci_config_pm_runtime_put(struct pci_dev *dev);
 void pci_pm_init(struct pci_dev *dev);
Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -501,12 +501,29 @@ static int acpi_pci_run_wake(struct pci_
 	return 0;
 }
 
+static bool acpi_pci_need_resume(struct pci_dev *dev)
+{
+	struct acpi_device *adev = ACPI_COMPANION(&dev->dev);
+
+	if (!adev || !acpi_device_power_manageable(adev))
+		return false;
+
+	if (device_may_wakeup(&dev->dev) != !!adev->wakeup.prepare_count)
+		return true;
+
+	if (acpi_target_system_state() == ACPI_STATE_S0)
+		return false;
+
+	return !!adev->power.flags.dsw_present;
+}
+
 static struct pci_platform_pm_ops acpi_pci_platform_pm = {
 	.is_manageable = acpi_pci_power_manageable,
 	.set_state = acpi_pci_set_power_state,
 	.choose_state = acpi_pci_choose_state,
 	.sleep_wake = acpi_pci_sleep_wake,
 	.run_wake = acpi_pci_run_wake,
+	.need_resume = acpi_pci_need_resume,
 };
 
 void acpi_pci_add_bus(struct pci_bus *bus)
Index: linux-pm/drivers/pci/pci-driver.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-driver.c
+++ linux-pm/drivers/pci/pci-driver.c
@@ -653,7 +653,6 @@ static bool pci_has_legacy_pm_support(st
 static int pci_pm_prepare(struct device *dev)
 {
 	struct device_driver *drv = dev->driver;
-	int error = 0;
 
 	/*
 	 * Devices having power.ignore_children set may still be necessary for
@@ -662,10 +661,12 @@ static int pci_pm_prepare(struct device
 	if (dev->power.ignore_children)
 		pm_runtime_resume(dev);
 
-	if (drv && drv->pm && drv->pm->prepare)
-		error = drv->pm->prepare(dev);
-
-	return error;
+	if (drv && drv->pm && drv->pm->prepare) {
+		int error = drv->pm->prepare(dev);
+		if (error)
+			return error;
+	}
+	return pci_dev_keep_suspended(to_pci_dev(dev));
 }
 
 

