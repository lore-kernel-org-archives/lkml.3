Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab3DCG02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:26:28 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:54133 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762358Ab3DCGYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:24:53 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: linus.walleij@linaro.org
Cc: robherring2@gmail.com, swarren@wwwdotorg.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv5 2/7] of: Remove duplicated code for validating property and value
Date: Wed,  3 Apr 2013 19:24:46 +1300
Message-Id: <1364970291-17721-3-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364970291-17721-1-git-send-email-linux@prisktech.co.nz>
References: <1364970291-17721-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several functions in of/base.c have the same code duplicated for
finding and validating a property and value.

struct property *prop = of_find_property(np, propname, NULL);
if (!prop)
	return -EINVAL;
if (!prop->value)
	return -ENODATA;
if (<some length> > prop->length)
	return -EOVERFLOW;

This patch adds of_find_property_value_of_size() which performs the
equivalent of the above code and removes the instances where it was
duplicated in several functions.

Reported-by: Rob Herring <robherring2@gmail.com>
Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/of/base.c |   94 +++++++++++++++++++++++++++++------------------------
 1 file changed, 51 insertions(+), 43 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index f6c89ed..c6443de 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -746,6 +746,34 @@ struct device_node *of_find_node_by_phandle(phandle handle)
 EXPORT_SYMBOL(of_find_node_by_phandle);
 
 /**
+ * of_find_property_value_of_size
+ *
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ * @len:	requested length of property value
+ *
+ * Search for a property in a device node and valid the requested size.
+ * Returns the property value on success, -EINVAL if the property does not
+ *  exist, -ENODATA if property does not have a value, and -EOVERFLOW if the
+ * property data isn't large enough.
+ *
+ */
+static void *of_find_property_value_of_size(const struct device_node *np,
+			const char *propname, u32 len)
+{
+	struct property *prop = of_find_property(np, propname, NULL);
+
+	if (!prop)
+		return ERR_PTR(-EINVAL);
+	if (!prop->value)
+		return ERR_PTR(-ENODATA);
+	if (len > prop->length)
+		return ERR_PTR(-EOVERFLOW);
+
+	return prop->value;
+}
+
+/**
  * of_property_read_u32_index - Find and read a u32 from a multi-value property.
  *
  * @np:		device node from which the property value is to be read.
@@ -764,16 +792,13 @@ int of_property_read_u32_index(const struct device_node *np,
 				       const char *propname,
 				       u32 index, u32 *out_value)
 {
-	struct property *prop = of_find_property(np, propname, NULL);
+	const u32 *val = of_find_property_value_of_size(np, propname,
+					((index + 1) * sizeof(*out_value)));
 
-	if (!prop)
-		return -EINVAL;
-	if (!prop->value)
-		return -ENODATA;
-	if (((index + 1) * sizeof(*out_value)) > prop->length)
-		return -EOVERFLOW;
+	if (IS_ERR(val))
+		return PTR_ERR(val);
 
-	*out_value = be32_to_cpup(((__be32 *)prop->value) + index);
+	*out_value = be32_to_cpup(((__be32 *)val) + index);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(of_property_read_u32_index);
@@ -799,17 +824,12 @@ EXPORT_SYMBOL_GPL(of_property_read_u32_index);
 int of_property_read_u8_array(const struct device_node *np,
 			const char *propname, u8 *out_values, size_t sz)
 {
-	struct property *prop = of_find_property(np, propname, NULL);
-	const u8 *val;
+	const u8 *val = of_find_property_value_of_size(np, propname,
+						(sz * sizeof(*out_values)));
 
-	if (!prop)
-		return -EINVAL;
-	if (!prop->value)
-		return -ENODATA;
-	if ((sz * sizeof(*out_values)) > prop->length)
-		return -EOVERFLOW;
+	if (IS_ERR(val))
+		return PTR_ERR(val);
 
-	val = prop->value;
 	while (sz--)
 		*out_values++ = *val++;
 	return 0;
@@ -837,17 +857,12 @@ EXPORT_SYMBOL_GPL(of_property_read_u8_array);
 int of_property_read_u16_array(const struct device_node *np,
 			const char *propname, u16 *out_values, size_t sz)
 {
-	struct property *prop = of_find_property(np, propname, NULL);
-	const __be16 *val;
+	const __be16 *val = of_find_property_value_of_size(np, propname,
+						(sz * sizeof(*out_values)));
 
-	if (!prop)
-		return -EINVAL;
-	if (!prop->value)
-		return -ENODATA;
-	if ((sz * sizeof(*out_values)) > prop->length)
-		return -EOVERFLOW;
+	if (IS_ERR(val))
+		return PTR_ERR(val);
 
-	val = prop->value;
 	while (sz--)
 		*out_values++ = be16_to_cpup(val++);
 	return 0;
@@ -874,17 +889,12 @@ int of_property_read_u32_array(const struct device_node *np,
 			       const char *propname, u32 *out_values,
 			       size_t sz)
 {
-	struct property *prop = of_find_property(np, propname, NULL);
-	const __be32 *val;
+	const __be32 *val = of_find_property_value_of_size(np, propname,
+						(sz * sizeof(*out_values)));
 
-	if (!prop)
-		return -EINVAL;
-	if (!prop->value)
-		return -ENODATA;
-	if ((sz * sizeof(*out_values)) > prop->length)
-		return -EOVERFLOW;
+	if (IS_ERR(val))
+		return PTR_ERR(val);
 
-	val = prop->value;
 	while (sz--)
 		*out_values++ = be32_to_cpup(val++);
 	return 0;
@@ -907,15 +917,13 @@ EXPORT_SYMBOL_GPL(of_property_read_u32_array);
 int of_property_read_u64(const struct device_node *np, const char *propname,
 			 u64 *out_value)
 {
-	struct property *prop = of_find_property(np, propname, NULL);
+	const __be32 *val = of_find_property_value_of_size(np, propname,
+						sizeof(*out_value));
 
-	if (!prop)
-		return -EINVAL;
-	if (!prop->value)
-		return -ENODATA;
-	if (sizeof(*out_value) > prop->length)
-		return -EOVERFLOW;
-	*out_value = of_read_number(prop->value, 2);
+	if (IS_ERR(val))
+		return PTR_ERR(val);
+
+	*out_value = of_read_number(val, 2);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(of_property_read_u64);
-- 
1.7.9.5

