Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab3KQQ1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:27:11 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60315 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754406Ab3KQQZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:25:53 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>
Subject: [PATCH 2/10] ACPI / scan: Define non-empty device removal handler
Date: Sun, 17 Nov 2013 17:31:50 +0100
Message-ID: <1441676.GMPXue5xNm@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1421028.Rsfpmhnym3@vostro.rjw.lan>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

If an ACPI namespace node is removed (usually, as a result of a
table unload), and there is a data object attached to that node,
acpi_ns_delete_node() executes the removal handler submitted to
acpi_attach_data() for that object.  That handler is currently empty
for struct acpi_device objects, so it is necessary to detach those
objects from the corresponding ACPI namespace nodes in advance every
time a table unload may happen.  That is cumbersome and inefficient
and leads to some design constraints that turn out to be quite
inconvenient (in particular, struct acpi_device objects cannot be
registered for namespace nodes representing devices that are not
reported as present or functional by _STA).

For this reason, introduce a non-empty removal handler for ACPI
device objects that will unregister them when their ACPI namespace
nodes go away.

This code modification alone should not change functionality except
for the ordering of the ACPI hotplug workqueue which should not
matter (without subsequent code changes).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |    2 
 drivers/acpi/osl.c      |    6 ++
 drivers/acpi/scan.c     |  114 +++++++++++++++++++++++++++++++++++++++---------
 include/acpi/acpi_bus.h |    1 
 4 files changed, 102 insertions(+), 21 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -14,6 +14,8 @@
 
 #include <acpi/acpi_drivers.h>
 
+#include <asm/pgtable.h>
+
 #include "internal.h"
 
 #define _COMPONENT		ACPI_BUS_COMPONENT
@@ -27,6 +29,8 @@ extern struct acpi_device *acpi_root;
 
 #define ACPI_IS_ROOT_DEVICE(device)    (!(device)->parent)
 
+#define INVALID_ACPI_HANDLE	((acpi_handle)empty_zero_page)
+
 /*
  * If set, devices will be hot-removed even if they cannot be put offline
  * gracefully (from the kernel's standpoint).
@@ -907,9 +911,91 @@ struct bus_type acpi_bus_type = {
 	.uevent		= acpi_device_uevent,
 };
 
-static void acpi_bus_data_handler(acpi_handle handle, void *context)
+static void acpi_device_del(struct acpi_device *device)
+{
+	mutex_lock(&acpi_device_lock);
+	if (device->parent)
+		list_del(&device->node);
+
+	list_del(&device->wakeup_list);
+	mutex_unlock(&acpi_device_lock);
+
+	acpi_power_add_remove_device(device, false);
+	acpi_device_remove_files(device);
+	if (device->remove)
+		device->remove(device);
+
+	device_del(&device->dev);
+}
+
+static LIST_HEAD(acpi_device_del_list);
+static DEFINE_MUTEX(acpi_device_del_lock);
+
+static void acpi_device_del_work_fn(struct work_struct *work_not_used)
+{
+	for (;;) {
+		struct acpi_device *adev;
+
+		mutex_lock(&acpi_device_del_lock);
+
+		if (list_empty(&acpi_device_del_list)) {
+			mutex_unlock(&acpi_device_del_lock);
+			break;
+		}
+		adev = list_first_entry(&acpi_device_del_list,
+					struct acpi_device, del_list);
+		list_del(&adev->del_list);
+
+		mutex_unlock(&acpi_device_del_lock);
+
+		acpi_device_del(adev);
+		/*
+		 * Drop references to all power resources that might have been
+		 * used by the device.
+		 */
+		acpi_power_transition(adev, ACPI_STATE_D3_COLD);
+		put_device(&adev->dev);
+	}
+}
+
+/**
+ * acpi_scan_drop_device - Drop an ACPI device object.
+ * @handle: Handle of an ACPI namespace node, not used.
+ * @context: Address of the ACPI device object to drop.
+ *
+ * This is invoked by acpi_ns_delete_node() during the removal of the ACPI
+ * namespace node the device object pointed to by @context is attached to.
+ *
+ * The unregistration is carried out asynchronously to avoid running
+ * acpi_device_del() under the ACPICA's namespace mutex and the list is used to
+ * ensure the correct ordering (the device objects must be unregistered in the
+ * same order in which the corresponding namespace nodes are deleted).
+ */
+static void acpi_scan_drop_device(acpi_handle handle, void *context)
 {
-	/* Intentionally empty. */
+	static DECLARE_WORK(work, acpi_device_del_work_fn);
+	struct acpi_device *adev = context;
+
+	mutex_lock(&acpi_device_del_lock);
+
+	/*
+	 * Use the ACPI hotplug workqueue which is ordered, so this work item
+	 * won't run after any hotplug work items submitted subsequently.  That
+	 * prevents attempts to register device objects identical to those being
+	 * deleted from happening concurrently (such attempts result from
+	 * hotplug events handled via the ACPI hotplug workqueue).  It also will
+	 * run after all of the work items submitted previosuly, which helps
+	 * those work items to ensure that they are not accessing stale device
+	 * objects.
+	 */
+	if (list_empty(&acpi_device_del_list))
+		acpi_queue_hotplug_work(&work);
+
+	list_add_tail(&adev->del_list, &acpi_device_del_list);
+	/* Make acpi_ns_validate_handle() return NULL for this handle. */
+	adev->handle = INVALID_ACPI_HANDLE;
+
+	mutex_unlock(&acpi_device_del_lock);
 }
 
 int acpi_bus_get_device(acpi_handle handle, struct acpi_device **device)
@@ -919,7 +1005,7 @@ int acpi_bus_get_device(acpi_handle hand
 	if (!device)
 		return -EINVAL;
 
-	status = acpi_get_data(handle, acpi_bus_data_handler, (void **)device);
+	status = acpi_get_data(handle, acpi_scan_drop_device, (void **)device);
 	if (ACPI_FAILURE(status) || !*device) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No context for object [%p]\n",
 				  handle));
@@ -939,7 +1025,7 @@ int acpi_device_add(struct acpi_device *
 	if (device->handle) {
 		acpi_status status;
 
-		status = acpi_attach_data(device->handle, acpi_bus_data_handler,
+		status = acpi_attach_data(device->handle, acpi_scan_drop_device,
 					  device);
 		if (ACPI_FAILURE(status)) {
 			acpi_handle_err(device->handle,
@@ -957,6 +1043,7 @@ int acpi_device_add(struct acpi_device *
 	INIT_LIST_HEAD(&device->node);
 	INIT_LIST_HEAD(&device->wakeup_list);
 	INIT_LIST_HEAD(&device->physical_node_list);
+	INIT_LIST_HEAD(&device->del_list);
 	mutex_init(&device->physical_node_lock);
 
 	new_bus_id = kzalloc(sizeof(struct acpi_device_bus_id), GFP_KERNEL);
@@ -1020,27 +1107,14 @@ int acpi_device_add(struct acpi_device *
 	mutex_unlock(&acpi_device_lock);
 
  err_detach:
-	acpi_detach_data(device->handle, acpi_bus_data_handler);
+	acpi_detach_data(device->handle, acpi_scan_drop_device);
 	return result;
 }
 
 static void acpi_device_unregister(struct acpi_device *device)
 {
-	mutex_lock(&acpi_device_lock);
-	if (device->parent)
-		list_del(&device->node);
-
-	list_del(&device->wakeup_list);
-	mutex_unlock(&acpi_device_lock);
-
-	acpi_detach_data(device->handle, acpi_bus_data_handler);
-
-	acpi_power_add_remove_device(device, false);
-	acpi_device_remove_files(device);
-	if (device->remove)
-		device->remove(device);
-
-	device_del(&device->dev);
+	acpi_detach_data(device->handle, acpi_scan_drop_device);
+	acpi_device_del(device);
 	/*
 	 * Transition the device to D3cold to drop the reference counts of all
 	 * power resources the device depends on and turn off the ones that have
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -298,6 +298,7 @@ struct acpi_device {
 	struct list_head children;
 	struct list_head node;
 	struct list_head wakeup_list;
+	struct list_head del_list;
 	struct acpi_device_status status;
 	struct acpi_device_flags flags;
 	struct acpi_device_pnp pnp;
Index: linux-pm/drivers/acpi/osl.c
===================================================================
--- linux-pm.orig/drivers/acpi/osl.c
+++ linux-pm/drivers/acpi/osl.c
@@ -1215,6 +1215,10 @@ acpi_status acpi_hotplug_execute(acpi_hp
 	return AE_OK;
 }
 
+bool acpi_queue_hotplug_work(struct work_struct *work)
+{
+	return queue_work(kacpi_hotplug_wq, work);
+}
 
 acpi_status
 acpi_os_create_semaphore(u32 max_units, u32 initial_units, acpi_handle * handle)
@@ -1794,7 +1798,7 @@ acpi_status __init acpi_os_initialize1(v
 {
 	kacpid_wq = alloc_workqueue("kacpid", 0, 1);
 	kacpi_notify_wq = alloc_workqueue("kacpi_notify", 0, 1);
-	kacpi_hotplug_wq = alloc_workqueue("kacpi_hotplug", 0, 1);
+	kacpi_hotplug_wq = alloc_ordered_workqueue("kacpi_hotplug", 0);
 	BUG_ON(!kacpid_wq);
 	BUG_ON(!kacpi_notify_wq);
 	BUG_ON(!kacpi_hotplug_wq);
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -73,6 +73,8 @@ void acpi_lpss_init(void);
 static inline void acpi_lpss_init(void) {}
 #endif
 
+bool acpi_queue_hotplug_work(struct work_struct *work);
+
 /* --------------------------------------------------------------------------
                      Device Node Initialization / Removal
    -------------------------------------------------------------------------- */

