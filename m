Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3G3AnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:43:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44703 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab3G3Amf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:42:35 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
CC: "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "Samuel Ortiz (sameo@linux.intel.com)" <sameo@linux.intel.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/4] pwm: add LP3943 PWM driver
Thread-Topic: [PATCH v2 3/4] pwm: add LP3943 PWM driver
Thread-Index: Ac6MuwZDtlWt0UbsQt21aPhLLrET6Q==
Date: Tue, 30 Jul 2013 00:42:26 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E849E6@DQHE06.ent.ti.com>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6U0hBZg030774

This is the other of the LP3943 MFD driver.
LP3943 can be used as a PWM generator, up to 2 channels.

* Two PWM generators supported

* Supported PWM operations
  request, free, config, set_polarity, enable and disable

* Manual polarity configuration
  No register exists for setting polarity. However, the value of duty can be
  calculated as following.
  PWM-inversed mode : duty = period - duty
  PWM-normal mode   : input duty itself

* LP3943 PWM port map
  One PWM controller can be mapped to one or multiple output pins.

  For example, PWM 0 is used for a backlight device.
  PWM 1 is for RGB LEDs.

  PWM controller    Output pins    PWM consumer
  ______________    ___________    ____________
  PWM 0             pin 1          backlight
  PWM 1             pin 7, 8, 9    RGB LEDs

  Then, PWM port map is as below.
  PWM 0: num_outputs = 1, output = pin 1
  PWM 1: num_outputs = 3, output = pin 7, 8, 9

  The 'lp3943_pwm_map' structure is used for this feature.

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
* Patch v2
  Support device tree structure for the PWM controller.
  Add request() and free() for the pin assignment.
  add PWM map for multiple output pin configuration.

 drivers/pwm/Kconfig      |   10 ++
 drivers/pwm/Makefile     |    1 +
 drivers/pwm/pwm-lp3943.c |  348 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 359 insertions(+)
 create mode 100644 drivers/pwm/pwm-lp3943.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 75840b5..038de2b 100644
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
index 0000000..217e30c
--- /dev/null
+++ b/drivers/pwm/pwm-lp3943.c
@@ -0,0 +1,348 @@
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
+#define LP3943_NUM_PWMS			2
+
+#define to_lp3943_pwm(_chip)	container_of(_chip, struct lp3943_pwm, chip)
+
+struct lp3943_pwm {
+	struct pwm_chip chip;
+	struct lp3943 *lp3943;
+	struct lp3943_pwm_map *map[LP3943_NUM_PWMS];
+	bool inversed[LP3943_NUM_PWMS];
+};
+
+static int lp3943_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
+	struct lp3943 *lp3943 = lp3943_pwm->lp3943;
+	int num_outputs = lp3943_pwm->map[pwm->hwpwm]->num_outputs;
+	int offset;
+	int i;
+
+	for (i = 0; i < num_outputs; i++) {
+		offset = lp3943_pwm->map[pwm->hwpwm]->output[i] - 1;
+
+		/* Return an error if the pin is already assigned */
+		if (test_and_set_bit(offset, &lp3943->pin_used))
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
+static void lp3943_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
+	struct lp3943 *lp3943 = lp3943_pwm->lp3943;
+	int num_outputs = lp3943_pwm->map[pwm->hwpwm]->num_outputs;
+	int offset;
+	int i;
+
+	for (i = 0; i < num_outputs; i++) {
+		offset = lp3943_pwm->map[pwm->hwpwm]->output[i] - 1;
+		clear_bit(offset, &lp3943->pin_used);
+	}
+}
+
+static int lp3943_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			int duty_ns, int period_ns)
+{
+	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
+	struct lp3943 *lp3943 = lp3943_pwm->lp3943;
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
+		reg_duty     = LP3943_REG_PWM0;
+	} else if (pwm->hwpwm == 1) {
+		reg_prescale = LP3943_REG_PRESCALE1;
+		reg_duty     = LP3943_REG_PWM1;
+	} else {
+		return -EINVAL;
+	}
+
+	period_ns = clamp(period_ns, LP3943_MIN_PERIOD, LP3943_MAX_PERIOD);
+	val       = (u8)(period_ns / LP3943_MIN_PERIOD - 1);
+
+	err = lp3943_write_byte(lp3943, reg_prescale, val);
+	if (err)
+		return err;
+
+	if (lp3943_pwm->inversed[pwm->hwpwm])
+		val = (u8)((period_ns - duty_ns) * LP3943_MAX_DUTY / period_ns);
+	else
+		val = (u8)(duty_ns * LP3943_MAX_DUTY / period_ns);
+
+	return lp3943_write_byte(lp3943, reg_duty, val);
+}
+
+static int lp3943_pwm_set_polarity(struct pwm_chip *chip,
+			struct pwm_device *pwm, enum pwm_polarity polarity)
+{
+	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
+
+	if (polarity == PWM_POLARITY_INVERSED)
+		lp3943_pwm->inversed[pwm->hwpwm] = true;
+	else
+		lp3943_pwm->inversed[pwm->hwpwm] = false;
+
+	return 0;
+}
+
+static int lp3943_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
+	struct lp3943 *lp3943 = lp3943_pwm->lp3943;
+	const struct lp3943_reg_cfg *mux = lp3943->mux_cfg;
+	int num_outputs = lp3943_pwm->map[pwm->hwpwm]->num_outputs;
+	int index;
+	int err;
+	int i;
+	u8 val;
+
+	if (pwm->hwpwm == 0)
+		val = LP3943_DIM_PWM0;
+	else if (pwm->hwpwm == 1)
+		val = LP3943_DIM_PWM1;
+	else
+		return -EINVAL;
+
+	/*
+	 * Each PWM generator is set to control any of outputs of LP3943.
+	 * To enable/disable the PWM, these output pins should be configured.
+	 */
+
+	for (i = 0; i < num_outputs; i++) {
+		index = lp3943_pwm->map[pwm->hwpwm]->output[i] - 1;
+
+		err = lp3943_update_bits(lp3943, mux[index].reg,
+					mux[index].mask,
+					val << mux[index].shift);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void lp3943_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct lp3943_pwm *lp3943_pwm = to_lp3943_pwm(chip);
+	struct lp3943 *lp3943 = lp3943_pwm->lp3943;
+	const struct lp3943_reg_cfg *mux = lp3943->mux_cfg;
+	int num_outputs = lp3943_pwm->map[pwm->hwpwm]->num_outputs;
+	int index;
+	int err;
+	int i;
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
+	for (i = 0; i < num_outputs; i++) {
+		index = lp3943_pwm->map[pwm->hwpwm]->output[i] - 1;
+
+		if (lp3943_pwm->inversed[pwm->hwpwm])
+			val = LP3943_GPIO_OUT_LOW << mux[index].shift;
+		else
+			val = LP3943_GPIO_OUT_HIGH << mux[index].shift;
+
+		err = lp3943_update_bits(lp3943, mux[index].reg,
+					mux[index].mask, val);
+		if (err)
+			return;
+	}
+}
+
+static const struct pwm_ops lp3943_pwm_ops = {
+	.request	= lp3943_pwm_request,
+	.free		= lp3943_pwm_free,
+	.config		= lp3943_pwm_config,
+	.set_polarity	= lp3943_pwm_set_polarity,
+	.enable		= lp3943_pwm_enable,
+	.disable	= lp3943_pwm_disable,
+	.owner		= THIS_MODULE,
+};
+
+#ifdef CONFIG_OF
+static int lp3943_pwm_parse_dt(struct device *dev, struct device_node *node,
+			struct lp3943 *lp3943)
+{
+	const char *name[] = { "ti,pwm0", "ti,pwm1", };
+	struct lp3943_platform_data *pdata;
+	enum lp3943_pwm_output *output;
+	struct lp3943_pwm_map *pwm_map;
+	u32 num_outputs;
+	int count = 0;
+	int proplen;
+	int err;
+	int i;
+
+	if (!node)
+		return -EINVAL;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	/*
+	 * Configure the PWM output map from the device tree.
+	 * Each PWM generator is connected to output channel(s).
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
+				GFP_KERNEL);
+		if (!output)
+			return -ENOMEM;
+
+		err = of_property_read_u32_array(node, name[i], output,
+						num_outputs);
+		if (err)
+			return err;
+
+		pwm_map = devm_kzalloc(dev, sizeof(*pwm_map), GFP_KERNEL);
+		if (!pwm_map)
+			return -ENOMEM;
+
+		pwm_map->output = output;
+		pwm_map->num_outputs = num_outputs;
+
+		if (i == 0)
+			pdata->pwm0 = pwm_map;
+		else
+			pdata->pwm1 = pwm_map;
+
+		count++;
+	}
+
+	if (count == 0)
+		return -ENODATA;
+
+	lp3943->pdata = pdata;
+	return 0;
+}
+#else
+static int lp3943_pwm_parse_dt(struct device *dev, struct device_node *node)
+{
+	return -EINVAL;
+}
+#endif
+
+static int lp3943_pwm_probe(struct platform_device *pdev)
+{
+	struct lp3943 *lp3943 = dev_get_drvdata(pdev->dev.parent);
+	struct lp3943_platform_data *pdata;
+	struct lp3943_pwm *lp3943_pwm;
+	int ret;
+
+	if (!lp3943->pdata) {
+		ret = lp3943_pwm_parse_dt(&pdev->dev, pdev->dev.of_node,
+					lp3943);
+		if (ret)
+			return ret;
+	}
+
+	pdata = lp3943->pdata;
+
+	lp3943_pwm = devm_kzalloc(&pdev->dev, sizeof(*lp3943_pwm), GFP_KERNEL);
+	if (!lp3943_pwm)
+		return -ENOMEM;
+
+	if (pdata->pwm0 && (pdata->pwm0->num_outputs > 0))
+		lp3943_pwm->map[0] = pdata->pwm0;
+
+	if (pdata->pwm1 && (pdata->pwm1->num_outputs > 0))
+		lp3943_pwm->map[1] = pdata->pwm1;
+
+	lp3943_pwm->lp3943 = lp3943;
+	lp3943_pwm->chip.dev = &pdev->dev;
+	lp3943_pwm->chip.of_xlate = of_pwm_xlate_with_flags;
+	lp3943_pwm->chip.of_pwm_n_cells = 3;
+	lp3943_pwm->chip.ops = &lp3943_pwm_ops;
+	lp3943_pwm->chip.npwm = LP3943_NUM_PWMS;
+
+	platform_set_drvdata(pdev, lp3943_pwm);
+
+	ret = pwmchip_add(&lp3943_pwm->chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to add PWM chip: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int lp3943_pwm_remove(struct platform_device *pdev)
+{
+	struct lp3943_pwm *lp3943_pwm = platform_get_drvdata(pdev);
+	return pwmchip_remove(&lp3943_pwm->chip);
+}
+
+static const struct of_device_id lp3943_pwm_dt_ids[] = {
+	{ .compatible = "ti,lp3943-pwm", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lp3943_pwm_dt_ids);
+
+static struct platform_driver lp3943_pwm_driver = {
+	.probe = lp3943_pwm_probe,
+	.remove = lp3943_pwm_remove,
+	.driver = {
+		.name = "lp3943-pwm",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(lp3943_pwm_dt_ids),
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


Best Regards,
Milo


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
