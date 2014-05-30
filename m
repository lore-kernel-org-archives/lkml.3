Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbaE3NqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:46:12 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:63585 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235AbaE3Nnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:43:53 -0400
From: mathieu.poirier@linaro.org
To: linus.walleij@linaro.org, will.deacon@arm.com
Cc: mathieu.poirier@linaro.org, arve@android.com, john.stultz@linaro.org,
        pratikp@codeaurora.org, varshney@ti.com, Al.Grant@arm.com,
        jonas.svennebring@avagotech.com, james.king@linaro.org,
        panchaxari.prasannamurthy@linaro.org, arnd@linaro.org,
        marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, patches@linaro.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        daniel.thompson@linaro.org
Subject: [RFC PATCH 05/11] coresight: add CoreSight Funnel driver
Date: Fri, 30 May 2014 07:43:05 -0600
Message-Id: <1401457391-12242-6-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
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
 drivers/coresight/coresight-funnel.c | 310 +++++++++++++++++++++++++++++++++++
 2 files changed, 311 insertions(+), 1 deletion(-)
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
index 0000000..c1024df
--- /dev/null
+++ b/drivers/coresight/coresight-funnel.c
@@ -0,0 +1,310 @@
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
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/of_coresight.h>
+#include <linux/coresight.h>
+
+#include "coresight-priv.h"
+
+#define funnel_writel(drvdata, val, off)	\
+			__raw_writel((val), drvdata->base + off)
+#define funnel_readl(drvdata, off)		\
+			__raw_readl(drvdata->base + off)
+
+#define FUNNEL_LOCK(drvdata)						\
+do {									\
+	/* wait for things to settle */					\
+	mb();								\
+	funnel_writel(drvdata, 0x0, CORESIGHT_LAR);			\
+} while (0)
+#define FUNNEL_UNLOCK(drvdata)						\
+do {									\
+	funnel_writel(drvdata, CORESIGHT_UNLOCK, CORESIGHT_LAR);	\
+	/* make sure everyone has seen this */				\
+	mb();								\
+} while (0)
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
+	uint32_t		priority;
+};
+
+static void __funnel_enable(struct funnel_drvdata *drvdata, int port)
+{
+	uint32_t functl;
+
+	FUNNEL_UNLOCK(drvdata);
+
+	functl = funnel_readl(drvdata, FUNNEL_FUNCTL);
+	functl &= ~FUNNEL_HOLDTIME_MASK;
+	functl |= FUNNEL_HOLDTIME;
+	functl |= (1 << port);
+	funnel_writel(drvdata, functl, FUNNEL_FUNCTL);
+	funnel_writel(drvdata, drvdata->priority, FUNNEL_PRICTL);
+
+	FUNNEL_LOCK(drvdata);
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
+	__funnel_enable(drvdata, inport);
+
+	dev_info(drvdata->dev, "FUNNEL inport %d enabled\n", inport);
+	return 0;
+}
+
+static void __funnel_disable(struct funnel_drvdata *drvdata, int inport)
+{
+	uint32_t functl;
+
+	FUNNEL_UNLOCK(drvdata);
+
+	functl = funnel_readl(drvdata, FUNNEL_FUNCTL);
+	functl &= ~(1 << inport);
+	funnel_writel(drvdata, functl, FUNNEL_FUNCTL);
+
+	FUNNEL_LOCK(drvdata);
+}
+
+static void funnel_disable(struct coresight_device *csdev, int inport,
+			   int outport)
+{
+	struct funnel_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+
+	__funnel_disable(drvdata, inport);
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
+static ssize_t debugfs_show_funnel_priority(struct file *file,
+					    char __user *user_buf,
+					    size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	struct funnel_drvdata *drvdata = file->private_data;
+
+	val = drvdata->priority;
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+	kfree(buf);
+	return ret;
+}
+
+static ssize_t debugfs_store_funnel_priority(struct file *file,
+					     const char __user *user_buf,
+					     size_t count, loff_t *ppos)
+{
+	unsigned long val;
+	struct funnel_drvdata *drvdata = file->private_data;
+
+	if (sscanf(user_buf, "%lx", &val) != 1)
+		return -EINVAL;
+
+	drvdata->priority = val;
+	return count;
+}
+
+static const struct file_operations debugfs_funnel_priority_ops = {
+	.open = simple_open,
+	.read = debugfs_show_funnel_priority,
+	.write = debugfs_store_funnel_priority,
+};
+
+static const struct coresight_ops_entry debugfs_funnel_priority_entry = {
+	.name = "priority",
+	.mode =  S_IRUGO | S_IWUSR,
+	.ops = &debugfs_funnel_priority_ops,
+};
+
+static uint32_t __get_funnel_ctrl(struct funnel_drvdata *drvdata)
+{
+	uint32_t functl;
+
+	FUNNEL_UNLOCK(drvdata);
+	functl = funnel_readl(drvdata, FUNNEL_FUNCTL);
+	FUNNEL_LOCK(drvdata);
+
+	return functl;
+}
+
+static ssize_t debugfs_show_funnel_ctrl(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	int ret;
+	unsigned long val;
+	struct funnel_drvdata *drvdata = file->private_data;
+	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+
+	ret = clk_prepare_enable(drvdata->clk);
+	if (ret)
+		goto out;
+
+	val = __get_funnel_ctrl(drvdata);
+
+	clk_disable_unprepare(drvdata->clk);
+
+	ret = scnprintf(buf, PAGE_SIZE, "%#lx\n", val);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+
+out:
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations debugfs_funnel_ctrl_ops = {
+	.open = simple_open,
+	.read = debugfs_show_funnel_ctrl,
+};
+
+static const struct coresight_ops_entry debugfs_funnel_ctrl_entry = {
+	.name = "funnel_ctrl",
+	.mode =  S_IRUGO,
+	.ops = &debugfs_funnel_ctrl_ops,
+};
+
+static const struct coresight_ops_entry *funnel_attr_grps[] = {
+	&debugfs_funnel_priority_entry,
+	&debugfs_funnel_ctrl_entry,
+	NULL,
+};
+
+static int funnel_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct coresight_platform_data *pdata = NULL;
+	struct funnel_drvdata *drvdata;
+	struct resource *res;
+	struct coresight_desc *desc;
+
+	if (pdev->dev.of_node) {
+		pdata = of_get_coresight_platform_data(dev, pdev->dev.of_node);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+		pdev->dev.platform_data = pdata;
+	}
+
+	drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+	drvdata->dev = &pdev->dev;
+	platform_set_drvdata(pdev, drvdata);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	drvdata->base = devm_ioremap(dev, res->start, resource_size(res));
+	if (!drvdata->base)
+		return -ENOMEM;
+
+	if (pdata && pdata->clk)
+		drvdata->clk = pdata->clk;
+
+	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+	desc->type = CORESIGHT_DEV_TYPE_LINK;
+	desc->subtype.link_subtype = CORESIGHT_DEV_SUBTYPE_LINK_MERG;
+	desc->ops = &funnel_cs_ops;
+	desc->pdata = pdev->dev.platform_data;
+	desc->dev = &pdev->dev;
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
+static int funnel_remove(struct platform_device *pdev)
+{
+	struct funnel_drvdata *drvdata = platform_get_drvdata(pdev);
+
+	coresight_unregister(drvdata->csdev);
+	return 0;
+}
+
+static struct of_device_id funnel_match[] = {
+	{.compatible = "arm,coresight-funnel"},
+	{}
+};
+
+static struct platform_driver funnel_driver = {
+	.probe          = funnel_probe,
+	.remove         = funnel_remove,
+	.driver         = {
+		.name   = "coresight-funnel",
+		.owner	= THIS_MODULE,
+		.of_match_table = funnel_match,
+	},
+};
+
+static int __init funnel_init(void)
+{
+	return platform_driver_register(&funnel_driver);
+}
+module_init(funnel_init);
+
+static void __exit funnel_exit(void)
+{
+	platform_driver_unregister(&funnel_driver);
+}
+module_exit(funnel_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CoreSight Funnel driver");
-- 
1.9.1

