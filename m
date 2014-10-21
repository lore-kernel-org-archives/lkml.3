Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbaJUVWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:22:12 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55510 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933710AbaJUVRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:17:49 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <darren.hart@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>
Subject: [PATCH v6 09/12] Driver core: Unified interface for firmware node properties
Date: Tue, 21 Oct 2014 23:29:24 +0200
Message-ID: <3311274.lPerUdEdSh@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <13750506.S2yVlRRDa2@vostro.rjw.lan>
References: <13750506.S2yVlRRDa2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Add new generic routines are provided for retrieving properties from
device description objects in the platform firmware in case there are
no struct device objects for them (either those objects have not been
created yet or they do not exist at all).

The following functions are provided:

fwnode_property_present()
fwnode_property_read_u8()
fwnode_property_read_u16()
fwnode_property_read_u32()
fwnode_property_read_u64()
fwnode_property_read_string()
fwnode_property_read_u8_array()
fwnode_property_read_u16_array()
fwnode_property_read_u32_array()
fwnode_property_read_u64_array()
fwnode_property_read_string_array()

in analogy with the corresponding functions for struct device added
previously.  For all of them, the first argument is a pointer to struct
fwnode_handle (new type) that allows a device description object
(depending on what platform firmware interface is in use) to be
obtained.

Add a new macro device_for_each_child_node() for iterating over the
children of the device description object associated with a given
device and a new function device_get_child_node_count() returning the
number of a given device's child nodes.

The interface covers both ACPI and Device Trees.

Suggested-by: Grant Likely <grant.likely@linaro.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Changes from v5:
- There's a new macro for generating the bodies of fwnode_property_read_u*_array().
- fwnode_property_read_u*() are implemented using fwnode_property_read_u*_array().
- fwnode_property_read_bool() is a new static inline wrapper around
  fwnode_property_present().
- IS_ENABLED(CONFIG_ACPI) is used in device_get_next_child_node() instead of
  ACPI_COMPANION(dev), because acpi_get_next_child() returns NULL if
  ACPI_COMPANION(dev) is NULL.

---
 drivers/acpi/scan.c      |   21 +++
 drivers/base/property.c  |  298 +++++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h  |   17 ++
 include/linux/acpi.h     |   26 ++++
 include/linux/of.h       |   22 +++
 include/linux/property.h |   54 ++++++++
 6 files changed, 438 insertions(+)

Index: linux-pm/include/linux/property.h
===================================================================
--- linux-pm.orig/include/linux/property.h
+++ linux-pm/include/linux/property.h
@@ -44,10 +44,64 @@ int device_property_read_u64(struct devi
 int device_property_read_string(struct device *dev, const char *propname,
 				const char **val);
 
+enum fwnode_type {
+	FWNODE_INVALID = 0,
+	FWNODE_OF,
+	FWNODE_ACPI,
+};
+
+struct fwnode_handle {
+	enum fwnode_type type;
+};
+
+bool fwnode_property_present(struct fwnode_handle *fwnode, const char *propname);
+int fwnode_property_read_u8_array(struct fwnode_handle *fwnode,
+				  const char *propname, u8 *val,
+				  size_t nval);
+int fwnode_property_read_u16_array(struct fwnode_handle *fwnode,
+				   const char *propname, u16 *val,
+				   size_t nval);
+int fwnode_property_read_u32_array(struct fwnode_handle *fwnode,
+				   const char *propname, u32 *val,
+				   size_t nval);
+int fwnode_property_read_u64_array(struct fwnode_handle *fwnode,
+				   const char *propname, u64 *val,
+				   size_t nval);
+int fwnode_property_read_string_array(struct fwnode_handle *fwnode,
+				      const char *propname, char **val,
+				      size_t nval);
+int fwnode_property_read_u8(struct fwnode_handle *fwnode, const char *propname,
+			    u8 *val);
+int fwnode_property_read_u16(struct fwnode_handle *fwnode, const char *propname,
+			     u16 *val);
+int fwnode_property_read_u32(struct fwnode_handle *fwnode, const char *propname,
+			     u32 *val);
+int fwnode_property_read_u64(struct fwnode_handle *fwnode, const char *propname,
+			     u64 *val);
+int fwnode_property_read_string(struct fwnode_handle *fwnode,
+				const char *propname, const char **val);
+
+struct fwnode_handle *device_get_next_child_node(struct device *dev,
+						 struct fwnode_handle *child);
+
+#define device_for_each_child_node(dev, child) \
+	for (child = device_get_next_child_node(dev, NULL); child; \
+	     child = device_get_next_child_node(dev, child))
+
+void fwnode_handle_put(struct fwnode_handle *fwnode);
+
+unsigned int device_get_child_node_count(struct device *dev);
+
 static inline bool device_property_read_bool(struct device *dev,
 					     const char *propname)
 {
 	return device_property_present(dev, propname);
 }
 
+static inline bool fwnode_property_read_bool(struct fwnode_handle *fwnode,
+					     const char *propname)
+{
+	return fwnode_property_present(fwnode, propname);
+}
+
 #endif /* _LINUX_PROPERTY_H_ */
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -27,6 +27,7 @@
 #define __ACPI_BUS_H__
 
 #include <linux/device.h>
+#include <linux/property.h>
 
 /* TBD: Make dynamic */
 #define ACPI_MAX_HANDLES	10
@@ -348,6 +349,7 @@ struct acpi_device_data {
 struct acpi_device {
 	int device_type;
 	acpi_handle handle;		/* no handle for fixed hardware */
+	struct fwnode_handle fwnode;
 	struct acpi_device *parent;
 	struct list_head children;
 	struct list_head node;
@@ -372,6 +374,21 @@ struct acpi_device {
 	void (*remove)(struct acpi_device *);
 };
 
+static inline bool is_acpi_node(struct fwnode_handle *fwnode)
+{
+	return fwnode && fwnode->type == FWNODE_ACPI;
+}
+
+static inline struct acpi_device *acpi_node(struct fwnode_handle *fwnode)
+{
+	return fwnode ? container_of(fwnode, struct acpi_device, fwnode) : NULL;
+}
+
+static inline struct fwnode_handle *acpi_fwnode_handle(struct acpi_device *adev)
+{
+	return &adev->fwnode;
+}
+
 static inline void *acpi_driver_data(struct acpi_device *d)
 {
 	return d->driver_data;
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -439,6 +439,23 @@ int acpi_device_modalias(struct device *
 #define ACPI_COMPANION_SET(dev, adev)	do { } while (0)
 #define ACPI_HANDLE(dev)		(NULL)
 
+struct fwnode_handle;
+
+static inline bool is_acpi_node(struct fwnode_handle *fwnode)
+{
+	return false;
+}
+
+static inline struct acpi_device *acpi_node(struct fwnode_handle *fwnode)
+{
+	return NULL;
+}
+
+static inline struct fwnode_handle *acpi_fwnode_handle(struct acpi_device *adev)
+{
+	return NULL;
+}
+
 static inline const char *acpi_dev_name(struct acpi_device *adev)
 {
 	return NULL;
@@ -680,6 +697,9 @@ int acpi_dev_prop_read_single(struct acp
 			      enum dev_prop_type proptype, void *val);
 int acpi_dev_prop_read(struct acpi_device *adev, const char *propname,
 		       enum dev_prop_type proptype, void *val, size_t nval);
+
+struct acpi_device *acpi_get_next_child(struct device *dev,
+					struct acpi_device *child);
 #else
 static inline int acpi_dev_get_property(struct acpi_device *adev,
 					const char *name, acpi_object_type type,
@@ -724,6 +744,12 @@ static inline int acpi_dev_prop_read(str
 	return -ENXIO;
 }
 
+static inline struct acpi_device *acpi_get_next_child(struct device *dev,
+						      struct acpi_device *child)
+{
+	return NULL;
+}
+
 #endif
 
 #endif	/*_LINUX_ACPI_H*/
Index: linux-pm/include/linux/of.h
===================================================================
--- linux-pm.orig/include/linux/of.h
+++ linux-pm/include/linux/of.h
@@ -50,6 +50,7 @@ struct device_node {
 	const char *type;
 	phandle phandle;
 	const char *full_name;
+	struct fwnode_handle fwnode;
 
 	struct	property *properties;
 	struct	property *deadprops;	/* removed properties */
@@ -80,6 +81,7 @@ extern struct kobj_type of_node_ktype;
 static inline void of_node_init(struct device_node *node)
 {
 	kobject_init(&node->kobj, &of_node_ktype);
+	node->fwnode.type = FWNODE_OF;
 }
 
 /* true when node is initialized */
@@ -115,6 +117,16 @@ extern struct device_node *of_aliases;
 extern struct device_node *of_stdout;
 extern raw_spinlock_t devtree_lock;
 
+static inline bool is_of_node(struct fwnode_handle *fwnode)
+{
+	return fwnode && fwnode->type == FWNODE_OF;
+}
+
+static inline struct device_node *of_node(struct fwnode_handle *fwnode)
+{
+	return fwnode ? container_of(fwnode, struct device_node, fwnode) : NULL;
+}
+
 static inline bool of_have_populated_dt(void)
 {
 	return of_allnodes != NULL;
@@ -365,6 +377,16 @@ bool of_console_check(struct device_node
 
 #else /* CONFIG_OF */
 
+static inline bool is_of_node(struct fwnode_handle *fwnode)
+{
+	return false;
+}
+
+static inline struct device_node *of_node(struct fwnode_handle *fwnode)
+{
+	return NULL;
+}
+
 static inline const char* of_node_full_name(const struct device_node *np)
 {
 	return "<no-node>";
Index: linux-pm/drivers/base/property.c
===================================================================
--- linux-pm.orig/drivers/base/property.c
+++ linux-pm/drivers/base/property.c
@@ -31,6 +31,22 @@ bool device_property_present(struct devi
 }
 EXPORT_SYMBOL_GPL(device_property_present);
 
+/**
+ * fwnode_property_present - check if a property of a firmware node is present
+ * @fwnode: Firmware node whose property to check
+ * @propname: Name of the property
+ */
+bool fwnode_property_present(struct fwnode_handle *fwnode, const char *propname)
+{
+	if (is_of_node(fwnode))
+		return of_property_read_bool(of_node(fwnode), propname);
+	else if (is_acpi_node(fwnode))
+		return !acpi_dev_prop_get(acpi_node(fwnode), propname, NULL);
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(fwnode_property_present);
+
 #define OF_DEV_PROP_READ_ARRAY(node, propname, type, val, nval) \
 	(val) ? of_property_read_##type##_array((node), (propname), (val), (nval)) \
 	      : of_property_count_elems_of_size((node), (propname), sizeof(type))
@@ -231,3 +247,285 @@ int device_property_read_string(struct d
 				   DEV_PROP_STRING, val, 1);
 }
 EXPORT_SYMBOL_GPL(device_property_read_string);
+
+#define FWNODE_PROP_READ_ARRAY(_fwnode_, _propname_, _type_, _proptype_, _val_, _nval_) \
+({ \
+	int _ret_; \
+	if (is_of_node(_fwnode_)) \
+		_ret_ = OF_DEV_PROP_READ_ARRAY(of_node(_fwnode_), _propname_, \
+					       _type_, _val_, _nval_); \
+	else if (is_acpi_node(_fwnode_)) \
+		_ret_ = acpi_dev_prop_read(acpi_node(_fwnode_), _propname_, \
+					   _proptype_, _val_, _nval_); \
+	else \
+		_ret_ = -ENXIO; \
+	_ret_; \
+})
+
+/**
+ * fwnode_property_read_u8_array - return a u8 array property of firmware node
+ * @fwnode: Firmware node to get the property of
+ * @propname: Name of the property
+ * @val: The values are stored here
+ * @nval: Size of the @val array
+ *
+ * Read an array of u8 properties with @propname from @fwnode and stores them to
+ * @val if found.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO if the property is not an array of numbers,
+ *	   %-EOVERFLOW if the size of the property is not as expected,
+ *	   %-ENXIO if no suitable firmware interface is present.
+ */
+int fwnode_property_read_u8_array(struct fwnode_handle *fwnode,
+				  const char *propname, u8 *val, size_t nval)
+{
+	return FWNODE_PROP_READ_ARRAY(fwnode, propname, u8, DEV_PROP_U8,
+				      val, nval);
+}
+EXPORT_SYMBOL_GPL(fwnode_property_read_u8_array);
+
+/**
+ * fwnode_property_read_u16_array - return a u16 array property of firmware node
+ * @fwnode: Firmware node to get the property of
+ * @propname: Name of the property
+ * @val: The values are stored here
+ * @nval: Size of the @val array
+ *
+ * Read an array of u16 properties with @propname from @fwnode and store them to
+ * @val if found.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO if the property is not an array of numbers,
+ *	   %-EOVERFLOW if the size of the property is not as expected,
+ *	   %-ENXIO if no suitable firmware interface is present.
+ */
+int fwnode_property_read_u16_array(struct fwnode_handle *fwnode,
+				   const char *propname, u16 *val, size_t nval)
+{
+	return FWNODE_PROP_READ_ARRAY(fwnode, propname, u16, DEV_PROP_U16,
+				      val, nval);
+}
+EXPORT_SYMBOL_GPL(fwnode_property_read_u16_array);
+
+/**
+ * fwnode_property_read_u32_array - return a u32 array property of firmware node
+ * @fwnode: Firmware node to get the property of
+ * @propname: Name of the property
+ * @val: The values are stored here
+ * @nval: Size of the @val array
+ *
+ * Read an array of u32 properties with @propname from @fwnode store them to
+ * @val if found.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO if the property is not an array of numbers,
+ *	   %-EOVERFLOW if the size of the property is not as expected,
+ *	   %-ENXIO if no suitable firmware interface is present.
+ */
+int fwnode_property_read_u32_array(struct fwnode_handle *fwnode,
+				   const char *propname, u32 *val, size_t nval)
+{
+	return FWNODE_PROP_READ_ARRAY(fwnode, propname, u32, DEV_PROP_U32,
+				      val, nval);
+}
+EXPORT_SYMBOL_GPL(fwnode_property_read_u32_array);
+
+/**
+ * fwnode_property_read_u64_array - return a u64 array property firmware node
+ * @fwnode: Firmware node to get the property of
+ * @propname: Name of the property
+ * @val: The values are stored here
+ * @nval: Size of the @val array
+ *
+ * Read an array of u64 properties with @propname from @fwnode and store them to
+ * @val if found.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO if the property is not an array of numbers,
+ *	   %-EOVERFLOW if the size of the property is not as expected,
+ *	   %-ENXIO if no suitable firmware interface is present.
+ */
+int fwnode_property_read_u64_array(struct fwnode_handle *fwnode,
+				   const char *propname, u64 *val, size_t nval)
+{
+	return FWNODE_PROP_READ_ARRAY(fwnode, propname, u64, DEV_PROP_U64,
+				      val, nval);
+}
+EXPORT_SYMBOL_GPL(fwnode_property_read_u64_array);
+
+/**
+ * fwnode_property_read_string_array - return string array property of a node
+ * @fwnode: Firmware node to get the property of
+ * @propname: Name of the property
+ * @val: The values are stored here
+ * @nval: Size of the @val array
+ *
+ * Read an string list property @propname from the given firmware node and store
+ * them to @val if found.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO if the property is not an array of strings,
+ *	   %-EOVERFLOW if the size of the property is not as expected,
+ *	   %-ENXIO if no suitable firmware interface is present.
+ */
+int fwnode_property_read_string_array(struct fwnode_handle *fwnode,
+				      const char *propname, char **val,
+				      size_t nval)
+{
+	if (is_of_node(fwnode))
+		return of_property_read_string_array(of_node(fwnode), propname,
+						     val, nval);
+	else if (is_acpi_node(fwnode))
+		return acpi_dev_prop_read(acpi_node(fwnode), propname,
+					  DEV_PROP_STRING, val, nval);
+
+	return -ENXIO;
+}
+EXPORT_SYMBOL_GPL(fwnode_property_read_string_array);
+
+/**
+ * fwnode_property_read_u8 - return a u8 property of a firmware node
+ * @fwnode: Firmware node to get the property of
+ * @propname: Name of the property
+ * @val: The value is stored here
+ */
+int fwnode_property_read_u8(struct fwnode_handle *fwnode, const char *propname,
+			    u8 *val)
+{
+	return fwnode_property_read_u8_array(fwnode, propname, val, 1);
+}
+EXPORT_SYMBOL_GPL(fwnode_property_read_u8);
+
+/**
+ * fwnode_property_read_u16 - return a u16 property of a firmware node
+ * @fwnode: Firmware node to get the property of
+ * @propname: Name of the property
+ * @val: The value is stored here
+ */
+int fwnode_property_read_u16(struct fwnode_handle *fwnode, const char *propname,
+			     u16 *val)
+{
+	return fwnode_property_read_u16_array(fwnode, propname, val, 1);
+}
+EXPORT_SYMBOL_GPL(fwnode_property_read_u16);
+
+/**
+ * fwnode_property_read_u32 - return a u32 property of a firmware node
+ * @fwnode: Firmware node to get the property of
+ * @propname: Name of the property
+ * @val: The value is stored here
+ */
+int fwnode_property_read_u32(struct fwnode_handle *fwnode, const char *propname,
+			     u32 *val)
+{
+	return fwnode_property_read_u32_array(fwnode, propname, val, 1);
+}
+EXPORT_SYMBOL_GPL(fwnode_property_read_u32);
+
+/**
+ * fwnode_property_read_u64 - return a u64 property of a firmware node
+ * @fwnode: Firmware node to get the property of
+ * @propname: Name of the property
+ * @val: The value is stored here
+ */
+int fwnode_property_read_u64(struct fwnode_handle *fwnode, const char *propname,
+			     u64 *val)
+{
+	return fwnode_property_read_u64_array(fwnode, propname, val, 1);
+}
+EXPORT_SYMBOL_GPL(fwnode_property_read_u64);
+
+/**
+ * fwnode_property_read_string - return a string property of a firmware node
+ * @fwnode: Firmware node to get the property of
+ * @propname: Name of the property
+ * @val: The value is stored here
+ *
+ * Read property @propname from the given firmware node and store the value into
+ * @val if found.  The value is checked to be a string.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO or %-EILSEQ if the property is not a string,
+ *	   %-ENXIO if no suitable firmware interface is present.
+ */
+int fwnode_property_read_string(struct fwnode_handle *fwnode,
+				const char *propname, const char **val)
+{
+	if (is_of_node(fwnode))
+		return of_property_read_string(of_node(fwnode),propname, val);
+	else if (is_acpi_node(fwnode))
+		return acpi_dev_prop_read(acpi_node(fwnode), propname,
+					  DEV_PROP_STRING, val, 1);
+
+	return -ENXIO;
+}
+EXPORT_SYMBOL_GPL(fwnode_property_read_string);
+
+/**
+ * device_get_next_child_node - Return the next child node handle for a device
+ * @dev: Device to find the next child node for.
+ * @child: Handle to one of the device's child nodes or a null handle.
+ */
+struct fwnode_handle *device_get_next_child_node(struct device *dev,
+						 struct fwnode_handle *child)
+{
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
+		struct device_node *node;
+
+		node = of_get_next_available_child(dev->of_node, of_node(child));
+		if (node)
+			return &node->fwnode;
+	} else if (IS_ENABLED(CONFIG_ACPI)) {
+		struct acpi_device *node;
+
+		node = acpi_get_next_child(dev, acpi_node(child));
+		if (node)
+			return acpi_fwnode_handle(node);
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(device_get_next_child_node);
+
+/**
+ * fwnode_handle_put - Drop reference to a device node
+ * @fwnode: Pointer to the device node to drop the reference to.
+ *
+ * This has to be used when terminating device_for_each_child_node() iteration
+ * with break or return to prevent stale device node references from being left
+ * behind.
+ */
+void fwnode_handle_put(struct fwnode_handle *fwnode)
+{
+	if (is_of_node(fwnode))
+		of_node_put(of_node(fwnode));
+}
+EXPORT_SYMBOL_GPL(fwnode_handle_put);
+
+/**
+ * device_get_child_node_count - return the number of child nodes for device
+ * @dev: Device to cound the child nodes for
+ */
+unsigned int device_get_child_node_count(struct device *dev)
+{
+	struct fwnode_handle *child;
+	unsigned int count = 0;
+
+	device_for_each_child_node(dev, child)
+		count++;
+
+	return count;
+}
+EXPORT_SYMBOL_GPL(device_get_child_node_count);
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
@@ -1961,6 +1981,7 @@ void acpi_init_device_object(struct acpi
 	device->device_type = type;
 	device->handle = handle;
 	device->parent = acpi_bus_get_parent(handle);
+	device->fwnode.type = FWNODE_ACPI;
 	acpi_set_device_status(device, sta);
 	acpi_device_get_busid(device);
 	acpi_set_pnp_ids(handle, &device->pnp, type);

