Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbaGVXsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 19:48:16 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39442 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbaGVXsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 19:48:14 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Marc Carino <marc.ceeeee@gmail.com>, Matt Porter <mporter@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org
Subject: [PATCH v9] power: reset: Add reboot driver for brcmstb
Date: Tue, 22 Jul 2014 16:48:03 -0700
Message-Id: <1406072883-16035-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Carino <marc.ceeeee@gmail.com>

Add support for reboot functionality on boards with ARM-based
Broadcom STB chipsets. Make it built-in by default for ARCH_BRCMSTB,
but allow it to be configurable under COMPILE_TEST.

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
Hi Sebastian, can you merge this, or else defer this to Matt?

This driver is mostly unchanged for a while, but it hasn't gotten an Ack from
any PM guys. It is now separated from the rest of its accompanying series:

  https://lkml.org/lkml/2014/7/21/647
  https://lkml.org/lkml/2014/7/21/801

The DT bindings have gotten review somewhere in the course of 8 versions.

 drivers/power/reset/Kconfig          |  11 ++++
 drivers/power/reset/Makefile         |   1 +
 drivers/power/reset/brcmstb-reboot.c | 120 +++++++++++++++++++++++++++++++++++
 3 files changed, 132 insertions(+)
 create mode 100644 drivers/power/reset/brcmstb-reboot.c

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index bdcf5173e377..f2ac54df496f 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -20,6 +20,17 @@ config POWER_RESET_AXXIA
 
 	  Say Y if you have an Axxia family SoC.
 
+config POWER_RESET_BRCMSTB
+	bool "Broadcom STB reset driver" if COMPILE_TEST
+	depends on POWER_RESET && ARM
+	default ARCH_BRCMSTB
+	help
+	  This driver provides restart support for ARM-based Broadcom STB
+	  boards.
+
+	  Say Y here if you have an ARM-based Broadcom STB board and you wish
+	  to have restart support.
+
 config POWER_RESET_GPIO
 	bool "GPIO power-off driver"
 	depends on OF_GPIO && POWER_RESET
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index dde2e8bbac53..7379818ca69d 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_POWER_RESET_AS3722) += as3722-poweroff.o
 obj-$(CONFIG_POWER_RESET_AXXIA) += axxia-reset.o
+obj-$(CONFIG_POWER_RESET_BRCMSTB) += brcmstb-reboot.o
 obj-$(CONFIG_POWER_RESET_GPIO) += gpio-poweroff.o
 obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
 obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
diff --git a/drivers/power/reset/brcmstb-reboot.c b/drivers/power/reset/brcmstb-reboot.c
new file mode 100644
index 000000000000..3f236924742a
--- /dev/null
+++ b/drivers/power/reset/brcmstb-reboot.c
@@ -0,0 +1,120 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/printk.h>
+#include <linux/reboot.h>
+#include <linux/regmap.h>
+#include <linux/smp.h>
+#include <linux/mfd/syscon.h>
+
+#include <asm/system_misc.h>
+
+#define RESET_SOURCE_ENABLE_REG 1
+#define SW_MASTER_RESET_REG 2
+
+static struct regmap *regmap;
+static u32 rst_src_en;
+static u32 sw_mstr_rst;
+
+static void brcmstb_reboot(enum reboot_mode mode, const char *cmd)
+{
+	int rc;
+	u32 tmp;
+
+	rc = regmap_write(regmap, rst_src_en, 1);
+	if (rc) {
+		pr_err("failed to write rst_src_en (%d)\n", rc);
+		return;
+	}
+
+	rc = regmap_read(regmap, rst_src_en, &tmp);
+	if (rc) {
+		pr_err("failed to read rst_src_en (%d)\n", rc);
+		return;
+	}
+
+	rc = regmap_write(regmap, sw_mstr_rst, 1);
+	if (rc) {
+		pr_err("failed to write sw_mstr_rst (%d)\n", rc);
+		return;
+	}
+
+	rc = regmap_read(regmap, sw_mstr_rst, &tmp);
+	if (rc) {
+		pr_err("failed to read sw_mstr_rst (%d)\n", rc);
+		return;
+	}
+
+	while (1)
+		;
+}
+
+static int brcmstb_reboot_probe(struct platform_device *pdev)
+{
+	int rc;
+	struct device_node *np = pdev->dev.of_node;
+
+	regmap = syscon_regmap_lookup_by_phandle(np, "syscon");
+	if (IS_ERR(regmap)) {
+		pr_err("failed to get syscon phandle\n");
+		return -EINVAL;
+	}
+
+	rc = of_property_read_u32_index(np, "syscon", RESET_SOURCE_ENABLE_REG,
+					&rst_src_en);
+	if (rc) {
+		pr_err("can't get rst_src_en offset (%d)\n", rc);
+		return -EINVAL;
+	}
+
+	rc = of_property_read_u32_index(np, "syscon", SW_MASTER_RESET_REG,
+					&sw_mstr_rst);
+	if (rc) {
+		pr_err("can't get sw_mstr_rst offset (%d)\n", rc);
+		return -EINVAL;
+	}
+
+	arm_pm_restart = brcmstb_reboot;
+
+	return 0;
+}
+
+static const struct of_device_id of_match[] = {
+	{ .compatible = "brcm,brcmstb-reboot", },
+	{},
+};
+
+static struct platform_driver brcmstb_reboot_driver = {
+	.probe = brcmstb_reboot_probe,
+	.driver = {
+		.name = "brcmstb-reboot",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match,
+	},
+};
+
+static int __init brcmstb_reboot_init(void)
+{
+	return platform_driver_probe(&brcmstb_reboot_driver,
+					brcmstb_reboot_probe);
+}
+subsys_initcall(brcmstb_reboot_init);
-- 
1.9.1

