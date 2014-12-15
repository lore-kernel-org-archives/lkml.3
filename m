Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaLOL0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:26:07 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:62752 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaLOL0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:26:02 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, a.zummo@towertech.it,
        rtc-linux@googlegroups.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 5/8] mfd: Add ST's Low Power Controller driver
Date: Mon, 15 Dec 2014 11:25:35 +0000
Message-Id: <1418642738-17407-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418642738-17407-1-git-send-email-lee.jones@linaro.org>
References: <1418642738-17407-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On current ST platforms the LPC controls a number of functions.  This
patch enables possible support for the LPC Watchdog and LPC RTC devices
and ensures only one of them operates at any one time.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/Kconfig  |  8 +++++
 drivers/mfd/Makefile |  1 +
 drivers/mfd/st-lpc.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 97 insertions(+)
 create mode 100644 drivers/mfd/st-lpc.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index de5abf2..75db2f2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -752,6 +752,14 @@ config STMPE_SPI
 	  This is used to enable SPI interface of STMPE
 endmenu
 
+config MFD_ST_LPC
+	tristate "STMicroelectronics Low-Power-Controller"
+	depends on OF
+	select MFD_CORE
+	help
+	  Say yes here to add support for ST's Low-Power-Controller (LPC).
+	  This device provides Real-Time Clock and Watchdog functionality.
+
 config MFD_STA2X11
 	bool "STMicroelectronics STA2X11"
 	depends on STA2X11
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index f001487..09aeb95 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_MFD_STA2X11)	+= sta2x11-mfd.o
 obj-$(CONFIG_MFD_STMPE)		+= stmpe.o
 obj-$(CONFIG_STMPE_I2C)		+= stmpe-i2c.o
 obj-$(CONFIG_STMPE_SPI)		+= stmpe-spi.o
+obj-$(CONFIG_MFD_ST_LPC)	+= st-lpc.o
 obj-$(CONFIG_MFD_SUN6I_PRCM)	+= sun6i-prcm.o
 obj-$(CONFIG_MFD_TC3589X)	+= tc3589x.o
 obj-$(CONFIG_MFD_T7L66XB)	+= t7l66xb.o tmio_core.o
diff --git a/drivers/mfd/st-lpc.c b/drivers/mfd/st-lpc.c
new file mode 100644
index 0000000..13906d9
--- /dev/null
+++ b/drivers/mfd/st-lpc.c
@@ -0,0 +1,88 @@
+/*
+ * st-lpc.c - ST's Low Power Controller (LPC) Multi-Function Device Driver
+ *
+ * Copyright (C) 2014 STMicroelectronics -- All Rights Reserved
+ *
+ * Author: Lee Jones <lee.jones@linaro.org> for STMicroelectronics
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/err.h>
+#include <linux/mfd/core.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <dt-bindings/mfd/st-lpc.h>
+
+static int st_lpc_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct mfd_cell *cell;
+	u32 mode;
+	int ret;
+
+	cell = devm_kzalloc(&pdev->dev, sizeof(*cell), GFP_KERNEL);
+	if (!cell)
+		return -ENOMEM;
+
+	ret = of_property_read_u32(np, "st,lpc-mode", &mode);
+	if (ret) {
+		dev_err(&pdev->dev, "An LPC mode must be selected\n");
+		return ret;
+	}
+
+	switch (mode) {
+	case ST_LPC_MODE_RTC:
+		cell->name = "st-lpc-rtc";
+		break;
+	case ST_LPC_MODE_WDT:
+		cell->name = "st-lpc-wdt";
+		break;
+	default:
+		dev_err(&pdev->dev, "Unsupported mode: %d\n", mode);
+		return ret;
+	}
+
+	/* Pass resources though to selected child device. */
+	cell->resources = pdev->resource;
+	cell->num_resources = pdev->num_resources;
+
+	ret = mfd_add_devices(&pdev->dev, PLATFORM_DEVID_AUTO,
+			      cell, 1, NULL, 0, NULL);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register child devices\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int st_lpc_remove(struct platform_device *pdev)
+{
+	mfd_remove_devices(&pdev->dev);
+
+	return 0;
+}
+
+static const struct of_device_id st_lpc_dt_match[] = {
+	{ .compatible = "st,stih407-lpc" },
+	{ }
+};
+
+static struct platform_driver st_lpc_driver = {
+	.driver = {
+		.name = "st-lpc",
+		.of_match_table = st_lpc_dt_match,
+	},
+	.probe = st_lpc_probe,
+	.remove = st_lpc_remove,
+};
+
+module_platform_driver(st_lpc_driver);
+
+MODULE_AUTHOR("Lee Jones <lee.jones@linaro.org>");
+MODULE_DESCRIPTION("ST's Low Power Controller (LPC) Multi-Function Device");
+MODULE_LICENSE("GPL");
-- 
1.9.1

