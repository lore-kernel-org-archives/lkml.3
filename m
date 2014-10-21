Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbaJUVSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:18:37 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56324 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933755AbaJUVRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:17:55 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <darren.hart@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Grant Likely <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>
Subject: [PATCH v6 01/12] ACPI: Add support for device specific properties
Date: Tue, 21 Oct 2014 23:09:43 +0200
Message-ID: <5482244.xscPyWdqaY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <13750506.S2yVlRRDa2@vostro.rjw.lan>
References: <13750506.S2yVlRRDa2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Device Tree is used in many embedded systems to describe the system
configuration to the OS. It supports attaching properties or name-value
pairs to the devices it describe. With these properties one can pass
additional information to the drivers that would not be available
otherwise.

ACPI is another configuration mechanism (among other things) typically
seen, but not limited to, x86 machines. ACPI allows passing arbitrary
data from methods but there has not been mechanism equivalent to Device
Tree until the introduction of _DSD in the recent publication of the
ACPI 5.1 specification.

In order to facilitate ACPI usage in systems where Device Tree is
typically used, it would be beneficial to standardize a way to retrieve
Device Tree style properties from ACPI devices, which is what we do in
this patch.

If a given device described in ACPI namespace wants to export properties it
must implement _DSD method (Device Specific Data, introduced with ACPI 5.1)
that returns the properties in a package of packages. For example:

	Name (_DSD, Package () {
		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
		Package () {
			Package () {"name1", <VALUE1>},
			Package () {"name2", <VALUE2>},
			...
		}
	})

The UUID reserved for properties is daffd814-6eba-4d8c-8a91-bc9bbf4aa301
and is documented in the ACPI 5.1 companion document called "_DSD
Implementation Guide" [1], [2].

We add several helper functions that can be used to extract these
properties and convert them to different Linux data types.

The ultimate goal is that we only have one device property API that
retrieves the requested properties from Device Tree or from ACPI
transparent to the caller.

[1] http://www.uefi.org/sites/default/files/resources/_DSD-implementation-guide-toplevel.htm
[2] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf

Reviewed-by: Hanjun Guo <hanjun.guo@linaro.org>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/Makefile   |    1 
 drivers/acpi/internal.h |    6 
 drivers/acpi/property.c |  364 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/scan.c     |    2 
 include/acpi/acpi_bus.h |    7 
 include/linux/acpi.h    |   40 +++++
 6 files changed, 420 insertions(+)
 create mode 100644 drivers/acpi/property.c

Index: linux-pm/drivers/acpi/Makefile
===================================================================
--- linux-pm.orig/drivers/acpi/Makefile
+++ linux-pm/drivers/acpi/Makefile
@@ -46,6 +46,7 @@ acpi-y				+= acpi_pnp.o
 acpi-y				+= power.o
 acpi-y				+= event.o
 acpi-y				+= sysfs.o
+acpi-y				+= property.o
 acpi-$(CONFIG_X86)		+= acpi_cmos_rtc.o
 acpi-$(CONFIG_DEBUG_FS)		+= debugfs.o
 acpi-$(CONFIG_ACPI_NUMA)	+= numa.o
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -181,4 +181,10 @@ struct platform_device *acpi_create_plat
 bool acpi_osi_is_win8(void);
 #endif
 
+/*--------------------------------------------------------------------------
+				Device properties
+  -------------------------------------------------------------------------- */
+void acpi_init_properties(struct acpi_device *adev);
+void acpi_free_properties(struct acpi_device *adev);
+
 #endif /* _ACPI_INTERNAL_H_ */
Index: linux-pm/drivers/acpi/property.c
===================================================================
--- /dev/null
+++ linux-pm/drivers/acpi/property.c
@@ -0,0 +1,364 @@
+/*
+ * ACPI device specific properties support.
+ *
+ * Copyright (C) 2014, Intel Corporation
+ * All rights reserved.
+ *
+ * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
+ *          Darren Hart <dvhart@linux.intel.com>
+ *          Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/acpi.h>
+#include <linux/device.h>
+#include <linux/export.h>
+
+#include "internal.h"
+
+/* ACPI _DSD device properties UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301 */
+static const u8 prp_uuid[16] = {
+	0x14, 0xd8, 0xff, 0xda, 0xba, 0x6e, 0x8c, 0x4d,
+	0x8a, 0x91, 0xbc, 0x9b, 0xbf, 0x4a, 0xa3, 0x01
+};
+
+static bool acpi_property_value_ok(const union acpi_object *value)
+{
+	int j;
+
+	/*
+	 * The value must be an integer, a string, a reference, or a package
+	 * whose every element must be an integer, a string, or a reference.
+	 */
+	switch (value->type) {
+	case ACPI_TYPE_INTEGER:
+	case ACPI_TYPE_STRING:
+	case ACPI_TYPE_LOCAL_REFERENCE:
+		return true;
+
+	case ACPI_TYPE_PACKAGE:
+		for (j = 0; j < value->package.count; j++)
+			switch (value->package.elements[j].type) {
+			case ACPI_TYPE_INTEGER:
+			case ACPI_TYPE_STRING:
+			case ACPI_TYPE_LOCAL_REFERENCE:
+				continue;
+
+			default:
+				return false;
+			}
+
+		return true;
+	}
+	return false;
+}
+
+static bool acpi_properties_format_valid(const union acpi_object *properties)
+{
+	int i;
+
+	for (i = 0; i < properties->package.count; i++) {
+		const union acpi_object *property;
+
+		property = &properties->package.elements[i];
+		/*
+		 * Only two elements allowed, the first one must be a string and
+		 * the second one has to satisfy certain conditions.
+		 */
+		if (property->package.count != 2
+		    || property->package.elements[0].type != ACPI_TYPE_STRING
+		    || !acpi_property_value_ok(&property->package.elements[1]))
+			return false;
+	}
+	return true;
+}
+
+void acpi_init_properties(struct acpi_device *adev)
+{
+	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER };
+	const union acpi_object *desc;
+	acpi_status status;
+	int i;
+
+	status = acpi_evaluate_object_typed(adev->handle, "_DSD", NULL, &buf,
+					    ACPI_TYPE_PACKAGE);
+	if (ACPI_FAILURE(status))
+		return;
+
+	desc = buf.pointer;
+	if (desc->package.count % 2)
+		goto fail;
+
+	/* Look for the device properties UUID. */
+	for (i = 0; i < desc->package.count; i += 2) {
+		const union acpi_object *uuid, *properties;
+
+		uuid = &desc->package.elements[i];
+		properties = &desc->package.elements[i + 1];
+
+		/*
+		 * The first element must be a UUID and the second one must be
+		 * a package.
+		 */
+		if (uuid->type != ACPI_TYPE_BUFFER || uuid->buffer.length != 16
+		    || properties->type != ACPI_TYPE_PACKAGE)
+			break;
+
+		if (memcmp(uuid->buffer.pointer, prp_uuid, sizeof(prp_uuid)))
+			continue;
+
+		/*
+		 * We found the matching UUID. Now validate the format of the
+		 * package immediately following it.
+		 */
+		if (!acpi_properties_format_valid(properties))
+			break;
+
+		adev->data.pointer = buf.pointer;
+		adev->data.properties = properties;
+		return;
+	}
+
+ fail:
+	dev_warn(&adev->dev, "Returned _DSD data is not valid, skipping\n");
+	ACPI_FREE(buf.pointer);
+}
+
+void acpi_free_properties(struct acpi_device *adev)
+{
+	ACPI_FREE((void *)adev->data.pointer);
+	adev->data.pointer = NULL;
+	adev->data.properties = NULL;
+}
+
+/**
+ * acpi_dev_get_property - return an ACPI property with given name
+ * @adev: ACPI device to get property
+ * @name: Name of the property
+ * @type: Expected property type
+ * @obj: Location to store the property value (if not %NULL)
+ *
+ * Look up a property with @name and store a pointer to the resulting ACPI
+ * object at the location pointed to by @obj if found.
+ *
+ * Callers must not attempt to free the returned objects.  These objects will be
+ * freed by the ACPI core automatically during the removal of @adev.
+ *
+ * Return: %0 if property with @name has been found (success),
+ *         %-EINVAL if the arguments are invalid,
+ *         %-ENODATA if the property doesn't exist,
+ *         %-EPROTO if the property value type doesn't match @type.
+ */
+int acpi_dev_get_property(struct acpi_device *adev, const char *name,
+			  acpi_object_type type, const union acpi_object **obj)
+{
+	const union acpi_object *properties;
+	int i;
+
+	if (!adev || !name)
+		return -EINVAL;
+
+	if (!adev->data.pointer || !adev->data.properties)
+		return -ENODATA;
+
+	properties = adev->data.properties;
+	for (i = 0; i < properties->package.count; i++) {
+		const union acpi_object *propname, *propvalue;
+		const union acpi_object *property;
+
+		property = &properties->package.elements[i];
+
+		propname = &property->package.elements[0];
+		propvalue = &property->package.elements[1];
+
+		if (!strcmp(name, propname->string.pointer)) {
+			if (type != ACPI_TYPE_ANY && propvalue->type != type)
+				return -EPROTO;
+			else if (obj)
+				*obj = propvalue;
+
+			return 0;
+		}
+	}
+	return -ENODATA;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_get_property);
+
+/**
+ * acpi_dev_get_property_array - return an ACPI array property with given name
+ * @adev: ACPI device to get property
+ * @name: Name of the property
+ * @type: Expected type of array elements
+ * @obj: Location to store a pointer to the property value (if not NULL)
+ *
+ * Look up an array property with @name and store a pointer to the resulting
+ * ACPI object at the location pointed to by @obj if found.
+ *
+ * Callers must not attempt to free the returned objects.  Those objects will be
+ * freed by the ACPI core automatically during the removal of @adev.
+ *
+ * Return: %0 if array property (package) with @name has been found (success),
+ *         %-EINVAL if the arguments are invalid,
+ *         %-ENODATA if the property doesn't exist,
+ *         %-EPROTO if the property is not a package or the type of its elements
+ *           doesn't match @type.
+ */
+int acpi_dev_get_property_array(struct acpi_device *adev, const char *name,
+				acpi_object_type type,
+				const union acpi_object **obj)
+{
+	const union acpi_object *prop;
+	int ret, i;
+
+	ret = acpi_dev_get_property(adev, name, ACPI_TYPE_PACKAGE, &prop);
+	if (ret)
+		return ret;
+
+	if (type != ACPI_TYPE_ANY) {
+		/* Check that all elements are of correct type. */
+		for (i = 0; i < prop->package.count; i++)
+			if (prop->package.elements[i].type != type)
+				return -EPROTO;
+	}
+	if (obj)
+		*obj = prop;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_get_property_array);
+
+/**
+ * acpi_dev_get_property_reference - returns handle to the referenced object
+ * @adev: ACPI device to get property
+ * @name: Name of the property
+ * @size_prop: Name of the "size" property in referenced object
+ * @index: Index of the reference to return
+ * @args: Location to store the returned reference with optional arguments
+ *
+ * Find property with @name, verifify that it is a package containing at least
+ * one object reference and if so, store the ACPI device object pointer to the
+ * target object in @args->adev.
+ *
+ * If the reference includes arguments (@size_prop is not %NULL) follow the
+ * reference and check whether or not there is an integer property @size_prop
+ * under the target object and if so, whether or not its value matches the
+ * number of arguments that follow the reference.  If there's more than one
+ * reference in the property value package, @index is used to select the one to
+ * return.
+ *
+ * Return: %0 on success, negative error code on failure.
+ */
+int acpi_dev_get_property_reference(struct acpi_device *adev, const char *name,
+				    const char *size_prop, size_t index,
+				    struct acpi_reference_args *args)
+{
+	const union acpi_object *element, *end;
+	const union acpi_object *obj;
+	struct acpi_device *device;
+	int ret, idx = 0;
+
+	ret = acpi_dev_get_property(adev, name, ACPI_TYPE_ANY, &obj);
+	if (ret)
+		return ret;
+
+	/*
+	 * The simplest case is when the value is a single reference.  Just
+	 * return that reference then.
+	 */
+	if (obj->type == ACPI_TYPE_LOCAL_REFERENCE) {
+		if (size_prop || index)
+			return -EINVAL;
+
+		ret = acpi_bus_get_device(obj->reference.handle, &device);
+		if (ret)
+			return ret;
+
+		args->adev = device;
+		args->nargs = 0;
+		return 0;
+	}
+
+	/*
+	 * If it is not a single reference, then it is a package of
+	 * references followed by number of ints as follows:
+	 *
+	 *  Package () { REF, INT, REF, INT, INT }
+	 *
+	 * The index argument is then used to determine which reference
+	 * the caller wants (along with the arguments).
+	 */
+	if (obj->type != ACPI_TYPE_PACKAGE || index >= obj->package.count)
+		return -EPROTO;
+
+	element = obj->package.elements;
+	end = element + obj->package.count;
+
+	while (element < end) {
+		u32 nargs, i;
+
+		if (element->type != ACPI_TYPE_LOCAL_REFERENCE)
+			return -EPROTO;
+
+		ret = acpi_bus_get_device(element->reference.handle, &device);
+		if (ret)
+			return -ENODEV;
+
+		element++;
+		nargs = 0;
+
+		if (size_prop) {
+			const union acpi_object *prop;
+
+			/*
+			 * Find out how many arguments the refenced object
+			 * expects by reading its size_prop property.
+			 */
+			ret = acpi_dev_get_property(device, size_prop,
+						    ACPI_TYPE_INTEGER, &prop);
+			if (ret)
+				return ret;
+
+			nargs = prop->integer.value;
+			if (nargs > MAX_ACPI_REFERENCE_ARGS
+			    || element + nargs > end)
+				return -EPROTO;
+
+			/*
+			 * Skip to the start of the arguments and verify
+			 * that they all are in fact integers.
+			 */
+			for (i = 0; i < nargs; i++)
+				if (element[i].type != ACPI_TYPE_INTEGER)
+					return -EPROTO;
+		} else {
+			/* assume following integer elements are all args */
+			for (i = 0; element + i < end; i++) {
+				int type = element[i].type;
+
+				if (type == ACPI_TYPE_INTEGER)
+					nargs++;
+				else if (type == ACPI_TYPE_LOCAL_REFERENCE)
+					break;
+				else
+					return -EPROTO;
+			}
+		}
+
+		if (idx++ == index) {
+			args->adev = device;
+			args->nargs = nargs;
+			for (i = 0; i < nargs; i++)
+				args->args[i] = element[i].integer.value;
+
+			return 0;
+		}
+
+		element += nargs;
+	}
+
+	return -EPROTO;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_get_property_reference);
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -884,6 +884,7 @@ static void acpi_device_release(struct d
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 
+	acpi_free_properties(acpi_dev);
 	acpi_free_pnp_ids(&acpi_dev->pnp);
 	acpi_free_power_resources_lists(acpi_dev);
 	kfree(acpi_dev);
@@ -1888,6 +1889,7 @@ void acpi_init_device_object(struct acpi
 	acpi_set_device_status(device, sta);
 	acpi_device_get_busid(device);
 	acpi_set_pnp_ids(handle, &device->pnp, type);
+	acpi_init_properties(device);
 	acpi_bus_get_flags(device);
 	device->flags.match_driver = false;
 	device->flags.initialized = true;
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -337,6 +337,12 @@ struct acpi_device_physical_node {
 	bool put_online:1;
 };
 
+/* ACPI Device Specific Data (_DSD) */
+struct acpi_device_data {
+	const union acpi_object *pointer;
+	const union acpi_object *properties;
+};
+
 /* Device */
 struct acpi_device {
 	int device_type;
@@ -353,6 +359,7 @@ struct acpi_device {
 	struct acpi_device_wakeup wakeup;
 	struct acpi_device_perf performance;
 	struct acpi_device_dir dir;
+	struct acpi_device_data data;
 	struct acpi_scan_handler *handler;
 	struct acpi_hotplug_context *hp;
 	struct acpi_driver *driver;
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -658,4 +658,44 @@ do {									\
 #endif
 #endif
 
+/* Device properties */
+
+#define MAX_ACPI_REFERENCE_ARGS	8
+struct acpi_reference_args {
+	struct acpi_device *adev;
+	size_t nargs;
+	u64 args[MAX_ACPI_REFERENCE_ARGS];
+};
+
+#ifdef CONFIG_ACPI
+int acpi_dev_get_property(struct acpi_device *adev, const char *name,
+			  acpi_object_type type, const union acpi_object **obj);
+int acpi_dev_get_property_array(struct acpi_device *adev, const char *name,
+				acpi_object_type type,
+				const union acpi_object **obj);
+int acpi_dev_get_property_reference(struct acpi_device *adev, const char *name,
+				    const char *cells_name, size_t index,
+				    struct acpi_reference_args *args);
+#else
+static inline int acpi_dev_get_property(struct acpi_device *adev,
+					const char *name, acpi_object_type type,
+					const union acpi_object **obj)
+{
+	return -ENXIO;
+}
+static inline int acpi_dev_get_property_array(struct acpi_device *adev,
+					      const char *name,
+					      acpi_object_type type,
+					      const union acpi_object **obj)
+{
+	return -ENXIO;
+}
+static inline int acpi_dev_get_property_reference(struct acpi_device *adev,
+				const char *name, const char *cells_name,
+				size_t index, struct acpi_reference_args *args)
+{
+	return -ENXIO;
+}
+#endif
+
 #endif	/*_LINUX_ACPI_H*/

