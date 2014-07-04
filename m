Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030476AbaGDJ5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:57:46 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38182 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030290AbaGDJ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:56:37 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v6 20/23] clk: Add driver for Maxim 77802 PMIC clocks
Date: Fri,  4 Jul 2014 11:55:19 +0200
Message-Id: <1404467722-26687-21-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX77802 PMIC has two 32.768kHz Buffered Clock Outputs with
Low Jitter Mode. This patch adds support for these two clocks.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---

Changes since v5: None

Changes since v4: None

Changes since v3: None

Changes since v2: None

Changes since v1:
 - Use module_platform_driver() instead of having init/exit functions.
   Suggested by Mark Brown.
 - Use the generic maxim clock driver to reduce code duplication with
   clk-max77686.c driver.
---
 drivers/clk/Kconfig                        |  7 +++
 drivers/clk/Makefile                       |  1 +
 drivers/clk/clk-max77802.c                 | 98 ++++++++++++++++++++++++++++++
 include/dt-bindings/clock/maxim,max77802.h | 22 +++++++
 4 files changed, 128 insertions(+)
 create mode 100644 drivers/clk/clk-max77802.c
 create mode 100644 include/dt-bindings/clock/maxim,max77802.h

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 3fd4270..8808f2a 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -42,6 +42,13 @@ config COMMON_CLK_MAX77686
 	---help---
 	  This driver supports Maxim 77686 crystal oscillator clock. 
 
+config COMMON_CLK_MAX77802
+	tristate "Clock driver for Maxim 77802 PMIC"
+	depends on MFD_MAX77686
+	select COMMON_CLK_MAX_GEN
+	---help---
+	  This driver supports Maxim 77802 crystal oscillator clock.
+
 config COMMON_CLK_SI5351
 	tristate "Clock driver for SiLabs 5351A/B/C"
 	depends on I2C
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 6c1aff6..520ff76 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_ARCH_HIGHBANK)		+= clk-highbank.o
 obj-$(CONFIG_MACH_LOONGSON1)		+= clk-ls1x.o
 obj-$(CONFIG_COMMON_CLK_MAX_GEN)	+= clk-max-gen.o
 obj-$(CONFIG_COMMON_CLK_MAX77686)	+= clk-max77686.o
+obj-$(CONFIG_COMMON_CLK_MAX77802)	+= clk-max77802.o
 obj-$(CONFIG_ARCH_MOXART)		+= clk-moxart.o
 obj-$(CONFIG_ARCH_NOMADIK)		+= clk-nomadik.o
 obj-$(CONFIG_ARCH_NSPIRE)		+= clk-nspire.o
diff --git a/drivers/clk/clk-max77802.c b/drivers/clk/clk-max77802.c
new file mode 100644
index 0000000..8e480c5
--- /dev/null
+++ b/drivers/clk/clk-max77802.c
@@ -0,0 +1,98 @@
+/*
+ * clk-max77802.c - Clock driver for Maxim 77802
+ *
+ * Copyright (C) 2014 Google, Inc
+ *
+ * Copyright (C) 2012 Samsung Electornics
+ * Jonghwa Lee <jonghwa3.lee@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * This driver is based on clk-max77686.c
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/max77686-private.h>
+#include <linux/clk-provider.h>
+#include <linux/mutex.h>
+#include <linux/clkdev.h>
+
+#include <dt-bindings/clock/maxim,max77802.h>
+#include "clk-max-gen.h"
+
+#define MAX77802_CLOCK_OPMODE_MASK	0x1
+#define MAX77802_CLOCK_LOW_JITTER_SHIFT 0x3
+
+static struct clk_init_data max77802_clks_init[MAX77802_CLKS_NUM] = {
+	[MAX77802_CLK_32K_AP] = {
+		.name = "32khz_ap",
+		.ops = &max_gen_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+	[MAX77802_CLK_32K_CP] = {
+		.name = "32khz_cp",
+		.ops = &max_gen_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+};
+
+static int max77802_clk_probe(struct platform_device *pdev)
+{
+	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	int ret;
+
+	ret = max_gen_clk_probe(pdev, iodev->regmap, MAX77802_REG_32KHZ,
+				max77802_clks_init, MAX77802_CLKS_NUM);
+
+	if (ret) {
+		dev_err(&pdev->dev, "generic probe failed %d\n", ret);
+		return ret;
+	}
+
+	/* Enable low-jitter mode on the 32khz clocks. */
+	ret = regmap_update_bits(iodev->regmap, MAX77802_REG_32KHZ,
+				 1 << MAX77802_CLOCK_LOW_JITTER_SHIFT,
+				 1 << MAX77802_CLOCK_LOW_JITTER_SHIFT);
+	if (ret < 0)
+		dev_err(&pdev->dev, "failed to enable low-jitter mode\n");
+
+	return ret;
+}
+
+static int max77802_clk_remove(struct platform_device *pdev)
+{
+	return max_gen_clk_remove(pdev, MAX77802_CLKS_NUM);
+}
+
+static const struct platform_device_id max77802_clk_id[] = {
+	{ "max77802-clk", 0},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, max77802_clk_id);
+
+static struct platform_driver max77802_clk_driver = {
+	.driver = {
+		.name  = "max77802-clk",
+		.owner = THIS_MODULE,
+	},
+	.probe = max77802_clk_probe,
+	.remove = max77802_clk_remove,
+	.id_table = max77802_clk_id,
+};
+
+module_platform_driver(max77802_clk_driver);
+
+MODULE_DESCRIPTION("MAXIM 77802 Clock Driver");
+MODULE_AUTHOR("Javier Martinez Canillas <javier.martinez@collabora.co.uk>");
+MODULE_LICENSE("GPL");
diff --git a/include/dt-bindings/clock/maxim,max77802.h b/include/dt-bindings/clock/maxim,max77802.h
new file mode 100644
index 0000000..997312e
--- /dev/null
+++ b/include/dt-bindings/clock/maxim,max77802.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2014 Google, Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Device Tree binding constants clocks for the Maxim 77802 PMIC.
+ */
+
+#ifndef _DT_BINDINGS_CLOCK_MAXIM_MAX77802_CLOCK_H
+#define _DT_BINDINGS_CLOCK_MAXIM_MAX77802_CLOCK_H
+
+/* Fixed rate clocks. */
+
+#define MAX77802_CLK_32K_AP		0
+#define MAX77802_CLK_32K_CP		1
+
+/* Total number of clocks. */
+#define MAX77802_CLKS_NUM		(MAX77802_CLK_32K_CP + 1)
+
+#endif /* _DT_BINDINGS_CLOCK_MAXIM_MAX77802_CLOCK_H */
-- 
2.0.0.rc2

