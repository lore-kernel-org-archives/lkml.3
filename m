Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab3GaAFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:05:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43496 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587Ab3GaAFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:05:33 -0400
From: Abhimanyu Kapur <abhimany@codeaurora.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sboyd@codeaurora.org
Subject: [PATCH] drivers: power: reset: add msm restart support
Date: Tue, 30 Jul 2013 17:05:28 -0700
Message-Id: <1375229128-32226-1-git-send-email-abhimany@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for restart and poweroff functionality present on MSM
chipsets with the MPM2 ps-hold hardware.

Signed-off-by: Abhimanyu Kapur <abhimany@codeaurora.org>
---
 .../bindings/power_supply/msm-poweroff.txt         | 17 +++++
 drivers/power/reset/Kconfig                        |  6 ++
 drivers/power/reset/Makefile                       |  1 +
 drivers/power/reset/msm-poweroff.c                 | 75 ++++++++++++++++++++++
 4 files changed, 99 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/msm-poweroff.txt
 create mode 100644 drivers/power/reset/msm-poweroff.c

diff --git a/Documentation/devicetree/bindings/power_supply/msm-poweroff.txt b/Documentation/devicetree/bindings/power_supply/msm-poweroff.txt
new file mode 100644
index 0000000..ce44ad3
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/msm-poweroff.txt
@@ -0,0 +1,17 @@
+MSM Restart Driver
+
+A power supply hold (ps-hold) bit is set to power the msm chipsets.
+Clearing that bit allows us to restart/poweroff. The difference
+between poweroff and restart is determined by unique power manager IC
+settings.
+
+Required Properties:
+-compatible: "qcom,pshold"
+-reg: Specifies the physical address of the ps-hold register
+
+Example:
+
+	restart@fc4ab000 {
+		compatible = "qcom,pshold";
+		reg = <0xfc4ab000 0x4>;
+	};
diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 349e9ae..e7bcf1d 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -14,6 +14,12 @@ config POWER_RESET_GPIO
 	  If your board needs a GPIO high/low to power down, say Y and
 	  create a binding in your devicetree.
 
+config POWER_RESET_MSM
+	bool "Qualcomm MSM power-off driver"
+	depends on POWER_RESET && ARCH_MSM
+	help
+	  Power off and restart support for Qualcomm boards.
+
 config POWER_RESET_QNAP
 	bool "QNAP power-off driver"
 	depends on OF_GPIO && POWER_RESET && PLAT_ORION
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index 372807f..b82288e 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_POWER_RESET_GPIO) += gpio-poweroff.o
+obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
 obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
 obj-$(CONFIG_POWER_RESET_RESTART) += restart-poweroff.o
 obj-$(CONFIG_POWER_RESET_VEXPRESS) += vexpress-poweroff.o
diff --git a/drivers/power/reset/msm-poweroff.c b/drivers/power/reset/msm-poweroff.c
new file mode 100644
index 0000000..c461fe4
--- /dev/null
+++ b/drivers/power/reset/msm-poweroff.c
@@ -0,0 +1,75 @@
+/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
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
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/reboot.h>
+
+#include <asm/system_misc.h>
+
+static void __iomem *msm_ps_hold;
+
+static void do_msm_restart(enum reboot_mode reboot_mode, const char *cmd)
+{
+	writel(0, msm_ps_hold);
+	mdelay(10000);
+}
+
+static void do_msm_poweroff(void)
+{
+	/* TODO: Add poweroff capability */
+
+	do_msm_restart(REBOOT_HARD, NULL);
+}
+
+static int msm_restart_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *mem;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	msm_ps_hold = devm_ioremap_resource(dev, mem);
+	if (IS_ERR(msm_ps_hold))
+		return PTR_ERR(msm_ps_hold);
+
+	pm_power_off = do_msm_poweroff;
+	arm_pm_restart = do_msm_restart;
+	return 0;
+}
+
+static const struct of_device_id of_msm_restart_match[] = {
+	{ .compatible = "qcom,pshold", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, of_msm_restart_match);
+
+static struct platform_driver msm_restart_driver = {
+	.probe = msm_restart_probe,
+	.driver = {
+		.name = "msm-restart",
+		.of_match_table = of_match_ptr(of_msm_restart_match),
+	},
+};
+
+static int __init msm_restart_init(void)
+{
+	return platform_driver_register(&msm_restart_driver);
+}
+device_initcall(msm_restart_init);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

