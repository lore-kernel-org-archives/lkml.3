Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaFUOX7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 10:23:59 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:54100 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaFUOXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 10:23:45 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>, linux-pwm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 1/3] pwm: add Rockchip SoC PWM support
Date: Sat, 21 Jun 2014 16:22:06 +0200
Message-Id: <1403360528-12757-2-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403360528-12757-1-git-send-email-b.galvani@gmail.com>
References: <1403360528-12757-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds a driver for the PWM controller found on Rockchip
RK29, RK30 and RK31 SoCs.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 drivers/pwm/Kconfig        |    7 ++
 drivers/pwm/Makefile       |    1 +
 drivers/pwm/pwm-rockchip.c |  177 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 185 insertions(+)
 create mode 100644 drivers/pwm/pwm-rockchip.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 4ad7b89..a86879a 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -206,6 +206,13 @@ config PWM_RENESAS_TPU
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-renesas-tpu.
 
+config PWM_ROCKCHIP
+	tristate "Rockchip PWM support"
+	depends on ARCH_ROCKCHIP
+	help
+	  Generic PWM framework driver for the PWM controller found on
+	  Rockchip SoCs.
+
 config PWM_SAMSUNG
 	tristate "Samsung PWM support"
 	depends on PLAT_SAMSUNG
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 5c86a19..e03e2ae 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_PWM_PCA9685)	+= pwm-pca9685.o
 obj-$(CONFIG_PWM_PUV3)		+= pwm-puv3.o
 obj-$(CONFIG_PWM_PXA)		+= pwm-pxa.o
 obj-$(CONFIG_PWM_RENESAS_TPU)	+= pwm-renesas-tpu.o
+obj-$(CONFIG_PWM_ROCKCHIP)	+= pwm-rockchip.o
 obj-$(CONFIG_PWM_SAMSUNG)	+= pwm-samsung.o
 obj-$(CONFIG_PWM_SPEAR)		+= pwm-spear.o
 obj-$(CONFIG_PWM_TEGRA)		+= pwm-tegra.o
diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
new file mode 100644
index 0000000..eec2145
--- /dev/null
+++ b/drivers/pwm/pwm-rockchip.c
@@ -0,0 +1,177 @@
+/*
+ * PWM driver for Rockchip SoCs
+ *
+ * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/time.h>
+
+#define PWM_CNTR		0x00		/* Counter register */
+#define PWM_HRC			0x04		/* High reference register */
+#define PWM_LRC			0x08		/* Low reference register */
+#define PWM_CTRL		0x0c		/* Control register */
+#define PWM_CTRL_TIMER_EN	(1 << 0)
+#define PWM_CTRL_OUTPUT_EN	(1 << 3)
+
+#define PRESCALER		2
+
+struct rockchip_pwm_chip {
+	struct pwm_chip chip;
+	struct clk *clk;
+	void __iomem *base;
+};
+
+static inline struct rockchip_pwm_chip *to_rockchip_pwm_chip(struct pwm_chip *c)
+{
+	return container_of(c, struct rockchip_pwm_chip, chip);
+}
+
+static int rockchip_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			       int duty_ns, int period_ns)
+{
+	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
+	unsigned long period, duty;
+	u64 clk_rate, div;
+	int ret;
+
+	clk_rate = clk_get_rate(pc->clk);
+
+	/*
+	 * Since period and duty cycle registers have a width of 32
+	 * bits, every possible input period can be obtained using the
+	 * default prescaler value for all practical clock rate values.
+	 */
+	div = clk_rate * period_ns;
+	do_div(div, PRESCALER * NSEC_PER_SEC);
+	period = div;
+
+	div = clk_rate * duty_ns;
+	do_div(div, PRESCALER * NSEC_PER_SEC);
+	duty = div;
+
+	ret = clk_enable(pc->clk);
+	if (ret)
+		return ret;
+
+	writel(period, pc->base + PWM_LRC);
+	writel(duty, pc->base + PWM_HRC);
+	writel(0, pc->base + PWM_CNTR);
+
+	clk_disable(pc->clk);
+
+	return 0;
+}
+
+static int rockchip_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
+	int ret;
+	u32 val;
+
+	ret = clk_enable(pc->clk);
+	if (ret)
+		return ret;
+
+	val = readl_relaxed(pc->base + PWM_CTRL);
+	val |= PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN;
+	writel_relaxed(val, pc->base + PWM_CTRL);
+
+	return 0;
+}
+
+static void rockchip_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct rockchip_pwm_chip *pc = to_rockchip_pwm_chip(chip);
+	u32 val;
+
+	val = readl_relaxed(pc->base + PWM_CTRL);
+	val &= ~(PWM_CTRL_OUTPUT_EN | PWM_CTRL_TIMER_EN);
+	writel_relaxed(val, pc->base + PWM_CTRL);
+
+	clk_disable(pc->clk);
+}
+
+static const struct pwm_ops rockchip_pwm_ops = {
+	.config = rockchip_pwm_config,
+	.enable = rockchip_pwm_enable,
+	.disable = rockchip_pwm_disable,
+	.owner = THIS_MODULE,
+};
+
+static int rockchip_pwm_probe(struct platform_device *pdev)
+{
+	struct rockchip_pwm_chip *pc;
+	struct resource *r;
+	int ret;
+
+	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
+	if (!pc)
+		return -ENOMEM;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pc->base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(pc->base))
+		return PTR_ERR(pc->base);
+
+	pc->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(pc->clk))
+		return PTR_ERR(pc->clk);
+
+	ret = clk_prepare(pc->clk);
+	if (ret)
+		return ret;
+
+	platform_set_drvdata(pdev, pc);
+
+	pc->chip.dev = &pdev->dev;
+	pc->chip.ops = &rockchip_pwm_ops;
+	pc->chip.base = -1;
+	pc->chip.npwm = 1;
+
+	ret = pwmchip_add(&pc->chip);
+	if (ret < 0) {
+		clk_unprepare(pc->clk);
+		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
+	}
+
+	return ret;
+}
+
+static int rockchip_pwm_remove(struct platform_device *pdev)
+{
+	struct rockchip_pwm_chip *pc = platform_get_drvdata(pdev);
+
+	clk_unprepare(pc->clk);
+
+	return pwmchip_remove(&pc->chip);
+}
+
+static const struct of_device_id rockchip_pwm_dt_ids[] = {
+	{ .compatible = "rockchip,rk2928-pwm" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, rockchip_pwm_dt_ids);
+
+static struct platform_driver rockchip_pwm_driver = {
+	.driver = {
+		.name = "rockchip-pwm",
+		.of_match_table = rockchip_pwm_dt_ids,
+	},
+	.probe = rockchip_pwm_probe,
+	.remove = rockchip_pwm_remove,
+};
+module_platform_driver(rockchip_pwm_driver);
+
+MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
+MODULE_DESCRIPTION("Rockchip SoC PWM driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.10.4

