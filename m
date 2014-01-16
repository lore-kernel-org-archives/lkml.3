Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaAPSFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:05:24 -0500
Received: from gloria.sntech.de ([95.129.55.99]:49282 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbaAPSFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:05:20 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: [PATCH] of: add function to count number of u32 elements in a property
Date: Thu, 16 Jan 2014 19:04:42 +0100
Message-ID: <3781679.27UF2dWtKL@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140116124527.GD19578@e106331-lin.cambridge.arm.com>
References: <27256277.YJ687suYy5@phil> <1669323.jqjZBfkRx4@phil> <20140116124527.GD19578@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The need to know the number of array elements in a property is
a common pattern. To prevent duplication of open-coded implementations
add a helper function that also centralises strict sanity checking
and DTB format details.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
Hi Mark,
did you mean it like this? I've tested it with the sram-reserve change and
it made the part of the determining the number elements a lot nicer :-)

 drivers/of/base.c  |   32 ++++++++++++++++++++++++++++++++
 include/linux/of.h |    8 ++++++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index f807d0e..0f40ea5 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -920,6 +920,38 @@ int of_property_read_u32_index(const struct device_node *np,
 EXPORT_SYMBOL_GPL(of_property_read_u32_index);
 
 /**
+ * of_property_count_u32_elems - Count the number of u32 values in a property
+ *
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ *
+ * Search for a property in a device node and count the number of u32 elements
+ * in it. Returns number of elements on sucess, -EINVAL if the property does
+ * not exist or its length does not match a multiple of u32 and -ENODATA if the
+ * property does not have a value.
+ */
+int of_property_count_u32_elems(const struct device_node *np,
+				const char *propname)
+{
+	int elem_size = sizeof(u32);
+	int len;
+	struct property *prop = of_find_property(np, propname, &len);
+
+	if (!prop)
+		return -EINVAL;
+	if (!prop->value)
+		return -ENODATA;
+
+	if (prop->length % elem_size != 0) {
+		pr_err("size of %s is not a multiple of u32\n", propname);
+		return -EINVAL;
+	}
+
+	return len / elem_size;
+}
+EXPORT_SYMBOL_GPL(of_property_count_u32_elems);
+
+/**
  * of_property_read_u8_array - Find and read an array of u8 from a property.
  *
  * @np:		device node from which the property value is to be read.
diff --git a/include/linux/of.h b/include/linux/of.h
index 276c546..5794942 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -253,6 +253,8 @@ extern struct property *of_find_property(const struct device_node *np,
 extern int of_property_read_u32_index(const struct device_node *np,
 				       const char *propname,
 				       u32 index, u32 *out_value);
+extern int of_property_count_u32_elems(const struct device_node *np,
+				       const char *propname);
 extern int of_property_read_u8_array(const struct device_node *np,
 			const char *propname, u8 *out_values, size_t sz);
 extern int of_property_read_u16_array(const struct device_node *np,
@@ -432,6 +434,12 @@ static inline int of_property_read_u32_index(const struct device_node *np,
 	return -ENOSYS;
 }
 
+static inline int of_property_count_u32_elems(const struct device_node *np,
+			const char *propname)
+{
+	return -ENOSYS;
+}
+
 static inline int of_property_read_u8_array(const struct device_node *np,
 			const char *propname, u8 *out_values, size_t sz)
 {
-- 
1.7.10.4


