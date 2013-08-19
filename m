Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750737Ab3HSDQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 23:16:38 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:26305 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab3HSDQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 23:16:37 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Bo Shen <voice.shen@atmel.com>
Subject: [RFC PATCH] pwm: atmel-pwm: add pwm controller driver
Date: Mon, 19 Aug 2013 11:11:06 +0800
Message-Id: <1376881866-14214-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add atmel pwm controller driver based on PWM framework

this is basic function implementation of pwm controller
it can work with pwm based led and backlight

Signed-off-by: Bo Shen <voice.shen@atmel.com>

---
This patch is based on Linux v3.11 rc6
Tested on sama5d31ek and at91sam9m10g45ek board
---
 .../devicetree/bindings/pwm/atmel-pwm.txt          |   19 ++
 drivers/pwm/Kconfig                                |    9 +
 drivers/pwm/Makefile                               |    1 +
 drivers/pwm/pwm-atmel.c                            |  327 ++++++++++++++++++++
 4 files changed, 356 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/atmel-pwm.txt
 create mode 100644 drivers/pwm/pwm-atmel.c

diff --git a/Documentation/devicetree/bindings/pwm/atmel-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-pwm.txt
new file mode 100644
index 0000000..127fcdb
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/atmel-pwm.txt
@@ -0,0 +1,19 @@
+Atmel PWM controller
+
+Required properties:
+  - compatible: should be one of:
+    - "atmel,at91sam9rl-pwm"
+    - "atmel,sama5-pwm"
+  - reg: physical base address and length of the controller's registers
+  - #pwm-cells: Should be 3.
+    - The first cell specifies the per-chip index of the PWM to use
+    - The second cell is the period in nanoseconds
+    - The third cell is used to encode the polarity of PWM output
+
+Example:
+
+	pwm0: pwm@f8034000 {
+		compatible = "atmel,at91sam9rl-pwm";
+		reg = <0xf8034000 0x400>;
+		#pwm-cells = <3>;
+	};
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 75840b5..54237b9 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -41,6 +41,15 @@ config PWM_AB8500
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-ab8500.
 
+config PWM_ATMEL
+	tristate "Atmel PWM support"
+	depends on ARCH_AT91
+	help
+	  Generic PWM framework driver for Atmel SoC.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-atmel.
+
 config PWM_ATMEL_TCB
 	tristate "Atmel TC Block PWM support"
 	depends on ATMEL_TCLIB && OF
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 77a8c18..5b193f8 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_PWM)		+= core.o
 obj-$(CONFIG_PWM_SYSFS)		+= sysfs.o
 obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
+obj-$(CONFIG_PWM_ATMEL)		+= pwm-atmel.o
 obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
 obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
 obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
new file mode 100644
index 0000000..b83d68e
--- /dev/null
+++ b/drivers/pwm/pwm-atmel.c
@@ -0,0 +1,327 @@
+/*
+ * Driver for Atmel Pulse Width Modulation Controller
+ *
+ * Copyright (C) 2013 Atmel Semiconductor Technology Ltd.
+ *		 Bo Shen <voice.shen@atmel.com>
+ *
+ * GPL v2 or later
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/slab.h>
+
+#define PWM_MR		0x00
+#define PWM_ENA		0x04
+#define PWM_DIS		0x08
+#define PWM_SR		0x0C
+
+#define PWM_CMR		0x00
+
+/* The following register for PWM v1 */
+#define PWMv1_CDTY	0x04
+#define PWMv1_CPRD	0x08
+#define PWMv1_CUPD	0x10
+
+/* The following register for PWM v2 */
+#define PWMv2_CDTY	0x04
+#define PWMv2_CDTYUPD	0x08
+#define PWMv2_CPRD	0x0C
+#define PWMv2_CPRDUPD	0x10
+
+#define PWM_NUM		4
+
+struct atmel_pwm_chip {
+	struct pwm_chip chip;
+	struct clk *clk;
+	void __iomem *base;
+
+	void (*config)(struct atmel_pwm_chip *chip, struct pwm_device *pwm,
+			unsigned int dty, unsigned int prd);
+};
+
+#define to_atmel_pwm_chip(chip) container_of(chip, struct atmel_pwm_chip, chip)
+
+static inline u32 atmel_pwm_readl(struct atmel_pwm_chip *chip, int offset)
+{
+	return readl(chip->base + offset);
+}
+
+static inline void atmel_pwm_writel(struct atmel_pwm_chip *chip, int offset,
+		u32 val)
+{
+	writel(val, chip->base + offset);
+}
+
+static inline u32 atmel_pwm_ch_readl(struct atmel_pwm_chip *chip, int ch,
+		int offset)
+{
+	return readl(chip->base + 0x200 + ch * 0x20 + offset);
+}
+
+static inline void atmel_pwm_ch_writel(struct atmel_pwm_chip *chip, int ch,
+		int offset, u32 val)
+{
+	writel(val, chip->base + 0x200 + ch * 0x20 + offset);
+}
+
+static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+		int duty_ns, int period_ns)
+{
+	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
+	unsigned long long val, prd, dty;
+	unsigned long long div, clk_rate;
+	int ret, pres = 0;
+
+	clk_rate = clk_get_rate(atmel_pwm->clk);
+
+	while (1) {
+		div = 1000000000;
+		div *= 1 << pres;
+		val = clk_rate * period_ns;
+		prd = div_u64(val, div);
+		val = clk_rate * duty_ns;
+		dty = div_u64(val, div);
+
+		if (prd < 0x0001 || dty < 0x0)
+			return -EINVAL;
+
+		if (prd > 0xffff || dty > 0xffff) {
+			if (++pres > 0x10)
+				return -EINVAL;
+			continue;
+		}
+
+		break;
+	}
+
+	/* Enable clock */
+	ret = clk_prepare_enable(atmel_pwm->clk);
+	if (ret) {
+		pr_err("failed to enable pwm clock\n");
+		return ret;
+	}
+
+	atmel_pwm->config(atmel_pwm, pwm, dty, prd);
+
+	/* Check whether need to disable clock */
+	val = atmel_pwm_readl(atmel_pwm, PWM_SR);
+	if ((val & 0xf) == 0)
+		clk_disable_unprepare(atmel_pwm->clk);
+
+	return 0;
+}
+
+static void atmel_pwm_config_v1(struct atmel_pwm_chip *atmel_pwm,
+		struct pwm_device *pwm, unsigned int dty, unsigned int prd)
+{
+	unsigned int val;
+
+	/*
+	 * if the pwm channel is enabled, using update register to update
+	 * related register value, or else write it directly
+	 */
+	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CUPD, dty);
+
+		val = atmel_pwm_ch_readl(atmel_pwm, pwm->hwpwm, PWM_CMR);
+		val &= ~(1 << 10);
+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
+	} else {
+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CDTY, dty);
+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CPRD, prd);
+	}
+}
+
+static void atmel_pwm_config_v2(struct atmel_pwm_chip *atmel_pwm,
+		struct pwm_device *pwm, unsigned int dty, unsigned int prd)
+{
+	/*
+	 * if the pwm channel is enabled, using update register to update
+	 * related register value, or else write it directly
+	 */
+	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CDTYUPD, dty);
+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CPRDUPD, prd);
+	} else {
+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CDTY, dty);
+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv2_CPRD, prd);
+	}
+}
+
+static int atmel_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
+		enum pwm_polarity polarity)
+{
+	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
+	u32 val = 0;
+	int ret;
+
+	/* Enable clock */
+	ret = clk_prepare_enable(atmel_pwm->clk);
+	if (ret) {
+		pr_err("failed to enable pwm clock\n");
+		return ret;
+	}
+
+	if (polarity == PWM_POLARITY_NORMAL)
+		val &= ~(1 << 9);
+	else
+		val |= 1 << 9;
+
+	atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
+
+	/* Disable clock */
+	clk_disable_unprepare(atmel_pwm->clk);
+
+	return 0;
+}
+
+static int atmel_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
+
+	clk_prepare_enable(atmel_pwm->clk);
+
+	atmel_pwm_writel(atmel_pwm, PWM_ENA, 1 << pwm->hwpwm);
+
+	return 0;
+}
+
+static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
+	u32 val;
+
+	atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
+
+	/* Disable clock */
+	val = atmel_pwm_readl(atmel_pwm, PWM_SR);
+	if ((val & 0xf) == 0)
+		clk_disable_unprepare(atmel_pwm->clk);
+}
+
+static const struct pwm_ops atmel_pwm_ops = {
+	.config = atmel_pwm_config,
+	.set_polarity = atmel_pwm_set_polarity,
+	.enable = atmel_pwm_enable,
+	.disable = atmel_pwm_disable,
+	.owner = THIS_MODULE,
+};
+
+struct atmel_pwm_data {
+	void (*config)(struct atmel_pwm_chip *chip, struct pwm_device *pwm,
+			unsigned int dty, unsigned int prd);
+};
+
+static struct atmel_pwm_data atmel_pwm_data_v1 = {
+	.config = atmel_pwm_config_v1,
+};
+
+static struct atmel_pwm_data atmel_pwm_data_v2 = {
+	.config = atmel_pwm_config_v2,
+};
+
+static const struct of_device_id atmel_pwm_dt_ids[] = {
+	{
+		.compatible = "atmel,at91sam9rl-pwm",
+		.data = &atmel_pwm_data_v1,
+	}, {
+		.compatible = "atmel,sama5-pwm",
+		.data = &atmel_pwm_data_v2,
+	}, {
+		/* sentinel */
+	},
+};
+MODULE_DEVICE_TABLE(of, atmel_pwm_dt_ids);
+
+static int atmel_pwm_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *of_id =
+		of_match_device(atmel_pwm_dt_ids, &pdev->dev);
+	const struct atmel_pwm_data *data;
+	struct atmel_pwm_chip *atmel_pwm;
+	struct resource *res;
+	struct pinctrl *pinctrl;
+	int ret;
+
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl)) {
+		dev_err(&pdev->dev, "failed get pinctrl\n");
+		return PTR_ERR(pinctrl);
+	}
+
+	atmel_pwm = devm_kzalloc(&pdev->dev, sizeof(*atmel_pwm), GFP_KERNEL);
+	if (!atmel_pwm) {
+		dev_err(&pdev->dev, "out of memory\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "no memory resource defined\n");
+		return -ENODEV;
+	}
+
+	atmel_pwm->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(atmel_pwm->base)) {
+		dev_err(&pdev->dev, "ioremap failed\n");
+		return PTR_ERR(atmel_pwm->base);
+	}
+
+	atmel_pwm->clk = devm_clk_get(&pdev->dev, "pwm_clk");
+	if (IS_ERR(atmel_pwm->clk)) {
+		dev_err(&pdev->dev, "clk get failed\n");
+		return PTR_ERR(atmel_pwm->clk);
+	}
+
+	atmel_pwm->chip.dev = &pdev->dev;
+	atmel_pwm->chip.ops = &atmel_pwm_ops;
+	atmel_pwm->chip.of_xlate = of_pwm_xlate_with_flags;
+	atmel_pwm->chip.of_pwm_n_cells = 3;
+	atmel_pwm->chip.base = -1;
+	atmel_pwm->chip.npwm = PWM_NUM;
+
+	data = of_id->data;
+	atmel_pwm->config = data->config;
+
+	ret = pwmchip_add(&atmel_pwm->chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to add pwm chip %d\n", ret);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, atmel_pwm);
+
+	dev_info(&pdev->dev, "successfully register pwm\n");
+
+	return 0;
+}
+
+static int atmel_pwm_remove(struct platform_device *pdev)
+{
+	struct atmel_pwm_chip *atmel_pwm = platform_get_drvdata(pdev);
+
+	return pwmchip_remove(&atmel_pwm->chip);
+}
+
+static struct platform_driver atmel_pwm_driver = {
+	.driver = {
+		.name = "atmel-pwm",
+		.of_match_table = of_match_ptr(atmel_pwm_dt_ids),
+	},
+	.probe = atmel_pwm_probe,
+	.remove = atmel_pwm_remove,
+};
+module_platform_driver(atmel_pwm_driver);
+
+MODULE_ALIAS("platform:atmel-pwm");
+MODULE_AUTHOR("Bo Shen <voice.shen@atmel.com>");
+MODULE_DESCRIPTION("Atmel PWM driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

