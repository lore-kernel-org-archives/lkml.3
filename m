Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaEVQpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:45:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46325 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbaEVQpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:45:49 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <lee.jones@linaro.org>,
        <santosh.shilimkar@ti.com>, <arnd@arndb.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <grant.likely@linaro.org>
CC: <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <m-karicheri2@ti.com>,
        <sergei.shtylyov@cogentembedded.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [Patch v6 1/7] power: reset: keystone-reset: introduce keystone reset driver
Date: Thu, 22 May 2014 19:44:16 +0300
Message-ID: <1400777062-19276-2-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400777062-19276-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1400777062-19276-1-git-send-email-ivan.khoronzhuk@ti.com>
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

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/power/reset/Kconfig          |   8 ++
 drivers/power/reset/Makefile         |   1 +
 drivers/power/reset/keystone-reset.c | 166 +++++++++++++++++++++++++++++++++++
 3 files changed, 175 insertions(+)
 create mode 100644 drivers/power/reset/keystone-reset.c

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index fa0e4e0..d095e5b 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -57,3 +57,11 @@ config POWER_RESET_XGENE
 	depends on POWER_RESET
 	help
 	  Reboot support for the APM SoC X-Gene Eval boards.
+
+config POWER_RESET_KEYSTONE
+	bool "Keystone reset driver"
+	depends on ARCH_KEYSTONE
+	select MFD_SYSCON
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
index 0000000..ab96bd5
--- /dev/null
+++ b/drivers/power/reset/keystone-reset.c
@@ -0,0 +1,166 @@
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
+#include <linux/regmap.h>
+#include <asm/system_misc.h>
+#include <linux/mfd/syscon.h>
+#include <linux/of_platform.h>
+
+#define RSTYPE_RG			0x0
+#define RSCTRL_RG			0x4
+#define RSCFG_RG			0x8
+#define RSISO_RG			0xc
+
+#define RSCTRL_KEY_MASK			0x0000ffff
+#define RSCTRL_RESET_MASK		BIT(16)
+#define RSCTRL_KEY			0x5a69
+
+#define RSMUX_OMODE_MASK		0xe
+#define RSMUX_OMODE_RESET_ON		0xa
+#define RSMUX_OMODE_RESET_OFF		0x0
+#define RSMUX_LOCK_MASK			0x1
+#define RSMUX_LOCK_SET			0x1
+
+#define RSCFG_RSTYPE_SOFT		0x300f
+#define RSCFG_RSTYPE_HARD		0x0
+
+#define WDT_MUX_NUMBER			0x4
+
+static int rspll_offset;
+static struct regmap *pllctrl_regs;
+
+/**
+ * rsctrl_enable_rspll_write - enable access to RSCTRL, RSCFG
+ * To be able to access to RSCTRL, RSCFG registers
+ * we have to write a key before
+ */
+static inline int rsctrl_enable_rspll_write(void)
+{
+	return regmap_update_bits(pllctrl_regs, rspll_offset + RSCTRL_RG,
+				  RSCTRL_KEY_MASK, RSCTRL_KEY);
+}
+
+static void rsctrl_restart(enum reboot_mode mode, const char *cmd)
+{
+	/* enable write access to RSTCTRL */
+	rsctrl_enable_rspll_write();
+
+	/* reset the SOC */
+	regmap_update_bits(pllctrl_regs, rspll_offset + RSCTRL_RG,
+			   RSCTRL_RESET_MASK, 0);
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
+	unsigned int rg;
+	u32 rsmux_offset;
+	struct regmap *devctrl_regs;
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+
+	if (!np)
+		return -ENODEV;
+
+	/* get regmaps */
+	pllctrl_regs = syscon_regmap_lookup_by_phandle(np, "ti,syscon-pll");
+	if (IS_ERR(pllctrl_regs))
+		return PTR_ERR(pllctrl_regs);
+
+	devctrl_regs = syscon_regmap_lookup_by_phandle(np, "ti,syscon-dev");
+	if (IS_ERR(devctrl_regs))
+		return PTR_ERR(devctrl_regs);
+
+	ret = of_property_read_u32_index(np, "ti,syscon-pll", 1, &rspll_offset);
+	if (ret) {
+		dev_err(dev, "couldn't read the reset pll offset!\n");
+		return -EINVAL;
+	}
+
+	ret = of_property_read_u32_index(np, "ti,syscon-dev", 1, &rsmux_offset);
+	if (ret) {
+		dev_err(dev, "couldn't read the rsmux offset!\n");
+		return -EINVAL;
+	}
+
+	/* set soft/hard reset */
+	val = of_property_read_bool(np, "ti,soft-reset");
+	val = val ? RSCFG_RSTYPE_SOFT : RSCFG_RSTYPE_HARD;
+
+	ret = rsctrl_enable_rspll_write();
+	if (ret)
+		return ret;
+
+	ret = regmap_write(pllctrl_regs, rspll_offset + RSCFG_RG, val);
+	if (ret)
+		return ret;
+
+	arm_pm_restart = rsctrl_restart;
+
+	/* disable a reset isolation for all module clocks */
+	ret = regmap_write(pllctrl_regs, rspll_offset + RSISO_RG, 0);
+	if (ret)
+		return ret;
+
+	/* enable a reset for watchdogs from wdt_list */
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
+		rg = rsmux_offset + val * 4;
+
+		ret = regmap_update_bits(devctrl_regs, rg, RSMUX_OMODE_MASK,
+					 RSMUX_OMODE_RESET_ON |
+					 RSMUX_LOCK_SET);
+		if (ret)
+			return ret;
+	}
+
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

