Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaJGOEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:04:25 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:54495 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaJGOEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:04:24 -0400
From: Bart Tanghe <bart.tanghe@thomasmore.be>
To: thierry.reding@gmail.com
Cc: matt.porter@linaro.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        bart.tanghe@thomasmore.be
Subject: [PATCH v6]pwm: add BCM2835 PWM driver
Date: Tue,  7 Oct 2014 16:04:25 +0200
Message-Id: <1412690665-15416-1-git-send-email-bart.tanghe@thomasmore.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pwm driver for Broadcom BCM2835 processor (Raspberry Pi)

Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>
---
Changes in v6:
 - changed the global index of the pwm to local pwm index
 - change to the mainline kernel Kconfig architecture dependency
 - clean up the code (Stephen Warren comments)

diff --git a/Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt b/Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt
new file mode 100644
index 0000000..99f1d7d
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt
@@ -0,0 +1,27 @@
+BCM2835 PWM controller (Raspberry Pi controller)
+
+Required properties:
+- compatible: should be "brcm,bcm2835-pwm"
+- reg: physical base address and length of the controller's registers
+- clock: this clock defines the base clock frequency of the pwm
+hardware system, the period and the duty_cycle of the pwm signal is a
+multiple of the base period
+
+Examples:
+
+pwm@2020c000 {
+	compatible = "brcm,bcm2835-pwm";
+	reg = <0x2020c000 0x28>;
+	clocks = <&clk_pwm>;
+};
+
+clocks {
+	....
+		clk_pwm: pwm {
+			compatible = "fixed-clock";
+			reg = <3>;
+			#clock-cells = <0>;
+			clock-frequency = <9200000>;
+		};
+	....
+};
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 90c5c73..e533178 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -29,6 +29,15 @@ menuconfig PWM
 
 if PWM
 
+config PWM_BCM2835
+	tristate "BCM2835 PWM support"
+	depends on ARCH_BCM2835
+	help
+	  PWM framework driver for BCM2835 controller (Raspberry Pi)
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-bcm2835
+
 config PWM_BFIN
 	tristate "Blackfin PWM support"
 	depends on BFIN_GPTIMERS
diff --git a/drivers/pwm/pwm-bcm2835.c b/drivers/pwm/pwm-bcm2835.c
new file mode 100644
index 0000000..bc439e8
--- /dev/null
+++ b/drivers/pwm/pwm-bcm2835.c
@@ -0,0 +1,201 @@
+/*
+ * Copyright 2014 Bart Tanghe <bart.tanghe@thomasmore.be>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+
+#define DUTY		0x14
+#define PERIOD		0x10
+#define CHANNEL	0x10
+
+#define PWM_ENABLE	(1 << 0)
+#define PWM_POLARITY	(1 << 4)
+
+#define PWM_CONTROL_MASK	0xff
+#define PWM_MODE		0x80		/* set timer in pwm mode */
+#define DEFAULT		0xff		/* set timer in default mode */
+#define PWM_CONTROL_STRIDE	8
+#define MIN_PERIOD		108		/* 9.2Mhz max pwm clock */
+
+struct bcm2835_pwm {
+	struct pwm_chip chip;
+	struct device *dev;
+	int channel;
+	unsigned long scaler;
+	void __iomem *base;
+	struct clk *clk;
+};
+
+static inline struct bcm2835_pwm  *to_bcm2835_pwm(struct pwm_chip *chip)
+{
+	return container_of(chip, struct bcm2835_pwm, chip);
+}
+
+static int bcm2835_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
+	u32 value;
+
+	value = readl(pc->base);
+	value &= ~(PWM_CONTROL_MASK << PWM_CONTROL_STRIDE * pwm->hwpwm);
+	value |= (PWM_MODE << (PWM_CONTROL_STRIDE * pwm->hwpwm));
+	writel(value, pc->base);
+	return 0;
+}
+
+static void bcm2835_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
+	u32 value;
+
+	value = readl(pc->base);
+	value &= (~DEFAULT << (PWM_CONTROL_STRIDE * pwm->hwpwm));
+	writel(value, pc->base);
+}
+
+static int bcm2835_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			      int duty_ns, int period_ns)
+{
+	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
+
+	if (period_ns <= MIN_PERIOD) {
+		dev_err(pc->dev, "Period not supported\n");
+		return -EINVAL;
+	}
+	writel(duty_ns / pc->scaler, pc->base + DUTY + pwm->hwpwm * CHANNEL);
+	writel(period_ns / pc->scaler,
+		pc->base + PERIOD + pwm->hwpwm * CHANNEL);
+	return 0;
+}
+
+static int bcm2835_pwm_enable(struct pwm_chip *chip,
+			      struct pwm_device *pwm)
+{
+	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
+	u32 value;
+
+	value = readl(pc->base);
+	value |= (PWM_ENABLE << (PWM_CONTROL_STRIDE * pwm->hwpwm));
+	writel(value, pc->base);
+	return 0;
+}
+
+static void bcm2835_pwm_disable(struct pwm_chip *chip,
+				struct pwm_device *pwm)
+{
+	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
+	u32 value;
+
+	value = readl(pc->base);
+	value &= ~(PWM_ENABLE << (PWM_CONTROL_STRIDE * pwm->hwpwm));
+	writel(value, pc->base);
+}
+
+static int bcm2835_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
+				enum pwm_polarity polarity)
+{
+	struct bcm2835_pwm *pc = to_bcm2835_pwm(chip);
+	u32 value;
+
+	value = readl(pc->base);
+	if (polarity == PWM_POLARITY_NORMAL)
+		value &= ~(PWM_POLARITY << PWM_CONTROL_STRIDE * pwm->hwpwm);
+	else if (polarity == PWM_POLARITY_INVERSED)
+		value |= PWM_POLARITY << (PWM_CONTROL_STRIDE * pwm->hwpwm);
+	writel(value, pc->base);
+	return 0;
+}
+
+static const struct pwm_ops bcm2835_pwm_ops = {
+	.request = bcm2835_pwm_request,
+	.free = bcm2835_pwm_free,
+	.config = bcm2835_pwm_config,
+	.enable = bcm2835_pwm_enable,
+	.disable = bcm2835_pwm_disable,
+	.set_polarity = bcm2835_set_polarity,
+	.owner = THIS_MODULE,
+};
+
+static int bcm2835_pwm_probe(struct platform_device *pdev)
+{
+	struct bcm2835_pwm *pwm;
+	int ret;
+	struct resource *r;
+	struct clk *clk;
+
+	pwm = devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
+	if (!pwm)
+		return -ENOMEM;
+
+	pwm->dev = &pdev->dev;
+
+	clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(clk)) {
+		dev_err(&pdev->dev, "no clock found: %ld\n", PTR_ERR(clk));
+		return PTR_ERR(clk);
+	}
+
+	pwm->clk = clk;
+	ret = clk_prepare_enable(pwm->clk);
+	if (ret) {
+		clk_disable_unprepare(pwm->clk);
+		return ret;
+	}
+
+	pwm->scaler = NSEC_PER_SEC / clk_get_rate(clk);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pwm->base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(pwm->base))
+		return PTR_ERR(pwm->base);
+
+	pwm->chip.dev = &pdev->dev;
+	pwm->chip.ops = &bcm2835_pwm_ops;
+	pwm->chip.npwm = 2;
+
+	platform_set_drvdata(pdev, pwm);
+
+	ret = pwmchip_add(&pwm->chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int bcm2835_pwm_remove(struct platform_device *pdev)
+{
+	struct bcm2835_pwm *pc = platform_get_drvdata(pdev);
+	clk_disable_unprepare(pc->clk);
+	return pwmchip_remove(&pc->chip);
+}
+
+static const struct of_device_id bcm2835_pwm_of_match[] = {
+	{ .compatible = "brcm,bcm2835-pwm", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, bcm2835_pwm_of_match);
+
+static struct platform_driver bcm2835_pwm_driver = {
+	.driver = {
+		.name = "bcm2835-pwm",
+		.of_match_table = bcm2835_pwm_of_match,
+	},
+	.probe = bcm2835_pwm_probe,
+	.remove = bcm2835_pwm_remove,
+};
+module_platform_driver(bcm2835_pwm_driver);
+
+MODULE_AUTHOR("Bart Tanghe <bart.tanghe@thomasmore.be");
+MODULE_DESCRIPTION("Broadcom BCM2835 PWM driver");
+MODULE_LICENSE("GPL v2");
