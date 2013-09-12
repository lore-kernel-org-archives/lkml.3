Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab3ILBeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 21:34:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46484 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab3ILBeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 21:34:07 -0400
From: Milo Kim <milo.kim@ti.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, Milo Kim <milo.kim@ti.com>
Subject: [PATCH v3 3/4] pwm: add LP3943 PWM driver
Date: Thu, 12 Sep 2013 10:33:50 +0900
Message-ID: <1378949630-6275-1-git-send-email-milo.kim@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the other of the LP3943 MFD driver.
LP3943 can be used as a PWM generator, up to 2 channels.

* Two PWM generators supported

* Supported PWM operations
  request, free, config, enable and disable

* Pin assignment
  A driver data, 'pin_used' is checked when a PWM is requested.
  If the output pin is already assigned, then returns as failure.
  If the pin is available, 'pin_used' is set.
  When the PWM is not used anymore, then it is cleared.
  It is defined as unsigned long type for atomic bit operation APIs,
  but only LSB 16bits are used because LP3943 has 16 outputs.

Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Milo Kim <milo.kim@ti.com>
---
* Patch v3
  Manual polarity not supported any more.
  Add encapsulation functions for accessing internal data structure.
  Use pwm_set_chip_data() and pwm_get_chip_data().
  And other code fixes based on Thierry's feedback.

 drivers/pwm/Kconfig      |   10 ++
 drivers/pwm/Makefile     |    1 +
 drivers/pwm/pwm-lp3943.c |  314 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 325 insertions(+)
 create mode 100644 drivers/pwm/pwm-lp3943.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 75840b5..9cf38bc 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -81,6 +81,16 @@ config PWM_JZ4740
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-jz4740.
 
+config PWM_LP3943
+	tristate "TI/National Semiconductor LP3943 PWM support"
+	depends on MFD_LP3943
+	help
+	  Generic PWM framework driver for LP3943 which supports two PWM
+	  channels.
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
index 0000000..8a843a0
--- /dev/null
+++ b/drivers/pwm/pwm-lp3943.c
@@ -0,0 +1,314 @@
+/*
+ * TI/National Semiconductor LP3943 PWM driver
+ *
+ * Copyright 2013 Texas Instruments
+ *
+ * Author: Milo Kim <milo.kim@ti.com>
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
+
+struct lp3943_pwm {
+	struct pwm_chip chip;
+	struct lp3943 *lp3943;
+	struct lp3943_platform_data *pdata;
+};
+
+static inline struct lp3943_pwm *to_lp3943_pwm(struct pwm_chip *_chip)
+{
+	return container_of(_chip, struct lp3943_pwm, chip);
+}
+
+static struct lp3943_pwm_map *
+lp3943_pwm_request_map(struct lp3943_pwm *lp3943_pwm, int hwpwm)
+{
+	struct lp3943_platform_data *pdata = lp3943_pwm->pdata;
+	struct lp3943 *lp3943 = lp3943_pwm->lp3943;
+	struct lp3943_pwm_map *pwm_map;
+	int i, offset;
+
+	pwm_map = kzalloc(sizeof(*pwm_map), GFP_KERNEL);
+	if (!pwm_map)
+		return ERR_PTR(-ENOMEM);
+
+	pwm_map->output = pdata->pwms[hwpwm]->output;
+	pwm_map->num_outputs = pdata->pwms[hwpwm]->num_outputs;
+
+	for (i = 0; i < pwm_map->num_outputs; i++) {
+		offset = pwm_map->output[i];
+
+		/* Return an error if the pin is already assigned */
+		if (test_and_set_bit(offset, &lp3943->pin_used))
+			return ERR_PTR(-EBUSY);
+	}
+
+	return pwm_map;
+}
+
+static int lp3943_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
+	struct lp3943_pwm_map *pwm_map;
+
+	pwm_map = lp3943_pwm_request_map(lp3943_pwm, pwm->hwpwm);
+	if (IS_ERR(pwm_map))
+		return PTR_ERR(pwm_map);
+
+	return pwm_set_chip_data(pwm, pwm_map);
+}
+
+static void lp3943_pwm_free_map(struct lp3943_pwm *lp3943_pwm,
+				struct lp3943_pwm_map *pwm_map)
+{
+	struct lp3943 *lp3943 = lp3943_pwm->lp3943;
+	int i, offset;
+
+	for (i = 0; i < pwm_map->num_outputs; i++) {
+		offset = pwm_map->output[i];
+		clear_bit(offset, &lp3943->pin_used);
+	}
+
+	kfree(pwm_map);
+}
+
+static void lp3943_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
+	struct lp3943_pwm_map *pwm_map = pwm_get_chip_data(pwm);
+
+	lp3943_pwm_free_map(lp3943_pwm, pwm_map);
+}
+
+static int lp3943_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			     int duty_ns, int period_ns)
+{
+	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
+	struct lp3943 *lp3943 = lp3943_pwm->lp3943;
+	u8 val, reg_duty, reg_prescale;
+	int err;
+
+	/*
+	 * How to configure the LP3943 PWMs
+	 *
+	 * 1) Period = 6250 ~ 1600000
+	 * 2) Prescale = period / 6250 -1
+	 * 3) Duty = input duty
+	 *
+	 * Prescale and duty are register values
+	 */
+
+	if (pwm->hwpwm == 0) {
+		reg_prescale = LP3943_REG_PRESCALE0;
+		reg_duty     = LP3943_REG_PWM0;
+	} else {
+		reg_prescale = LP3943_REG_PRESCALE1;
+		reg_duty     = LP3943_REG_PWM1;
+	}
+
+	period_ns = clamp(period_ns, LP3943_MIN_PERIOD, LP3943_MAX_PERIOD);
+	val       = (u8)(period_ns / LP3943_MIN_PERIOD - 1);
+
+	err = lp3943_write_byte(lp3943, reg_prescale, val);
+	if (err)
+		return err;
+
+	val = (u8)(duty_ns * LP3943_MAX_DUTY / period_ns);
+
+	return lp3943_write_byte(lp3943, reg_duty, val);
+}
+
+static int lp3943_pwm_set_mode(struct lp3943_pwm *lp3943_pwm,
+			       struct lp3943_pwm_map *pwm_map,
+			       u8 val)
+{
+	struct lp3943 *lp3943 = lp3943_pwm->lp3943;
+	const struct lp3943_reg_cfg *mux = lp3943->mux_cfg;
+	int i, index, err;
+
+	for (i = 0; i < pwm_map->num_outputs; i++) {
+		index = pwm_map->output[i];
+		err = lp3943_update_bits(lp3943, mux[index].reg,
+					 mux[index].mask,
+					 val << mux[index].shift);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int lp3943_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
+	struct lp3943_pwm_map *pwm_map = pwm_get_chip_data(pwm);
+	u8 val;
+
+	if (pwm->hwpwm == 0)
+		val = LP3943_DIM_PWM0;
+	else
+		val = LP3943_DIM_PWM1;
+
+	/*
+	 * Each PWM generator is set to control any of outputs of LP3943.
+	 * To enable/disable the PWM, these output pins should be configured.
+	 */
+
+	return lp3943_pwm_set_mode(lp3943_pwm, pwm_map, val);
+}
+
+static void lp3943_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
+	struct lp3943_pwm_map *pwm_map = pwm_get_chip_data(pwm);
+
+	/*
+	 * LP3943 outputs are open-drain, so the pin should be configured
+	 * when the PWM is disabled.
+	 */
+
+	lp3943_pwm_set_mode(lp3943_pwm, pwm_map, LP3943_GPIO_OUT_HIGH);
+}
+
+static const struct pwm_ops lp3943_pwm_ops = {
+	.request	= lp3943_pwm_request,
+	.free		= lp3943_pwm_free,
+	.config		= lp3943_pwm_config,
+	.enable		= lp3943_pwm_enable,
+	.disable	= lp3943_pwm_disable,
+	.owner		= THIS_MODULE,
+};
+
+static int lp3943_pwm_parse_dt(struct device *dev,
+			       struct lp3943_pwm *lp3943_pwm)
+{
+	static const char * const name[] = { "ti,pwm0", "ti,pwm1", };
+	struct device_node *node = dev->of_node;
+	struct lp3943_platform_data *pdata;
+	struct lp3943_pwm_map *pwm_map;
+	enum lp3943_pwm_output *output;
+	int i, err, proplen, count = 0;
+	u32 num_outputs;
+
+	if (!node)
+		return -EINVAL;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	/*
+	 * Read the output map configuration from the device tree.
+	 * Each of the two PWM generators can drive zero or more outputs.
+	 */
+
+	for (i = 0; i < LP3943_NUM_PWMS; i++) {
+		if (!of_get_property(node, name[i], &proplen))
+			continue;
+
+		num_outputs = proplen / sizeof(u32);
+		if (num_outputs == 0)
+			continue;
+
+		output = devm_kzalloc(dev, sizeof(*output) * num_outputs,
+				      GFP_KERNEL);
+		if (!output)
+			return -ENOMEM;
+
+		err = of_property_read_u32_array(node, name[i], output,
+						 num_outputs);
+		if (err)
+			return err;
+
+		pwm_map = devm_kzalloc(dev, sizeof(*pwm_map), GFP_KERNEL);
+		if (!pwm_map)
+			return -ENOMEM;
+
+		pwm_map->output = output;
+		pwm_map->num_outputs = num_outputs;
+		pdata->pwms[i] = pwm_map;
+
+		count++;
+	}
+
+	if (count == 0)
+		return -ENODATA;
+
+	lp3943_pwm->pdata = pdata;
+	return 0;
+}
+
+static int lp3943_pwm_probe(struct platform_device *pdev)
+{
+	struct lp3943 *lp3943 = dev_get_drvdata(pdev->dev.parent);
+	struct lp3943_pwm *lp3943_pwm;
+	int ret;
+
+	lp3943_pwm = devm_kzalloc(&pdev->dev, sizeof(*lp3943_pwm), GFP_KERNEL);
+	if (!lp3943_pwm)
+		return -ENOMEM;
+
+	lp3943_pwm->pdata = lp3943->pdata;
+	if (!lp3943_pwm->pdata) {
+		if (IS_ENABLED(CONFIG_OF))
+			ret = lp3943_pwm_parse_dt(&pdev->dev, lp3943_pwm);
+		else
+			ret = -ENODEV;
+
+		if (ret)
+			return ret;
+	}
+
+	lp3943_pwm->lp3943 = lp3943;
+	lp3943_pwm->chip.dev = &pdev->dev;
+	lp3943_pwm->chip.ops = &lp3943_pwm_ops;
+	lp3943_pwm->chip.npwm = LP3943_NUM_PWMS;
+
+	platform_set_drvdata(pdev, lp3943_pwm);
+
+	return pwmchip_add(&lp3943_pwm->chip);
+}
+
+static int lp3943_pwm_remove(struct platform_device *pdev)
+{
+	struct lp3943_pwm *lp3943_pwm = platform_get_drvdata(pdev);
+
+	return pwmchip_remove(&lp3943_pwm->chip);
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id lp3943_pwm_of_match[] = {
+	{ .compatible = "ti,lp3943-pwm", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lp3943_pwm_of_match);
+#endif
+
+static struct platform_driver lp3943_pwm_driver = {
+	.probe = lp3943_pwm_probe,
+	.remove = lp3943_pwm_remove,
+	.driver = {
+		.name = "lp3943-pwm",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(lp3943_pwm_of_match),
+	},
+};
+module_platform_driver(lp3943_pwm_driver);
+
+MODULE_DESCRIPTION("LP3943 PWM driver");
+MODULE_ALIAS("platform:lp3943-pwm");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

