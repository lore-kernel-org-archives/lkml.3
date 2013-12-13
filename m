Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab3LMJsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:48:31 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:43657 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305Ab3LMJsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:48:19 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(z551bizc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <thierry.reding@gmail.com>
CC: <mark.rutland@arm.com>, <s.hauer@pengutronix.de>, <galak@codeaurora.org>,
        <swarren@wwwdotorg.org>, <t.figa@samsung.com>,
        <grant.likely@linaro.org>, <matt.porter@linaro.org>,
        <linux@arm.linux.org.uk>, <rob@landley.net>, <tomasz.figa@gmail.com>,
        <ian.campbell@citrix.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Alison Wang <b18965@freescale.com>,
        Jingchang Lu <b35083@freescale.com>
Subject: [PATCHv7 1/4] pwm: Add Freescale FTM PWM driver support
Date: Fri, 13 Dec 2013 16:57:04 +0800
Message-ID: <1386925027-16288-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1386925027-16288-1-git-send-email-Li.Xiubo@freescale.com>
References: <1386925027-16288-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FTM PWM device can be found on Vybrid VF610 Tower and
Layerscape LS-1 SoCs.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Alison Wang <b18965@freescale.com>
Signed-off-by: Jingchang Lu <b35083@freescale.com>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/pwm/Kconfig       |  10 +
 drivers/pwm/Makefile      |   1 +
 drivers/pwm/pwm-fsl-ftm.c | 508 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 519 insertions(+)
 create mode 100644 drivers/pwm/pwm-fsl-ftm.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index eece329..c77c571 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -71,6 +71,16 @@ config PWM_EP93XX
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-ep93xx.
 
+config PWM_FSL_FTM
+	tristate "Freescale FlexTimer Module (FTM) PWM support"
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
index 0000000..22715e7
--- /dev/null
+++ b/drivers/pwm/pwm-fsl-ftm.c
@@ -0,0 +1,508 @@
+/*
+ *  Freescale FlexTimer Module (FTM) PWM Driver
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
+#define FTM_SC	0x00
+#define FTM_SC_CLK_MASK	0x3
+#define FTM_SC_CLK_SHIFT	3
+#define FTM_SC_CLK(c)	(((c) + 1) << FTM_SC_CLK_SHIFT)
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
+enum {
+	FSL_PWM_CLK_SYS,
+	FSL_PWM_CLK_FIX,
+	FSL_PWM_CLK_EXT,
+	FSL_PWM_CLK_MAX,
+};
+
+struct fsl_pwm_chip {
+	struct pwm_chip chip;
+
+	struct mutex lock;
+
+	struct clk *sys_clk;
+	struct clk *counter_clk;
+	struct clk *counter_clk_en;
+	unsigned int counter_clk_select;
+	unsigned int counter_clk_enable;
+	unsigned int clk_ps;
+
+	void __iomem *base;
+
+	int period_ns;
+	int big_endian;
+};
+
+static inline u32 fsl_pwm_readl(struct fsl_pwm_chip *fpc,
+		const void __iomem *addr)
+{
+	u32 val;
+
+	val = __raw_readl(addr);
+
+	if (likely(fpc->big_endian))
+		val = be32_to_cpu(val);
+	else
+		val = le32_to_cpu(val);
+	rmb();
+
+	return val;
+}
+
+static inline void fsl_pwm_writel(struct fsl_pwm_chip *fpc,
+		u32 val, void __iomem *addr)
+{
+	wmb();
+	if (likely(fpc->big_endian))
+		val = cpu_to_be32(val);
+	else
+		val = cpu_to_le32(val);
+
+	__raw_writel(val, addr);
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
+static inline int fsl_pwm_calculate_default_ps(struct fsl_pwm_chip *fpc,
+		int index)
+{
+	unsigned long sys_rate, cnt_rate;
+	unsigned long long ratio;
+
+	sys_rate = clk_get_rate(fpc->sys_clk);
+	if (!sys_rate)
+		return -EINVAL;
+
+	cnt_rate = clk_get_rate(fpc->counter_clk);
+	if (!cnt_rate)
+		return -EINVAL;
+
+	switch (index) {
+	case FSL_PWM_CLK_SYS:
+		fpc->clk_ps = 1;
+		break;
+	case FSL_PWM_CLK_FIX:
+		ratio = 2 * cnt_rate - 1;
+		do_div(ratio, sys_rate);
+		fpc->clk_ps = ratio;
+		break;
+	case FSL_PWM_CLK_EXT:
+		ratio = 4 * cnt_rate - 1;
+		do_div(ratio, sys_rate);
+		fpc->clk_ps = ratio;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static inline unsigned long fsl_pwm_calculate_cycles(struct fsl_pwm_chip *fpc,
+		unsigned long period_ns)
+{
+	unsigned long long c, c0;
+
+	c = clk_get_rate(fpc->counter_clk);
+	c = c * period_ns;
+	do_div(c, 1000000000UL);
+
+	do {
+		c0 = c;
+		do_div(c0, (1 << fpc->clk_ps));
+		if (c0 <= 0xFFFF)
+			return (unsigned long)c0;
+	} while (++fpc->clk_ps < 8);
+
+	return 0;
+}
+
+static unsigned long fsl_pwm_calculate_period_cycles(struct fsl_pwm_chip *fpc,
+		unsigned long period_ns, int index)
+{
+	int ret;
+	unsigned long cycles;
+
+	fpc->counter_clk_select = FTM_SC_CLK(index);
+
+	ret = fsl_pwm_calculate_default_ps(fpc, index);
+	if (ret) {
+		dev_err(fpc->chip.dev, "failed to calculate default ps.\n");
+		return 0;
+	}
+
+	cycles = fsl_pwm_calculate_cycles(fpc, period_ns);
+
+	return cycles;
+}
+
+static unsigned long fsl_pwm_calculate_period(struct fsl_pwm_chip *fpc,
+		unsigned long period_ns)
+{
+	unsigned long cycles;
+	int m0, m1;
+	unsigned long fix_rate, ext_rate;
+	struct clk *cnt_clk[FSL_PWM_CLK_MAX];
+
+	fpc->counter_clk = fpc->sys_clk;
+	cycles = fsl_pwm_calculate_period_cycles(fpc, period_ns,
+			FSL_PWM_CLK_SYS);
+	if (cycles)
+		return cycles;
+
+	cnt_clk[FSL_PWM_CLK_FIX] = devm_clk_get(fpc->chip.dev, "ftm_fix");
+	if (IS_ERR(cnt_clk[FSL_PWM_CLK_FIX]))
+		return PTR_ERR(cnt_clk[FSL_PWM_CLK_FIX]);
+
+	cnt_clk[FSL_PWM_CLK_EXT] = devm_clk_get(fpc->chip.dev, "ftm_ext");
+	if (IS_ERR(cnt_clk[FSL_PWM_CLK_EXT]))
+		return PTR_ERR(cnt_clk[FSL_PWM_CLK_EXT]);
+
+	fpc->counter_clk_en = devm_clk_get(fpc->chip.dev, "ftm_cnt_clk_en");
+	if (IS_ERR(fpc->counter_clk_en))
+		return PTR_ERR(fpc->counter_clk_en);
+
+	fix_rate = clk_get_rate(cnt_clk[FSL_PWM_CLK_FIX]);
+	ext_rate = clk_get_rate(cnt_clk[FSL_PWM_CLK_EXT]);
+
+	if (fix_rate > ext_rate) {
+		m0 = FSL_PWM_CLK_FIX;
+		m1 = FSL_PWM_CLK_EXT;
+	} else {
+		m0 = FSL_PWM_CLK_EXT;
+		m1 = FSL_PWM_CLK_FIX;
+
+	}
+
+	fpc->counter_clk = cnt_clk[m0];
+	cycles = fsl_pwm_calculate_period_cycles(fpc, period_ns, m0);
+	if (cycles)
+		return cycles;
+
+	fpc->counter_clk = cnt_clk[m1];
+	cycles = fsl_pwm_calculate_period_cycles(fpc, period_ns, m0);
+
+	return cycles;
+}
+
+static unsigned long fsl_pwm_calculate_duty(struct fsl_pwm_chip *fpc,
+		unsigned long period_ns, unsigned long duty_ns)
+{
+	unsigned long long val, duty;
+
+	val = fsl_pwm_readl(fpc, fpc->base + FTM_MOD);
+	duty = duty_ns * (val + 1);
+	do_div(duty, period_ns);
+
+	return (unsigned long)duty;
+}
+
+static int fsl_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			  int duty_ns, int period_ns)
+{
+	u32 val, period, duty;
+	struct fsl_pwm_chip *fpc = to_fsl_chip(chip);
+
+	mutex_lock(&fpc->lock);
+	if (fpc->period_ns && fpc->period_ns != period_ns) {
+		dev_err(fpc->chip.dev, "fail to config pwm%d, the period "
+				"time should be the same with the current "
+				"running pwm(s).\n", pwm->hwpwm);
+		mutex_unlock(&fpc->lock);
+		return -EINVAL;
+	}
+
+	if (!fpc->period_ns && duty_ns) {
+		period = fsl_pwm_calculate_period(fpc, period_ns);
+		if (!period) {
+			dev_err(fpc->chip.dev, "fail to calculate the "
+					"period cycles.\n");
+			mutex_unlock(&fpc->lock);
+			return -EINVAL;
+		}
+
+		val = fsl_pwm_readl(fpc, fpc->base + FTM_SC);
+		val &= ~(FTM_SC_PS_MASK << FTM_SC_PS_SHIFT);
+		val |= fpc->clk_ps;
+		fsl_pwm_writel(fpc, val, fpc->base + FTM_SC);
+		fsl_pwm_writel(fpc, period - 1, fpc->base + FTM_MOD);
+
+		fpc->period_ns = period_ns;
+	}
+	mutex_unlock(&fpc->lock);
+
+	duty = fsl_pwm_calculate_duty(fpc, period_ns, duty_ns);
+
+	fsl_pwm_writel(fpc, FTM_CSC_MSB | FTM_CSC_ELSB,
+			fpc->base + FTM_CSC(pwm->hwpwm));
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
+	ret = clk_prepare_enable(fpc->counter_clk_en);
+	if (ret) {
+		fpc->counter_clk_enable--;
+		return ret;
+	}
+
+	/* select counter clock source */
+	val = fsl_pwm_readl(fpc, fpc->base + FTM_SC);
+	val &= ~(FTM_SC_CLK_MASK << FTM_SC_CLK_SHIFT);
+	val |= fpc->counter_clk_select;
+	fsl_pwm_writel(fpc, val, fpc->base + FTM_SC);
+
+	return 0;
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
+	mutex_lock(&fpc->lock);
+	ret = fsl_counter_clock_enable(fpc);
+	mutex_unlock(&fpc->lock);
+
+	return ret;
+}
+
+static inline void fsl_counter_clock_disable(struct fsl_pwm_chip *fpc)
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
+	clk_disable_unprepare(fpc->counter_clk_en);
+	clk_disable_unprepare(fpc->counter_clk);
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
+	if ((val & 0xFF) == 0xFF) {
+		fpc->period_ns = 0;
+		fpc->counter_clk_en = NULL;
+	}
+	mutex_unlock(&fpc->lock);
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
+static int fsl_pwm_probe(struct platform_device *pdev)
+{
+	int ret;
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
+	fpc->big_endian = of_property_read_bool(np, "big-endian");
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	fpc->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(fpc->base))
+		return PTR_ERR(fpc->base);
+
+	fpc->sys_clk = devm_clk_get(fpc->chip.dev, "ftm_sys");
+	if (IS_ERR(fpc->sys_clk)) {
+		dev_err(fpc->chip.dev,
+				"failed to get \"ftm_sys\" clock\n");
+		return PTR_ERR(fpc->sys_clk);
+	}
+
+	ret = clk_prepare_enable(fpc->sys_clk);
+	if (ret)
+		return ret;
+
+	fsl_pwm_writel(fpc, 0x00, fpc->base + FTM_CNTIN);
+	fsl_pwm_writel(fpc, 0x00, fpc->base + FTM_OUTINIT);
+	fsl_pwm_writel(fpc, 0xFF, fpc->base + FTM_OUTMASK);
+	clk_disable_unprepare(fpc->sys_clk);
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
+MODULE_DESCRIPTION("Freescale FlexTimer Module PWM Driver");
+MODULE_AUTHOR("Xiubo Li <Li.Xiubo@freescale.com>");
+MODULE_ALIAS("platform:fsl-ftm-pwm");
+MODULE_LICENSE("GPL");
-- 
1.8.4


