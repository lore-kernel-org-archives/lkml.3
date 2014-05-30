Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283AbaE3Nn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:43:58 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35529 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933224AbaE3Nnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:43:55 -0400
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
Subject: [RFC PATCH 06/11] coresight: add CoreSight Replicator driver
Date: Fri, 30 May 2014 07:43:06 -0600
Message-Id: <1401457391-12242-7-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratik Patel <pratikp@codeaurora.org>

This driver manages CoreSight Replicator that takes single input
trace data stream and replicates it to produce two identical
trace data output streams. Replicators are typically used to
route single interleaved trace data stream to two or more sinks.

Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/coresight/Makefile               |   2 +-
 drivers/coresight/coresight-replicator.c | 130 +++++++++++++++++++++++++++++++
 2 files changed, 131 insertions(+), 1 deletion(-)
 create mode 100644 drivers/coresight/coresight-replicator.c

diff --git a/drivers/coresight/Makefile b/drivers/coresight/Makefile
index 1f66804..25296a2 100644
--- a/drivers/coresight/Makefile
+++ b/drivers/coresight/Makefile
@@ -4,4 +4,4 @@
 obj-$(CONFIG_CORESIGHT) += coresight.o
 obj-$(CONFIG_OF) += of_coresight.o
 obj-$(CONFIG_CORESIGHT_LINKS_AND_SINKS) += coresight-tmc.o coresight-tpiu.o \
-					   coresight-etb.o coresight-funnel.o
+					   coresight-etb.o coresight-funnel.o \
diff --git a/drivers/coresight/coresight-replicator.c b/drivers/coresight/coresight-replicator.c
new file mode 100644
index 0000000..1cbb288
--- /dev/null
+++ b/drivers/coresight/coresight-replicator.c
@@ -0,0 +1,130 @@
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
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/of_coresight.h>
+#include <linux/coresight.h>
+
+#include "coresight-priv.h"
+
+struct replicator_drvdata {
+	struct device		*dev;
+	struct coresight_device	*csdev;
+};
+
+static int replicator_enable(struct coresight_device *csdev, int inport,
+			     int outport)
+{
+	struct replicator_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	dev_info(drvdata->dev, "REPLICATOR enabled\n");
+
+	return 0;
+}
+
+static void replicator_disable(struct coresight_device *csdev, int inport,
+			       int outport)
+{
+	struct replicator_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	dev_info(drvdata->dev, "REPLICATOR disabled\n");
+}
+
+static const struct coresight_ops_link replicator_link_ops = {
+	.enable		= replicator_enable,
+	.disable	= replicator_disable,
+};
+
+static const struct coresight_ops replicator_cs_ops = {
+	.link_ops	= &replicator_link_ops,
+};
+
+static int replicator_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct coresight_platform_data *pdata;
+	struct replicator_drvdata *drvdata;
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
+	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+	desc->type = CORESIGHT_DEV_TYPE_LINK;
+	desc->subtype.sink_subtype = CORESIGHT_DEV_SUBTYPE_LINK_SPLIT;
+	desc->ops = &replicator_cs_ops;
+	desc->pdata = pdev->dev.platform_data;
+	desc->dev = &pdev->dev;
+	desc->owner = THIS_MODULE;
+	drvdata->csdev = coresight_register(desc);
+	if (IS_ERR(drvdata->csdev))
+		return PTR_ERR(drvdata->csdev);
+
+	dev_info(dev, "REPLICATOR initialized\n");
+	return 0;
+}
+
+static int replicator_remove(struct platform_device *pdev)
+{
+	struct replicator_drvdata *drvdata = platform_get_drvdata(pdev);
+
+	coresight_unregister(drvdata->csdev);
+	return 0;
+}
+
+static struct of_device_id replicator_match[] = {
+	{.compatible = "arm,coresight-replicator"},
+	{}
+};
+
+static struct platform_driver replicator_driver = {
+	.probe          = replicator_probe,
+	.remove         = replicator_remove,
+	.driver         = {
+		.name   = "coresight-replicator",
+		.owner	= THIS_MODULE,
+		.of_match_table = replicator_match,
+	},
+};
+
+static int __init replicator_init(void)
+{
+	return platform_driver_register(&replicator_driver);
+}
+module_init(replicator_init);
+
+static void __exit replicator_exit(void)
+{
+	platform_driver_unregister(&replicator_driver);
+}
+module_exit(replicator_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CoreSight Replicator driver");
-- 
1.9.1

