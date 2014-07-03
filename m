Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbaGCOUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:20:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50923 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758381AbaGCOUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:20:17 -0400
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
Subject: [PATCH 11/18] power: reset: Add AT91 poweroff driver
Date: Thu,  3 Jul 2014 16:14:52 +0200
Message-Id: <1404396906-25194-20-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver to handle the shutdown of the Atmel SoCs. This code used to be
(and still is) in arch/arm/mach-at91. We didn't removed it yet so that we can
convert all the boards to using this driver, before removing it entirely in a
separate patch.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/power/reset/Kconfig         |   7 ++
 drivers/power/reset/Makefile        |   1 +
 drivers/power/reset/at91-poweroff.c | 156 ++++++++++++++++++++++++++++++++++++
 3 files changed, 164 insertions(+)
 create mode 100644 drivers/power/reset/at91-poweroff.c

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index b3fef01d7cbb..f9d53af50ec0 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -14,6 +14,13 @@ config POWER_RESET_AS3722
 	help
 	  This driver supports turning off board via a ams AS3722 power-off.
 
+config POWER_RESET_AT91_POWEROFF
+	bool "Atmel AT91 poweroff driver"
+	default SOC_AT91SAM9 || SOC_SAMA5
+	help
+	  This driver supports poweroff for Atmel AT91SAM9 and SAMA5
+	  SoCs
+
 config POWER_RESET_AT91_RESET
 	bool "Atmel AT91 reset driver"
 	default SOC_AT91SAM9 || SOC_SAMA5
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index 1599214b91d9..8bf941bac3da 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_POWER_RESET_AS3722) += as3722-poweroff.o
+obj-$(CONFIG_POWER_RESET_AT91_POWEROFF) += at91-poweroff.o
 obj-$(CONFIG_POWER_RESET_AT91_RESET) += at91-reset.o
 obj-$(CONFIG_POWER_RESET_AXXIA) += axxia-reset.o
 obj-$(CONFIG_POWER_RESET_GPIO) += gpio-poweroff.o
diff --git a/drivers/power/reset/at91-poweroff.c b/drivers/power/reset/at91-poweroff.c
new file mode 100644
index 000000000000..2f2a69e9bae3
--- /dev/null
+++ b/drivers/power/reset/at91-poweroff.c
@@ -0,0 +1,156 @@
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
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/printk.h>
+
+#define AT91_SHDW_CR	0x00		/* Shut Down Control Register */
+#define	AT91_SHDW_SHDW		BIT(0)			/* Shut Down command */
+#define	AT91_SHDW_KEY		(0xa5 << 24)		/* KEY Password */
+
+#define AT91_SHDW_MR	0x04		/* Shut Down Mode Register */
+#define	AT91_SHDW_WKMODE0	GENMASK(2, 0)		/* Wake-up 0 Mode Selection */
+#define	AT91_SHDW_CPTWK0_MAX	0xf			/* Maximum Counter On Wake Up 0 */
+#define	AT91_SHDW_CPTWK0	(AT91_SHDW_CPTWK0_MAX << 4) /* Counter On Wake Up 0 */
+#define	AT91_SHDW_CPTWK0_(x)	((x) << 4)
+#define	AT91_SHDW_RTTWKEN	BIT(16)			/* Real Time Timer Wake-up Enable */
+#define	AT91_SHDW_RTCWKEN	BIT(17)			/* Real Time Clock Wake-up Enable */
+
+#define AT91_SHDW_SR	0x08		/* Shut Down Status Register */
+#define	AT91_SHDW_WAKEUP0	BIT(0)			/* Wake-up 0 Status */
+#define	AT91_SHDW_RTTWK		BIT(16)			/* Real-time Timer Wake-up */
+#define	AT91_SHDW_RTCWK		BIT(17)			/* Real-time Clock Wake-up [SAM9RL] */
+
+enum wakeup_type {
+	AT91_SHDW_WKMODE0_NONE		= 0,
+	AT91_SHDW_WKMODE0_HIGH		= 1,
+	AT91_SHDW_WKMODE0_LOW		= 2,
+	AT91_SHDW_WKMODE0_ANYLEVEL	= 3,
+};
+
+static const char *shdwc_wakeup_modes[] = {
+	[AT91_SHDW_WKMODE0_NONE]	= "none",
+	[AT91_SHDW_WKMODE0_HIGH]	= "high",
+	[AT91_SHDW_WKMODE0_LOW]		= "low",
+	[AT91_SHDW_WKMODE0_ANYLEVEL]	= "any",
+};
+
+static void __iomem *at91_shdwc_base;
+
+static void __init at91_wakeup_status(void)
+{
+	u32 reg = readl(at91_shdwc_base);
+	char *reason = "unknown";
+
+	/* Simple power-on, just bail out */
+	if (!reg)
+		return;
+
+	if (reg & AT91_SHDW_RTTWK)
+		reason = "RTT";
+	else if (reg & AT91_SHDW_RTCWK)
+		reason = "RTC";
+
+	pr_info("AT91: Wake-Up source: %s\n", reason);
+}
+
+static void at91_poweroff(void)
+{
+	writel(AT91_SHDW_KEY | AT91_SHDW_SHDW, at91_shdwc_base + AT91_SHDW_CR);
+}
+
+const enum wakeup_type at91_poweroff_get_wakeup_mode(struct device_node *np)
+{
+	const char *pm;
+	int err, i;
+
+	err = of_property_read_string(np, "atmel,wakeup-mode", &pm);
+	if (err < 0)
+		return AT91_SHDW_WKMODE0_ANYLEVEL;
+
+	for (i = 0; i < ARRAY_SIZE(shdwc_wakeup_modes); i++)
+		if (!strcasecmp(pm, shdwc_wakeup_modes[i]))
+			return i;
+
+	return -ENODEV;
+}
+
+static void at91_poweroff_dt_set_wakeup_mode(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	enum wakeup_type wakeup_mode;
+	u32 mode = 0, tmp;
+
+	wakeup_mode = at91_poweroff_get_wakeup_mode(np);
+	if (wakeup_mode < 0) {
+		dev_warn(&pdev->dev, "shdwc unknown wakeup mode\n");
+		return;
+	}
+
+	if (!of_property_read_u32(np, "atmel,wakeup-counter", &tmp)) {
+		if (tmp > AT91_SHDW_CPTWK0_MAX) {
+			dev_warn(&pdev->dev,
+				 "shdwc wakeup counter 0x%x > 0x%x reduce it to 0x%x\n",
+				 tmp, AT91_SHDW_CPTWK0_MAX, AT91_SHDW_CPTWK0_MAX);
+			tmp = AT91_SHDW_CPTWK0_MAX;
+		}
+		mode |= AT91_SHDW_CPTWK0_(tmp);
+	}
+
+	if (of_property_read_bool(np, "atmel,wakeup-rtc-timer"))
+			mode |= AT91_SHDW_RTCWKEN;
+
+	if (of_property_read_bool(np, "atmel,wakeup-rtt-timer"))
+			mode |= AT91_SHDW_RTTWKEN;
+
+	writel(wakeup_mode | mode, at91_shdwc_base + AT91_SHDW_MR);
+}
+
+static int at91_poweroff_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	at91_shdwc_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(at91_shdwc_base)) {
+		dev_err(&pdev->dev, "Could not map reset controller address\n");
+		return PTR_ERR(at91_shdwc_base);
+	}
+
+	at91_wakeup_status();
+
+	if (pdev->dev.of_node)
+		at91_poweroff_dt_set_wakeup_mode(pdev);
+
+	pm_power_off = at91_poweroff;
+
+	return 0;
+}
+
+static struct of_device_id at91_poweroff_of_match[] = {
+	{ .compatible = "atmel,at91sam9260-shdwc", },
+	{ .compatible = "atmel,at91sam9rl-shdwc", },
+	{ .compatible = "atmel,at91sam9x5-shdwc", },
+	{ /*sentinel*/ }
+};
+
+static struct platform_driver at91_poweroff_driver = {
+	.probe = at91_poweroff_probe,
+	.driver = {
+		.name = "at91-poweroff",
+		.of_match_table = at91_poweroff_of_match,
+	},
+};
+module_platform_driver(at91_poweroff_driver);
-- 
2.0.1

