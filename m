Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3HUDKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 23:10:41 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:44037
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036Ab3HUDKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 23:10:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zz78fbmc8kzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <thierry.reding@gmail.com>
CC: <grant.likely@linaro.org>, <linux@arm.linux.org.uk>, <rob@landley.net>,
        <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Jingchang Lu <b35083@freescale.com>
Subject: [PATCH 1/4] pwm: add freescale ftm pwm driver support
Date: Wed, 21 Aug 2013 11:07:39 +0800
Message-ID: <1377054462-6283-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add freescale ftm pwm driver support. The ftm pwm device
can be found on Vybrid VF610 and Layerscape LS-1 SoCs.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Jingchang Lu <b35083@freescale.com>
---
 drivers/pwm/Kconfig       |  10 +
 drivers/pwm/Makefile      |   1 +
 drivers/pwm/pwm-fsl-ftm.c | 586 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 597 insertions(+)
 create mode 100644 drivers/pwm/pwm-fsl-ftm.c

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 75840b5..247b4c3 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -62,6 +62,16 @@ config PWM_BFIN
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-bfin.
 
+config PWM_FTM
+	tristate "Freescale FTM PWM support"
+	depends on OF
+	help
+	  Generic FTM PWM framework driver for Freescale VF610 and
+	  Layerscape LS-1 SoCs.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-ftm.
+
 config PWM_IMX
 	tristate "i.MX PWM support"
 	depends on ARCH_MXC
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 77a8c18..0e7f6ae 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_PWM_SYSFS)		+= sysfs.o
 obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
 obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
 obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
+obj-$(CONFIG_PWM_FTM)		+= pwm-fsl-ftm.o
 obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
 obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
 obj-$(CONFIG_PWM_LPC32XX)	+= pwm-lpc32xx.o
diff --git a/drivers/pwm/pwm-fsl-ftm.c b/drivers/pwm/pwm-fsl-ftm.c
new file mode 100644
index 0000000..f10ed34
--- /dev/null
+++ b/drivers/pwm/pwm-fsl-ftm.c
@@ -0,0 +1,586 @@
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
+#define FTMSC_CPWMS         (0x1 << 5)
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
+#define FTM_CSC(_CHANNEL) \
+	(FTM_CSC_BASE + (_CHANNEL * 0x08))
+#define FTMCnSC_MSB         (0x01 << 5)
+#define FTMCnSC_MSA         (0x01 << 4)
+#define FTMCnSC_ELSB        (0x01 << 3)
+#define FTMCnSC_ELSA        (0x01 << 2)
+#define FTM_PWMMODE         (FTMCnSC_MSB)
+#define FTM_HIGH_TRUE       (FTMCnSC_ELSB)
+#define FTM_LOW_TRUE        (FTMCnSC_ELSA)
+
+#define FTM_CV_BASE         0x10
+#define FTM_CV(_CHANNEL) \
+	(FTM_CV_BASE + (_CHANNEL * 0x08))
+
+#define FTM_CNTIN           0x4C
+#define FTM_STATUS          0x50
+
+#define FTM_MODE            0x54
+#define FTMMODE_FTMEN       (0x01 << 0)
+#define FTMMODE_INIT        (0x01 << 2)
+#define FTMMODE_PWMSYNC     (0x01 << 3)
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
+#define FTM_MAX_CHANNEL     0x08
+#define FTM_CNTIN_VAL       0x00
+
+struct fsl_pwm {
+	unsigned long period_cycles;
+	unsigned long duty_cycles;
+};
+
+struct fsl_pwm_chip {
+	struct mutex lock;
+
+	struct platform_device *pdev;
+	struct pwm_chip chip;
+
+	unsigned int	clk_ps;
+	struct clk	*clk;
+
+	void __iomem	*base;
+
+	unsigned int	cpwm;
+	struct fsl_pwm fpwms[FTM_MAX_CHANNEL];
+
+	/* pinctrl handles */
+	struct pinctrl          *pinctrl;
+};
+
+static inline struct fsl_pwm_chip *to_fsl_chip(struct pwm_chip *chip)
+{
+	return container_of(chip, struct fsl_pwm_chip, chip);
+}
+
+static int fsl_pwm_request_channel(struct pwm_chip *chip,
+			       struct pwm_device *pwm)
+{
+	int ret = 0;
+	struct fsl_pwm_chip *fpc;
+
+	fpc = to_fsl_chip(chip);
+
+	ret = clk_prepare_enable(fpc->clk);
+	if (ret) {
+		dev_err(&fpc->pdev->dev,
+				"failed to clk_prepare_enable "
+				"ftm pwm module clock : %d\n",
+				ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void fsl_pwm_free_channel(struct pwm_chip *chip,
+			     struct pwm_device *pwm)
+{
+	struct fsl_pwm_chip *fpc;
+
+	fpc = to_fsl_chip(chip);
+
+	clk_disable_unprepare(fpc->clk);
+}
+
+/* For center-aligned PWM:
+ * period = 2*(MOD - CNTIN)
+ * duty = 2*(CnV - CNTIN)
+ * For edge-aligend PWM:
+ * period = MOD - CNTIN + 1
+ * duty = CnV - CNTIN
+ */
+static int fsl_updata_config(struct fsl_pwm_chip *fpc,
+			     struct pwm_device *pwm)
+{
+	int i;
+	unsigned long reg, cntin = FTM_CNTIN_VAL;
+	struct pwm_chip *chip = &fpc->chip;
+
+	reg = readl(fpc->base + FTM_SC);
+	reg &= ~(FTMSC_CPWMS);
+	reg |= (fpc->cpwm ? FTMSC_CPWMS : 0x00);
+	writel(reg, fpc->base + FTM_SC);
+
+	if (pwm && fpc->cpwm) {
+		writel(fpc->fpwms[pwm->hwpwm].period_cycles / 2 + cntin,
+				fpc->base + FTM_MOD);
+		writel(fpc->fpwms[pwm->hwpwm].duty_cycles / 2 + cntin,
+				fpc->base + FTM_CV(pwm->hwpwm));
+	} else if (pwm) {
+		writel(fpc->fpwms[pwm->hwpwm].period_cycles + cntin - 1,
+				fpc->base + FTM_MOD);
+		writel(fpc->fpwms[pwm->hwpwm].duty_cycles + cntin,
+				fpc->base + FTM_CV(pwm->hwpwm));
+	}
+
+	if (pwm)
+		return 0;
+
+	for (i = 0; i < chip->npwm; i++) {
+		if (!test_bit(PWMF_ENABLED, &chip->pwms[i].flags))
+			continue;
+		if (fpc->cpwm) {
+			writel(fpc->fpwms[i].period_cycles / 2 + cntin,
+					fpc->base + FTM_MOD);
+			writel(fpc->fpwms[i].duty_cycles / 2 + cntin,
+					fpc->base + FTM_CV(i));
+		} else {
+			writel(fpc->fpwms[i].period_cycles + cntin - 1,
+					fpc->base + FTM_MOD);
+			writel(fpc->fpwms[i].duty_cycles + cntin,
+					fpc->base + FTM_CV(i));
+		}
+	}
+
+	return 0;
+}
+
+static unsigned long
+fsl_rate_to_cycles(struct fsl_pwm_chip *fpc, int time_ns)
+{
+	unsigned long ps;
+	unsigned long long c;
+
+	ps = (0x01 << fpc->clk_ps);
+
+	/* The module clk is HZ/s, the time_ns parameter
+	 * is based nanosecond, so here should divide
+	 * 1000000000UL.
+	 */
+	c = clk_get_rate(fpc->clk);
+	c = c * time_ns;
+	do_div(c, 1000000000UL);
+	do_div(c, ps);
+
+	return (unsigned long)c;
+}
+
+static int fsl_pwm_config_channel(struct pwm_chip *chip,
+			      struct pwm_device *pwm,
+			      int duty_ns,
+			      int period_ns)
+{
+	unsigned long period_cycles, duty_cycles;
+	struct fsl_pwm_chip *fpc;
+
+	fpc = to_fsl_chip(chip);
+
+	if (WARN_ON(!test_bit(PWMF_REQUESTED, &pwm->flags)))
+		return -ESHUTDOWN;
+
+	period_cycles = fsl_rate_to_cycles(fpc, period_ns);
+	if (period_cycles > 0xFFFF) {
+		dev_warn(&fpc->pdev->dev,
+				"required PWM period cycles(%lu) "
+				"overflow 16-bits counter!\n",
+				period_cycles);
+		period_cycles = 0xFFFF;
+	}
+
+	duty_cycles = fsl_rate_to_cycles(fpc, duty_ns);
+	if (duty_cycles >= 0xFFFF) {
+		dev_warn(&fpc->pdev->dev,
+				"required PWM duty cycles(%lu) "
+				"overflow 16-bits counter!\n",
+				duty_cycles);
+		duty_cycles = 0xFFFF - 1;
+	}
+
+	fpc->fpwms[pwm->hwpwm].period_cycles = period_cycles;
+	fpc->fpwms[pwm->hwpwm].duty_cycles = duty_cycles;
+
+	writel(FTM_PWMMODE | FTM_HIGH_TRUE,
+			fpc->base + FTM_CSC(pwm->hwpwm));
+
+	writel(0xF0, fpc->base + FTM_OUTMASK);
+	writel(0x0F, fpc->base + FTM_OUTINIT);
+	writel(FTM_CNTIN_VAL, fpc->base + FTM_CNTIN);
+
+	mutex_lock(&fpc->lock);
+	fsl_updata_config(fpc, pwm);
+	mutex_unlock(&fpc->lock);
+
+	return 0;
+}
+
+static int fsl_pwm_set_channel_polarity(struct pwm_chip *chip,
+				    struct pwm_device *pwm,
+				    enum pwm_polarity polarity)
+{
+	unsigned long reg;
+	struct fsl_pwm_chip *fpc;
+
+	fpc = to_fsl_chip(chip);
+
+	reg = readl(fpc->base + FTM_POL);
+	reg &= ~(0x01 << pwm->hwpwm);
+	reg |= (polarity << pwm->hwpwm);
+	writel(reg, fpc->base + FTM_POL);
+
+	return 0;
+}
+
+static int is_any_other_channel_enabled(struct pwm_chip *chip,
+				    unsigned int cur)
+{
+	int i;
+
+	for (i = 0; i < chip->npwm; i++) {
+		if (i == cur)
+			continue;
+		if (test_bit(PWMF_ENABLED, &chip->pwms[i].flags))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int fsl_pwm_enable_channel(struct pwm_chip *chip,
+			      struct pwm_device *pwm)
+{
+	int ret;
+	unsigned long reg;
+	struct fsl_pwm_chip *fpc;
+	struct pinctrl_state *pins_state;
+	const char *statename;
+
+	fpc = to_fsl_chip(chip);
+
+	if (WARN_ON(!test_bit(PWMF_REQUESTED, &pwm->flags)))
+		return -ESHUTDOWN;
+
+	statename = kasprintf(GFP_KERNEL, "en%d", pwm->hwpwm);
+	pins_state = pinctrl_lookup_state(fpc->pinctrl,
+			statename);
+	/* enable pins to be muxed in and configured */
+	if (!IS_ERR(pins_state)) {
+		ret = pinctrl_select_state(fpc->pinctrl, pins_state);
+		if (ret)
+			dev_warn(&fpc->pdev->dev,
+					"could not set default pins\n");
+	} else
+		dev_warn(&fpc->pdev->dev,
+				"could not get default pinstate\n");
+
+	if (is_any_other_channel_enabled(chip, pwm->hwpwm))
+		return 0;
+
+	reg = readl(fpc->base + FTM_SC);
+	reg &= ~((FTMSC_CLK_MASK << FTMSC_CLK_OFFSET) |
+			(FTMSC_PS_MASK << FTMSC_PS_OFFSET));
+	/* select system clock source */
+	reg |= (FTMSC_CLKSYS | fpc->clk_ps);
+	writel(reg, fpc->base + FTM_SC);
+
+	return 0;
+}
+
+static void fsl_pwm_disable_channel(struct pwm_chip *chip,
+				struct pwm_device *pwm)
+{
+	int ret;
+	unsigned long reg;
+	struct fsl_pwm_chip *fpc;
+	struct pinctrl_state    *pins_state;
+	const char *statename;
+
+	fpc = to_fsl_chip(chip);
+
+	statename = kasprintf(GFP_KERNEL, "ds%d", pwm->hwpwm);
+	pins_state = pinctrl_lookup_state(fpc->pinctrl,
+			statename);
+	/* enable pins to be muxed in and configured */
+	if (!IS_ERR(pins_state)) {
+		ret = pinctrl_select_state(fpc->pinctrl, pins_state);
+		if (ret)
+			dev_warn(&fpc->pdev->dev,
+					"could not set default pins\n");
+	} else
+		dev_warn(&fpc->pdev->dev,
+				"could not get default pinstate\n");
+
+	if (WARN_ON(!test_bit(PWMF_REQUESTED, &pwm->flags)))
+		return;
+
+	if (is_any_other_channel_enabled(chip, pwm->hwpwm))
+		return;
+
+	writel(0xFF, fpc->base + FTM_OUTMASK);
+	reg = readl(fpc->base + FTM_SC);
+	reg &= ~(FTMSC_CLK_MASK << FTMSC_CLK_OFFSET);
+	writel(reg, fpc->base + FTM_SC);
+}
+
+static const struct pwm_ops fsl_pwm_ops = {
+	.request = fsl_pwm_request_channel,
+	.free = fsl_pwm_free_channel,
+	.config = fsl_pwm_config_channel,
+	.set_polarity = fsl_pwm_set_channel_polarity,
+	.enable = fsl_pwm_enable_channel,
+	.disable = fsl_pwm_disable_channel,
+	.owner = THIS_MODULE,
+};
+
+static ssize_t fsl_pwm_cpwm_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct fsl_pwm_chip *fpc;
+
+	fpc = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", fpc->cpwm);
+}
+
+static ssize_t fsl_pwm_cpwm_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf,
+				  size_t count)
+{
+	int ret;
+	unsigned int val;
+	struct fsl_pwm_chip *fpc;
+
+	fpc = dev_get_drvdata(dev);
+
+	ret = kstrtouint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	mutex_lock(&fpc->lock);
+	if (!!(val) != !!(fpc->cpwm)) {
+		fpc->cpwm = !!val;
+		fsl_updata_config(fpc, NULL);
+	}
+	mutex_unlock(&fpc->lock);
+
+	return count;
+}
+
+static DEVICE_ATTR(cpwm, S_IRUGO | S_IWUSR | S_IWGRP,
+		fsl_pwm_cpwm_show, fsl_pwm_cpwm_store);
+
+static struct attribute *fsl_pwm_attrs[] = {
+	&dev_attr_cpwm.attr,
+	NULL
+};
+
+static const struct attribute_group fsl_pwm_attr_group = {
+	.attrs          = fsl_pwm_attrs,
+};
+
+static int fsl_pwm_parse_dt(struct fsl_pwm_chip *fpc)
+{
+	int ret = 0;
+	u32 chs[FTM_MAX_CHANNEL];
+	struct device_node *np = fpc->pdev->dev.of_node;
+
+	ret = of_property_read_u32(np, "fsl,pwm-clk-ps",
+				   &fpc->clk_ps);
+	if (ret < 0) {
+		dev_err(&fpc->pdev->dev,
+				"failed to get pwm "
+				"clk prescaler : %d\n",
+				ret);
+		return ret;
+	}
+	if (fpc->clk_ps > 7 || fpc->clk_ps < 0)
+		return -EINVAL;
+
+	ret = of_property_read_u32(np, "fsl,pwm-cpwm",
+				   &fpc->cpwm);
+	if (ret < 0) {
+		dev_err(&fpc->pdev->dev,
+				"failed to get cpwm "
+				"status: %d\n",
+				ret);
+		return ret;
+	}
+
+	ret = of_property_read_u32(np, "fsl,pwm-number",
+				   &fpc->chip.npwm);
+	if (ret < 0) {
+		dev_err(&fpc->pdev->dev,
+				"failed to get pwm number: %d\n",
+				ret);
+		return ret;
+	}
+	if (fpc->chip.npwm > FTM_MAX_CHANNEL
+			|| fpc->chip.npwm <= 0)
+		return -EINVAL;
+
+	ret = of_property_read_u32_array(np, "fsl,pwm-channels",
+					 chs, fpc->chip.npwm);
+	if (ret < 0) {
+		dev_err(&fpc->pdev->dev,
+				"failed to get pwm channel Ids: %d\n",
+				ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int fsl_pwm_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct fsl_pwm_chip *fpc;
+	struct resource *res;
+
+	fpc = devm_kzalloc(&pdev->dev, sizeof(*fpc), GFP_KERNEL);
+	if (!fpc) {
+		dev_err(&pdev->dev,
+				"failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	mutex_init(&fpc->lock);
+
+	fpc->pdev = pdev;
+
+	ret = fsl_pwm_parse_dt(fpc);
+	if (ret < 0)
+		return ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	fpc->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(fpc->base)) {
+		dev_err(&pdev->dev,
+				"failed to ioremap() registers\n");
+		ret = PTR_ERR(fpc->base);
+		return ret;
+	}
+
+	fpc->chip.dev = &pdev->dev;
+	fpc->chip.ops = &fsl_pwm_ops;
+	fpc->chip.of_xlate = of_pwm_xlate_with_flags;
+	fpc->chip.of_pwm_n_cells = 3;
+	fpc->chip.base = -1;
+
+	ret = pwmchip_add(&fpc->chip);
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+				"failed to add ftm0 pwm chip %d\n",
+				ret);
+		return ret;
+	}
+
+	fpc->clk = devm_clk_get(&pdev->dev, "ftm0");
+	if (IS_ERR(fpc->clk)) {
+		ret = PTR_ERR(fpc->clk);
+		dev_err(&pdev->dev,
+				"failed to get ftm0's module clock %d\n",
+				ret);
+		return ret;
+	}
+
+	fpc->pinctrl = devm_pinctrl_get(&pdev->dev);
+	if (IS_ERR(fpc->pinctrl)) {
+		ret = PTR_ERR(fpc->pinctrl);
+		return ret;
+	}
+
+	ret = sysfs_create_group(&pdev->dev.kobj,
+				 &fsl_pwm_attr_group);
+	if (ret) {
+		dev_err(&pdev->dev,
+				"Failed to create sysfs "
+				"attributes, err: %d\n",
+				ret);
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
+	if (fpc == NULL)
+		return -ENODEV;
+
+	mutex_destroy(&fpc->lock);
+
+	sysfs_remove_group(&pdev->dev.kobj,
+			   &fsl_pwm_attr_group);
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


