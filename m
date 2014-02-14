Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaBNGcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:32:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39368 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbaBNGcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:32:08 -0500
From: Milo Kim <milo.kim@ti.com>
To: Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Milo Kim <milo.kim@ti.com>
Subject: [PATCH 06/10] backlight: ti-lmu-backlight: Add LM3695 driver
Date: Fri, 14 Feb 2014 15:31:57 +0900
Message-ID: <1392359517-7065-1-git-send-email-milo.kim@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LM3695 has 2 backlight strings and 11 bit dimming is supported.

Common backlight driver is controlled by TI LMU backlight driver.
Only LM3695 specific code is implemented here.

Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Milo Kim <milo.kim@ti.com>
---
 drivers/video/backlight/Kconfig     |    8 ++
 drivers/video/backlight/Makefile    |    1 +
 drivers/video/backlight/lm3695_bl.c |  143 +++++++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+)
 create mode 100644 drivers/video/backlight/lm3695_bl.c

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index aa012a3..b169c8d 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -411,6 +411,14 @@ config BACKLIGHT_LM3633
 	  Up to 3 backlight strings and 11 bit dimming is supported.
 	  PWM brightness control is also supported.
 
+config BACKLIGHT_LM3695
+	tristate "Backlight driver for TI LM3695"
+	depends on BACKLIGHT_CLASS_DEVICE && MFD_TI_LMU
+	select TI_LMU_BACKLIGHT
+	help
+	  Say Y to enable the backlight driver for TI LM3695.
+	  Up to 2 backlight strings and 11 bit dimming is supported.
+
 config TI_LMU_BACKLIGHT
 	tristate "Backlight driver for TI LMU"
 	depends on BACKLIGHT_LM3532 || BACKLIGHT_LM3631 || BACKLIGHT_LM3633 || BACKLIGHT_LM3695 || BACKLIGHT_LM3697
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index 842a256..5427162 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_BACKLIGHT_LM3639)		+= lm3639_bl.o
 obj-$(CONFIG_BACKLIGHT_LM3532)		+= lm3532_bl.o
 obj-$(CONFIG_BACKLIGHT_LM3631)		+= lm3631_bl.o
 obj-$(CONFIG_BACKLIGHT_LM3633)		+= lm3633_bl.o
+obj-$(CONFIG_BACKLIGHT_LM3695)		+= lm3695_bl.o
 obj-$(CONFIG_TI_LMU_BACKLIGHT)		+= ti-lmu-backlight.o
 obj-$(CONFIG_BACKLIGHT_LOCOMO)		+= locomolcd.o
 obj-$(CONFIG_BACKLIGHT_LP855X)		+= lp855x_bl.o
diff --git a/drivers/video/backlight/lm3695_bl.c b/drivers/video/backlight/lm3695_bl.c
new file mode 100644
index 0000000..959e72a
--- /dev/null
+++ b/drivers/video/backlight/lm3695_bl.c
@@ -0,0 +1,143 @@
+/*
+ * TI LM3695 Backlight Driver
+ *
+ * Copyright 2014 Texas Instruments
+ *
+ * Author: Milo Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * LM3695 backlight driver consists of two parts
+ *
+ *   1) LM3695 chip specific part: this file
+ *      Define device specific operations
+ *      Register LMU backlight driver
+ *
+ *   2) LMU backlight common driver: ti-lmu-backlight
+ *      General backlight subsystem control
+ */
+
+#include <linux/backlight.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/mfd/ti-lmu.h>
+#include <linux/mfd/ti-lmu-register.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "ti-lmu-backlight.h"
+
+#define LM3695_FULL_STRINGS		(LMU_HVLED1 | LMU_HVLED2)
+#define LM3695_MAX_BRIGHTNESS		2047
+
+static int lm3695_bl_enable(struct ti_lmu_bl *lmu_bl, int enable)
+{
+	int ret;
+
+	ret = ti_lmu_update_bits(lmu_bl->chip->lmu, LM3695_REG_GP,
+				 LM3695_BL_EN_MASK, enable);
+	if (ret)
+		return ret;
+
+	/* Wait time for brightness register wake up */
+	usleep_range(600, 700);
+
+	return 0;
+}
+
+static int lm3695_bl_set_brightness(struct ti_lmu_bl *lmu_bl, int brightness)
+{
+	u8 data;
+	int ret;
+
+	data = brightness & LM3695_BRT_LSB_MASK;
+	ret = ti_lmu_update_bits(lmu_bl->chip->lmu, LM3695_REG_BRT_LSB,
+				 LM3695_BRT_LSB_MASK, data);
+	if (ret)
+		return ret;
+
+	data = (brightness >> LM3695_BRT_MSB_SHIFT) & 0xFF;
+	return ti_lmu_write_byte(lmu_bl->chip->lmu, LM3695_REG_BRT_MSB,
+				 data);
+}
+
+static int lm3695_bl_init(struct ti_lmu_bl_chip *chip)
+{
+	return ti_lmu_update_bits(chip->lmu, LM3695_REG_GP,
+				  LM3695_BRT_RW_MASK, LM3695_BRT_SET_RW);
+}
+
+static int lm3695_bl_configure(struct ti_lmu_bl *lmu_bl)
+{
+	u8 val;
+
+	if (lmu_bl->bl_pdata->bl_string == LM3695_FULL_STRINGS)
+		val = LM3695_BL_TWO_STRINGS;
+	else
+		val = LM3695_BL_ONE_STRING;
+
+	return ti_lmu_update_bits(lmu_bl->chip->lmu, LM3695_REG_GP,
+				  LM3695_BL_STRING_MASK, val);
+}
+
+static const struct ti_lmu_bl_ops lm3695_lmu_ops = {
+	.init              = lm3695_bl_init,
+	.configure         = lm3695_bl_configure,
+	.update_brightness = lm3695_bl_set_brightness,
+	.bl_enable         = lm3695_bl_enable,
+	.max_brightness    = LM3695_MAX_BRIGHTNESS,
+};
+
+static int lm3695_bl_probe(struct platform_device *pdev)
+{
+	struct ti_lmu *lmu = dev_get_drvdata(pdev->dev.parent);
+	struct ti_lmu_bl *lmu_bl;
+	struct ti_lmu_bl_chip *chip;
+
+	chip = ti_lmu_backlight_init_device(&pdev->dev, lmu, &lm3695_lmu_ops);
+	if (IS_ERR(chip))
+		return PTR_ERR(chip);
+
+	lmu_bl = ti_lmu_backlight_register(chip, lmu->pdata->bl_pdata, 1);
+	if (IS_ERR(lmu_bl))
+		return PTR_ERR(lmu_bl);
+
+	platform_set_drvdata(pdev, lmu_bl);
+
+	return 0;
+}
+
+static int lm3695_bl_remove(struct platform_device *pdev)
+{
+	struct ti_lmu_bl *lmu_bl = platform_get_drvdata(pdev);
+
+	return ti_lmu_backlight_unregister(lmu_bl);
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id lm3695_bl_of_match[] = {
+	{ .compatible = "ti,lm3695-backlight", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lm3695_bl_of_match);
+#endif
+
+static struct platform_driver lm3695_bl_driver = {
+	.probe = lm3695_bl_probe,
+	.remove = lm3695_bl_remove,
+	.driver = {
+		.name = "lm3695-backlight",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(lm3695_bl_of_match),
+	},
+};
+module_platform_driver(lm3695_bl_driver);
+
+MODULE_DESCRIPTION("TI LM3695 Backlight Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:lm3695-backlight");
-- 
1.7.9.5

