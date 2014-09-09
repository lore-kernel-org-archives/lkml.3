Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbaIIPnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:43:16 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:52028 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205AbaIIPnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:43:09 -0400
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pwm@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Roland Stigge <stigge@antcom.de>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH V3] pwm: lpc32xx - Add a driver for the motor PWM
Date: Tue,  9 Sep 2014 17:42:41 +0200
Message-Id: <1410277361-26848-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 2.1.0
X-Provags-ID: V02:K0:UZbmg5CffHhTTNXknirazOH8K3iOvSsvYPf9GJrNJRw
 suzHJKEgagqvNxmeOeZBbJX/XW9HcdIKxm7kceeJX/qlwSqGAn
 BICasIVXe6eIEK3njZSghJMV1P2QpcNx7wkGll6W9Ya/JPwHko
 /9X0G9Dexeoe81ZvXm16wHVzU83UDe8w1ftiBLcs8K1cD9pYYa
 GDQ0R5On/hmSwdKZ0rG7/4e/Eat61HEHgFq9FtMGC2OjMIb0hk
 XxtJ+T+lDlb1COeF7ENFjs/zXP3CVhpf2eK1Gqwdt47ODdd8fV
 lPXjQGdBB6od6ixJtXT5Fa0aecpOuEgGOPFeMY8o1OJx+e/BRE
 y1x8GaBcBnOzisMdADtLIOkz1n2Wjtf0Cgv9U/gRg+gP6jESJY
 JQgkcTakMMeIA0a4IFCH6AvGPKwgFhBn+3TmCjLswoC4lBN8Uj
 zDEWh
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LPC32xx motor PWMs have two output pin, A and B, with B = !A.
The driver can switch the polarity to allow use either output pin A
or output pin B.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
V3: * Updated to current mainline API
    * Fixed LPC32xx vs. LPC32XX
    * Various coding style fix
V2: * Splitted the DTS to its own patch
---
 .../devicetree/bindings/pwm/lpc32xx-motor-pwm.txt  |  24 +++
 drivers/pwm/Kconfig                                |  10 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-lpc32xx-motor.c                    | 210 +++++++++++++++++++++
 4 files changed, 245 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/lpc32xx-motor-pwm.txt
 create mode 100644 drivers/pwm/pwm-lpc32xx-motor.c

diff --git a/Documentation/devicetree/bindings/pwm/lpc32xx-motor-pwm.txt b/Documentation/devicetree/bindings/pwm/lpc32xx-motor-pwm.txt
new file mode 100644
index 0000000..decc27c
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/lpc32xx-motor-pwm.txt
@@ -0,0 +1,24 @@
+LPC32xx Motor PWM controller
+
+The LPC32xx motor PWMs have two output pin, A and B, with B = !A.
+By default, output A should be used, if output B is used the PWM
+polarity should be inverted using the linux,polarity property.
+
+Required properties:
+- compatible: should be "nxp,lpc3220-motor-pwm"
+- reg: physical base address and length of the controller's registers
+
+Optional properties:
+- linux,polarity: Bit mask of the polarity to use for each output,
+      a bit set to 0 indicate the default polarity, a bit set to 1
+      indicate an inverted polarity. In other word this set if output
+      pin A or output pin B has the correct polarity.
+
+Examples:
+
+mpwm@400e8000 {
+	compatible = "nxp,lpc3220-motor-pwm";
+	reg = <0x400E8000 0x78>;
+	linux,polarity = <0x5>; /* Use outputs B0, A1 and B2 */
+	#pwm-cells = <2>;
+};
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index b800783..1143348 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -147,6 +147,16 @@ config PWM_LPC32XX
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-lpc32xx.
 
+config PWM_LPC32XX_MOTOR
+	tristate "LPC32xx Motor PWM support"
+	depends on ARCH_LPC32XX
+	help
+	  Generic PWM framework driver for LPC32xx motor PWM. The LPC32xx SOC
+	  has one motor PWM controllers.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-lpc32xx-motor.
+
 config PWM_LPSS
 	tristate "Intel LPSS PWM support"
 	depends on ACPI
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index f8c577d..3eb5dd9 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
 obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
 obj-$(CONFIG_PWM_LP3943)	+= pwm-lp3943.o
 obj-$(CONFIG_PWM_LPC32XX)	+= pwm-lpc32xx.o
+obj-$(CONFIG_PWM_LPC32XX_MOTOR)	+= pwm-lpc32xx-motor.o
 obj-$(CONFIG_PWM_LPSS)		+= pwm-lpss.o
 obj-$(CONFIG_PWM_MXS)		+= pwm-mxs.o
 obj-$(CONFIG_PWM_PCA9685)	+= pwm-pca9685.o
diff --git a/drivers/pwm/pwm-lpc32xx-motor.c b/drivers/pwm/pwm-lpc32xx-motor.c
new file mode 100644
index 0000000..01cac53
--- /dev/null
+++ b/drivers/pwm/pwm-lpc32xx-motor.c
@@ -0,0 +1,210 @@
+/*
+ * Copyright 2012 Alban Bedel <alban.bedel@avionic-design.de>
+ *
+ * Based on pwm-lpc32xx.c from Alexandre Pereira da Silva
+ * <aletes.xgr@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/slab.h>
+
+struct lpc32xx_motor_pwm_chip {
+	struct pwm_chip chip;
+	struct clk *clk;
+	unsigned int pins;
+	void __iomem *base;
+};
+
+#define to_motor_pwm_chip(_chip) \
+	container_of(_chip, struct lpc32xx_motor_pwm_chip, chip)
+
+/* Register mapping for MCPWM modules */
+#define LPC32XX_MCPWM_MCCON		0x00
+#define LPC32XX_MCPWM_MCCON_SET		0x04
+#define LPC32XX_MCPWM_MCCON_CLR		0x08
+#define LPC32XX_MCPWM_MCCAPCON		0x0C
+#define LPC32XX_MCPWM_MCCAPCON_SET	0x10
+#define LPC32XX_MCPWM_MCCAPCON_CLR	0x14
+#define LPC32XX_MCPWM_MCLIM0		0x24
+#define LPC32XX_MCPWM_MCLIM1		0x28
+#define LPC32XX_MCPWM_MCLIM2		0x2C
+#define LPC32XX_MCPWM_MCMAT0		0x30
+#define LPC32XX_MCPWM_MCMAT1		0x34
+#define LPC32XX_MCPWM_MCMAT2		0x38
+#define LPC32XX_MCPWM_MCINTEN_CLR	0x58
+
+#define LPC32XX_MCPWM_COUNT		3
+
+#define PWM_EN_MASK(pwm)	BIT(0 + (pwm)->hwpwm * 8)
+#define MCLIM_REG_OFFSET(pwm)	(LPC32XX_MCPWM_MCLIM0 + (pwm)->hwpwm * 4)
+#define MCMAT_REG_OFFSET(pwm)	(LPC32XX_MCPWM_MCMAT0 + (pwm)->hwpwm * 4)
+
+static int lpc32xx_motor_pwm_config(struct pwm_chip *chip,
+				    struct pwm_device *pwm,
+				    int duty_ns, int period_ns)
+{
+	struct lpc32xx_motor_pwm_chip *lpc32xx = to_motor_pwm_chip(chip);
+	u64 rate, period, duty;
+	int err = 0;
+
+	/* The clock is needed to access the registers */
+	err = clk_enable(lpc32xx->clk);
+	if (err)
+		return err;
+
+	/* Calculate period */
+	rate = clk_get_rate(lpc32xx->clk);
+	period  = (u64)period_ns * rate;
+	duty = (u64)duty_ns * rate;
+	do_div(period,  1000000000);
+	do_div(duty, 1000000000);
+
+	/* Write to limit register -> period */
+	__raw_writel(period, lpc32xx->base + MCLIM_REG_OFFSET(pwm));
+
+	/* Write to match register -> duty */
+	__raw_writel(period - duty, lpc32xx->base + MCMAT_REG_OFFSET(pwm));
+
+	/* Disable the clock now that we are done */
+	clk_disable(lpc32xx->clk);
+	return 0;
+}
+
+static int lpc32xx_motor_pwm_enable(struct pwm_chip *chip,
+				    struct pwm_device *pwm)
+{
+	struct lpc32xx_motor_pwm_chip *lpc32xx = to_motor_pwm_chip(chip);
+	int err;
+
+	err = clk_enable(lpc32xx->clk);
+	if (err)
+		return err;
+
+	__raw_writel(PWM_EN_MASK(pwm), lpc32xx->base + LPC32XX_MCPWM_MCCON_SET);
+
+	return 0;
+}
+
+static void lpc32xx_motor_pwm_disable(struct pwm_chip *chip,
+				      struct pwm_device *pwm)
+{
+	struct lpc32xx_motor_pwm_chip *lpc32xx = to_motor_pwm_chip(chip);
+
+	__raw_writel(PWM_EN_MASK(pwm), lpc32xx->base + LPC32XX_MCPWM_MCCON_CLR);
+
+	clk_disable(lpc32xx->clk);
+}
+
+static const struct pwm_ops lpc32xx_motor_pwm_ops = {
+	.config = lpc32xx_motor_pwm_config,
+	.enable = lpc32xx_motor_pwm_enable,
+	.disable = lpc32xx_motor_pwm_disable,
+	.owner = THIS_MODULE,
+};
+
+static int lpc32xx_motor_pwm_probe(struct platform_device *pdev)
+{
+	struct lpc32xx_motor_pwm_chip *lpc32xx;
+	struct resource *res;
+	int ret;
+
+	lpc32xx = devm_kzalloc(&pdev->dev, sizeof(*lpc32xx), GFP_KERNEL);
+	if (!lpc32xx)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
+
+	lpc32xx->base = devm_ioremap_resource(&pdev->dev, res);
+	if (!lpc32xx->base)
+		return -EADDRNOTAVAIL;
+
+	lpc32xx->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(lpc32xx->clk))
+		return PTR_ERR(lpc32xx->clk);
+
+	/* Configure the pins polarity */
+	ret = of_property_read_u32(pdev->dev.of_node, "linux,polarity",
+				   &lpc32xx->pins);
+	if (!ret) {
+		u32 set = 0, clr = 0;
+		int i;
+
+		for (i = 0; i < LPC32XX_MCPWM_COUNT; i++)
+			if (lpc32xx->pins & BIT(i))
+				set |= BIT(2 + i * 8);
+			else
+				clr |= BIT(2 + i * 8);
+
+		ret = clk_enable(lpc32xx->clk);
+		if (ret)
+			return ret;
+
+		__raw_writel(set, lpc32xx->base + LPC32XX_MCPWM_MCCON_SET);
+		__raw_writel(clr, lpc32xx->base + LPC32XX_MCPWM_MCCON_CLR);
+
+		clk_disable(lpc32xx->clk);
+	}
+
+	lpc32xx->chip.dev = &pdev->dev;
+	lpc32xx->chip.ops = &lpc32xx_motor_pwm_ops;
+	lpc32xx->chip.npwm = LPC32XX_MCPWM_COUNT;
+	lpc32xx->chip.base = -1;
+
+	ret = pwmchip_add(&lpc32xx->chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to add PWM chip, error %d\n", ret);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, lpc32xx);
+
+	return 0;
+}
+
+static int lpc32xx_motor_pwm_remove(struct platform_device *pdev)
+{
+	struct lpc32xx_motor_pwm_chip *lpc32xx = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < lpc32xx->chip.npwm; i++)
+		pwm_disable(&lpc32xx->chip.pwms[i]);
+
+	return pwmchip_remove(&lpc32xx->chip);
+}
+
+static const struct of_device_id lpc32xx_motor_pwm_dt_ids[] = {
+	{ .compatible = "nxp,lpc3220-motor-pwm", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, lpc32xx_motor_pwm_dt_ids);
+
+static struct platform_driver lpc32xx_motor_pwm_driver = {
+	.driver = {
+		.name = "lpc32xx-motor-pwm",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(lpc32xx_motor_pwm_dt_ids),
+	},
+	.probe = lpc32xx_motor_pwm_probe,
+	.remove = lpc32xx_motor_pwm_remove,
+};
+module_platform_driver(lpc32xx_motor_pwm_driver);
+
+MODULE_ALIAS("platform:lpc32xx-motor-pwm");
+MODULE_AUTHOR("Alban Bedel <alban.bedel@avionic-design.de>");
+MODULE_DESCRIPTION("LPC32xx Motor PWM Driver");
+MODULE_LICENSE("GPL v2");
-- 
2.1.0

