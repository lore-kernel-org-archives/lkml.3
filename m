Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab3KOLoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:44:38 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40577 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab3KOLni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:43:38 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-pm@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rjw@rjwysocki.net,
        kgene.kim@samsung.com, tomasz.figa@gmail.com, yadi.brar01@gmail.com,
        sachin.kamat@linaro.org, myungjoo.ham@samsung.com,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [RFC v2 2/4] power: asv: Add a common ASV driver for Exynos SoCs.
Date: Fri, 15 Nov 2013 17:11:29 +0530
Message-Id: <1384515691-26299-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384515691-26299-1-git-send-email-sachin.kamat@linaro.org>
References: <1384515691-26299-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yadwinder Singh Brar <yadi.brar@samsung.com>

This patch adds a common platform driver to register ASV members for
Exynos SoCs.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/power/asv/Kconfig      |   13 ++++++++
 drivers/power/asv/Makefile     |    1 +
 drivers/power/asv/exynos-asv.c |   70 ++++++++++++++++++++++++++++++++++++++++
 drivers/power/asv/exynos-asv.h |   21 ++++++++++++
 4 files changed, 105 insertions(+)
 create mode 100644 drivers/power/asv/exynos-asv.c
 create mode 100644 drivers/power/asv/exynos-asv.h

diff --git a/drivers/power/asv/Kconfig b/drivers/power/asv/Kconfig
index 761119d9f7f8..a57980a33148 100644
--- a/drivers/power/asv/Kconfig
+++ b/drivers/power/asv/Kconfig
@@ -8,3 +8,16 @@ menuconfig POWER_ASV
 	  chip id info which depends on the chip manufacturing process.
 
 	  Say Y here to enable Adaptive Supply Voltage support.
+
+if POWER_ASV
+
+config POWER_EXYNOS_ASV
+	bool "Adaptive Supply Voltage for Exynos"
+	help
+	  Exynos supports ASV depending upon the ASV group fused on chip.
+	  Users can request ASV specific to a frequency for a particular member
+	  from corresponding DVFS driver.
+
+	  Say Y here to enable Exynos Adaptive Supply Voltage.
+
+endif
diff --git a/drivers/power/asv/Makefile b/drivers/power/asv/Makefile
index 366cb04f557b..9d0e0cc32cb5 100644
--- a/drivers/power/asv/Makefile
+++ b/drivers/power/asv/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_POWER_ASV)			+= asv.o
+obj-$(CONFIG_POWER_EXYNOS_ASV)		+= exynos-asv.o
diff --git a/drivers/power/asv/exynos-asv.c b/drivers/power/asv/exynos-asv.c
new file mode 100644
index 000000000000..50efb0b6af85
--- /dev/null
+++ b/drivers/power/asv/exynos-asv.c
@@ -0,0 +1,70 @@
+/* Common Exynos ASV(Adaptive Supply Voltage) driver
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/of_address.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/power/asv-driver.h>
+#include "exynos-asv.h"
+
+static int exynos_asv_probe(struct platform_device *pdev)
+{
+	struct device_node *chip_id;
+	struct exynos_asv_common *exynos_asv_info;
+	void __iomem *base;
+	int ret = 0;
+
+	exynos_asv_info = devm_kzalloc(&pdev->dev, sizeof(*exynos_asv_info),
+				       GFP_KERNEL);
+	if (!exynos_asv_info)
+		return -ENOMEM;
+
+	chip_id = of_find_compatible_node(NULL, NULL,
+						"samsung,exynos4210-chipid");
+	if (!chip_id) {
+		pr_err("%s: unable to find chipid\n", __func__);
+		return -ENODEV;
+	}
+
+	base = of_iomap(chip_id, 0);
+	if (!base) {
+		dev_err(&pdev->dev, "unable to map chip_id register\n");
+		ret = -ENOMEM;
+		goto err_map;
+	}
+
+	exynos_asv_info->base = base;
+
+	/* call SoC specific intialisation routine */
+
+	register_asv_member(exynos_asv_info->asv_list, exynos_asv_info->nr_mem);
+
+	iounmap(base);
+err_map:
+	of_node_put(chip_id);
+
+	return ret;
+}
+
+static struct platform_driver exynos_asv_platdrv = {
+	.driver = {
+		.name	= "exynos-asv",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= exynos_asv_probe,
+};
+module_platform_driver(exynos_asv_platdrv);
+
+MODULE_AUTHOR("Yadwinder Singh Brar<yadi.brar@samsung.com>");
+MODULE_DESCRIPTION("Exynos ASV driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/power/asv/exynos-asv.h b/drivers/power/asv/exynos-asv.h
new file mode 100644
index 000000000000..89a1ae8b5e19
--- /dev/null
+++ b/drivers/power/asv/exynos-asv.h
@@ -0,0 +1,21 @@
+/*
+ * Exynos - Adaptive Supply Voltage Driver Header File
+ *
+ * copyright (c) 2013 samsung electronics co., ltd.
+ *		http://www.samsung.com/
+ *
+ * this program is free software; you can redistribute it and/or modify
+ * it under the terms of the gnu general public license version 2 as
+ * published by the free software foundation.
+*/
+
+#ifndef __EXYNOS_ASV_D_H
+#define __EXYNOS_ASV_D_H __FILE__
+
+struct exynos_asv_common {
+	struct asv_info *asv_list;
+	unsigned int nr_mem;
+	void __iomem *base;
+};
+
+#endif	/* __EXYNOS_ASV_D_H */
-- 
1.7.9.5

