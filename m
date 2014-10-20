Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaJSXrO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 19:47:14 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60720 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751694AbaJSXrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 19:47:08 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [Update][PATCH v5 02/12] Driver core: Unified device properties interface for platform firmware
Date: Mon, 20 Oct 2014 02:07:31 +0200
Message-ID: <3644918.N9UqvZ1y01@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <52358812.fUDG3PX6s8@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <11223831.j9KAEfSQsY@vostro.rjw.lan> <52358812.fUDG3PX6s8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

Add a uniform interface by which device drivers can request device
properties from the platform firmware by providing a property name
and the corresponding data type.  The purpose of it is to help to
write portable code that won't depend on any particular platform
firmware interface.

The following general helper functions are added:

device_property_present()
device_property_read_u8()
device_property_read_u16()
device_property_read_u32()
device_property_read_u64()
device_property_read_string()
device_property_read_u8_array()
device_property_read_u16_array()
device_property_read_u32_array()
device_property_read_u64_array()
device_property_read_string_array()

The first one allows the caller to check if the given property is
present.  The next 5 of them allow single-valued properties of
various types to be retrieved in a uniform way.  The remaining 5 are
for reading properties with multiple values (arrays of either numbers
or strings).

The interface covers both ACPI and Device Trees.

This change set includes material from Mika Westerberg and Aaron Lu.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

This adds device_property_read_bool() as a wrapper around device_property_present()
and uses macros to generate the bodies of device_property_read_*(), except for
device_property_read_string_array() that doesn't match the overall scheme exactly.

I believe that the Greg's ACK still applies. :-)

Rafael

---
 drivers/acpi/property.c  |  169 ++++++++++++++++++++++++++++
 drivers/base/Makefile    |    2 
 drivers/base/property.c  |  276 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/of/base.c        |  106 +++++++++++++++---
 include/linux/acpi.h     |   32 +++++
 include/linux/of.h       |   22 +++
 include/linux/property.h |   53 +++++++++
 7 files changed, 643 insertions(+), 17 deletions(-)
 create mode 100644 drivers/base/property.c
 create mode 100644 include/linux/property.h

Index: linux-pm/include/linux/property.h
===================================================================
--- /dev/null
+++ linux-pm/include/linux/property.h
@@ -0,0 +1,53 @@
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
+bool device_property_present(struct device *dev, const char *propname);
+int device_property_read_u8(struct device *dev, const char *propname, u8 *val);
+int device_property_read_u16(struct device *dev, const char *propname, u16 *val);
+int device_property_read_u32(struct device *dev, const char *propname, u32 *val);
+int device_property_read_u64(struct device *dev, const char *propname, u64 *val);
+int device_property_read_string(struct device *dev, const char *propname,
+				const char **val);
+int device_property_read_u8_array(struct device *dev, const char *propname,
+				  u8 *val, size_t nval);
+int device_property_read_u16_array(struct device *dev, const char *propname,
+				   u16 *val, size_t nval);
+int device_property_read_u32_array(struct device *dev, const char *propname,
+				   u32 *val, size_t nval);
+int device_property_read_u64_array(struct device *dev, const char *propname,
+				   u64 *val, size_t nval);
+int device_property_read_string_array(struct device *dev, const char *propname,
+				      char **val, size_t nval);
+
+static inline bool device_property_read_bool(struct device *dev,
+					     const char *propname)
+{
+	return device_property_present(dev, propname);
+}
+
+#endif /* _LINUX_PROPERTY_H_ */
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
@@ -263,6 +264,10 @@ extern int of_property_read_u32_array(co
 				      size_t sz);
 extern int of_property_read_u64(const struct device_node *np,
 				const char *propname, u64 *out_value);
+extern int of_property_read_u64_array(const struct device_node *np,
+				      const char *propname,
+				      u64 *out_values,
+				      size_t sz);
 
 extern int of_property_read_string(struct device_node *np,
 				   const char *propname,
@@ -275,6 +280,9 @@ extern int of_property_match_string(stru
 				    const char *string);
 extern int of_property_count_strings(struct device_node *np,
 				     const char *propname);
+extern int of_property_read_string_array(struct device_node *np,
+					      const char *propname,
+					      char **out_strs, size_t sz);
 extern int of_device_is_compatible(const struct device_node *device,
 				   const char *);
 extern int of_device_is_available(const struct device_node *device);
@@ -479,6 +487,13 @@ static inline int of_property_read_u32_a
 	return -ENOSYS;
 }
 
+static inline int of_property_read_u64_array(const struct device_node *np,
+					     const char *propname,
+					     u64 *out_values, size_t sz)
+{
+	return -ENOSYS;
+}
+
 static inline int of_property_read_string(struct device_node *np,
 					  const char *propname,
 					  const char **out_string)
@@ -498,6 +513,13 @@ static inline int of_property_count_stri
 {
 	return -ENOSYS;
 }
+
+static inline int of_property_read_string_array(struct device_node *np,
+						 const char *propname,
+						 char **out_strs, size_t sz)
+{
+	return -ENOSYS;
+}
 
 static inline const void *of_get_property(const struct device_node *node,
 				const char *name,
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
@@ -696,6 +705,29 @@ static inline int acpi_dev_get_property_
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
 #endif
 
 #endif	/*_LINUX_ACPI_H*/
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
@@ -0,0 +1,276 @@
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
+ * device_property_present - check if a property of a device is present
+ * @dev: Device whose property is being checked
+ * @propname: Name of the property
+ *
+ * Check if property @propname is present in the device firmware description.
+ */
+bool device_property_present(struct device *dev, const char *propname)
+{
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		return of_property_read_bool(dev->of_node, propname);
+
+	return !acpi_dev_prop_get(ACPI_COMPANION(dev), propname, NULL);
+}
+EXPORT_SYMBOL_GPL(device_property_present);
+
+#define DEVICE_PROPERTY_READ(_dev_, _propname_, _type_, _proptype_, _val_) \
+	IS_ENABLED(CONFIG_OF) && _dev_->of_node ? \
+		of_property_read_##_type_(_dev_->of_node, _propname_, _val_) : \
+		acpi_dev_prop_read(ACPI_COMPANION(_dev_), _propname_, \
+				   _proptype_, _val_)
+
+/**
+ * device_property_read_u8 - return a u8 property of a device
+ * @dev: Device to get the property of
+ * @propname: Name of the property
+ * @val: The value is stored here
+ *
+ * Function reads property @propname from the device firmware description and
+ * stores the value into @val if found. The value is checked to be of type u8.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO or %-EILSEQ if the property type is not u8,
+ *	   %-EOVERFLOW if the property value is out of bounds of u8.
+ */
+int device_property_read_u8(struct device *dev, const char *propname, u8 *val)
+{
+	return DEVICE_PROPERTY_READ(dev, propname, u8, DEV_PROP_U8, val);
+}
+EXPORT_SYMBOL_GPL(device_property_read_u8);
+
+/**
+ * device_property_read_u16 - return a u16 property of a device
+ * @dev: Device to get the property of
+ * @propname: Name of the property
+ * @val: The value is stored here
+ *
+ * Function reads property @propname from the device firmware description and
+ * stores the value into @val if found. The value is checked to be of type u16.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO or %-EILSEQ if the property type is not u16,
+ *	   %-EOVERFLOW if the property value is out of bounds of u16.
+ */
+int device_property_read_u16(struct device *dev, const char *propname, u16 *val)
+{
+	return DEVICE_PROPERTY_READ(dev, propname, u16, DEV_PROP_U16, val);
+}
+EXPORT_SYMBOL_GPL(device_property_read_u16);
+
+/**
+ * device_property_read_u32 - return a u32 property of a device
+ * @dev: Device to get the property of
+ * @propname: Name of the property
+ * @val: The value is stored here
+ *
+ * Function reads property @propname from the device firmware description and
+ * stores the value into @val if found. The value is checked to be of type u32.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO or %-EILSEQ if the property type is not u32,
+ *	   %-EOVERFLOW if the property value is out of bounds of u32.
+ */
+int device_property_read_u32(struct device *dev, const char *propname, u32 *val)
+{
+	return DEVICE_PROPERTY_READ(dev, propname, u32, DEV_PROP_U32, val);
+}
+EXPORT_SYMBOL_GPL(device_property_read_u32);
+
+/**
+ * device_property_read_u64 - return a u64 property of a device
+ * @dev: Device to get the property of
+ * @propname: Name of the property
+ * @val: The value is stored here
+ *
+ * Function reads property @propname from the device firmware description and
+ * stores the value into @val if found. The value is checked to be of type u64.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO or %-EILSEQ if the property type is not u64,
+ *	   %-EOVERFLOW if the property value is out of bounds of u64.
+ */
+int device_property_read_u64(struct device *dev, const char *propname, u64 *val)
+{
+	return DEVICE_PROPERTY_READ(dev, propname, u64, DEV_PROP_U64, val);
+}
+EXPORT_SYMBOL_GPL(device_property_read_u64);
+
+/**
+ * device_property_read_string - return a string property of a device
+ * @dev: Device to get the property of
+ * @propname: Name of the property
+ * @val: The value is stored here
+ *
+ * Function reads property @propname from the device firmware description and
+ * stores the value into @val if found. The value is checked to be a string.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO or %-EILSEQ if the property type is not a string.
+ */
+int device_property_read_string(struct device *dev, const char *propname,
+				const char **val)
+{
+	return DEVICE_PROPERTY_READ(dev, propname, string, DEV_PROP_STRING, val);
+}
+EXPORT_SYMBOL_GPL(device_property_read_string);
+
+#define OF_DEV_PROP_READ_ARRAY(node, propname, type, val, nval) \
+	(val) ? of_property_read_##type##_array((node), (propname), (val), (nval)) \
+	      : of_property_count_elems_of_size((node), (propname), sizeof(type))
+
+#define DEVICE_PROPERTY_READ_ARRAY(_dev_, _propname_, _type_, _proptype_, _val_, _nval_) \
+	IS_ENABLED(CONFIG_OF) && _dev_->of_node ? \
+		(OF_DEV_PROP_READ_ARRAY(_dev_->of_node, _propname_, _type_, \
+					_val_, _nval_)) : \
+		acpi_dev_prop_read_array(ACPI_COMPANION(_dev_), _propname_, \
+					 _proptype_, _val_, _nval_)
+
+/**
+ * device_property_read_u8_array - return a u8 array property of a device
+ * @dev: Device to get the property of
+ * @propname: Name of the property
+ * @val: The values are stored here
+ * @nval: Size of the @val array
+ *
+ * Function reads an array of u8 properties with @propname from the device
+ * firmware description and stores them to @val if found.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO if the property is not an array of numbers,
+ *	   %-EOVERFLOW if the size of the property is not as expected.
+ */
+int device_property_read_u8_array(struct device *dev, const char *propname,
+				  u8 *val, size_t nval)
+{
+	return DEVICE_PROPERTY_READ_ARRAY(dev, propname, u8, DEV_PROP_U8, val,
+					  nval);
+}
+EXPORT_SYMBOL_GPL(device_property_read_u8_array);
+
+/**
+ * device_property_read_u16_array - return a u16 array property of a device
+ * @dev: Device to get the property of
+ * @propname: Name of the property
+ * @val: The values are stored here
+ * @nval: Size of the @val array
+ *
+ * Function reads an array of u16 properties with @propname from the device
+ * firmware description and stores them to @val if found.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO if the property is not an array of numbers,
+ *	   %-EOVERFLOW if the size of the property is not as expected.
+ */
+int device_property_read_u16_array(struct device *dev, const char *propname,
+				   u16 *val, size_t nval)
+{
+	return DEVICE_PROPERTY_READ_ARRAY(dev, propname, u16, DEV_PROP_U16, val,
+					  nval);
+}
+EXPORT_SYMBOL_GPL(device_property_read_u16_array);
+
+/**
+ * device_property_read_u32_array - return a u32 array property of a device
+ * @dev: Device to get the property of
+ * @propname: Name of the property
+ * @val: The values are stored here
+ * @nval: Size of the @val array
+ *
+ * Function reads an array of u32 properties with @propname from the device
+ * firmware description and stores them to @val if found.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO if the property is not an array of numbers,
+ *	   %-EOVERFLOW if the size of the property is not as expected.
+ */
+int device_property_read_u32_array(struct device *dev, const char *propname,
+				   u32 *val, size_t nval)
+{
+	return DEVICE_PROPERTY_READ_ARRAY(dev, propname, u32, DEV_PROP_U32, val,
+					  nval);
+}
+EXPORT_SYMBOL_GPL(device_property_read_u32_array);
+
+/**
+ * device_property_read_u64_array - return a u64 array property of a device
+ * @dev: Device to get the property of
+ * @propname: Name of the property
+ * @val: The values are stored here
+ * @nval: Size of the @val array
+ *
+ * Function reads an array of u64 properties with @propname from the device
+ * firmware description and stores them to @val if found.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO if the property is not an array of numbers,
+ *	   %-EOVERFLOW if the size of the property is not as expected.
+ */
+int device_property_read_u64_array(struct device *dev, const char *propname,
+				   u64 *val, size_t nval)
+{
+	return DEVICE_PROPERTY_READ_ARRAY(dev, propname, u64, DEV_PROP_U64, val,
+					  nval);
+}
+EXPORT_SYMBOL_GPL(device_property_read_u64_array);
+
+/**
+ * device_property_read_string_array - return a string array property of device
+ * @dev: Device to get the property of
+ * @propname: Name of the property
+ * @val: The values are stored here
+ * @nval: Size of the @val array
+ *
+ * Function reads an array of string properties with @propname from the device
+ * firmware description and stores them to @val if found.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO or %-EILSEQ if the property is not an array of strings,
+ *	   %-EOVERFLOW if the size of the property is not as expected.
+ */
+int device_property_read_string_array(struct device *dev, const char *propname,
+				      char **val, size_t nval)
+{
+	return IS_ENABLED(CONFIG_OF) && dev->of_node ?
+		of_property_read_string_array(dev->of_node, propname, val, nval) :
+		acpi_dev_prop_read_array(ACPI_COMPANION(dev), propname,
+					 DEV_PROP_STRING, val, nval);
+}
+EXPORT_SYMBOL_GPL(device_property_read_string_array);
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
@@ -1359,24 +1392,11 @@ int of_property_match_string(struct devi
 }
 EXPORT_SYMBOL_GPL(of_property_match_string);
 
-/**
- * of_property_count_strings - Find and return the number of strings from a
- * multiple strings property.
- * @np:		device node from which the property value is to be read.
- * @propname:	name of the property to be searched.
- *
- * Search for a property in a device tree node and retrieve the number of null
- * terminated string contain in it. Returns the number of strings on
- * success, -EINVAL if the property does not exist, -ENODATA if property
- * does not have a value, and -EILSEQ if the string is not null-terminated
- * within the length of the property data.
- */
-int of_property_count_strings(struct device_node *np, const char *propname)
+static int property_count_strings(struct property *prop)
 {
-	struct property *prop = of_find_property(np, propname, NULL);
-	int i = 0;
-	size_t l = 0, total = 0;
 	const char *p;
+	size_t l = 0, total = 0;
+	int i = 0;
 
 	if (!prop)
 		return -EINVAL;
@@ -1392,8 +1412,62 @@ int of_property_count_strings(struct dev
 
 	return i;
 }
+
+/**
+ * of_property_count_strings - Find and return the number of strings from a
+ * multiple strings property.
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ *
+ * Search for a property in a device tree node and retrieve the number of null
+ * terminated string contain in it. Returns the number of strings on
+ * success, -EINVAL if the property does not exist, -ENODATA if property
+ * does not have a value, and -EILSEQ if the string is not null-terminated
+ * within the length of the property data.
+ */
+int of_property_count_strings(struct device_node *np, const char *propname)
+{
+	return property_count_strings(of_find_property(np, propname, NULL));
+}
 EXPORT_SYMBOL_GPL(of_property_count_strings);
 
+/**
+ * of_property_read_string_array - Read an array of strings from a multiple
+ * strings property.
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ * @out_strs:	output array of string pointers.
+ * @sz:		number of array elements to read.
+ *
+ * Search for a property in a device tree node and retrieve a list of
+ * terminated string values (pointer to data, not a copy) in that property.
+ *
+ * If @out_strs is NULL, the number of strings in the property is returned.
+ */
+int of_property_read_string_array(struct device_node *np, const char *propname,
+				  char **out_strs, size_t sz)
+{
+	struct property *prop = of_find_property(np, propname, NULL);
+	char *p = prop->value;
+	size_t total = 0;
+	int i;
+
+	i = property_count_strings(prop);
+	if (!out_strs || i < 0)
+		return i;
+
+	if (i < sz)
+		return -EOVERFLOW;
+
+	while (total < prop->length && i < sz) {
+		size_t l = strlen(p) + 1;
+
+		out_strs[i++] = p;
+		total += l;
+		p += l;
+	}
+}
+
 void of_print_phandle_args(const char *msg, const struct of_phandle_args *args)
 {
 	int i;
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
+		return -EOVERFLOW;
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

