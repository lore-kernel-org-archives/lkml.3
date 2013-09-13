Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab3IMGDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 02:03:09 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:49456
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754468Ab3IMGDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 02:03:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(z551bizc8kzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <thierry.reding@gmail.com>
CC: <s.hauer@pengutronix.de>, <swarren@wwwdotorg.org>, <t.figa@samsung.com>,
        <grant.likely@linaro.org>, <linux@arm.linux.org.uk>, <rob@landley.net>,
        <ian.campbell@citrix.com>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <rob.herring@calxeda.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pwm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Jingchang Lu <b35083@freescale.com>
Subject: [PATCHv4 1/4] pwm: Add Freescale FTM PWM driver support
Date: Fri, 13 Sep 2013 13:58:39 +0800
Message-ID: <1379051922-4930-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1379051922-4930-1-git-send-email-Li.Xiubo@freescale.com>
References: <1379051922-4930-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FTM PWM device can be found on Vybrid VF610 Tower and Layerscape LS-1 SoCs.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Jingchang Lu <b35083@freescale.com>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/pwm/Kconfig       |  10 +
 drivers/pwm/Makefile      |   1 +
 drivers/pwm/pwm-fsl-ftm.c | 507 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 518 insertions(+)
 create mode 100644 drivers/pwm/pwm-fsl-ftm.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 75840b5..8144fb0 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -62,6 +62,16 @@ config PWM_BFIN
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-bfin.
 
+config PWM_FSL_FTM
+	tristate "Freescale FTM PWM support"
+	depends on OF
+	help
+	  Generic FTM PWM framework driver for Freescale VF610 and
+	  Layerscape LS-1 SoCs.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-fsl-ftm.
+
 config PWM_IMX
 	tristate "i.MX PWM support"
 	depends on ARCH_MXC
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 77a8c18..f383784 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_PWM_SYSFS)		+= sysfs.o
 obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
 obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
 obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
+obj-$(CONFIG_PWM_FSL_FTM)	+= pwm-fsl-ftm.o
 obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
 obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
 obj-$(CONFIG_PWM_LPC32XX)	+= pwm-lpc32xx.o
diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
new file mode 100644
index 0000000..d67a86d
--- /dev/null
+++ b/drivers/pwm/pwm-fsl-ftm.c
@@ -0,0 +1,507 @@
+/*
+ *  Freescale FTM PWM Driver
+ *
+ *  Copyright 2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/pwm.h>
+#include <linux/of_address.h>
+#include <linux/pinctrl/consumer.h>
+
+#define FTM_SC              0x00
+#define FTMSC_CLK_MASK      0x03
+#define FTMSC_CLK_OFFSET    0x03
+#define FTMSC_CLKSYS        (0x01 << 3)
+#define FTMSC_CLKFIX        (0x02 << 3)
+#define FTMSC_CLKEXT        (0x03 << 3)
+#define FTMSC_PS_MASK       0x07
+#define FTMSC_PS_OFFSET     0x00
+
+#define FTM_CNT             0x04
+#define FTM_MOD             0x08
+
+#define FTM_CSC_BASE        0x0C
+#define FTM_CSC(_channel) (FTM_CSC_BASE + ((_channel) * 8))
+#define FTMCnSC_MSB         BIT(5)
+#define FTMCnSC_MSA         BIT(4)
+#define FTMCnSC_ELSB        BIT(3)
+#define FTMCnSC_ELSA        BIT(2)
+
+#define FTM_CV_BASE         0x10
+#define FTM_CV(_channel) (FTM_CV_BASE + ((_channel) * 8))
+
+#define FTM_CNTIN           0x4C
+#define FTM_STATUS          0x50
+
+#define FTM_MODE            0x54
+#define FTMMODE_FTMEN       BIT(0)
+#define FTMMODE_INIT        BIT(2)
+#define FTMMODE_PWMSYNC     BIT(3)
+
+#define FTM_SYNC            0x58
+#define FTM_OUTINIT         0x5C
+#define FTM_OUTMASK         0x60
+#define FTM_COMBINE         0x64
+#define FTM_DEADTIME        0x68
+#define FTM_EXTTRIG         0x6C
+#define FTM_POL             0x70
+#define FTM_FMS             0x74
+#define FTM_FILTER          0x78
+#define FTM_FLTCTRL         0x7C
+#define FTM_QDCTRL          0x80
+#define FTM_CONF            0x84
+#define FTM_FLTPOL          0x88
+#define FTM_SYNCONF         0x8C
+#define FTM_INVCTRL         0x90
+#define FTM_SWOCTRL         0x94
+#define FTM_PWMLOAD         0x98
+
+#define FTM_CNTIN_VAL       0x00
+#define FTM_MAX_CHANNEL     8
+
+enum {
+	FSL_INVALID = 0,
+	FSL_AVAILABLE,
+};
+
+enum {
+	FSL_COUNTER_CLK_SYS = 0,
+	FSL_COUNTER_CLK_FIX,
+	FSL_COUNTER_CLK_EXT,
+	FSL_COUNTER_CLK_MAX,
+};
+
+struct fsl_pwm_chip {
+	struct pwm_chip chip;
+
+	struct clk *sys_clk;
+	struct clk *counter_clk;
+	unsigned int counter_clk_select;
+	unsigned int counter_clk_enable;
+	unsigned int clk_ps;
+
+	void __iomem *base;
+
+	/* pinctrl handle */
+	struct pinctrl *pinctrl;
+};
+
+static inline struct fsl_pwm_chip *to_fsl_chip(struct pwm_chip *chip)
+{
+	return container_of(chip, struct fsl_pwm_chip, chip);
+}
+
+static int fsl_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	int ret;
+	struct fsl_pwm_chip *fpc;
+
+	fpc = to_fsl_chip(chip);
+
+	ret = clk_prepare_enable(fpc->sys_clk);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void fsl_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct fsl_pwm_chip *fpc;
+
+	fpc = to_fsl_chip(chip);
+
+	clk_disable_unprepare(fpc->sys_clk);
+}
+
+static unsigned long fsl_rate_to_cycles(struct fsl_pwm_chip *fpc,
+				       unsigned long time_ns)
+{
+	unsigned long long c;
+	unsigned long ps = 1 << fpc->clk_ps;
+
+	if (fpc->counter_clk)
+		c = clk_get_rate(fpc->counter_clk);
+	else
+		c = clk_get_rate(fpc->sys_clk);
+
+	c = c * time_ns;
+	do_div(c, 1000000000UL);
+	do_div(c, ps);
+
+	return (unsigned long)c;
+}
+
+static int fsl_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			  int duty_ns, int period_ns)
+{
+	unsigned long period_cycles, duty_cycles;
+	unsigned long cntin = FTM_CNTIN_VAL;
+	struct fsl_pwm_chip *fpc;
+
+	fpc = to_fsl_chip(chip);
+
+	if (WARN_ON(!test_bit(PWMF_REQUESTED, &pwm->flags)))
+		return -ESHUTDOWN;
+
+	period_cycles = fsl_rate_to_cycles(fpc, period_ns);
+	if (period_cycles > 0xFFFF) {
+		dev_err(chip->dev, "required PWM period cycles(%lu) overflow "
+				"16-bits counter!\n", period_cycles);
+		return -EINVAL;
+	}
+
+	duty_cycles = fsl_rate_to_cycles(fpc, duty_ns);
+	if (duty_cycles >= 0xFFFF) {
+		dev_err(chip->dev, "required PWM duty cycles(%lu) overflow "
+				"16-bits counter!\n", duty_cycles);
+		return -EINVAL;
+	}
+
+	writel(FTMCnSC_MSB | FTMCnSC_ELSB, fpc->base + FTM_CSC(pwm->hwpwm));
+
+	writel(0xF0, fpc->base + FTM_OUTMASK);
+	writel(0x0F, fpc->base + FTM_OUTINIT);
+	writel(FTM_CNTIN_VAL, fpc->base + FTM_CNTIN);
+
+	writel(period_cycles + cntin - 1, fpc->base + FTM_MOD);
+	writel(duty_cycles + cntin, fpc->base + FTM_CV(pwm->hwpwm));
+
+	return 0;
+}
+
+static int fsl_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
+				enum pwm_polarity polarity)
+{
+	unsigned long reg;
+	struct fsl_pwm_chip *fpc;
+
+	fpc = to_fsl_chip(chip);
+
+	reg = readl(fpc->base + FTM_POL);
+	if (polarity == PWM_POLARITY_INVERSED)
+		reg |= BIT(pwm->hwpwm);
+	else
+		reg &= ~BIT(pwm->hwpwm);
+	writel(reg, fpc->base + FTM_POL);
+
+	return 0;
+}
+
+static int fsl_counter_clock_enable(struct fsl_pwm_chip *fpc)
+{
+	int ret;
+	unsigned long reg;
+
+	if (fpc->counter_clk_enable++)
+		return 0;
+
+	ret = clk_prepare_enable(fpc->counter_clk);
+	if (ret)
+		return ret;
+
+	reg = readl(fpc->base + FTM_SC);
+	reg &= ~((FTMSC_CLK_MASK << FTMSC_CLK_OFFSET) |
+			(FTMSC_PS_MASK << FTMSC_PS_OFFSET));
+	/* select counter clock source */
+	switch (fpc->counter_clk_select) {
+	case FSL_COUNTER_CLK_SYS:
+		reg |= FTMSC_CLKSYS;
+		break;
+	case FSL_COUNTER_CLK_FIX:
+		reg |= FTMSC_CLKFIX;
+		break;
+	case FSL_COUNTER_CLK_EXT:
+		reg |= FTMSC_CLKEXT;
+		break;
+	default:
+		break;
+	}
+	reg |= fpc->clk_ps;
+	writel(reg, fpc->base + FTM_SC);
+
+	return 0;
+}
+
+static int fsl_counter_clock_disable(struct fsl_pwm_chip *fpc)
+{
+	unsigned long reg;
+
+	if (--fpc->counter_clk_enable)
+		return 0;
+
+	writel(0xFF, fpc->base + FTM_OUTMASK);
+	reg = readl(fpc->base + FTM_SC);
+	reg &= ~(FTMSC_CLK_MASK << FTMSC_CLK_OFFSET);
+	writel(reg, fpc->base + FTM_SC);
+
+	clk_disable_unprepare(fpc->counter_clk);
+
+	return 0;
+}
+
+static int fsl_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	int ret;
+	struct fsl_pwm_chip *fpc;
+	struct pinctrl_state *pins_state;
+	const char *statename;
+
+	fpc = to_fsl_chip(chip);
+
+	statename = kasprintf(GFP_KERNEL, "ch%d-active", pwm->hwpwm);
+	pins_state = pinctrl_lookup_state(fpc->pinctrl,
+			statename);
+	if (IS_ERR(pins_state)) {
+		ret = PTR_ERR(pins_state);
+		dev_err(chip->dev, "could not get \"%s\" pinstate :%d\n",
+				statename, ret);
+		goto out;
+	}
+
+	/* enable pins to be muxed in and configured */
+	ret = pinctrl_select_state(fpc->pinctrl, pins_state);
+	if (ret) {
+		dev_err(chip->dev, "could not set \"%s\" pinstate :%d\n",
+				statename, ret);
+		goto out;
+	}
+
+	fsl_counter_clock_enable(fpc);
+
+out:
+	kfree(statename);
+	return ret;
+}
+
+static void fsl_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	int ret;
+	struct fsl_pwm_chip *fpc;
+	struct pinctrl_state    *pins_state;
+	const char *statename;
+
+	fpc = to_fsl_chip(chip);
+
+	statename = kasprintf(GFP_KERNEL, "ch%d-idle", pwm->hwpwm);
+	pins_state = pinctrl_lookup_state(fpc->pinctrl,
+			statename);
+	if (IS_ERR(pins_state)) {
+		ret = PTR_ERR(pins_state);
+		dev_err(chip->dev, "could not get \"%s\" pinstate :%d\n",
+				statename, ret);
+		goto out;
+	}
+
+	/* enable pins to be muxed in and configured */
+	ret = pinctrl_select_state(fpc->pinctrl, pins_state);
+	if (ret) {
+		dev_err(chip->dev, "could not set \"%s\" pinstate :%d\n",
+				statename, ret);
+		goto out;
+	}
+
+	fsl_counter_clock_disable(fpc);
+
+out:
+	kfree(statename);
+}
+
+static const struct pwm_ops fsl_pwm_ops = {
+	.request = fsl_pwm_request,
+	.free = fsl_pwm_free,
+	.config = fsl_pwm_config,
+	.set_polarity = fsl_pwm_set_polarity,
+	.enable = fsl_pwm_enable,
+	.disable = fsl_pwm_disable,
+	.owner = THIS_MODULE,
+};
+
+static int fsl_pwm_calculate_ps(struct fsl_pwm_chip *fpc)
+{
+	unsigned long long sys_rate, counter_rate, ratio;
+
+	sys_rate = clk_get_rate(fpc->sys_clk);
+	if (!sys_rate)
+		return -EINVAL;
+
+	counter_rate = clk_get_rate(fpc->counter_clk);
+	if (!counter_rate && fpc->counter_clk_select != FSL_COUNTER_CLK_SYS) {
+		dev_warn(fpc->chip.dev,
+				"the counter source clock is a dummy clock, "
+				"so select the system clock as default!\n");
+	}
+
+	if (!counter_rate) {
+		fpc->counter_clk = NULL;
+		fpc->counter_clk_select = FSL_COUNTER_CLK_SYS;
+		fpc->clk_ps = 7;
+	}
+
+	switch (fpc->counter_clk_select) {
+	case FSL_COUNTER_CLK_FIX:
+		ratio = 2 * counter_rate - 1;
+		do_div(ratio, sys_rate);
+		fpc->clk_ps = ratio;
+		break;
+	case FSL_COUNTER_CLK_EXT:
+		ratio = 4 * counter_rate - 1;
+		do_div(ratio, sys_rate);
+		fpc->clk_ps = ratio;
+		break;
+	case FSL_COUNTER_CLK_SYS:
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int fsl_pwm_parse_clk_ps(struct fsl_pwm_chip *fpc)
+{
+	const char *cname;
+	int ret, index;
+	struct device_node *np = fpc->chip.dev->of_node;
+
+	ret = of_property_read_string_index(np, "fsl,pwm-counter-clk", 0,
+					    &cname);
+	if (ret < 0) {
+		dev_err(fpc->chip.dev,
+				"failed to get \"fsl,pwm-counter-clk\": %d\n",
+				ret);
+		return ret;
+	}
+
+	index = of_property_match_string(np, "clock-names", cname);
+	if (index < 0)
+		return index;
+	if (index >= FSL_COUNTER_CLK_MAX)
+		return -EINVAL;
+	fpc->counter_clk_select = index;
+
+	fpc->sys_clk = devm_clk_get(fpc->chip.dev, "ftm0");
+	if (IS_ERR(fpc->sys_clk)) {
+		ret = PTR_ERR(fpc->sys_clk);
+		dev_err(fpc->chip.dev,
+				"failed to get \"ftm0\" clock %d\n", ret);
+		return ret;
+	}
+
+	switch (fpc->counter_clk_select) {
+	case FSL_COUNTER_CLK_SYS:
+		fpc->counter_clk = NULL;
+		break;
+	case FSL_COUNTER_CLK_FIX:
+		fpc->counter_clk = devm_clk_get(fpc->chip.dev, "ftm0_fix_sel");
+		if (IS_ERR(fpc->counter_clk)) {
+			ret = PTR_ERR(fpc->counter_clk);
+			dev_err(fpc->chip.dev,
+					"failed to get \"ftm0_fix_sel\" "
+					"clock %d\n", ret);
+			return ret;
+		}
+		break;
+	case FSL_COUNTER_CLK_EXT:
+		fpc->counter_clk = devm_clk_get(fpc->chip.dev, "ftm0_ext_sel");
+		if (IS_ERR(fpc->counter_clk)) {
+			ret = PTR_ERR(fpc->counter_clk);
+			dev_err(fpc->chip.dev,
+					"failed to get \"ftm0_ext_sel\" "
+					"clock %d\n", ret);
+			return ret;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return fsl_pwm_calculate_ps(fpc);
+}
+
+static int fsl_pwm_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct fsl_pwm_chip *fpc;
+	struct resource *res;
+
+	fpc = devm_kzalloc(&pdev->dev, sizeof(*fpc), GFP_KERNEL);
+	if (!fpc)
+		return -ENOMEM;
+
+	fpc->chip.dev = &pdev->dev;
+	fpc->counter_clk_enable = 0;
+
+	ret = fsl_pwm_parse_clk_ps(fpc);
+	if (ret < 0)
+		return ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	fpc->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(fpc->base)) {
+		ret = PTR_ERR(fpc->base);
+		return ret;
+	}
+
+	fpc->pinctrl = devm_pinctrl_get(&pdev->dev);
+	if (IS_ERR(fpc->pinctrl)) {
+		ret = PTR_ERR(fpc->pinctrl);
+		return ret;
+	}
+
+	fpc->chip.ops = &fsl_pwm_ops;
+	fpc->chip.of_xlate = of_pwm_xlate_with_flags;
+	fpc->chip.of_pwm_n_cells = 3;
+	fpc->chip.base = -1;
+	fpc->chip.npwm = FTM_MAX_CHANNEL;
+	ret = pwmchip_add(&fpc->chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to add PWM chip %d\n", ret);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, fpc);
+
+	return 0;
+}
+
+static int fsl_pwm_remove(struct platform_device *pdev)
+{
+	struct fsl_pwm_chip *fpc;
+
+	fpc = platform_get_drvdata(pdev);
+
+	return pwmchip_remove(&fpc->chip);
+}
+
+static const struct of_device_id fsl_pwm_dt_ids[] = {
+	{ .compatible = "fsl,vf610-ftm-pwm", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, fsl_pwm_dt_ids);
+
+static struct platform_driver fsl_pwm_driver = {
+	.driver = {
+		.name = "fsl-ftm-pwm",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(fsl_pwm_dt_ids),
+	},
+	.probe = fsl_pwm_probe,
+	.remove = fsl_pwm_remove,
+};
+module_platform_driver(fsl_pwm_driver);
+
+MODULE_DESCRIPTION("Freescale FTM PWM Driver");
+MODULE_AUTHOR("Xiubo Li <Li.Xiubo@freescale.com>");
+MODULE_LICENSE("GPL");
-- 
1.8.0


