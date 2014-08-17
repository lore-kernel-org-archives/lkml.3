Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaHQGE5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 02:04:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:19568 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbaHQGEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 02:04:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,878,1400050800"; 
   d="scan'208";a="469519017"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Max Eliaser <max.eliaser@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/9] Driver core: Unified device properties interface for platform firmware
Date: Sun, 17 Aug 2014 09:04:13 +0300
Message-Id: <1408255459-17625-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0.rc1
In-Reply-To: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

Add a uniform interface by which device drivers can request device
properties from the platform firmware by providing a property name
and the corresponding data type.

Three general helper functions, device_property_get(),
device_property_read() and device_property_read_array() are provided.
The first one allows the raw value of a given device property to be
accessed by the driver.  The remaining two allow the value of a numeric
or string property and multiple numeric or string values of one array
property to be acquired, respectively.

The interface is supposed to cover both ACPI and Device Trees,
although the ACPI part is only implemented at this time.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Reviewed-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/glue.c      |   4 +-
 drivers/acpi/property.c  | 179 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/acpi/scan.c      |  12 +++-
 drivers/base/Makefile    |   2 +-
 drivers/base/property.c  |  48 +++++++++++++
 include/acpi/acpi_bus.h  |   1 +
 include/linux/device.h   |   3 +
 include/linux/property.h |  50 +++++++++++++
 8 files changed, 293 insertions(+), 6 deletions(-)
 create mode 100644 drivers/base/property.c
 create mode 100644 include/linux/property.h

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index f774c65ecb8b..1df5223bb98d 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -9,7 +9,7 @@
 #include <linux/export.h>
 #include <linux/init.h>
 #include <linux/list.h>
-#include <linux/device.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include <linux/rwsem.h>
 #include <linux/acpi.h>
@@ -220,6 +220,7 @@ int acpi_bind_one(struct device *dev, struct acpi_device *acpi_dev)
 	list_add(&physical_node->node, physnode_list);
 	acpi_dev->physical_node_count++;
 
+	dev->property_ops = &acpi_property_ops;
 	if (!ACPI_COMPANION(dev))
 		ACPI_COMPANION_SET(dev, acpi_dev);
 
@@ -271,6 +272,7 @@ int acpi_unbind_one(struct device *dev)
 			acpi_physnode_link_name(physnode_name, entry->node_id);
 			sysfs_remove_link(&acpi_dev->dev.kobj, physnode_name);
 			sysfs_remove_link(&dev->kobj, "firmware_node");
+			dev->property_ops = NULL;
 			ACPI_COMPANION_SET(dev, NULL);
 			/* Drop references taken by acpi_bind_one(). */
 			put_device(dev);
diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index 093e834c35db..bdba5f85c919 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -13,8 +13,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/property.h>
 #include <linux/acpi.h>
-#include <linux/device.h>
 #include <linux/export.h>
 
 #include "internal.h"
@@ -363,3 +363,180 @@ int acpi_dev_get_property_reference(struct acpi_device *adev, const char *name,
 	return -EPROTO;
 }
 EXPORT_SYMBOL_GPL(acpi_dev_get_property_reference);
+
+static int acpi_dev_prop_get(struct device *dev, const char *propname,
+			     void **valptr)
+{
+	return acpi_dev_get_property(ACPI_COMPANION(dev), propname,
+				     ACPI_TYPE_ANY,
+				     (const union acpi_object **)valptr);
+}
+
+static int acpi_dev_prop_read(struct device *dev, const char *propname,
+			      enum dev_prop_type proptype, void *val)
+{
+	const union acpi_object *obj;
+	int ret = -EINVAL;
+
+	if (!val)
+		return -EINVAL;
+
+	if (proptype >= DEV_PROP_U8 && proptype <= DEV_PROP_U64) {
+		ret = acpi_dev_get_property(ACPI_COMPANION(dev), propname,
+					    ACPI_TYPE_INTEGER, &obj);
+		if (ret)
+			return ret;
+
+		switch (proptype) {
+		case DEV_PROP_U8:
+			*(u8 *)val = obj->integer.value;
+			break;
+		case DEV_PROP_U16:
+			*(u16 *)val = obj->integer.value;
+			break;
+		case DEV_PROP_U32:
+			*(u32 *)val = obj->integer.value;
+			break;
+		default:
+			*(u64 *)val = obj->integer.value;
+			break;
+		}
+	} else if (proptype == DEV_PROP_STRING) {
+		ret = acpi_dev_get_property(ACPI_COMPANION(dev), propname,
+					    ACPI_TYPE_STRING, &obj);
+		if (ret)
+			return ret;
+
+		*(char **)val = obj->string.pointer;
+	}
+	return ret;
+}
+
+static int acpi_copy_property_array_u8(const union acpi_object *items, u8 *val,
+				       size_t nval)
+{
+	int i;
+
+	for (i = 0; i < nval; i++) {
+		if (items[i].type != ACPI_TYPE_INTEGER)
+			return -EPROTO;
+
+		val[i] = items[i].integer.value;
+	}
+	return 0;
+}
+
+static int acpi_copy_property_array_u16(const union acpi_object *items,
+					u16 *val, size_t nval)
+{
+	int i;
+
+	for (i = 0; i < nval; i++) {
+		if (items[i].type != ACPI_TYPE_INTEGER)
+			return -EPROTO;
+
+		val[i] = items[i].integer.value;
+	}
+	return 0;
+}
+
+static int acpi_copy_property_array_u32(const union acpi_object *items,
+					u32 *val, size_t nval)
+{
+	int i;
+
+	for (i = 0; i < nval; i++) {
+		if (items[i].type != ACPI_TYPE_INTEGER)
+			return -EPROTO;
+
+		val[i] = items[i].integer.value;
+	}
+	return 0;
+}
+
+static int acpi_copy_property_array_u64(const union acpi_object *items,
+					u64 *val, size_t nval)
+{
+	int i;
+
+	for (i = 0; i < nval; i++) {
+		if (items[i].type != ACPI_TYPE_INTEGER)
+			return -EPROTO;
+
+		val[i] = items[i].integer.value;
+	}
+	return 0;
+}
+
+static int acpi_copy_property_array_string(const union acpi_object *items,
+					   char **val, size_t nval)
+{
+	int i;
+
+	for (i = 0; i < nval; i++) {
+		if (items[i].type != ACPI_TYPE_STRING)
+			return -EPROTO;
+
+		val[i] = items[i].string.pointer;
+	}
+	return 0;
+}
+
+static int acpi_dev_prop_read_array(struct device *dev, const char *propname,
+				    enum dev_prop_type proptype, void *val,
+				    size_t nval)
+{
+	const union acpi_object *obj;
+	const union acpi_object *items;
+	int ret;
+
+	ret = acpi_dev_get_property_array(ACPI_COMPANION(dev), propname,
+					  ACPI_TYPE_ANY, &obj);
+	if (ret)
+		return ret;
+
+	if (!val)
+		return obj->package.count;
+
+	if (nval > obj->package.count)
+		nval = obj->package.count;
+
+	items = obj->package.elements;
+	switch (proptype) {
+	case DEV_PROP_U8:
+		ret = acpi_copy_property_array_u8(items, (u8 *)val, nval);
+		break;
+	case DEV_PROP_U16:
+		ret = acpi_copy_property_array_u16(items, (u16 *)val, nval);
+		break;
+	case DEV_PROP_U32:
+		ret = acpi_copy_property_array_u32(items, (u32 *)val, nval);
+		break;
+	case DEV_PROP_U64:
+		ret = acpi_copy_property_array_u64(items, (u64 *)val, nval);
+		break;
+	case DEV_PROP_STRING:
+		ret = acpi_copy_property_array_string(items, (char **)val, nval);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int acpi_dev_get_child_count(struct device *dev)
+{
+	struct acpi_device *adev = ACPI_COMPANION(dev);
+
+	if (!adev)
+		return -EINVAL;
+	return adev->child_count;
+}
+
+struct dev_prop_ops acpi_property_ops = {
+	.get = acpi_dev_prop_get,
+	.read = acpi_dev_prop_read,
+	.read_array = acpi_dev_prop_read_array,
+	.child_count = acpi_dev_get_child_count,
+};
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index fc97e6123864..75b1b91e5ab0 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1035,8 +1035,10 @@ struct bus_type acpi_bus_type = {
 static void acpi_device_del(struct acpi_device *device)
 {
 	mutex_lock(&acpi_device_lock);
-	if (device->parent)
+	if (device->parent) {
 		list_del(&device->node);
+		device->parent->child_count--;
+	}
 
 	list_del(&device->wakeup_list);
 	mutex_unlock(&acpi_device_lock);
@@ -1222,8 +1224,10 @@ int acpi_device_add(struct acpi_device *device,
 	}
 	dev_set_name(&device->dev, "%s:%02x", acpi_device_bus_id->bus_id, acpi_device_bus_id->instance_no);
 
-	if (device->parent)
+	if (device->parent) {
 		list_add_tail(&device->node, &device->parent->children);
+		device->parent->child_count++;
+	}
 
 	if (device->wakeup.flags.valid)
 		list_add_tail(&device->wakeup_list, &acpi_wakeup_device_list);
@@ -1248,8 +1252,10 @@ int acpi_device_add(struct acpi_device *device,
 
  err:
 	mutex_lock(&acpi_device_lock);
-	if (device->parent)
+	if (device->parent) {
 		list_del(&device->node);
+		device->parent->child_count--;
+	}
 	list_del(&device->wakeup_list);
 	mutex_unlock(&acpi_device_lock);
 
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 04b314e0fa51..1acd294b6514 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -4,7 +4,7 @@ obj-y			:= component.o core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o \
-			   topology.o container.o
+			   topology.o container.o property.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
diff --git a/drivers/base/property.c b/drivers/base/property.c
new file mode 100644
index 000000000000..d770b6edc91a
--- /dev/null
+++ b/drivers/base/property.c
@@ -0,0 +1,48 @@
+/*
+ * property.c - Unified device property interface.
+ *
+ * Copyright (C) 2014, Intel Corporation
+ * All rights reserved.
+ *
+ * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/property.h>
+#include <linux/export.h>
+
+int device_property_get(struct device *dev, const char *propname, void **valptr)
+{
+	return dev->property_ops && dev->property_ops->get ?
+		dev->property_ops->get(dev, propname, valptr) : -ENODATA;
+}
+EXPORT_SYMBOL_GPL(device_property_get);
+
+int device_property_read(struct device *dev, const char *propname,
+			 enum dev_prop_type proptype, void *val)
+{
+	return dev->property_ops && dev->property_ops->read ?
+		dev->property_ops->read(dev, propname, proptype, val) :
+		-ENODATA;
+}
+EXPORT_SYMBOL_GPL(device_property_read);
+
+int device_property_read_array(struct device *dev, const char *propname,
+			       enum dev_prop_type proptype, void *val,
+			       size_t nval)
+{
+	return dev->property_ops && dev->property_ops->read_array ?
+		dev->property_ops->read_array(dev, propname, proptype, val, nval) :
+		-ENODATA;
+}
+EXPORT_SYMBOL_GPL(device_property_read_array);
+
+int device_property_child_count(struct device *dev)
+{
+	return dev->property_ops && dev->property_ops->child_count ?
+		dev->property_ops->child_count(dev) : -ENODATA;
+}
+EXPORT_SYMBOL_GPL(device_property_child_count);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 348bd260a6b4..312813f60a22 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -340,6 +340,7 @@ struct acpi_device_data {
 /* Device */
 struct acpi_device {
 	int device_type;
+	int child_count;
 	acpi_handle handle;		/* no handle for fixed hardware */
 	struct acpi_device *parent;
 	struct list_head children;
diff --git a/include/linux/device.h b/include/linux/device.h
index af424acd393d..ea4cf31f8b9e 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -38,6 +38,7 @@ struct class;
 struct subsys_private;
 struct bus_type;
 struct device_node;
+struct dev_prop_ops;
 struct iommu_ops;
 struct iommu_group;
 
@@ -701,6 +702,7 @@ struct acpi_dev_node {
  * @archdata:	For arch-specific additions.
  * @of_node:	Associated device tree node.
  * @acpi_node:	Associated ACPI device node.
+ * @property_ops: Firmware interface for device properties
  * @devt:	For creating the sysfs "dev".
  * @id:		device instance
  * @devres_lock: Spinlock to protect the resource of the device.
@@ -777,6 +779,7 @@ struct device {
 
 	struct device_node	*of_node; /* associated device tree node */
 	struct acpi_dev_node	acpi_node; /* associated ACPI device node */
+	struct dev_prop_ops	*property_ops;
 
 	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
 	u32			id;	/* device instance */
diff --git a/include/linux/property.h b/include/linux/property.h
new file mode 100644
index 000000000000..52ea7fe7fe09
--- /dev/null
+++ b/include/linux/property.h
@@ -0,0 +1,50 @@
+/*
+ * property.h - Unified device property interface.
+ *
+ * Copyright (C) 2014, Intel Corporation
+ * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_PROPERTY_H_
+#define _LINUX_PROPERTY_H_
+
+#include <linux/device.h>
+#include <linux/acpi.h>
+#include <linux/of.h>
+
+enum dev_prop_type {
+	DEV_PROP_U8,
+	DEV_PROP_U16,
+	DEV_PROP_U32,
+	DEV_PROP_U64,
+	DEV_PROP_STRING,
+	DEV_PROP_MAX,
+};
+
+struct dev_prop_ops {
+	int (*get)(struct device *dev, const char *propname, void **valptr);
+	int (*read)(struct device *dev, const char *propname,
+		    enum dev_prop_type proptype, void *val);
+	int (*read_array)(struct device *dev, const char *propname,
+			  enum dev_prop_type proptype, void *val, size_t nval);
+	int (*child_count)(struct device *dev);
+};
+
+#ifdef CONFIG_ACPI
+extern struct dev_prop_ops acpi_property_ops;
+#endif
+
+int device_property_get(struct device *dev, const char *propname,
+			void **valptr);
+int device_property_read(struct device *dev, const char *propname,
+			 enum dev_prop_type proptype, void *val);
+int device_property_read_array(struct device *dev, const char *propname,
+			       enum dev_prop_type proptype, void *val,
+			       size_t nval);
+int device_property_child_count(struct device *dev);
+
+#endif /* _LINUX_PROPERTY_H_ */
-- 
2.1.0.rc1

