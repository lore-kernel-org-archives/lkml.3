Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaFROxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:53:52 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:61372 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaFROxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:53:21 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, thierry.reding@gmail.com,
        linux-pwm@vger.kernel.org, maxime.coquelin@st.com,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        devicetree@vger.kernel.org, ajitpal.singh@st.com
Subject: [PATCH 6/7] pwm: st: Add new driver for ST's PWM IP
Date: Wed, 18 Jun 2014 15:52:51 +0100
Message-Id: <1403103172-19856-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports all current STi platforms' PWM IPs.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/pwm/Kconfig  |   9 ++
 drivers/pwm/Makefile |   1 +
 drivers/pwm/pwm-st.c | 378 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 388 insertions(+)
 create mode 100644 drivers/pwm/pwm-st.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 4ad7b89..98a7bbc 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -292,4 +292,13 @@ config PWM_VT8500
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-vt8500.
 
+config PWM_ST
+	tristate "STiH4xx PWM support"
+	depends on ARCH_STI
+	help
+	  Generic PWM framework driver for STiH4xx SoCs.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-st.
+
 endif
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 5c86a19..2c846a6 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_PWM_PXA)		+= pwm-pxa.o
 obj-$(CONFIG_PWM_RENESAS_TPU)	+= pwm-renesas-tpu.o
 obj-$(CONFIG_PWM_SAMSUNG)	+= pwm-samsung.o
 obj-$(CONFIG_PWM_SPEAR)		+= pwm-spear.o
+obj-$(CONFIG_PWM_ST)		+= pwm-st.o
 obj-$(CONFIG_PWM_TEGRA)		+= pwm-tegra.o
 obj-$(CONFIG_PWM_TIECAP)	+= pwm-tiecap.o
 obj-$(CONFIG_PWM_TIEHRPWM)	+= pwm-tiehrpwm.o
diff --git a/drivers/pwm/pwm-st.c b/drivers/pwm/pwm-st.c
new file mode 100644
index 0000000..4dea616
--- /dev/null
+++ b/drivers/pwm/pwm-st.c
@@ -0,0 +1,378 @@
+/*
+ * PWM device driver for ST SoCs.
+ * Author: Ajit Pal Singh <ajitpal.singh@st.com>
+ *
+ * Copyright (C) 2003-2014 STMicroelectronics (R&D) Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+#include <linux/bsearch.h>
+#include <linux/clk.h>
+#include <linux/math64.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/mfd/syscon.h>
+#include <linux/time.h>
+
+#define ST_PWMVAL(x)	(4 * (x))	/* Value used to define duty cycle */
+#define ST_PWMCR	0x50		/* Control/Config reg */
+#define ST_INTEN	0x54		/* Interrupt Enable/Disable reg */
+#define ST_CNT		0x60		/* PWMCounter */
+
+#define MAX_PWM_CNT_DEFAULT	255
+#define MAX_PRESCALE_DEFAULT	0xff
+#define NUM_CHAN_DEFAULT	1
+
+/* Regfield IDs */
+enum {
+	PWMCLK_PRESCALE = 0,
+	PWM_EN,
+	PWM_INT_EN,
+	/* keep last */
+	MAX_REGFIELDS
+};
+
+struct st_pwm_chip {
+	struct device *dev;
+	struct clk *clk;
+	unsigned long clk_rate;
+	struct regmap *regmap;
+	struct st_pwm_compat_data *cdata;
+	struct regmap_field *prescale;
+	struct regmap_field *pwm_en;
+	struct regmap_field *pwm_int_en;
+	unsigned long *pwm_periods;
+	struct pwm_chip chip;
+	void __iomem *mmio_base;
+};
+
+struct st_pwm_compat_data {
+	const struct reg_field *reg_fields;
+	int num_chan;
+	int max_pwm_cnt;
+	int max_prescale;
+};
+
+static const struct reg_field st_pwm_regfields[MAX_REGFIELDS] = {
+	[PWMCLK_PRESCALE]	= REG_FIELD(ST_PWMCR, 0, 3),
+	[PWM_EN]		= REG_FIELD(ST_PWMCR, 9, 9),
+	[PWM_INT_EN]		= REG_FIELD(ST_INTEN, 0, 0),
+};
+
+static inline struct st_pwm_chip *to_st_pwmchip(struct pwm_chip *chip)
+{
+	return container_of(chip, struct st_pwm_chip, chip);
+}
+
+/*
+ * Calculate the period values supported by the PWM for the
+ * current clock rate.
+ */
+static void st_pwm_calc_periods(struct st_pwm_chip *pc)
+{
+	struct st_pwm_compat_data *cdata = pc->cdata;
+	struct device *dev = pc->dev;
+	unsigned long val;
+	int i;
+
+	/*
+	 * period_ns = (10^9 * (prescaler + 1) * (MAX_PWM_COUNT + 1)) / CLK_RATE
+	 */
+	val = NSEC_PER_SEC / pc->clk_rate;
+	val *= cdata->max_pwm_cnt + 1;
+
+	dev_dbg(dev, "possible periods for clkrate[HZ]:%lu\n", pc->clk_rate);
+
+	for (i = 0; i <= cdata->max_prescale; i++) {
+		pc->pwm_periods[i] = val * (i + 1);
+		dev_dbg(dev, "prescale:%d, period[ns]:%lu\n",
+			i, pc->pwm_periods[i]);
+	}
+}
+
+static int st_pwm_cmp_periods(const void *key, const void *elt)
+{
+	unsigned long i = *(unsigned long *)key;
+	unsigned long j = *(unsigned long *)elt;
+
+	if (i < j)
+		return -1;
+	else
+		return i == j ? 0 : 1;
+}
+
+/*
+ * For STiH4xx PWM IP, the pwm period is fixed to 256 local clock cycles.
+ * The only way to change the period (apart from changing the pwm input clock)
+ * is to change the pwm clock prescaler.
+ * The prescaler is of 4 bits, so only 16 prescaler values and hence only
+ * 16 possible period values are supported (for a particular clock rate).
+ * The requested period will be applied only if it matches one of these
+ * 16 values.
+ */
+static int st_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			 int duty_ns, int period_ns)
+{
+	struct st_pwm_chip *pc = to_st_pwmchip(chip);
+	struct device *dev = pc->dev;
+	struct st_pwm_compat_data *cdata = pc->cdata;
+	unsigned int prescale, pwmvalx;
+	unsigned long *found;
+	int ret;
+
+	/*
+	 * Search for matching period value. The corresponding index is our
+	 * prescale value
+	 */
+	found = bsearch(&period_ns, &pc->pwm_periods[0],
+			cdata->max_prescale + 1, sizeof(unsigned long),
+			st_pwm_cmp_periods);
+	if (!found) {
+		dev_err(dev, "failed to find matching period\n");
+		return -EINVAL;
+	}
+
+	prescale = found - &pc->pwm_periods[0];
+
+	/*
+	 * When PWMVal == 0, PWM pulse = 1 local clock cycle.
+	 * When PWMVal == max_pwm_count,
+	 * PWM pulse = (max_pwm_count + 1) local cycles,
+	 * that is continuous pulse: signal never goes low.
+	 */
+	pwmvalx = cdata->max_pwm_cnt * duty_ns / period_ns;
+
+	dev_dbg(dev, "prescale:%u, period:%i, duty:%i, pwmvalx:%u\n",
+		prescale, period_ns, duty_ns, pwmvalx);
+
+	/* Enable clock before writing to PWM registers */
+	ret = clk_enable(pc->clk);
+	if (ret)
+		return ret;
+
+	ret = regmap_field_write(pc->prescale, prescale);
+	if (ret)
+		goto clk_dis;
+
+	ret = regmap_write(pc->regmap, ST_PWMVAL(pwm->hwpwm), pwmvalx);
+	if (ret)
+		goto clk_dis;
+
+	ret = regmap_field_write(pc->pwm_int_en, 0);
+
+clk_dis:
+	clk_disable(pc->clk);
+	return ret;
+}
+
+static int st_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct st_pwm_chip *pc = to_st_pwmchip(chip);
+	struct device *dev = pc->dev;
+	int ret;
+
+	ret = clk_enable(pc->clk);
+	if (ret)
+		return ret;
+
+	ret = regmap_field_write(pc->pwm_en, 1);
+	if (ret)
+		dev_err(dev, "%s,pwm_en write failed\n", __func__);
+
+	return ret;
+}
+
+static void st_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct st_pwm_chip *pc = to_st_pwmchip(chip);
+	struct device *dev = pc->dev;
+	unsigned int val;
+
+	regmap_field_write(pc->pwm_en, 0);
+
+	regmap_read(pc->regmap, ST_CNT, &val);
+
+	dev_dbg(dev, "pwm counter :%u\n", val);
+
+	clk_disable(pc->clk);
+}
+
+static const struct pwm_ops st_pwm_ops = {
+	.config = st_pwm_config,
+	.enable = st_pwm_enable,
+	.disable = st_pwm_disable,
+	.owner = THIS_MODULE,
+};
+
+static int st_pwm_probe_dt(struct st_pwm_chip *pc)
+{
+	struct device *dev = pc->dev;
+	const struct reg_field *reg_fields;
+	struct device_node *np = dev->of_node;
+	struct st_pwm_compat_data *cdata = pc->cdata;
+	u32 num_chan;
+
+	of_property_read_u32(np, "st,pwm-num-chan", &num_chan);
+	if (num_chan)
+		cdata->num_chan = num_chan;
+
+	reg_fields = cdata->reg_fields;
+
+	pc->prescale = devm_regmap_field_alloc(dev, pc->regmap,
+					       reg_fields[PWMCLK_PRESCALE]);
+	pc->pwm_en = devm_regmap_field_alloc(dev, pc->regmap,
+					     reg_fields[PWM_EN]);
+	pc->pwm_int_en = devm_regmap_field_alloc(dev, pc->regmap,
+						 reg_fields[PWM_INT_EN]);
+
+	if (IS_ERR(pc->prescale) ||
+	    IS_ERR(pc->pwm_en)   ||
+	    IS_ERR(pc->pwm_int_en)) {
+		dev_err(dev, "unable to allocate reg_field(s)\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct regmap_config st_pwm_regmap_config = {
+	.reg_bits   = 32,
+	.val_bits   = 32,
+	.reg_stride = 4,
+};
+
+static int st_pwm_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct st_pwm_compat_data *cdata;
+	struct st_pwm_chip *pc;
+	struct resource *res;
+	int ret;
+
+	if (!np) {
+		dev_err(dev, "failed to find device node\n");
+		return -EINVAL;
+	}
+
+	pc = devm_kzalloc(dev, sizeof(*pc), GFP_KERNEL);
+	if (!pc)
+		return -ENOMEM;
+
+	cdata = devm_kzalloc(dev, sizeof(*cdata), GFP_KERNEL);
+	if (!cdata)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	pc->mmio_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(pc->mmio_base)) {
+		dev_err(dev, "failed to find and map memory resources\n");
+		return PTR_ERR(pc->mmio_base);
+	}
+
+	pc->regmap = devm_regmap_init_mmio(dev, pc->mmio_base,
+					   &st_pwm_regmap_config);
+	if (IS_ERR(pc->regmap))
+		return PTR_ERR(pc->regmap);
+
+	/*
+	 * Setup PWM data with default values: some values could be replaced
+	 * with specific ones provided from device tree
+	 */
+	cdata->reg_fields   = &st_pwm_regfields[0];
+	cdata->max_pwm_cnt  = MAX_PWM_CNT_DEFAULT;
+	cdata->max_prescale = MAX_PRESCALE_DEFAULT;
+	cdata->num_chan     = NUM_CHAN_DEFAULT;
+
+	pc->cdata = cdata;
+	pc->dev = dev;
+
+	ret = st_pwm_probe_dt(pc);
+	if (ret)
+		return ret;
+
+	pc->pwm_periods = devm_kzalloc(dev,
+			sizeof(unsigned long) * (pc->cdata->max_prescale + 1),
+			GFP_KERNEL);
+	if (!pc->pwm_periods)
+		return -ENOMEM;
+
+	pc->clk = of_clk_get_by_name(np, "pwm");
+	if (IS_ERR(pc->clk)) {
+		dev_err(dev, "failed to get pwm clock\n");
+		return PTR_ERR(pc->clk);
+	}
+
+	pc->clk_rate = clk_get_rate(pc->clk);
+	if (!pc->clk_rate) {
+		dev_err(dev, "failed to get clk rate\n");
+		return -EINVAL;
+	}
+
+	ret = clk_prepare(pc->clk);
+	if (ret) {
+		dev_err(dev, "failed to prepare clk\n");
+		return ret;
+	}
+
+	st_pwm_calc_periods(pc);
+
+	pc->chip.dev = dev;
+	pc->chip.ops = &st_pwm_ops;
+	pc->chip.base = -1;
+	pc->chip.npwm = pc->cdata->num_chan;
+	pc->chip.can_sleep = true;
+
+	ret = pwmchip_add(&pc->chip);
+	if (ret < 0) {
+		clk_unprepare(pc->clk);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, pc);
+
+	return 0;
+}
+
+static int st_pwm_remove(struct platform_device *pdev)
+{
+	struct st_pwm_chip *pc = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < pc->cdata->num_chan; i++)
+		pwm_disable(&pc->chip.pwms[i]);
+
+	clk_unprepare(pc->clk);
+
+	return pwmchip_remove(&pc->chip);
+}
+
+static struct of_device_id st_pwm_of_match[] = {
+	{ .compatible = "st,sti-pwm", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, st_pwm_of_match);
+
+static struct platform_driver st_pwm_driver = {
+	.driver = {
+		.name	= "st-pwm",
+		.owner  = THIS_MODULE,
+		.of_match_table = st_pwm_of_match,
+	},
+	.probe		= st_pwm_probe,
+	.remove		= st_pwm_remove,
+};
+module_platform_driver(st_pwm_driver);
+
+MODULE_AUTHOR("STMicroelectronics (R&D) Limited <ajitpal.singh@st.com>");
+MODULE_DESCRIPTION("STMicroelectronics ST PWM driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.2

