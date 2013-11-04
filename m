Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab3KDAKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 19:10:06 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62473 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750913Ab3KDAKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 19:10:02 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/3] ACPI / hotplug: Merge device hot-removal routines
Date: Mon, 04 Nov 2013 01:21:46 +0100
Message-ID: <5913958.7oJcoqqQ9l@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5839747.7HXXGHmMBd@vostro.rjw.lan>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The only substantial difference between acpi_bus_device_eject() and
acpi_bus_hot_remove_device() is the get_device() done by the former
which is supposed to be done by callers of the latter.  However,
at least one caller of acpi_bus_hot_remove_device(), which is
handle_root_bridge_removal(), doesn't do that and generally it
won't be necessary to do that at all if ACPI handles, rather than
struct acpi_device objects, are passed between ACPI hotplug routines,
because the correctness of those routines already depends on the
persistence of ACPI handles (that may not be an entirely correct
assumption in theory, but in practice it has been good enough for a
long time).

For this reason, modify acpi_bus_device_eject() to take two
arguments, an ACPI handle and event code, and make
acpi_bus_hot_remove_device() call it internally.  Moreover, rework
acpi_bus_hot_remove_device() so that it only takes one argument,
an ACPI handle, and make acpi_scan_bus_device_check() queue up
acpi_bus_hot_remove_device() instead of acpi_bus_device_eject()
itself.  After these changes, handle_root_bridge_removal() may
be replaced with async execution of acpi_bus_hot_remove_device()
with the ACPI handle of the root passed to it as the argument.

However, since acpi_eject_store() also needs to execute
acpi_bus_device_eject() asynchronously and it needs to pass a
special event code, ACPI_OST_EC_OSPM_EJECT, to that function,
introduce a separate wrapper around acpi_bus_device_eject(),
acpi_eject_store_work(), that will be queued up by
acpi_eject_store() instead of acpi_bus_hot_remove_device().
This allows acpi_eject_store() to be simplified and it allows
struct acpi_eject_event to be dropped entirely, as there's
no more users of that structure.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |    1 
 drivers/acpi/pci_root.c |   28 ++--------------
 drivers/acpi/scan.c     |   81 ++++++++++++++++--------------------------------
 include/acpi/acpi_bus.h |    6 ---
 4 files changed, 32 insertions(+), 84 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -285,9 +285,8 @@ static int acpi_scan_hot_remove(struct a
 	return 0;
 }
 
-static void acpi_bus_device_eject(void *context)
+static void acpi_bus_device_eject(acpi_handle handle, u32 ost_source)
 {
-	acpi_handle handle = context;
 	struct acpi_device *device = NULL;
 	struct acpi_scan_handler *handler;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
@@ -304,8 +303,10 @@ static void acpi_bus_device_eject(void *
 	if (!handler || !handler->hotplug.enabled)
 		goto err_support;
 
-	acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
-				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
+	if (ost_source == ACPI_NOTIFY_EJECT_REQUEST)
+		acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
+					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
+
 	if (handler->hotplug.mode == AHM_CONTAINER)
 		kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
 
@@ -325,11 +326,22 @@ static void acpi_bus_device_eject(void *
  err_support:
 	ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
  err_out:
-	acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST, ost_code,
-				  NULL);
+	acpi_evaluate_hotplug_ost(handle, ost_source, ost_code, NULL);
 	goto out;
 }
 
+/**
+ * acpi_bus_hot_remove_device: Eject a device and its children.
+ * @context: ACPI handle of the device to eject.
+ *
+ * Hot-remove a device and its children. This function is to be called
+ * asynchronously through acpi_os_hotplug_execute().
+ */
+void acpi_bus_hot_remove_device(void *context)
+{
+	acpi_bus_device_eject(context, ACPI_NOTIFY_EJECT_REQUEST);
+}
+
 static void acpi_scan_bus_device_check(acpi_handle handle, u32 ost_source)
 {
 	struct acpi_device *device = NULL;
@@ -428,7 +440,7 @@ static void acpi_hotplug_notify_cb(acpi_
 		break;
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
-		callback = acpi_bus_device_eject;
+		callback = acpi_bus_hot_remove_device;
 		break;
 	default:
 		/* non-hotplug event; possibly handled by other handler */
@@ -441,36 +453,6 @@ static void acpi_hotplug_notify_cb(acpi_
 					  NULL);
 }
 
-/**
- * acpi_bus_hot_remove_device: hot-remove a device and its children
- * @context: struct acpi_eject_event pointer (freed in this func)
- *
- * Hot-remove a device and its children. This function frees up the
- * memory space passed by arg context, so that the caller may call
- * this function asynchronously through acpi_os_hotplug_execute().
- */
-void acpi_bus_hot_remove_device(void *context)
-{
-	struct acpi_eject_event *ej_event = context;
-	struct acpi_device *device = ej_event->device;
-	acpi_handle handle = device->handle;
-	int error;
-
-	lock_device_hotplug();
-	mutex_lock(&acpi_scan_lock);
-
-	error = acpi_scan_hot_remove(device);
-	if (error && handle)
-		acpi_evaluate_hotplug_ost(handle, ej_event->event,
-					  ACPI_OST_SC_NON_SPECIFIC_FAILURE,
-					  NULL);
-
-	mutex_unlock(&acpi_scan_lock);
-	unlock_device_hotplug();
-	kfree(context);
-}
-EXPORT_SYMBOL(acpi_bus_hot_remove_device);
-
 static ssize_t real_power_state_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
@@ -497,15 +479,18 @@ static ssize_t power_state_show(struct d
 
 static DEVICE_ATTR(power_state, 0444, power_state_show, NULL);
 
+static void acpi_eject_store_work(void *context)
+{
+	acpi_bus_device_eject(context, ACPI_OST_EC_OSPM_EJECT);
+}
+
 static ssize_t
 acpi_eject_store(struct device *d, struct device_attribute *attr,
 		const char *buf, size_t count)
 {
 	struct acpi_device *acpi_device = to_acpi_device(d);
-	struct acpi_eject_event *ej_event;
 	acpi_object_type not_used;
 	acpi_status status;
-	int ret;
 
 	if (!count || buf[0] != '1')
 		return -EINVAL;
@@ -518,28 +503,16 @@ acpi_eject_store(struct device *d, struc
 	if (ACPI_FAILURE(status) || !acpi_device->flags.ejectable)
 		return -ENODEV;
 
-	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
-	if (!ej_event) {
-		ret = -ENOMEM;
-		goto err_out;
-	}
 	acpi_evaluate_hotplug_ost(acpi_device->handle, ACPI_OST_EC_OSPM_EJECT,
 				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
-	ej_event->device = acpi_device;
-	ej_event->event = ACPI_OST_EC_OSPM_EJECT;
-	get_device(&acpi_device->dev);
-	status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, ej_event);
+	status = acpi_os_hotplug_execute(acpi_eject_store_work,
+					 acpi_device->handle);
 	if (ACPI_SUCCESS(status))
 		return count;
 
-	put_device(&acpi_device->dev);
-	kfree(ej_event);
-	ret = status == AE_NO_MEMORY ? -ENOMEM : -EAGAIN;
-
- err_out:
 	acpi_evaluate_hotplug_ost(acpi_device->handle, ACPI_OST_EC_OSPM_EJECT,
 				  ACPI_OST_SC_NON_SPECIFIC_FAILURE, NULL);
-	return ret;
+	return -EAGAIN;
 }
 
 static DEVICE_ATTR(eject, 0200, NULL, acpi_eject_store);
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -92,6 +92,7 @@ void acpi_device_add_finalize(struct acp
 void acpi_free_pnp_ids(struct acpi_device_pnp *pnp);
 int acpi_bind_one(struct device *dev, acpi_handle handle);
 int acpi_unbind_one(struct device *dev);
+void acpi_bus_hot_remove_device(void *context);
 
 /* --------------------------------------------------------------------------
                                   Power Resource
Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -39,6 +39,8 @@
 #include <acpi/acpi_drivers.h>
 #include <acpi/apei.h>
 
+#include "internal.h"
+
 #define PREFIX "ACPI: "
 
 #define _COMPONENT		ACPI_PCI_COMPONENT
@@ -590,29 +592,6 @@ static void handle_root_bridge_insertion
 		acpi_handle_err(handle, "cannot add bridge to acpi list\n");
 }
 
-static void handle_root_bridge_removal(struct acpi_device *device)
-{
-	acpi_status status;
-	struct acpi_eject_event *ej_event;
-
-	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
-	if (!ej_event) {
-		/* Inform firmware the hot-remove operation has error */
-		(void) acpi_evaluate_hotplug_ost(device->handle,
-					ACPI_NOTIFY_EJECT_REQUEST,
-					ACPI_OST_SC_NON_SPECIFIC_FAILURE,
-					NULL);
-		return;
-	}
-
-	ej_event->device = device;
-	ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
-
-	status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, ej_event);
-	if (ACPI_FAILURE(status))
-		kfree(ej_event);
-}
-
 static void _handle_hotplug_event_root(struct work_struct *work)
 {
 	struct acpi_pci_root *root;
@@ -653,7 +632,8 @@ static void _handle_hotplug_event_root(s
 		acpi_handle_printk(KERN_DEBUG, handle,
 				   "Device eject notify on %s\n", __func__);
 		if (root)
-			handle_root_bridge_removal(root->device);
+			acpi_os_hotplug_execute(acpi_bus_hot_remove_device,
+						handle);
 		break;
 	default:
 		acpi_handle_warn(handle,
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -339,11 +339,6 @@ struct acpi_bus_event {
 	u32 data;
 };
 
-struct acpi_eject_event {
-	struct acpi_device	*device;
-	u32		event;
-};
-
 struct acpi_hp_work {
 	struct work_struct work;
 	acpi_handle handle;
@@ -391,7 +386,6 @@ int acpi_scan_add_handler(struct acpi_sc
 int acpi_bus_register_driver(struct acpi_driver *driver);
 void acpi_bus_unregister_driver(struct acpi_driver *driver);
 int acpi_bus_scan(acpi_handle handle);
-void acpi_bus_hot_remove_device(void *context);
 void acpi_bus_trim(struct acpi_device *start);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
 int acpi_match_device_ids(struct acpi_device *device,

