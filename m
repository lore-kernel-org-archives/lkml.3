Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaIOTOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:14:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40615 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754510AbaIOTOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:14:05 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, jonsmirl@gmail.com,
        Simon <longsleep@gmail.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv6 1/2] pwm: Add Allwinner SoC support
Date: Mon, 15 Sep 2014 21:13:55 +0200
Message-Id: <1410808436-21460-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410808436-21460-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410808436-21460-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a generic PWM framework driver for the PWM controller
found on Allwinner SoCs.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/pwm/Kconfig     |   9 ++
 drivers/pwm/Makefile    |   1 +
 drivers/pwm/pwm-sunxi.c | 371 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 381 insertions(+)
 create mode 100644 drivers/pwm/pwm-sunxi.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 4ad7b89a4cb4..426d2b49b76e 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -226,6 +226,15 @@ config PWM_SPEAR
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-spear.
 
+config PWM_SUNXI
+	tristate "Allwinner PWM support"
+	depends on ARCH_SUNXI || COMPILE_TEST
+	help
+	  Generic PWM framework driver for Allwinner SoCs.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-sunxi.
+
 config PWM_TEGRA
 	tristate "NVIDIA Tegra PWM support"
 	depends on ARCH_TEGRA
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 5c86a19d5d39..c32f8275cae8 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_PWM_PXA)		+= pwm-pxa.o
 obj-$(CONFIG_PWM_RENESAS_TPU)	+= pwm-renesas-tpu.o
 obj-$(CONFIG_PWM_SAMSUNG)	+= pwm-samsung.o
 obj-$(CONFIG_PWM_SPEAR)		+= pwm-spear.o
+obj-$(CONFIG_PWM_SUNXI)		+= pwm-sunxi.o
 obj-$(CONFIG_PWM_TEGRA)		+= pwm-tegra.o
 obj-$(CONFIG_PWM_TIECAP)	+= pwm-tiecap.o
 obj-$(CONFIG_PWM_TIEHRPWM)	+= pwm-tiehrpwm.o
diff --git a/drivers/pwm/pwm-sunxi.c b/drivers/pwm/pwm-sunxi.c
new file mode 100644
index 000000000000..d8e60eb97776
--- /dev/null
+++ b/drivers/pwm/pwm-sunxi.c
@@ -0,0 +1,371 @@
+/*
+ * Driver for Allwinner Pulse Width Modulation Controller
+ *
+ * Copyright (C) 2014 Alexandre Belloni <alexandre.belloni@free-electrons.com>
+ *
+ * Licensed under GPLv2.
+ */
+
+#include <linux/bitops.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+
+#define PWM_CTRL_REG		0x0
+
+#define PWM_CH_PRD_BASE		0x4
+#define PWM_CH_PRD_OFFSET	0x4
+#define PWM_CH_PRD(ch)		(PWM_CH_PRD_BASE + PWM_CH_PRD_OFFSET * (ch))
+
+#define PWMCH_OFFSET		15
+#define PWM_PRESCAL_MASK	GENMASK(3, 0)
+#define PWM_PRESCAL_OFF		0
+#define PWM_EN			BIT(4)
+#define PWM_ACT_STATE		BIT(5)
+#define PWM_CLK_GATING		BIT(6)
+#define PWM_MODE		BIT(7)
+#define PWM_PULSE		BIT(8)
+#define PWM_BYPASS		BIT(9)
+
+#define PWM_RDY_BASE		28
+#define PWM_RDY_OFFSET		1
+#define PWM_RDY(ch)		BIT(PWM_RDY_BASE + PWM_RDY_OFFSET * (ch))
+
+#define PWM_PRD(prd)		(((prd) - 1) << 16)
+#define PWM_PRD_MASK		GENMASK(15, 0)
+
+#define PWM_DTY_MASK		GENMASK(15, 0)
+
+#define BIT_CH(bit, chan)	(bit << (chan * PWMCH_OFFSET))
+
+static const u32 prescaler_table[] = {
+	120,
+	180,
+	240,
+	360,
+	480,
+	0,
+	0,
+	0,
+	12000,
+	24000,
+	36000,
+	48000,
+	72000,
+	0,
+	0,
+	0, /* Actually 1 but tested separately */
+};
+
+struct sunxi_pwm_data {
+	bool has_prescaler_bypass;
+	bool has_rdy;
+};
+
+struct sunxi_pwm_chip {
+	struct pwm_chip chip;
+	struct clk *clk;
+	void __iomem *base;
+	struct mutex ctrl_lock;
+	const struct sunxi_pwm_data *data;
+};
+
+static inline struct sunxi_pwm_chip *to_sunxi_pwm_chip(struct pwm_chip *chip)
+{
+	return container_of(chip, struct sunxi_pwm_chip, chip);
+}
+
+static inline u32 sunxi_pwm_readl(struct sunxi_pwm_chip *chip,
+				  unsigned long offset)
+{
+	return readl(chip->base + offset);
+}
+
+
+static inline void sunxi_pwm_writel(struct sunxi_pwm_chip *chip,
+				    u32 val, unsigned long offset)
+{
+	writel(val, chip->base + offset);
+}
+
+static int sunxi_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			    int duty_ns, int period_ns)
+{
+	struct sunxi_pwm_chip *sunxi_pwm = to_sunxi_pwm_chip(chip);
+	u32 clk_rate, prd, dty, val, clk_gate;
+	u64 div = 0;
+	unsigned int prescaler = 0;
+	int err;
+
+	clk_rate = clk_get_rate(sunxi_pwm->clk);
+
+	if (sunxi_pwm->data->has_prescaler_bypass) {
+		/* First, test without any prescaler when available */
+		prescaler = PWM_PRESCAL_MASK;
+		/*
+		 * When not using any prescaler, the clock period in nanoseconds
+		 * is not an integer so round it half up instead of
+		 * truncating to get less surprising values.
+		 */
+		div = clk_rate * (u64)period_ns + NSEC_PER_SEC/2;
+		do_div(div, NSEC_PER_SEC)
+		if (div - 1 > PWM_PRD_MASK)
+			prescaler = 0;
+	}
+
+	if (prescaler == 0) {
+		/* Go up from the first divider */
+		for (prescaler = 0; prescaler < PWM_PRESCAL_MASK; prescaler++) {
+			if (!prescaler_table[prescaler])
+				continue;
+			div = clk_rate / prescaler_table[prescaler];
+			div = div * (u64)period_ns;
+			do_div(div, NSEC_PER_SEC);
+			if (div - 1 <= PWM_PRD_MASK)
+				break;
+		}
+
+		if (div - 1 > PWM_PRD_MASK) {
+			dev_err(chip->dev, "period exceeds the maximum value\n");
+			return -EINVAL;
+		}
+	}
+
+	prd = div;
+	div *= duty_ns;
+	do_div(div, period_ns);
+	dty = div;
+
+	err = clk_prepare_enable(sunxi_pwm->clk);
+	if (err) {
+		dev_err(chip->dev, "failed to enable PWM clock\n");
+		return err;
+	}
+
+	mutex_lock(&sunxi_pwm->ctrl_lock);
+	val = sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
+
+	if (sunxi_pwm->data->has_rdy && (val & PWM_RDY(pwm->hwpwm))) {
+		mutex_unlock(&sunxi_pwm->ctrl_lock);
+		clk_disable_unprepare(sunxi_pwm->clk);
+		return -EBUSY;
+	}
+
+	clk_gate = val & BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
+	if (clk_gate) {
+		val &= ~BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
+		sunxi_pwm_writel(sunxi_pwm, val, PWM_CTRL_REG);
+	}
+
+	val = sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
+	val &= ~BIT_CH(PWM_PRESCAL_MASK, pwm->hwpwm);
+	val |= BIT_CH(prescaler, pwm->hwpwm);
+	sunxi_pwm_writel(sunxi_pwm, val, PWM_CTRL_REG);
+
+	val = (dty & PWM_DTY_MASK) | PWM_PRD(prd);
+	sunxi_pwm_writel(sunxi_pwm, val, PWM_CH_PRD(pwm->hwpwm));
+
+	if (clk_gate) {
+		val = sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
+		val |= clk_gate;
+		sunxi_pwm_writel(sunxi_pwm, val, PWM_CTRL_REG);
+	}
+
+	mutex_unlock(&sunxi_pwm->ctrl_lock);
+	clk_disable_unprepare(sunxi_pwm->clk);
+
+	return 0;
+}
+
+static int sunxi_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
+				  enum pwm_polarity polarity)
+{
+	struct sunxi_pwm_chip *sunxi_pwm = to_sunxi_pwm_chip(chip);
+	u32 val;
+	int ret;
+
+	ret = clk_prepare_enable(sunxi_pwm->clk);
+	if (ret) {
+		dev_err(chip->dev, "failed to enable PWM clock\n");
+		return ret;
+	}
+
+	mutex_lock(&sunxi_pwm->ctrl_lock);
+	val = sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
+
+	if (polarity != PWM_POLARITY_NORMAL)
+		val &= ~BIT_CH(PWM_ACT_STATE, pwm->hwpwm);
+	else
+		val |= BIT_CH(PWM_ACT_STATE, pwm->hwpwm);
+
+	sunxi_pwm_writel(sunxi_pwm, val, PWM_CTRL_REG);
+
+	mutex_unlock(&sunxi_pwm->ctrl_lock);
+	clk_disable_unprepare(sunxi_pwm->clk);
+
+	return 0;
+}
+
+static int sunxi_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct sunxi_pwm_chip *sunxi_pwm = to_sunxi_pwm_chip(chip);
+	u32 val;
+	int ret;
+
+	ret = clk_prepare_enable(sunxi_pwm->clk);
+	if (ret) {
+		dev_err(chip->dev, "failed to enable PWM clock\n");
+		return ret;
+	}
+
+	mutex_lock(&sunxi_pwm->ctrl_lock);
+	val = sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
+	val |= BIT_CH(PWM_EN, pwm->hwpwm);
+	val |= BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
+	sunxi_pwm_writel(sunxi_pwm, val, PWM_CTRL_REG);
+	mutex_unlock(&sunxi_pwm->ctrl_lock);
+
+	return 0;
+}
+
+static void sunxi_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct sunxi_pwm_chip *sunxi_pwm = to_sunxi_pwm_chip(chip);
+	u32 val;
+
+	mutex_lock(&sunxi_pwm->ctrl_lock);
+	val = sunxi_pwm_readl(sunxi_pwm, PWM_CTRL_REG);
+	val &= ~BIT_CH(PWM_EN, pwm->hwpwm);
+	val &= ~BIT_CH(PWM_CLK_GATING, pwm->hwpwm);
+	sunxi_pwm_writel(sunxi_pwm, val, PWM_CTRL_REG);
+	mutex_unlock(&sunxi_pwm->ctrl_lock);
+
+	clk_disable_unprepare(sunxi_pwm->clk);
+}
+
+static const struct pwm_ops sunxi_pwm_ops = {
+	.config = sunxi_pwm_config,
+	.set_polarity = sunxi_pwm_set_polarity,
+	.enable = sunxi_pwm_enable,
+	.disable = sunxi_pwm_disable,
+	.owner = THIS_MODULE,
+};
+
+static const struct sunxi_pwm_data sunxi_pwm_data_a10 = {
+	.has_prescaler_bypass = false,
+	.has_rdy = false,
+};
+
+static const struct sunxi_pwm_data sunxi_pwm_data_a20 = {
+	.has_prescaler_bypass = true,
+	.has_rdy = true,
+};
+
+static const struct of_device_id sunxi_pwm_dt_ids[] = {
+	{
+		.compatible = "allwinner,sun4i-a10-pwm",
+		.data = &sunxi_pwm_data_a10,
+	}, {
+		.compatible = "allwinner,sun7i-a20-pwm",
+		.data = &sunxi_pwm_data_a20,
+	}, {
+		/* sentinel */
+	},
+};
+MODULE_DEVICE_TABLE(of, sunxi_pwm_dt_ids);
+
+static int sunxi_pwm_probe(struct platform_device *pdev)
+{
+	struct sunxi_pwm_chip *pwm;
+	struct resource *res;
+	u32 val;
+	int i, ret;
+	const struct of_device_id *match;
+
+	match = of_match_device(sunxi_pwm_dt_ids, &pdev->dev);
+
+	pwm = devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
+	if (!pwm)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pwm->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pwm->base))
+		return PTR_ERR(pwm->base);
+
+	pwm->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(pwm->clk))
+		return PTR_ERR(pwm->clk);
+
+	pwm->chip.dev = &pdev->dev;
+	pwm->chip.ops = &sunxi_pwm_ops;
+	pwm->chip.base = -1;
+	pwm->chip.npwm = 2;
+	pwm->chip.can_sleep = true;
+	pwm->chip.of_xlate = of_pwm_xlate_with_flags;
+	pwm->chip.of_pwm_n_cells = 3;
+	pwm->data = match->data;
+
+	mutex_init(&pwm->ctrl_lock);
+
+	ret = pwmchip_add(&pwm->chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to add PWM chip %d\n", ret);
+		goto error;
+	}
+
+	ret = clk_prepare_enable(pwm->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to enable PWM clock\n");
+		goto error;
+	}
+
+	val = sunxi_pwm_readl(pwm, PWM_CTRL_REG);
+	for (i = 0; i < pwm->chip.npwm; i++) {
+		if (!(val & BIT_CH(PWM_ACT_STATE, i)))
+			pwm->chip.pwms[i].polarity = PWM_POLARITY_INVERSED;
+	}
+
+	clk_disable_unprepare(pwm->clk);
+
+	platform_set_drvdata(pdev, pwm);
+
+	return ret;
+
+error:
+	mutex_destroy(&pwm->ctrl_lock);
+	clk_disable_unprepare(pwm->clk);
+	return ret;
+}
+
+static int sunxi_pwm_remove(struct platform_device *pdev)
+{
+	struct sunxi_pwm_chip *pwm = platform_get_drvdata(pdev);
+
+	mutex_destroy(&pwm->ctrl_lock);
+
+	return pwmchip_remove(&pwm->chip);
+}
+
+static struct platform_driver sunxi_pwm_driver = {
+	.driver = {
+		.name = "sunxi-pwm",
+		.of_match_table = sunxi_pwm_dt_ids,
+	},
+	.probe = sunxi_pwm_probe,
+	.remove = sunxi_pwm_remove,
+};
+module_platform_driver(sunxi_pwm_driver);
+
+MODULE_ALIAS("platform:sunxi-pwm");
+MODULE_AUTHOR("Alexandre Belloni <alexandre.belloni@free-electrons.com>");
+MODULE_DESCRIPTION("Allwinner PWM driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

