Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbbAMMAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:00:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:9576 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbbAMMAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:00:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,749,1413270000"; 
   d="scan'208";a="669038764"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2] driver core: property: support for generic property
Date: Tue, 13 Jan 2015 14:00:28 +0200
Message-Id: <1421150428-10191-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the Unified Property Interface by adding
"Generic Property" to it for cases where device tree or ACPI
are not being used.

That makes the unified device property interface cover also
most of the cases where information is extracted from custom
platform_data in the drivers. So if before we had to check
separately if there is custom platform_data for a driver:

	if (pdata)
		val = pdata->val;
	else
		device_property_read_u32(dev, "magic", &val);

we can now drop that check and simply always use the unified
device property interface.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---

Changes since v1:
- Kept DEV_PROP_READ_ARRAY as suggested by Rafael.

 drivers/base/property.c  | 156 +++++++++++++++++++++++++++++++++++++++++++----
 include/linux/device.h   |   2 +
 include/linux/property.h |  13 ++++
 3 files changed, 159 insertions(+), 12 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index c458458..666d0c4 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -15,6 +15,129 @@
 #include <linux/acpi.h>
 #include <linux/of.h>
 
+static struct dev_gen_prop *dev_prop_get(struct device *dev, const char *name)
+{
+	struct dev_gen_prop *prop;
+
+	if (!dev->gen_prop)
+		return NULL;
+
+	for (prop = dev->gen_prop; prop->name; prop++)
+		if (!strcmp(name, prop->name))
+			return prop;
+	return NULL;
+}
+
+static int dev_prop_copy_array_u8(const char **src, u8 *val, size_t nval)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < nval; i++) {
+		if (!src[i])
+			return -EOVERFLOW;
+		ret = kstrtou8(src[i], 0, &val[i]);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int dev_prop_copy_array_u16(const char **src, u16 *val, size_t nval)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < nval; i++) {
+		if (!src[i])
+			return -EOVERFLOW;
+		ret = kstrtou16(src[i], 0, &val[i]);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int dev_prop_copy_array_u32(const char **src, u32 *val, size_t nval)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < nval; i++) {
+		if (!src[i])
+			return -EOVERFLOW;
+		ret = kstrtou32(src[i], 0, &val[i]);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int dev_prop_copy_array_u64(const char **src, u64 *val, size_t nval)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < nval; i++) {
+		if (!src[i])
+			return -EOVERFLOW;
+		ret = kstrtou64(src[i], 0, &val[i]);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int dev_prop_copy_array_string(const char **src, const char **val,
+				      size_t nval)
+{
+	int i;
+
+	for (i = 0; i < nval; i++) {
+		if (!src[i])
+			return -EOVERFLOW;
+		val[i] = src[i];
+	}
+	return 0;
+}
+
+static int dev_prop_read_array(struct device *dev, const char *name,
+			       enum dev_prop_type type, void *val, size_t nval)
+{
+	struct dev_gen_prop *prop;
+	int ret = 0;
+
+	prop = dev_prop_get(dev, name);
+	if (!prop)
+		return -ENODATA;
+
+	if (prop->type != type)
+		return -EPROTO;
+
+	switch (prop->type) {
+	case DEV_PROP_U8:
+		ret = dev_prop_copy_array_u8(prop->val, (u8 *)val, nval);
+		break;
+	case DEV_PROP_U16:
+		ret = dev_prop_copy_array_u16(prop->val, (u16 *)val, nval);
+		break;
+	case DEV_PROP_U32:
+		ret = dev_prop_copy_array_u32(prop->val, (u32 *)val, nval);
+		break;
+	case DEV_PROP_U64:
+		ret = dev_prop_copy_array_u64(prop->val, (u64 *)val, nval);
+		break;
+	case DEV_PROP_STRING:
+		ret = dev_prop_copy_array_string(prop->val, (const char **)val,
+						 nval);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
 /**
  * device_property_present - check if a property of a device is present
  * @dev: Device whose property is being checked
@@ -26,8 +149,9 @@ bool device_property_present(struct device *dev, const char *propname)
 {
 	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
 		return of_property_read_bool(dev->of_node, propname);
-
-	return !acpi_dev_prop_get(ACPI_COMPANION(dev), propname, NULL);
+	if (ACPI_HANDLE(dev))
+		return !acpi_dev_prop_get(ACPI_COMPANION(dev), propname, NULL);
+	return !!dev_prop_get(dev, propname);
 }
 EXPORT_SYMBOL_GPL(device_property_present);
 
@@ -55,8 +179,11 @@ EXPORT_SYMBOL_GPL(fwnode_property_present);
 	IS_ENABLED(CONFIG_OF) && _dev_->of_node ? \
 		(OF_DEV_PROP_READ_ARRAY(_dev_->of_node, _propname_, _type_, \
 					_val_, _nval_)) : \
-		acpi_dev_prop_read(ACPI_COMPANION(_dev_), _propname_, \
-				   _proptype_, _val_, _nval_)
+		ACPI_HANDLE(_dev_) ? \
+			acpi_dev_prop_read(ACPI_COMPANION(_dev_), _propname_, \
+					   _proptype_, _val_, _nval_) : \
+			dev_prop_read_array(_dev_, _propname_, _proptype_, \
+					   _val_, _nval_)
 
 /**
  * device_property_read_u8_array - return a u8 array property of a device
@@ -169,10 +296,13 @@ EXPORT_SYMBOL_GPL(device_property_read_u64_array);
 int device_property_read_string_array(struct device *dev, const char *propname,
 				      const char **val, size_t nval)
 {
-	return IS_ENABLED(CONFIG_OF) && dev->of_node ?
-		of_property_read_string_array(dev->of_node, propname, val, nval) :
-		acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
-				   DEV_PROP_STRING, val, nval);
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		return of_property_read_string_array(dev->of_node, propname,
+						     val, nval);
+	if (ACPI_HANDLE(dev))
+		return acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
+					  DEV_PROP_STRING, val, nval);
+	return dev_prop_read_array(dev, propname, DEV_PROP_STRING, val, nval);
 }
 EXPORT_SYMBOL_GPL(device_property_read_string_array);
 
@@ -193,10 +323,12 @@ EXPORT_SYMBOL_GPL(device_property_read_string_array);
 int device_property_read_string(struct device *dev, const char *propname,
 				const char **val)
 {
-	return IS_ENABLED(CONFIG_OF) && dev->of_node ?
-		of_property_read_string(dev->of_node, propname, val) :
-		acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
-				   DEV_PROP_STRING, val, 1);
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		return of_property_read_string(dev->of_node, propname, val);
+	if (ACPI_HANDLE(dev))
+		return acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
+					  DEV_PROP_STRING, val, 1);
+	return dev_prop_read_array(dev, propname, DEV_PROP_STRING, val, 1);
 }
 EXPORT_SYMBOL_GPL(device_property_read_string);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index fb50673..bd1e292 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -27,6 +27,7 @@
 #include <linux/ratelimit.h>
 #include <linux/uidgid.h>
 #include <linux/gfp.h>
+#include <linux/property.h>
 #include <asm/device.h>
 
 struct device;
@@ -780,6 +781,7 @@ struct device {
 
 	struct device_node	*of_node; /* associated device tree node */
 	struct acpi_dev_node	acpi_node; /* associated ACPI device node */
+	struct dev_gen_prop	*gen_prop;
 
 	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
 	u32			id;	/* device instance */
diff --git a/include/linux/property.h b/include/linux/property.h
index a6a3d98..6ac8e508 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -26,6 +26,19 @@ enum dev_prop_type {
 	DEV_PROP_MAX,
 };
 
+/**
+ * struct dev_gen_prop - Generic Device Property
+ * @name: property name
+ * @val: value array
+ *
+ * Used when of_node and acpi_node are missing.
+ */
+struct dev_gen_prop {
+	enum dev_prop_type type;
+	const char *name;
+	const char **val;
+};
+
 bool device_property_present(struct device *dev, const char *propname);
 int device_property_read_u8_array(struct device *dev, const char *propname,
 				  u8 *val, size_t nval);
-- 
2.1.4

