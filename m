Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaBLABZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 19:01:25 -0500
Received: from gloria.sntech.de ([95.129.55.99]:54639 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaBLABY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 19:01:24 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: grant.likely@linaro.org
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 1/3] of: add functions to count number of elements in a property
Date: Wed, 12 Feb 2014 01:00:34 +0100
Message-ID: <2409422.L9c2tQTy2E@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <2573561.oCYNnnL0gm@phil>
References: <2573561.oCYNnnL0gm@phil>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@bqreaders.com>

The need to know the number of array elements in a property is
a common pattern. To prevent duplication of open-coded implementations
add a helper static function that also centralises strict sanity
checking and DTB format details, as well as a set of wrapper functions
for u8, u16, u32 and u64.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Heiko Stuebner <heiko.stuebner@bqreaders.com>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/base.c  |   32 ++++++++++++++++++++++
 include/linux/of.h |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 239e3da..bed63c2 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -886,6 +886,38 @@ struct device_node *of_find_node_by_phandle(phandle handle)
 EXPORT_SYMBOL(of_find_node_by_phandle);
 
 /**
+ * of_property_count_elems_of_size - Count the number of elements in a property
+ *
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ * @elem_size:	size of the individual element
+ *
+ * Search for a property in a device node and count the number of elements of
+ * size elem_size in it. Returns number of elements on sucess, -EINVAL if the
+ * property does not exist or its length does not match a multiple of elem_size
+ * and -ENODATA if the property does not have a value.
+ */
+int of_property_count_elems_of_size(const struct device_node *np,
+				const char *propname, int elem_size)
+{
+	struct property *prop = of_find_property(np, propname, NULL);
+
+	if (!prop)
+		return -EINVAL;
+	if (!prop->value)
+		return -ENODATA;
+
+	if (prop->length % elem_size != 0) {
+		pr_err("size of %s in node %s is not a multiple of %d\n",
+		       propname, np->full_name, elem_size);
+		return -EINVAL;
+	}
+
+	return prop->length / elem_size;
+}
+EXPORT_SYMBOL_GPL(of_property_count_elems_of_size);
+
+/**
  * of_find_property_value_of_size
  *
  * @np:		device node from which the property value is to be read.
diff --git a/include/linux/of.h b/include/linux/of.h
index b3d0f6d..8cc9cef 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -218,6 +218,8 @@ extern struct device_node *of_find_node_with_property(
 extern struct property *of_find_property(const struct device_node *np,
 					 const char *name,
 					 int *lenp);
+extern int of_property_count_elems_of_size(const struct device_node *np,
+				const char *propname, int elem_size);
 extern int of_property_read_u32_index(const struct device_node *np,
 				       const char *propname,
 				       u32 index, u32 *out_value);
@@ -410,6 +412,12 @@ static inline struct device_node *of_find_compatible_node(
 	return NULL;
 }
 
+static inline int of_property_count_elems_of_size(const struct device_node *np,
+			const char *propname, int elem_size)
+{
+	return -ENOSYS;
+}
+
 static inline int of_property_read_u32_index(const struct device_node *np,
 			const char *propname, u32 index, u32 *out_value)
 {
@@ -556,6 +564,74 @@ static inline struct device_node *of_find_matching_node(
 }
 
 /**
+ * of_property_count_u8_elems - Count the number of u8 elements in a property
+ *
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ *
+ * Search for a property in a device node and count the number of u8 elements
+ * in it. Returns number of elements on sucess, -EINVAL if the property does
+ * not exist or its length does not match a multiple of u8 and -ENODATA if the
+ * property does not have a value.
+ */
+static inline int of_property_count_u8_elems(const struct device_node *np,
+				const char *propname)
+{
+	return of_property_count_elems_of_size(np, propname, sizeof(u8));
+}
+
+/**
+ * of_property_count_u16_elems - Count the number of u16 elements in a property
+ *
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ *
+ * Search for a property in a device node and count the number of u16 elements
+ * in it. Returns number of elements on sucess, -EINVAL if the property does
+ * not exist or its length does not match a multiple of u16 and -ENODATA if the
+ * property does not have a value.
+ */
+static inline int of_property_count_u16_elems(const struct device_node *np,
+				const char *propname)
+{
+	return of_property_count_elems_of_size(np, propname, sizeof(u16));
+}
+
+/**
+ * of_property_count_u32_elems - Count the number of u32 elements in a property
+ *
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ *
+ * Search for a property in a device node and count the number of u32 elements
+ * in it. Returns number of elements on sucess, -EINVAL if the property does
+ * not exist or its length does not match a multiple of u32 and -ENODATA if the
+ * property does not have a value.
+ */
+static inline int of_property_count_u32_elems(const struct device_node *np,
+				const char *propname)
+{
+	return of_property_count_elems_of_size(np, propname, sizeof(u32));
+}
+
+/**
+ * of_property_count_u64_elems - Count the number of u64 elements in a property
+ *
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ *
+ * Search for a property in a device node and count the number of u64 elements
+ * in it. Returns number of elements on sucess, -EINVAL if the property does
+ * not exist or its length does not match a multiple of u64 and -ENODATA if the
+ * property does not have a value.
+ */
+static inline int of_property_count_u64_elems(const struct device_node *np,
+				const char *propname)
+{
+	return of_property_count_elems_of_size(np, propname, sizeof(u64));
+}
+
+/**
  * of_property_read_bool - Findfrom a property
  * @np:		device node from which the property value is to be read.
  * @propname:	name of the property to be searched.
-- 
1.7.10.4


