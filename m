Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaGIImu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:42:50 -0400
Received: from gloria.sntech.de ([95.129.55.99]:49458 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbaGIImr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:42:47 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        =?utf-8?B?ZWRkaWUo6JSh5p6rKQ==?= <cf@rock-chips.com>,
        huangtao@rock-chips.com, Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH v2 1/2] iio: adc: add driver for Rockchip saradc
Date: Wed, 09 Jul 2014 10:44:06 +0200
Message-ID: <2482306.yDb91TH59G@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <2959154.xc8BQActsn@diego>
References: <2959154.xc8BQActsn@diego>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ADC is a 3-channel signal-ended 10-bit Successive Approximation
Register (SAR) A/D Converter. It uses the supply and ground as its reference
and converts the analog input signal into 10-bit binary digital codes.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
changes since v1:
- address comments from Peter Meerwald

 drivers/iio/adc/Kconfig           |  10 ++
 drivers/iio/adc/Makefile          |   1 +
 drivers/iio/adc/rockchip_saradc.c | 313 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 324 insertions(+)
 create mode 100644 drivers/iio/adc/rockchip_saradc.c

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index a80d236..5d36bdb 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -187,6 +187,16 @@ config NAU7802
 	  To compile this driver as a module, choose M here: the
 	  module will be called nau7802.
 
+config ROCKCHIP_SARADC
+	tristate "Rockchip SARADC driver"
+	depends on ARCH_ROCKCHIP || (OF && COMPILE_TEST)
+	help
+	  Say yes here to build support for the SARADC found in SoCs from
+	  Rockchip.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rockchip_saradc.
+
 config TI_ADC081C
 	tristate "Texas Instruments ADC081C021/027"
 	depends on I2C
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index 9d60f2d..8e2932d 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_MCP320X) += mcp320x.o
 obj-$(CONFIG_MCP3422) += mcp3422.o
 obj-$(CONFIG_MEN_Z188_ADC) += men_z188_adc.o
 obj-$(CONFIG_NAU7802) += nau7802.o
+obj-$(CONFIG_ROCKCHIP_SARADC) += rockchip_saradc.o
 obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
 obj-$(CONFIG_TI_AM335X_ADC) += ti_am335x_adc.o
 obj-$(CONFIG_TWL4030_MADC) += twl4030-madc.o
diff --git a/drivers/iio/adc/rockchip_saradc.c b/drivers/iio/adc/rockchip_saradc.c
new file mode 100644
index 0000000..3f0164c
--- /dev/null
+++ b/drivers/iio/adc/rockchip_saradc.c
@@ -0,0 +1,313 @@
+/*
+ * Rockchip Successive Approximation Register (SAR) A/D Converter
+ * Copyright (C) 2014 ROCKCHIP, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/regulator/consumer.h>
+#include <linux/iio/iio.h>
+
+#define SARADC_DATA			0x00
+#define SARADC_DATA_MASK		0x3ff
+
+#define SARADC_STAS			0x04
+#define SARADC_STAS_BUSY		BIT(0)
+
+#define SARADC_CTRL			0x08
+#define SARADC_CTRL_IRQ_STATUS		BIT(6)
+#define SARADC_CTRL_IRQ_ENABLE		BIT(5)
+#define SARADC_CTRL_POWER_CTRL		BIT(3)
+#define SARADC_CTRL_CHN_MASK		0x7
+
+#define SARADC_DLY_PU_SOC		0x0c
+#define SARADC_DLY_PU_SOC_MASK		0x3f
+
+#define SARADC_BITS			10
+#define SARADC_TIMEOUT			msecs_to_jiffies(100)
+
+struct rockchip_saradc {
+	void __iomem		*regs;
+	struct clk		*pclk;
+	struct clk		*clk;
+	struct completion	completion;
+	struct regulator	*vref;
+	int			vref_mv;
+	u16			last_val;
+};
+
+static int rockchip_saradc_read_raw(struct iio_dev *indio_dev,
+				    struct iio_chan_spec const *chan,
+				    int *val, int *val2, long mask)
+{
+	struct rockchip_saradc *info = iio_priv(indio_dev);
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		mutex_lock(&indio_dev->mlock);
+
+		/* Select the channel to be used and trigger conversion */
+		writel_relaxed(0x08, info->regs + SARADC_DLY_PU_SOC);
+		writel(SARADC_CTRL_POWER_CTRL
+				| (chan->channel & SARADC_CTRL_CHN_MASK)
+				| SARADC_CTRL_IRQ_ENABLE,
+		       info->regs + SARADC_CTRL);
+
+		if (!wait_for_completion_timeout(&info->completion,
+						 SARADC_TIMEOUT)) {
+			writel_relaxed(0, info->regs + SARADC_CTRL);
+			mutex_unlock(&indio_dev->mlock);
+			return -ETIMEDOUT;
+		}
+
+		*val = info->last_val;
+		mutex_unlock(&indio_dev->mlock);
+		return IIO_VAL_INT;
+	case IIO_CHAN_INFO_SCALE:
+		*val = info->vref_mv;
+		*val2 = SARADC_BITS;
+		return IIO_VAL_FRACTIONAL_LOG2;
+	default:
+		return -EINVAL;
+	}
+}
+
+static irqreturn_t rockchip_saradc_isr(int irq, void *dev_id)
+{
+	struct rockchip_saradc *info = (struct rockchip_saradc *)dev_id;
+
+	/* Read value */
+	info->last_val = readl_relaxed(info->regs + SARADC_DATA);
+	info->last_val &= SARADC_DATA_MASK;
+
+	/* clear irq & power down adc */
+	writel_relaxed(0, info->regs + SARADC_CTRL);
+
+	complete(&info->completion);
+
+	return IRQ_HANDLED;
+}
+
+static const struct iio_info rockchip_saradc_iio_info = {
+	.read_raw = rockchip_saradc_read_raw,
+	.driver_module = THIS_MODULE,
+};
+
+#define ADC_CHANNEL(_index, _id) {			\
+	.type = IIO_VOLTAGE,				\
+	.indexed = 1,					\
+	.channel = _index,				\
+	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),	\
+	.datasheet_name = _id,				\
+}
+
+static const struct iio_chan_spec rockchip_saradc_iio_channels[] = {
+	ADC_CHANNEL(0, "adc0"),
+	ADC_CHANNEL(1, "adc1"),
+	ADC_CHANNEL(2, "adc2"),
+};
+
+static int rockchip_saradc_probe(struct platform_device *pdev)
+{
+	struct rockchip_saradc *info = NULL;
+	struct device_node *np = pdev->dev.of_node;
+	struct iio_dev *indio_dev = NULL;
+	struct resource	*mem;
+	int ret = -ENODEV;
+	int irq;
+	u32 rate;
+
+	if (!np)
+		return ret;
+
+	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*info));
+	if (!indio_dev) {
+		dev_err(&pdev->dev, "failed allocating iio device\n");
+		return -ENOMEM;
+	}
+	info = iio_priv(indio_dev);
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	info->regs = devm_request_and_ioremap(&pdev->dev, mem);
+	if (!info->regs)
+		return -ENOMEM;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no irq resource?\n");
+		return irq;
+	}
+
+	ret = devm_request_irq(&pdev->dev, irq, rockchip_saradc_isr,
+			       0, dev_name(&pdev->dev), info);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed requesting irq %d\n", irq);
+		return ret;
+	}
+
+	init_completion(&info->completion);
+
+	info->pclk = devm_clk_get(&pdev->dev, "apb_pclk");
+	if (IS_ERR(info->pclk)) {
+		dev_err(&pdev->dev, "failed to get pclk\n");
+		return PTR_ERR(info->pclk);
+	}
+
+	info->clk = devm_clk_get(&pdev->dev, "saradc");
+	if (IS_ERR(info->clk)) {
+		dev_err(&pdev->dev, "failed to get adc clock\n");
+		return PTR_ERR(info->clk);
+	}
+
+	info->vref = devm_regulator_get(&pdev->dev, "vref");
+	if (IS_ERR(info->vref)) {
+		dev_err(&pdev->dev, "failed to get regulator, %ld\n",
+			PTR_ERR(info->vref));
+		return PTR_ERR(info->vref);
+	}
+
+	/* use a default of 1MHz for the converter clock */
+	if (of_property_read_u32(np, "clock-frequency", &rate))
+		rate = 1000000;
+
+	ret = clk_set_rate(info->clk, rate);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to set adc clk rate, %d\n", ret);
+		return ret;
+	}
+
+	ret = regulator_enable(info->vref);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to enable vref regulator\n");
+		return ret;
+	}
+
+	ret = regulator_get_voltage(info->vref);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to get regulator voltage\n");
+		goto err_reg_voltage;
+	}
+	info->vref_mv = ret / 1000;
+
+	ret = clk_prepare_enable(info->pclk);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to enable pclk\n");
+		goto err_reg_voltage;
+	}
+
+	ret = clk_prepare_enable(info->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to enable converter clock\n");
+		goto err_pclk;
+	}
+
+	platform_set_drvdata(pdev, indio_dev);
+
+	indio_dev->name = dev_name(&pdev->dev);
+	indio_dev->dev.parent = &pdev->dev;
+	indio_dev->dev.of_node = pdev->dev.of_node;
+	indio_dev->info = &rockchip_saradc_iio_info;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+
+	indio_dev->channels = rockchip_saradc_iio_channels;
+	indio_dev->num_channels = ARRAY_SIZE(rockchip_saradc_iio_channels);
+
+	ret = iio_device_register(indio_dev);
+	if (ret)
+		goto err_clk;
+
+	return 0;
+
+err_clk:
+	clk_disable_unprepare(info->clk);
+err_pclk:
+	clk_disable_unprepare(info->pclk);
+err_reg_voltage:
+	regulator_disable(info->vref);
+	return ret;
+}
+
+static int rockchip_saradc_remove(struct platform_device *pdev)
+{
+	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
+	struct rockchip_saradc *info = iio_priv(indio_dev);
+
+	iio_device_unregister(indio_dev);
+	clk_disable_unprepare(info->clk);
+	clk_disable_unprepare(info->pclk);
+	regulator_disable(info->vref);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int rockchip_saradc_suspend(struct device *dev)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct rockchip_saradc *info = iio_priv(indio_dev);
+
+	clk_disable_unprepare(info->clk);
+	clk_disable_unprepare(info->pclk);
+	regulator_disable(info->vref);
+
+	return 0;
+}
+
+static int rockchip_saradc_resume(struct device *dev)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct rockchip_saradc *info = iio_priv(indio_dev);
+	int ret;
+
+	ret = regulator_enable(info->vref);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(info->pclk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(info->clk);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(rockchip_saradc_pm_ops,
+			 rockchip_saradc_suspend, rockchip_saradc_resume);
+
+static const struct of_device_id rockchip_saradc_match[] = {
+	{ .compatible = "rockchip,saradc" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, rockchip_saradc_match);
+
+static struct platform_driver rockchip_saradc_driver = {
+	.probe		= rockchip_saradc_probe,
+	.remove		= rockchip_saradc_remove,
+	.driver		= {
+		.name	= "rockchip-saradc",
+		.owner	= THIS_MODULE,
+		.of_match_table = rockchip_saradc_match,
+		.pm	= &rockchip_saradc_pm_ops,
+	},
+};
+
+module_platform_driver(rockchip_saradc_driver);
-- 
1.9.0


