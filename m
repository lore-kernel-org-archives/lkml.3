Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3KQQ1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:27:38 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56732 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754393Ab3KQQZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:25:52 -0500
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
Subject: [PATCH 3/10] ACPI / scan: Add acpi_device objects for all device nodes in the namespace
Date: Sun, 17 Nov 2013 17:33:10 +0100
Message-ID: <3185505.phPUOjmG2O@vostro.rjw.lan>
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

Modify the ACPI namespace scanning code to register a struct
acpi_device object for every namespace node representing a device,
processor and so on, even if the device represented by that namespace
node is reported to be not present and not functional by _STA.

There are multiple reasons to do that.  First of all, it avoids
quite a lot of overhead when struct acpi_device objects are
deleted every time acpi_bus_trim() is run and then added again
by a subsequent acpi_bus_scan() for the same scope, although the
namespace objects they correspond to stay in memory all the time
(which always is the case on a vast majority of systems).

Second, it will allow user space to see that there are namespace
nodes representing devices that are not present at the moment and may
be added to the system.  It will also allow user space to evaluate
_SUN for those nodes to check what physical slots the "missing"
devices may be put into and it will make sense to add a sysfs
attribute for _STA evaluation after this change (that will be
useful for thermal management on some systems).

Next, it will help to consolidate the ACPI hotplug handling among
subsystems by making it possible to store hotplug-related information
in struct acpi_device objects in a standard common way.

Finally, it will help to avoid a race condition related to the
deletion of ACPI namespace nodes.  Namely, namespace nodes may be
deleted as a result of a table unload triggered by _EJ0 or _DCK.
If a hotplug notification for one of those nodes is triggered
right before the deletion and it executes a hotplug callback
via acpi_hotplug_execute(), the ACPI handle passed to that
callback may be stale when the callback actually runs.  One way
to work around that is to always pass struct acpi_device pointers
to hotplug callbacks after doing a get_device() on the objects in
question which eliminates the use-after-free possibility (the ACPI
handles in those objects are invalidated by acpi_scan_drop_device(),
so they will trigger ACPICA errors on attempts to use them).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/acpi/namespace.txt   |   10 ---
 drivers/acpi/device_pm.c           |   22 ++++++-
 drivers/acpi/dock.c                |    9 +--
 drivers/acpi/internal.h            |    3 +
 drivers/acpi/pci_root.c            |    5 +
 drivers/acpi/scan.c                |  107 +++++++++++++++++--------------------
 drivers/pci/hotplug/acpiphp_glue.c |    2 
 drivers/xen/xen-acpi-cpuhotplug.c  |    8 +-
 drivers/xen/xen-acpi-memhotplug.c  |    7 +-
 include/acpi/acpi_bus.h            |    9 ++-
 10 files changed, 98 insertions(+), 84 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -168,7 +168,9 @@ struct acpi_device_flags {
 	u32 ejectable:1;
 	u32 power_manageable:1;
 	u32 match_driver:1;
-	u32 reserved:27;
+	u32 initialized:1;
+	u32 visited:1;
+	u32 reserved:25;
 };
 
 /* File System */
@@ -385,6 +387,11 @@ int acpi_match_device_ids(struct acpi_de
 int acpi_create_dir(struct acpi_device *);
 void acpi_remove_dir(struct acpi_device *);
 
+static inline bool acpi_device_enumerated(struct acpi_device *adev)
+{
+	return adev && adev->flags.initialized && adev->flags.visited;
+}
+
 typedef void (*acpi_hp_callback)(void *data, u32 src);
 
 acpi_status acpi_hotplug_execute(acpi_hp_callback func, void *data, u32 src);
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -259,7 +259,6 @@ static int acpi_scan_hot_remove(struct a
 
 	acpi_bus_trim(device);
 
-	/* Device node has been unregistered. */
 	put_device(&device->dev);
 	device = NULL;
 
@@ -328,7 +327,7 @@ void acpi_bus_device_eject(void *data, u
 static void acpi_scan_bus_device_check(void *data, u32 ost_source)
 {
 	acpi_handle handle = data;
-	struct acpi_device *device = NULL;
+	struct acpi_device *device;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 	int error;
 
@@ -336,8 +335,9 @@ static void acpi_scan_bus_device_check(v
 	mutex_lock(&acpi_scan_lock);
 
 	if (ost_source != ACPI_NOTIFY_BUS_CHECK) {
+		device = NULL;
 		acpi_bus_get_device(handle, &device);
-		if (device) {
+		if (acpi_device_enumerated(device)) {
 			dev_warn(&device->dev, "Attempt to re-insert\n");
 			goto out;
 		}
@@ -347,9 +347,10 @@ static void acpi_scan_bus_device_check(v
 		acpi_handle_warn(handle, "Namespace scan failure\n");
 		goto out;
 	}
-	error = acpi_bus_get_device(handle, &device);
-	if (error) {
-		acpi_handle_warn(handle, "Missing device node object\n");
+	device = NULL;
+	acpi_bus_get_device(handle, &device);
+	if (!acpi_device_enumerated(device)) {
+		acpi_handle_warn(handle, "Device not enumerated\n");
 		goto out;
 	}
 	ost_code = ACPI_OST_SC_SUCCESS;
@@ -1111,20 +1112,6 @@ int acpi_device_add(struct acpi_device *
 	return result;
 }
 
-static void acpi_device_unregister(struct acpi_device *device)
-{
-	acpi_detach_data(device->handle, acpi_scan_drop_device);
-	acpi_device_del(device);
-	/*
-	 * Transition the device to D3cold to drop the reference counts of all
-	 * power resources the device depends on and turn off the ones that have
-	 * no more references.
-	 */
-	acpi_device_set_power(device, ACPI_STATE_D3_COLD);
-	device->handle = NULL;
-	put_device(&device->dev);
-}
-
 /* --------------------------------------------------------------------------
                                  Driver Management
    -------------------------------------------------------------------------- */
@@ -1703,6 +1690,8 @@ void acpi_init_device_object(struct acpi
 	acpi_set_pnp_ids(handle, &device->pnp, type);
 	acpi_bus_get_flags(device);
 	device->flags.match_driver = false;
+	device->flags.initialized = true;
+	device->flags.visited = false;
 	device_initialize(&device->dev);
 	dev_set_uevent_suppress(&device->dev, true);
 }
@@ -1787,6 +1776,15 @@ static int acpi_bus_type_and_status(acpi
 	return 0;
 }
 
+bool acpi_device_is_present(struct acpi_device *adev)
+{
+	if (adev->status.present || adev->status.functional)
+		return true;
+
+	adev->flags.initialized = false;
+	return false;
+}
+
 static bool acpi_scan_handler_matching(struct acpi_scan_handler *handler,
 				       char *idstr,
 				       const struct acpi_device_id **matchid)
@@ -1880,18 +1878,6 @@ static acpi_status acpi_bus_check_add(ac
 
 	acpi_scan_init_hotplug(handle, type);
 
-	if (!(sta & ACPI_STA_DEVICE_PRESENT) &&
-	    !(sta & ACPI_STA_DEVICE_FUNCTIONING)) {
-		struct acpi_device_wakeup wakeup;
-
-		if (acpi_has_method(handle, "_PRW")) {
-			acpi_bus_extract_wakeup_device_power_package(handle,
-								     &wakeup);
-			acpi_power_resources_list_free(&wakeup.resources);
-		}
-		return AE_CTRL_DEPTH;
-	}
-
 	acpi_add_single_object(&device, handle, type, sta);
 	if (!device)
 		return AE_CTRL_DEPTH;
@@ -1930,32 +1916,50 @@ static acpi_status acpi_bus_device_attac
 					  void *not_used, void **ret_not_used)
 {
 	struct acpi_device *device;
-	unsigned long long sta_not_used;
+	unsigned long long sta;
 	int ret;
 
 	/*
 	 * Ignore errors ignored by acpi_bus_check_add() to avoid terminating
 	 * namespace walks prematurely.
 	 */
-	if (acpi_bus_type_and_status(handle, &ret, &sta_not_used))
+	if (acpi_bus_type_and_status(handle, &ret, &sta))
 		return AE_OK;
 
 	if (acpi_bus_get_device(handle, &device))
 		return AE_CTRL_DEPTH;
 
+	STRUCT_TO_INT(device->status) = sta;
+	/* Skip devices that are not present. */
+	if (!acpi_device_is_present(device))
+		goto err;
+
 	if (device->handler)
 		return AE_OK;
 
+	if (!device->flags.initialized) {
+		acpi_bus_update_power(device, NULL);
+		device->flags.initialized = true;
+	}
 	ret = acpi_scan_attach_handler(device);
 	if (ret < 0)
-		return AE_CTRL_DEPTH;
+		goto err;
 
 	device->flags.match_driver = true;
 	if (ret > 0)
-		return AE_OK;
+		goto ok;
 
 	ret = device_attach(&device->dev);
-	return ret >= 0 ? AE_OK : AE_CTRL_DEPTH;
+	if (ret < 0)
+		goto err;
+
+ ok:
+	device->flags.visited = true;
+	return AE_OK;
+
+ err:
+	device->flags.visited = false;
+	return AE_CTRL_DEPTH;
 }
 
 /**
@@ -2007,21 +2011,17 @@ static acpi_status acpi_bus_device_detac
 		} else {
 			device_release_driver(&device->dev);
 		}
+		/*
+		 * Most likely, the device is going away, so put it into D3cold
+		 * before that.
+		 */
+		acpi_device_set_power(device, ACPI_STATE_D3_COLD);
+		device->flags.initialized = false;
+		device->flags.visited = false;
 	}
 	return AE_OK;
 }
 
-static acpi_status acpi_bus_remove(acpi_handle handle, u32 lvl_not_used,
-				   void *not_used, void **ret_not_used)
-{
-	struct acpi_device *device = NULL;
-
-	if (!acpi_bus_get_device(handle, &device))
-		acpi_device_unregister(device);
-
-	return AE_OK;
-}
-
 /**
  * acpi_bus_trim - Remove ACPI device node and all of its descendants
  * @start: Root of the ACPI device nodes subtree to remove.
@@ -2037,13 +2037,6 @@ void acpi_bus_trim(struct acpi_device *s
 	acpi_walk_namespace(ACPI_TYPE_ANY, start->handle, ACPI_UINT32_MAX, NULL,
 			    acpi_bus_device_detach, NULL, NULL);
 	acpi_bus_device_detach(start->handle, 0, NULL, NULL);
-	/*
-	 * Execute acpi_bus_remove() as a post-order callback to remove device
-	 * nodes in the given namespace scope.
-	 */
-	acpi_walk_namespace(ACPI_TYPE_ANY, start->handle, ACPI_UINT32_MAX, NULL,
-			    acpi_bus_remove, NULL, NULL);
-	acpi_bus_remove(start->handle, 0, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(acpi_bus_trim);
 
@@ -2119,7 +2112,9 @@ int __init acpi_scan_init(void)
 
 	result = acpi_bus_scan_fixed();
 	if (result) {
-		acpi_device_unregister(acpi_root);
+		acpi_detach_data(acpi_root->handle, acpi_scan_drop_device);
+		acpi_device_del(acpi_root);
+		put_device(&acpi_root->dev);
 		goto out;
 	}
 
Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -256,6 +256,8 @@ int acpi_bus_init_power(struct acpi_devi
 		return -EINVAL;
 
 	device->power.state = ACPI_STATE_UNKNOWN;
+	if (!acpi_device_is_present(device))
+		return 0;
 
 	result = acpi_device_get_power(device, &state);
 	if (result)
@@ -302,15 +304,18 @@ int acpi_device_fix_up_power(struct acpi
 	return ret;
 }
 
-int acpi_bus_update_power(acpi_handle handle, int *state_p)
+int acpi_device_update_power(struct acpi_device *device, int *state_p)
 {
-	struct acpi_device *device;
 	int state;
 	int result;
 
-	result = acpi_bus_get_device(handle, &device);
-	if (result)
+	if (device->power.state == ACPI_STATE_UNKNOWN) {
+		result = acpi_bus_init_power(device);
+		if (!result && state_p)
+			*state_p = device->power.state;
+
 		return result;
+	}
 
 	result = acpi_device_get_power(device, &state);
 	if (result)
@@ -338,6 +343,15 @@ int acpi_bus_update_power(acpi_handle ha
 
 	return 0;
 }
+
+int acpi_bus_update_power(acpi_handle handle, int *state_p)
+{
+	struct acpi_device *device;
+	int result;
+
+	result = acpi_bus_get_device(handle, &device);
+	return result ? result : acpi_device_update_power(device, state_p);
+}
 EXPORT_SYMBOL_GPL(acpi_bus_update_power);
 
 bool acpi_bus_power_manageable(acpi_handle handle)
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -90,6 +90,7 @@ void acpi_free_pnp_ids(struct acpi_devic
 int acpi_bind_one(struct device *dev, acpi_handle handle);
 int acpi_unbind_one(struct device *dev);
 void acpi_bus_device_eject(void *data, u32 ost_src);
+bool acpi_device_is_present(struct acpi_device *adev);
 
 /* --------------------------------------------------------------------------
                                   Power Resource
@@ -107,6 +108,8 @@ int acpi_power_get_inferred_state(struct
 int acpi_power_on_resources(struct acpi_device *device, int state);
 int acpi_power_transition(struct acpi_device *device, int state);
 
+int acpi_device_update_power(struct acpi_device *device, int *state_p);
+
 int acpi_wakeup_device_init(void);
 void acpi_early_processor_set_pdc(void);
 
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -489,7 +489,7 @@ static void acpiphp_bus_add(acpi_handle
 
 	acpi_bus_scan(handle);
 	acpi_bus_get_device(handle, &adev);
-	if (adev)
+	if (acpi_device_enumerated(adev))
 		acpi_device_set_power(adev, ACPI_STATE_D0);
 }
 
Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -323,14 +323,11 @@ static int dock_present(struct dock_stat
  */
 static void dock_create_acpi_device(acpi_handle handle)
 {
-	struct acpi_device *device;
+	struct acpi_device *device = NULL;
 	int ret;
 
-	if (acpi_bus_get_device(handle, &device)) {
-		/*
-		 * no device created for this object,
-		 * so we should create one.
-		 */
+	acpi_bus_get_device(handle, &device);
+	if (!acpi_device_enumerated(device)) {
 		ret = acpi_bus_scan(handle);
 		if (ret)
 			pr_debug("error adding bus, %x\n", -ret);
Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -631,9 +631,10 @@ void __init acpi_pci_root_init(void)
 
 static void handle_root_bridge_insertion(acpi_handle handle)
 {
-	struct acpi_device *device;
+	struct acpi_device *device = NULL;
 
-	if (!acpi_bus_get_device(handle, &device)) {
+	acpi_bus_get_device(handle, &device);
+	if (acpi_device_enumerated(device)) {
 		dev_printk(KERN_DEBUG, &device->dev,
 			   "acpi device already exists; ignoring notify\n");
 		return;
Index: linux-pm/drivers/xen/xen-acpi-cpuhotplug.c
===================================================================
--- linux-pm.orig/drivers/xen/xen-acpi-cpuhotplug.c
+++ linux-pm/drivers/xen/xen-acpi-cpuhotplug.c
@@ -269,7 +269,8 @@ static void acpi_processor_hotplug_notif
 		if (!is_processor_present(handle))
 			break;
 
-		if (!acpi_bus_get_device(handle, &device))
+		acpi_bus_get_device(handle, &device);
+		if (acpi_device_enumerated(device))
 			break;
 
 		result = acpi_bus_scan(handle);
@@ -277,8 +278,9 @@ static void acpi_processor_hotplug_notif
 			pr_err(PREFIX "Unable to add the device\n");
 			break;
 		}
-		result = acpi_bus_get_device(handle, &device);
-		if (result) {
+		device = NULL;
+		acpi_bus_get_device(handle, &device);
+		if (!acpi_device_enumerated(device)) {
 			pr_err(PREFIX "Missing device object\n");
 			break;
 		}
Index: linux-pm/drivers/xen/xen-acpi-memhotplug.c
===================================================================
--- linux-pm.orig/drivers/xen/xen-acpi-memhotplug.c
+++ linux-pm/drivers/xen/xen-acpi-memhotplug.c
@@ -169,7 +169,7 @@ static int acpi_memory_get_device(acpi_h
 	acpi_scan_lock_acquire();
 
 	acpi_bus_get_device(handle, &device);
-	if (device)
+	if (acpi_device_enumerated(device))
 		goto end;
 
 	/*
@@ -182,8 +182,9 @@ static int acpi_memory_get_device(acpi_h
 		result = -EINVAL;
 		goto out;
 	}
-	result = acpi_bus_get_device(handle, &device);
-	if (result) {
+	device = NULL;
+	acpi_bus_get_device(handle, &device);
+	if (!acpi_device_enumerated(device)) {
 		pr_warn(PREFIX "Missing device object\n");
 		result = -EINVAL;
 		goto out;
Index: linux-pm/Documentation/acpi/namespace.txt
===================================================================
--- linux-pm.orig/Documentation/acpi/namespace.txt
+++ linux-pm/Documentation/acpi/namespace.txt
@@ -235,10 +235,6 @@ Wysocki <rafael.j.wysocki@intel.com>.
       named object's type in the second column).  In that case the object's
       directory in sysfs will contain the 'path' attribute whose value is
       the full path to the node from the namespace root.
-      struct acpi_device objects are created for the ACPI namespace nodes
-      whose _STA control methods return PRESENT or FUNCTIONING.  The power
-      resource nodes or nodes without _STA are assumed to be both PRESENT
-      and FUNCTIONING.
    F:
       The struct acpi_device object is created for a fixed hardware
       feature (as indicated by the fixed feature flag's name in the second
@@ -340,7 +336,7 @@ Wysocki <rafael.j.wysocki@intel.com>.
      | +-------------+-------+----------------+
      |   |
      |   | +- - - - - - - +- - - - - - +- - - - - - - -+
-     |   +-| * PNP0C0D:00 | \_SB_.LID0 | acpi:PNP0C0D: |
+     |   +-| PNP0C0D:00 | \_SB_.LID0 | acpi:PNP0C0D: |
      |   | +- - - - - - - +- - - - - - +- - - - - - - -+
      |   |
      |   | +------------+------------+-----------------------+
@@ -390,6 +386,4 @@ Wysocki <rafael.j.wysocki@intel.com>.
             attribute (as described earlier in this document).
    NOTE: N/A indicates the device object does not have the 'path' or the
          'modalias' attribute.
-   NOTE: The PNP0C0D device listed above is highlighted (marked by "*")
-         to indicate it will be created only when its _STA methods return
-         PRESENT or FUNCTIONING.
+

