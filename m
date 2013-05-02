Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab3EBMYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:24:03 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55028 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab3EBMXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:23:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>
Subject: [PATCH 3/4] ACPI / hotplug: Use device offline/online for graceful hot-removal
Date: Thu, 02 May 2013 14:29:56 +0200
Message-ID: <4172338.SM4yyc8Lmg@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3166726.elbgrUIZ0L@vostro.rjw.lan>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan> <3166726.elbgrUIZ0L@vostro.rjw.lan>
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

Namely, make acpi_scan_hot_remove() handling device hot-removal call
device_offline() for all physical companions of the ACPI device nodes
involved in the operation and check the results.  If any of the
device_offline() calls fails, the function will not progress to the
removal phase (which cannot be aborted), unless its (new) force
argument is set (in case of a failing offline it will put the devices
offlined by it back online).

In support of 'forced' device hot-removal, add a new sysfs attribute
'force_remove' that will reside under /sys/firmware/acpi/hotplug/.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/ABI/testing/sysfs-firmware-acpi |   10 +++
 drivers/acpi/internal.h                       |    2 
 drivers/acpi/scan.c                           |   84 ++++++++++++++++++++++++++
 drivers/acpi/sysfs.c                          |   31 +++++++++
 include/acpi/acpi_bus.h                       |    1 
 5 files changed, 128 insertions(+)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -286,6 +286,7 @@ struct acpi_device_physical_node {
 	u8 node_id;
 	struct list_head node;
 	struct device *dev;
+	bool put_online:1;
 };
 
 /* set maximum of physical nodes to 32 for expansibility */
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -27,6 +27,12 @@ extern struct acpi_device *acpi_root;
 
 #define ACPI_IS_ROOT_DEVICE(device)    (!(device)->parent)
 
+/*
+ * If set, devices will be hot-removed even if they cannot be put offline
+ * gracefully (from the kernel's standpoint).
+ */
+bool acpi_force_hot_remove;
+
 static const char *dummy_hid = "device";
 
 static LIST_HEAD(acpi_device_list);
@@ -120,6 +126,59 @@ acpi_device_modalias_show(struct device
 }
 static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
 
+static acpi_status acpi_bus_offline_companions(acpi_handle handle, u32 lvl,
+					       void *data, void **ret_p)
+{
+	struct acpi_device *device = NULL;
+	struct acpi_device_physical_node *pn;
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
+		if (acpi_force_hot_remove)
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
 static int acpi_scan_hot_remove(struct acpi_device *device)
 {
 	acpi_handle handle = device->handle;
@@ -136,10 +195,33 @@ static int acpi_scan_hot_remove(struct a
 		return -EINVAL;
 	}
 
+	lock_device_hotplug();
+
+	status = acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
+				     NULL, acpi_bus_offline_companions, NULL,
+				     NULL);
+	if (ACPI_SUCCESS(status) || acpi_force_hot_remove)
+		status = acpi_bus_offline_companions(handle, 0, NULL, NULL);
+
+	if (ACPI_FAILURE(status) && !acpi_force_hot_remove) {
+		acpi_bus_online_companions(handle, 0, NULL, NULL);
+		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
+				    acpi_bus_online_companions, NULL, NULL,
+				    NULL);
+
+		unlock_device_hotplug();
+
+		put_device(&device->dev);
+		return -EBUSY;
+	}
+
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 		"Hot-removing device %s...\n", dev_name(&device->dev)));
 
 	acpi_bus_trim(device);
+
+	unlock_device_hotplug();
+
 	/* Device node has been unregistered. */
 	put_device(&device->dev);
 	device = NULL;
@@ -236,6 +318,7 @@ static void acpi_scan_bus_device_check(a
 	int error;
 
 	mutex_lock(&acpi_scan_lock);
+	lock_device_hotplug();
 
 	acpi_bus_get_device(handle, &device);
 	if (device) {
@@ -259,6 +342,7 @@ static void acpi_scan_bus_device_check(a
 		kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
 
  out:
+	unlock_device_hotplug();
 	acpi_evaluate_hotplug_ost(handle, ost_source, ost_code, NULL);
 	mutex_unlock(&acpi_scan_lock);
 }
Index: linux-pm/drivers/acpi/sysfs.c
===================================================================
--- linux-pm.orig/drivers/acpi/sysfs.c
+++ linux-pm/drivers/acpi/sysfs.c
@@ -780,6 +780,33 @@ void acpi_sysfs_add_hotplug_profile(stru
 	pr_err(PREFIX "Unable to add hotplug profile '%s'\n", name);
 }
 
+static ssize_t force_remove_show(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", !!acpi_force_hot_remove);
+}
+
+static ssize_t force_remove_store(struct kobject *kobj,
+				  struct kobj_attribute *attr,
+				  const char *buf, size_t size)
+{
+	bool val;
+	int ret;
+
+	ret = strtobool(buf, &val);
+	if (ret < 0)
+		return ret;
+
+	lock_device_hotplug();
+	acpi_force_hot_remove = val;
+	unlock_device_hotplug();
+	return size;
+}
+
+static const struct kobj_attribute force_remove_attr =
+	__ATTR(force_remove, S_IRUGO | S_IWUSR, force_remove_show,
+	       force_remove_store);
+
 int __init acpi_sysfs_init(void)
 {
 	int result;
@@ -789,6 +816,10 @@ int __init acpi_sysfs_init(void)
 		return result;
 
 	hotplug_kobj = kobject_create_and_add("hotplug", acpi_kobj);
+	result = sysfs_create_file(hotplug_kobj, &force_remove_attr.attr);
+	if (result)
+		return result;
+
 	result = sysfs_create_file(acpi_kobj, &pm_profile_attr.attr);
 	return result;
 }
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -47,6 +47,8 @@ void acpi_memory_hotplug_init(void);
 static inline void acpi_memory_hotplug_init(void) {}
 #endif
 
+extern bool acpi_force_hot_remove;
+
 void acpi_sysfs_add_hotplug_profile(struct acpi_hotplug_profile *hotplug,
 				    const char *name);
 int acpi_scan_add_handler_with_hotplug(struct acpi_scan_handler *handler,
Index: linux-pm/Documentation/ABI/testing/sysfs-firmware-acpi
===================================================================
--- linux-pm.orig/Documentation/ABI/testing/sysfs-firmware-acpi
+++ linux-pm/Documentation/ABI/testing/sysfs-firmware-acpi
@@ -44,6 +44,16 @@ Description:
 		or 0 (unset).  Attempts to write any other values to it will
 		cause -EINVAL to be returned.
 
+What:		/sys/firmware/acpi/hotplug/force_remove
+Date:		May 2013
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The number in this file (0 or 1) determines whether (1) or not
+		(0) the ACPI subsystem will allow devices to be hot-removed even
+		if they cannot be put offline gracefully (from the kernel's
+		viewpoint).  That number can be changed by writing a boolean
+		value to this file.
+
 What:		/sys/firmware/acpi/interrupts/
 Date:		February 2008
 Contact:	Len Brown <lenb@kernel.org>

