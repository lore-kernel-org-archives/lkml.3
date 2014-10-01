Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaJAOxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:53:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35333 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751860AbaJAOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:53:33 -0400
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
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v7 03/11] pwm: add support for atmel-hlcdc-pwm device
Date: Wed,  1 Oct 2014 16:53:00 +0200
Message-Id: <1412175188-28278-4-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

The HLCDC IP available in some Atmel SoCs (i.e. sam9x5i.e. at91sam9n12,
at91sam9x5 family or sama5d3 family) provide a PWM device.

This driver add support for a PWM chip exposing a single PWM device (which
will most likely be used to drive a backlight device).

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Tested-by: Anthony Harivel <anthony.harivel@emtrion.de>
Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
---
 drivers/pwm/Kconfig           |  10 ++
 drivers/pwm/Makefile          |   1 +
 drivers/pwm/pwm-atmel-hlcdc.c | 229 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 240 insertions(+)
 create mode 100644 drivers/pwm/pwm-atmel-hlcdc.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index b800783..afb896b 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -50,6 +50,16 @@ config PWM_ATMEL
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-atmel.
 
+config PWM_ATMEL_HLCDC_PWM
+	tristate "Atmel HLCDC PWM support"
+	select MFD_ATMEL_HLCDC
+	depends on OF
+	help
+	  Generic PWM framework driver for Atmel HLCDC PWM.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-atmel.
+
 config PWM_ATMEL_TCB
 	tristate "Atmel TC Block PWM support"
 	depends on ATMEL_TCLIB && OF
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index f8c577d..eb0aae5 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_PWM)		+= core.o
 obj-$(CONFIG_PWM_SYSFS)		+= sysfs.o
 obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
 obj-$(CONFIG_PWM_ATMEL)		+= pwm-atmel.o
+obj-$(CONFIG_PWM_ATMEL_HLCDC_PWM)	+= pwm-atmel-hlcdc.o
 obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
 obj-$(CONFIG_PWM_BCM_KONA)	+= pwm-bcm-kona.o
 obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
diff --git a/drivers/pwm/pwm-atmel-hlcdc.c b/drivers/pwm/pwm-atmel-hlcdc.c
new file mode 100644
index 0000000..0238f7a
--- /dev/null
+++ b/drivers/pwm/pwm-atmel-hlcdc.c
@@ -0,0 +1,229 @@
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
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/regmap.h>
+
+#define ATMEL_HLCDC_PWMCVAL_MASK	GENMASK(15, 8)
+#define ATMEL_HLCDC_PWMCVAL(x)		((x << 8) & ATMEL_HLCDC_PWMCVAL_MASK)
+#define ATMEL_HLCDC_PWMPOL		BIT(4)
+#define ATMEL_HLCDC_PWMPS_MASK		GENMASK(2, 0)
+#define ATMEL_HLCDC_PWMPS_MAX		0x6
+#define ATMEL_HLCDC_PWMPS(x)		((x) & ATMEL_HLCDC_PWMPS_MASK)
+
+struct atmel_hlcdc_pwm_chip {
+	struct pwm_chip chip;
+	struct atmel_hlcdc *hlcdc;
+	struct clk *cur_clk;
+};
+
+static inline struct atmel_hlcdc_pwm_chip *
+pwm_chip_to_atmel_hlcdc_pwm_chip(struct pwm_chip *chip)
+{
+	return container_of(chip, struct atmel_hlcdc_pwm_chip, chip);
+}
+
+static int atmel_hlcdc_pwm_config(struct pwm_chip *c,
+				  struct pwm_device *pwm,
+				  int duty_ns, int period_ns)
+{
+	struct atmel_hlcdc_pwm_chip *chip =
+				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
+	struct atmel_hlcdc *hlcdc = chip->hlcdc;
+	struct clk *new_clk = hlcdc->slow_clk;
+	u64 pwmcval = duty_ns * 256;
+	unsigned long clk_freq;
+	u64 clk_period_ns;
+	u32 pwmcfg;
+	int pres;
+
+	clk_freq = clk_get_rate(new_clk);
+	clk_period_ns = 1000000000;
+	clk_period_ns *= 256;
+	do_div(clk_period_ns, clk_freq);
+
+	if (clk_period_ns > period_ns) {
+		new_clk = hlcdc->sys_clk;
+		clk_freq = clk_get_rate(new_clk);
+		clk_period_ns = 1000000000;
+		clk_period_ns *= 256;
+		do_div(clk_period_ns, clk_freq);
+	}
+
+	for (pres = 0; pres <= ATMEL_HLCDC_PWMPS_MAX; pres++) {
+		if ((clk_period_ns << pres) >= period_ns)
+			break;
+	}
+
+	if (pres > ATMEL_HLCDC_PWMPS_MAX)
+		return -EINVAL;
+
+	pwmcfg = ATMEL_HLCDC_PWMPS(pres);
+
+	if (new_clk != chip->cur_clk) {
+		u32 gencfg = 0;
+
+		clk_prepare_enable(new_clk);
+		clk_disable_unprepare(chip->cur_clk);
+		chip->cur_clk = new_clk;
+
+		if (new_clk != hlcdc->slow_clk)
+			gencfg = ATMEL_HLCDC_CLKPWMSEL;
+		regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(0),
+				   ATMEL_HLCDC_CLKPWMSEL, gencfg);
+	}
+
+	do_div(pwmcval, period_ns);
+	if (pwmcval > 255)
+		pwmcval = 255;
+
+	pwmcfg |= ATMEL_HLCDC_PWMCVAL(pwmcval);
+
+	regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(6),
+			   ATMEL_HLCDC_PWMCVAL_MASK | ATMEL_HLCDC_PWMPS_MASK,
+			   pwmcfg);
+
+	return 0;
+}
+
+static int atmel_hlcdc_pwm_set_polarity(struct pwm_chip *c,
+					struct pwm_device *pwm,
+					enum pwm_polarity polarity)
+{
+	struct atmel_hlcdc_pwm_chip *chip =
+				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
+	struct atmel_hlcdc *hlcdc = chip->hlcdc;
+	u32 cfg = 0;
+
+	if (polarity == PWM_POLARITY_NORMAL)
+		cfg = ATMEL_HLCDC_PWMPOL;
+
+	regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(6),
+			   ATMEL_HLCDC_PWMPOL, cfg);
+
+	return 0;
+}
+
+static int atmel_hlcdc_pwm_enable(struct pwm_chip *c,
+				  struct pwm_device *pwm)
+{
+	struct atmel_hlcdc_pwm_chip *chip =
+				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
+	struct atmel_hlcdc *hlcdc = chip->hlcdc;
+	u32 status;
+
+	regmap_write(hlcdc->regmap, ATMEL_HLCDC_EN, ATMEL_HLCDC_PWM);
+	while (!regmap_read(hlcdc->regmap, ATMEL_HLCDC_SR, &status) &&
+	       !(status & ATMEL_HLCDC_PWM))
+		;
+
+	return 0;
+}
+
+static void atmel_hlcdc_pwm_disable(struct pwm_chip *c,
+				    struct pwm_device *pwm)
+{
+	struct atmel_hlcdc_pwm_chip *chip =
+				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
+	struct atmel_hlcdc *hlcdc = chip->hlcdc;
+	u32 status;
+
+	regmap_write(hlcdc->regmap, ATMEL_HLCDC_DIS, ATMEL_HLCDC_PWM);
+	while (!regmap_read(hlcdc->regmap, ATMEL_HLCDC_SR, &status) &&
+	       (status & ATMEL_HLCDC_PWM))
+		;
+}
+
+static const struct pwm_ops atmel_hlcdc_pwm_ops = {
+	.config = atmel_hlcdc_pwm_config,
+	.set_polarity = atmel_hlcdc_pwm_set_polarity,
+	.enable = atmel_hlcdc_pwm_enable,
+	.disable = atmel_hlcdc_pwm_disable,
+	.owner = THIS_MODULE,
+};
+
+static int atmel_hlcdc_pwm_probe(struct platform_device *pdev)
+{
+	struct atmel_hlcdc_pwm_chip *chip;
+	struct device *dev = &pdev->dev;
+	struct atmel_hlcdc *hlcdc;
+	int ret;
+
+	hlcdc = dev_get_drvdata(dev->parent);
+	if (!hlcdc)
+		return -EINVAL;
+
+	ret = clk_prepare_enable(hlcdc->periph_clk);
+	if (ret)
+		return ret;
+
+	chip = devm_kzalloc(dev, sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->hlcdc = hlcdc;
+	chip->chip.ops = &atmel_hlcdc_pwm_ops;
+	chip->chip.dev = dev;
+	chip->chip.base = -1;
+	chip->chip.npwm = 1;
+	chip->chip.of_xlate = of_pwm_xlate_with_flags;
+	chip->chip.of_pwm_n_cells = 3;
+	chip->chip.can_sleep = 1;
+
+	ret = pwmchip_add(&chip->chip);
+	if (ret)
+		return ret;
+
+	platform_set_drvdata(pdev, chip);
+
+	return 0;
+}
+
+static int atmel_hlcdc_pwm_remove(struct platform_device *pdev)
+{
+	struct atmel_hlcdc_pwm_chip *chip = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(chip->hlcdc->periph_clk);
+
+	return pwmchip_remove(&chip->chip);
+}
+
+static const struct of_device_id atmel_hlcdc_pwm_dt_ids[] = {
+	{ .compatible = "atmel,hlcdc-pwm" },
+	{ /* sentinel */ },
+};
+
+static struct platform_driver atmel_hlcdc_pwm_driver = {
+	.driver = {
+		.name = "atmel-hlcdc-pwm",
+		.of_match_table = atmel_hlcdc_pwm_dt_ids,
+	},
+	.probe = atmel_hlcdc_pwm_probe,
+	.remove = atmel_hlcdc_pwm_remove,
+};
+module_platform_driver(atmel_hlcdc_pwm_driver);
+
+MODULE_ALIAS("platform:atmel-hlcdc-pwm");
+MODULE_AUTHOR("Boris Brezillon <boris.brezillon@free-electrons.com>");
+MODULE_DESCRIPTION("Atmel HLCDC PWM driver");
+MODULE_LICENSE("GPL");
-- 
1.9.1

