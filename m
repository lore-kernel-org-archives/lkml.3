Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161419AbaJ3XA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:00:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40190 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422669AbaJ3XAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:00:24 -0400
From: Gilad Avidov <gavidov@codeaurora.org>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        sdharia@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Gilad Avidov <gavidov@codeaurora.org>
Subject: [PATCH 1/1] of_propery_map: compact interface for Device-Tree
Date: Thu, 30 Oct 2014 16:59:24 -0600
Message-Id: <1414709964-27284-2-git-send-email-gavidov@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414709964-27284-1-git-send-email-gavidov@codeaurora.org>
References: <1414709964-27284-1-git-send-email-gavidov@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compact API for populating variables with values
from Device-Tree properties.

Change-Id: Ib0f17d32941605b0c431a1815cfcf5e8b76fb07c
Signed-off-by: Gilad Avidov <gavidov@codeaurora.org>
---
 Documentation/devicetree/of_property_map.txt |   76 ++++++++++++++++++++++
 drivers/of/Makefile                          |    2 +-
 drivers/of/of_property_map.c                 |   88 ++++++++++++++++++++++++++
 include/linux/of_property_map.h              |   74 ++++++++++++++++++++++
 4 files changed, 239 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/of_property_map.txt
 create mode 100644 drivers/of/of_property_map.c
 create mode 100644 include/linux/of_property_map.h

diff --git a/Documentation/devicetree/of_property_map.txt b/Documentation/devicetree/of_property_map.txt
new file mode 100644
index 0000000..307bf57
--- /dev/null
+++ b/Documentation/devicetree/of_property_map.txt
@@ -0,0 +1,76 @@
+* of_property_map:
+
+of_property_map is a compact API for reading Device-Tree nodes.
+The following snippet demonstrates reading the aliased-ID and four other
+properties of the Device-Tree node defined at the bottom.
+
+Example:
+
+struct of_prop_map map[] = {
+	{"i2c",			&dev->id,		OF_REQ,  OF_ID,  -1},
+	{"qcom,clk-freq-out",	&dev->clk_freq_out,	OF_REQ,  OF_U32,  0},
+	{"qcom,clk-freq-in",	&dev->clk_freq_in,	OF_REQ,  OF_U32,  0},
+	{"qcom,disable-dma",	&dev->disable_dma,	OF_OPT,  OF_BOOL, 0},
+	{"qcom,master-id",	&dev->mstr_id,		OF_SGST, OF_U32,  0},
+	{NULL,			NULL,			0,       0,       0},
+};
+
+ret = of_prop_populate(dev, dev->of_node, map);
+
+
+An equivalent code snippet using the traditional of_property_read_XXXX() API.
+Note that the equivalent is longer and more difficult to follow and debug.
+
+Example:
+
+/* optional property */
+dev->disable_dma = of_property_read_bool(node, "qcom,disable-dma");
+
+ret = of_property_read_u32(dev->node, "qcom,clk-freq-out", &dev->clk_freq_out);
+if (ret) {
+	dev_err(dev, "error: missing 'qcom,clk-freq-out' DT property\n");
+	if (!err)
+		err = ret;
+}
+
+ret = of_property_read_u32(dev->node, "qcom,clk-freq-in", &dev->clk_freq_in);
+if (ret) {
+	dev_err(dev, "error: missing 'qcom,clk-freq-in' DT property\n");
+	if (!err)
+		err = ret;
+}
+
+/* suggested property */
+ret = of_property_read_u32(dev->node, "qcom,master-id", &dev->mstr_id);
+if (ret && !err)
+	err = ret;
+
+
+ret = of_alias_get_id(dev->node, "i2c");
+if (ret < 0) {
+	dev_err(dev, "error: missing '"i2c"' DT property\n");
+	if (!err)
+		err = ret;
+} else {
+	dev->id = ret;
+}
+
+
+The Device-Tree node and alias which are read by the above code snippets.
+
+Example:
+
+	aliases {
+		i2c0 = &i2c_0; /* I2C0 controller device */
+	};
+
+	i2c_0: i2c@78b6000 { /* BLSP1 QUP2 */
+		compatible = "qcom,i2c-msm-v2";
+		reg-names = "qup_phys_addr", "bam_phys_addr";
+		reg = <0x78b6000 0x600>,
+		      <0x7884000 0x23000>;
+		qcom,clk-freq-out = <100000>;
+		qcom,clk-freq-in  = <19200000>;
+		qcom,disable-dma;
+		qcom,master-id = <86>;
+	};
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index ca9209c..c60eeb0 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -1,4 +1,4 @@
-obj-y = base.o device.o platform.o
+obj-y = base.o device.o platform.o of_property_map.o
 obj-$(CONFIG_OF_DYNAMIC) += dynamic.o
 obj-$(CONFIG_OF_FLATTREE) += fdt.o
 obj-$(CONFIG_OF_EARLY_FLATTREE) += fdt_address.o
diff --git a/drivers/of/of_property_map.c b/drivers/of/of_property_map.c
new file mode 100644
index 0000000..8145f1c
--- /dev/null
+++ b/drivers/of/of_property_map.c
@@ -0,0 +1,88 @@
+/* Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/of.h>
+#include <linux/device.h>
+#include <linux/of_property_map.h>
+
+int of_prop_populate(struct device *dev, struct device_node *np,
+						struct of_prop_map *itr)
+{
+	int  ret, err = 0;
+
+	for (; itr->propname; ++itr) {
+		switch (itr->type) {
+		case OF_BOOL:
+			*((bool *) itr->var_ptr) =
+				of_property_read_bool(np, itr->propname);
+			ret = 0;
+			break;
+		case OF_U8:
+			ret = of_property_read_u8(np, itr->propname,
+							(u8 *) itr->var_ptr);
+			break;
+		case OF_U16:
+			ret = of_property_read_u16(np, itr->propname,
+							(u16 *) itr->var_ptr);
+			break;
+		case OF_U32:
+			ret = of_property_read_u32(np, itr->propname,
+							(u32 *) itr->var_ptr);
+			break;
+		case OF_U64:
+			ret = of_property_read_u64(np, itr->propname,
+							(u64 *) itr->var_ptr);
+			break;
+		case OF_STR:
+			ret = of_property_read_string(np, itr->propname,
+								itr->var_ptr);
+			break;
+		case OF_ID:
+			ret = of_alias_get_id(np, itr->propname);
+			if (ret >= 0) {
+				*((int *) itr->var_ptr) = ret;
+				ret = 0;
+			}
+			break;
+		default:
+			dev_err(dev, "error: %d is unknown DT property type\n",
+								itr->type);
+			ret = -EINVAL;
+		}
+
+		dev_dbg(dev, "of_property: name:%s val:%d ret:%d\n",
+				itr->propname, *((int *)itr->var_ptr), ret);
+
+		if (ret) {
+			/* on error set value to default */
+			*((long long int *)itr->var_ptr) = itr->default_val;
+
+			if (itr->criticality < OF_OPT) {
+				dev_err(dev,
+					"error: missing '%s' DT property\n",
+					itr->propname);
+
+				/*
+				 * Do not stop on errors. Keep running to
+				 * dump messages for all missing properties.
+				 * On error return the first one found.
+				 */
+				if (itr->criticality == OF_REQ && !err)
+					err = ret;
+			}
+		}
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(of_prop_populate);
diff --git a/include/linux/of_property_map.h b/include/linux/of_property_map.h
new file mode 100644
index 0000000..0c61673
--- /dev/null
+++ b/include/linux/of_property_map.h
@@ -0,0 +1,74 @@
+/* Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+/*
+ * Higher level and compact interface for reading Device-Tree nodes. Uses
+ * a direct visual mapping table of the node's property name to the
+ * driver's/module's fields.
+ *
+ * Usage exapmle:
+ * struct of_prop_map map[] = {
+ *	{"i2c",			&dev->id,		OF_REQ,  OF_ID,  -1},
+ *	{"qcom,clk-freq-out",	&dev->clk_freq_out,	OF_REQ,  OF_U32,  0},
+ *	{"qcom,clk-freq-in",	&dev->clk_freq_in,	OF_REQ,  OF_U32,  0},
+ *	{"qcom,bam-disable",	&dev->disable_dma,	OF_OPT,  OF_BOOL, 0},
+ *	{"qcom,master-id",	&dev->mstr_id,		OF_SGST, OF_U32,  0},
+ *	{NULL,			NULL,			0,       0,       0},
+ * };
+ *
+ * ret = of_prop_populate(dev, dev->of_node, map);
+ */
+
+#ifndef _OF_PROPERTY_MAP_H
+#define _OF_PROPERTY_MAP_H
+
+enum of_prop_criticality {
+	OF_REQ,		/* Required : fail if missing       */
+	OF_SGST,	/* Suggested: warn if missing       */
+	OF_OPT,		/* Optional : don't warn if missing */
+};
+
+enum of_prop_type {
+	OF_BOOL,	/* of_property_read_bool()	*/
+	OF_U8,		/* of_property_read_u8()	*/
+	OF_U16,		/* of_property_read_u16()	*/
+	OF_U32,		/* of_property_read_u32()	*/
+	OF_U64,		/* of_property_read_u64()	*/
+	OF_STR,		/* of_property_read_string()	*/
+	OF_ID,		/* of_alias_get_id()		*/
+};
+
+/*
+ * of_prop_map: mapping Device-Tree property name to the dev's variable
+ *
+ * @propname property name in Device-Tree
+ * @var_ptr pointer to the device's variable to store the value in.
+ * @default_val if propname is not found then *var_ptr = default_val
+ */
+struct of_prop_map {
+	const char		*propname;
+	void			*var_ptr;
+	enum of_prop_criticality criticality;
+	enum of_prop_type	 type;
+	long long int		 default_val;
+};
+
+/*
+ * of_prop_populate: read Device-Tree properites and populate the mapped fields
+ *
+ * @node the Device-Tree node corresponding to dev
+ * @itr pointer to a NULL terminated property mapping
+ */
+int of_prop_populate(struct device *dev, struct device_node *node,
+						struct of_prop_map *itr);
+
+#endif /*_OF_PROPERTY_MAP_H*/
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

