Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaAQTUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:20:05 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:55312 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaAQTT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:19:57 -0500
From: Marc Carino <marc.ceeeee@gmail.com>
To: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v4 2/8] power: reset: Add reboot driver for brcmstb
Date: Fri, 17 Jan 2014 11:19:21 -0800
Message-Id: <1389986367-4010-3-git-send-email-marc.ceeeee@gmail.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1389986367-4010-1-git-send-email-marc.ceeeee@gmail.com>
References: <1389986367-4010-1-git-send-email-marc.ceeeee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for reboot functionality on boards with ARM-based
Broadcom STB chipsets.

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
---
 drivers/power/reset/Kconfig          |   10 +++
 drivers/power/reset/Makefile         |    1 +
 drivers/power/reset/brcmstb-reboot.c |  120 ++++++++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/reset/brcmstb-reboot.c

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 9b3ea53..31b468b 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -6,6 +6,16 @@ menuconfig POWER_RESET
 
 	  Say Y here to enable board reset and power off
 
+config POWER_RESET_BRCMSTB
+	bool "Broadcom STB reset driver"
+	depends on POWER_RESET && ARCH_BRCMSTB
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
index 3e6ed88..806d056 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
 obj-$(CONFIG_POWER_RESET_RESTART) += restart-poweroff.o
 obj-$(CONFIG_POWER_RESET_VEXPRESS) += vexpress-poweroff.o
 obj-$(CONFIG_POWER_RESET_XGENE) += xgene-reboot.o
+obj-$(CONFIG_POWER_RESET_BRCMSTB) += brcmstb-reboot.o
diff --git a/drivers/power/reset/brcmstb-reboot.c b/drivers/power/reset/brcmstb-reboot.c
new file mode 100644
index 0000000..3f23692
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
1.7.1

