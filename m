Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaBCXin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:38:43 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53378 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752427AbaBCX2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:20 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 23/24][Update] ACPI / hotplug / PCI: Hotplug notifications from acpi_bus_notify()
Date: Tue, 04 Feb 2014 00:40:26 +0100
Message-ID: <4319453.nrCmpQmkNH@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <7532948.aJNUotNMpR@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <20140203104408.GQ18029@intel.com> <7532948.aJNUotNMpR@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since acpi_bus_notify() is executed on all notifications for all
devices anyway, make it execute acpi_device_hotplug() for all
hotplug events instead of installing notify handlers pointing to
the same function for all hotplug devices.

This change reduces both the size and complexity of ACPI-based device
hotplug code.  Moreover, since acpi_device_hotplug() only does
significant things for devices that have either an ACPI scan handler,
or a hotplug context with .eject() defined, and those devices
had notify handlers pointing to acpi_hotplug_notify_cb() installed
before anyway, this modification shouldn't change functionality.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c                 |   61 +++++++++++++---------
 drivers/acpi/internal.h            |    1 
 drivers/acpi/scan.c                |  101 -------------------------------------
 drivers/pci/hotplug/acpiphp.h      |    1 
 drivers/pci/hotplug/acpiphp_glue.c |   24 ++++----
 include/acpi/acpi_bus.h            |    2 
 6 files changed, 53 insertions(+), 137 deletions(-)

Index: linux-pm/drivers/acpi/bus.c
===================================================================
--- linux-pm.orig/drivers/acpi/bus.c
+++ linux-pm/drivers/acpi/bus.c
@@ -340,62 +340,77 @@ static void acpi_bus_osc_support(void)
  */
 static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
 {
-	struct acpi_device *device;
+	struct acpi_device *adev;
 	struct acpi_driver *driver;
-
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Notification %#02x to handle %p\n",
-			  type, handle));
+	acpi_status status;
+	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 
 	switch (type) {
-
 	case ACPI_NOTIFY_BUS_CHECK:
-		/* TBD */
+		acpi_handle_debug(handle, "ACPI_NOTIFY_BUS_CHECK event\n");
 		break;
 
 	case ACPI_NOTIFY_DEVICE_CHECK:
-		/* TBD */
+		acpi_handle_debug(handle, "ACPI_NOTIFY_DEVICE_CHECK event\n");
 		break;
 
 	case ACPI_NOTIFY_DEVICE_WAKE:
-		/* TBD */
+		acpi_handle_debug(handle, "ACPI_NOTIFY_DEVICE_WAKE event\n");
 		break;
 
 	case ACPI_NOTIFY_EJECT_REQUEST:
-		/* TBD */
+		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
 		break;
 
 	case ACPI_NOTIFY_DEVICE_CHECK_LIGHT:
+		acpi_handle_debug(handle, "ACPI_NOTIFY_DEVICE_CHECK_LIGHT event\n");
 		/* TBD: Exactly what does 'light' mean? */
 		break;
 
 	case ACPI_NOTIFY_FREQUENCY_MISMATCH:
-		/* TBD */
+		acpi_handle_err(handle, "Device cannot be configured due "
+				"to a frequency mismatch\n");
 		break;
 
 	case ACPI_NOTIFY_BUS_MODE_MISMATCH:
-		/* TBD */
+		acpi_handle_err(handle, "Device cannot be configured due "
+				"to a bus mode mismatch\n");
 		break;
 
 	case ACPI_NOTIFY_POWER_FAULT:
-		/* TBD */
+		acpi_handle_err(handle, "Device has suffered a power fault\n");
 		break;
 
 	default:
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Received unknown/unsupported notification [%08x]\n",
-				  type));
-		break;
+		acpi_handle_warn(handle, "Unsupported event type 0x%x\n", type);
+		ost_code = ACPI_OST_SC_UNRECOGNIZED_NOTIFY;
+		goto err;
 	}
 
-	device = acpi_bus_get_acpi_device(handle);
-	if (device) {
-		driver = device->driver;
-		if (driver && driver->ops.notify &&
-		    (driver->flags & ACPI_DRIVER_ALL_NOTIFY_EVENTS))
-			driver->ops.notify(device, type);
+	adev = acpi_bus_get_acpi_device(handle);
+	if (!adev)
+		goto err;
+
+	driver = adev->driver;
+	if (driver && driver->ops.notify &&
+	    (driver->flags & ACPI_DRIVER_ALL_NOTIFY_EVENTS))
+		driver->ops.notify(adev, type);
 
-		acpi_bus_put_acpi_device(device);
+	switch (type) {
+	case ACPI_NOTIFY_BUS_CHECK:
+	case ACPI_NOTIFY_DEVICE_CHECK:
+	case ACPI_NOTIFY_EJECT_REQUEST:
+		status = acpi_hotplug_execute(acpi_device_hotplug, adev, type);
+		if (ACPI_SUCCESS(status))
+			return;
+	default:
+		break;
 	}
+	acpi_bus_put_acpi_device(adev);
+	return;
+
+ err:
+	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
 }
 
 /* --------------------------------------------------------------------------
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -73,6 +73,7 @@ static inline void acpi_lpss_init(void)
 #endif
 
 bool acpi_queue_hotplug_work(struct work_struct *work);
+void acpi_device_hotplug(void *data, u32 src);
 bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent);
 
 /* --------------------------------------------------------------------------
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -470,7 +470,7 @@ static int acpi_generic_hotplug_event(st
 	return -EINVAL;
 }
 
-static void acpi_device_hotplug(void *data, u32 src)
+void acpi_device_hotplug(void *data, u32 src)
 {
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 	struct acpi_device *adev = data;
@@ -520,75 +520,6 @@ static void acpi_device_hotplug(void *da
 	unlock_device_hotplug();
 }
 
-static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
-{
-	u32 ost_code = ACPI_OST_SC_SUCCESS;
-	struct acpi_device *adev;
-	acpi_status status;
-
-	switch (type) {
-	case ACPI_NOTIFY_BUS_CHECK:
-		acpi_handle_debug(handle, "ACPI_NOTIFY_BUS_CHECK event\n");
-		break;
-
-	case ACPI_NOTIFY_DEVICE_CHECK:
-		acpi_handle_debug(handle, "ACPI_NOTIFY_DEVICE_CHECK event\n");
-		break;
-
-	case ACPI_NOTIFY_EJECT_REQUEST:
-		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
-		break;
-
-	case ACPI_NOTIFY_DEVICE_WAKE:
-		return;
-
-	case ACPI_NOTIFY_FREQUENCY_MISMATCH:
-		acpi_handle_err(handle, "Device cannot be configured due "
-				"to a frequency mismatch\n");
-		goto out;
-
-	case ACPI_NOTIFY_BUS_MODE_MISMATCH:
-		acpi_handle_err(handle, "Device cannot be configured due "
-				"to a bus mode mismatch\n");
-		goto out;
-
-	case ACPI_NOTIFY_POWER_FAULT:
-		acpi_handle_err(handle, "Device has suffered a power fault\n");
-		goto out;
-
-	default:
-		acpi_handle_warn(handle, "Unsupported event type 0x%x\n", type);
-		ost_code = ACPI_OST_SC_UNRECOGNIZED_NOTIFY;
-		goto out;
-	}
-
-	ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
-	adev = acpi_bus_get_acpi_device(handle);
-	if (!adev)
-		goto out;
-
-	status = acpi_hotplug_execute(acpi_device_hotplug, adev, type);
-	if (ACPI_SUCCESS(status))
-		return;
-
-	acpi_bus_put_acpi_device(adev);
-
- out:
-	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
-}
-
-void acpi_install_hotplug_notify_handler(acpi_handle handle)
-{
-	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-				    acpi_hotplug_notify_cb, NULL);
-}
-
-void acpi_remove_hotplug_notify_handler(acpi_handle handle)
-{
-	acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-				   acpi_hotplug_notify_cb);
-}
-
 static ssize_t real_power_state_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
@@ -2029,34 +1960,6 @@ void acpi_scan_hotplug_enabled(struct ac
 	mutex_unlock(&acpi_scan_lock);
 }
 
-static void acpi_scan_init_hotplug(acpi_handle handle, int type)
-{
-	struct acpi_device_pnp pnp = {};
-	struct acpi_hardware_id *hwid;
-	struct acpi_scan_handler *handler;
-
-	INIT_LIST_HEAD(&pnp.ids);
-	acpi_set_pnp_ids(handle, &pnp, type);
-
-	if (!pnp.type.hardware_id)
-		goto out;
-
-	/*
-	 * This relies on the fact that acpi_install_notify_handler() will not
-	 * install the same notify handler routine twice for the same handle.
-	 */
-	list_for_each_entry(hwid, &pnp.ids, list) {
-		handler = acpi_scan_match_handler(hwid->id, NULL);
-		if (handler) {
-			acpi_install_hotplug_notify_handler(handle);
-			break;
-		}
-	}
-
-out:
-	acpi_free_pnp_ids(&pnp);
-}
-
 static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
 				      void *not_used, void **return_value)
 {
@@ -2078,8 +1981,6 @@ static acpi_status acpi_bus_check_add(ac
 		return AE_OK;
 	}
 
-	acpi_scan_init_hotplug(handle, type);
-
 	acpi_add_single_object(&device, handle, type, sta);
 	if (!device)
 		return AE_CTRL_DEPTH;
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -293,7 +293,6 @@ static acpi_status register_slot(acpi_ha
 	newfunc = &context->func;
 	newfunc->function = function;
 	newfunc->parent = bridge;
-	acpi_unlock_hp_context();
 
 	if (acpi_has_method(handle, "_EJ0"))
 		newfunc->flags = FUNC_HAS_EJ0;
@@ -301,8 +300,14 @@ static acpi_status register_slot(acpi_ha
 	if (acpi_has_method(handle, "_STA"))
 		newfunc->flags |= FUNC_HAS_STA;
 
+	/*
+	 * Dock stations' notify handler should be used for dock devices instead
+	 * of the common one, so clear hp.event in their contexts.
+	 */
 	if (acpi_has_method(handle, "_DCK"))
-		newfunc->flags |= FUNC_HAS_DCK;
+		context->hp.event = NULL;
+
+	acpi_unlock_hp_context();
 
 	/* search for objects that share the same slot */
 	list_for_each_entry(slot, &bridge->slots, node)
@@ -370,10 +375,6 @@ static acpi_status register_slot(acpi_ha
 			pr_debug("failed to register dock device\n");
 	}
 
-	/* install notify handler */
-	if (!(newfunc->flags & FUNC_HAS_DCK))
-		acpi_install_hotplug_notify_handler(handle);
-
 	return AE_OK;
 }
 
@@ -407,13 +408,14 @@ static void cleanup_bridge(struct acpiph
 
 	list_for_each_entry(slot, &bridge->slots, node) {
 		list_for_each_entry(func, &slot->funcs, sibling) {
-			acpi_handle handle = func_to_handle(func);
+			struct acpi_device *adev = func_to_acpi_device(func);
 
-			if (is_dock_device(handle))
-				unregister_hotplug_dock_device(handle);
+			if (is_dock_device(adev->handle))
+				unregister_hotplug_dock_device(adev->handle);
 
-			if (!(func->flags & FUNC_HAS_DCK))
-				acpi_remove_hotplug_notify_handler(handle);
+			acpi_lock_hp_context();
+			adev->hp->event = NULL;
+			acpi_unlock_hp_context();
 		}
 		slot->flags |= SLOT_IS_GOING_AWAY;
 		if (slot->slot)
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -445,8 +445,6 @@ static inline bool acpi_device_enumerate
 typedef void (*acpi_hp_callback)(void *data, u32 src);
 
 acpi_status acpi_hotplug_execute(acpi_hp_callback func, void *data, u32 src);
-void acpi_install_hotplug_notify_handler(acpi_handle handle);
-void acpi_remove_hotplug_notify_handler(acpi_handle handle);
 
 /**
  * module_acpi_driver(acpi_driver) - Helper macro for registering an ACPI driver
Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -167,7 +167,6 @@ struct acpiphp_attention_info
 
 #define FUNC_HAS_STA		(0x00000001)
 #define FUNC_HAS_EJ0		(0x00000002)
-#define FUNC_HAS_DCK            (0x00000004)
 
 /* function prototypes */
 

