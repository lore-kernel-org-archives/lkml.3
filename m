Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3C1GKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:10:25 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:55790 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab3C1GKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:10:24 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com, swarren@wwwdotorg.org,
        arnd@arndb.de, olof@lixom.net, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv3 1/6] of: Add support for reading a u32 from a multi-value property.
Date: Thu, 28 Mar 2013 19:10:44 +1300
Message-Id: <1364451049-2981-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364451049-2981-1-git-send-email-linux@prisktech.co.nz>
References: <1364451049-2981-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an of_property_read_u32_index() function to allow
reading a single indexed u32 value from a property containing multiple
u32 values.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/of/base.c  |   33 +++++++++++++++++++++++++++++++++
 include/linux/of.h |    9 +++++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 321d3ef..7dc001e 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -746,6 +746,39 @@ struct device_node *of_find_node_by_phandle(phandle handle)
 EXPORT_SYMBOL(of_find_node_by_phandle);
 
 /**
+ * of_property_read_u32_index - Find and read a u32 from a multi-value property.
+ *
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ * @index:	index of the u32 in the list of values
+ * @out_value:	pointer to return value, modified only if no error.
+ *
+ * Search for a property in a device node and read nth 32-bit value from
+ * it. Returns 0 on success, -EINVAL if the property does not exist,
+ * -ENODATA if property does not have a value, and -EOVERFLOW if the
+ * property data isn't large enough.
+ *
+ * The out_value is modified only if a valid u32 value can be decoded.
+ */
+int of_property_read_u32_index(const struct device_node *np,
+				       const char *propname,
+				       u32 index, u32 *out_value)
+{
+	struct property *prop = of_find_property(np, propname, NULL);
+
+	if (!prop)
+		return -EINVAL;
+	if (!prop->value)
+		return -ENODATA;
+	if ((index * sizeof(*out_value)) > prop->length)
+		return -EOVERFLOW;
+
+	*out_value = be32_to_cpup(((__be32 *)prop->value) + index);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_property_read_u32_index);
+
+/**
  * of_property_read_u8_array - Find and read an array of u8 from a property.
  *
  * @np:		device node from which the property value is to be read.
diff --git a/include/linux/of.h b/include/linux/of.h
index a0f1292..c0747a4 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -235,6 +235,9 @@ extern struct device_node *of_find_node_with_property(
 extern struct property *of_find_property(const struct device_node *np,
 					 const char *name,
 					 int *lenp);
+extern int of_property_read_u32_index(const struct device_node *np,
+				       const char *propname,
+				       u32 index, u32 *out_value);
 extern int of_property_read_u8_array(const struct device_node *np,
 			const char *propname, u8 *out_values, size_t sz);
 extern int of_property_read_u16_array(const struct device_node *np,
@@ -394,6 +397,12 @@ static inline struct device_node *of_find_compatible_node(
 	return NULL;
 }
 
+static inline int of_property_read_u32_index(const struct device_node *np,
+			const char *propname, u32 index, u32 *out_value)
+{
+	return -ENOSYS;
+}
+
 static inline int of_property_read_u8_array(const struct device_node *np,
 			const char *propname, u8 *out_values, size_t sz)
 {
-- 
1.7.9.5

