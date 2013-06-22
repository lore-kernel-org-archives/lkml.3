Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab3FVVQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 17:16:34 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47194 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab3FVVQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 17:16:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-acpi@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ACPI / dock / PCI: Synchronous handling of dock events for PCI devices
Date: Sat, 22 Jun 2013 23:25:33 +0200
Message-ID: <15269989.ojxutYs2L1@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2737587.I0nULev1kj@vostro.rjw.lan>
References: <2737587.I0nULev1kj@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The interactions between the ACPI dock driver and the ACPI-based PCI
hotplug (acpiphp) are currently problematic because of ordering
issues during hot-remove operations.

First of all, the current ACPI glue code expects that physical
devices will always be deleted before deleting the companion ACPI
device objects.  Otherwise, acpi_unbind_one() will fail with a
warning message printed to the kernel log, for example:

[  185.026073] usb usb5: Oops, 'acpi_handle' corrupt
[  185.035150] pci 0000:1b:00.0: Oops, 'acpi_handle' corrupt
[  185.035515] pci 0000:18:02.0: Oops, 'acpi_handle' corrupt
[  180.013656]  port1: Oops, 'acpi_handle' corrupt

This means, in particular, that struct pci_dev objects have to
be deleted before the struct acpi_device objects they are "glued"
with.

Now, the following happens the during the undocking of an ACPI-based
dock station:
 1) hotplug_dock_devices() invokes registered hotplug callbacks to
    destroy physical devices associated with the ACPI device objects
    depending on the dock station.  It calls dd->ops->handler() for
    each of those device objects.
 2) For PCI devices dd->ops->handler() points to
    handle_hotplug_event_func() that queues up a separate work item
    to execute _handle_hotplug_event_func() for the given device and
    returns immediately.  That work item will be executed later.
 3) hotplug_dock_devices() calls dock_remove_acpi_device() for each
    device depending on the dock station.  This runs acpi_bus_trim()
    for each of them, which causes the underlying ACPI device object
    to be destroyed, but the work items queued up by
    handle_hotplug_event_func() haven't been started yet.
 4) _handle_hotplug_event_func() queued up in step 2) are executed
    and cause the above failure to happen, because the PCI devices
    they handle do not have the companion ACPI device objects any
    more (they have been deleted in step 3).

The possible breakage doesn't end here, though, because
hotplug_dock_devices() may return before at least some of the
_handle_hotplug_event_func() work items spawned by it have a
chance to complete and then undock() will cause _DCK to be
evaluated and that will cause the devices handled by the
_handle_hotplug_event_func() to go away possibly while they are
being accessed.

This means that dd->ops->handler() for PCI devices should not point
to handle_hotplug_event_func().  Instead, it should point to a
function that will do the work of _handle_hotplug_event_func()
synchronously.  For this reason, introduce such a function,
hotplug_event_func(), and modity acpiphp_dock_ops to point to
it as the handler.

Unfortunately, however, this is not sufficient, because if the dock
code were not changed further, hotplug_event_func() would now
deadlock with hotplug_dock_devices() that called it, since it would
run unregister_hotplug_dock_device() which in turn would attempt to
acquire the dock station's hp_lock mutex already acquired by
hotplug_dock_devices().

To resolve that deadlock use the observation that
unregister_hotplug_dock_device() won't need to acquire hp_lock
if PCI bridges the devices on the dock station depend on are
prevented from being removed prematurely while the first loop in
hotplug_dock_devices() is in progress.

To make that possible, introduce a mechanism by which the callers of
register_hotplug_dock_device() can provide "init" and "release"
routines that will be executed, respectively, after the addition
and removal of the physical device object associated with the
given ACPI device handle.  Make acpiphp use two new functions,
acpiphp_dock_init() and acpiphp_dock_release(), respectively,
calling get_bridge() and put_bridge() on the PCI bridge holding the
given device, respectively, for this purpose.

In addition to that, remove the dock station's list of
"hotplug devices" and make the dock code always walk the whole list
of "dependent devices" instead in such a way that the loops in
hotplug_dock_devices() and dock_event() (replacing the loops over
"hotplug devices") will take references to the list entries that
register_hotplug_dock_device() has been called for.  That prevents
the "release" routines associated with those entries from being
called while the given entry is being processed and for PCI
devices this means that their bridges won't be removed (by a
concurrent thread) while hotplug_event_func() handling them is
being executed.

This change is based on two earlier patches from Jiang Liu.

References: https://bugzilla.kernel.org/show_bug.cgi?id=59501
Reported-by: Alexander E. Patrakov <patrakov@gmail.com>
Tracked-down-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 3.9+ <stable@vger.kernel.org>
---
 drivers/acpi/dock.c                |  152 +++++++++++++++++++++++++------------
 drivers/pci/hotplug/acpiphp_glue.c |   46 +++++++----
 include/acpi/acpi_drivers.h        |    4 
 3 files changed, 138 insertions(+), 64 deletions(-)

Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -66,20 +66,21 @@ struct dock_station {
 	spinlock_t dd_lock;
 	struct mutex hp_lock;
 	struct list_head dependent_devices;
-	struct list_head hotplug_devices;
 
 	struct list_head sibling;
 	struct platform_device *dock_device;
 };
 static LIST_HEAD(dock_stations);
 static int dock_station_count;
+static DEFINE_MUTEX(hotplug_lock);
 
 struct dock_dependent_device {
 	struct list_head list;
-	struct list_head hotplug_list;
 	acpi_handle handle;
-	const struct acpi_dock_ops *ops;
-	void *context;
+	const struct acpi_dock_ops *hp_ops;
+	void *hp_context;
+	unsigned int hp_refcount;
+	void (*hp_release)(void *);
 };
 
 #define DOCK_DOCKING	0x00000001
@@ -111,7 +112,6 @@ add_dock_dependent_device(struct dock_st
 
 	dd->handle = handle;
 	INIT_LIST_HEAD(&dd->list);
-	INIT_LIST_HEAD(&dd->hotplug_list);
 
 	spin_lock(&ds->dd_lock);
 	list_add_tail(&dd->list, &ds->dependent_devices);
@@ -121,35 +121,90 @@ add_dock_dependent_device(struct dock_st
 }
 
 /**
- * dock_add_hotplug_device - associate a hotplug handler with the dock station
- * @ds: The dock station
- * @dd: The dependent device struct
- *
- * Add the dependent device to the dock's hotplug device list
- */
-static void
-dock_add_hotplug_device(struct dock_station *ds,
-			struct dock_dependent_device *dd)
-{
-	mutex_lock(&ds->hp_lock);
-	list_add_tail(&dd->hotplug_list, &ds->hotplug_devices);
-	mutex_unlock(&ds->hp_lock);
+ * dock_init_hotplug - Initialize a hotplug device on a docking station.
+ * @dd: Dock-dependent device.
+ * @ops: Dock operations to attach to the dependent device.
+ * @context: Data to pass to the @ops callbacks and @release.
+ * @init: Optional initialization routine to run after setting up context.
+ * @release: Optional release routine to run on removal.
+ */
+static int dock_init_hotplug(struct dock_dependent_device *dd,
+			     const struct acpi_dock_ops *ops, void *context,
+			     void (*init)(void *), void (*release)(void *))
+{
+	int ret = 0;
+
+	mutex_lock(&hotplug_lock);
+
+	if (dd->hp_context) {
+		ret = -EEXIST;
+	} else {
+		dd->hp_refcount = 1;
+		dd->hp_ops = ops;
+		dd->hp_context = context;
+		dd->hp_release = release;
+	}
+
+	if (!WARN_ON(ret) && init)
+		init(context);
+
+	mutex_unlock(&hotplug_lock);
+	return ret;
 }
 
 /**
- * dock_del_hotplug_device - remove a hotplug handler from the dock station
- * @ds: The dock station
- * @dd: the dependent device struct
+ * dock_release_hotplug - Decrement hotplug reference counter of dock device.
+ * @dd: Dock-dependent device.
  *
- * Delete the dependent device from the dock's hotplug device list
+ * Decrement the reference counter of @dd and if 0, detach its hotplug
+ * operations from it, reset its context pointer and run the optional release
+ * routine if present.
  */
-static void
-dock_del_hotplug_device(struct dock_station *ds,
-			struct dock_dependent_device *dd)
+static void dock_release_hotplug(struct dock_dependent_device *dd)
 {
-	mutex_lock(&ds->hp_lock);
-	list_del(&dd->hotplug_list);
-	mutex_unlock(&ds->hp_lock);
+	void (*release)(void *) = NULL;
+	void *context = NULL;
+
+	mutex_lock(&hotplug_lock);
+
+	if (dd->hp_context && !--dd->hp_refcount) {
+		dd->hp_ops = NULL;
+		context = dd->hp_context;
+		dd->hp_context = NULL;
+		release = dd->hp_release;
+		dd->hp_release = NULL;
+	}
+
+	if (release && context)
+		release(context);
+
+	mutex_unlock(&hotplug_lock);
+}
+
+static void dock_hotplug_event(struct dock_dependent_device *dd, u32 event,
+			       bool uevent)
+{
+	acpi_notify_handler cb = NULL;
+	bool run = false;
+
+	mutex_lock(&hotplug_lock);
+
+	if (dd->hp_context) {
+		run = true;
+		dd->hp_refcount++;
+		if (dd->hp_ops)
+			cb = uevent ? dd->hp_ops->uevent : dd->hp_ops->handler;
+	}
+
+	mutex_unlock(&hotplug_lock);
+
+	if (!run)
+		return;
+
+	if (cb)
+		cb(dd->handle, event, dd->hp_context);
+
+	dock_release_hotplug(dd);
 }
 
 /**
@@ -360,9 +415,8 @@ static void hotplug_dock_devices(struct
 	/*
 	 * First call driver specific hotplug functions
 	 */
-	list_for_each_entry(dd, &ds->hotplug_devices, hotplug_list)
-		if (dd->ops && dd->ops->handler)
-			dd->ops->handler(dd->handle, event, dd->context);
+	list_for_each_entry(dd, &ds->dependent_devices, list)
+		dock_hotplug_event(dd, event, false);
 
 	/*
 	 * Now make sure that an acpi_device is created for each
@@ -398,9 +452,8 @@ static void dock_event(struct dock_stati
 	if (num == DOCK_EVENT)
 		kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
 
-	list_for_each_entry(dd, &ds->hotplug_devices, hotplug_list)
-		if (dd->ops && dd->ops->uevent)
-			dd->ops->uevent(dd->handle, event, dd->context);
+	list_for_each_entry(dd, &ds->dependent_devices, list)
+		dock_hotplug_event(dd, event, true);
 
 	if (num != DOCK_EVENT)
 		kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
@@ -570,18 +623,22 @@ EXPORT_SYMBOL_GPL(unregister_dock_notifi
  * @handle: the handle of the device
  * @ops: handlers to call after docking
  * @context: device specific data
+ * @init: Optional initialization routine to run after registration
+ * @release: Optional release routine to run on unregistration
  *
  * If a driver would like to perform a hotplug operation after a dock
  * event, they can register an acpi_notifiy_handler to be called by
  * the dock driver after _DCK is executed.
  */
-int
-register_hotplug_dock_device(acpi_handle handle, const struct acpi_dock_ops *ops,
-			     void *context)
+int register_hotplug_dock_device(acpi_handle handle,
+				 const struct acpi_dock_ops *ops, void *context,
+				 void (*init)(void *), void (*release)(void *))
 {
 	struct dock_dependent_device *dd;
 	struct dock_station *dock_station;
-	int ret = -EINVAL;
+
+	if (WARN_ON(!context))
+		return -EINVAL;
 
 	if (!dock_station_count)
 		return -ENODEV;
@@ -597,15 +654,11 @@ register_hotplug_dock_device(acpi_handle
 		 * ops
 		 */
 		dd = find_dock_dependent_device(dock_station, handle);
-		if (dd) {
-			dd->ops = ops;
-			dd->context = context;
-			dock_add_hotplug_device(dock_station, dd);
-			ret = 0;
-		}
+		if (dd)
+			return dock_init_hotplug(dd, ops, context,
+						 init, release);
 	}
-
-	return ret;
+	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(register_hotplug_dock_device);
 
@@ -623,8 +676,10 @@ void unregister_hotplug_dock_device(acpi
 
 	list_for_each_entry(dock_station, &dock_stations, sibling) {
 		dd = find_dock_dependent_device(dock_station, handle);
-		if (dd)
-			dock_del_hotplug_device(dock_station, dd);
+		if (dd) {
+			dock_release_hotplug(dd);
+			return;
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(unregister_hotplug_dock_device);
@@ -953,7 +1008,6 @@ static int __init dock_add(acpi_handle h
 	mutex_init(&dock_station->hp_lock);
 	spin_lock_init(&dock_station->dd_lock);
 	INIT_LIST_HEAD(&dock_station->sibling);
-	INIT_LIST_HEAD(&dock_station->hotplug_devices);
 	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 	INIT_LIST_HEAD(&dock_station->dependent_devices);
 
Index: linux-pm/include/acpi/acpi_drivers.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_drivers.h
+++ linux-pm/include/acpi/acpi_drivers.h
@@ -123,7 +123,9 @@ extern int register_dock_notifier(struct
 extern void unregister_dock_notifier(struct notifier_block *nb);
 extern int register_hotplug_dock_device(acpi_handle handle,
 					const struct acpi_dock_ops *ops,
-					void *context);
+					void *context,
+					void (*init)(void *),
+					void (*release)(void *));
 extern void unregister_hotplug_dock_device(acpi_handle handle);
 #else
 static inline int is_dock_device(acpi_handle handle)
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -61,6 +61,7 @@ static DEFINE_MUTEX(bridge_mutex);
 static void handle_hotplug_event_bridge (acpi_handle, u32, void *);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
+static void hotplug_event_func(acpi_handle handle, u32 type, void *context);
 static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
 static void free_bridge(struct kref *kref);
 
@@ -147,7 +148,7 @@ static int post_dock_fixups(struct notif
 
 
 static const struct acpi_dock_ops acpiphp_dock_ops = {
-	.handler = handle_hotplug_event_func,
+	.handler = hotplug_event_func,
 };
 
 /* Check whether the PCI device is managed by native PCIe hotplug driver */
@@ -179,6 +180,20 @@ static bool device_is_managed_by_native_
 	return true;
 }
 
+static void acpiphp_dock_init(void *data)
+{
+	struct acpiphp_func *func = data;
+
+	get_bridge(func->slot->bridge);
+}
+
+static void acpiphp_dock_release(void *data)
+{
+	struct acpiphp_func *func = data;
+
+	put_bridge(func->slot->bridge);
+}
+
 /* callback routine to register each ACPI PCI slot object */
 static acpi_status
 register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
@@ -298,7 +313,8 @@ register_slot(acpi_handle handle, u32 lv
 		 */
 		newfunc->flags &= ~FUNC_HAS_EJ0;
 		if (register_hotplug_dock_device(handle,
-			&acpiphp_dock_ops, newfunc))
+			&acpiphp_dock_ops, newfunc,
+			acpiphp_dock_init, acpiphp_dock_release))
 			dbg("failed to register dock device\n");
 
 		/* we need to be notified when dock events happen
@@ -1068,22 +1084,12 @@ static void handle_hotplug_event_bridge(
 	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_bridge);
 }
 
-static void _handle_hotplug_event_func(struct work_struct *work)
+static void hotplug_event_func(acpi_handle handle, u32 type, void *context)
 {
-	struct acpiphp_func *func;
+	struct acpiphp_func *func = context;
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
 				      .pointer = objname };
-	struct acpi_hp_work *hp_work;
-	acpi_handle handle;
-	u32 type;
-
-	hp_work = container_of(work, struct acpi_hp_work, work);
-	handle = hp_work->handle;
-	type = hp_work->type;
-	func = (struct acpiphp_func *)hp_work->context;
-
-	acpi_scan_lock_acquire();
 
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
@@ -1116,6 +1122,18 @@ static void _handle_hotplug_event_func(s
 		warn("notify_handler: unknown event type 0x%x for %s\n", type, objname);
 		break;
 	}
+}
+
+static void _handle_hotplug_event_func(struct work_struct *work)
+{
+	struct acpi_hp_work *hp_work;
+	struct acpiphp_func *func;
+
+	hp_work = container_of(work, struct acpi_hp_work, work);
+	func = hp_work->context;
+	acpi_scan_lock_acquire();
+
+	hotplug_event_func(hp_work->handle, hp_work->type, func);
 
 	acpi_scan_lock_release();
 	kfree(hp_work); /* allocated in handle_hotplug_event_func */

