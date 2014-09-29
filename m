Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaI2Ooe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:44:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47867 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753247AbaI2Ooa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:44:30 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v6 01/11] mfd: add atmel-hlcdc driver
Date: Mon, 29 Sep 2014 16:44:14 +0200
Message-Id: <1412001864-3251-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412001864-3251-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1412001864-3251-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HLCDC IP available on some Atmel SoCs (i.e. at91sam9n12, at91sam9x5
family or sama5d3 family) exposes 2 subdevices:
- a display controller (controlled by a DRM driver)
- a PWM chip

The MFD device provides a regmap and several clocks (those connected
to this hardware block) to its subdevices.

This way concurrent accesses to the iomem range are handled by the regmap
framework, and each subdevice can safely access HLCDC registers.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
Tested-by: Anthony Harivel <anthony.harivel@emtrion.de>
Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
---
 drivers/mfd/Kconfig             |   6 ++
 drivers/mfd/Makefile            |   1 +
 drivers/mfd/atmel-hlcdc.c       | 118 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/atmel-hlcdc.h |  78 ++++++++++++++++++++++++++
 4 files changed, 203 insertions(+)
 create mode 100644 drivers/mfd/atmel-hlcdc.c
 create mode 100644 include/linux/mfd/atmel-hlcdc.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index de5abf2..1b925f7 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -59,6 +59,12 @@ config MFD_AAT2870_CORE
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
+config MFD_ATMEL_HLCDC
+	tristate
+	select MFD_CORE
+	select REGMAP_MMIO
+	depends on OF
+
 config MFD_BCM590XX
 	tristate "Broadcom BCM590xx PMUs"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index f001487..df36f68 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -156,6 +156,7 @@ obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o ssbi.o
 obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
 obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
 obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
+obj-$(CONFIG_MFD_ATMEL_HLCDC)	+= atmel-hlcdc.o
 obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
 obj-$(CONFIG_MFD_PALMAS)	+= palmas.o
 obj-$(CONFIG_MFD_VIPERBOARD)    += viperboard.o
diff --git a/drivers/mfd/atmel-hlcdc.c b/drivers/mfd/atmel-hlcdc.c
new file mode 100644
index 0000000..aadb371
--- /dev/null
+++ b/drivers/mfd/atmel-hlcdc.c
@@ -0,0 +1,118 @@
+/*
+ * Copyright (C) 2014 Free Electrons
+ * Copyright (C) 2014 Atmel
+ *
+ * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/clk.h>
+#include <linux/mfd/atmel-hlcdc.h>
+#include <linux/mfd/core.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+
+#define ATMEL_HLCDC_REG_MAX		(0x4000 - 0x4)
+
+static const struct mfd_cell atmel_hlcdc_cells[] = {
+	{
+		.name = "atmel-hlcdc-pwm",
+		.of_compatible = "atmel,hlcdc-pwm",
+	},
+	{
+		.name = "atmel-hlcdc-dc",
+		.of_compatible = "atmel,hlcdc-display-controller",
+	},
+};
+
+static const struct regmap_config atmel_hlcdc_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+	.max_register = ATMEL_HLCDC_REG_MAX,
+};
+
+static int atmel_hlcdc_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct atmel_hlcdc *hlcdc;
+	struct resource *res;
+	void __iomem *regs;
+
+	hlcdc = devm_kzalloc(dev, sizeof(*hlcdc), GFP_KERNEL);
+	if (!hlcdc)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
+
+	hlcdc->periph_clk = devm_clk_get(dev, "periph_clk");
+	if (IS_ERR(hlcdc->periph_clk)) {
+		dev_err(dev, "failed to get peripheral clock\n");
+		return PTR_ERR(hlcdc->periph_clk);
+	}
+
+	hlcdc->sys_clk = devm_clk_get(dev, "sys_clk");
+	if (IS_ERR(hlcdc->sys_clk)) {
+		dev_err(dev, "failed to get system clock\n");
+		return PTR_ERR(hlcdc->sys_clk);
+	}
+
+	hlcdc->slow_clk = devm_clk_get(dev, "slow_clk");
+	if (IS_ERR(hlcdc->slow_clk)) {
+		dev_err(dev, "failed to get slow clock\n");
+		return PTR_ERR(hlcdc->slow_clk);
+	}
+
+	hlcdc->regmap = devm_regmap_init_mmio(dev, regs,
+					      &atmel_hlcdc_regmap_config);
+	if (IS_ERR(hlcdc->regmap))
+		return PTR_ERR(hlcdc->regmap);
+
+	dev_set_drvdata(dev, hlcdc);
+
+	return mfd_add_devices(dev, -1, atmel_hlcdc_cells,
+			       ARRAY_SIZE(atmel_hlcdc_cells),
+			       NULL, 0, NULL);
+}
+
+static int atmel_hlcdc_remove(struct platform_device *pdev)
+{
+	mfd_remove_devices(&pdev->dev);
+
+	return 0;
+}
+
+static const struct of_device_id atmel_hlcdc_match[] = {
+	{ .compatible = "atmel,sama5d3-hlcdc" },
+	{ /* sentinel */ },
+};
+
+static struct platform_driver atmel_hlcdc_driver = {
+	.probe = atmel_hlcdc_probe,
+	.remove = atmel_hlcdc_remove,
+	.driver = {
+		.name = "atmel-hlcdc",
+		.of_match_table = atmel_hlcdc_match,
+	},
+};
+module_platform_driver(atmel_hlcdc_driver);
+
+MODULE_ALIAS("platform:atmel-hlcdc");
+MODULE_AUTHOR("Boris Brezillon <boris.brezillon@free-electrons.com>");
+MODULE_DESCRIPTION("Atmel HLCDC driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/atmel-hlcdc.h b/include/linux/mfd/atmel-hlcdc.h
new file mode 100644
index 0000000..e9a503d
--- /dev/null
+++ b/include/linux/mfd/atmel-hlcdc.h
@@ -0,0 +1,78 @@
+/*
+ * Copyright (C) 2014 Free Electrons
+ * Copyright (C) 2014 Atmel
+ *
+ * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __LINUX_MFD_HLCDC_H
+#define __LINUX_MFD_HLCDC_H
+
+#include <linux/clk.h>
+#include <linux/regmap.h>
+
+#define ATMEL_HLCDC_CFG(i)		((i) * 0x4)
+#define ATMEL_HLCDC_SIG_CFG		LCDCFG(5)
+#define ATMEL_HLCDC_HSPOL		BIT(0)
+#define ATMEL_HLCDC_VSPOL		BIT(1)
+#define ATMEL_HLCDC_VSPDLYS		BIT(2)
+#define ATMEL_HLCDC_VSPDLYE		BIT(3)
+#define ATMEL_HLCDC_DISPPOL		BIT(4)
+#define ATMEL_HLCDC_DITHER		BIT(6)
+#define ATMEL_HLCDC_DISPDLY		BIT(7)
+#define ATMEL_HLCDC_MODE_MASK		GENMASK(9, 8)
+#define ATMEL_HLCDC_PP			BIT(10)
+#define ATMEL_HLCDC_VSPSU		BIT(12)
+#define ATMEL_HLCDC_VSPHO		BIT(13)
+#define ATMEL_HLCDC_GUARDTIME_MASK	GENMASK(20, 16)
+
+#define ATMEL_HLCDC_EN			0x20
+#define ATMEL_HLCDC_DIS			0x24
+#define ATMEL_HLCDC_SR			0x28
+#define ATMEL_HLCDC_IER			0x2c
+#define ATMEL_HLCDC_IDR			0x30
+#define ATMEL_HLCDC_IMR			0x34
+#define ATMEL_HLCDC_ISR			0x38
+
+#define ATMEL_HLCDC_CLKPOL		BIT(0)
+#define ATMEL_HLCDC_CLKSEL		BIT(2)
+#define ATMEL_HLCDC_CLKPWMSEL		BIT(3)
+#define ATMEL_HLCDC_CGDIS(i)		BIT(8 + (i))
+#define ATMEL_HLCDC_CLKDIV_SHFT		16
+#define ATMEL_HLCDC_CLKDIV_MASK		GENMASK(23, 16)
+#define ATMEL_HLCDC_CLKDIV(div)		((div - 2) << ATMEL_HLCDC_CLKDIV_SHFT)
+
+#define ATMEL_HLCDC_PIXEL_CLK		BIT(0)
+#define ATMEL_HLCDC_SYNC		BIT(1)
+#define ATMEL_HLCDC_DISP		BIT(2)
+#define ATMEL_HLCDC_PWM			BIT(3)
+#define ATMEL_HLCDC_SIP			BIT(4)
+
+/**
+ * Structure shared by the MFD device and its subdevices.
+ *
+ * @regmap: register map used to access HLCDC IP registers
+ * @periph_clk: the hlcdc peripheral clock
+ * @sys_clk: the hlcdc system clock
+ * @slow_clk: the system slow clk
+ */
+struct atmel_hlcdc {
+	struct regmap *regmap;
+	struct clk *periph_clk;
+	struct clk *sys_clk;
+	struct clk *slow_clk;
+};
+
+#endif /* __LINUX_MFD_HLCDC_H */
-- 
1.9.1

