Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab3KRS56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:57:58 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1173 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab3KRSz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:55:27 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Thierry Reding" <thierry.reding@gmail.com>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Christian Daudt" <bcm@fixthebug.org>,
        "Grant Likely" <grant.likely@linaro.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>,
        "Linux PWM List" <linux-pwm@vger.kernel.org>,
        "Device Tree List" <devicetree@vger.kernel.org>,
        "Linux Doc List" <linux-doc@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Broadcom Kernel Feedback List" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "Linux ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linaro Patches List" <patches@linaro.org>
Subject: [PATCH 2/5] pwm: kona: Introduce Kona PWM controller support
Date: Mon, 18 Nov 2013 10:54:58 -0800
Message-ID: <1384800901-21711-3-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
References: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E94BDE81SC9038038-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the six-channel Kona PWM controller found on Broadcom
mobile SoCs like bcm281xx.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 drivers/pwm/Kconfig        |  10 ++
 drivers/pwm/Makefile       |   1 +
 drivers/pwm/pwm-bcm-kona.c | 226 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 237 insertions(+)
 create mode 100644 drivers/pwm/pwm-bcm-kona.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 75840b5..4ed5d8b 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -53,6 +53,16 @@ config PWM_ATMEL_TCB
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-atmel-tcb.
 
+config PWM_BCM_KONA
+	tristate "Kona PWM support"
+	depends on ARCH_BCM_MOBILE
+	default y
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
index 77a8c18..dd96938 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_PWM_SYSFS)		+= sysfs.o
 obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
 obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
 obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
+obj-$(CONFIG_PWM_BCM_KONA)	+= pwm-bcm-kona.o
 obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
 obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
 obj-$(CONFIG_PWM_LPC32XX)	+= pwm-lpc32xx.o
diff --git a/drivers/pwm/pwm-bcm-kona.c b/drivers/pwm/pwm-bcm-kona.c
new file mode 100644
index 0000000..cdf30d9
--- /dev/null
+++ b/drivers/pwm/pwm-bcm-kona.c
@@ -0,0 +1,226 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
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
+#define KONA_PWM_CHANNEL_CNT		6
+
+#define PWM_CONTROL_OFFSET		(0x00000000)
+#define PWM_CONTROL_INITIAL		(0x3f3f3f00)
+#define PWMOUT_POLARITY(chan)		(0x1 << (8 + chan))
+#define PWMOUT_ENABLE(chan)		(0x1 << chan)
+
+#define PRESCALE_OFFSET			(0x00000004)
+#define PRESCALE_SHIFT(chan)		(chan << 2)
+#define PRESCALE_MASK(chan)		(~(0x7 << (chan << 2)))
+#define PRESCALE_MIN			(0x00000000)
+#define PRESCALE_MAX			(0x00000007)
+
+#define PERIOD_COUNT_OFFSET(chan)	(0x00000008 + (chan << 3))
+#define PERIOD_COUNT_MIN		(0x00000002)
+#define PERIOD_COUNT_MAX		(0x00ffffff)
+
+#define DUTY_CYCLE_HIGH_OFFSET(chan)	(0x0000000c + (chan << 3))
+#define DUTY_CYCLE_HIGH_MIN		(0x00000000)
+#define DUTY_CYCLE_HIGH_MAX		(0x00ffffff)
+
+struct kona_pwmc {
+	struct pwm_chip chip;
+	void __iomem *base;
+	struct clk *clk;
+};
+
+static void kona_pwmc_apply_settings(struct kona_pwmc *kp, int chan)
+{
+	/* New settings take effect on rising edge of enable  bit */
+	writel(readl(kp->base + PWM_CONTROL_OFFSET) & ~PWMOUT_ENABLE(chan),
+	       kp->base + PWM_CONTROL_OFFSET);
+	writel(readl(kp->base + PWM_CONTROL_OFFSET) | PWMOUT_ENABLE(chan),
+	       kp->base + PWM_CONTROL_OFFSET);
+}
+
+static int kona_pwmc_config(struct pwm_chip *chip, struct pwm_device *pwm,
+				int duty_ns, int period_ns)
+{
+	struct kona_pwmc *kp = dev_get_drvdata(chip->dev);
+	u64 val, div, clk_rate;
+	unsigned long prescale = PRESCALE_MIN, pc, dc;
+	int chan = pwm->hwpwm;
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
+	clk_rate = clk_get_rate(kp->clk);
+	while (1) {
+		div = 1000000000;
+		div *= 1 + prescale;
+		val = clk_rate * period_ns;
+		pc = div64_u64(val, div);
+		val = clk_rate * duty_ns;
+		dc = div64_u64(val, div);
+
+		/* If duty_ns or period_ns are not achievable then return */
+		if (pc < PERIOD_COUNT_MIN || dc < DUTY_CYCLE_HIGH_MIN)
+			return -EINVAL;
+
+		/*
+		 * If pc or dc have crossed their upper limit, then increase
+		 * prescale and recalculate pc and dc.
+		 */
+		if (pc > PERIOD_COUNT_MAX || dc > DUTY_CYCLE_HIGH_MAX) {
+			if (++prescale > PRESCALE_MAX)
+				return -EINVAL;
+			continue;
+		}
+		break;
+	}
+
+	/* Program prescale */
+	writel((readl(kp->base + PRESCALE_OFFSET) & PRESCALE_MASK(chan)) |
+	       prescale << PRESCALE_SHIFT(chan),
+	       kp->base + PRESCALE_OFFSET);
+
+	/* Program period count */
+	writel(pc, kp->base + PERIOD_COUNT_OFFSET(chan));
+
+	/* Program duty cycle high count */
+	writel(dc, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
+
+	if (test_bit(PWMF_ENABLED, &pwm->flags))
+		kona_pwmc_apply_settings(kp, chan);
+
+	return 0;
+}
+
+static int kona_pwmc_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	return kona_pwmc_config(chip, pwm, pwm->duty_cycle, pwm->period);
+}
+
+static void kona_pwmc_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct kona_pwmc *kp = dev_get_drvdata(chip->dev);
+	int chan = pwm->hwpwm;
+
+	/*
+	 * The PWM hardware lacks a proper way to be disabled so
+	 * we just program zero duty cycle high count instead
+	 */
+
+	writel(0, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
+	kona_pwmc_apply_settings(kp, chan);
+}
+
+static const struct pwm_ops kona_pwm_ops = {
+	.config = kona_pwmc_config,
+	.owner = THIS_MODULE,
+	.enable = kona_pwmc_enable,
+	.disable = kona_pwmc_disable,
+};
+
+static int kona_pwmc_probe(struct platform_device *pdev)
+{
+	struct kona_pwmc *kp;
+	struct resource *res;
+	int ret = 0;
+
+	dev_dbg(&pdev->dev, "bcm_kona_pwmc probe\n");
+
+	kp = devm_kzalloc(&pdev->dev, sizeof(*kp), GFP_KERNEL);
+	if (kp == NULL)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	kp->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(kp->base))
+		return PTR_ERR(kp->base);
+
+	kp->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(kp->clk)) {
+		dev_err(&pdev->dev, "Clock get failed : Err %d\n", ret);
+		return PTR_ERR(kp->clk);
+	}
+
+	ret = clk_prepare_enable(kp->clk);
+	if (ret < 0)
+		return ret;
+
+	/* Set smooth mode, push/pull, and normal polarity for all channels */
+	writel(PWM_CONTROL_INITIAL, kp->base + PWM_CONTROL_OFFSET);
+
+	dev_set_drvdata(&pdev->dev, kp);
+
+	kp->chip.dev = &pdev->dev;
+	kp->chip.ops = &kona_pwm_ops;
+	kp->chip.base = -1;
+	kp->chip.npwm = KONA_PWM_CHANNEL_CNT;
+
+	ret = pwmchip_add(&kp->chip);
+	if (ret < 0) {
+		clk_disable_unprepare(kp->clk);
+		dev_err(&pdev->dev, "pwmchip_add() failed: Err %d\n", ret);
+	}
+
+	return ret;
+}
+
+static int kona_pwmc_remove(struct platform_device *pdev)
+{
+	struct kona_pwmc *kp = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(kp->clk);
+	return pwmchip_remove(&kp->chip);
+}
+
+static const struct of_device_id bcm_kona_pwmc_dt[] = {
+	{.compatible = "brcm,kona-pwm"},
+	{},
+};
+MODULE_DEVICE_TABLE(of, bcm_kona_pwmc_dt);
+
+static struct platform_driver kona_pwmc_driver = {
+
+	.driver = {
+		   .name = "bcm-kona-pwm",
+		   .owner = THIS_MODULE,
+		   .of_match_table = bcm_kona_pwmc_dt,
+		   },
+
+	.probe = kona_pwmc_probe,
+	.remove = kona_pwmc_remove,
+};
+
+module_platform_driver(kona_pwmc_driver);
+
+MODULE_AUTHOR("Broadcom");
+MODULE_DESCRIPTION("Driver for KONA PWMC");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0");
-- 
1.8.0.1


