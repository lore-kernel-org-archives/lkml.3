Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbbAYSOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:14:45 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:52407 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957AbbAYSOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:14:40 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/6] power/reset: Remove sun6i reboot driver
Date: Sun, 25 Jan 2015 10:13:39 -0800
Message-Id: <1422209622-31994-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422209622-31994-1-git-send-email-linux@roeck-us.net>
References: <1422209622-31994-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54C53290.00B7,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 31
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sun6i restart is now handled by its watchdog driver directly,
so this driver is no longer needed.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/power/reset/Kconfig        |  6 ---
 drivers/power/reset/Makefile       |  1 -
 drivers/power/reset/sun6i-reboot.c | 85 --------------------------------------
 3 files changed, 92 deletions(-)
 delete mode 100644 drivers/power/reset/sun6i-reboot.c

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 028e765..720a310 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -110,12 +110,6 @@ config POWER_RESET_RESTART
 	  Instead they restart, and u-boot holds the SoC until the
 	  user presses a key. u-boot then boots into Linux.
 
-config POWER_RESET_SUN6I
-	bool "Allwinner A31 SoC reset driver"
-	depends on ARCH_SUNXI
-	help
-	  Reboot support for the Allwinner A31 SoCs.
-
 config POWER_RESET_ST
 	bool "ST restart power-off driver"
 	depends on ARCH_STI
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index 1d4804d..2f5e549 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -11,7 +11,6 @@ obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
 obj-$(CONFIG_POWER_RESET_LTC2952) += ltc2952-poweroff.o
 obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
 obj-$(CONFIG_POWER_RESET_RESTART) += restart-poweroff.o
-obj-$(CONFIG_POWER_RESET_SUN6I) += sun6i-reboot.o
 obj-$(CONFIG_POWER_RESET_ST) += st-poweroff.o
 obj-$(CONFIG_POWER_RESET_VERSATILE) += arm-versatile-reboot.o
 obj-$(CONFIG_POWER_RESET_VEXPRESS) += vexpress-poweroff.o
diff --git a/drivers/power/reset/sun6i-reboot.c b/drivers/power/reset/sun6i-reboot.c
deleted file mode 100644
index af2cd7f..0000000
--- a/drivers/power/reset/sun6i-reboot.c
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
- * Allwinner A31 SoCs reset code
- *
- * Copyright (C) 2012-2014 Maxime Ripard
- *
- * Maxime Ripard <maxime.ripard@free-electrons.com>
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2.  This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-
-#include <linux/delay.h>
-#include <linux/io.h>
-#include <linux/module.h>
-#include <linux/of_address.h>
-#include <linux/platform_device.h>
-#include <linux/reboot.h>
-
-#include <asm/system_misc.h>
-
-#define SUN6I_WATCHDOG1_IRQ_REG		0x00
-#define SUN6I_WATCHDOG1_CTRL_REG	0x10
-#define SUN6I_WATCHDOG1_CTRL_RESTART		BIT(0)
-#define SUN6I_WATCHDOG1_CONFIG_REG	0x14
-#define SUN6I_WATCHDOG1_CONFIG_RESTART		BIT(0)
-#define SUN6I_WATCHDOG1_CONFIG_IRQ		BIT(1)
-#define SUN6I_WATCHDOG1_MODE_REG	0x18
-#define SUN6I_WATCHDOG1_MODE_ENABLE		BIT(0)
-
-static void __iomem *wdt_base;
-
-static void sun6i_wdt_restart(enum reboot_mode mode, const char *cmd)
-{
-	if (!wdt_base)
-		return;
-
-	/* Disable interrupts */
-	writel(0, wdt_base + SUN6I_WATCHDOG1_IRQ_REG);
-
-	/* We want to disable the IRQ and just reset the whole system */
-	writel(SUN6I_WATCHDOG1_CONFIG_RESTART,
-		wdt_base + SUN6I_WATCHDOG1_CONFIG_REG);
-
-	/* Enable timer. The default and lowest interval value is 0.5s */
-	writel(SUN6I_WATCHDOG1_MODE_ENABLE,
-		wdt_base + SUN6I_WATCHDOG1_MODE_REG);
-
-	/* Restart the watchdog. */
-	writel(SUN6I_WATCHDOG1_CTRL_RESTART,
-		wdt_base + SUN6I_WATCHDOG1_CTRL_REG);
-
-	while (1) {
-		mdelay(5);
-		writel(SUN6I_WATCHDOG1_MODE_ENABLE,
-			wdt_base + SUN6I_WATCHDOG1_MODE_REG);
-	}
-}
-
-static int sun6i_reboot_probe(struct platform_device *pdev)
-{
-	wdt_base = of_iomap(pdev->dev.of_node, 0);
-	if (!wdt_base) {
-		WARN(1, "failed to map watchdog base address");
-		return -ENODEV;
-	}
-
-	arm_pm_restart = sun6i_wdt_restart;
-
-	return 0;
-}
-
-static struct of_device_id sun6i_reboot_of_match[] = {
-	{ .compatible = "allwinner,sun6i-a31-wdt" },
-	{}
-};
-
-static struct platform_driver sun6i_reboot_driver = {
-	.probe = sun6i_reboot_probe,
-	.driver = {
-		.name = "sun6i-reboot",
-		.of_match_table = sun6i_reboot_of_match,
-	},
-};
-module_platform_driver(sun6i_reboot_driver);
-- 
2.1.0

