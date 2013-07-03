Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757Ab3GCXSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:18:39 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57730 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693Ab3GCXSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:18:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: [PATCH 3/4] ACPI / dock / PCI: Drop ACPI dock notifier chain
Date: Thu, 04 Jul 2013 01:27:23 +0200
Message-ID: <3595856.Dm3PiSJoni@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2759309.GsYqNLU1ac@vostro.rjw.lan>
References: <1640211.P0jyS5muX2@vostro.rjw.lan> <1515394.L46AJCfCTt@vostro.rjw.lan> <2759309.GsYqNLU1ac@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The only user of the ACPI dock notifier chain is the ACPI-based PCI
hotplug (acpiphp) driver that uses it to carry out post-dock fixups
needed by some systems with broken _DCK.  However, it is not
necessary to use a separate notifier chain for that, as it can be
simply replaced with a new callback in struct acpi_dock_ops.

For this reason, add a new .fixup() callback to struct acpi_dock_ops
and make hotplug_dock_devices() execute it for all dock devices with
hotplug operations registered.  Accordingly, make acpiphp point that
callback to the function carrying out the post-dock fixups and
do not register a separate dock notifier for each device
registering dock operations.  Finally, drop the ACPI dock notifier
chain that has no more users.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c                |   66 ++++++++++++++-----------------------
 drivers/pci/hotplug/acpiphp.h      |    1 
 drivers/pci/hotplug/acpiphp_glue.c |   18 ++--------
 include/acpi/acpi_drivers.h        |   10 -----
 4 files changed, 30 insertions(+), 65 deletions(-)

Index: linux-pm/include/acpi/acpi_drivers.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_drivers.h
+++ linux-pm/include/acpi/acpi_drivers.h
@@ -113,14 +113,13 @@ void pci_acpi_crs_quirks(void);
                                   Dock Station
   -------------------------------------------------------------------------- */
 struct acpi_dock_ops {
+	acpi_notify_handler fixup;
 	acpi_notify_handler handler;
 	acpi_notify_handler uevent;
 };
 
 #ifdef CONFIG_ACPI_DOCK
 extern int is_dock_device(acpi_handle handle);
-extern int register_dock_notifier(struct notifier_block *nb);
-extern void unregister_dock_notifier(struct notifier_block *nb);
 extern int register_hotplug_dock_device(acpi_handle handle,
 					const struct acpi_dock_ops *ops,
 					void *context,
@@ -132,13 +131,6 @@ static inline int is_dock_device(acpi_ha
 {
 	return 0;
 }
-static inline int register_dock_notifier(struct notifier_block *nb)
-{
-	return -ENODEV;
-}
-static inline void unregister_dock_notifier(struct notifier_block *nb)
-{
-}
 static inline int register_hotplug_dock_device(acpi_handle handle,
 					       const struct acpi_dock_ops *ops,
 					       void *context,
Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -122,7 +122,6 @@ struct acpiphp_func {
 	struct acpiphp_slot *slot;	/* parent */
 
 	struct list_head sibling;
-	struct notifier_block nb;
 	acpi_handle	handle;
 
 	u8		function;	/* pci function# */
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -119,15 +119,14 @@ static void free_bridge(struct kref *kre
  * TBD - figure out a way to only call fixups for
  * systems that require them.
  */
-static int post_dock_fixups(struct notifier_block *nb, unsigned long val,
-	void *v)
+static void post_dock_fixups(acpi_handle not_used, u32 event, void *data)
 {
-	struct acpiphp_func *func = container_of(nb, struct acpiphp_func, nb);
+	struct acpiphp_func *func = data;
 	struct pci_bus *bus = func->slot->bridge->pci_bus;
 	u32 buses;
 
 	if (!bus->self)
-		return  NOTIFY_OK;
+		return;
 
 	/* fixup bad _DCK function that rewrites
 	 * secondary bridge on slot
@@ -143,11 +142,11 @@ static int post_dock_fixups(struct notif
 			| ((unsigned int)(bus->busn_res.end) << 16);
 		pci_write_config_dword(bus->self, PCI_PRIMARY_BUS, buses);
 	}
-	return NOTIFY_OK;
 }
 
 
 static const struct acpi_dock_ops acpiphp_dock_ops = {
+	.fixup = post_dock_fixups,
 	.handler = hotplug_event_func,
 };
 
@@ -315,14 +314,6 @@ register_slot(acpi_handle handle, u32 lv
 			&acpiphp_dock_ops, newfunc,
 			acpiphp_dock_init, acpiphp_dock_release))
 			dbg("failed to register dock device\n");
-
-		/* we need to be notified when dock events happen
-		 * outside of the hotplug operation, since we may
-		 * need to do fixups before we can hotplug.
-		 */
-		newfunc->nb.notifier_call = post_dock_fixups;
-		if (register_dock_notifier(&newfunc->nb))
-			dbg("failed to register a dock notifier");
 	}
 
 	/* install notify handler */
@@ -472,7 +463,6 @@ static void cleanup_bridge(struct acpiph
 		list_for_each_entry(func, &slot->funcs, sibling) {
 			if (is_dock_device(func->handle)) {
 				unregister_hotplug_dock_device(func->handle);
-				unregister_dock_notifier(&func->nb);
 			}
 			if (!(func->flags & FUNC_HAS_DCK)) {
 				status = acpi_remove_notify_handler(func->handle,
Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -51,8 +51,6 @@ MODULE_PARM_DESC(immediate_undock, "1 (d
 	" the driver to wait for userspace to write the undock sysfs file "
 	" before undocking");
 
-static struct atomic_notifier_head dock_notifier_list;
-
 static const struct acpi_device_id dock_device_ids[] = {
 	{"LNXDOCK", 0},
 	{"", 0},
@@ -89,6 +87,12 @@ struct dock_dependent_device {
 #define DOCK_EVENT	3
 #define UNDOCK_EVENT	2
 
+enum dock_callback_type {
+	DOCK_CALL_HANDLER,
+	DOCK_CALL_FIXUP,
+	DOCK_CALL_UEVENT,
+};
+
 /*****************************************************************************
  *                         Dock Dependent device functions                   *
  *****************************************************************************/
@@ -179,7 +183,7 @@ static void dock_release_hotplug(struct
 }
 
 static void dock_hotplug_event(struct dock_dependent_device *dd, u32 event,
-			       bool uevent)
+			       enum dock_callback_type cb_type)
 {
 	acpi_notify_handler cb = NULL;
 	bool run = false;
@@ -189,8 +193,18 @@ static void dock_hotplug_event(struct do
 	if (dd->hp_context) {
 		run = true;
 		dd->hp_refcount++;
-		if (dd->hp_ops)
-			cb = uevent ? dd->hp_ops->uevent : dd->hp_ops->handler;
+		if (dd->hp_ops) {
+			switch (cb_type) {
+			case DOCK_CALL_FIXUP:
+				cb = dd->hp_ops->fixup;
+				break;
+			case DOCK_CALL_UEVENT:
+				cb = dd->hp_ops->uevent;
+				break;
+			default:
+				cb = dd->hp_ops->handler;
+			}
+		}
 	}
 
 	mutex_unlock(&hotplug_lock);
@@ -372,9 +386,13 @@ static void hotplug_dock_devices(struct
 {
 	struct dock_dependent_device *dd;
 
+	/* Call driver specific post-dock fixups. */
+	list_for_each_entry(dd, &ds->dependent_devices, list)
+		dock_hotplug_event(dd, event, DOCK_CALL_FIXUP);
+
 	/* Call driver specific hotplug functions. */
 	list_for_each_entry(dd, &ds->dependent_devices, list)
-		dock_hotplug_event(dd, event, false);
+		dock_hotplug_event(dd, event, DOCK_CALL_HANDLER);
 
 	/*
 	 * Now make sure that an acpi_device is created for each dependent
@@ -405,7 +423,7 @@ static void dock_event(struct dock_stati
 		kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
 
 	list_for_each_entry(dd, &ds->dependent_devices, list)
-		dock_hotplug_event(dd, event, true);
+		dock_hotplug_event(dd, event, DOCK_CALL_UEVENT);
 
 	if (num != DOCK_EVENT)
 		kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
@@ -488,37 +506,6 @@ static int dock_in_progress(struct dock_
 }
 
 /**
- * register_dock_notifier - add yourself to the dock notifier list
- * @nb: the callers notifier block
- *
- * If a driver wishes to be notified about dock events, they can
- * use this function to put a notifier block on the dock notifier list.
- * this notifier call chain will be called after a dock event, but
- * before hotplugging any new devices.
- */
-int register_dock_notifier(struct notifier_block *nb)
-{
-	if (!dock_station_count)
-		return -ENODEV;
-
-	return atomic_notifier_chain_register(&dock_notifier_list, nb);
-}
-EXPORT_SYMBOL_GPL(register_dock_notifier);
-
-/**
- * unregister_dock_notifier - remove yourself from the dock notifier list
- * @nb: the callers notifier block
- */
-void unregister_dock_notifier(struct notifier_block *nb)
-{
-	if (!dock_station_count)
-		return;
-
-	atomic_notifier_chain_unregister(&dock_notifier_list, nb);
-}
-EXPORT_SYMBOL_GPL(unregister_dock_notifier);
-
-/**
  * register_hotplug_dock_device - register a hotplug function
  * @handle: the handle of the device
  * @ops: handlers to call after docking
@@ -658,8 +645,6 @@ static void dock_notify(struct dock_stat
 				complete_dock(ds);
 				break;
 			}
-			atomic_notifier_call_chain(&dock_notifier_list,
-						   event, NULL);
 			hotplug_dock_devices(ds, event);
 			complete_dock(ds);
 			dock_event(ds, event, DOCK_EVENT);
@@ -945,7 +930,6 @@ void __init acpi_dock_init(void)
 		return;
 	}
 
-	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 	pr_info(PREFIX "%s: %d docks/bays found\n",
 		ACPI_DOCK_DRIVER_DESCRIPTION, dock_station_count);
 }

