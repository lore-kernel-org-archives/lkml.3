Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab3BQPXB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:23:01 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39034 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218Ab3BQPVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:21:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 5/7] ACPI / hotplug: Introduce user space interface for hotplug profiles
Date: Sun, 17 Feb 2013 16:24:47 +0100
Message-ID: <5060623.RI4NTzcn19@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3260206.bhaAobGhpZ@vostro.rjw.lan>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@inel.com>

Introduce user space interface for manipulating hotplug profiles
associated with ACPI scan handlers.

The interface consists of sysfs directories under
/sys/firmware/acpi/hotplug/, one for each hotplug profile, containing
attributes allowing user space to manipulate the enabled, uevents,
and autoeject fields of the corresponding profile.  In particular,
switching the enabled attribute from 'unset' to 'set' will cause
the common hotplug notify handler to be installed for all ACPI
namespace objects representing devices matching the scan handler
associated with the given hotplug profile (and analogously for the
converse switch).

Drivers willing to use the new user space interface should add their
ACPI scan handlers with the help of new funtion
acpi_scan_add_handler_with_hotplug().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@inel.com>
---
 Documentation/ABI/testing/sysfs-firmware-acpi |   42 +++++++++
 drivers/acpi/internal.h                       |    9 +
 drivers/acpi/scan.c                           |   73 +++++++++++++++
 drivers/acpi/sysfs.c                          |  120 ++++++++++++++++++++++++++
 include/acpi/acpi_bus.h                       |    7 +
 5 files changed, 251 insertions(+)

Index: test/drivers/acpi/sysfs.c
===================================================================
--- test.orig/drivers/acpi/sysfs.c
+++ test/drivers/acpi/sysfs.c
@@ -7,6 +7,8 @@
 #include <linux/moduleparam.h>
 #include <acpi/acpi_drivers.h>
 
+#include "internal.h"
+
 #define _COMPONENT		ACPI_SYSTEM_COMPONENT
 ACPI_MODULE_NAME("sysfs");
 
@@ -249,6 +251,7 @@ module_param_call(acpica_version, NULL,
 static LIST_HEAD(acpi_table_attr_list);
 static struct kobject *tables_kobj;
 static struct kobject *dynamic_tables_kobj;
+static struct kobject *hotplug_kobj;
 
 struct acpi_table_attr {
 	struct bin_attribute attr;
@@ -716,6 +719,121 @@ acpi_show_profile(struct device *dev, st
 static const struct device_attribute pm_profile_attr =
 	__ATTR(pm_profile, S_IRUGO, acpi_show_profile, NULL);
 
+static ssize_t hotplug_enabled_show(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	struct acpi_hotplug_profile *hotplug = to_acpi_hotplug_profile(kobj);
+
+	return sprintf(buf, "%d\n", hotplug->enabled);
+}
+
+static ssize_t hotplug_enabled_store(struct kobject *kobj,
+				     struct kobj_attribute *attr,
+				     const char *buf, size_t size)
+{
+	struct acpi_hotplug_profile *hotplug = to_acpi_hotplug_profile(kobj);
+	unsigned int val;
+
+	if (kstrtouint(buf, 10, &val) || val > 1)
+		return -EINVAL;
+
+	acpi_scan_hotplug_enabled(hotplug, val);
+	return size;
+}
+
+static struct kobj_attribute hotplug_enabled_attr =
+	__ATTR(enabled, S_IRUGO | S_IWUSR, hotplug_enabled_show,
+		hotplug_enabled_store);
+
+static ssize_t hotplug_uevents_show(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	struct acpi_hotplug_profile *hotplug = to_acpi_hotplug_profile(kobj);
+
+	return sprintf(buf, "%d\n", hotplug->uevents);
+}
+
+static ssize_t hotplug_uevents_store(struct kobject *kobj,
+				     struct kobj_attribute *attr,
+				     const char *buf, size_t size)
+{
+	struct acpi_hotplug_profile *hotplug = to_acpi_hotplug_profile(kobj);
+	unsigned int val;
+
+	if (kstrtouint(buf, 10, &val) || val > 1)
+		return -EINVAL;
+
+	acpi_scan_hotplug_uevents(hotplug, val);
+	return size;
+}
+
+static struct kobj_attribute hotplug_uevents_attr =
+	__ATTR(uevents, S_IRUGO | S_IWUSR, hotplug_uevents_show,
+		hotplug_uevents_store);
+
+static ssize_t hotplug_autoeject_show(struct kobject *kobj,
+				      struct kobj_attribute *attr, char *buf)
+{
+	struct acpi_hotplug_profile *hotplug = to_acpi_hotplug_profile(kobj);
+
+	return sprintf(buf, "%d\n", hotplug->autoeject);
+}
+
+static ssize_t hotplug_autoeject_store(struct kobject *kobj,
+				       struct kobj_attribute *attr,
+				       const char *buf, size_t size)
+{
+	struct acpi_hotplug_profile *hotplug = to_acpi_hotplug_profile(kobj);
+	unsigned int val;
+
+	if (kstrtouint(buf, 10, &val) || val > 1)
+		return -EINVAL;
+
+	acpi_scan_hotplug_autoeject(hotplug, val);
+	return size;
+}
+
+static struct kobj_attribute hotplug_autoeject_attr =
+	__ATTR(autoeject, S_IRUGO | S_IWUSR, hotplug_autoeject_show,
+		hotplug_autoeject_store);
+
+static struct attribute *hotplug_profile_attrs[] = {
+	&hotplug_enabled_attr.attr,
+	&hotplug_uevents_attr.attr,
+	&hotplug_autoeject_attr.attr,
+	NULL
+};
+
+struct kobj_type acpi_hotplug_profile_ktype = {
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_attrs = hotplug_profile_attrs,
+};
+
+void acpi_sysfs_add_hotplug_profile(struct acpi_hotplug_profile *hotplug,
+				    const char *name)
+{
+	int error;
+
+	if (!hotplug_kobj)
+		goto err_out;
+
+	kobject_init(&hotplug->kobj, &acpi_hotplug_profile_ktype);
+	error = kobject_set_name(&hotplug->kobj, "%s", name);
+	if (error)
+		goto err_out;
+
+	hotplug->kobj.parent = hotplug_kobj;
+	error = kobject_add(&hotplug->kobj, hotplug_kobj, NULL);
+	if (error)
+		goto err_out;
+
+	kobject_uevent(&hotplug->kobj, KOBJ_ADD);
+	return;
+
+ err_out:
+	pr_err(PREFIX "Unable to add hotplug profile '%s'\n", name);
+}
+
 int __init acpi_sysfs_init(void)
 {
 	int result;
@@ -723,6 +841,8 @@ int __init acpi_sysfs_init(void)
 	result = acpi_tables_sysfs_init();
 	if (result)
 		return result;
+
+	hotplug_kobj = kobject_create_and_add("hotplug", acpi_kobj);
 	result = sysfs_create_file(acpi_kobj, &pm_profile_attr.attr);
 	return result;
 }
Index: test/include/acpi/acpi_bus.h
===================================================================
--- test.orig/include/acpi/acpi_bus.h
+++ test/include/acpi/acpi_bus.h
@@ -89,11 +89,18 @@ struct acpi_device;
  */
 
 struct acpi_hotplug_profile {
+	struct kobject kobj;
 	bool enabled:1;
 	bool uevents:1;
 	bool autoeject:1;
 };
 
+static inline struct acpi_hotplug_profile *to_acpi_hotplug_profile(
+						struct kobject *kobj)
+{
+	return container_of(kobj, struct acpi_hotplug_profile, kobj);
+}
+
 struct acpi_scan_handler {
 	const struct acpi_device_id *ids;
 	struct list_head list_node;
Index: test/drivers/acpi/internal.h
===================================================================
--- test.orig/drivers/acpi/internal.h
+++ test/drivers/acpi/internal.h
@@ -36,6 +36,15 @@ void acpi_container_init(void);
 static inline void acpi_container_init(void) {}
 #endif
 
+void acpi_sysfs_add_hotplug_profile(struct acpi_hotplug_profile *hotplug,
+				    const char *name);
+int acpi_scan_add_handler_with_hotplug(struct acpi_scan_handler *handler,
+				       const char *hotplug_profile_name);
+void acpi_scan_hotplug_enabled(struct acpi_hotplug_profile *hotplug, bool val);
+void acpi_scan_hotplug_uevents(struct acpi_hotplug_profile *hotplug, bool val);
+void acpi_scan_hotplug_autoeject(struct acpi_hotplug_profile *hotplug,
+				 bool val);
+
 #ifdef CONFIG_DEBUG_FS
 extern struct dentry *acpi_debugfs_dir;
 int acpi_debugfs_init(void);
Index: test/drivers/acpi/scan.c
===================================================================
--- test.orig/drivers/acpi/scan.c
+++ test/drivers/acpi/scan.c
@@ -63,6 +63,19 @@ int acpi_scan_add_handler(struct acpi_sc
 	return 0;
 }
 
+int acpi_scan_add_handler_with_hotplug(struct acpi_scan_handler *handler,
+				       const char *hotplug_profile_name)
+{
+	int error;
+
+	error = acpi_scan_add_handler(handler);
+	if (error)
+		return error;
+
+	acpi_sysfs_add_hotplug_profile(&handler->hotplug, hotplug_profile_name);
+	return 0;
+}
+
 /*
  * Creates hid/cid(s) string needed for modalias and uevent
  * e.g. on a device with hid:IBM0001 and cid:ACPI0001 you get:
@@ -1675,6 +1688,66 @@ static bool acpi_scan_handler_matching(s
 	return false;
 }
 
+static acpi_status acpi_scan_hotplug_modify(acpi_handle handle,
+					    u32 lvl_not_used, void *data,
+					    void **ret_not_used)
+{
+	struct acpi_scan_handler *handler = data;
+	struct acpi_device_info *info;
+	bool match = false;
+
+	if (ACPI_FAILURE(acpi_get_object_info(handle, &info)))
+		return AE_OK;
+
+	if (info->valid & ACPI_VALID_HID) {
+		char *idstr = info->hardware_id.string;
+		match = acpi_scan_handler_matching(handler, idstr, NULL);
+	}
+	kfree(info);
+	if (!match)
+		return AE_OK;
+
+	if (handler->hotplug.enabled)
+		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					   acpi_hotplug_notify_cb);
+	else
+		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					    acpi_hotplug_notify_cb, NULL);
+
+	return AE_OK;
+}
+
+void acpi_scan_hotplug_enabled(struct acpi_hotplug_profile *hotplug, bool val)
+{
+	struct acpi_scan_handler *handler;
+
+	if (!!hotplug->enabled == !!val)
+		return;
+
+	mutex_lock(&acpi_scan_lock);
+
+	hotplug->enabled = val;
+	handler = container_of(hotplug, struct acpi_scan_handler, hotplug);
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT, ACPI_UINT32_MAX,
+			    acpi_scan_hotplug_modify, NULL, handler, NULL);
+
+	mutex_unlock(&acpi_scan_lock);
+}
+
+void acpi_scan_hotplug_uevents(struct acpi_hotplug_profile *hotplug, bool val)
+{
+	mutex_lock(&acpi_scan_lock);
+	hotplug->uevents = val;
+	mutex_unlock(&acpi_scan_lock);
+}
+
+void acpi_scan_hotplug_autoeject(struct acpi_hotplug_profile *hotplug, bool val)
+{
+	mutex_lock(&acpi_scan_lock);
+	hotplug->autoeject = val;
+	mutex_unlock(&acpi_scan_lock);
+}
+
 static struct acpi_scan_handler *acpi_scan_match_handler(char *idstr,
 					const struct acpi_device_id **matchid)
 {
Index: test/Documentation/ABI/testing/sysfs-firmware-acpi
===================================================================
--- test.orig/Documentation/ABI/testing/sysfs-firmware-acpi
+++ test/Documentation/ABI/testing/sysfs-firmware-acpi
@@ -18,6 +18,48 @@ Description:
 		yoffset: The number of pixels between the top of the screen
 			 and the top edge of the image.
 
+What:		/sys/firmware/acpi/hotplug/
+Date:		February 2013
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		There are separate hotplug profiles for different classes of
+		devices supported by ACPI, such as containers, memory modules,
+		processors, PCI root bridges etc.  A hotplug profile for a given
+		class of devices is a collection of settings defining the way
+		that class of devices will be handled by the ACPI core hotplug
+		code.  Those profiles are represented in sysfs as subdirectories
+		of /sys/firmware/acpi/hotplug/.
+
+		The following settings are available for each hotplug profile:
+
+		enabled: If set, the ACPI core will handle notifications of
+			hotplug events associated with the given class of
+			devices and will allow those devices to be ejected with
+			the help of the _EJ0 control method.  Unsetting it
+			effectively disables hotplug for the correspoinding
+			class of devices.
+
+		uevents: If set, the ACPI core will emit a KOBJ_ONLINE uevent
+			after a successful namespace scan for a device of the
+			given class resulting from a "bus check" or "device
+			check" firmware notification.  It also will emit a
+			KOBJ_OFFLINE uevent upon receiving an eject request from
+			the platform firmware for a device node of the given
+			class.  If unset, no uevents related to hotplug will be
+			emitted for devices of the given class.
+
+		autoeject: If set, the ACPI core will automatically carry out
+			a namespace trim operation and will attempt to execute
+			_EJ0 after receiving an eject request from the platform
+			firmware for a device node of the given class.  If
+			unset, user space will have to trigger ejects directly
+			using the 'eject' attributes of the device nodes to be
+			ejected.
+
+		The values of all of the above attributes are integer numbers:
+		1 (set) or 0 (unset).  Attempts to write any other values to
+		them will cause -EINVAL to be returned.
+
 What:		/sys/firmware/acpi/interrupts/
 Date:		February 2008
 Contact:	Len Brown <lenb@kernel.org>

