Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbaDBQ1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:27:54 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:19873 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367AbaDBQ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:27:43 -0400
X-IronPort-AV: E=Sophos;i="4.97,780,1389772800"; 
   d="scan'208";a="22326544"
From: Tim Kryger <tim.kryger@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>,
        Matt Porter <mporter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, "Rob Landley" <rob@landley.net>,
        Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: [RESEND PATCH v5 2/5] pwm: kona: Introduce Kona PWM controller support
Date: Wed, 2 Apr 2014 09:27:21 -0700
Message-ID: <1396456044-19427-3-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396456044-19427-1-git-send-email-tim.kryger@linaro.org>
References: <1396456044-19427-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the six-channel Kona PWM controller found on Broadcom
mobile SoCs like bcm281xx.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 drivers/pwm/Kconfig        |    9 ++
 drivers/pwm/Makefile       |    1 +
 drivers/pwm/pwm-bcm-kona.c |  319 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 329 insertions(+)
 create mode 100644 drivers/pwm/pwm-bcm-kona.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 22f2f28..777d87dd 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -62,6 +62,15 @@ config PWM_ATMEL_TCB
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-atmel-tcb.
 
+config PWM_BCM_KONA
+	tristate "Kona PWM support"
+	depends on ARCH_BCM_MOBILE
+	help
+	  Generic PWM framework driver for Broadcom Kona PWM block.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-bcm-kona.
+
 config PWM_BFIN
 	tristate "Blackfin PWM support"
 	depends on BFIN_GPTIMERS
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index d8906ec..7413090 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_PWM_SYSFS)		+= sysfs.o
 obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
 obj-$(CONFIG_PWM_ATMEL)		+= pwm-atmel.o
 obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
+obj-$(CONFIG_PWM_BCM_KONA)	+= pwm-bcm-kona.o
 obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
 obj-$(CONFIG_PWM_EP93XX)	+= pwm-ep93xx.o
 obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
new file mode 100644
index 0000000..ee8a59d
--- /dev/null
+++ b/drivers/pwm/pwm-bcm-kona.c
@@ -0,0 +1,319 @@
+/*
+ * Copyright (C) 2014 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/math64.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+/*
+ * The Kona PWM has some unusual characteristics.  Here are the main points.
+ *
+ * 1) There is no disable bit and the hardware docs advise programming a zero
+ *    duty to achieve output equivalent to that of a normal disable operation.
+ *
+ * 2) Changes to prescale, duty, period, and polarity do not take effect until
+ *    a subsequent rising edge of the trigger bit.
+ *
+ * 3) If the smooth bit and trigger bit are both low, the output is a constant
+ *    high signal.  Otherwise, the earlier waveform continues to be output.
+ *
+ * 4) If the smooth bit is set on the rising edge of the trigger bit, output
+ *    will transition to the new settings on a period boundary (which could be
+ *    seconds away).  If the smooth bit is clear, new settings will be applied
+ *    as soon as possible (the hardware always has a 400ns delay).
+ *
+ * 5) When the external clock that feeds the PWM is disabled, output is pegged
+ *    high or low depending on its state at that exact instant.
+ */
+
+#define PWM_CONTROL_OFFSET			(0x00000000)
+#define PWM_CONTROL_SMOOTH_SHIFT(chan)		(24 + (chan))
+#define PWM_CONTROL_TYPE_SHIFT(chan)		(16 + (chan))
+#define PWM_CONTROL_POLARITY_SHIFT(chan)	(8 + (chan))
+#define PWM_CONTROL_TRIGGER_SHIFT(chan)		(chan)
+
+#define PRESCALE_OFFSET				(0x00000004)
+#define PRESCALE_SHIFT(chan)			((chan) << 2)
+#define PRESCALE_MASK(chan)			(0x7 << PRESCALE_SHIFT(chan))
+#define PRESCALE_MIN				(0x00000000)
+#define PRESCALE_MAX				(0x00000007)
+
+#define PERIOD_COUNT_OFFSET(chan)		(0x00000008 + ((chan) << 3))
+#define PERIOD_COUNT_MIN			(0x00000002)
+#define PERIOD_COUNT_MAX			(0x00ffffff)
+
+#define DUTY_CYCLE_HIGH_OFFSET(chan)		(0x0000000c + ((chan) << 3))
+#define DUTY_CYCLE_HIGH_MIN			(0x00000000)
+#define DUTY_CYCLE_HIGH_MAX			(0x00ffffff)
+
+struct kona_pwmc {
+	struct pwm_chip chip;
+	void __iomem *base;
+	struct clk *clk;
+};
+
+static inline struct kona_pwmc *to_kona_pwmc(struct pwm_chip *_chip)
+{
+	return container_of(_chip, struct kona_pwmc, chip);
+}
+
+static void kona_pwmc_apply_settings(struct kona_pwmc *kp, unsigned int chan)
+{
+	unsigned int value = readl(kp->base + PWM_CONTROL_OFFSET);
+
+	/* Clear trigger bit but set smooth bit to maintain old output */
+	value |= 1 << PWM_CONTROL_SMOOTH_SHIFT(chan);
+	value &= ~(1 << PWM_CONTROL_TRIGGER_SHIFT(chan));
+	writel(value, kp->base + PWM_CONTROL_OFFSET);
+
+	/* Set trigger bit and clear smooth bit to apply new settings */
+	value &= ~(1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
+	value |= 1 << PWM_CONTROL_TRIGGER_SHIFT(chan);
+	writel(value, kp->base + PWM_CONTROL_OFFSET);
+}
+
+static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			    int duty_ns, int period_ns)
+{
+	struct kona_pwmc *kp = to_kona_pwmc(chip);
+	u64 val, div, rate;
+	unsigned long prescale = PRESCALE_MIN, pc, dc;
+	unsigned int value, chan = pwm->hwpwm;
+
+	/*
+	 * Find period count, duty count and prescale to suit duty_ns and
+	 * period_ns. This is done according to formulas described below:
+	 *
+	 * period_ns = 10^9 * (PRESCALE + 1) * PC / PWM_CLK_RATE
+	 * duty_ns = 10^9 * (PRESCALE + 1) * DC / PWM_CLK_RATE
+	 *
+	 * PC = (PWM_CLK_RATE * period_ns) / (10^9 * (PRESCALE + 1))
+	 * DC = (PWM_CLK_RATE * duty_ns) / (10^9 * (PRESCALE + 1))
+	 */
+
+	rate = clk_get_rate(kp->clk);
+
+	while (1) {
+		div = 1000000000;
+		div *= 1 + prescale;
+		val = rate * period_ns;
+		pc = div64_u64(val, div);
+		val = rate * duty_ns;
+		dc = div64_u64(val, div);
+
+		/* If duty_ns or period_ns are not achievable then return */
+		if (pc < PERIOD_COUNT_MIN || dc < DUTY_CYCLE_HIGH_MIN)
+			return -EINVAL;
+
+		/* If pc and dc are in bounds, the calculation is done */
+		if (pc <= PERIOD_COUNT_MAX && dc <= DUTY_CYCLE_HIGH_MAX)
+			break;
+
+		/* Otherwise, increase prescale and recalculate pc and dc */
+		if (++prescale > PRESCALE_MAX)
+			return -EINVAL;
+	}
+
+	/* If the PWM channel is enabled, write the settings to the HW */
+	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
+		value = readl(kp->base + PRESCALE_OFFSET);
+		value &= ~PRESCALE_MASK(chan);
+		value |= prescale << PRESCALE_SHIFT(chan);
+		writel(value, kp->base + PRESCALE_OFFSET);
+
+		writel(pc, kp->base + PERIOD_COUNT_OFFSET(chan));
+
+		writel(dc, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
+
+		kona_pwmc_apply_settings(kp, chan);
+	}
+
+	return 0;
+}
+
+static int kona_pwmc_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
+				  enum pwm_polarity polarity)
+{
+	struct kona_pwmc *kp = to_kona_pwmc(chip);
+	unsigned int chan = pwm->hwpwm;
+	unsigned int value;
+	int ret;
+
+	ret = clk_prepare_enable(kp->clk);
+
+	if (ret < 0) {
+		dev_err(chip->dev, "failed to enable clock: %d\n", ret);
+		return ret;
+	}
+
+	value = readl(kp->base + PWM_CONTROL_OFFSET);
+
+	if (polarity == PWM_POLARITY_NORMAL)
+		value |= 1 << PWM_CONTROL_POLARITY_SHIFT(chan);
+	else
+		value &= ~(1 << PWM_CONTROL_POLARITY_SHIFT(chan));
+
+	writel(value, kp->base + PWM_CONTROL_OFFSET);
+
+	kona_pwmc_apply_settings(kp, chan);
+
+	/* Wait for waveform to settle before gating off the clock */
+	ndelay(400);
+
+	clk_disable_unprepare(kp->clk);
+
+	return 0;
+}
+
+static int kona_pwmc_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct kona_pwmc *kp = to_kona_pwmc(chip);
+	int ret;
+
+	ret = clk_prepare_enable(kp->clk);
+	if (ret < 0) {
+		dev_err(chip->dev, "failed to enable clock: %d\n", ret);
+		return ret;
+	}
+
+	ret = kona_pwmc_config(chip, pwm, pwm->duty_cycle, pwm->period);
+	if (ret < 0) {
+		clk_disable_unprepare(kp->clk);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void kona_pwmc_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct kona_pwmc *kp = to_kona_pwmc(chip);
+	unsigned int chan = pwm->hwpwm;
+
+	/* Simulate a disable by configuring for zero duty */
+	writel(0, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
+	kona_pwmc_apply_settings(kp, chan);
+
+	/* Wait for waveform to settle before gating off the clock */
+	ndelay(400);
+
+	clk_disable_unprepare(kp->clk);
+}
+
+static const struct pwm_ops kona_pwm_ops = {
+	.config = kona_pwmc_config,
+	.set_polarity = kona_pwmc_set_polarity,
+	.enable = kona_pwmc_enable,
+	.disable = kona_pwmc_disable,
+	.owner = THIS_MODULE,
+};
+
+static int kona_pwmc_probe(struct platform_device *pdev)
+{
+	struct kona_pwmc *kp;
+	struct resource *res;
+	unsigned int chan;
+	unsigned int value = 0;
+	int ret = 0;
+
+	kp = devm_kzalloc(&pdev->dev, sizeof(*kp), GFP_KERNEL);
+	if (kp == NULL)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, kp);
+
+	kp->chip.dev = &pdev->dev;
+	kp->chip.ops = &kona_pwm_ops;
+	kp->chip.base = -1;
+	kp->chip.npwm = 6;
+	kp->chip.of_xlate = of_pwm_xlate_with_flags;
+	kp->chip.of_pwm_n_cells = 3;
+	kp->chip.can_sleep = true;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	kp->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(kp->base))
+		return PTR_ERR(kp->base);
+
+	kp->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(kp->clk)) {
+		dev_err(&pdev->dev, "failed to get clock: %ld\n",
+			PTR_ERR(kp->clk));
+		return PTR_ERR(kp->clk);
+	}
+
+	ret = clk_prepare_enable(kp->clk);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to enable clock: %d\n", ret);
+		return ret;
+	}
+
+	/* Set smooth mode, push/pull, and normal polarity for all channels */
+	for (chan = 0; chan < kp->chip.npwm; chan++) {
+		value |= (1 << PWM_CONTROL_SMOOTH_SHIFT(chan));
+		value |= (1 << PWM_CONTROL_TYPE_SHIFT(chan));
+		value |= (1 << PWM_CONTROL_POLARITY_SHIFT(chan));
+	}
+
+	writel(value, kp->base + PWM_CONTROL_OFFSET);
+
+	clk_disable_unprepare(kp->clk);
+
+	ret = pwmchip_add(&kp->chip);
+	if (ret < 0)
+		dev_err(&pdev->dev, "failed to add PWM chip: %d\n", ret);
+
+	return ret;
+}
+
+static int kona_pwmc_remove(struct platform_device *pdev)
+{
+	struct kona_pwmc *kp = platform_get_drvdata(pdev);
+	unsigned int chan;
+
+	for (chan = 0; chan < kp->chip.npwm; chan++)
+		if (test_bit(PWMF_ENABLED, &kp->chip.pwms[chan].flags))
+			clk_disable_unprepare(kp->clk);
+
+	return pwmchip_remove(&kp->chip);
+}
+
+static const struct of_device_id bcm_kona_pwmc_dt[] = {
+	{ .compatible = "brcm,kona-pwm" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, bcm_kona_pwmc_dt);
+
+static struct platform_driver kona_pwmc_driver = {
+	.driver = {
+		.name = "bcm-kona-pwm",
+		.of_match_table = bcm_kona_pwmc_dt,
+	},
+	.probe = kona_pwmc_probe,
+	.remove = kona_pwmc_remove,
+};
+
+module_platform_driver(kona_pwmc_driver);
+MODULE_AUTHOR("Broadcom Corporation <bcm-kernel-feedback-list@broadcom.com>");
+MODULE_AUTHOR("Tim Kryger <tkryger@broadcom.com>");
+MODULE_DESCRIPTION("Broadcom Kona PWM driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

