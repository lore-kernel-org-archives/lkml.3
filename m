Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaJGAAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:00:17 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53350 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751646AbaJFX7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 19:59:46 -0400
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
Subject: [PATCH 10/13] Driver core: Child node properties for devices
Date: Tue, 07 Oct 2014 02:17:17 +0200
Message-ID: <3208469.WyhU6QFTtE@vostro.rjw.lan>
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

Add new generic routines for retrieving properties from device
description objects in the platform firmware in case a device driver
needs/wants to access properties of a child object of a given device
object.  There are cases in which there is no struct device
representation of such child objects and this additional API is useful
then.  Three functions are provided, device_get_child_property(),
device_read_child_property(), device_read_child_property_array(), in
analogy with device_get_property(), device_read_property() and
device_read_property_array() introduced earlier, respectively, along
with static inline wrappers for all of the propery data types that can
be used.  For all of them, the first argument is a struct device
pointer to the parent device object and the second argument is a
(void *) pointer to the child description provided by the platform
firmware (either ACPI or FDT).

Additionally, provided are a new macro device_for_each_child_node()
for iterating over the children of the device description object
associated with a given device and a new function
device_get_child_node_count() returning the number of a given
device's child nodes.

The interface covers both ACPI and Device Trees.

This change set includes material from Mika Westerberg.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c      |   20 ++++++
 drivers/base/property.c  |  148 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h     |    9 ++
 include/linux/property.h |  108 ++++++++++++++++++++++++++++++++++
 4 files changed, 285 insertions(+)

Index: linux-pm/include/linux/property.h
===================================================================
--- linux-pm.orig/include/linux/property.h
+++ linux-pm/include/linux/property.h
@@ -34,6 +34,21 @@ int device_read_property_array(struct de
 			       enum dev_prop_type proptype, void *val,
 			       size_t nval);
 
+int device_get_child_property(struct device *dev, void *child,
+			      const char *propname, void **valptr);
+int device_read_child_property(struct device *dev, void *child,
+			       const char *propname,
+			       enum dev_prop_type proptype, void *val);
+int device_read_child_property_array(struct device *dev, void *child,
+				     const char *propname,
+				     enum dev_prop_type proptype, void *val,
+				     size_t nval);
+
+void *device_get_next_child_node(struct device *dev, void *child);
+void device_put_child_node(struct device *dev, void *child);
+
+unsigned int device_get_child_node_count(struct device *dev);
+
 static inline int device_property_read_u8(struct device *dev,
 					  const char *propname, u8 *out_value)
 {
@@ -105,4 +120,97 @@ static inline int device_property_read_s
 	return device_read_property_array(dev, propname, DEV_PROP_STRING,
 					  out_strings, nstrings);
 }
+
+static inline int device_child_property_read_u8(struct device *dev, void *child,
+						const char *propname,
+						u8 *out_value)
+{
+	return device_read_child_property(dev, child, propname, DEV_PROP_U8,
+					  out_value);
+}
+
+static inline int device_child_property_read_u16(struct device *dev, void *child,
+						 const char *propname,
+						 u16 *out_value)
+{
+	return device_read_child_property(dev, child, propname, DEV_PROP_U16,
+					  out_value);
+}
+
+static inline int device_child_property_read_u32(struct device *dev, void *child,
+						 const char *propname,
+						 u32 *out_value)
+{
+	return device_read_child_property(dev, child, propname, DEV_PROP_U32,
+					  out_value);
+}
+
+static inline int device_child_property_read_u64(struct device *dev, void *child,
+						 const char *propname,
+						 u64 *out_value)
+{
+	return device_read_child_property(dev, child, propname, DEV_PROP_U64,
+					  out_value);
+}
+
+static inline int device_child_property_read_u8_array(struct device *dev,
+						      void *child,
+						      const char *propname,
+						      u8 *val, size_t nval)
+{
+	return device_read_child_property_array(dev, child, propname,
+						DEV_PROP_U8, val, nval);
+}
+
+static inline int device_child_property_read_u16_array(struct device *dev,
+						       void *child,
+						       const char *propname,
+						       u16 *val, size_t nval)
+{
+	return device_read_child_property_array(dev, child, propname,
+						DEV_PROP_U16, val, nval);
+}
+
+static inline int device_child_property_read_u32_array(struct device *dev,
+						       void *child,
+						       const char *propname,
+						       u32 *val, size_t nval)
+{
+	return device_read_child_property_array(dev, child, propname,
+						DEV_PROP_U32, val, nval);
+}
+
+static inline int device_child_property_read_u64_array(struct device *dev,
+						       void *child,
+						       const char *propname,
+						       u64 *val, size_t nval)
+{
+	return device_read_child_property_array(dev, child, propname,
+						DEV_PROP_U64, val, nval);
+}
+
+static inline int device_child_property_read_string(struct device *dev,
+						    void *child,
+						    const char *propname,
+						    const char **out_string)
+{
+	return device_read_child_property(dev, child, propname, DEV_PROP_STRING,
+					  out_string);
+}
+
+static inline int device_child_property_read_string_array(struct device *dev,
+						void *child,
+						const char *propname,
+						const char **out_strings,
+						size_t nstrings)
+{
+	return device_read_child_property_array(dev, child, propname,
+						DEV_PROP_STRING,
+						out_strings, nstrings);
+}
+
+#define device_for_each_child_node(dev, child) \
+	for (child = device_get_next_child_node(dev, NULL); child; \
+	     child = device_get_next_child_node(dev, child))
+
 #endif /* _LINUX_PROPERTY_H_ */
Index: linux-pm/drivers/base/property.c
===================================================================
--- linux-pm.orig/drivers/base/property.c
+++ linux-pm/drivers/base/property.c
@@ -95,3 +95,151 @@ int device_read_property_array(struct de
 					val, nval);
 }
 EXPORT_SYMBOL_GPL(device_read_property_array);
+
+/**
+ * device_get_child_property - return a raw property of a device's child
+ * @dev: Parent device
+ * @child: Child to get a property of
+ * @propname: Name of the property
+ * @valptr: The raw property value is stored here
+ *
+ * Function reads property @propname from the firmware description of @child and
+ * stores the raw value into @valptr if found.  Otherwise returns a negative
+ * errno as specified below.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not exist.
+ */
+int device_get_child_property(struct device *dev, void *child,
+			      const char *propname, void **valptr)
+{
+	if (!child)
+		return -EINVAL;
+
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		return of_dev_prop_get(child, propname, valptr);
+	else if (ACPI_COMPANION(dev))
+		return acpi_dev_prop_get(child, propname, valptr);
+
+	return -ENODATA;
+}
+EXPORT_SYMBOL_GPL(device_get_child_property);
+
+/**
+ * device_read_child_property - read a typed property of a device's child
+ * @dev: Parent device
+ * @child: Child to read a property of
+ * @propname: Name of the property
+ * @proptype: Type of the property
+ * @val: The value is stored here
+ *
+ * Function reads property @propname from the firmware description of @child and
+ * stores the value into @val if found. The value is checked to be of type
+ * @proptype.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not exist,
+ *	   %-EPROTO if the property type does not match @proptype,
+ *	   %-EOVERFLOW if the property value is out of bounds of @proptype.
+ */
+int device_read_child_property(struct device *dev, void *child,
+			       const char *propname, enum dev_prop_type proptype,
+			       void *val)
+{
+	if (!child)
+		return -EINVAL;
+
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		return of_dev_prop_read(child, propname, proptype, val);
+	else if (ACPI_COMPANION(dev))
+		return acpi_dev_prop_read(child, propname, proptype, val);
+
+	return -ENODATA;
+}
+EXPORT_SYMBOL_GPL(device_read_child_property);
+
+/**
+ * device_read_child_property_array - read an array property of a device's child
+ * @dev: Parent device
+ * @child: Child to get the property of
+ * @propname: Name of the property
+ * @proptype: Type of the property
+ * @val: The values are stored here
+ * @nval: Size of the @val array
+ *
+ * Function reads an array of properties with @propname from the firmware
+ * description of @child and stores them to @val if found. All the values
+ * in the array must be of type @proptype.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not exist,
+ *	   %-EPROTO if the property type does not match @proptype,
+ *	   %-EOVERFLOW if the property value is out of bounds of @proptype.
+ */
+int device_read_child_property_array(struct device *dev, void *child,
+				     const char *propname,
+				     enum dev_prop_type proptype, void *val,
+				     size_t nval)
+{
+	if (!child)
+		return -EINVAL;
+
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		return of_dev_prop_read_array(child, propname, proptype,
+					      val, nval);
+	else if (ACPI_COMPANION(dev))
+		return acpi_dev_prop_read_array(child, propname, proptype,
+						val, nval);
+
+	return -ENODATA;
+}
+EXPORT_SYMBOL_GPL(device_read_child_property_array);
+
+/**
+ * device_get_next_child_node - Return the next child node pointer for a device
+ * @dev: Device to find the next child node for.
+ * @child: Pointer to one of the device's child nodes or NULL.
+ */
+void *device_get_next_child_node(struct device *dev, void *child)
+{
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		return of_get_next_available_child(dev->of_node, child);
+
+	return acpi_get_next_child(dev, child);
+}
+EXPORT_SYMBOL_GPL(device_get_next_child_node);
+
+/**
+ * device_put_child_node - Drop reference to a device child node
+ * @dev: Parent device.
+ * @child: Pointer to the child to drop the reference to.
+ *
+ * This has to be used when terminating device_for_each_child_node() iteration
+ * with break or return to prevent stale device node references from being left
+ * behind.
+ */
+void device_put_child_node(struct device *dev, void *child)
+{
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		of_node_put(child);
+}
+EXPORT_SYMBOL_GPL(device_put_child_node);
+
+/**
+ * device_get_child_node_count - return the number of child nodes for device
+ * @dev: Device to cound the child nodes for
+ */
+unsigned int device_get_child_node_count(struct device *dev)
+{
+	unsigned int count = 0;
+	void *child = NULL;
+
+	device_for_each_child_node(dev, child)
+		count++;
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(device_get_child_node_count);
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -681,6 +681,9 @@ int acpi_dev_prop_read(struct acpi_devic
 int acpi_dev_prop_read_array(struct acpi_device *adev, const char *propname,
 			     enum dev_prop_type proptype, void *val,
 			     size_t nval);
+
+struct acpi_device *acpi_get_next_child(struct device *dev,
+					struct acpi_device *child);
 #else
 static inline int acpi_dev_get_property(struct acpi_device *adev,
 					const char *name, acpi_object_type type,
@@ -723,6 +726,12 @@ static inline int acpi_dev_prop_read_arr
 {
 	return -ENXIO;
 }
+
+static inline struct acpi_device *acpi_get_next_child(struct device *dev,
+						      struct acpi_device *child)
+{
+	return NULL;
+}
 #endif
 
 #endif	/*_LINUX_ACPI_H*/
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1342,6 +1342,26 @@ int acpi_device_add(struct acpi_device *
 	return result;
 }
 
+struct acpi_device *acpi_get_next_child(struct device *dev,
+					struct acpi_device *child)
+{
+	struct acpi_device *adev = ACPI_COMPANION(dev);
+	struct list_head *head, *next;
+
+	if (!adev)
+		return NULL;
+
+	head = &adev->children;
+	if (list_empty(head))
+		return NULL;
+
+	if (!child)
+		return list_first_entry(head, struct acpi_device, node);
+
+	next = child->node.next;
+	return next == head ? NULL : list_entry(next, struct acpi_device, node);
+}
+
 /* --------------------------------------------------------------------------
                                  Driver Management
    -------------------------------------------------------------------------- */

