Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaBSBVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:21:24 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65207 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751718AbaBSBSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:18:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 7/9] ACPI / dock: Drop struct acpi_dock_ops and all code related to it
Date: Wed, 19 Feb 2014 02:31:35 +0100
Message-ID: <13294001.IuldAkXa07@vostro.rjw.lan>
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

Since struct acpi_dock_ops and the code handling it don't have any
users any more after the previous changes, drop that structure and
the code related to it altogether.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c         |  167 --------------------------------------------
 include/acpi/acpi_drivers.h |   22 -----
 2 files changed, 2 insertions(+), 187 deletions(-)

Index: linux-pm/include/acpi/acpi_drivers.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_drivers.h
+++ linux-pm/include/acpi/acpi_drivers.h
@@ -109,36 +109,14 @@ void pci_acpi_crs_quirks(void);
 /*--------------------------------------------------------------------------
                                   Dock Station
   -------------------------------------------------------------------------- */
-struct acpi_dock_ops {
-	acpi_notify_handler fixup;
-	acpi_notify_handler handler;
-	acpi_notify_handler uevent;
-};
 
 #ifdef CONFIG_ACPI_DOCK
 extern int is_dock_device(struct acpi_device *adev);
-extern int register_hotplug_dock_device(acpi_handle handle,
-					const struct acpi_dock_ops *ops,
-					void *context,
-					void (*init)(void *),
-					void (*release)(void *));
-extern void unregister_hotplug_dock_device(acpi_handle handle);
 #else
 static inline int is_dock_device(struct acpi_device *adev)
 {
 	return 0;
 }
-static inline int register_hotplug_dock_device(acpi_handle handle,
-					       const struct acpi_dock_ops *ops,
-					       void *context,
-					       void (*init)(void *),
-					       void (*release)(void *))
-{
-	return -ENODEV;
-}
-static inline void unregister_hotplug_dock_device(acpi_handle handle)
-{
-}
 #endif /* CONFIG_ACPI_DOCK */
 
 #endif /*__ACPI_DRIVERS_H__*/
Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -68,15 +68,10 @@ struct dock_station {
 };
 static LIST_HEAD(dock_stations);
 static int dock_station_count;
-static DEFINE_MUTEX(hotplug_lock);
 
 struct dock_dependent_device {
 	struct list_head list;
 	struct acpi_device *adev;
-	const struct acpi_dock_ops *hp_ops;
-	void *hp_context;
-	unsigned int hp_refcount;
-	void (*hp_release)(void *);
 };
 
 #define DOCK_DOCKING	0x00000001
@@ -129,70 +124,15 @@ static void remove_dock_dependent_device
 	}
 }
 
-/**
- * dock_init_hotplug - Initialize a hotplug device on a docking station.
- * @dd: Dock-dependent device.
- * @ops: Dock operations to attach to the dependent device.
- * @context: Data to pass to the @ops callbacks and @release.
- * @init: Optional initialization routine to run after setting up context.
- * @release: Optional release routine to run on removal.
- */
-static int dock_init_hotplug(struct dock_dependent_device *dd,
-			     const struct acpi_dock_ops *ops, void *context,
-			     void (*init)(void *), void (*release)(void *))
-{
-	int ret = 0;
-
-	mutex_lock(&hotplug_lock);
-	if (WARN_ON(dd->hp_context)) {
-		ret = -EEXIST;
-	} else {
-		dd->hp_refcount = 1;
-		dd->hp_ops = ops;
-		dd->hp_context = context;
-		dd->hp_release = release;
-		if (init)
-			init(context);
-	}
-	mutex_unlock(&hotplug_lock);
-	return ret;
-}
-
-/**
- * dock_release_hotplug - Decrement hotplug reference counter of dock device.
- * @dd: Dock-dependent device.
- *
- * Decrement the reference counter of @dd and if 0, detach its hotplug
- * operations from it, reset its context pointer and run the optional release
- * routine if present.
- */
-static void dock_release_hotplug(struct dock_dependent_device *dd)
-{
-	mutex_lock(&hotplug_lock);
-	if (dd->hp_context && !--dd->hp_refcount) {
-		void (*release)(void *) = dd->hp_release;
-		void *context = dd->hp_context;
-
-		dd->hp_ops = NULL;
-		dd->hp_context = NULL;
-		dd->hp_release = NULL;
-		if (release)
-			release(context);
-	}
-	mutex_unlock(&hotplug_lock);
-}
-
 static void dock_hotplug_event(struct dock_dependent_device *dd, u32 event,
 			       enum dock_callback_type cb_type)
 {
 	struct acpi_device *adev = dd->adev;
-	acpi_notify_handler cb = NULL;
-	bool run = false;
 
 	acpi_lock_hp_context();
 
 	if (!adev->hp)
-		goto no_context;
+		goto out;
 
 	if (cb_type == DOCK_CALL_FIXUP) {
 		void (*fixup)(struct acpi_device *);
@@ -223,37 +163,8 @@ static void dock_hotplug_event(struct do
 		}
 	}
 
- no_context:
+ out:
 	acpi_unlock_hp_context();
-
-	mutex_lock(&hotplug_lock);
-
-	if (dd->hp_context) {
-		run = true;
-		dd->hp_refcount++;
-		if (dd->hp_ops) {
-			switch (cb_type) {
-			case DOCK_CALL_FIXUP:
-				cb = dd->hp_ops->fixup;
-				break;
-			case DOCK_CALL_UEVENT:
-				cb = dd->hp_ops->uevent;
-				break;
-			default:
-				cb = dd->hp_ops->handler;
-			}
-		}
-	}
-
-	mutex_unlock(&hotplug_lock);
-
-	if (!run)
-		return;
-
-	if (cb)
-		cb(dd->adev->handle, event, dd->hp_context);
-
-	dock_release_hotplug(dd);
 }
 
 static struct dock_station *find_dock_station(acpi_handle handle)
@@ -506,80 +417,6 @@ static int dock_in_progress(struct dock_
 }
 
 /**
- * register_hotplug_dock_device - register a hotplug function
- * @handle: the handle of the device
- * @ops: handlers to call after docking
- * @context: device specific data
- * @init: Optional initialization routine to run after registration
- * @release: Optional release routine to run on unregistration
- *
- * If a driver would like to perform a hotplug operation after a dock
- * event, they can register an acpi_notifiy_handler to be called by
- * the dock driver after _DCK is executed.
- */
-int register_hotplug_dock_device(acpi_handle handle,
-				 const struct acpi_dock_ops *ops, void *context,
-				 void (*init)(void *), void (*release)(void *))
-{
-	struct dock_dependent_device *dd;
-	struct dock_station *dock_station;
-	struct acpi_device *adev;
-	int ret = -EINVAL;
-
-	if (WARN_ON(!context))
-		return -EINVAL;
-
-	if (!dock_station_count)
-		return -ENODEV;
-
-	ret = acpi_bus_get_device(handle, &adev);
-	if (ret)
-		return ret;
-
-	/*
-	 * make sure this handle is for a device dependent on the dock,
-	 * this would include the dock station itself
-	 */
-	list_for_each_entry(dock_station, &dock_stations, sibling) {
-		/*
-		 * An ATA bay can be in a dock and itself can be ejected
-		 * separately, so there are two 'dock stations' which need the
-		 * ops
-		 */
-		dd = find_dock_dependent_device(dock_station, adev);
-		if (dd && !dock_init_hotplug(dd, ops, context, init, release))
-			ret = 0;
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(register_hotplug_dock_device);
-
-/**
- * unregister_hotplug_dock_device - remove yourself from the hotplug list
- * @handle: the acpi handle of the device
- */
-void unregister_hotplug_dock_device(acpi_handle handle)
-{
-	struct dock_dependent_device *dd;
-	struct dock_station *dock_station;
-	struct acpi_device *adev;
-
-	if (!dock_station_count)
-		return;
-
-	if (acpi_bus_get_device(handle, &adev))
-		return;
-
-	list_for_each_entry(dock_station, &dock_stations, sibling) {
-		dd = find_dock_dependent_device(dock_station, adev);
-		if (dd)
-			dock_release_hotplug(dd);
-	}
-}
-EXPORT_SYMBOL_GPL(unregister_hotplug_dock_device);
-
-/**
  * handle_eject_request - handle an undock request checking for error conditions
  *
  * Check to make sure the dock device is still present, then undock and

