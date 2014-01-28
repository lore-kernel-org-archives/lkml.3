Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbaA1WFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:05:41 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62584 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932195AbaA1WFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:05:34 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 3/5][RFT] ACPI / hotplug / PCI: Consolidate ACPIPHP with ACPI core hotplug
Date: Tue, 28 Jan 2014 23:14:05 +0100
Message-ID: <2890590.snhsohRNYl@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1508034.JFmpIOzjVZ@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1508034.JFmpIOzjVZ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Use the same ACPI notify handler, acpi_hotplug_notify_cb() for both
ACPI-based PCI hotplug (ACPIPHP) and the generic ACPI-based hotplug
of devices.  For PCI devices use the  .hp.event() callback from
their ACPI companions that points to acpiphp_hotplug_event().
For other devices (CPU, memory, containers, PCI host bridges) the
generic ACPI-based device hotplug code is used.

This allows code duplication between ACPIPHP and the ACPI core to be
reduced significantly and makes further ACPI-based device hotplug
consolidation possible.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c                |   85 ++++++++++++++++++----------
 drivers/pci/hotplug/acpiphp_glue.c |  110 +++----------------------------------
 include/acpi/acpi_bus.h            |    1 
 3 files changed, 66 insertions(+), 130 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -145,6 +145,7 @@ struct acpi_scan_handler {
 
 struct acpi_hotplug_context {
 	struct acpi_device *self;
+	int (*event)(struct acpi_device *, u32);
 	void (*release)(struct acpi_hotplug_context *);
 };
 
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -439,40 +439,44 @@ static int acpi_scan_bus_check(struct ac
 	return 0;
 }
 
+static int acpi_generic_hotplug_event(struct acpi_device *adev, u32 type)
+{
+	switch (type) {
+	case ACPI_NOTIFY_BUS_CHECK:
+		return acpi_scan_bus_check(adev);
+	case ACPI_NOTIFY_DEVICE_CHECK:
+		return acpi_scan_device_check(adev);
+	case ACPI_NOTIFY_EJECT_REQUEST:
+	case ACPI_OST_EC_OSPM_EJECT:
+		return acpi_scan_hot_remove(adev);
+	}
+	return -EINVAL;
+}
+
 static void acpi_device_hotplug(void *data, u32 src)
 {
-	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
+	u32 ost_code = ACPI_OST_SC_SUCCESS;
 	struct acpi_device *adev = data;
-	int error;
+	int error = -ENODEV;
 
 	lock_device_hotplug();
 	mutex_lock(&acpi_scan_lock);
 
 	/*
 	 * The device object's ACPI handle cannot become invalid as long as we
-	 * are holding acpi_scan_lock, but it may have become invalid before
+	 * are holding acpi_scan_lock, but it might have become invalid before
 	 * that lock was acquired.
 	 */
 	if (adev->handle == INVALID_ACPI_HANDLE)
 		goto out;
 
-	switch (src) {
-	case ACPI_NOTIFY_BUS_CHECK:
-		error = acpi_scan_bus_check(adev);
-		break;
-	case ACPI_NOTIFY_DEVICE_CHECK:
-		error = acpi_scan_device_check(adev);
-		break;
-	case ACPI_NOTIFY_EJECT_REQUEST:
-	case ACPI_OST_EC_OSPM_EJECT:
-		error = acpi_scan_hot_remove(adev);
-		break;
-	default:
-		error = -EINVAL;
-		break;
-	}
-	if (!error)
-		ost_code = ACPI_OST_SC_SUCCESS;
+	if (adev->handler)
+		error = acpi_generic_hotplug_event(adev, src);
+	else if (adev->hp && adev->hp->event)
+		error = adev->hp->event(adev, src);
+
+	if (error)
+		ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 
  out:
 	acpi_evaluate_hotplug_ost(adev->handle, src, ost_code, NULL);
@@ -483,35 +487,58 @@ static void acpi_device_hotplug(void *da
 
 static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
 {
-	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 	struct acpi_scan_handler *handler = data;
+	u32 ost_code = ACPI_OST_SC_SUCCESS;
 	struct acpi_device *adev;
 	acpi_status status;
 
-	if (acpi_bus_get_device(handle, &adev))
-		goto err_out;
-
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_BUS_CHECK event\n");
 		break;
+
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_DEVICE_CHECK event\n");
 		break;
+
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
-		if (!handler->hotplug.enabled) {
+		if (handler && !handler->hotplug.enabled) {
 			acpi_handle_err(handle, "Eject disabled\n");
 			ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
-			goto err_out;
+			goto out;
 		}
 		acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
 					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 		break;
-	default:
-		/* non-hotplug event; possibly handled by other handler */
+
+	case ACPI_NOTIFY_DEVICE_WAKE:
 		return;
+
+	case ACPI_NOTIFY_FREQUENCY_MISMATCH:
+		acpi_handle_err(handle, "Device cannot be configured due "
+				"to a frequency mismatch\n");
+		goto out;
+
+	case ACPI_NOTIFY_BUS_MODE_MISMATCH:
+		acpi_handle_err(handle, "Device cannot be configured due "
+				"to a bus mode mismatch\n");
+		goto out;
+
+	case ACPI_NOTIFY_POWER_FAULT:
+		acpi_handle_err(handle, "Device has suffered a power fault\n");
+		goto out;
+
+	default:
+		acpi_handle_warn(handle, "Unsupported event type 0x%x\n", type);
+		ost_code = ACPI_OST_SC_UNRECOGNIZED_NOTIFY;
+		goto out;
 	}
+
+	ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
+	if (acpi_bus_get_device(handle, &adev))
+		goto out;
+
 	get_device(&adev->dev);
 	status = acpi_hotplug_execute(acpi_device_hotplug, adev, type);
 	if (ACPI_SUCCESS(status))
@@ -519,7 +546,7 @@ static void acpi_hotplug_notify_cb(acpi_
 
 	put_device(&adev->dev);
 
- err_out:
+ out:
 	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
 }
 
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -53,18 +53,14 @@
 #include <linux/slab.h>
 #include <linux/acpi.h>
 
-#include <asm/pgtable.h>
-
 #include "../pci.h"
 #include "acpiphp.h"
 
-#define INVALID_ACPI_HANDLE	((acpi_handle)empty_zero_page)
-
 static LIST_HEAD(bridge_list);
 static DEFINE_MUTEX(bridge_mutex);
 static DEFINE_MUTEX(acpiphp_context_lock);
 
-static void handle_hotplug_event(acpi_handle handle, u32 type, void *data);
+static int acpiphp_hotplug_event(struct acpi_device *adev, u32 type);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
 static void hotplug_event(u32 type, void *data);
@@ -91,6 +87,7 @@ static struct acpiphp_context *acpiphp_i
 
 	context->hp.self = adev;
 	context->hp.release = acpiphp_free_context;
+	context->hp.event = acpiphp_hotplug_event;
 	context->refcount = 1;
 	adev->hp = &context->hp;
 	return context;
@@ -373,14 +370,8 @@ static acpi_status register_slot(acpi_ha
 	}
 
 	/* install notify handler */
-	if (!(newfunc->flags & FUNC_HAS_DCK)) {
-		status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-						     handle_hotplug_event,
-						     context);
-		if (ACPI_FAILURE(status))
-			acpi_handle_err(handle,
-					"failed to install notify handler\n");
-	}
+	if (!(newfunc->flags & FUNC_HAS_DCK))
+		acpi_install_hotplug_notify_handler(handle, NULL);
 
 	return AE_OK;
 }
@@ -411,7 +402,6 @@ static void cleanup_bridge(struct acpiph
 {
 	struct acpiphp_slot *slot;
 	struct acpiphp_func *func;
-	acpi_status status;
 
 	list_for_each_entry(slot, &bridge->slots, node) {
 		list_for_each_entry(func, &slot->funcs, sibling) {
@@ -420,13 +410,8 @@ static void cleanup_bridge(struct acpiph
 			if (is_dock_device(handle))
 				unregister_hotplug_dock_device(handle);
 
-			if (!(func->flags & FUNC_HAS_DCK)) {
-				status = acpi_remove_notify_handler(handle,
-							ACPI_SYSTEM_NOTIFY,
-							handle_hotplug_event);
-				if (ACPI_FAILURE(status))
-					pr_err("failed to remove notify handler\n");
-			}
+			if (!(func->flags & FUNC_HAS_DCK))
+				acpi_remove_hotplug_notify_handler(handle);
 		}
 		slot->flags |= SLOT_IS_GOING_AWAY;
 		if (slot->slot)
@@ -838,26 +823,15 @@ static void hotplug_event(u32 type, void
 		put_bridge(bridge);
 }
 
-static void hotplug_event_work(void *data, u32 type)
+static int acpiphp_hotplug_event(struct acpi_device *adev, u32 type)
 {
-	struct acpi_device *adev = data;
 	struct acpiphp_context *context;
-	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
-
-	acpi_scan_lock_acquire();
-	/*
-	 * The device object's ACPI handle cannot become invalid as long as we
-	 * are holding acpi_scan_lock, but it might have become invalid before
-	 * that lock was acquired.
-	 */
-	if (adev->handle == INVALID_ACPI_HANDLE)
-		goto out;
 
 	mutex_lock(&acpiphp_context_lock);
 	context = acpiphp_get_context(adev);
 	if (!context) {
 		mutex_unlock(&acpiphp_context_lock);
-		goto out;
+		return -ENODATA;
 	}
 	get_bridge(context->func.parent);
 	acpiphp_put_context(context);
@@ -867,73 +841,7 @@ static void hotplug_event_work(void *dat
 	hotplug_event(type, context);
 	pci_unlock_rescan_remove();
 	put_bridge(context->func.parent);
-	ost_code = ACPI_OST_SC_SUCCESS;
-
- out:
-	acpi_evaluate_hotplug_ost(adev->handle, type, ost_code, NULL);
-	put_device(&adev->dev);
-	acpi_scan_lock_release();
-}
-
-/**
- * handle_hotplug_event - handle ACPI hotplug event
- * @handle: Notify()'ed acpi_handle
- * @type: Notify code
- * @data: pointer to acpiphp_context structure
- *
- * Handles ACPI event notification on slots.
- */
-static void handle_hotplug_event(acpi_handle handle, u32 type, void *data)
-{
-	struct acpi_device *adev;
-	acpi_status status;
-	u32 ost_code = ACPI_OST_SC_SUCCESS;
-
-	switch (type) {
-	case ACPI_NOTIFY_BUS_CHECK:
-	case ACPI_NOTIFY_DEVICE_CHECK:
-		break;
-	case ACPI_NOTIFY_EJECT_REQUEST:
-		ost_code = ACPI_OST_SC_EJECT_IN_PROGRESS;
-		acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
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
-	if (acpi_bus_get_device(handle, &adev))
-		goto out;
-
-	get_device(&adev->dev);
-	status = acpi_hotplug_execute(hotplug_event_work, adev, type);
-	if (ACPI_SUCCESS(status))
-		return;
-
-	put_device(&adev->dev);
-
- out:
-	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
+	return 0;
 }
 
 /**

