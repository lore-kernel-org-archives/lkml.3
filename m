Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaJGAAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:00:33 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59332 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752560AbaJFX7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 19:59:53 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 02/13] Driver core: Unified device properties interface for platform firmware
Date: Tue, 07 Oct 2014 02:12:59 +0200
Message-ID: <1552453.TziEyyQsBz@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2660541.BycO7TFnA2@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Add a uniform interface by which device drivers can request device
properties from the platform firmware by providing a property name
and the corresponding data type.  The purpose of it is to help to
write portable code that won't depend on any particular platform
firmware interface.

Three general helper functions, device_get_property(),
device_read_property() and device_read_property_array() are provided.
The first one allows the raw value of a given device property to be
accessed.  The remaining two allow the value of a numeric or string
property and multiple numeric or string values of one array
property to be acquired, respectively.  Static inline wrappers are also
provided for the various property data types that can be passed to
device_read_property() or device_read_property_array() for extra type
checking.

The interface covers both ACPI and Device Trees.

This change set includes material from Mika Westerberg and Aaron Lu.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/property.c  |  169 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/base/Makefile    |    2 
 drivers/base/property.c  |   97 ++++++++++++++++++++++++++
 drivers/of/base.c        |  171 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h     |   31 ++++++++
 include/linux/of.h       |   27 +++++++
 include/linux/property.h |  108 +++++++++++++++++++++++++++++
 7 files changed, 604 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/property.c
 create mode 100644 include/linux/property.h

Index: linux-pm/drivers/acpi/property.c
===================================================================
--- linux-pm.orig/drivers/acpi/property.c
+++ linux-pm/drivers/acpi/property.c
@@ -362,3 +362,172 @@ int acpi_dev_get_property_reference(stru
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
Index: linux-pm/drivers/base/Makefile
===================================================================
--- linux-pm.orig/drivers/base/Makefile
+++ linux-pm/drivers/base/Makefile
@@ -4,7 +4,7 @@ obj-y			:= component.o core.o bus.o dd.o
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o \
-			   topology.o container.o
+			   topology.o container.o property.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
Index: linux-pm/drivers/base/property.c
===================================================================
--- /dev/null
+++ linux-pm/drivers/base/property.c
@@ -0,0 +1,97 @@
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
+ * device_get_property - return a raw property of a device
+ * @dev: Device get the property of
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
+int device_get_property(struct device *dev, const char *propname, void **valptr)
+{
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		return of_dev_prop_get(dev->of_node, propname, valptr);
+
+	return acpi_dev_prop_get(ACPI_COMPANION(dev), propname, valptr);
+}
+EXPORT_SYMBOL_GPL(device_get_property);
+
+/**
+ * device_read_property - read a typed property of a device
+ * @dev: Device to get the property of
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
+int device_read_property(struct device *dev, const char *propname,
+			 enum dev_prop_type proptype, void *val)
+{
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		return of_dev_prop_read(dev->of_node, propname, proptype, val);
+
+	return acpi_dev_prop_read(ACPI_COMPANION(dev), propname, proptype, val);
+}
+EXPORT_SYMBOL_GPL(device_read_property);
+
+/**
+ * device_read_property_array - read an array property of a device
+ * @dev: Device to get the property of
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
+int device_read_property_array(struct device *dev, const char *propname,
+			       enum dev_prop_type proptype, void *val,
+			       size_t nval)
+{
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		return of_dev_prop_read_array(dev->of_node, propname, proptype,
+					      val, nval);
+
+	return acpi_dev_prop_read_array(ACPI_COMPANION(dev), propname, proptype,
+					val, nval);
+}
+EXPORT_SYMBOL_GPL(device_read_property_array);
Index: linux-pm/drivers/of/base.c
===================================================================
--- linux-pm.orig/drivers/of/base.c
+++ linux-pm/drivers/of/base.c
@@ -1247,6 +1247,39 @@ int of_property_read_u64(const struct de
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
+	}
+	return 0;
+}
+
+/**
  * of_property_read_string - Find and read a string from a property
  * @np:		device node from which the property value is to be read.
  * @propname:	name of the property to be searched.
@@ -1394,6 +1427,49 @@ int of_property_count_strings(struct dev
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
@@ -2183,3 +2259,98 @@ struct device_node *of_graph_get_remote_
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
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -28,6 +28,7 @@
 #include <linux/errno.h>
 #include <linux/ioport.h>	/* for struct resource */
 #include <linux/device.h>
+#include <linux/property.h>
 
 #ifndef _LINUX
 #define _LINUX
@@ -676,6 +677,14 @@ int acpi_dev_get_property_array(struct a
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
 #else
 static inline int acpi_dev_get_property(struct acpi_device *adev,
 					const char *name, acpi_object_type type,
@@ -696,6 +705,28 @@ static inline int acpi_dev_get_property_
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
 #endif
 
 #endif	/*_LINUX_ACPI_H*/
Index: linux-pm/include/linux/of.h
===================================================================
--- linux-pm.orig/include/linux/of.h
+++ linux-pm/include/linux/of.h
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/topology.h>
 #include <linux/notifier.h>
+#include <linux/property.h>
 
 #include <asm/byteorder.h>
 #include <asm/errno.h>
@@ -355,6 +356,12 @@ const char *of_prop_next_string(struct p
 
 bool of_console_check(struct device_node *dn, char *name, int index);
 
+int of_dev_prop_get(struct device_node *dn, const char *propname, void **valptr);
+int of_dev_prop_read(struct device_node *dn, const char *propname,
+		     enum dev_prop_type proptype, void *val);
+int of_dev_prop_read_array(struct device_node *dn, const char *propname,
+			   enum dev_prop_type proptype, void *val, size_t nval);
+
 #else /* CONFIG_OF */
 
 static inline const char* of_node_full_name(const struct device_node *np)
@@ -582,6 +589,26 @@ static inline const char *of_prop_next_s
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
 #define of_match_ptr(_ptr)	NULL
 #define of_match_node(_matches, _node)	NULL
 #endif /* CONFIG_OF */
Index: linux-pm/include/linux/property.h
===================================================================
--- /dev/null
+++ linux-pm/include/linux/property.h
@@ -0,0 +1,108 @@
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
+#include <linux/types.h>
+
+struct device;
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
+int device_get_property(struct device *dev, const char *propname,
+			void **valptr);
+int device_read_property(struct device *dev, const char *propname,
+			 enum dev_prop_type proptype, void *val);
+int device_read_property_array(struct device *dev, const char *propname,
+			       enum dev_prop_type proptype, void *val,
+			       size_t nval);
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

