Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaIPLxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:53:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:34254 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbaIPLw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:52:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="600313910"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC PATCH v2 02/16] Driver core: Unified device properties interface for platform firmware
Date: Tue, 16 Sep 2014 14:52:33 +0300
Message-Id: <1410868367-11056-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

Add a uniform interface by which device drivers can request device
properties from the platform firmware by providing a property name
and the corresponding data type.  The purpose of it is to help to
write portable code that won't depend on any particular platform
firmware interface.

Three general helper functions, device_get_property(),
device_read_property() and device_read_property_array() are provided.
The first one allows the raw value of a given device property to be
accessed by the driver.  The remaining two allow the value of a numeric
or string property and multiple numeric or string values of one array
property to be acquired, respectively.  Static inline wrappers are also
provided for the various property data types that can be passed to
device_read_property() or device_read_property_array() for extra type
checking.

In addition to that new generic routines are provided for retrieving
properties from device description objects in the platform firmware
in case there are no struct device objects for them (either those
objects have not been created yet or they do not exist at all).
Again, three functions are provided, dev_node_get_property(),
dev_node_read_property(), dev_node_read_property_array(), in analogy
with device_get_property(), device_read_property() and
device_read_property_array() described above, respectively, along
with static inline wrappers for all of the propery data types that
can be used.  For all of them, the first argument is a pointer to
struct fw_dev_node (new type) that in turn contains exactly one
valid pointer to a device description object (depending on what
platform firmware interface is in use).

Finally, device_for_each_child_node() is added for iterating over
the children of the device description object associated with the
given device.

The interface covers both ACPI and Device Trees.

This change set includes material from Mika Westerberg and Aaron Lu.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/property.c  | 186 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/base/Makefile    |   2 +-
 drivers/base/property.c  | 196 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/of/base.c        | 188 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h     |  42 ++++++++++
 include/linux/of.h       |  37 +++++++++
 include/linux/property.h | 193 ++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 843 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/property.c
 create mode 100644 include/linux/property.h

diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index c4a3e800e82c..e50964012da8 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -362,3 +362,189 @@ int acpi_dev_get_property_reference(struct acpi_device *adev, const char *name,
 	return -EPROTO;
 }
 EXPORT_SYMBOL_GPL(acpi_dev_get_property_reference);
+
+int acpi_dev_prop_get(struct acpi_device *adev, const char *propname,
+		      void **valptr)
+{
+	return acpi_dev_get_property(adev, propname, ACPI_TYPE_ANY,
+				     (const union acpi_object **)valptr);
+}
+
+int acpi_dev_prop_read(struct acpi_device *adev, const char *propname,
+		       enum dev_prop_type proptype, void *val)
+{
+	const union acpi_object *obj;
+	int ret = -EINVAL;
+
+	if (!val)
+		return -EINVAL;
+
+	if (proptype >= DEV_PROP_U8 && proptype <= DEV_PROP_U64) {
+		ret = acpi_dev_get_property(adev, propname, ACPI_TYPE_INTEGER, &obj);
+		if (ret)
+			return ret;
+
+		switch (proptype) {
+		case DEV_PROP_U8:
+			if (obj->integer.value > U8_MAX)
+				return -EOVERFLOW;
+			*(u8 *)val = obj->integer.value;
+			break;
+		case DEV_PROP_U16:
+			if (obj->integer.value > U16_MAX)
+				return -EOVERFLOW;
+			*(u16 *)val = obj->integer.value;
+			break;
+		case DEV_PROP_U32:
+			if (obj->integer.value > U32_MAX)
+				return -EOVERFLOW;
+			*(u32 *)val = obj->integer.value;
+			break;
+		default:
+			*(u64 *)val = obj->integer.value;
+			break;
+		}
+	} else if (proptype == DEV_PROP_STRING) {
+		ret = acpi_dev_get_property(adev, propname, ACPI_TYPE_STRING, &obj);
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
+		if (items[i].integer.value > U8_MAX)
+			return -EOVERFLOW;
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
+		if (items[i].integer.value > U16_MAX)
+			return -EOVERFLOW;
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
+		if (items[i].integer.value > U32_MAX)
+			return -EOVERFLOW;
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
+int acpi_dev_prop_read_array(struct acpi_device *adev, const char *propname,
+			     enum dev_prop_type proptype, void *val,
+			     size_t nval)
+{
+	const union acpi_object *obj;
+	const union acpi_object *items;
+	int ret;
+
+	ret = acpi_dev_get_property_array(adev, propname, ACPI_TYPE_ANY, &obj);
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
+int acpi_for_each_child_node(struct acpi_device *adev,
+			      int (*fn)(struct fw_dev_node *fdn, void *data),
+			      void *data)
+{
+	struct acpi_device *child;
+	int ret = 0;
+
+	list_for_each_entry(child, &adev->children, node) {
+		struct fw_dev_node fdn = { .acpi_node = child, };
+
+		ret = fn(&fdn, data);
+		if (ret)
+			break;
+	}
+	return ret;
+}
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 4aab26ec0292..0d801cfb7390 100644
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
index 000000000000..8348176e5498
--- /dev/null
+++ b/drivers/base/property.c
@@ -0,0 +1,196 @@
+/*
+ * property.c - Unified device property interface.
+ *
+ * Copyright (C) 2014, Intel Corporation
+ * Authors: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+ *          Mika Westerberg <mika.westerberg@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/property.h>
+#include <linux/export.h>
+#include <linux/acpi.h>
+#include <linux/of.h>
+
+/**
+ * dev_node_get_property - return a raw property from device description
+ * @fdn: Device node to get the property from
+ * @propname: Name of the property
+ * @valptr: The raw property value is stored here
+ *
+ * Function reads property @propname from the device firmware description and
+ * stores the raw value into @valptr if found.  Otherwise returns a negative
+ * errno as specified below.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not exist.
+ */
+int dev_node_get_property(struct fw_dev_node *fdn, const char *propname,
+			  void **valptr)
+{
+	if (IS_ENABLED(CONFIG_OF) && fdn->of_node)
+		return of_dev_prop_get(fdn->of_node, propname, valptr);
+	else if (IS_ENABLED(CONFIG_ACPI) && fdn->acpi_node)
+		return acpi_dev_prop_get(fdn->acpi_node, propname, valptr);
+
+	return -ENODATA;
+}
+EXPORT_SYMBOL_GPL(dev_node_get_property);
+
+/**
+ * device_get_property - return a raw property of a device
+ * @dev: Device get the property of
+ * @propname: Name of the property
+ * @valptr: The raw property value is stored here
+ */
+int device_get_property(struct device *dev, const char *propname, void **valptr)
+{
+	struct fw_dev_node fdn = {
+		.of_node = dev->of_node,
+		.acpi_node = ACPI_COMPANION(dev),
+	};
+	return dev_node_get_property(&fdn, propname, valptr);
+}
+EXPORT_SYMBOL_GPL(device_get_property);
+
+/**
+ * dev_node_read_property - return a typed property from device description
+ * @fdn: Device node to get the property from
+ * @propname: Name of the property
+ * @proptype: Type of the property
+ * @val: The value is stored here
+ *
+ * Function reads property @propname from the device firmware description and
+ * stores the value into @val if found. The value is checked to be of type
+ * @proptype.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not exist,
+ *	   %-EPROTO if the property type does not match @proptype,
+ *	   %-EOVERFLOW if the property value is out of bounds of @proptype.
+ */
+int dev_node_read_property(struct fw_dev_node *fdn, const char *propname,
+			   enum dev_prop_type proptype, void *val)
+{
+	if (IS_ENABLED(CONFIG_OF) && fdn->of_node)
+		return of_dev_prop_read(fdn->of_node, propname, proptype, val);
+	else if (IS_ENABLED(CONFIG_ACPI) && fdn->acpi_node)
+		return acpi_dev_prop_read(fdn->acpi_node, propname, proptype, val);
+
+	return -ENODATA;
+}
+EXPORT_SYMBOL_GPL(dev_node_read_property);
+
+/**
+ * device_read_property - return a typed property of a device
+ * @dev: Device to get the property of
+ * @propname: Name of the property
+ * @proptype: Type of the property
+ * @val: The value is stored here
+ */
+int device_read_property(struct device *dev, const char *propname,
+			 enum dev_prop_type proptype, void *val)
+{
+	struct fw_dev_node fdn = {
+		.of_node = dev->of_node,
+		.acpi_node = ACPI_COMPANION(dev),
+	};
+	return dev_node_read_property(&fdn, propname, proptype, val);
+}
+EXPORT_SYMBOL_GPL(device_read_property);
+
+/**
+ * dev_node_read_property_array - return an array property from a device
+ * @fdn: Device node to get the property from
+ * @propname: Name of the property
+ * @proptype: Type of the property
+ * @val: The values are stored here
+ * @nval: Size of the @val array
+ *
+ * Function reads an array of properties with @propname from the device
+ * firmware description and stores them to @val if found. All the values
+ * in the array must be of type @proptype.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not exist,
+ *	   %-EPROTO if the property type does not match @proptype,
+ *	   %-EOVERFLOW if the property value is out of bounds of @proptype.
+ */
+int dev_node_read_property_array(struct fw_dev_node *fdn, const char *propname,
+				 enum dev_prop_type proptype, void *val,
+				 size_t nval)
+{
+	if (IS_ENABLED(CONFIG_OF) && fdn->of_node)
+		return of_dev_prop_read_array(fdn->of_node, propname, proptype,
+					      val, nval);
+	else if (IS_ENABLED(CONFIG_ACPI) && fdn->acpi_node)
+		return acpi_dev_prop_read_array(fdn->acpi_node, propname,
+						proptype, val, nval);
+
+	return -ENODATA;
+}
+EXPORT_SYMBOL_GPL(dev_node_read_property_array);
+
+/**
+ * device_read_property_array - return an array property of a device
+ * @dev: Device to get the property of
+ * @propname: Name of the property
+ * @proptype: Type of the property
+ * @val: The values are stored here
+ * @nval: Size of the @val array
+ */
+int device_read_property_array(struct device *dev, const char *propname,
+			       enum dev_prop_type proptype, void *val,
+			       size_t nval)
+{
+	struct fw_dev_node fdn = {
+		.of_node = dev->of_node,
+		.acpi_node = ACPI_COMPANION(dev),
+	};
+	return dev_node_read_property_array(&fdn, propname, proptype, val, nval);
+}
+EXPORT_SYMBOL_GPL(device_read_property_array);
+
+/**
+ * device_for_each_child_node - execute function for each child node of device
+ * @dev: Device to run the function for
+ * @fn: Function to run
+ * @data: Additional data to pass to the function
+ */
+int device_for_each_child_node(struct device *dev,
+			       int (*fn)(struct fw_dev_node *fdn, void *data),
+			       void *data)
+{
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		return of_for_each_child_node(dev->of_node, fn, data);
+	else if (ACPI_COMPANION(dev))
+		return acpi_for_each_child_node(ACPI_COMPANION(dev), fn, data);
+
+	return -ENXIO;
+}
+EXPORT_SYMBOL_GPL(device_for_each_child_node);
+
+static int dev_node_count(struct fw_dev_node *fdn, void *data)
+{
+	*((int *)data) += 1;
+	return 0;
+}
+
+/**
+ * device_get_child_node_count - return number of child nodes for this device
+ * @dev: Device to get the child node count from
+ */
+int device_get_child_node_count(struct device *dev)
+{
+	int count = 0;
+
+	device_for_each_child_node(dev, dev_node_count, &count);
+	return count;
+}
+EXPORT_SYMBOL_GPL(device_get_child_node_count);
diff --git a/drivers/of/base.c b/drivers/of/base.c
index d8574adf0d62..84d436aeac51 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1241,6 +1241,39 @@ int of_property_read_u64(const struct device_node *np, const char *propname,
 EXPORT_SYMBOL_GPL(of_property_read_u64);
 
 /**
+ * of_property_read_u64_array - Find and read an array of 64 bit integers
+ * from a property.
+ *
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ * @out_values:	pointer to return value, modified only if return value is 0.
+ * @sz:		number of array elements to read
+ *
+ * Search for a property in a device node and read 64-bit value(s) from
+ * it. Returns 0 on success, -EINVAL if the property does not exist,
+ * -ENODATA if property does not have a value, and -EOVERFLOW if the
+ * property data isn't large enough.
+ *
+ * The out_values is modified only if a valid u64 value can be decoded.
+ */
+int of_property_read_u64_array(const struct device_node *np,
+			       const char *propname, u64 *out_values,
+			       size_t sz)
+{
+	const __be32 *val = of_find_property_value_of_size(np, propname,
+						(sz * sizeof(*out_values)));
+
+	if (IS_ERR(val))
+		return PTR_ERR(val);
+
+	while (sz--) {
+		*out_values++ = of_read_number(val, 2);
+		val += 2;
+	};
+	return 0;
+}
+
+/**
  * of_property_read_string - Find and read a string from a property
  * @np:		device node from which the property value is to be read.
  * @propname:	name of the property to be searched.
@@ -1388,6 +1421,49 @@ int of_property_count_strings(struct device_node *np, const char *propname)
 }
 EXPORT_SYMBOL_GPL(of_property_count_strings);
 
+/**
+ * of_property_read_string_array - Find and read an array of strings
+ * from a multiple strings property.
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ * @out_string:	pointer to null terminated return string, modified only if
+ *		return value is 0.
+ * @sz:		number of array elements to read
+ *
+ * Search for a property in a device tree node and retrieve a list of
+ * terminated string value (pointer to data, not a copy) in that property.
+ * Returns 0 on success, -EINVAL if the property does not exist, -ENODATA if
+ * property does not have a value, and -EOVERFLOW if the string is not
+ * null-terminated within the length of the property data.
+ *
+ * The out_string pointer is modified only if a valid string can be decoded.
+ */
+int of_property_read_string_array(struct device_node *np, const char *propname,
+				  char **output, size_t sz)
+{
+	struct property *prop = of_find_property(np, propname, NULL);
+	int i = 0;
+	size_t l = 0, total = 0;
+	char *p;
+
+	if (!prop)
+		return -EINVAL;
+
+	if (!prop->value)
+		return -ENODATA;
+
+	if (strnlen(prop->value, prop->length) >= prop->length)
+		return -EOVERFLOW;
+
+	p = prop->value;
+
+	for (i = 0; total < prop->length; total += l, p += l) {
+		output[i++] = p;
+		l = strlen(p) + 1;
+	}
+	return 0;
+}
+
 void of_print_phandle_args(const char *msg, const struct of_phandle_args *args)
 {
 	int i;
@@ -2171,3 +2247,115 @@ struct device_node *of_graph_get_remote_port(const struct device_node *node)
 	return of_get_next_parent(np);
 }
 EXPORT_SYMBOL(of_graph_get_remote_port);
+
+int of_dev_prop_get(struct device_node *dn, const char *propname, void **valptr)
+{
+	struct property *pp = of_find_property(dn, propname, NULL);
+
+	if (!pp)
+		return -ENODATA;
+
+	if (valptr)
+		*valptr = pp->value;
+	return 0;
+}
+
+int of_dev_prop_read(struct device_node *dn, const char *propname,
+		     enum dev_prop_type proptype, void *val)
+{
+	void *value;
+	int ret = of_dev_prop_get(dn, propname, &value);
+
+	if (ret)
+		return ret;
+
+	if (proptype >= DEV_PROP_U8 && proptype <= DEV_PROP_U64) {
+		switch (proptype) {
+		case DEV_PROP_U8: {
+			*(u8 *)val = *(u8 *)value;
+			break;
+		}
+		case DEV_PROP_U16:
+			*(u16 *)val = *(u16 *)value;
+			break;
+		case DEV_PROP_U32:
+			*(u32 *)val = *(u32 *)value;
+			break;
+		default:
+			*(u64 *)val = *(u64 *)value;
+			break;
+		}
+	} else if (proptype == DEV_PROP_STRING) {
+		*(char **)val = value;
+	}
+	return ret;
+
+}
+
+int of_dev_prop_read_array(struct device_node *dn, const char *propname,
+			   enum dev_prop_type proptype, void *val, size_t nval)
+{
+	int ret, elem_size;
+
+	if (!val) {
+		switch (proptype) {
+		case DEV_PROP_U8:
+			elem_size = sizeof(u8);
+			break;
+		case DEV_PROP_U16:
+			elem_size = sizeof(u16);
+			break;
+		case DEV_PROP_U32:
+			elem_size = sizeof(u32);
+			break;
+		case DEV_PROP_U64:
+			elem_size = sizeof(u64);
+			break;
+		case DEV_PROP_STRING:
+			return of_property_count_strings(dn, propname);
+		default:
+			return -EINVAL;
+		}
+		return of_property_count_elems_of_size(dn, propname, elem_size);
+	}
+
+	switch (proptype) {
+	case DEV_PROP_U8:
+		ret = of_property_read_u8_array(dn, propname, (u8 *)val, nval);
+		break;
+	case DEV_PROP_U16:
+		ret = of_property_read_u16_array(dn, propname, (u16 *)val, nval);
+		break;
+	case DEV_PROP_U32:
+		ret = of_property_read_u32_array(dn, propname, (u32 *)val, nval);
+		break;
+	case DEV_PROP_U64:
+		ret = of_property_read_u64_array(dn, propname, (u64 *)val, nval);
+		break;
+	case DEV_PROP_STRING:
+		ret = of_property_read_string_array(dn, propname,
+						    (char **)val, nval);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+int of_for_each_child_node(struct device_node *dn,
+			    int (*fn)(struct fw_dev_node *fdn, void *data),
+			    void *data)
+{
+	struct device_node *child;
+	int ret = 0;
+
+	for_each_child_of_node(dn, child) {
+		struct fw_dev_node fdn = { .of_node = child, };
+
+		ret = fn(&fdn, data);
+		if (ret)
+			break;
+	}
+	return ret;
+}
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 104321d994f5..288abbdf2fb4 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -28,6 +28,7 @@
 #include <linux/errno.h>
 #include <linux/ioport.h>	/* for struct resource */
 #include <linux/device.h>
+#include <linux/property.h>
 
 #ifndef _LINUX
 #define _LINUX
@@ -678,6 +679,17 @@ int acpi_dev_get_property_array(struct acpi_device *adev, const char *name,
 int acpi_dev_get_property_reference(struct acpi_device *adev, const char *name,
 				    const char *cells_name, size_t index,
 				    struct acpi_reference_args *args);
+
+int acpi_dev_prop_get(struct acpi_device *adev, const char *propname,
+		      void **valptr);
+int acpi_dev_prop_read(struct acpi_device *adev, const char *propname,
+		       enum dev_prop_type proptype, void *val);
+int acpi_dev_prop_read_array(struct acpi_device *adev, const char *propname,
+			     enum dev_prop_type proptype, void *val,
+			     size_t nval);
+int acpi_for_each_child_node(struct acpi_device *adev,
+			      int (*fn)(struct fw_dev_node *fdn, void *data),
+			      void *data);
 #else
 static inline int acpi_dev_get_property(struct acpi_device *adev,
 					const char *name, acpi_object_type type,
@@ -698,6 +710,36 @@ static inline int acpi_dev_get_property_reference(struct acpi_device *adev,
 {
 	return -ENXIO;
 }
+
+static inline int acpi_dev_prop_get(struct acpi_device *adev,
+				    const char *propname,
+				    void **valptr)
+{
+	return -ENXIO;
+}
+
+static inline int acpi_dev_prop_read(struct acpi_device *adev,
+				     const char *propname,
+				     enum dev_prop_type proptype, void *val)
+{
+	return -ENXIO;
+}
+
+static inline int acpi_dev_prop_read_array(struct acpi_device *adev,
+					   const char *propname,
+					   enum dev_prop_type proptype,
+					   void *val, size_t nval)
+{
+	return -ENXIO;
+}
+
+static inline int acpi_for_each_child_node(struct acpi_device *adev,
+				int (*fn)(struct fw_dev_node *fdn, void *data),
+				void *data)
+{
+	return -ENXIO;
+}
+
 #endif
 
 #endif	/*_LINUX_ACPI_H*/
diff --git a/include/linux/of.h b/include/linux/of.h
index 6c4363b8ddc3..8121cc920bb4 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/topology.h>
 #include <linux/notifier.h>
+#include <linux/property.h>
 
 #include <asm/byteorder.h>
 #include <asm/errno.h>
@@ -355,6 +356,15 @@ const char *of_prop_next_string(struct property *prop, const char *cur);
 
 bool of_console_check(struct device_node *dn, char *name, int index);
 
+int of_dev_prop_get(struct device_node *dn, const char *propname, void **valptr);
+int of_dev_prop_read(struct device_node *dn, const char *propname,
+		     enum dev_prop_type proptype, void *val);
+int of_dev_prop_read_array(struct device_node *dn, const char *propname,
+			   enum dev_prop_type proptype, void *val, size_t nval);
+int of_for_each_child_node(struct device_node *dn,
+			    int (*fn)(struct fw_dev_node *fdn, void *data),
+			    void *data);
+
 #else /* CONFIG_OF */
 
 static inline const char* of_node_full_name(const struct device_node *np)
@@ -582,6 +592,33 @@ static inline const char *of_prop_next_string(struct property *prop,
 	return NULL;
 }
 
+static inline int of_dev_prop_get(struct device_node *dn, const char *propname,
+				 void **valptr)
+{
+	return -ENXIO;
+}
+
+static inline int of_dev_prop_read(struct device_node *dn, const char *propname,
+				   enum dev_prop_type proptype, void *val)
+{
+	return -ENXIO;
+}
+
+static inline int of_dev_prop_read_array(struct device_node *dn,
+					 const char *propname,
+					 enum dev_prop_type proptype,
+					 void *val, size_t nval)
+{
+	return -ENXIO;
+}
+
+static inline int of_for_each_child_node(struct device_node *dn,
+				int (*fn)(struct fw_dev_node *fdn, void *data),
+				void *data)
+{
+	return -ENXIO;
+}
+
 #define of_match_ptr(_ptr)	NULL
 #define of_match_node(_matches, _node)	NULL
 #endif /* CONFIG_OF */
diff --git a/include/linux/property.h b/include/linux/property.h
new file mode 100644
index 000000000000..6a9f76007ca9
--- /dev/null
+++ b/include/linux/property.h
@@ -0,0 +1,193 @@
+/*
+ * property.h - Unified device property interface.
+ *
+ * Copyright (C) 2014, Intel Corporation
+ * Authors: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+ *          Mika Westerberg <mika.westerberg@linux.intel.com>
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
+struct fw_dev_node {
+	struct device_node *of_node;
+	struct acpi_device *acpi_node;
+};
+
+int dev_node_get_property(struct fw_dev_node *fdn, const char *propname,
+			  void **valptr);
+int dev_node_read_property(struct fw_dev_node *fdn, const char *propname,
+			   enum dev_prop_type proptype, void *val);
+int dev_node_read_property_array(struct fw_dev_node *fdn, const char *propname,
+				 enum dev_prop_type proptype, void *val,
+				 size_t nval);
+int device_get_property(struct device *dev, const char *propname,
+			void **valptr);
+int device_read_property(struct device *dev, const char *propname,
+			 enum dev_prop_type proptype, void *val);
+int device_read_property_array(struct device *dev, const char *propname,
+			       enum dev_prop_type proptype, void *val,
+			       size_t nval);
+int device_for_each_child_node(struct device *dev,
+			       int (*fn)(struct fw_dev_node *fdn, void *data),
+			       void *data);
+int device_get_child_node_count(struct device *dev);
+
+static inline int dev_node_property_read_u8(struct fw_dev_node *fdn,
+					    const char *propname, u8 *out_value)
+{
+	return dev_node_read_property(fdn, propname, DEV_PROP_U8, out_value);
+}
+
+static inline int dev_node_property_read_u16(struct fw_dev_node *fdn,
+					     const char *propname,
+					     u16 *out_value)
+{
+	return dev_node_read_property(fdn, propname, DEV_PROP_U16, out_value);
+}
+
+static inline int dev_node_property_read_u32(struct fw_dev_node *fdn,
+					     const char *propname,
+					     u32 *out_value)
+{
+	return dev_node_read_property(fdn, propname, DEV_PROP_U32, out_value);
+}
+
+static inline int dev_node_property_read_u64(struct fw_dev_node *fdn,
+					     const char *propname,
+					     u64 *out_value)
+{
+	return dev_node_read_property(fdn, propname, DEV_PROP_U64, out_value);
+}
+
+static inline int dev_node_property_read_u8_array(struct fw_dev_node *fdn,
+						  const char *propname,
+						  u8 *val, size_t nval)
+{
+	return dev_node_read_property_array(fdn, propname, DEV_PROP_U8, val, nval);
+}
+
+static inline int dev_node_property_read_u16_array(struct fw_dev_node *fdn,
+						   const char *propname,
+						   u16 *val, size_t nval)
+{
+	return dev_node_read_property_array(fdn, propname, DEV_PROP_U16, val, nval);
+}
+
+static inline int dev_node_property_read_u32_array(struct fw_dev_node *fdn,
+						   const char *propname,
+						   u32 *val, size_t nval)
+{
+	return dev_node_read_property_array(fdn, propname, DEV_PROP_U32, val, nval);
+}
+
+static inline int dev_node_property_read_u64_array(struct fw_dev_node *fdn,
+						   const char *propname,
+						   u64 *val, size_t nval)
+{
+	return dev_node_read_property_array(fdn, propname, DEV_PROP_U64, val, nval);
+}
+
+static inline int dev_node_property_read_string(struct fw_dev_node *fdn,
+						const char *propname,
+						const char **out_string)
+{
+	return dev_node_read_property(fdn, propname, DEV_PROP_STRING, out_string);
+}
+
+static inline int dev_node_property_read_string_array(struct fw_dev_node *fdn,
+						      const char *propname,
+						      const char **out_strings,
+						      size_t nstrings)
+{
+	return dev_node_read_property_array(fdn, propname, DEV_PROP_STRING,
+					    out_strings, nstrings);
+}
+
+static inline int device_property_read_u8(struct device *dev,
+					  const char *propname, u8 *out_value)
+{
+	return device_read_property(dev, propname, DEV_PROP_U8, out_value);
+}
+
+static inline int device_property_read_u16(struct device *dev,
+					  const char *propname, u16 *out_value)
+{
+	return device_read_property(dev, propname, DEV_PROP_U16, out_value);
+}
+
+static inline int device_property_read_u32(struct device *dev,
+					  const char *propname, u32 *out_value)
+{
+	return device_read_property(dev, propname, DEV_PROP_U32, out_value);
+}
+
+static inline int device_property_read_u64(struct device *dev,
+					  const char *propname, u64 *out_value)
+{
+	return device_read_property(dev, propname, DEV_PROP_U64, out_value);
+}
+
+static inline int device_property_read_u8_array(struct device *dev,
+						const char *propname,
+						u8 *val, size_t nval)
+{
+	return device_read_property_array(dev, propname, DEV_PROP_U8, val,
+					  nval);
+}
+
+static inline int device_property_read_u16_array(struct device *dev,
+						 const char *propname,
+						 u16 *val, size_t nval)
+{
+	return device_read_property_array(dev, propname, DEV_PROP_U16, val,
+					  nval);
+}
+
+static inline int device_property_read_u32_array(struct device *dev,
+						 const char *propname,
+						 u32 *val, size_t nval)
+{
+	return device_read_property_array(dev, propname, DEV_PROP_U32, val,
+					  nval);
+}
+
+static inline int device_property_read_u64_array(struct device *dev,
+						 const char *propname,
+						 u64 *val, size_t nval)
+{
+	return device_read_property_array(dev, propname, DEV_PROP_U64, val,
+					  nval);
+}
+
+static inline int device_property_read_string(struct device *dev,
+					      const char *propname,
+					      const char **out_string)
+{
+	return device_read_property(dev, propname, DEV_PROP_STRING, out_string);
+}
+
+static inline int device_property_read_string_array(struct device *dev,
+						    const char *propname,
+						    const char **out_strings,
+						    size_t nstrings)
+{
+	return device_read_property_array(dev, propname, DEV_PROP_STRING,
+					  out_strings, nstrings);
+}
+#endif /* _LINUX_PROPERTY_H_ */
-- 
2.1.0

