Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaGTG7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 02:59:17 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53090 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751164AbaGTG7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 02:59:15 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [Update][PATCH 1/2] ACPI / PM: Always enable wakeup GPEs when enabling device wakeup
Date: Sun, 20 Jul 2014 09:17:33 +0200
Message-ID: <7670400.0LUVFHKPfm@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1617640.X0G82q0eFI@vostro.rjw.lan>
References: <1907495.agrCMfRsQN@vostro.rjw.lan> <1617640.X0G82q0eFI@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Wakeup GPEs are currently only enabled when setting up devices for
remote wakeup at run time.  During system-wide transitions they are
enabled by ACPICA at the very last stage of suspend (before asking
the BIOS to take over).  Of course, that only works for system
sleep states supported by ACPI, so in particular it doesn't work
for the "freeze" sleep state.

For this reason, modify the ACPI core device PM code to enable wakeup
GPEs for devices when setting them up for wakeup regardless of whether
that is remote wakeup at runtime or system wakeup.  That allows the
same device wakeup setup routine to be used for both runtime PM and
system-wide PM and makes it possible to reduce code size quite a bit.

That should make things like ACPI-based PCI Wake-on-LAN work with
the "freeze" sleep state among other things.

Tested-on: Toshiba Portege R500
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

The acpi_target_sleep_state() check in acpi_wakeup_device() would not cover
the "freeze" sleep state, so instead use pm_request_resume() for resuming
the device in there which defers the runtime resume until after system
suspend-resume is complete.

---
 drivers/acpi/device_pm.c |   83 ++++++++++++++++++++---------------------------
 include/acpi/acpi_bus.h  |   11 ------
 2 files changed, 37 insertions(+), 57 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -600,26 +600,10 @@ int acpi_pm_device_sleep_state(struct de
 }
 EXPORT_SYMBOL(acpi_pm_device_sleep_state);
 
-#ifdef CONFIG_PM_RUNTIME
-/**
- * acpi_wakeup_device - Wakeup notification handler for ACPI devices.
- * @handle: ACPI handle of the device the notification is for.
- * @event: Type of the signaled event.
- * @context: Device corresponding to @handle.
- */
-static void acpi_wakeup_device(acpi_handle handle, u32 event, void *context)
-{
-	struct device *dev = context;
-
-	if (event == ACPI_NOTIFY_DEVICE_WAKE && dev) {
-		pm_wakeup_event(dev, 0);
-		pm_runtime_resume(dev);
-	}
-}
-
 /**
- * __acpi_device_run_wake - Enable/disable runtime remote wakeup for device.
- * @adev: ACPI device to enable/disable the remote wakeup for.
+ * acpi_device_wakeup - Enable/disable wakeup functionality for device.
+ * @adev: ACPI device to enable/disable wakeup functionality for.
+ * @target_state: State the system is transitioning into.
  * @enable: Whether to enable or disable the wakeup functionality.
  *
  * Enable/disable the GPE associated with @adev so that it can generate
@@ -629,7 +613,8 @@ static void acpi_wakeup_device(acpi_hand
  * Callers must ensure that @adev is a valid ACPI device node before executing
  * this function.
  */
-int __acpi_device_run_wake(struct acpi_device *adev, bool enable)
+static int acpi_device_wakeup(struct acpi_device *adev, u32 target_state,
+			      bool enable)
 {
 	struct acpi_device_wakeup *wakeup = &adev->wakeup;
 
@@ -637,7 +622,7 @@ int __acpi_device_run_wake(struct acpi_d
 		acpi_status res;
 		int error;
 
-		error = acpi_enable_wakeup_device_power(adev, ACPI_STATE_S0);
+		error = acpi_enable_wakeup_device_power(adev, target_state);
 		if (error)
 			return error;
 
@@ -653,6 +638,27 @@ int __acpi_device_run_wake(struct acpi_d
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
+/**
+ * acpi_wakeup_device - Wakeup notification handler for ACPI devices.
+ * @handle: ACPI handle of the device the notification is for.
+ * @event: Type of the signaled event.
+ * @context: Device corresponding to @handle.
+ */
+static void acpi_wakeup_device(acpi_handle handle, u32 event, void *context)
+{
+	struct device *dev = context;
+
+	if (event == ACPI_NOTIFY_DEVICE_WAKE && dev) {
+		pm_wakeup_event(dev, 0);
+		/*
+		 * Use the PM workqueue to avoid running the runtime resume
+		 * callback during system suspend which may not be appropriate.
+		 */
+		pm_request_resume(dev);
+	}
+}
+
 /**
  * acpi_pm_device_run_wake - Enable/disable remote wakeup for given device.
  * @dev: Device to enable/disable the platform to wake up.
@@ -673,7 +679,7 @@ int acpi_pm_device_run_wake(struct devic
 		return -ENODEV;
 	}
 
-	return __acpi_device_run_wake(adev, enable);
+	return acpi_device_wakeup(adev, enable, ACPI_STATE_S0);
 }
 EXPORT_SYMBOL(acpi_pm_device_run_wake);
 #else
@@ -683,20 +689,6 @@ static inline void acpi_wakeup_device(ac
 
 #ifdef CONFIG_PM_SLEEP
 /**
- * __acpi_device_sleep_wake - Enable or disable device to wake up the system.
- * @dev: Device to enable/desible to wake up the system.
- * @target_state: System state the device is supposed to wake up from.
- * @enable: Whether to enable or disable @dev to wake up the system.
- */
-int __acpi_device_sleep_wake(struct acpi_device *adev, u32 target_state,
-			     bool enable)
-{
-	return enable ?
-		acpi_enable_wakeup_device_power(adev, target_state) :
-		acpi_disable_wakeup_device_power(adev);
-}
-
-/**
  * acpi_pm_device_sleep_wake - Enable or disable device to wake up the system.
  * @dev: Device to enable/desible to wake up the system from sleep states.
  * @enable: Whether to enable or disable @dev to wake up the system.
@@ -716,8 +708,7 @@ int acpi_pm_device_sleep_wake(struct dev
 		return -ENODEV;
 	}
 
-	error = __acpi_device_sleep_wake(adev, acpi_target_system_state(),
-					 enable);
+	error = acpi_device_wakeup(adev, acpi_target_system_state(), enable);
 	if (!error)
 		dev_info(dev, "System wakeup %s by ACPI\n",
 				enable ? "enabled" : "disabled");
@@ -775,13 +766,13 @@ int acpi_dev_runtime_suspend(struct devi
 
 	remote_wakeup = dev_pm_qos_flags(dev, PM_QOS_FLAG_REMOTE_WAKEUP) >
 				PM_QOS_FLAGS_NONE;
-	error = __acpi_device_run_wake(adev, remote_wakeup);
+	error = acpi_device_wakeup(adev, ACPI_STATE_S0, remote_wakeup);
 	if (remote_wakeup && error)
 		return -EAGAIN;
 
 	error = acpi_dev_pm_low_power(dev, adev, ACPI_STATE_S0);
 	if (error)
-		__acpi_device_run_wake(adev, false);
+		acpi_device_wakeup(adev, ACPI_STATE_S0, false);
 
 	return error;
 }
@@ -804,7 +795,7 @@ int acpi_dev_runtime_resume(struct devic
 		return 0;
 
 	error = acpi_dev_pm_full_power(adev);
-	__acpi_device_run_wake(adev, false);
+	acpi_device_wakeup(adev, ACPI_STATE_S0, false);
 	return error;
 }
 EXPORT_SYMBOL_GPL(acpi_dev_runtime_resume);
@@ -860,13 +851,13 @@ int acpi_dev_suspend_late(struct device
 
 	target_state = acpi_target_system_state();
 	wakeup = device_may_wakeup(dev);
-	error = __acpi_device_sleep_wake(adev, target_state, wakeup);
+	error = acpi_device_wakeup(adev, target_state, wakeup);
 	if (wakeup && error)
 		return error;
 
 	error = acpi_dev_pm_low_power(dev, adev, target_state);
 	if (error)
-		__acpi_device_sleep_wake(adev, ACPI_STATE_UNKNOWN, false);
+		acpi_device_wakeup(adev, ACPI_STATE_UNKNOWN, false);
 
 	return error;
 }
@@ -889,7 +880,7 @@ int acpi_dev_resume_early(struct device
 		return 0;
 
 	error = acpi_dev_pm_full_power(adev);
-	__acpi_device_sleep_wake(adev, ACPI_STATE_UNKNOWN, false);
+	acpi_device_wakeup(adev, ACPI_STATE_UNKNOWN, false);
 	return error;
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resume_early);
@@ -1052,7 +1043,7 @@ int acpi_dev_pm_attach(struct device *de
 	dev->pm_domain = &acpi_general_pm_domain;
 	if (power_on) {
 		acpi_dev_pm_full_power(adev);
-		__acpi_device_run_wake(adev, false);
+		acpi_device_wakeup(adev, ACPI_STATE_S0, false);
 	}
 	return 0;
 }
@@ -1086,7 +1077,7 @@ void acpi_dev_pm_detach(struct device *d
 			 */
 			dev_pm_qos_hide_latency_limit(dev);
 			dev_pm_qos_hide_flags(dev);
-			__acpi_device_run_wake(adev, false);
+			acpi_device_wakeup(adev, ACPI_STATE_S0, false);
 			acpi_dev_pm_low_power(dev, adev, ACPI_STATE_S0);
 		}
 	}
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -532,13 +532,8 @@ static inline int acpi_pm_device_sleep_s
 #endif
 
 #ifdef CONFIG_PM_RUNTIME
-int __acpi_device_run_wake(struct acpi_device *, bool);
 int acpi_pm_device_run_wake(struct device *, bool);
 #else
-static inline int __acpi_device_run_wake(struct acpi_device *adev, bool en)
-{
-	return -ENODEV;
-}
 static inline int acpi_pm_device_run_wake(struct device *dev, bool enable)
 {
 	return -ENODEV;
@@ -546,14 +541,8 @@ static inline int acpi_pm_device_run_wak
 #endif
 
 #ifdef CONFIG_PM_SLEEP
-int __acpi_device_sleep_wake(struct acpi_device *, u32, bool);
 int acpi_pm_device_sleep_wake(struct device *, bool);
 #else
-static inline int __acpi_device_sleep_wake(struct acpi_device *adev,
-					   u32 target_state, bool enable)
-{
-	return -ENODEV;
-}
 static inline int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
 {
 	return -ENODEV;

