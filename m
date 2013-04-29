Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab3D2MVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:21:36 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48958 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145Ab3D2MVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:21:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: [PATCH 3/3 RFC] ACPI / hotplug: Use device offline/online for graceful hot-removal
Date: Mon, 29 Apr 2013 14:29:23 +0200
Message-ID: <2740694.MNypEzdXxd@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Modify the generic ACPI hotplug code to be able to check if devices
scheduled for hot-removal may be gracefully removed from the system
using the device offline/online mechanism introduced previously.

Namely, make acpi_scan_hot_remove() which handles device hot-removal
call device_offline() for all physical companions of the ACPI device
nodes involved in the operation and check the results.  If any of
the device_offline() calls fails, the function will not progress to
the removal phase (which cannot be aborted), unless its (new) force
argument is set (in case of a failing offline it will put the devices
offlined by it back online).

In support of the 'forced' hot-removal, add a new sysfs attribute
'force_remove' that will reside in every ACPI hotplug profile
present under /sys/firmware/acpi/hotplug/.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/ABI/testing/sysfs-firmware-acpi |    9 +-
 drivers/acpi/internal.h                       |    2 
 drivers/acpi/scan.c                           |   97 ++++++++++++++++++++++++--
 drivers/acpi/sysfs.c                          |   27 +++++++
 include/acpi/acpi_bus.h                       |    3 
 5 files changed, 131 insertions(+), 7 deletions(-)

Index: linux-pm/drivers/acpi/sysfs.c
===================================================================
--- linux-pm.orig/drivers/acpi/sysfs.c
+++ linux-pm/drivers/acpi/sysfs.c
@@ -745,8 +745,35 @@ static struct kobj_attribute hotplug_ena
 	__ATTR(enabled, S_IRUGO | S_IWUSR, hotplug_enabled_show,
 		hotplug_enabled_store);
 
+static ssize_t hotplug_force_remove_show(struct kobject *kobj,
+					 struct kobj_attribute *attr, char *buf)
+{
+	struct acpi_hotplug_profile *hotplug = to_acpi_hotplug_profile(kobj);
+
+	return sprintf(buf, "%d\n", hotplug->force_remove);
+}
+
+static ssize_t hotplug_force_remove_store(struct kobject *kobj,
+					  struct kobj_attribute *attr,
+					  const char *buf, size_t size)
+{
+	struct acpi_hotplug_profile *hotplug = to_acpi_hotplug_profile(kobj);
+	unsigned int val;
+
+	if (kstrtouint(buf, 10, &val) || val > 1)
+		return -EINVAL;
+
+	acpi_scan_hotplug_force_remove(hotplug, val);
+	return size;
+}
+
+static struct kobj_attribute hotplug_force_remove_attr =
+	__ATTR(force_remove, S_IRUGO | S_IWUSR, hotplug_force_remove_show,
+		hotplug_force_remove_store);
+
 static struct attribute *hotplug_profile_attrs[] = {
 	&hotplug_enabled_attr.attr,
+	&hotplug_force_remove_attr.attr,
 	NULL
 };
 
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -52,6 +52,8 @@ void acpi_sysfs_add_hotplug_profile(stru
 int acpi_scan_add_handler_with_hotplug(struct acpi_scan_handler *handler,
 				       const char *hotplug_profile_name);
 void acpi_scan_hotplug_enabled(struct acpi_hotplug_profile *hotplug, bool val);
+void acpi_scan_hotplug_force_remove(struct acpi_hotplug_profile *hotplug,
+				    bool val);
 
 #ifdef CONFIG_DEBUG_FS
 extern struct dentry *acpi_debugfs_dir;
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -97,6 +97,7 @@ enum acpi_hotplug_mode {
 struct acpi_hotplug_profile {
 	struct kobject kobj;
 	bool enabled:1;
+	bool force_remove:1;
 	enum acpi_hotplug_mode mode;
 };
 
@@ -286,6 +287,7 @@ struct acpi_device_physical_node {
 	u8 node_id;
 	struct list_head node;
 	struct device *dev;
+	bool put_online:1;
 };
 
 /* set maximum of physical nodes to 32 for expansibility */
@@ -346,6 +348,7 @@ struct acpi_bus_event {
 struct acpi_eject_event {
 	struct acpi_device	*device;
 	u32		event;
+	bool		force;
 };
 
 struct acpi_hp_work {
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -120,7 +120,61 @@ acpi_device_modalias_show(struct device
 }
 static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
 
-static int acpi_scan_hot_remove(struct acpi_device *device)
+static acpi_status acpi_bus_offline_companions(acpi_handle handle, u32 lvl,
+					       void *data, void **ret_p)
+{
+	struct acpi_device *device = NULL;
+	struct acpi_device_physical_node *pn;
+	bool force = *((bool *)data);
+	acpi_status status = AE_OK;
+
+	if (acpi_bus_get_device(handle, &device))
+		return AE_OK;
+
+	mutex_lock(&device->physical_node_lock);
+
+	list_for_each_entry(pn, &device->physical_node_list, node) {
+		int ret;
+
+		ret = device_offline(pn->dev);
+		if (force)
+			continue;
+
+		if (ret < 0) {
+			status = AE_ERROR;
+			break;
+		}
+		pn->put_online = !ret;
+	}
+
+	mutex_unlock(&device->physical_node_lock);
+
+	return status;
+}
+
+static acpi_status acpi_bus_online_companions(acpi_handle handle, u32 lvl,
+					      void *data, void **ret_p)
+{
+	struct acpi_device *device = NULL;
+	struct acpi_device_physical_node *pn;
+
+	if (acpi_bus_get_device(handle, &device))
+		return AE_OK;
+
+	mutex_lock(&device->physical_node_lock);
+
+	list_for_each_entry(pn, &device->physical_node_list, node)
+		if (pn->put_online) {
+			device_online(pn->dev);
+			pn->put_online = false;
+		}
+
+	mutex_unlock(&device->physical_node_lock);
+
+	return AE_OK;
+}
+
+static int acpi_scan_hot_remove(struct acpi_device *device, bool force)
 {
 	acpi_handle handle = device->handle;
 	acpi_handle not_used;
@@ -136,10 +190,30 @@ static int acpi_scan_hot_remove(struct a
 		return -EINVAL;
 	}
 
+	lock_device_offline();
+
+	status = acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
+				     NULL, acpi_bus_offline_companions, &force,
+				     NULL);
+	if (ACPI_SUCCESS(status) || force)
+		status = acpi_bus_offline_companions(handle, 0, &force, NULL);
+
+	if (ACPI_FAILURE(status) && !force) {
+		acpi_bus_online_companions(handle, 0, NULL, NULL);
+		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
+				    acpi_bus_online_companions, NULL, NULL,
+				    NULL);
+		unlock_device_offline();
+		return -EBUSY;
+	}
+
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 		"Hot-removing device %s...\n", dev_name(&device->dev)));
 
 	acpi_bus_trim(device);
+
+	unlock_device_offline();
+
 	/* Device node has been unregistered. */
 	put_device(&device->dev);
 	device = NULL;
@@ -214,7 +288,8 @@ static void acpi_bus_device_eject(void *
 		int error;
 
 		get_device(&device->dev);
-		error = acpi_scan_hot_remove(device);
+		error = acpi_scan_hot_remove(device,
+					     handler->hotplug.force_remove);
 		if (error)
 			goto err_out;
 	}
@@ -353,7 +428,7 @@ void acpi_bus_hot_remove_device(void *co
 
 	mutex_lock(&acpi_scan_lock);
 
-	error = acpi_scan_hot_remove(device);
+	error = acpi_scan_hot_remove(device, ej_event->force);
 	if (error && handle)
 		acpi_evaluate_hotplug_ost(handle, ej_event->event,
 					  ACPI_OST_SC_NON_SPECIFIC_FAILURE,
@@ -422,7 +497,7 @@ acpi_eject_store(struct device *d, struc
 		/* Eject initiated by user space. */
 		ost_source = ACPI_OST_EC_OSPM_EJECT;
 	}
-	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
+	ej_event = kzalloc(sizeof(*ej_event), GFP_KERNEL);
 	if (!ej_event) {
 		ret = -ENOMEM;
 		goto err_out;
@@ -431,6 +506,9 @@ acpi_eject_store(struct device *d, struc
 				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 	ej_event->device = acpi_device;
 	ej_event->event = ost_source;
+	if (acpi_device->handler)
+		ej_event->force = acpi_device->handler->hotplug.force_remove;
+
 	get_device(&acpi_device->dev);
 	status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, ej_event);
 	if (ACPI_FAILURE(status)) {
@@ -1769,9 +1847,18 @@ void acpi_scan_hotplug_enabled(struct ac
 		return;
 
 	mutex_lock(&acpi_scan_lock);
-
 	hotplug->enabled = val;
+	mutex_unlock(&acpi_scan_lock);
+}
 
+void acpi_scan_hotplug_force_remove(struct acpi_hotplug_profile *hotplug,
+				    bool val)
+{
+	if (!!hotplug->force_remove == !!val)
+		return;
+
+	mutex_lock(&acpi_scan_lock);
+	hotplug->force_remove = val;
 	mutex_unlock(&acpi_scan_lock);
 }
 
Index: linux-pm/Documentation/ABI/testing/sysfs-firmware-acpi
===================================================================
--- linux-pm.orig/Documentation/ABI/testing/sysfs-firmware-acpi
+++ linux-pm/Documentation/ABI/testing/sysfs-firmware-acpi
@@ -40,8 +40,13 @@ Description:
 			effectively disables hotplug for the correspoinding
 			class of devices.
 
-		The value of the above attribute is an integer number: 1 (set)
-		or 0 (unset).  Attempts to write any other values to it will
+		force_remove: If set, the ACPI core will force hot-removal
+			for the given class of devices regardless of whether or
+			not they may be gracefully removed from the system
+			(according to the kernel).
+
+		The values of the above attributes are integer numbers: 1 (set)
+		or 0 (unset).  Attempts to write any other values to them will
 		cause -EINVAL to be returned.
 
 What:		/sys/firmware/acpi/interrupts/

