Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaBSBTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:19:46 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63336 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752180AbaBSBSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:18:33 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 3/9] ACPI / dock: Use ACPI device object pointers instead of ACPI handles
Date: Wed, 19 Feb 2014 02:28:39 +0100
Message-ID: <1833602.aFMlcGHZo2@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3011875.q18rCmXyYX@vostro.rjw.lan>
References: <3011875.q18rCmXyYX@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Rework the ACPI dock station driver to store ACPI device object
pointers instead of ACPI handles in its internal data structures.

The purpose is moslty to make subsequent simplifications possible,
but also this allows the overall code size to be reduced slightly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c                |  104 ++++++++++++++-----------------------
 drivers/pci/hotplug/acpiphp_glue.c |    6 +-
 include/acpi/acpi_drivers.h        |    4 -
 3 files changed, 47 insertions(+), 67 deletions(-)

Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -72,7 +72,7 @@ static DEFINE_MUTEX(hotplug_lock);
 
 struct dock_dependent_device {
 	struct list_head list;
-	acpi_handle handle;
+	struct acpi_device *adev;
 	const struct acpi_dock_ops *hp_ops;
 	void *hp_context;
 	unsigned int hp_refcount;
@@ -98,12 +98,13 @@ enum dock_callback_type {
  *****************************************************************************/
 /**
  * add_dock_dependent_device - associate a device with the dock station
- * @ds: The dock station
- * @handle: handle of the dependent device
+ * @ds: Dock station.
+ * @adev: Dependent ACPI device object.
  *
  * Add the dependent device to the dock's dependent device list.
  */
-static int add_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
+static int add_dock_dependent_device(struct dock_station *ds,
+				     struct acpi_device *adev)
 {
 	struct dock_dependent_device *dd;
 
@@ -111,7 +112,7 @@ static int add_dock_dependent_device(str
 	if (!dd)
 		return -ENOMEM;
 
-	dd->handle = handle;
+	dd->adev = adev;
 	INIT_LIST_HEAD(&dd->list);
 	list_add_tail(&dd->list, &ds->dependent_devices);
 
@@ -212,7 +213,7 @@ static void dock_hotplug_event(struct do
 		return;
 
 	if (cb)
-		cb(dd->handle, event, dd->hp_context);
+		cb(dd->adev->handle, event, dd->hp_context);
 
 	dock_release_hotplug(dd);
 }
@@ -231,18 +232,18 @@ static struct dock_station *find_dock_st
 /**
  * find_dock_dependent_device - get a device dependent on this dock
  * @ds: the dock station
- * @handle: the acpi_handle of the device we want
+ * @adev: ACPI device object to find.
  *
  * iterate over the dependent device list for this dock.  If the
  * dependent device matches the handle, return.
  */
 static struct dock_dependent_device *
-find_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
+find_dock_dependent_device(struct dock_station *ds, struct acpi_device *adev)
 {
 	struct dock_dependent_device *dd;
 
 	list_for_each_entry(dd, &ds->dependent_devices, list)
-		if (handle == dd->handle)
+		if (adev == dd->adev)
 			return dd;
 
 	return NULL;
@@ -252,10 +253,9 @@ void register_dock_dependent_device(stru
 				    acpi_handle dshandle)
 {
 	struct dock_station *ds = find_dock_station(dshandle);
-	acpi_handle handle = adev->handle;
 
-	if (ds && !find_dock_dependent_device(ds, handle))
-		add_dock_dependent_device(ds, handle);
+	if (ds && !find_dock_dependent_device(ds, adev))
+		add_dock_dependent_device(ds, adev);
 }
 
 /*****************************************************************************
@@ -264,24 +264,24 @@ void register_dock_dependent_device(stru
 
 /**
  * is_dock_device - see if a device is on a dock station
- * @handle: acpi handle of the device
+ * @adev: ACPI device object to check.
  *
  * If this device is either the dock station itself,
  * or is a device dependent on the dock station, then it
  * is a dock device
  */
-int is_dock_device(acpi_handle handle)
+int is_dock_device(struct acpi_device *adev)
 {
 	struct dock_station *dock_station;
 
 	if (!dock_station_count)
 		return 0;
 
-	if (acpi_dock_match(handle))
+	if (acpi_dock_match(adev->handle))
 		return 1;
 
 	list_for_each_entry(dock_station, &dock_stations, sibling)
-		if (find_dock_dependent_device(dock_station, handle))
+		if (find_dock_dependent_device(dock_station, adev))
 			return 1;
 
 	return 0;
@@ -309,43 +309,6 @@ static int dock_present(struct dock_stat
 }
 
 /**
- * dock_create_acpi_device - add new devices to acpi
- * @handle - handle of the device to add
- *
- *  This function will create a new acpi_device for the given
- *  handle if one does not exist already.  This should cause
- *  acpi to scan for drivers for the given devices, and call
- *  matching driver's add routine.
- */
-static void dock_create_acpi_device(acpi_handle handle)
-{
-	struct acpi_device *device = NULL;
-	int ret;
-
-	acpi_bus_get_device(handle, &device);
-	if (!acpi_device_enumerated(device)) {
-		ret = acpi_bus_scan(handle);
-		if (ret)
-			pr_debug("error adding bus, %x\n", -ret);
-	}
-}
-
-/**
- * dock_remove_acpi_device - remove the acpi_device struct from acpi
- * @handle - the handle of the device to remove
- *
- *  Tell acpi to remove the acpi_device.  This should cause any loaded
- *  driver to have it's remove routine called.
- */
-static void dock_remove_acpi_device(acpi_handle handle)
-{
-	struct acpi_device *device;
-
-	if (!acpi_bus_get_device(handle, &device))
-		acpi_bus_trim(device);
-}
-
-/**
  * hot_remove_dock_devices - Remove dock station devices.
  * @ds: Dock station.
  */
@@ -362,7 +325,7 @@ static void hot_remove_dock_devices(stru
 		dock_hotplug_event(dd, ACPI_NOTIFY_EJECT_REQUEST, false);
 
 	list_for_each_entry_reverse(dd, &ds->dependent_devices, list)
-		dock_remove_acpi_device(dd->handle);
+		acpi_bus_trim(dd->adev);
 }
 
 /**
@@ -388,12 +351,20 @@ static void hotplug_dock_devices(struct
 		dock_hotplug_event(dd, event, DOCK_CALL_HANDLER);
 
 	/*
-	 * Now make sure that an acpi_device is created for each dependent
-	 * device.  That will cause scan handlers to be attached to device
-	 * objects or acpi_drivers to be stopped/started if they are present.
+	 * Check if all devices have been enumerated already.  If not, run
+	 * acpi_bus_scan() for them and that will cause scan handlers to be
+	 * attached to device objects or acpi_drivers to be stopped/started if
+	 * they are present.
 	 */
-	list_for_each_entry(dd, &ds->dependent_devices, list)
-		dock_create_acpi_device(dd->handle);
+	list_for_each_entry(dd, &ds->dependent_devices, list) {
+		struct acpi_device *adev = dd->adev;
+
+		if (!acpi_device_enumerated(adev)) {
+			int ret = acpi_bus_scan(adev->handle);
+			if (ret)
+				dev_dbg(&adev->dev, "scan error %d\n", -ret);
+		}
+	}
 }
 
 static void dock_event(struct dock_station *ds, u32 event, int num)
@@ -514,6 +485,7 @@ int register_hotplug_dock_device(acpi_ha
 {
 	struct dock_dependent_device *dd;
 	struct dock_station *dock_station;
+	struct acpi_device *adev;
 	int ret = -EINVAL;
 
 	if (WARN_ON(!context))
@@ -522,6 +494,10 @@ int register_hotplug_dock_device(acpi_ha
 	if (!dock_station_count)
 		return -ENODEV;
 
+	ret = acpi_bus_get_device(handle, &adev);
+	if (ret)
+		return ret;
+
 	/*
 	 * make sure this handle is for a device dependent on the dock,
 	 * this would include the dock station itself
@@ -532,7 +508,7 @@ int register_hotplug_dock_device(acpi_ha
 		 * separately, so there are two 'dock stations' which need the
 		 * ops
 		 */
-		dd = find_dock_dependent_device(dock_station, handle);
+		dd = find_dock_dependent_device(dock_station, adev);
 		if (dd && !dock_init_hotplug(dd, ops, context, init, release))
 			ret = 0;
 	}
@@ -549,12 +525,16 @@ void unregister_hotplug_dock_device(acpi
 {
 	struct dock_dependent_device *dd;
 	struct dock_station *dock_station;
+	struct acpi_device *adev;
 
 	if (!dock_station_count)
 		return;
 
+	if (acpi_bus_get_device(handle, &adev))
+		return;
+
 	list_for_each_entry(dock_station, &dock_stations, sibling) {
-		dd = find_dock_dependent_device(dock_station, handle);
+		dd = find_dock_dependent_device(dock_station, adev);
 		if (dd)
 			dock_release_hotplug(dd);
 	}
@@ -807,7 +787,7 @@ void acpi_dock_add(struct acpi_device *a
 		goto err_unregister;
 
 	/* add the dock station as a device dependent on itself */
-	ret = add_dock_dependent_device(dock_station, handle);
+	ret = add_dock_dependent_device(dock_station, adev);
 	if (ret)
 		goto err_rmgroup;
 
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -334,7 +334,7 @@ static acpi_status acpiphp_add_context(a
 	 * by the native PCIe hotplug (PCIeHP), becuase that code is supposed to
 	 * expose slots to user space in those cases.
 	 */
-	if ((acpi_pci_check_ejectable(pbus, handle) || is_dock_device(handle))
+	if ((acpi_pci_check_ejectable(pbus, handle) || is_dock_device(adev))
 	    && !(pdev && device_is_managed_by_native_pciehp(pdev))) {
 		unsigned long long sun;
 		int retval;
@@ -369,7 +369,7 @@ static acpi_status acpiphp_add_context(a
 				       &val, 60*1000))
 		slot->flags |= SLOT_ENABLED;
 
-	if (is_dock_device(handle)) {
+	if (is_dock_device(adev)) {
 		/* we don't want to call this device's _EJ0
 		 * because we want the dock notify handler
 		 * to call it after it calls _DCK
@@ -411,7 +411,7 @@ static void cleanup_bridge(struct acpiph
 		list_for_each_entry(func, &slot->funcs, sibling) {
 			struct acpi_device *adev = func_to_acpi_device(func);
 
-			if (is_dock_device(adev->handle))
+			if (is_dock_device(adev))
 				unregister_hotplug_dock_device(adev->handle);
 
 			acpi_lock_hp_context();
Index: linux-pm/include/acpi/acpi_drivers.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_drivers.h
+++ linux-pm/include/acpi/acpi_drivers.h
@@ -116,7 +116,7 @@ struct acpi_dock_ops {
 };
 
 #ifdef CONFIG_ACPI_DOCK
-extern int is_dock_device(acpi_handle handle);
+extern int is_dock_device(struct acpi_device *adev);
 extern int register_hotplug_dock_device(acpi_handle handle,
 					const struct acpi_dock_ops *ops,
 					void *context,
@@ -124,7 +124,7 @@ extern int register_hotplug_dock_device(
 					void (*release)(void *));
 extern void unregister_hotplug_dock_device(acpi_handle handle);
 #else
-static inline int is_dock_device(acpi_handle handle)
+static inline int is_dock_device(struct acpi_device *adev)
 {
 	return 0;
 }

