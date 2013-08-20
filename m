Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab3HTIMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:12:42 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:10437 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab3HTIMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:12:39 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Bo Shen <voice.shen@atmel.com>
Subject: [v2 PATCH] PWM: atmel-pwm: add PWM controller driver
Date: Tue, 20 Aug 2013 16:11:55 +0800
Message-Id: <1376986316-10874-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Atmel PWM controller driver based on PWM framework.

This is the basic function implementation of Atmel PWM controller.
It can work with PWM based led and backlight.

Signed-off-by: Bo Shen <voice.shen@atmel.com>

---
This patch is based on the for-next branch on Linux pwm tree
Test on at91sam9m10g45ek board with pwm led
Test on sama5d31ek board with pwm backlight

Changes in v2:
  - Address the comments from Thierry Reding

 .../devicetree/bindings/pwm/atmel-pwm.txt          |   17 +
 drivers/pwm/Kconfig                                |    9 +
 drivers/pwm/Makefile                               |    1 +
 drivers/pwm/pwm-atmel.c                            |  328 ++++++++++++++++++++
 4 files changed, 355 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/atmel-pwm.txt
 create mode 100644 drivers/pwm/pwm-atmel.c

diff --git a/Documentation/devicetree/bindings/pwm/atmel-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-pwm.txt
new file mode 100644
index 0000000..f7b04f7
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/atmel-pwm.txt
@@ -0,0 +1,17 @@
+Atmel PWM controller
+
+Required properties:
+  - compatible: should be one of:
+    - "atmel,at91sam9rl-pwm"
+    - "atmel,sama5-pwm"
+  - reg: physical base address and length of the controller's registers
+  - #pwm-cells: Should be 3. See pwm.txt in this directory for a
+    description of the cells format
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
index 0000000..a9af974
--- /dev/null
+++ b/drivers/pwm/pwm-atmel.c
@@ -0,0 +1,328 @@
+/*
+ * Driver for Atmel Pulse Width Modulation Controller
+ *
+ * Copyright (C) 2013 Atmel Semiconductor Technology Ltd.
+ *		 Bo Shen <voice.shen@atmel.com>
+ *
+ * GPL v2
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/slab.h>
+
+/* The following is global registers for PWM controller */
+#define PWM_ENA		0x04
+#define PWM_DIS		0x08
+#define PWM_SR		0x0C
+/* bit field in SR */
+#define PWM_SR_ALL_CH_ON	0x0F
+
+/* The following register is PWM channel related registers */
+#define PWM_CMR		0x00
+/* bit field in CMR */
+#define PWM_CMR_CPOL		(1 << 9)
+#define PWM_CMR_UPD_CDTY	(1 << 10)
+
+/* The following registers for PWM v1 */
+#define PWMv1_CDTY	0x04
+#define PWMv1_CPRD	0x08
+#define PWMv1_CUPD	0x10
+
+/* The following registers for PWM v2 */
+#define PWMv2_CDTY	0x04
+#define PWMv2_CDTYUPD	0x08
+#define PWMv2_CPRD	0x0C
+#define PWMv2_CPRDUPD	0x10
+
+struct atmel_pwm_chip {
+	struct pwm_chip chip;
+	struct clk *clk;
+	void __iomem *base;
+
+	void (*config)(struct pwm_chip *chip, struct pwm_device *pwm,
+		       int dty, int prd);
+};
+
+static inline struct atmel_pwm_chip *to_atmel_pwm_chip(struct pwm_chip *chip)
+{
+	return container_of(chip, struct atmel_pwm_chip, chip);
+}
+
+static inline u32 atmel_pwm_readl(struct atmel_pwm_chip *chip,
+				  unsigned long offset)
+{
+	return readl(chip->base + offset);
+}
+
+static inline void atmel_pwm_writel(struct atmel_pwm_chip *chip,
+				    unsigned long offset, unsigned long val)
+{
+	writel(val, chip->base + offset);
+}
+
+static inline u32 atmel_pwm_ch_readl(struct atmel_pwm_chip *chip,
+				     unsigned int ch, unsigned long offset)
+{
+	return readl(chip->base + 0x200 + ch * 0x20 + offset);
+}
+
+static inline void atmel_pwm_ch_writel(struct atmel_pwm_chip *chip,
+				       unsigned int ch, unsigned long offset,
+				       unsigned long val)
+{
+	writel(val, chip->base + 0x200 + ch * 0x20 + offset);
+}
+
+static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+		int duty_ns, int period_ns)
+{
+	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
+	unsigned long long val, prd, dty, div, clk_rate;
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
+		if (prd < 1 || dty < 0)
+			return -EINVAL;
+
+		/*
+		 * Although the period register is 32 bit,
+		 * however the LSB 16 bits is used
+		 */
+		if (prd > 0xffff || dty > 0xffff) {
+			if (++pres > 16)
+				return -EINVAL;
+			continue;
+		}
+
+		break;
+	}
+
+	ret = clk_enable(atmel_pwm->clk);
+	if (ret) {
+		pr_err("failed to enable pwm clock\n");
+		return ret;
+	}
+
+	atmel_pwm->config(chip, pwm, dty, prd);
+
+	/* Check whether need to disable clock */
+	val = atmel_pwm_readl(atmel_pwm, PWM_SR);
+	if ((val & PWM_SR_ALL_CH_ON) == 0)
+		clk_disable(atmel_pwm->clk);
+
+	return 0;
+}
+
+static void atmel_pwm_config_v1(struct pwm_chip *chip, struct pwm_device *pwm,
+				int dty, int prd)
+{
+	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
+	unsigned int val;
+
+	/*
+	 * If the PWM channel is disabled, write value to duty and period
+	 * registers directly.
+	 * If the PWM channel is enabled, only update the duty register
+	 *
+	 * When update duty value, it need to set bit 10 of CMR to 0
+	 */
+	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CUPD, dty);
+
+		val = atmel_pwm_ch_readl(atmel_pwm, pwm->hwpwm, PWM_CMR);
+		val &= ~PWM_CMR_UPD_CDTY;
+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
+	} else {
+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CDTY, dty);
+		atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWMv1_CPRD, prd);
+	}
+}
+
+static void atmel_pwm_config_v2(struct pwm_chip *chip, struct pwm_device *pwm,
+				int dty, int prd)
+{
+	struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
+
+	/*
+	 * If the PWM channel is disabled, write value to duty and period
+	 * registers directly.
+	 * If the PWM channel is enabled, using period update register to update
+	 * value to period register, the same operation to duty register
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
+	ret = clk_enable(atmel_pwm->clk);
+	if (ret) {
+		pr_err("failed to enable pwm clock\n");
+		return ret;
+	}
+
+	if (polarity == PWM_POLARITY_NORMAL)
+		val &= ~PWM_CMR_CPOL;
+	else
+		val |= PWM_CMR_CPOL;
+
+	atmel_pwm_ch_writel(atmel_pwm, pwm->hwpwm, PWM_CMR, val);
+
+	clk_disable(atmel_pwm->clk);
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
+	val = atmel_pwm_readl(atmel_pwm, PWM_SR);
+	if ((val & PWM_SR_ALL_CH_ON) == 0)
+		clk_disable(atmel_pwm->clk);
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
+	void (*config)(struct pwm_chip *chip, struct pwm_device *pwm,
+		       int dty, int prd);
+};
+
+static const struct atmel_pwm_data atmel_pwm_data_v1 = {
+	.config = atmel_pwm_config_v1,
+};
+
+static const struct atmel_pwm_data atmel_pwm_data_v2 = {
+	.config = atmel_pwm_config_v2,
+};
+
+#ifdef CONFIG_OF
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
+#endif
+
+static int atmel_pwm_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *of_id =
+		of_match_device(atmel_pwm_dt_ids, &pdev->dev);
+	const struct atmel_pwm_data *data;
+	struct atmel_pwm_chip *atmel_pwm;
+	struct resource *res;
+	int ret;
+
+	atmel_pwm = devm_kzalloc(&pdev->dev, sizeof(*atmel_pwm), GFP_KERNEL);
+	if (!atmel_pwm)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	atmel_pwm->base = devm_ioremap_resource(&pdev->dev, res);
+
+	atmel_pwm->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(atmel_pwm->clk))
+		return PTR_ERR(atmel_pwm->clk);
+	clk_prepare(atmel_pwm->clk);
+
+	atmel_pwm->chip.dev = &pdev->dev;
+	atmel_pwm->chip.ops = &atmel_pwm_ops;
+	atmel_pwm->chip.of_xlate = of_pwm_xlate_with_flags;
+	atmel_pwm->chip.of_pwm_n_cells = 3;
+	atmel_pwm->chip.base = -1;
+	atmel_pwm->chip.npwm = 4;
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
+	return 0;
+}
+
+static int atmel_pwm_remove(struct platform_device *pdev)
+{
+	struct atmel_pwm_chip *atmel_pwm = platform_get_drvdata(pdev);
+
+	clk_unprepare(atmel_pwm->clk);
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

