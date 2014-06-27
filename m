Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaF0SGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:06:10 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47634 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaF0SEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:04:45 -0400
From: mathieu.poirier@linaro.org
To: linus.walleij@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        daniel.thompson@linaro.org, robherring2@gmail.com
Cc: mathieu.poirier@linaro.org, arve@android.com, john.stultz@linaro.org,
        pratikp@codeaurora.org, varshney@ti.com, Al.Grant@arm.com,
        jonas.svennebring@avagotech.com, james.king@linaro.org,
        panchaxari.prasannamurthy@linaro.org, arnd@linaro.org,
        marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, Tony.Armitstead@arm.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9 v2] coresight-funnel: add CoreSight Funnel driver
Date: Fri, 27 Jun 2014 12:04:17 -0600
Message-Id: <1403892261-25026-6-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org>
References: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratik Patel <pratikp@codeaurora.org>

This driver manages CoreSight Funnel which acts as a link.
Funnels have multiple input ports (typically 8) each of which
represents an input trace data stream. These multiple input trace
data streams are interleaved into a single output stream coming
out of the Funnel.

Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/coresight/Makefile           |   2 +-
 drivers/coresight/coresight-funnel.c | 252 +++++++++++++++++++++++++++++++++++
 2 files changed, 253 insertions(+), 1 deletion(-)
 create mode 100644 drivers/coresight/coresight-funnel.c

diff --git a/drivers/coresight/Makefile b/drivers/coresight/Makefile
index 8d4443b..1f66804 100644
--- a/drivers/coresight/Makefile
+++ b/drivers/coresight/Makefile
@@ -4,4 +4,4 @@
 obj-$(CONFIG_CORESIGHT) += coresight.o
 obj-$(CONFIG_OF) += of_coresight.o
 obj-$(CONFIG_CORESIGHT_LINKS_AND_SINKS) += coresight-tmc.o coresight-tpiu.o \
-					   coresight-etb.o
+					   coresight-etb.o coresight-funnel.o
diff --git a/drivers/coresight/coresight-funnel.c b/drivers/coresight/coresight-funnel.c
new file mode 100644
index 0000000..62c5fec
--- /dev/null
+++ b/drivers/coresight/coresight-funnel.c
@@ -0,0 +1,252 @@
+/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/of_coresight.h>
+#include <linux/coresight.h>
+#include <linux/amba/bus.h>
+
+#include "coresight-priv.h"
+
+#define FUNNEL_FUNCTL		(0x000)
+#define FUNNEL_PRICTL		(0x004)
+
+#define FUNNEL_HOLDTIME_MASK	(0xF00)
+#define FUNNEL_HOLDTIME_SHFT	(0x8)
+#define FUNNEL_HOLDTIME		(0x7 << FUNNEL_HOLDTIME_SHFT)
+
+struct funnel_drvdata {
+	void __iomem		*base;
+	struct device		*dev;
+	struct coresight_device	*csdev;
+	struct clk		*clk;
+	u32			priority;
+};
+
+static void funnel_enable_hw(struct funnel_drvdata *drvdata, int port)
+{
+	u32 functl;
+
+	CS_UNLOCK(drvdata->base);
+
+	functl = cs_readl(drvdata->base, FUNNEL_FUNCTL);
+	functl &= ~FUNNEL_HOLDTIME_MASK;
+	functl |= FUNNEL_HOLDTIME;
+	functl |= (1 << port);
+	cs_writel(drvdata->base, functl, FUNNEL_FUNCTL);
+	cs_writel(drvdata->base, drvdata->priority, FUNNEL_PRICTL);
+
+	CS_LOCK(drvdata->base);
+}
+
+static int funnel_enable(struct coresight_device *csdev, int inport,
+			 int outport)
+{
+	struct funnel_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	int ret;
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		return ret;
+
+	funnel_enable_hw(drvdata, inport);
+
+	dev_info(drvdata->dev, "FUNNEL inport %d enabled\n", inport);
+	return 0;
+}
+
+static void funnel_disable_hw(struct funnel_drvdata *drvdata, int inport)
+{
+	u32 functl;
+
+	CS_UNLOCK(drvdata->base);
+
+	functl = cs_readl(drvdata->base, FUNNEL_FUNCTL);
+	functl &= ~(1 << inport);
+	cs_writel(drvdata->base, functl, FUNNEL_FUNCTL);
+
+	CS_LOCK(drvdata->base);
+}
+
+static void funnel_disable(struct coresight_device *csdev, int inport,
+			   int outport)
+{
+	struct funnel_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+
+	funnel_disable_hw(drvdata, inport);
+
+	clk_disable_unprepare(drvdata->clk);
+
+	dev_info(drvdata->dev, "FUNNEL inport %d disabled\n", inport);
+}
+
+static const struct coresight_ops_link funnel_link_ops = {
+	.enable		= funnel_enable,
+	.disable	= funnel_disable,
+};
+
+static const struct coresight_ops funnel_cs_ops = {
+	.link_ops	= &funnel_link_ops,
+};
+
+static ssize_t debugfs_funnel_priority_get(void *data, u64 *val)
+{
+	struct funnel_drvdata *drvdata = data;
+
+	*val = drvdata->priority;
+	return 0;
+}
+
+static ssize_t debugfs_funnel_priority_set(void *data, u64 val)
+{
+	struct funnel_drvdata *drvdata = data;
+
+	drvdata->priority = val;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_funnel_priority, "priority",
+			S_IRUGO | S_IWUSR, debugfs_funnel_priority_get,
+			debugfs_funnel_priority_set, "%llu\n");
+
+static u32 get_funnel_ctrl_hw(struct funnel_drvdata *drvdata)
+{
+	u32 functl;
+
+	CS_UNLOCK(drvdata->base);
+	functl = cs_readl(drvdata->base, FUNNEL_FUNCTL);
+	CS_LOCK(drvdata->base);
+
+	return functl;
+}
+
+static ssize_t debugfs_funnel_ctrl_get(void *data, u64 *val)
+{
+	struct funnel_drvdata *drvdata = data;
+
+	if (clk_prepare_enable(drvdata->clk))
+		goto out;
+
+	*val = get_funnel_ctrl_hw(drvdata);
+	clk_disable_unprepare(drvdata->clk);
+out:
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_funnel_ctrl, "funnel_ctrl",
+			S_IRUGO, debugfs_funnel_ctrl_get,
+			NULL, "%llu\n");
+
+static const struct coresight_ops_entry *funnel_attr_grps[] = {
+	&debugfs_funnel_priority_entry,
+	&debugfs_funnel_ctrl_entry,
+	NULL,
+};
+
+static int funnel_probe(struct amba_device *adev, const struct amba_id *id)
+{
+	void __iomem *base;
+	struct device *dev = &adev->dev;
+	struct coresight_platform_data *pdata = NULL;
+	struct funnel_drvdata *drvdata;
+	struct resource *res = &adev->res;
+	struct coresight_desc *desc;
+	struct device_node *np = adev->dev.of_node;
+
+	if (np) {
+		pdata = of_get_coresight_platform_data(dev, np);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+		adev->dev.platform_data = pdata;
+	}
+
+	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	drvdata->dev = &adev->dev;
+	dev_set_drvdata(dev, drvdata);
+
+	/* validity for the resource is already checked by the AMBA core */
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	drvdata->base = base;
+
+	drvdata->clk = adev->pclk;
+
+	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	desc->type = CORESIGHT_DEV_TYPE_LINK;
+	desc->subtype.link_subtype = CORESIGHT_DEV_SUBTYPE_LINK_MERG;
+	desc->ops = &funnel_cs_ops;
+	desc->pdata = pdata;
+	desc->dev = dev;
+	desc->debugfs_ops = funnel_attr_grps;
+	desc->owner = THIS_MODULE;
+	drvdata->csdev = coresight_register(desc);
+	if (IS_ERR(drvdata->csdev))
+		return PTR_ERR(drvdata->csdev);
+
+	dev_info(dev, "FUNNEL initialized\n");
+	return 0;
+}
+
+static int funnel_remove(struct amba_device *adev)
+{
+	struct funnel_drvdata *drvdata = amba_get_drvdata(adev);
+
+	coresight_unregister(drvdata->csdev);
+	return 0;
+}
+
+static struct amba_id funnel_ids[] = {
+	{
+		.id     = 0x0003b908,
+		.mask   = 0x0003ffff,
+	},
+	{ 0, 0},
+};
+
+static struct amba_driver funnel_driver = {
+	.drv = {
+		.name	= "coresight-funnel",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= funnel_probe,
+	.remove		= funnel_remove,
+	.id_table	= funnel_ids,
+};
+
+static int __init funnel_init(void)
+{
+	return amba_driver_register(&funnel_driver);
+}
+module_init(funnel_init);
+
+static void __exit funnel_exit(void)
+{
+	amba_driver_unregister(&funnel_driver);
+}
+module_exit(funnel_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CoreSight Funnel driver");
-- 
1.9.1

