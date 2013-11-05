Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab3KEXf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:35:59 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57861 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755762Ab3KEXf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:35:56 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/3] ACPI / hotplug: Consolidate deferred execution of ACPI hotplug routines
Date: Wed, 06 Nov 2013 00:48:08 +0100
Message-ID: <1504641.FxROjG9bfM@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <18462848.9zsetEL1Yy@vostro.rjw.lan>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan> <2970389.SeMGM45Qln@vostro.rjw.lan> <18462848.9zsetEL1Yy@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

There are two different interfaces for queuing up work items on the
ACPI hotplug workqueue, alloc_acpi_hp_work() used by PCI and PCI host
bridge hotplug code and acpi_os_hotplug_execute() used by the common
ACPI hotplug code and docking stations.  They both are somewhat
cumbersome to use and work slightly differently.

The users of alloc_acpi_hp_work() have to submit a work function that
will extract the necessary data items from a struct acpi_hp_work
object allocated by alloc_acpi_hp_work() and then will free that
object, while it would be more straightforward to simply use a work
function with one more argument and let the interface take care of
the execution details.

The users of acpi_os_hotplug_execute() also have to deal with the
fact that it takes only one argument in addition to the work function
pointer, although acpi_os_execute_deferred() actually takes care of
the allocation and freeing of memory, so it would have been able to
pass more arguments to the work function if it hadn't been
constrained by the connection with acpi_os_execute().

Moreover, while alloc_acpi_hp_work() makes GFP_KERNEL memory
allocations, which is correct, because hotplug work items are
always queued up from process context, acpi_os_hotplug_execute()
uses GFP_ATOMIC, as that is needed by acpi_os_execute().  Also,
acpi_os_execute_deferred() queued up by it waits for the ACPI event
workqueues to flush before calling the work function, while
alloc_acpi_hp_work() obviously can't do anything like that.  That
leads to somewhat arbitrary differences in behavior between various
ACPI hotplug code paths and has to be straightened up.

For this reason, replace both alloc_acpi_hp_work() and
acpi_os_hotplug_execute() with a single interface,
acpi_hotplug_execute(), combining their behavior and being more
friendly to its users than any of the two.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c                |   25 +--------
 drivers/acpi/internal.h            |    2 
 drivers/acpi/osl.c                 |   96 +++++++++++++++++--------------------
 drivers/acpi/pci_root.c            |   14 +----
 drivers/acpi/scan.c                |   43 +++-------------
 drivers/pci/hotplug/acpiphp_glue.c |   18 ++----
 include/acpi/acpi_bus.h            |   12 +---
 include/acpi/platform/aclinux.h    |    3 -
 8 files changed, 71 insertions(+), 142 deletions(-)

Index: linux-pm/drivers/acpi/osl.c
===================================================================
--- linux-pm.orig/drivers/acpi/osl.c
+++ linux-pm/drivers/acpi/osl.c
@@ -61,7 +61,6 @@ struct acpi_os_dpc {
 	acpi_osd_exec_callback function;
 	void *context;
 	struct work_struct work;
-	int wait;
 };
 
 #ifdef CONFIG_ACPI_CUSTOM_DSDT
@@ -1087,9 +1086,6 @@ static void acpi_os_execute_deferred(str
 {
 	struct acpi_os_dpc *dpc = container_of(work, struct acpi_os_dpc, work);
 
-	if (dpc->wait)
-		acpi_os_wait_events_complete();
-
 	dpc->function(dpc->context);
 	kfree(dpc);
 }
@@ -1109,8 +1105,8 @@ static void acpi_os_execute_deferred(str
  *
  ******************************************************************************/
 
-static acpi_status __acpi_os_execute(acpi_execute_type type,
-	acpi_osd_exec_callback function, void *context, int hp)
+acpi_status acpi_os_execute(acpi_execute_type type,
+			    acpi_osd_exec_callback function, void *context)
 {
 	acpi_status status = AE_OK;
 	struct acpi_os_dpc *dpc;
@@ -1137,20 +1133,11 @@ static acpi_status __acpi_os_execute(acp
 	dpc->context = context;
 
 	/*
-	 * We can't run hotplug code in keventd_wq/kacpid_wq/kacpid_notify_wq
-	 * because the hotplug code may call driver .remove() functions,
-	 * which invoke flush_scheduled_work/acpi_os_wait_events_complete
-	 * to flush these workqueues.
-	 *
 	 * To prevent lockdep from complaining unnecessarily, make sure that
 	 * there is a different static lockdep key for each workqueue by using
 	 * INIT_WORK() for each of them separately.
 	 */
-	if (hp) {
-		queue = kacpi_hotplug_wq;
-		dpc->wait = 1;
-		INIT_WORK(&dpc->work, acpi_os_execute_deferred);
-	} else if (type == OSL_NOTIFY_HANDLER) {
+	if (type == OSL_NOTIFY_HANDLER) {
 		queue = kacpi_notify_wq;
 		INIT_WORK(&dpc->work, acpi_os_execute_deferred);
 	} else {
@@ -1175,28 +1162,59 @@ static acpi_status __acpi_os_execute(acp
 	}
 	return status;
 }
+EXPORT_SYMBOL(acpi_os_execute);
 
-acpi_status acpi_os_execute(acpi_execute_type type,
-			    acpi_osd_exec_callback function, void *context)
+void acpi_os_wait_events_complete(void)
 {
-	return __acpi_os_execute(type, function, context, 0);
+	flush_workqueue(kacpid_wq);
+	flush_workqueue(kacpi_notify_wq);
 }
-EXPORT_SYMBOL(acpi_os_execute);
 
-acpi_status acpi_os_hotplug_execute(acpi_osd_exec_callback function,
-	void *context)
+struct acpi_hp_work {
+	struct work_struct work;
+	acpi_hp_callback func;
+	void *data;
+	u32 src;
+};
+
+static void acpi_hotplug_work_fn(struct work_struct *work)
 {
-	return __acpi_os_execute(0, function, context, 1);
+	struct acpi_hp_work *hpw = container_of(work, struct acpi_hp_work, work);
+
+	acpi_os_wait_events_complete();
+	hpw->func(hpw->data, hpw->src);
+	kfree(hpw);
 }
-EXPORT_SYMBOL(acpi_os_hotplug_execute);
 
-void acpi_os_wait_events_complete(void)
+acpi_status acpi_hotplug_execute(acpi_hp_callback func, void *data, u32 src)
 {
-	flush_workqueue(kacpid_wq);
-	flush_workqueue(kacpi_notify_wq);
+	struct acpi_hp_work *hpw;
+
+	ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
+		  "Scheduling function [%p(%p, %u)] for deferred execution.\n",
+		  func, data, src));
+
+	hpw = kmalloc(sizeof(*hpw), GFP_KERNEL);
+	if (!hpw)
+		return AE_NO_MEMORY;
+
+	INIT_WORK(&hpw->work, acpi_hotplug_work_fn);
+	hpw->func = func;
+	hpw->data = data;
+	hpw->src = src;
+	/*
+	 * We can't run hotplug code in kacpid_wq/kacpid_notify_wq etc., because
+	 * the hotplug code may call driver .remove() functions, which may
+	 * invoke flush_scheduled_work()/acpi_os_wait_events_complete() to flush
+	 * these workqueues.
+	 */
+	if (!queue_work(kacpi_hotplug_wq, &hpw->work)) {
+		kfree(hpw);
+		return AE_ERROR;
+	}
+	return AE_OK;
 }
 
-EXPORT_SYMBOL(acpi_os_wait_events_complete);
 
 acpi_status
 acpi_os_create_semaphore(u32 max_units, u32 initial_units, acpi_handle * handle)
@@ -1845,25 +1863,3 @@ void acpi_os_set_prepare_extended_sleep(
 {
 	__acpi_os_prepare_extended_sleep = func;
 }
-
-
-void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
-			void (*func)(struct work_struct *work))
-{
-	struct acpi_hp_work *hp_work;
-	int ret;
-
-	hp_work = kmalloc(sizeof(*hp_work), GFP_KERNEL);
-	if (!hp_work)
-		return;
-
-	hp_work->handle = handle;
-	hp_work->type = type;
-	hp_work->context = context;
-
-	INIT_WORK(&hp_work->work, func);
-	ret = queue_work(kacpi_hotplug_wq, &hp_work->work);
-	if (!ret)
-		kfree(hp_work);
-}
-EXPORT_SYMBOL_GPL(alloc_acpi_hp_work);
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -339,15 +339,6 @@ struct acpi_bus_event {
 	u32 data;
 };
 
-struct acpi_hp_work {
-	struct work_struct work;
-	acpi_handle handle;
-	u32 type;
-	void *context;
-};
-void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
-			void (*func)(struct work_struct *work));
-
 extern struct kobject *acpi_kobj;
 extern int acpi_bus_generate_netlink_event(const char*, const char*, u8, int);
 void acpi_bus_private_data_handler(acpi_handle, void *);
@@ -393,6 +384,9 @@ int acpi_match_device_ids(struct acpi_de
 int acpi_create_dir(struct acpi_device *);
 void acpi_remove_dir(struct acpi_device *);
 
+typedef void (*acpi_hp_callback)(void *data, u32 src);
+
+acpi_status acpi_hotplug_execute(acpi_hp_callback func, void *data, u32 src);
 
 /**
  * module_acpi_driver(acpi_driver) - Helper macro for registering an ACPI driver
Index: linux-pm/include/acpi/platform/aclinux.h
===================================================================
--- linux-pm.orig/include/acpi/platform/aclinux.h
+++ linux-pm/include/acpi/platform/aclinux.h
@@ -243,9 +243,6 @@ void acpi_os_gpe_count(u32 gpe_number);
 
 void acpi_os_fixed_event_count(u32 fixed_event_number);
 
-acpi_status
-acpi_os_hotplug_execute(acpi_osd_exec_callback function, void *context);
-
 #endif				/* __KERNEL__ */
 
 #endif				/* __ACLINUX_H__ */
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -286,8 +286,9 @@ static int acpi_scan_hot_remove(struct a
 	return 0;
 }
 
-void acpi_bus_device_eject(struct acpi_device *device, u32 ost_src)
+void acpi_bus_device_eject(void *data, u32 ost_src)
 {
+	struct acpi_device *device = data;
 	acpi_handle handle = device->handle;
 	struct acpi_scan_handler *handler;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
@@ -328,8 +329,9 @@ void acpi_bus_device_eject(struct acpi_d
 	goto out;
 }
 
-static void acpi_scan_bus_device_check(acpi_handle handle, u32 ost_source)
+static void acpi_scan_bus_device_check(void *data, u32 ost_source)
 {
+	acpi_handle handle = data;
 	struct acpi_device *device = NULL;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 	int error;
@@ -364,18 +366,6 @@ static void acpi_scan_bus_device_check(a
 	unlock_device_hotplug();
 }
 
-static void acpi_scan_bus_check(void *context)
-{
-	acpi_scan_bus_device_check((acpi_handle)context,
-				   ACPI_NOTIFY_BUS_CHECK);
-}
-
-static void acpi_scan_device_check(void *context)
-{
-	acpi_scan_bus_device_check((acpi_handle)context,
-				   ACPI_NOTIFY_DEVICE_CHECK);
-}
-
 static void acpi_hotplug_unsupported(acpi_handle handle, u32 type)
 {
 	u32 ost_status;
@@ -404,18 +394,8 @@ static void acpi_hotplug_unsupported(acp
 	acpi_evaluate_hotplug_ost(handle, type, ost_status, NULL);
 }
 
-/**
- * acpi_bus_hot_remove_device: Hot-remove a device and its children.
- * @context: Address of the ACPI device object to hot-remove.
- */
-static void acpi_bus_hot_remove_device(void *context)
-{
-	acpi_bus_device_eject(context, ACPI_NOTIFY_EJECT_REQUEST);
-}
-
 static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
 {
-	acpi_osd_exec_callback callback;
 	struct acpi_scan_handler *handler = data;
 	struct acpi_device *adev;
 	acpi_status status;
@@ -426,11 +406,9 @@ static void acpi_hotplug_notify_cb(acpi_
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_BUS_CHECK event\n");
-		callback = acpi_scan_bus_check;
 		break;
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_DEVICE_CHECK event\n");
-		callback = acpi_scan_device_check;
 		break;
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
@@ -439,8 +417,7 @@ static void acpi_hotplug_notify_cb(acpi_
 			goto err_out;
 
 		get_device(&adev->dev);
-		callback = acpi_bus_hot_remove_device;
-		status = acpi_os_hotplug_execute(callback, adev);
+		status = acpi_hotplug_execute(acpi_bus_device_eject, adev, type);
 		if (ACPI_SUCCESS(status))
 			return;
 
@@ -450,7 +427,7 @@ static void acpi_hotplug_notify_cb(acpi_
 		/* non-hotplug event; possibly handled by other handler */
 		return;
 	}
-	status = acpi_os_hotplug_execute(callback, handle);
+	status = acpi_hotplug_execute(acpi_scan_bus_device_check, handle, type);
 	if (ACPI_SUCCESS(status))
 		return;
 
@@ -485,11 +462,6 @@ static ssize_t power_state_show(struct d
 
 static DEVICE_ATTR(power_state, 0444, power_state_show, NULL);
 
-static void acpi_eject_store_work(void *context)
-{
-	acpi_bus_device_eject(context, ACPI_OST_EC_OSPM_EJECT);
-}
-
 static ssize_t
 acpi_eject_store(struct device *d, struct device_attribute *attr,
 		const char *buf, size_t count)
@@ -512,7 +484,8 @@ acpi_eject_store(struct device *d, struc
 	acpi_evaluate_hotplug_ost(acpi_device->handle, ACPI_OST_EC_OSPM_EJECT,
 				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 	get_device(&acpi_device->dev);
-	status = acpi_os_hotplug_execute(acpi_eject_store_work, acpi_device);
+	status = acpi_hotplug_execute(acpi_bus_device_eject, acpi_device,
+				      ACPI_OST_EC_OSPM_EJECT);
 	if (ACPI_SUCCESS(status))
 		return count;
 
Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -598,16 +598,10 @@ static void handle_root_bridge_removal(s
 	acpi_bus_device_eject(device, ACPI_NOTIFY_EJECT_REQUEST);
 }
 
-static void _handle_hotplug_event_root(struct work_struct *work)
+static void hotplug_event_root(void *data, u32 type)
 {
+	acpi_handle handle = data;
 	struct acpi_pci_root *root;
-	struct acpi_hp_work *hp_work;
-	acpi_handle handle;
-	u32 type;
-
-	hp_work = container_of(work, struct acpi_hp_work, work);
-	handle = hp_work->handle;
-	type = hp_work->type;
 
 	acpi_scan_lock_acquire();
 
@@ -648,14 +642,12 @@ static void _handle_hotplug_event_root(s
 	}
 
 	acpi_scan_lock_release();
-	kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
 }
 
 static void handle_hotplug_event_root(acpi_handle handle, u32 type,
 					void *context)
 {
-	alloc_acpi_hp_work(handle, type, context,
-				_handle_hotplug_event_root);
+	acpi_hotplug_execute(hotplug_event_root, handle, type);
 }
 
 static acpi_status __init
Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -669,39 +669,20 @@ static void dock_notify(struct dock_stat
 	}
 }
 
-struct dock_data {
-	struct dock_station *ds;
-	u32 event;
-};
-
-static void acpi_dock_deferred_cb(void *context)
+static void acpi_dock_deferred_cb(void *data, u32 event)
 {
-	struct dock_data *data = context;
-
 	acpi_scan_lock_acquire();
-	dock_notify(data->ds, data->event);
+	dock_notify(data, event);
 	acpi_scan_lock_release();
-	kfree(data);
 }
 
 static void dock_notify_handler(acpi_handle handle, u32 event, void *data)
 {
-	struct dock_data *dd;
-
 	if (event != ACPI_NOTIFY_BUS_CHECK && event != ACPI_NOTIFY_DEVICE_CHECK
 	   && event != ACPI_NOTIFY_EJECT_REQUEST)
 		return;
 
-	dd = kmalloc(sizeof(*dd), GFP_KERNEL);
-	if (dd) {
-		acpi_status status;
-
-		dd->ds = data;
-		dd->event = event;
-		status = acpi_os_hotplug_execute(acpi_dock_deferred_cb, dd);
-		if (ACPI_FAILURE(status))
-			kfree(dd);
-	}
+	acpi_hotplug_execute(acpi_dock_deferred_cb, data, event);
 }
 
 /**
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -871,21 +871,17 @@ static void hotplug_event(acpi_handle ha
 		put_bridge(bridge);
 }
 
-static void hotplug_event_work(struct work_struct *work)
+static void hotplug_event_work(void *data, u32 type)
 {
-	struct acpiphp_context *context;
-	struct acpi_hp_work *hp_work;
+	struct acpiphp_context *context = data;
+	acpi_handle handle = context->handle;
 
-	hp_work = container_of(work, struct acpi_hp_work, work);
-	context = hp_work->context;
 	acpi_scan_lock_acquire();
 
-	hotplug_event(hp_work->handle, hp_work->type, context);
+	hotplug_event(handle, type, context);
 
 	acpi_scan_lock_release();
-	acpi_evaluate_hotplug_ost(hp_work->handle, hp_work->type,
-				  ACPI_OST_SC_SUCCESS, NULL);
-	kfree(hp_work); /* allocated in handle_hotplug_event() */
+	acpi_evaluate_hotplug_ost(handle, type, ACPI_OST_SC_SUCCESS, NULL);
 	put_bridge(context->func.parent);
 }
 
@@ -936,10 +932,10 @@ static void handle_hotplug_event(acpi_ha
 
 	mutex_lock(&acpiphp_context_lock);
 	context = acpiphp_get_context(handle);
-	if (context) {
+	if (context && !WARN_ON(context->handle != handle)) {
 		get_bridge(context->func.parent);
 		acpiphp_put_context(context);
-		alloc_acpi_hp_work(handle, type, context, hotplug_event_work);
+		acpi_hotplug_execute(hotplug_event_work, context, type);
 		mutex_unlock(&acpiphp_context_lock);
 		return;
 	}
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -92,7 +92,7 @@ void acpi_device_add_finalize(struct acp
 void acpi_free_pnp_ids(struct acpi_device_pnp *pnp);
 int acpi_bind_one(struct device *dev, acpi_handle handle);
 int acpi_unbind_one(struct device *dev);
-void acpi_bus_device_eject(struct acpi_device *device, u32 ost_src);
+void acpi_bus_device_eject(void *data, u32 ost_src);
 
 /* --------------------------------------------------------------------------
                                   Power Resource

