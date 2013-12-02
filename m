Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab3LBLEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:04:12 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:11401
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753452Ab3LBLEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:04:08 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(z551biz1102Ic8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <thierry.reding@gmail.com>,
        <s.hauer@pengutronix.de>, <galak@codeaurora.org>,
        <grant.likely@linaro.org>, <matt.porter@linaro.org>,
        <tomasz.figa@gmail.com>, <swarren@wwwdotorg.org>
CC: <t.figa@samsung.com>, <linux@arm.linux.org.uk>, <rob@landley.net>,
        <ian.campbell@citrix.com>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <rob.herring@calxeda.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pwm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Alison Wang <b18965@freescale.com>,
        Jingchang Lu <b35083@freescale.com>
Subject: [RFC] pwm: Add Freescale FTM PWM driver support
Date: Mon, 2 Dec 2013 18:15:09 +0800
Message-ID: <1385979309-10505-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FTM PWM device can be found on Vybrid VF610 Tower and
Layerscape LS-1 SoCs.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Alison Wang <b18965@freescale.com>
Signed-off-by: Jingchang Lu <b35083@freescale.com>
---

I'm sending the RFC patch about the FTM IP block registers read and write
endian fix for comments and more parcticed ideas.

In Vybird VF610 Tower, all the IP blocks expect LE data. In the LS-1, some of
the IP blocks expect LE data, while others expect BE data. And the CPU always
operates in LE mode in these two platforms.

So now I must take care of all these two cases. I'm not very sure if there is
other better ways to resolve this problem. In this patch I have implemented
two functions fsl_pwm_readl() and fsl_pwm_writel() to replace readl() and
writel(). At the same time there should add one "endianess" property in the DT
file.

And this patch is based the V7 series.


 drivers/pwm/Kconfig       |  10 +
 drivers/pwm/Makefile      |   1 +
 drivers/pwm/pwm-fsl-ftm.c | 455 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 466 insertions(+)
 create mode 100644 drivers/pwm/pwm-fsl-ftm.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index eece329..b7d0737 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -71,6 +71,16 @@ config PWM_EP93XX
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-ep93xx.
 
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
index 8b754e4..9029a12 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
 obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
 obj-$(CONFIG_PWM_EP93XX)	+= pwm-ep93xx.o
 obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
+obj-$(CONFIG_PWM_FSL_FTM)	+= pwm-fsl-ftm.o
 obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
 obj-$(CONFIG_PWM_LPC32XX)	+= pwm-lpc32xx.o
 obj-$(CONFIG_PWM_MXS)		+= pwm-mxs.o
diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
new file mode 100644
index 0000000..2401f2d
--- /dev/null
+++ b/drivers/pwm/pwm-fsl-ftm.c
@@ -0,0 +1,455 @@
+/*
+ *  Freescale FTM PWM Driver
+ *
+ *  Copyright 2012-2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/pwm.h>
+#include <linux/slab.h>
+
+#include <dt-bindings/clock/vf610-clock.h>
+
+#define FTM_SC	0x00
+#define FTM_SC_CLK_MASK	0x3
+#define FTM_SC_CLK_SHIFT	3
+#define FTM_SC_CLK_SYS	(0x1 << FTM_SC_CLK_SHIFT)
+#define FTM_SC_CLK_FIX	(0x2 << FTM_SC_CLK_SHIFT)
+#define FTM_SC_CLK_EXT	(0x3 << FTM_SC_CLK_SHIFT)
+#define FTM_SC_PS_MASK	0x7
+#define FTM_SC_PS_SHIFT	0
+
+#define FTM_CNT		0x04
+#define FTM_MOD		0x08
+
+#define FTM_CSC_BASE	0x0C
+#define FTM_CSC_MSB	BIT(5)
+#define FTM_CSC_MSA	BIT(4)
+#define FTM_CSC_ELSB	BIT(3)
+#define FTM_CSC_ELSA	BIT(2)
+#define FTM_CSC(_channel)	(FTM_CSC_BASE + ((_channel) * 8))
+
+#define FTM_CV_BASE	0x10
+#define FTM_CV(_channel)	(FTM_CV_BASE + ((_channel) * 8))
+
+#define FTM_CNTIN	0x4C
+#define FTM_STATUS	0x50
+
+#define FTM_MODE	0x54
+#define FTM_MODE_FTMEN	BIT(0)
+#define FTM_MODE_INIT	BIT(2)
+#define FTM_MODE_PWMSYNC	BIT(3)
+
+#define FTM_SYNC	0x58
+#define FTM_OUTINIT	0x5C
+#define FTM_OUTMASK	0x60
+#define FTM_COMBINE	0x64
+#define FTM_DEADTIME	0x68
+#define FTM_EXTTRIG	0x6C
+#define FTM_POL		0x70
+#define FTM_FMS		0x74
+#define FTM_FILTER	0x78
+#define FTM_FLTCTRL	0x7C
+#define FTM_QDCTRL	0x80
+#define FTM_CONF	0x84
+#define FTM_FLTPOL	0x88
+#define FTM_SYNCONF	0x8C
+#define FTM_INVCTRL	0x90
+#define FTM_SWOCTRL	0x94
+#define FTM_PWMLOAD	0x98
+
+#define FTM_LITTLE	0
+#define FTM_BIG		1
+
+struct fsl_pwm_chip {
+	struct pwm_chip chip;
+
+	struct mutex lock;
+
+	struct clk *sys_clk;
+	struct clk *counter_clk;
+	unsigned int counter_clk_select;
+	unsigned int counter_clk_enable;
+	unsigned int clk_ps;
+
+	void __iomem *base;
+
+	int period_ns;
+	int endianess;
+};
+
+static inline u32 fsl_pwm_readl(struct fsl_pwm_chip *fpc, void __iomem *reg)
+{
+	u32 val;
+
+	val = __raw_readl(reg);
+
+	if (fpc->endianess == FTM_BIG)
+		return be32_to_cpu(val);
+	else
+		return le32_to_cpu(val);
+}
+
+static inline void fsl_pwm_writel(struct fsl_pwm_chip *fpc, u32 val,
+		void __iomem *reg)
+{
+	if (fpc->endianess == FTM_BIG)
+		val = cpu_to_be32(val);
+	else
+		val = cpu_to_le32(val);
+
+	__raw_writel(val, reg);
+}
+
+static inline struct fsl_pwm_chip *to_fsl_chip(struct pwm_chip *chip)
+{
+	return container_of(chip, struct fsl_pwm_chip, chip);
+}
+
+static int fsl_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct fsl_pwm_chip *fpc = to_fsl_chip(chip);
+
+	return clk_prepare_enable(fpc->sys_clk);
+}
+
+static void fsl_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct fsl_pwm_chip *fpc = to_fsl_chip(chip);
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
+	c = clk_get_rate(fpc->counter_clk);
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
+	unsigned long period, duty;
+	struct fsl_pwm_chip *fpc = to_fsl_chip(chip);
+
+	mutex_lock(&fpc->lock);
+	if (fpc->period_ns && fpc->period_ns != period_ns) {
+		dev_err(fpc->chip.dev,
+				"All the PWMs' period value should be "
+				"the same\n");
+		mutex_unlock(&fpc->lock);
+		return -EINVAL;
+	} else {
+		period = fsl_rate_to_cycles(fpc, period_ns);
+		if (period > 0xFFFF) {
+			mutex_unlock(&fpc->lock);
+			return -EINVAL;
+		}
+
+		fsl_pwm_writel(fpc, period - 1, fpc->base + FTM_MOD);
+		fpc->period_ns = period_ns;
+	}
+	mutex_unlock(&fpc->lock);
+
+	duty = fsl_rate_to_cycles(fpc, duty_ns);
+	if (duty >= 0xFFFF)
+		return -EINVAL;
+
+	fsl_pwm_writel(fpc, FTM_CSC_MSB | FTM_CSC_ELSB,
+			fpc->base + FTM_CSC(pwm->hwpwm));
+	fsl_pwm_writel(fpc, 0, fpc->base + FTM_CNTIN);
+	fsl_pwm_writel(fpc, duty, fpc->base + FTM_CV(pwm->hwpwm));
+
+	return 0;
+}
+
+static int fsl_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
+				enum pwm_polarity polarity)
+{
+	u32 val;
+	struct fsl_pwm_chip *fpc = to_fsl_chip(chip);
+
+	val = fsl_pwm_readl(fpc, fpc->base + FTM_POL);
+	if (polarity == PWM_POLARITY_INVERSED)
+		val |= BIT(pwm->hwpwm);
+	else
+		val &= ~BIT(pwm->hwpwm);
+	fsl_pwm_writel(fpc, val, fpc->base + FTM_POL);
+
+	return 0;
+}
+
+static int fsl_counter_clock_enable(struct fsl_pwm_chip *fpc)
+{
+	int ret;
+	u32 val;
+
+	if (fpc->counter_clk_enable++)
+		return 0;
+
+	ret = clk_prepare_enable(fpc->counter_clk);
+	if (ret) {
+		fpc->counter_clk_enable--;
+		return ret;
+	}
+
+	val = fsl_pwm_readl(fpc, fpc->base + FTM_SC);
+	val &= ~((FTM_SC_CLK_MASK << FTM_SC_CLK_SHIFT) |
+			(FTM_SC_PS_MASK << FTM_SC_PS_SHIFT));
+
+	/* select counter clock source */
+	switch (fpc->counter_clk_select) {
+	case VF610_CLK_FTM0:
+		val |= FTM_SC_CLK_SYS;
+		break;
+	case VF610_CLK_FTM0_FIX_SEL:
+		val |= FTM_SC_CLK_FIX;
+		break;
+	case VF610_CLK_FTM0_EXT_SEL:
+		val |= FTM_SC_CLK_EXT;
+		break;
+	default:
+		fpc->counter_clk_enable--;
+		return -EINVAL;
+	}
+
+	val |= fpc->clk_ps;
+	fsl_pwm_writel(fpc, val, fpc->base + FTM_SC);
+
+	return 0;
+}
+
+static void fsl_counter_clock_disable(struct fsl_pwm_chip *fpc)
+{
+	u32 val;
+
+	if (--fpc->counter_clk_enable)
+		return;
+
+	val = fsl_pwm_readl(fpc, fpc->base + FTM_SC);
+	val &= ~(FTM_SC_CLK_MASK << FTM_SC_CLK_SHIFT);
+	fsl_pwm_writel(fpc, val, fpc->base + FTM_SC);
+
+	clk_disable_unprepare(fpc->counter_clk);
+}
+
+static int fsl_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	int ret;
+	u32 val;
+	struct fsl_pwm_chip *fpc = to_fsl_chip(chip);
+
+	val = fsl_pwm_readl(fpc, fpc->base + FTM_OUTMASK);
+	val &= ~BIT(pwm->hwpwm);
+	fsl_pwm_writel(fpc, val, fpc->base + FTM_OUTMASK);
+
+	val = fsl_pwm_readl(fpc, fpc->base + FTM_OUTINIT);
+	val &= ~BIT(pwm->hwpwm);
+	fsl_pwm_writel(fpc, val, fpc->base + FTM_OUTINIT);
+
+	mutex_lock(&fpc->lock);
+	ret = fsl_counter_clock_enable(fpc);
+	mutex_unlock(&fpc->lock);
+
+	return ret;
+}
+
+static void fsl_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	u32 val;
+	struct fsl_pwm_chip *fpc = to_fsl_chip(chip);
+
+	val = fsl_pwm_readl(fpc, fpc->base + FTM_OUTMASK);
+	val |= BIT(pwm->hwpwm);
+	fsl_pwm_writel(fpc, val, fpc->base + FTM_OUTMASK);
+
+	mutex_lock(&fpc->lock);
+	fsl_counter_clock_disable(fpc);
+
+	val = fsl_pwm_readl(fpc, fpc->base + FTM_OUTMASK);
+	if ((val & 0xFF) == 0xFF)
+		fpc->period_ns = 0;
+	mutex_unlock(&fpc->lock);
+
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
+	if (!counter_rate) {
+		fpc->counter_clk = fpc->sys_clk;
+		fpc->counter_clk_select = VF610_CLK_FTM0;
+		dev_warn(fpc->chip.dev,
+				"the counter source clock is a dummy clock, "
+				"so select the system clock as default!\n");
+	}
+
+	switch (fpc->counter_clk_select) {
+	case VF610_CLK_FTM0_FIX_SEL:
+		ratio = 2 * counter_rate - 1;
+		do_div(ratio, sys_rate);
+		fpc->clk_ps = ratio;
+		break;
+	case VF610_CLK_FTM0_EXT_SEL:
+		ratio = 4 * counter_rate - 1;
+		do_div(ratio, sys_rate);
+		fpc->clk_ps = ratio;
+		break;
+	case VF610_CLK_FTM0:
+		fpc->clk_ps = 7;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int fsl_pwm_parse_clk_ps(struct fsl_pwm_chip *fpc)
+{
+	int ret, index;
+	struct of_phandle_args clkspec;
+	struct device_node *np = fpc->chip.dev->of_node;
+
+	fpc->sys_clk = devm_clk_get(fpc->chip.dev, "ftm0");
+	if (IS_ERR(fpc->sys_clk)) {
+		ret = PTR_ERR(fpc->sys_clk);
+		dev_err(fpc->chip.dev,
+				"failed to get \"ftm0\" clock %d\n", ret);
+		return ret;
+	}
+
+	fpc->counter_clk = devm_clk_get(fpc->chip.dev, "ftm0_counter");
+	if (IS_ERR(fpc->counter_clk)) {
+		ret = PTR_ERR(fpc->counter_clk);
+		dev_err(fpc->chip.dev,
+				"failed to get \"ftm0_counter\" clock %d\n",
+				ret);
+		return ret;
+	}
+
+	index = of_property_match_string(np, "clock-names", "ftm0_counter");
+	ret = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
+					&clkspec);
+	if (ret)
+		return ret;
+
+	fpc->counter_clk_select = clkspec.args[0];
+
+	return fsl_pwm_calculate_ps(fpc);
+}
+
+static int fsl_pwm_probe(struct platform_device *pdev)
+{
+	int ret;
+	const char *endianess;
+	struct fsl_pwm_chip *fpc;
+	struct resource *res;
+	struct device_node *np = pdev->dev.of_node;
+
+	fpc = devm_kzalloc(&pdev->dev, sizeof(*fpc), GFP_KERNEL);
+	if (!fpc)
+		return -ENOMEM;
+
+	mutex_init(&fpc->lock);
+
+	fpc->chip.dev = &pdev->dev;
+
+	ret = fsl_pwm_parse_clk_ps(fpc);
+	if (ret < 0)
+		return ret;
+
+	if (of_property_read_string(np, "endianess", &endianess))
+		pr_warning("missing \"endianess\" property, "
+				"the FTM IP block is little "
+				"endian as default\n");
+	else if (!strcmp("big", endianess))
+		fpc->endianess = FTM_BIG;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	fpc->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(fpc->base))
+		return PTR_ERR(fpc->base);
+
+	fpc->chip.ops = &fsl_pwm_ops;
+	fpc->chip.of_xlate = of_pwm_xlate_with_flags;
+	fpc->chip.of_pwm_n_cells = 3;
+	fpc->chip.base = -1;
+	fpc->chip.npwm = 8;
+
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
+	struct fsl_pwm_chip *fpc = platform_get_drvdata(pdev);
+
+	mutex_destroy(&fpc->lock);
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
+		.of_match_table = fsl_pwm_dt_ids,
+	},
+	.probe = fsl_pwm_probe,
+	.remove = fsl_pwm_remove,
+};
+module_platform_driver(fsl_pwm_driver);
+
+MODULE_DESCRIPTION("Freescale FTM PWM Driver");
+MODULE_AUTHOR("Xiubo Li <Li.Xiubo@freescale.com>");
+MODULE_ALIAS("platform:fsl-ftm-pwm");
+MODULE_LICENSE("GPL");
-- 
1.8.4


