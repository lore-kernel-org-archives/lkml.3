Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaHACpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 22:45:07 -0400
Received: from exprod5og118.obsmtp.com ([64.18.0.160]:39853 "HELO
	exprod5og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751774AbaHACpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 22:45:02 -0400
From: Feng Kan <fkan@apm.com>
To: linux@roeck-us.net, dbaryshkov@gmail.com, catalin.marinas@arm.com,
        dwmw2@infradead.org, arnd@arndb.de, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@apm.com
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V9 1/6] power: reset: Add generic SYSCON register mapped reset
Date: Thu, 31 Jul 2014 19:45:52 -0700
Message-Id: <1406861157-29169-2-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406861157-29169-1-git-send-email-fkan@apm.com>
References: <1406861157-29169-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a generic SYSCON register mapped reset mechanism.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 drivers/power/reset/Kconfig         |  5 ++
 drivers/power/reset/Makefile        |  1 +
 drivers/power/reset/syscon-reboot.c | 98 +++++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+)
 create mode 100644 drivers/power/reset/syscon-reboot.c

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index bdcf517..fd5f9e5 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -80,3 +80,8 @@ config POWER_RESET_KEYSTONE
 	help
 	  Reboot support for the KEYSTONE SoCs.
 
+config POWER_RESET_SYSCON
+	bool "Generic SYSCON regmap reset driver"
+	depends on POWER_RESET && MFD_SYSCON && OF
+	help
+	  Reboot support for generic SYSCON mapped register reset.
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index dde2e8b..b1b5ab3 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_POWER_RESET_SUN6I) += sun6i-reboot.o
 obj-$(CONFIG_POWER_RESET_VEXPRESS) += vexpress-poweroff.o
 obj-$(CONFIG_POWER_RESET_XGENE) += xgene-reboot.o
 obj-$(CONFIG_POWER_RESET_KEYSTONE) += keystone-reset.o
+obj-$(CONFIG_POWER_RESET_SYSCON) += syscon-reboot.o
diff --git a/drivers/power/reset/syscon-reboot.c b/drivers/power/reset/syscon-reboot.c
new file mode 100644
index 0000000..75d6eae
--- /dev/null
+++ b/drivers/power/reset/syscon-reboot.c
@@ -0,0 +1,98 @@
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
+ */
+#include <linux/io.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/notifier.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+#include <linux/reboot.h>
+
+struct syscon_reboot_context {
+	struct regmap *map;
+	u32 offset;
+	u32 mask;
+	struct notifier_block restart_handler;
+};
+
+static struct syscon_reboot_context *syscon_reboot_ctx;
+
+static int syscon_restart_handle(struct notifier_block *this,
+					unsigned long mode, void *cmd)
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
+	return NOTIFY_DONE;
+}
+
+static int syscon_reboot_probe(struct platform_device *pdev)
+{
+	struct syscon_reboot_context *ctx;
+	struct device *dev = &pdev->dev;
+	int err;
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
+	ctx->restart_handler.notifier_call = syscon_restart_handle;
+	ctx->restart_handler.priority = 128;
+	err = register_restart_handler(&ctx->restart_handler);
+	if (err)
+		dev_err(dev, "can't register restart notifier (err=%d)\n", err);
+
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
1.9.1

