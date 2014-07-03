Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbaGCOVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:21:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51001 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758669AbaGCOUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:20:46 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 06/18] power: reset: Add AT91 reset driver
Date: Thu,  3 Jul 2014 16:14:42 +0200
Message-Id: <1404396906-25194-10-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the reset behaviour of the various AT91 SoCS in drivers/power/reset.

It used to be (and still is) located in arch/arm/mach-at91, and in order to
preserve bisectability is not removed yet, but every board should be converted
to use this driver instead.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/power/reset/Kconfig      |   7 ++
 drivers/power/reset/Makefile     |   1 +
 drivers/power/reset/at91-reset.c | 202 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 210 insertions(+)
 create mode 100644 drivers/power/reset/at91-reset.c

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 19d546c5edfa..b3fef01d7cbb 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -14,6 +14,13 @@ config POWER_RESET_AS3722
 	help
 	  This driver supports turning off board via a ams AS3722 power-off.
 
+config POWER_RESET_AT91_RESET
+	bool "Atmel AT91 reset driver"
+	default SOC_AT91SAM9 || SOC_SAMA5
+	help
+	  This driver supports restart for Atmel AT91SAM9 and SAMA5
+	  SoCs
+
 config POWER_RESET_AXXIA
 	bool "LSI Axxia reset driver"
 	depends on ARCH_AXXIA
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index dde2e8bbac53..1599214b91d9 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_POWER_RESET_AS3722) += as3722-poweroff.o
+obj-$(CONFIG_POWER_RESET_AT91_RESET) += at91-reset.o
 obj-$(CONFIG_POWER_RESET_AXXIA) += axxia-reset.o
 obj-$(CONFIG_POWER_RESET_GPIO) += gpio-poweroff.o
 obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
diff --git a/drivers/power/reset/at91-reset.c b/drivers/power/reset/at91-reset.c
new file mode 100644
index 000000000000..878547410acb
--- /dev/null
+++ b/drivers/power/reset/at91-reset.c
@@ -0,0 +1,202 @@
+/*
+ * Atmel AT91 SAM9 SoCs reset code
+ *
+ * Copyright (C) 2014 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/reboot.h>
+
+#include <asm/system_misc.h>
+
+#include <mach/at91sam9_ddrsdr.h>
+#include <mach/at91sam9_sdramc.h>
+
+#define AT91_RSTC_CR	0x00		/* Reset Controller Control Register */
+#define	AT91_RSTC_PROCRST	BIT(0)		/* Processor Reset */
+#define	AT91_RSTC_PERRST	BIT(2)		/* Peripheral Reset */
+#define	AT91_RSTC_EXTRST	BIT(3)		/* External Reset */
+#define	AT91_RSTC_KEY		(0xa5 << 24)	/* KEY Password */
+
+#define AT91_RSTC_SR	0x04		/* Reset Controller Status Register */
+#define	AT91_RSTC_URSTS		BIT(0)		/* User Reset Status */
+#define	AT91_RSTC_RSTTYP	GENMASK(10, 8)	/* Reset Type */
+#define	AT91_RSTC_NRSTL		BIT(16)		/* NRST Pin Level */
+#define	AT91_RSTC_SRCMP		BIT(17)		/* Software Reset Command in Progress */
+
+#define AT91_RSTC_MR	0x08		/* Reset Controller Mode Register */
+#define	AT91_RSTC_URSTEN	BIT(0)		/* User Reset Enable */
+#define	AT91_RSTC_URSTIEN	BIT(4)		/* User Reset Interrupt Enable */
+#define	AT91_RSTC_ERSTL		GENMASK(11, 8)	/* External Reset Length */
+
+enum reset_type {
+	RESET_TYPE_GENERAL	= 0,
+	RESET_TYPE_WAKEUP	= 1,
+	RESET_TYPE_WATCHDOG	= 2,
+	RESET_TYPE_SOFTWARE	= 3,
+	RESET_TYPE_USER		= 4,
+};
+
+static void __iomem *at91_ramc_base[2], *at91_rstc_base;
+
+static void at91sam9_restart(enum reboot_mode mode, const char *cmd)
+{
+	asm volatile(
+		".balign 32\n\t"
+
+		"str	%2, [%0, #" __stringify(AT91_SDRAMC_TR) "]\n\t"
+		"str	%3, [%0, #" __stringify(AT91_SDRAMC_LPR) "]\n\t"
+		"str	%4, [%1, #" __stringify(AT91_RSTC_CR) "]\n\t"
+
+		"b	.\n\t"
+		:
+		: "r" (at91_ramc_base[0]),
+		  "r" (at91_rstc_base),
+		  "r" (1),
+		  "r" (AT91_SDRAMC_LPCB_POWER_DOWN),
+		  "r" (AT91_RSTC_KEY | AT91_RSTC_PERRST | AT91_RSTC_PROCRST));
+}
+
+static void at91sam9g45_restart(enum reboot_mode mode, const char *cmd)
+{
+	asm volatile(
+		"cmp	%1, #0\n\t"
+		"beq	1f\n\t"
+
+		"ldr	r0, [%1]\n\t"
+		"cmp	r0, #0\n\t"
+
+		".balign 32\n\t"
+
+		"1:	str	%3, [%0, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
+		"	str	%4, [%0, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
+		"	strne	%3, [%1, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
+		"	strne	%4, [%1, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
+		"	str	%5, [%2, #" __stringify(AT91_RSTC_CR) "]\n\t"
+
+		"	b	.\n\t"
+		:
+		: "r" (at91_ramc_base[0]),
+		  "r" (at91_ramc_base[1]),
+		  "r" (at91_rstc_base),
+		  "r" (1),
+		  "r" (AT91_DDRSDRC_LPCB_POWER_DOWN),
+		  "r" (AT91_RSTC_KEY | AT91_RSTC_PERRST | AT91_RSTC_PROCRST)
+		: "r0");
+}
+
+static void __init at91_reset_status(struct platform_device *pdev)
+{
+	u32 reg = readl(at91_rstc_base + AT91_RSTC_SR);
+	char *reason;
+
+	switch ((reg & AT91_RSTC_RSTTYP) >> 8) {
+	case RESET_TYPE_GENERAL:
+		reason = "general reset";
+		break;
+	case RESET_TYPE_WAKEUP:
+		reason = "wakeup";
+		break;
+	case RESET_TYPE_WATCHDOG:
+		reason = "watchdog reset";
+		break;
+	case RESET_TYPE_SOFTWARE:
+		reason = "software reset";
+		break;
+	case RESET_TYPE_USER:
+		reason = "user reset";
+		break;
+	default:
+		reason = "unknown reset";
+		break;
+	}
+
+	pr_info("AT91: Starting after %s\n", reason);
+}
+
+static struct of_device_id at91_ramc_of_match[] = {
+	{ .compatible = "atmel,at91sam9260-sdramc", },
+	{ .compatible = "atmel,at91sam9g45-ddramc", },
+	{ /* sentinel */ }
+};
+
+static struct of_device_id at91_reset_of_match[] = {
+	{ .compatible = "atmel,at91sam9260-rstc", .data = at91sam9_restart },
+	{ .compatible = "atmel,at91sam9g45-rstc", .data = at91sam9g45_restart },
+	{ /* sentinel */ }
+};
+
+static int at91_reset_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	at91_rstc_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(at91_rstc_base)) {
+		dev_err(&pdev->dev, "Could not map reset controller address\n");
+		return PTR_ERR(at91_rstc_base);
+	}
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		struct device_node *np;
+		int idx = 0;
+
+		for_each_matching_node(np, at91_ramc_of_match) {
+			at91_ramc_base[idx] = of_iomap(np, 0);
+			if (!at91_ramc_base[idx]) {
+				dev_err(&pdev->dev, "Could not map ram controller address\n");
+				return -ENODEV;
+			}
+			idx++;
+		}
+
+		match = of_match_node(at91_reset_of_match, pdev->dev.of_node);
+		arm_pm_restart = match->data;
+	} else {
+		const struct platform_device_id *match;
+		int idx = 0;
+
+		for (idx = 0; idx < 2; idx++) {
+			res = platform_get_resource(pdev, IORESOURCE_MEM, idx + 1 );
+			at91_ramc_base[idx] = devm_ioremap_resource(&pdev->dev, res);
+			if (IS_ERR(at91_ramc_base[idx])) {
+				dev_err(&pdev->dev, "Could not map ram controller address\n");
+				return PTR_ERR(at91_rstc_base);
+			}
+		}
+
+		match = platform_get_device_id(pdev);
+		arm_pm_restart = (void (*)(enum reboot_mode, const char*))
+			match->driver_data;
+	}
+
+	at91_reset_status(pdev);
+
+	return 0;
+}
+
+static struct platform_device_id at91_reset_plat_match[] = {
+	{ "at91-sam9-reset", (unsigned long)at91sam9_restart },
+	{ "at91-g45-reset", (unsigned long)at91sam9g45_restart },
+	{ /* sentinel */ }
+};
+
+static struct platform_driver at91_reset_driver = {
+	.probe = at91_reset_probe,
+	.driver = {
+		.name = "at91-reset",
+		.of_match_table = at91_reset_of_match,
+	},
+	.id_table = at91_reset_plat_match,
+};
+module_platform_driver(at91_reset_driver);
-- 
2.0.1

