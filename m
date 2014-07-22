Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaGVBH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 21:07:56 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63645 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750889AbaGVBHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 21:07:51 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/3] ACPI / PM: Always enable wakeup GPEs when enabling device wakeup
Date: Tue, 22 Jul 2014 03:26:01 +0200
Message-ID: <2036304.rpZzsWCEyN@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <9631666.En3K0jlGsY@vostro.rjw.lan>
References: <1907495.agrCMfRsQN@vostro.rjw.lan> <9631666.En3K0jlGsY@vostro.rjw.lan>
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

This make ACPI-based PCI Wake-on-LAN work with the "freeze" sleep
state on my venerable Toshiba Portege R500 and should help other
systems too.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   49 ++++++++++++++++-------------------------------
 include/acpi/acpi_bus.h  |   11 ----------
 2 files changed, 17 insertions(+), 43 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -632,7 +632,6 @@ int acpi_pm_device_sleep_state(struct de
 }
 EXPORT_SYMBOL(acpi_pm_device_sleep_state);
 
-#ifdef CONFIG_PM_RUNTIME
 /**
  * acpi_pm_notify_work_func - ACPI devices wakeup notification work function.
  * @work: Work item to handle.
@@ -649,8 +648,9 @@ static void acpi_pm_notify_work_func(str
 }
 
 /**
- * __acpi_device_run_wake - Enable/disable runtime remote wakeup for device.
- * @adev: ACPI device to enable/disable the remote wakeup for.
+ * acpi_device_wakeup - Enable/disable wakeup functionality for device.
+ * @adev: ACPI device to enable/disable wakeup functionality for.
+ * @target_state: State the system is transitioning into.
  * @enable: Whether to enable or disable the wakeup functionality.
  *
  * Enable/disable the GPE associated with @adev so that it can generate
@@ -660,7 +660,8 @@ static void acpi_pm_notify_work_func(str
  * Callers must ensure that @adev is a valid ACPI device node before executing
  * this function.
  */
-int __acpi_device_run_wake(struct acpi_device *adev, bool enable)
+static int acpi_device_wakeup(struct acpi_device *adev, u32 target_state,
+			      bool enable)
 {
 	struct acpi_device_wakeup *wakeup = &adev->wakeup;
 
@@ -668,7 +669,7 @@ int __acpi_device_run_wake(struct acpi_d
 		acpi_status res;
 		int error;
 
-		error = acpi_enable_wakeup_device_power(adev, ACPI_STATE_S0);
+		error = acpi_enable_wakeup_device_power(adev, target_state);
 		if (error)
 			return error;
 
@@ -684,6 +685,7 @@ int __acpi_device_run_wake(struct acpi_d
 	return 0;
 }
 
+#ifdef CONFIG_PM_RUNTIME
 /**
  * acpi_pm_device_run_wake - Enable/disable remote wakeup for given device.
  * @dev: Device to enable/disable the platform to wake up.
@@ -704,29 +706,13 @@ int acpi_pm_device_run_wake(struct devic
 		return -ENODEV;
 	}
 
-	return __acpi_device_run_wake(adev, enable);
+	return acpi_device_wakeup(adev, enable, ACPI_STATE_S0);
 }
 EXPORT_SYMBOL(acpi_pm_device_run_wake);
-#else
-static inline void acpi_pm_notify_work_func(struct work_struct *work) {}
 #endif /* CONFIG_PM_RUNTIME */
 
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
@@ -746,8 +732,7 @@ int acpi_pm_device_sleep_wake(struct dev
 		return -ENODEV;
 	}
 
-	error = __acpi_device_sleep_wake(adev, acpi_target_system_state(),
-					 enable);
+	error = acpi_device_wakeup(adev, acpi_target_system_state(), enable);
 	if (!error)
 		dev_info(dev, "System wakeup %s by ACPI\n",
 				enable ? "enabled" : "disabled");
@@ -805,13 +790,13 @@ int acpi_dev_runtime_suspend(struct devi
 
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
@@ -834,7 +819,7 @@ int acpi_dev_runtime_resume(struct devic
 		return 0;
 
 	error = acpi_dev_pm_full_power(adev);
-	__acpi_device_run_wake(adev, false);
+	acpi_device_wakeup(adev, ACPI_STATE_S0, false);
 	return error;
 }
 EXPORT_SYMBOL_GPL(acpi_dev_runtime_resume);
@@ -890,13 +875,13 @@ int acpi_dev_suspend_late(struct device
 
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
@@ -919,7 +904,7 @@ int acpi_dev_resume_early(struct device
 		return 0;
 
 	error = acpi_dev_pm_full_power(adev);
-	__acpi_device_sleep_wake(adev, ACPI_STATE_UNKNOWN, false);
+	acpi_device_wakeup(adev, ACPI_STATE_UNKNOWN, false);
 	return error;
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resume_early);
@@ -1082,7 +1067,7 @@ int acpi_dev_pm_attach(struct device *de
 	dev->pm_domain = &acpi_general_pm_domain;
 	if (power_on) {
 		acpi_dev_pm_full_power(adev);
-		__acpi_device_run_wake(adev, false);
+		acpi_device_wakeup(adev, ACPI_STATE_S0, false);
 	}
 	return 0;
 }
@@ -1116,7 +1101,7 @@ void acpi_dev_pm_detach(struct device *d
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
@@ -537,13 +537,8 @@ static inline int acpi_pm_device_sleep_s
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
@@ -551,14 +546,8 @@ static inline int acpi_pm_device_run_wak
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

