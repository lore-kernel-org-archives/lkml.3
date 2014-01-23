Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaAWTXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:23:43 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:47290 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932122AbaAWTXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:23:40 -0500
From: Feng Kan <fkan@apm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V4 1/5] power: reset: Add generic SYSCON register mapped reset
Date: Thu, 23 Jan 2014 11:19:57 -0800
Message-Id: <1390504801-24483-2-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1390504801-24483-1-git-send-email-fkan@apm.com>
References: <1390504801-24483-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a generic SYSCON register mapped reset mechanism.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 drivers/power/reset/Kconfig         |    7 +++
 drivers/power/reset/Makefile        |    1 +
 drivers/power/reset/syscon-reboot.c |  100 +++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/reset/syscon-reboot.c

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 9b3ea53..4501c02 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -51,3 +51,10 @@ config POWER_RESET_XGENE
 	depends on POWER_RESET
 	help
 	  Reboot support for the APM SoC X-Gene Eval boards.
+
+config POWER_RESET_SYSCON
+	bool "Generic SYSCON regmap reset driver"
+	depends on MFD_SYSCON
+	depends on POWER_RESET
+	help
+	  Reboot support for generic SYSCON mapped register reset.
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index 3e6ed88..f2c0327 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
 obj-$(CONFIG_POWER_RESET_RESTART) += restart-poweroff.o
 obj-$(CONFIG_POWER_RESET_VEXPRESS) += vexpress-poweroff.o
 obj-$(CONFIG_POWER_RESET_XGENE) += xgene-reboot.o
+obj-$(CONFIG_POWER_RESET_SYSCON) += syscon-reboot.o
diff --git a/drivers/power/reset/syscon-reboot.c b/drivers/power/reset/syscon-reboot.c
new file mode 100644
index 0000000..29ed908
--- /dev/null
+++ b/drivers/power/reset/syscon-reboot.c
@@ -0,0 +1,100 @@
+/*
+ * Generic Syscon Reboot Driver
+ *
+ * Copyright (c) 2013, Applied Micro Circuits Corporation
+ * Author: Feng Kan <fkan@apm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ * This driver provides system reboot functionality for APM X-Gene SoC.
+ * For system shutdown, this is board specify. If a board designer
+ * implements GPIO shutdown, use the gpio-poweroff.c driver.
+ */
+#include <linux/io.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/stat.h>
+#include <linux/slab.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+#include <linux/reboot.h>
+#include <asm/system_misc.h>
+
+struct syscon_reboot_context {
+	struct regmap *map;
+	u32 offset;
+	u32 mask;
+};
+
+static struct syscon_reboot_context *syscon_reboot_ctx;
+
+static void syscon_restart(enum reboot_mode reboot_mode, const char *cmd)
+{
+	struct syscon_reboot_context *ctx = syscon_reboot_ctx;
+	unsigned long timeout;
+
+	/* Issue the reboot */
+	if (ctx->map)
+		regmap_write(ctx->map, ctx->offset, ctx->mask);
+
+	timeout = jiffies + HZ;
+	while (time_before(jiffies, timeout))
+		cpu_relax();
+
+	pr_emerg("Unable to restart system\n");
+}
+
+static int syscon_reboot_probe(struct platform_device *pdev)
+{
+	struct syscon_reboot_context *ctx;
+	struct device *dev = &pdev->dev;
+
+	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		dev_err(&pdev->dev, "out of memory for context\n");
+		return -ENOMEM;
+	}
+
+	ctx->map = syscon_regmap_lookup_by_phandle(dev->of_node, "regmap");
+	if (IS_ERR(ctx->map))
+		return PTR_ERR(ctx->map);
+
+	if (of_property_read_u32(pdev->dev.of_node, "offset", &ctx->offset))
+		return -EINVAL;
+
+	if (of_property_read_u32(pdev->dev.of_node, "mask", &ctx->mask))
+		return -EINVAL;
+
+	arm_pm_restart = syscon_restart;
+	syscon_reboot_ctx = ctx;
+
+	return 0;
+}
+
+static struct of_device_id syscon_reboot_of_match[] = {
+	{ .compatible = "syscon-reboot" },
+	{}
+};
+
+static struct platform_driver syscon_reboot_driver = {
+	.probe = syscon_reboot_probe,
+	.driver = {
+		.name = "syscon-reboot",
+		.of_match_table = syscon_reboot_of_match,
+	},
+};
+module_platform_driver(syscon_reboot_driver);
-- 
1.7.6.1

