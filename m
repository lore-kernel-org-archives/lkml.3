Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaEWJJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:09:36 -0400
Received: from exprod7og115.obsmtp.com ([64.18.2.217]:42005 "EHLO
	exprod7og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaEWJJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:09:32 -0400
From: Anders Berg <anders.berg@avagotech.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anders Berg <anders.berg@lsi.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v4 4/5] power: reset: Add Axxia system reset driver
Date: Fri, 23 May 2014 11:08:38 +0200
Message-Id: <3f6a31e2515d21dbef4ccf25ebbb090e242c9572.1400834521.git.anders.berg@avagotech.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1400834521.git.anders.berg@avagotech.com>
References: <cover.1400834521.git.anders.berg@avagotech.com>
In-Reply-To: <cover.1400834521.git.anders.berg@avagotech.com>
References: <cover.1400834521.git.anders.berg@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Berg <anders.berg@lsi.com>

Add Axxia (AXM55xx) SoC system reset driver. This driver handles only system
reboot (and not power-off).

Signed-off-by: Anders Berg <anders.berg@lsi.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 .../bindings/power_supply/axxia-reset.txt          | 20 +++++
 drivers/power/reset/Kconfig                        |  8 ++
 drivers/power/reset/Makefile                       |  1 +
 drivers/power/reset/axxia-reset.c                  | 88 ++++++++++++++++++++++
 4 files changed, 117 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/axxia-reset.txt
 create mode 100644 drivers/power/reset/axxia-reset.c

diff --git a/Documentation/devicetree/bindings/power_supply/axxia-reset.txt b/Documentation/devicetree/bindings/power_supply/axxia-reset.txt
new file mode 100644
index 0000000..47e720d
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/axxia-reset.txt
@@ -0,0 +1,20 @@
+Axxia Restart Driver
+
+This driver can do reset of the Axxia SoC. It uses the registers in the syscon
+block to initiate a chip reset.
+
+Required Properties:
+  -compatible: "lsi,axm55xx-reset"
+  -syscon: phandle to the syscon node.
+
+Example:
+
+	syscon: syscon@2010030000 {
+		compatible = "lsi,axxia-syscon", "syscon";
+		reg = <0x20 0x10030000 0 0x2000>;
+	};
+
+	reset: reset@2010031000 {
+		compatible = "lsi,axm55xx-reset";
+		syscon = <&syscon>;
+	};
diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index fa0e4e0..49b46e6 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -12,6 +12,14 @@ config POWER_RESET_AS3722
 	help
 	  This driver supports turning off board via a ams AS3722 power-off.
 
+config POWER_RESET_AXXIA
+	bool "LSI Axxia reset driver"
+	depends on POWER_RESET && ARCH_AXXIA
+	help
+	  This driver supports restart for Axxia SoC.
+
+	  Say Y if you have an Axxia family SoC.
+
 config POWER_RESET_GPIO
 	bool "GPIO power-off driver"
 	depends on OF_GPIO && POWER_RESET
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index a5b4a77..16c0516 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_POWER_RESET_AS3722) += as3722-poweroff.o
+obj-$(CONFIG_POWER_RESET_AXXIA) += axxia-reset.o
 obj-$(CONFIG_POWER_RESET_GPIO) += gpio-poweroff.o
 obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
 obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
diff --git a/drivers/power/reset/axxia-reset.c b/drivers/power/reset/axxia-reset.c
new file mode 100644
index 0000000..3b1f8d6
--- /dev/null
+++ b/drivers/power/reset/axxia-reset.c
@@ -0,0 +1,88 @@
+/*
+ * Reset driver for Axxia devices
+ *
+ * Copyright (C) 2014 LSI
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
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/reboot.h>
+#include <linux/regmap.h>
+
+#include <asm/system_misc.h>
+
+
+#define SC_CRIT_WRITE_KEY	0x1000
+#define SC_LATCH_ON_RESET	0x1004
+#define SC_RESET_CONTROL	0x1008
+#define   RSTCTL_RST_ZERO	(1<<3)
+#define   RSTCTL_RST_FAB	(1<<2)
+#define   RSTCTL_RST_CHIP	(1<<1)
+#define   RSTCTL_RST_SYS	(1<<0)
+#define SC_EFUSE_INT_STATUS	0x180c
+#define   EFUSE_READ_DONE	(1<<31)
+
+static struct regmap *syscon;
+
+static void do_axxia_restart(enum reboot_mode reboot_mode, const char *cmd)
+{
+	/* Access Key (0xab) */
+	regmap_write(syscon, SC_CRIT_WRITE_KEY, 0xab);
+	/* Select internal boot from 0xffff0000 */
+	regmap_write(syscon, SC_LATCH_ON_RESET, 0x00000040);
+	/* Assert ResetReadDone (to avoid hanging in boot ROM) */
+	regmap_write(syscon, SC_EFUSE_INT_STATUS, EFUSE_READ_DONE);
+	/* Assert chip reset */
+	regmap_update_bits(syscon, SC_RESET_CONTROL,
+			   RSTCTL_RST_CHIP, RSTCTL_RST_CHIP);
+}
+
+static int axxia_reset_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+
+	syscon = syscon_regmap_lookup_by_phandle(dev->of_node, "syscon");
+	if (IS_ERR(syscon)) {
+		pr_err("%s: syscon lookup failed\n", dev->of_node->name);
+		return PTR_ERR(syscon);
+	}
+
+	arm_pm_restart = do_axxia_restart;
+
+	return 0;
+}
+
+static const struct of_device_id of_axxia_reset_match[] = {
+	{ .compatible = "lsi,axm55xx-reset", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, of_axxia_reset_match);
+
+static struct platform_driver axxia_reset_driver = {
+	.probe = axxia_reset_probe,
+	.driver = {
+		.name = "axxia-reset",
+		.of_match_table = of_match_ptr(of_axxia_reset_match),
+	},
+};
+
+static int __init axxia_reset_init(void)
+{
+	return platform_driver_register(&axxia_reset_driver);
+}
+device_initcall(axxia_reset_init);
-- 
1.8.3.2

