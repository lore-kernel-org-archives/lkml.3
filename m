Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaGVMLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:11:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63555 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754476AbaGVMLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:11:22 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [Update][PATCH 2/3] ACPI / PM: Revork the handling of ACPI device wakeup notifications
Date: Tue, 22 Jul 2014 14:29:42 +0200
Message-ID: <1658618.0eushJSIkF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <15452047.8SNvN9NOiv@vostro.rjw.lan>
References: <1907495.agrCMfRsQN@vostro.rjw.lan> <9631666.En3K0jlGsY@vostro.rjw.lan> <15452047.8SNvN9NOiv@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since ACPI wakeup GPEs are going to be enabled during system suspend
as well as for runtime wakeup by a subsequent patch and the same
notify handlers will be used in both cases, rework the ACPI device
wakeup notification framework so that the part specific to physical
devices is always run asynchronously from the PM workqueue.  This
prevents runtime resume callbacks for those devices from being
run during system suspend and resume which may not be appropriate,
among other things.

Also make ACPI device wakeup notification handling a bit more robust
agaist subsequent removal of ACPI device objects, whould that ever
happen, and create a wakeup source object for each ACPI device
configured for wakeup so that wakeup notifications for those
devices can wake up the system from the "freeze" sleep state.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

I noticed that acpi_pm_notify_handler() was racy with the handler
unregistration, so added locking and a check to it.

---
 drivers/acpi/device_pm.c |   80 ++++++++++++++++++++++++++++++++++-------------
 drivers/acpi/pci_root.c  |    2 -
 drivers/pci/pci-acpi.c   |   60 +++++++++++------------------------
 include/acpi/acpi_bus.h  |   21 +++++++-----
 include/linux/pci-acpi.h |   13 +++++--
 5 files changed, 101 insertions(+), 75 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -315,12 +315,19 @@ struct acpi_device_wakeup_flags {
 	u8 notifier_present:1;  /* Wake-up notify handler has been installed */
 };
 
+struct acpi_device_wakeup_context {
+	struct work_struct work;
+	struct device *dev;
+};
+
 struct acpi_device_wakeup {
 	acpi_handle gpe_device;
 	u64 gpe_number;
 	u64 sleep_state;
 	struct list_head resources;
 	struct acpi_device_wakeup_flags flags;
+	struct acpi_device_wakeup_context context;
+	struct wakeup_source *ws;
 	int prepare_count;
 };
 
@@ -504,20 +511,18 @@ int acpi_enable_wakeup_device_power(stru
 int acpi_disable_wakeup_device_power(struct acpi_device *dev);
 
 #ifdef CONFIG_PM
-acpi_status acpi_add_pm_notifier(struct acpi_device *adev,
-				 acpi_notify_handler handler, void *context);
-acpi_status acpi_remove_pm_notifier(struct acpi_device *adev,
-				    acpi_notify_handler handler);
+acpi_status acpi_add_pm_notifier(struct acpi_device *adev, struct device *dev,
+				 void (*work_func)(struct work_struct *work));
+acpi_status acpi_remove_pm_notifier(struct acpi_device *adev);
 int acpi_pm_device_sleep_state(struct device *, int *, int);
 #else
 static inline acpi_status acpi_add_pm_notifier(struct acpi_device *adev,
-					       acpi_notify_handler handler,
-					       void *context)
+					       struct device *dev,
+				               void (*work_func)(struct work_struct *work))
 {
 	return AE_SUPPORT;
 }
-static inline acpi_status acpi_remove_pm_notifier(struct acpi_device *adev,
-						  acpi_notify_handler handler)
+static inline acpi_status acpi_remove_pm_notifier(struct acpi_device *adev)
 {
 	return AE_SUPPORT;
 }
Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -367,29 +367,61 @@ EXPORT_SYMBOL(acpi_bus_power_manageable)
 #ifdef CONFIG_PM
 static DEFINE_MUTEX(acpi_pm_notifier_lock);
 
+static void acpi_pm_notify_handler(acpi_handle handle, u32 val, void *not_used)
+{
+	struct acpi_device *adev;
+
+	if (val != ACPI_NOTIFY_DEVICE_WAKE)
+		return;
+
+	adev = acpi_bus_get_acpi_device(handle);
+	if (!adev)
+		return;
+
+	mutex_lock(&acpi_pm_notifier_lock);
+
+	if (adev->wakeup.flags.notifier_present) {
+		__pm_wakeup_event(adev->wakeup.ws, 0);
+		if (adev->wakeup.context.work.func)
+			queue_pm_work(&adev->wakeup.context.work);
+	}
+
+	mutex_unlock(&acpi_pm_notifier_lock);
+
+	acpi_bus_put_acpi_device(adev);
+}
+
 /**
- * acpi_add_pm_notifier - Register PM notifier for given ACPI device.
- * @adev: ACPI device to add the notifier for.
- * @context: Context information to pass to the notifier routine.
+ * acpi_add_pm_notifier - Register PM notify handler for given ACPI device.
+ * @adev: ACPI device to add the notify handler for.
+ * @dev: Device to generate a wakeup event for while handling the notification.
+ * @work_func: Work function to execute when handling the notification.
  *
  * NOTE: @adev need not be a run-wake or wakeup device to be a valid source of
  * PM wakeup events.  For example, wakeup events may be generated for bridges
  * if one of the devices below the bridge is signaling wakeup, even if the
  * bridge itself doesn't have a wakeup GPE associated with it.
  */
-acpi_status acpi_add_pm_notifier(struct acpi_device *adev,
-				 acpi_notify_handler handler, void *context)
+acpi_status acpi_add_pm_notifier(struct acpi_device *adev, struct device *dev,
+				 void (*work_func)(struct work_struct *work))
 {
 	acpi_status status = AE_ALREADY_EXISTS;
 
+	if (!dev && !work_func)
+		return AE_BAD_PARAMETER;
+
 	mutex_lock(&acpi_pm_notifier_lock);
 
 	if (adev->wakeup.flags.notifier_present)
 		goto out;
 
-	status = acpi_install_notify_handler(adev->handle,
-					     ACPI_SYSTEM_NOTIFY,
-					     handler, context);
+	adev->wakeup.ws = wakeup_source_register(dev_name(&adev->dev));
+	adev->wakeup.context.dev = dev;
+	if (work_func)
+		INIT_WORK(&adev->wakeup.context.work, work_func);
+
+	status = acpi_install_notify_handler(adev->handle, ACPI_SYSTEM_NOTIFY,
+					     acpi_pm_notify_handler, NULL);
 	if (ACPI_FAILURE(status))
 		goto out;
 
@@ -404,8 +436,7 @@ acpi_status acpi_add_pm_notifier(struct
  * acpi_remove_pm_notifier - Unregister PM notifier from given ACPI device.
  * @adev: ACPI device to remove the notifier from.
  */
-acpi_status acpi_remove_pm_notifier(struct acpi_device *adev,
-				    acpi_notify_handler handler)
+acpi_status acpi_remove_pm_notifier(struct acpi_device *adev)
 {
 	acpi_status status = AE_BAD_PARAMETER;
 
@@ -416,10 +447,17 @@ acpi_status acpi_remove_pm_notifier(stru
 
 	status = acpi_remove_notify_handler(adev->handle,
 					    ACPI_SYSTEM_NOTIFY,
-					    handler);
+					    acpi_pm_notify_handler);
 	if (ACPI_FAILURE(status))
 		goto out;
 
+	if (adev->wakeup.context.work.func) {
+		cancel_work_sync(&adev->wakeup.context.work);
+		adev->wakeup.context.work.func = NULL;
+	}
+	adev->wakeup.context.dev = NULL;
+	wakeup_source_unregister(adev->wakeup.ws);
+
 	adev->wakeup.flags.notifier_present = false;
 
  out:
@@ -602,16 +640,15 @@ EXPORT_SYMBOL(acpi_pm_device_sleep_state
 
 #ifdef CONFIG_PM_RUNTIME
 /**
- * acpi_wakeup_device - Wakeup notification handler for ACPI devices.
- * @handle: ACPI handle of the device the notification is for.
- * @event: Type of the signaled event.
- * @context: Device corresponding to @handle.
+ * acpi_pm_notify_work_func - ACPI devices wakeup notification work function.
+ * @work: Work item to handle.
  */
-static void acpi_wakeup_device(acpi_handle handle, u32 event, void *context)
+static void acpi_pm_notify_work_func(struct work_struct *work)
 {
-	struct device *dev = context;
+	struct device *dev;
 
-	if (event == ACPI_NOTIFY_DEVICE_WAKE && dev) {
+	dev = container_of(work, struct acpi_device_wakeup_context, work)->dev;
+	if (dev) {
 		pm_wakeup_event(dev, 0);
 		pm_runtime_resume(dev);
 	}
@@ -677,8 +714,7 @@ int acpi_pm_device_run_wake(struct devic
 }
 EXPORT_SYMBOL(acpi_pm_device_run_wake);
 #else
-static inline void acpi_wakeup_device(acpi_handle handle, u32 event,
-				      void *context) {}
+static inline void acpi_pm_notify_work_func(struct work_struct *work) {}
 #endif /* CONFIG_PM_RUNTIME */
 
 #ifdef CONFIG_PM_SLEEP
@@ -1048,7 +1084,7 @@ int acpi_dev_pm_attach(struct device *de
 	if (dev->pm_domain)
 		return -EEXIST;
 
-	acpi_add_pm_notifier(adev, acpi_wakeup_device, dev);
+	acpi_add_pm_notifier(adev, dev, acpi_pm_notify_work_func);
 	dev->pm_domain = &acpi_general_pm_domain;
 	if (power_on) {
 		acpi_dev_pm_full_power(adev);
@@ -1076,7 +1112,7 @@ void acpi_dev_pm_detach(struct device *d
 
 	if (adev && dev->pm_domain == &acpi_general_pm_domain) {
 		dev->pm_domain = NULL;
-		acpi_remove_pm_notifier(adev, acpi_wakeup_device);
+		acpi_remove_pm_notifier(adev);
 		if (power_off) {
 			/*
 			 * If the device's PM QoS resume latency limit or flags
Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -18,31 +18,31 @@
 #include "pci.h"
 
 /**
- * pci_acpi_wake_bus - Wake-up notification handler for root buses.
- * @handle: ACPI handle of a device the notification is for.
- * @event: Type of the signaled event.
- * @context: PCI root bus to wake up devices on.
+ * pci_acpi_wake_bus - Root bus wakeup notification fork function.
+ * @work: Work item to handle.
  */
-static void pci_acpi_wake_bus(acpi_handle handle, u32 event, void *context)
+static void pci_acpi_wake_bus(struct work_struct *work)
 {
-	struct pci_bus *pci_bus = context;
+	struct acpi_device *adev;
+	struct acpi_pci_root *root;
 
-	if (event == ACPI_NOTIFY_DEVICE_WAKE && pci_bus)
-		pci_pme_wakeup_bus(pci_bus);
+	adev = container_of(work, struct acpi_device, wakeup.context.work);
+	root = acpi_driver_data(adev);
+	pci_pme_wakeup_bus(root->bus);
 }
 
 /**
- * pci_acpi_wake_dev - Wake-up notification handler for PCI devices.
+ * pci_acpi_wake_dev - PCI device wakeup notification work function.
  * @handle: ACPI handle of a device the notification is for.
- * @event: Type of the signaled event.
- * @context: PCI device object to wake up.
+ * @work: Work item to handle.
  */
-static void pci_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
+static void pci_acpi_wake_dev(struct work_struct *work)
 {
-	struct pci_dev *pci_dev = context;
+	struct acpi_device_wakeup_context *context;
+	struct pci_dev *pci_dev;
 
-	if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
-		return;
+	context = container_of(work, struct acpi_device_wakeup_context, work);
+	pci_dev = to_pci_dev(context->dev);
 
 	if (pci_dev->pme_poll)
 		pci_dev->pme_poll = false;
@@ -65,23 +65,12 @@ static void pci_acpi_wake_dev(acpi_handl
 }
 
 /**
- * pci_acpi_add_bus_pm_notifier - Register PM notifier for given PCI bus.
- * @dev: ACPI device to add the notifier for.
- * @pci_bus: PCI bus to walk checking for PME status if an event is signaled.
+ * pci_acpi_add_bus_pm_notifier - Register PM notifier for root PCI bus.
+ * @dev: PCI root bridge ACPI device.
  */
-acpi_status pci_acpi_add_bus_pm_notifier(struct acpi_device *dev,
-					 struct pci_bus *pci_bus)
+acpi_status pci_acpi_add_bus_pm_notifier(struct acpi_device *dev)
 {
-	return acpi_add_pm_notifier(dev, pci_acpi_wake_bus, pci_bus);
-}
-
-/**
- * pci_acpi_remove_bus_pm_notifier - Unregister PCI bus PM notifier.
- * @dev: ACPI device to remove the notifier from.
- */
-acpi_status pci_acpi_remove_bus_pm_notifier(struct acpi_device *dev)
-{
-	return acpi_remove_pm_notifier(dev, pci_acpi_wake_bus);
+	return acpi_add_pm_notifier(dev, NULL, pci_acpi_wake_bus);
 }
 
 /**
@@ -92,16 +81,7 @@ acpi_status pci_acpi_remove_bus_pm_notif
 acpi_status pci_acpi_add_pm_notifier(struct acpi_device *dev,
 				     struct pci_dev *pci_dev)
 {
-	return acpi_add_pm_notifier(dev, pci_acpi_wake_dev, pci_dev);
-}
-
-/**
- * pci_acpi_remove_pm_notifier - Unregister PCI device PM notifier.
- * @dev: ACPI device to remove the notifier from.
- */
-acpi_status pci_acpi_remove_pm_notifier(struct acpi_device *dev)
-{
-	return acpi_remove_pm_notifier(dev, pci_acpi_wake_dev);
+	return acpi_add_pm_notifier(dev, &pci_dev->dev, pci_acpi_wake_dev);
 }
 
 phys_addr_t acpi_pci_root_get_mcfg_addr(acpi_handle handle)
Index: linux-pm/include/linux/pci-acpi.h
===================================================================
--- linux-pm.orig/include/linux/pci-acpi.h
+++ linux-pm/include/linux/pci-acpi.h
@@ -11,12 +11,17 @@
 #include <linux/acpi.h>
 
 #ifdef CONFIG_ACPI
-extern acpi_status pci_acpi_add_bus_pm_notifier(struct acpi_device *dev,
-						 struct pci_bus *pci_bus);
-extern acpi_status pci_acpi_remove_bus_pm_notifier(struct acpi_device *dev);
+extern acpi_status pci_acpi_add_bus_pm_notifier(struct acpi_device *dev);
+static inline acpi_status pci_acpi_remove_bus_pm_notifier(struct acpi_device *dev)
+{
+	return acpi_remove_pm_notifier(dev);
+}
 extern acpi_status pci_acpi_add_pm_notifier(struct acpi_device *dev,
 					     struct pci_dev *pci_dev);
-extern acpi_status pci_acpi_remove_pm_notifier(struct acpi_device *dev);
+static inline acpi_status pci_acpi_remove_pm_notifier(struct acpi_device *dev)
+{
+	return acpi_remove_pm_notifier(dev);
+}
 extern phys_addr_t acpi_pci_root_get_mcfg_addr(acpi_handle handle);
 
 static inline acpi_handle acpi_find_root_bridge_handle(struct pci_dev *pdev)
Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -593,7 +593,7 @@ static int acpi_pci_root_add(struct acpi
 	if (no_aspm)
 		pcie_no_aspm();
 
-	pci_acpi_add_bus_pm_notifier(device, root->bus);
+	pci_acpi_add_bus_pm_notifier(device);
 	if (device->wakeup.flags.run_wake)
 		device_set_run_wake(root->bus->bridge, true);
 

