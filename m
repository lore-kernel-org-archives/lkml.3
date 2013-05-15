Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3EOWzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 18:55:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49838 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab3EOWzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 18:55:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH] ACPI / PM: Allow device power states to be used for CONFIG_PM unset
Date: Thu, 16 May 2013 01:04:27 +0200
Message-ID: <6756211.Qs5Byrr4Re@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Currently, drivers/acpi/device_pm.c depends on CONFIG_PM and all of
the functions defined in there are replaced with static inline stubs
if that option is unset.  However, CONFIG_PM means, roughly, "runtime
PM or suspend/hibernation support" and some of those functions are
useful regardless of that.  For example, they are used by the ACPI
fan driver for controlling fans and acpi_device_set_power() is called
during device removal.  Moreover, device initialization may depend on
setting device power states properly.

For these reasons, make the routines manipulating ACPI device power
states defined in drivers/acpi/device_pm.c available for CONFIG_PM
unset too.

Reported-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/Makefile    |    2 
 drivers/acpi/device_pm.c |  126 +++++++++++++++++++++++------------------------
 include/acpi/acpi_bus.h  |   40 +-------------
 3 files changed, 70 insertions(+), 98 deletions(-)

Index: linux-pm/drivers/acpi/Makefile
===================================================================
--- linux-pm.orig/drivers/acpi/Makefile
+++ linux-pm/drivers/acpi/Makefile
@@ -24,7 +24,7 @@ acpi-y				+= nvs.o
 # Power management related files
 acpi-y				+= wakeup.o
 acpi-y				+= sleep.o
-acpi-$(CONFIG_PM)		+= device_pm.o
+acpi-y				+= device_pm.o
 acpi-$(CONFIG_ACPI_SLEEP)	+= proc.o
 
 
Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -37,68 +37,6 @@
 #define _COMPONENT	ACPI_POWER_COMPONENT
 ACPI_MODULE_NAME("device_pm");
 
-static DEFINE_MUTEX(acpi_pm_notifier_lock);
-
-/**
- * acpi_add_pm_notifier - Register PM notifier for given ACPI device.
- * @adev: ACPI device to add the notifier for.
- * @context: Context information to pass to the notifier routine.
- *
- * NOTE: @adev need not be a run-wake or wakeup device to be a valid source of
- * PM wakeup events.  For example, wakeup events may be generated for bridges
- * if one of the devices below the bridge is signaling wakeup, even if the
- * bridge itself doesn't have a wakeup GPE associated with it.
- */
-acpi_status acpi_add_pm_notifier(struct acpi_device *adev,
-				 acpi_notify_handler handler, void *context)
-{
-	acpi_status status = AE_ALREADY_EXISTS;
-
-	mutex_lock(&acpi_pm_notifier_lock);
-
-	if (adev->wakeup.flags.notifier_present)
-		goto out;
-
-	status = acpi_install_notify_handler(adev->handle,
-					     ACPI_SYSTEM_NOTIFY,
-					     handler, context);
-	if (ACPI_FAILURE(status))
-		goto out;
-
-	adev->wakeup.flags.notifier_present = true;
-
- out:
-	mutex_unlock(&acpi_pm_notifier_lock);
-	return status;
-}
-
-/**
- * acpi_remove_pm_notifier - Unregister PM notifier from given ACPI device.
- * @adev: ACPI device to remove the notifier from.
- */
-acpi_status acpi_remove_pm_notifier(struct acpi_device *adev,
-				    acpi_notify_handler handler)
-{
-	acpi_status status = AE_BAD_PARAMETER;
-
-	mutex_lock(&acpi_pm_notifier_lock);
-
-	if (!adev->wakeup.flags.notifier_present)
-		goto out;
-
-	status = acpi_remove_notify_handler(adev->handle,
-					    ACPI_SYSTEM_NOTIFY,
-					    handler);
-	if (ACPI_FAILURE(status))
-		goto out;
-
-	adev->wakeup.flags.notifier_present = false;
-
- out:
-	mutex_unlock(&acpi_pm_notifier_lock);
-	return status;
-}
-
 /**
  * acpi_power_state_string - String representation of ACPI device power state.
  * @state: ACPI device power state to return the string representation of.
@@ -385,6 +323,69 @@ bool acpi_bus_power_manageable(acpi_hand
 }
 EXPORT_SYMBOL(acpi_bus_power_manageable);
 
+#ifdef CONFIG_PM
+static DEFINE_MUTEX(acpi_pm_notifier_lock);
+
+/**
+ * acpi_add_pm_notifier - Register PM notifier for given ACPI device.
+ * @adev: ACPI device to add the notifier for.
+ * @context: Context information to pass to the notifier routine.
+ *
+ * NOTE: @adev need not be a run-wake or wakeup device to be a valid source of
+ * PM wakeup events.  For example, wakeup events may be generated for bridges
+ * if one of the devices below the bridge is signaling wakeup, even if the
+ * bridge itself doesn't have a wakeup GPE associated with it.
+ */
+acpi_status acpi_add_pm_notifier(struct acpi_device *adev,
+				 acpi_notify_handler handler, void *context)
+{
+	acpi_status status = AE_ALREADY_EXISTS;
+
+	mutex_lock(&acpi_pm_notifier_lock);
+
+	if (adev->wakeup.flags.notifier_present)
+		goto out;
+
+	status = acpi_install_notify_handler(adev->handle,
+					     ACPI_SYSTEM_NOTIFY,
+					     handler, context);
+	if (ACPI_FAILURE(status))
+		goto out;
+
+	adev->wakeup.flags.notifier_present = true;
+
+ out:
+	mutex_unlock(&acpi_pm_notifier_lock);
+	return status;
+}
+
+/**
+ * acpi_remove_pm_notifier - Unregister PM notifier from given ACPI device.
+ * @adev: ACPI device to remove the notifier from.
+ */
+acpi_status acpi_remove_pm_notifier(struct acpi_device *adev,
+				    acpi_notify_handler handler)
+{
+	acpi_status status = AE_BAD_PARAMETER;
+
+	mutex_lock(&acpi_pm_notifier_lock);
+
+	if (!adev->wakeup.flags.notifier_present)
+		goto out;
+
+	status = acpi_remove_notify_handler(adev->handle,
+					    ACPI_SYSTEM_NOTIFY,
+					    handler);
+	if (ACPI_FAILURE(status))
+		goto out;
+
+	adev->wakeup.flags.notifier_present = false;
+
+ out:
+	mutex_unlock(&acpi_pm_notifier_lock);
+	return status;
+}
+
 bool acpi_bus_can_wakeup(acpi_handle handle)
 {
 	struct acpi_device *device;
@@ -1023,3 +1024,4 @@ void acpi_dev_pm_remove_dependent(acpi_h
 	mutex_unlock(&adev->physical_node_lock);
 }
 EXPORT_SYMBOL_GPL(acpi_dev_pm_remove_dependent);
+#endif /* CONFIG_PM */
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -370,7 +370,6 @@ acpi_status acpi_bus_get_status_handle(a
 				       unsigned long long *sta);
 int acpi_bus_get_status(struct acpi_device *device);
 
-#ifdef CONFIG_PM
 int acpi_bus_set_power(acpi_handle handle, int state);
 const char *acpi_power_state_string(int state);
 int acpi_device_get_power(struct acpi_device *device, int *state);
@@ -378,41 +377,12 @@ int acpi_device_set_power(struct acpi_de
 int acpi_bus_init_power(struct acpi_device *device);
 int acpi_bus_update_power(acpi_handle handle, int *state_p);
 bool acpi_bus_power_manageable(acpi_handle handle);
+
+#ifdef CONFIG_PM
 bool acpi_bus_can_wakeup(acpi_handle handle);
-#else /* !CONFIG_PM */
-static inline int acpi_bus_set_power(acpi_handle handle, int state)
-{
-	return 0;
-}
-static inline const char *acpi_power_state_string(int state)
-{
-	return "D0";
-}
-static inline int acpi_device_get_power(struct acpi_device *device, int *state)
-{
-	return 0;
-}
-static inline int acpi_device_set_power(struct acpi_device *device, int state)
-{
-	return 0;
-}
-static inline int acpi_bus_init_power(struct acpi_device *device)
-{
-	return 0;
-}
-static inline int acpi_bus_update_power(acpi_handle handle, int *state_p)
-{
-	return 0;
-}
-static inline bool acpi_bus_power_manageable(acpi_handle handle)
-{
-	return false;
-}
-static inline bool acpi_bus_can_wakeup(acpi_handle handle)
-{
-	return false;
-}
-#endif /* !CONFIG_PM */
+#else
+static inline bool acpi_bus_can_wakeup(acpi_handle handle) { return false; }
+#endif
 
 #ifdef CONFIG_ACPI_PROC_EVENT
 int acpi_bus_generate_proc_event(struct acpi_device *device, u8 type, int data);

