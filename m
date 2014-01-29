Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbaA1XwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:52:02 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59447 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755043AbaA1Xu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:50:27 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [Update][PATCH 5/5][RFT] ACPI / hotplug / PCI: Hotplug notifications from acpi_bus_notify()
Date: Wed, 29 Jan 2014 01:02:28 +0100
Message-ID: <1826755.RG5jxVHPBj@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1693151.2qrLZHyp0o@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1508034.JFmpIOzjVZ@vostro.rjw.lan> <1693151.2qrLZHyp0o@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since acpi_bus_notify() is executed on all notifications for all
devices anyway, rename acpi_hotplug_notify_cb() to acpi_system_notify()
and call it directly from acpi_bus_notify() instead of installing
notify handlers pointing to it for all hotplug devices.

This change reduces both the size and complexity of ACPI-base device
hotplug code.  Moreover, since acpi_system_notify() only does
significant things for devices that either have an ACPI scan handler,
or have a hotplug context with .eject() defined, and those devices
had notify handlers pointing to acpi_hotplug_notify_cb() installed
before anyway, this change shouldn't modify functionality.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c                 |   42 ----------------------
 drivers/acpi/internal.h            |    1 
 drivers/acpi/scan.c                |   68 +++++++++----------------------------
 drivers/pci/hotplug/acpiphp.h      |    1 
 drivers/pci/hotplug/acpiphp_glue.c |   16 +++-----
 include/acpi/acpi_bus.h            |    2 -
 6 files changed, 26 insertions(+), 104 deletions(-)

Index: linux-pm/drivers/acpi/bus.c
===================================================================
--- linux-pm.orig/drivers/acpi/bus.c
+++ linux-pm/drivers/acpi/bus.c
@@ -345,47 +345,7 @@ static void acpi_bus_notify(acpi_handle
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Notification %#02x to handle %p\n",
 			  type, handle));
 
-	switch (type) {
-
-	case ACPI_NOTIFY_BUS_CHECK:
-		/* TBD */
-		break;
-
-	case ACPI_NOTIFY_DEVICE_CHECK:
-		/* TBD */
-		break;
-
-	case ACPI_NOTIFY_DEVICE_WAKE:
-		/* TBD */
-		break;
-
-	case ACPI_NOTIFY_EJECT_REQUEST:
-		/* TBD */
-		break;
-
-	case ACPI_NOTIFY_DEVICE_CHECK_LIGHT:
-		/* TBD: Exactly what does 'light' mean? */
-		break;
-
-	case ACPI_NOTIFY_FREQUENCY_MISMATCH:
-		/* TBD */
-		break;
-
-	case ACPI_NOTIFY_BUS_MODE_MISMATCH:
-		/* TBD */
-		break;
-
-	case ACPI_NOTIFY_POWER_FAULT:
-		/* TBD */
-		break;
-
-	default:
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Received unknown/unsupported notification [%08x]\n",
-				  type));
-		break;
-	}
-
+	acpi_system_notify(handle, type);
 	acpi_bus_get_device(handle, &device);
 	if (device) {
 		driver = device->driver;
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -74,6 +74,7 @@ static inline void acpi_lpss_init(void)
 
 bool acpi_queue_hotplug_work(struct work_struct *work);
 bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent);
+void acpi_system_notify(acpi_handle handle, u32 type);
 
 /* --------------------------------------------------------------------------
                      Device Node Initialization / Removal
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -485,11 +485,11 @@ static void acpi_device_hotplug(void *da
 	unlock_device_hotplug();
 }
 
-static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
+void acpi_system_notify(acpi_handle handle, u32 type)
 {
 	u32 ost_code = ACPI_OST_SC_SUCCESS;
 	struct acpi_device *adev;
-	acpi_status status;
+	bool execute_ost = true;
 
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
@@ -543,28 +543,24 @@ static void acpi_hotplug_notify_cb(acpi_
 		acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
 					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 	}
-	get_device(&adev->dev);
-	mutex_unlock(&acpi_scan_lock);
-	status = acpi_hotplug_execute(acpi_device_hotplug, adev, type);
-	if (ACPI_SUCCESS(status))
-		return;
-
-	put_device(&adev->dev);
+	if (adev->handler || (adev->hp && adev->hp->event)) {
+		acpi_status status;
 
- out:
-	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
-}
+		get_device(&adev->dev);
+		mutex_unlock(&acpi_scan_lock);
+		status = acpi_hotplug_execute(acpi_device_hotplug, adev, type);
+		if (ACPI_SUCCESS(status))
+			return;
 
-void acpi_install_hotplug_notify_handler(acpi_handle handle)
-{
-	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-				    acpi_hotplug_notify_cb, NULL);
-}
+		put_device(&adev->dev);
+	} else {
+		mutex_unlock(&acpi_scan_lock);
+		execute_ost = false;
+	}
 
-void acpi_remove_hotplug_notify_handler(acpi_handle handle)
-{
-	acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-				   acpi_hotplug_notify_cb);
+ out:
+	if (execute_ost)
+		acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
 }
 
 static ssize_t real_power_state_show(struct device *dev,
@@ -1986,34 +1982,6 @@ void acpi_scan_hotplug_enabled(struct ac
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
@@ -2035,8 +2003,6 @@ static acpi_status acpi_bus_check_add(ac
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
@@ -292,7 +292,6 @@ static acpi_status register_slot(acpi_ha
 	newfunc = &context->func;
 	newfunc->function = function;
 	newfunc->parent = bridge;
-	mutex_unlock(&acpiphp_context_lock);
 
 	if (acpi_has_method(handle, "_EJ0"))
 		newfunc->flags = FUNC_HAS_EJ0;
@@ -300,8 +299,14 @@ static acpi_status register_slot(acpi_ha
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
+	mutex_unlock(&acpiphp_context_lock);
 
 	/* search for objects that share the same slot */
 	list_for_each_entry(slot, &bridge->slots, node)
@@ -369,10 +374,6 @@ static acpi_status register_slot(acpi_ha
 			pr_debug("failed to register dock device\n");
 	}
 
-	/* install notify handler */
-	if (!(newfunc->flags & FUNC_HAS_DCK))
-		acpi_install_hotplug_notify_handler(handle);
-
 	return AE_OK;
 }
 
@@ -409,9 +410,6 @@ static void cleanup_bridge(struct acpiph
 
 			if (is_dock_device(handle))
 				unregister_hotplug_dock_device(handle);
-
-			if (!(func->flags & FUNC_HAS_DCK))
-				acpi_remove_hotplug_notify_handler(handle);
 		}
 		slot->flags |= SLOT_IS_GOING_AWAY;
 		if (slot->slot)
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -435,8 +435,6 @@ static inline bool acpi_device_enumerate
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
 

