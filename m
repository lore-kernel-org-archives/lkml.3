Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbaAWTYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:24:12 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:47306 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932139AbaAWTYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:24:09 -0500
From: Feng Kan <fkan@apm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V4 2/5] power: reset: Remove X-Gene reboot driver
Date: Thu, 23 Jan 2014 11:19:58 -0800
Message-Id: <1390504801-24483-3-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1390504801-24483-1-git-send-email-fkan@apm.com>
References: <1390504801-24483-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove X-Gene reboot driver.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 drivers/power/reset/Kconfig        |    7 ---
 drivers/power/reset/Makefile       |    1 -
 drivers/power/reset/xgene-reboot.c |  103 ------------------------------------
 3 files changed, 0 insertions(+), 111 deletions(-)
 delete mode 100644 drivers/power/reset/xgene-reboot.c

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 4501c02..13a5191 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -45,13 +45,6 @@ config POWER_RESET_VEXPRESS
 	  Power off and reset support for the ARM Ltd. Versatile
 	  Express boards.
 
-config POWER_RESET_XGENE
-	bool "APM SoC X-Gene reset driver"
-	depends on ARM64
-	depends on POWER_RESET
-	help
-	  Reboot support for the APM SoC X-Gene Eval boards.
-
 config POWER_RESET_SYSCON
 	bool "Generic SYSCON regmap reset driver"
 	depends on MFD_SYSCON
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index f2c0327..a3137ff 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -3,5 +3,4 @@ obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
 obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
 obj-$(CONFIG_POWER_RESET_RESTART) += restart-poweroff.o
 obj-$(CONFIG_POWER_RESET_VEXPRESS) += vexpress-poweroff.o
-obj-$(CONFIG_POWER_RESET_XGENE) += xgene-reboot.o
 obj-$(CONFIG_POWER_RESET_SYSCON) += syscon-reboot.o
diff --git a/drivers/power/reset/xgene-reboot.c b/drivers/power/reset/xgene-reboot.c
deleted file mode 100644
index ecd55f8..0000000
--- a/drivers/power/reset/xgene-reboot.c
+++ /dev/null
@@ -1,103 +0,0 @@
-/*
- * AppliedMicro X-Gene SoC Reboot Driver
- *
- * Copyright (c) 2013, Applied Micro Circuits Corporation
- * Author: Feng Kan <fkan@apm.com>
- * Author: Loc Ho <lho@apm.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of
- * the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
- * MA 02111-1307 USA
- *
- * This driver provides system reboot functionality for APM X-Gene SoC.
- * For system shutdown, this is board specify. If a board designer
- * implements GPIO shutdown, use the gpio-poweroff.c driver.
- */
-#include <linux/io.h>
-#include <linux/of_device.h>
-#include <linux/of_address.h>
-#include <linux/platform_device.h>
-#include <linux/stat.h>
-#include <linux/slab.h>
-#include <asm/system_misc.h>
-
-struct xgene_reboot_context {
-	struct platform_device *pdev;
-	void *csr;
-	u32 mask;
-};
-
-static struct xgene_reboot_context *xgene_restart_ctx;
-
-static void xgene_restart(char str, const char *cmd)
-{
-	struct xgene_reboot_context *ctx = xgene_restart_ctx;
-	unsigned long timeout;
-
-	/* Issue the reboot */
-	if (ctx)
-		writel(ctx->mask, ctx->csr);
-
-	timeout = jiffies + HZ;
-	while (time_before(jiffies, timeout))
-		cpu_relax();
-
-	dev_emerg(&ctx->pdev->dev, "Unable to restart system\n");
-}
-
-static int xgene_reboot_probe(struct platform_device *pdev)
-{
-	struct xgene_reboot_context *ctx;
-
-	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
-	if (!ctx) {
-		dev_err(&pdev->dev, "out of memory for context\n");
-		return -ENODEV;
-	}
-
-	ctx->csr = of_iomap(pdev->dev.of_node, 0);
-	if (!ctx->csr) {
-		devm_kfree(&pdev->dev, ctx);
-		dev_err(&pdev->dev, "can not map resource\n");
-		return -ENODEV;
-	}
-
-	if (of_property_read_u32(pdev->dev.of_node, "mask", &ctx->mask))
-		ctx->mask = 0xFFFFFFFF;
-
-	ctx->pdev = pdev;
-	arm_pm_restart = xgene_restart;
-	xgene_restart_ctx = ctx;
-
-	return 0;
-}
-
-static struct of_device_id xgene_reboot_of_match[] = {
-	{ .compatible = "apm,xgene-reboot" },
-	{}
-};
-
-static struct platform_driver xgene_reboot_driver = {
-	.probe = xgene_reboot_probe,
-	.driver = {
-		.name = "xgene-reboot",
-		.of_match_table = xgene_reboot_of_match,
-	},
-};
-
-static int __init xgene_reboot_init(void)
-{
-	return platform_driver_register(&xgene_reboot_driver);
-}
-device_initcall(xgene_reboot_init);
-- 
1.7.6.1

