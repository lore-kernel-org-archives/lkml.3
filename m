Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab3FNMYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:24:22 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37239 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab3FNMYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:24:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, Lan Tianyu <tianyu.lan@intel.com>
Subject: [PATCH 1/4] ACPI / PM: Rename function acpi_device_power_state() and make it static
Date: Fri, 14 Jun 2013 14:31:12 +0200
Message-ID: <35164110.EN5eTxIiVZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <6895318.cKDBc4OdI0@vostro.rjw.lan>
References: <6895318.cKDBc4OdI0@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

There is a name clash between function acpi_device_power_state()
defined in drivers/acpi/device_pm.c and structure data type
acpi_device_power_state defined in include/acpi/acpi_bus.h, which
may be resolved by renaming the function.  Additionally, that
funtion may be made static, because it is not used anywhere outside
of the file it is defined in.

Rename acpi_device_power_state() to acpi_dev_pm_get_state(), which
better reflects its purpose, and make it static.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   15 +++++++--------
 include/acpi/acpi_bus.h  |   16 ++--------------
 2 files changed, 9 insertions(+), 22 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -460,8 +460,6 @@ acpi_status acpi_add_pm_notifier(struct
 				 acpi_notify_handler handler, void *context);
 acpi_status acpi_remove_pm_notifier(struct acpi_device *adev,
 				    acpi_notify_handler handler);
-int acpi_device_power_state(struct device *dev, struct acpi_device *adev,
-			    u32 target_state, int d_max_in, int *d_min_p);
 int acpi_pm_device_sleep_state(struct device *, int *, int);
 void acpi_dev_pm_add_dependent(acpi_handle handle, struct device *depdev);
 void acpi_dev_pm_remove_dependent(acpi_handle handle, struct device *depdev);
@@ -477,23 +475,13 @@ static inline acpi_status acpi_remove_pm
 {
 	return AE_SUPPORT;
 }
-static inline int __acpi_device_power_state(int m, int *p)
+static inline int acpi_pm_device_sleep_state(struct device *d, int *p, int m)
 {
 	if (p)
 		*p = ACPI_STATE_D0;
+
 	return (m >= ACPI_STATE_D0 && m <= ACPI_STATE_D3) ? m : ACPI_STATE_D0;
 }
-static inline int acpi_device_power_state(struct device *dev,
-					  struct acpi_device *adev,
-					  u32 target_state, int d_max_in,
-					  int *d_min_p)
-{
-	return __acpi_device_power_state(d_max_in, d_min_p);
-}
-static inline int acpi_pm_device_sleep_state(struct device *d, int *p, int m)
-{
-	return __acpi_device_power_state(m, p);
-}
 static inline void acpi_dev_pm_add_dependent(acpi_handle handle,
 					     struct device *depdev) {}
 static inline void acpi_dev_pm_remove_dependent(acpi_handle handle,
Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -399,7 +399,7 @@ bool acpi_bus_can_wakeup(acpi_handle han
 EXPORT_SYMBOL(acpi_bus_can_wakeup);
 
 /**
- * acpi_device_power_state - Get preferred power state of ACPI device.
+ * acpi_dev_pm_get_state - Get preferred power state of ACPI device.
  * @dev: Device whose preferred target power state to return.
  * @adev: ACPI device node corresponding to @dev.
  * @target_state: System state to match the resultant device state.
@@ -417,8 +417,8 @@ EXPORT_SYMBOL(acpi_bus_can_wakeup);
  * Callers must ensure that @dev and @adev are valid pointers and that @adev
  * actually corresponds to @dev before using this function.
  */
-int acpi_device_power_state(struct device *dev, struct acpi_device *adev,
-			    u32 target_state, int d_max_in, int *d_min_p)
+static int acpi_dev_pm_get_state(struct device *dev, struct acpi_device *adev,
+				 u32 target_state, int d_max_in, int *d_min_p)
 {
 	char acpi_method[] = "_SxD";
 	unsigned long long d_min, d_max;
@@ -501,7 +501,6 @@ int acpi_device_power_state(struct devic
 	}
 	return d_max;
 }
-EXPORT_SYMBOL_GPL(acpi_device_power_state);
 
 /**
  * acpi_pm_device_sleep_state - Get preferred power state of ACPI device.
@@ -523,8 +522,8 @@ int acpi_pm_device_sleep_state(struct de
 		return -ENODEV;
 	}
 
-	return acpi_device_power_state(dev, adev, acpi_target_system_state(),
-				       d_max_in, d_min_p);
+	return acpi_dev_pm_get_state(dev, adev, acpi_target_system_state(),
+				     d_max_in, d_min_p);
 }
 EXPORT_SYMBOL(acpi_pm_device_sleep_state);
 
@@ -680,8 +679,8 @@ static int acpi_dev_pm_low_power(struct
 	if (!acpi_device_power_manageable(adev))
 		return 0;
 
-	power_state = acpi_device_power_state(dev, adev, system_state,
-					      ACPI_STATE_D3, NULL);
+	power_state = acpi_dev_pm_get_state(dev, adev, system_state,
+					    ACPI_STATE_D3, NULL);
 	if (power_state < ACPI_STATE_D0 || power_state > ACPI_STATE_D3)
 		return -EIO;
 

