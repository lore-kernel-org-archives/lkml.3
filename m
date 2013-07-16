Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab3GPCi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:38:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47740 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab3GPCi5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:38:57 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: [PATCH 3/3] pwm: add LP3943 PWM driver
Thread-Topic: [PATCH 3/3] pwm: add LP3943 PWM driver
Thread-Index: Ac6BzHmoo0334Or+S5yXty3LeSX47Q==
Date: Tue, 16 Jul 2013 02:38:48 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E815DF@DQHE06.ent.ti.com>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a part of the LP3943 MFD driver.
LP3943 can be used as a PWM generator, up to 2 channels.

* Two PWM generators
  LP3943 has 16 output channels.
  Two channels are configurable as PWM generators.

* Supported PWM operations
  config, set_polarity, enable and disable

* Manual polarity configuration
  No register exists for setting polarity. However, the value of duty can be
  calculated as following.
  PWM-inversed mode : duty = period - duty
  PWM-normal mode   : input duty itself

* Pin MUX configuration at each PWM operation - enable and disable

* Register access through exported LP3943 MFD functions

Signed-off-by: Milo Kim <milo.kim@ti.com>
---
 drivers/pwm/Kconfig      |   10 +++
 drivers/pwm/Makefile     |    1 +
 drivers/pwm/pwm-lp3943.c |  192 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 203 insertions(+)
 create mode 100644 drivers/pwm/pwm-lp3943.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 75840b5..28a7668 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -81,6 +81,16 @@ config PWM_JZ4740
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-jz4740.
 
+config PWM_LP3943
+	tristate "LP3943 PWM support"
+	depends on MFD_LP3943
+	help
+	  Generic PWM framework driver for LP3943. It supports two PWM
+	  controllers.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-lp3943.
+
 config PWM_LPC32XX
 	tristate "LPC32XX PWM support"
 	depends on ARCH_LPC32XX
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 77a8c18..db8e349 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
 obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
 obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
 obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
+obj-$(CONFIG_PWM_LP3943)	+= pwm-lp3943.o
 obj-$(CONFIG_PWM_LPC32XX)	+= pwm-lpc32xx.o
 obj-$(CONFIG_PWM_MXS)		+= pwm-mxs.o
 obj-$(CONFIG_PWM_PCA9685)	+= pwm-pca9685.o
diff --git a/drivers/pwm/pwm-lp3943.c b/drivers/pwm/pwm-lp3943.c
new file mode 100644
index 0000000..33e63fa7
--- /dev/null
+++ b/drivers/pwm/pwm-lp3943.c
@@ -0,0 +1,192 @@
+/*
+ * TI/National Semiconductor LP3943 PWM driver
+ *
+ *			Copyright (C) 2013 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2.
+ */
+
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/mfd/lp3943.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/slab.h>
+
+#define LP3943_MAX_DUTY			255
+#define LP3943_MIN_PERIOD		6250
+#define LP3943_MAX_PERIOD		1600000
+#define LP3943_NUM_PWMS			2
+
+#define to_lp3943_pwm(_chip)	container_of(_chip, struct lp3943_pwm, chip)
+
+struct lp3943_pwm {
+	struct pwm_chip chip;
+	struct lp3943 *l;
+	enum lp3943_pwm_output output[LP3943_NUM_PWMS];
+	bool inversed[LP3943_NUM_PWMS];
+};
+
+static int lp3943_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+		      int duty_ns, int period_ns)
+{
+	struct lp3943_pwm *lp = to_lp3943_pwm(chip);
+	u8 reg_prescale;
+	u8 reg_duty;
+	u8 val;
+	int err;
+
+	/*
+	 * How to configure the LP3943 PWMs
+	 *
+	 * 1) Period = 6250 ~ 1600000
+	 * 2) Prescale = period / 6250 -1
+	 * 3) Duty = 'input duty'(normal) or 'period - duty'(inversed)
+	 *
+	 * Prescale and duty are register values
+	 */
+
+	if (pwm->hwpwm == 0) {
+		reg_prescale = LP3943_REG_PRESCALE0;
+		reg_duty = LP3943_REG_PWM0;
+	} else if (pwm->hwpwm == 1) {
+		reg_prescale = LP3943_REG_PRESCALE1;
+		reg_duty = LP3943_REG_PWM1;
+	} else {
+		return -EINVAL;
+	}
+
+	period_ns = clamp(period_ns, LP3943_MIN_PERIOD, LP3943_MAX_PERIOD);
+	val = (u8)(period_ns / LP3943_MIN_PERIOD - 1);
+
+	err = lp3943_write_byte(lp->l, reg_prescale, val);
+	if (err)
+		return err;
+
+	if (lp->inversed[pwm->hwpwm])
+		val = (u8)((period_ns - duty_ns) * LP3943_MAX_DUTY / period_ns);
+	else
+		val = (u8)(duty_ns * LP3943_MAX_DUTY / period_ns);
+
+	return lp3943_write_byte(lp->l, reg_duty, val);
+}
+
+static int lp3943_pwm_set_polarity(struct pwm_chip *chip,
+			struct pwm_device *pwm, enum pwm_polarity polarity)
+{
+	struct lp3943_pwm *lp = to_lp3943_pwm(chip);
+
+	if (polarity == PWM_POLARITY_INVERSED)
+		lp->inversed[pwm->hwpwm] = true;
+	else
+		lp->inversed[pwm->hwpwm] = false;
+
+	return 0;
+}
+
+static int lp3943_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct lp3943_pwm *lp = to_lp3943_pwm(chip);
+	const struct lp3943_reg_cfg *mux = lp->l->mux_cfg;
+	int offset = lp->output[pwm->hwpwm] - 1;
+	u8 val;
+
+	if (pwm->hwpwm == 0)
+		val = LP3943_DIM_PWM0;
+	else if (pwm->hwpwm == 1)
+		val = LP3943_DIM_PWM1;
+	else
+		return -EINVAL;
+
+	return lp3943_update_bits(lp->l, mux[offset].reg, mux[offset].mask,
+				val << mux[offset].shift);
+}
+
+static void lp3943_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct lp3943_pwm *lp = to_lp3943_pwm(chip);
+	const struct lp3943_reg_cfg *mux = lp->l->mux_cfg;
+	int offset = lp->output[pwm->hwpwm] - 1;
+	u8 val;
+
+	/*
+	 * LP3943 outputs are open-drain, so the pin should be configured
+	 * when the PWM is disabled.
+	 *
+	 * - inversed: output low
+	 * - normal: output Hi-Z
+	 */
+
+	if (lp->inversed[pwm->hwpwm])
+		val = LP3943_GPIO_OUT_LOW << mux[offset].shift;
+	else
+		val = LP3943_GPIO_OUT_HIGH << mux[offset].shift;
+
+	lp3943_update_bits(lp->l, mux[offset].reg, mux[offset].mask, val);
+}
+
+static const struct pwm_ops lp3943_pwm_ops = {
+	.config  = lp3943_pwm_config,
+	.set_polarity = lp3943_pwm_set_polarity,
+	.enable  = lp3943_pwm_enable,
+	.disable = lp3943_pwm_disable,
+	.owner   = THIS_MODULE,
+};
+
+static int lp3943_pwm_probe(struct platform_device *pdev)
+{
+	struct lp3943 *l = dev_get_drvdata(pdev->dev.parent);
+	struct lp3943_platform_data *pdata = l->pdata;
+	struct lp3943_pwm *lp;
+	int num_pwms = 0;
+	int ret;
+
+	lp = devm_kzalloc(&pdev->dev, sizeof(struct lp3943_pwm), GFP_KERNEL);
+	if (!lp)
+		return -ENOMEM;
+
+	if (pdata->pwm0 != LP3943_PWM_INVALID)
+		lp->output[num_pwms++] = pdata->pwm0;
+
+	if (pdata->pwm1 != LP3943_PWM_INVALID)
+		lp->output[num_pwms++] = pdata->pwm1;
+
+	lp->l = l;
+	lp->chip.dev = &pdev->dev;
+	lp->chip.ops = &lp3943_pwm_ops;
+	lp->chip.npwm = num_pwms;
+
+	platform_set_drvdata(pdev, lp);
+
+	ret = pwmchip_add(&lp->chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to add PWM chip, err:%d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int lp3943_pwm_remove(struct platform_device *pdev)
+{
+	struct lp3943_pwm *lp = platform_get_drvdata(pdev);
+	return pwmchip_remove(&lp->chip);
+}
+
+static struct platform_driver lp3943_pwm_driver = {
+	.probe = lp3943_pwm_probe,
+	.remove = lp3943_pwm_remove,
+	.driver = {
+		.name = "lp3943-pwm",
+		.owner = THIS_MODULE,
+	},
+};
+module_platform_driver(lp3943_pwm_driver);
+
+MODULE_DESCRIPTION("LP3943 PWM driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:lp3943-pwm");
-- 
1.7.9.5


Best Regards,
Milo


