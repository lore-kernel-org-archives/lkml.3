Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbaESK3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:29:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60879 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbaESK1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:27:14 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <santosh.shilimkar@ti.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <grant.likely@linaro.org>
CC: <arnd@arndb.de>, <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [Patch v3 1/5] Power: reset: keystone-reset: introduce keystone reset driver
Date: Mon, 19 May 2014 13:25:51 +0300
Message-ID: <1400495155-11136-2-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400495155-11136-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1400495155-11136-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The keystone SoC can be rebooted in several ways. By external reset
pin, by soft and by watchdogs. To allow keystone SoC reset if
watchdog is triggered we have to enable it in reset mux configuration
register regarding of watchdog configuration. Also we need to set
soft/hard reset we are going to use.

So add keystone reset driver to handle all this stuff.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/power/reset/Kconfig          |   7 ++
 drivers/power/reset/Makefile         |   1 +
 drivers/power/reset/keystone-reset.c | 171 +++++++++++++++++++++++++++++++++++
 3 files changed, 179 insertions(+)
 create mode 100644 drivers/power/reset/keystone-reset.c

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index fa0e4e0..4d2d3d8 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -57,3 +57,10 @@ config POWER_RESET_XGENE
 	depends on POWER_RESET
 	help
 	  Reboot support for the APM SoC X-Gene Eval boards.
+
+config POWER_RESET_KEYSTONE
+	bool "Keystone reset driver"
+	depends on ARCH_KEYSTONE
+	help
+	  Reboot support for the KEYSTONE SoCs.
+
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index a5b4a77..802a420 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
 obj-$(CONFIG_POWER_RESET_RESTART) += restart-poweroff.o
 obj-$(CONFIG_POWER_RESET_VEXPRESS) += vexpress-poweroff.o
 obj-$(CONFIG_POWER_RESET_XGENE) += xgene-reboot.o
+obj-$(CONFIG_POWER_RESET_KEYSTONE) += keystone-reset.o
diff --git a/drivers/power/reset/keystone-reset.c b/drivers/power/reset/keystone-reset.c
new file mode 100644
index 0000000..3e44040
--- /dev/null
+++ b/drivers/power/reset/keystone-reset.c
@@ -0,0 +1,171 @@
+/*
+ * TI keystone reboot driver
+ *
+ * Copyright (C) 2014 Texas Instruments Incorporated. http://www.ti.com/
+ *
+ * Author: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/reboot.h>
+#include <asm/system_misc.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+
+#define RSTYPE_RG			0x0
+#define RSCTRL_RG			0x4
+#define RSCFG_RG			0x8
+#define RSISO_RG			0xc
+
+#define RSCTRL_KEY_MASK			0xffff0000
+#define RSCTRL_KEY			0x5a69
+#define RSCTRL_RESET			BIT(16)
+
+#define RSMUX_OMODE_MASK		0xe
+#define RSMUX_OMODE_RESET_SOC		0xa
+#define RSMUX_OMODE_RESET_OFF		0x0
+#define RSMUX_LOCK_MASK			0x1
+#define RSMUX_LOCK_SET			0x1
+
+#define RSCFG_RSTYPE_SOFT		0x300f
+#define RSCFG_RSTYPE_HARD		0x0
+
+#define WDT_MUX_NUMBER			0x4
+
+static void __iomem *rspll_base;
+
+/**
+ * rsctrl_enable_rspll_write - enable access to RSCTRL, RSCFG
+ * To be able to access to RSCTRL, RSCFG registers
+ * we have to write a key before
+ */
+static void rsctrl_enable_rspll_write(void)
+{
+	u32 val;
+	void __iomem *rstctrl_rg;
+
+	rstctrl_rg = rspll_base + RSCTRL_RG;
+	val = readl(rstctrl_rg);
+	val &= RSCTRL_KEY_MASK;
+	val |= RSCTRL_KEY;
+	writel(val, rstctrl_rg);
+}
+
+static void rsctrl_restart(enum reboot_mode mode, const char *cmd)
+{
+	u32 val;
+	void __iomem *rstctrl;
+
+	/* enable write access to RSTCTRL */
+	rsctrl_enable_rspll_write();
+
+	/* reset the SOC */
+	rstctrl = rspll_base + RSCTRL_RG;
+	val = readl(rstctrl);
+	val &= ~RSCTRL_RESET;
+	writel(val, rstctrl);
+}
+
+static struct of_device_id rsctrl_of_match[] = {
+	{.compatible = "ti,keystone-reset", },
+	{},
+};
+
+static int rsctrl_probe(struct platform_device *pdev)
+{
+	int i;
+	int ret;
+	u32 val;
+	void __iomem *rg;
+	struct resource *res;
+	void __iomem *rsmux_base;
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+
+	if (!np)
+		return -ENODEV;
+
+	i = of_property_match_string(np, "reg-names", "pllregs");
+	res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+	rspll_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(rspll_base))
+		return PTR_ERR(rspll_base);
+
+	i = of_property_match_string(np, "reg-names", "muxregs");
+	res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+	rsmux_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(rsmux_base))
+		return PTR_ERR(rsmux_base);
+
+	/* set soft/hard reset */
+	val = of_property_read_bool(np, "ti,soft-reset");
+	val = val ? RSCFG_RSTYPE_SOFT : RSCFG_RSTYPE_HARD;
+
+	rsctrl_enable_rspll_write();
+	writel(val, rspll_base + RSCFG_RG);
+
+	arm_pm_restart = rsctrl_restart;
+
+	/* disable reset isolation for all module clocks */
+	writel(0, rspll_base + RSISO_RG);
+
+	/* enable reset for watchdogs from list */
+	for (i = 0; i < WDT_MUX_NUMBER; i++) {
+		ret = of_property_read_u32_index(np, "ti,wdt_list", i, &val);
+		if (ret == -EOVERFLOW && !i) {
+			dev_err(dev, "ti,wdt_list property has to contain at"
+				"least one entry\n");
+			return -EINVAL;
+		} else if (ret) {
+			break;
+		}
+
+		if (val >= WDT_MUX_NUMBER) {
+			dev_err(dev, "ti,wdt_list property can contain"
+				"only numbers < 4\n");
+			return -EINVAL;
+		}
+
+		rg = rsmux_base + val * 4;
+
+		val = readl(rg);
+		val &= ~RSMUX_OMODE_MASK;
+		val |= RSMUX_OMODE_RESET_SOC | RSMUX_LOCK_SET;
+		writel(val, rg);
+	}
+
+	/* disable reset for watchdogs from not list */
+	for (i = 0; i < WDT_MUX_NUMBER; i++) {
+		rg = rsmux_base + i * 4;
+
+		val = readl(rg);
+		if (!(val & RSMUX_LOCK_MASK)) {
+			val &= ~RSMUX_OMODE_MASK;
+			val |= RSMUX_OMODE_RESET_OFF | RSMUX_LOCK_SET;
+			writel(val, rg);
+		}
+	}
+
+	devm_iounmap(dev, rsmux_base);
+	return 0;
+}
+
+static struct platform_driver rsctrl_driver = {
+	.probe = rsctrl_probe,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = KBUILD_MODNAME,
+		.of_match_table = rsctrl_of_match,
+	},
+};
+module_platform_driver(rsctrl_driver);
+
+MODULE_AUTHOR("Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>");
+MODULE_DESCRIPTION("Texas Instruments keystone reset driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" KBUILD_MODNAME);
-- 
1.8.3.2

