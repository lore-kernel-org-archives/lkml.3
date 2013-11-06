Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab3KFMT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:19:59 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17215 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab3KFMTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:19:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 06 Nov 2013 04:14:22 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <mturquette@linaro.org>,
        <dwmw2@infradead.org>, <anton@enomsg.org>
CC: <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <rob.herring@calxeda.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 5/5] power: reset: as3722: add power-off driver
Date: Wed, 6 Nov 2013 17:48:23 +0530
Message-ID: <1383740303-10956-6-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1383740303-10956-1-git-send-email-ldewangan@nvidia.com>
References: <1383740303-10956-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ams AS3722 supports the power off functionality to turn off
system.

Add power off driver for ams AS3722.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- None

 drivers/power/reset/Kconfig           |    6 ++
 drivers/power/reset/Makefile          |    1 +
 drivers/power/reset/as3722-poweroff.c |   96 +++++++++++++++++++++++++++++++++
 3 files changed, 103 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/reset/as3722-poweroff.c

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 9b3ea53..6d452a7 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -6,6 +6,12 @@ menuconfig POWER_RESET
 
 	  Say Y here to enable board reset and power off
 
+config POWER_RESET_AS3722
+	bool "ams AS3722 power-off driver"
+	depends on MFD_AS3722 && POWER_RESET
+	help
+	  This driver supports turning off board via a ams AS3722 power-off.
+
 config POWER_RESET_GPIO
 	bool "GPIO power-off driver"
 	depends on OF_GPIO && POWER_RESET
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index 3e6ed88..a5b4a77 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -1,3 +1,4 @@
+obj-$(CONFIG_POWER_RESET_AS3722) += as3722-poweroff.o
 obj-$(CONFIG_POWER_RESET_GPIO) += gpio-poweroff.o
 obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
 obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
diff --git a/drivers/power/reset/as3722-poweroff.c b/drivers/power/reset/as3722-poweroff.c
new file mode 100644
index 0000000..0e489ff
--- /dev/null
+++ b/drivers/power/reset/as3722-poweroff.c
@@ -0,0 +1,96 @@
+/*
+ * Power off driver for ams AS3722 device.
+ *
+ * Copyright (c) 2013, NVIDIA Corporation.
+ *
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/mfd/as3722.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+struct as3722_poweroff {
+	struct device *dev;
+	struct as3722 *as3722;
+};
+
+static struct as3722_poweroff *as3722_pm_poweroff;
+
+static void as3722_pm_power_off(void)
+{
+	int ret;
+
+	if (!as3722_pm_poweroff) {
+		pr_err("AS3722 poweroff is not initialised\n");
+		return;
+	}
+
+	ret = as3722_update_bits(as3722_pm_poweroff->as3722,
+		AS3722_RESET_CONTROL_REG, AS3722_POWER_OFF, AS3722_POWER_OFF);
+	if (ret < 0)
+		dev_err(as3722_pm_poweroff->dev,
+			"RESET_CONTROL_REG update failed, %d\n", ret);
+}
+
+static int as3722_poweroff_probe(struct platform_device *pdev)
+{
+	struct as3722_poweroff *as3722_poweroff;
+	struct device_node *np = pdev->dev.parent->of_node;
+
+	if (!np)
+		return -EINVAL;
+
+	if (!of_property_read_bool(np, "ams,system-power-controller"))
+		return 0;
+
+	as3722_poweroff = devm_kzalloc(&pdev->dev, sizeof(*as3722_poweroff),
+				GFP_KERNEL);
+	if (!as3722_poweroff)
+		return -ENOMEM;
+
+	as3722_poweroff->as3722 = dev_get_drvdata(pdev->dev.parent);
+	as3722_poweroff->dev = &pdev->dev;
+	as3722_pm_poweroff = as3722_poweroff;
+	if (!pm_power_off)
+		pm_power_off = as3722_pm_power_off;
+
+	return 0;
+}
+
+static int as3722_poweroff_remove(struct platform_device *pdev)
+{
+	if (pm_power_off == as3722_pm_power_off)
+		pm_power_off = NULL;
+	as3722_pm_poweroff = NULL;
+
+	return 0;
+}
+
+static struct platform_driver as3722_poweroff_driver = {
+	.driver = {
+		.name = "as3722-power-off",
+		.owner = THIS_MODULE,
+	},
+	.probe = as3722_poweroff_probe,
+	.remove = as3722_poweroff_remove,
+};
+
+module_platform_driver(as3722_poweroff_driver);
+
+MODULE_DESCRIPTION("Power off driver for ams AS3722 PMIC Device");
+MODULE_ALIAS("platform:as3722-power-off");
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.1.1

