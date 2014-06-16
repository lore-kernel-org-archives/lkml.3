Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbaFPUPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:15:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46007 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaFPUO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:14:56 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH 1/2] phy: qcom: Add driver for QCOM IPQ806x SATA PHY
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <539EC12C.6080504@ti.com>
Date: Mon, 16 Jun 2014 14:51:42 -0500
Cc: linux-ide@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A8CE5BD1-097E-416B-8D7C-D1CA84236C3E@codeaurora.org>
References: <1402600724-20651-1-git-send-email-galak@codeaurora.org> <539EC12C.6080504@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 16, 2014, at 5:04 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:

> Hi,
> 
> On Friday 13 June 2014 12:48 AM, Kumar Gala wrote:
>> Add a PHY driver for uses with AHCI based SATA controller driver on the
>> IPQ806x family of SoCs.
>> 
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> ---
>> drivers/phy/Kconfig                 |   6 ++
>> drivers/phy/Makefile                |   1 +
>> drivers/phy/phy-qcom-ipq806x-sata.c | 204 ++++++++++++++++++++++++++++++++++++
>> 3 files changed, 211 insertions(+)
>> create mode 100644 drivers/phy/phy-qcom-ipq806x-sata.c
>> 
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 16a2f06..52bfb93 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -178,4 +178,10 @@ config PHY_XGENE
>> 	help
>> 	  This option enables support for APM X-Gene SoC multi-purpose PHY.
>> 
>> +config PHY_QCOM_IPQ806X_SATA
>> +	tristate "Qualcomm IPQ806x SATA SerDes/PHY driver"
>> +	depends on ARCH_QCOM
>> +	depends on OF
> depends on HAS_IOMEM?

will add

>> +	select GENERIC_PHY
>> +
>> endmenu
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index b4f1d57..d950317 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -20,3 +20,4 @@ phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
>> phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
>> obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+= phy-exynos5-usbdrd.o
>> obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
>> +obj-$(CONFIG_PHY_QCOM_IPQ806X_SATA)	+= phy-qcom-ipq806x-sata.o
>> diff --git a/drivers/phy/phy-qcom-ipq806x-sata.c b/drivers/phy/phy-qcom-ipq806x-sata.c
>> new file mode 100644
>> index 0000000..fc57340
>> --- /dev/null
>> +++ b/drivers/phy/phy-qcom-ipq806x-sata.c
>> @@ -0,0 +1,204 @@
>> +/*
>> + * Copyright (c) 2014, The Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/time.h>
>> +#include <linux/delay.h>
>> +#include <linux/clk.h>
>> +#include <linux/slab.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/phy/phy.h>
>> +
>> +struct qcom_ipq806x_sata_phy {
>> +	struct device *dev;
> 
> dev is not used anywhere. remove it.

already done in v2

>> +	void __iomem *mmio;
>> +	struct clk *cfg_clk;
>> +};
>> +
>> +#define __set(v, a, b)	(((v) << (b)) & GENMASK(a, b))
>> +
>> +#define SATA_PHY_P0_PARAM0		0x200
>> +#define SATA_PHY_P0_PARAM0_P0_TX_PREEMPH_GEN3(x)	__set(x, 17, 12)
>> +#define SATA_PHY_P0_PARAM0_P0_TX_PREEMPH_GEN3_MASK	GENMASK(17, 12)
>> +#define SATA_PHY_P0_PARAM0_P0_TX_PREEMPH_GEN2(x)	__set(x, 11, 6)
>> +#define SATA_PHY_P0_PARAM0_P0_TX_PREEMPH_GEN2_MASK	GENMASK(11, 6)
>> +#define SATA_PHY_P0_PARAM0_P0_TX_PREEMPH_GEN1(x)	__set(x, 5, 0)
>> +#define SATA_PHY_P0_PARAM0_P0_TX_PREEMPH_GEN1_MASK	GENMASK(5, 0)
>> +
>> +#define SATA_PHY_P0_PARAM1		0x204
>> +#define SATA_PHY_P0_PARAM1_RESERVED_BITS31_21(x)	__set(x, 31, 21)
>> +#define SATA_PHY_P0_PARAM1_P0_TX_AMPLITUDE_GEN3(x)	__set(x, 20, 14)
>> +#define SATA_PHY_P0_PARAM1_P0_TX_AMPLITUDE_GEN3_MASK	GENMASK(20, 14)
>> +#define SATA_PHY_P0_PARAM1_P0_TX_AMPLITUDE_GEN2(x)	__set(x, 13, 7)
>> +#define SATA_PHY_P0_PARAM1_P0_TX_AMPLITUDE_GEN2_MASK	GENMASK(13, 7)
>> +#define SATA_PHY_P0_PARAM1_P0_TX_AMPLITUDE_GEN1(x)	__set(x, 6, 0)
>> +#define SATA_PHY_P0_PARAM1_P0_TX_AMPLITUDE_GEN1_MASK	GENMASK(6, 0)
>> +
>> +#define SATA_PHY_P0_PARAM2		0x208
>> +#define SATA_PHY_P0_PARAM2_RX_EQ(x)	__set(x, 20, 18)
>> +#define SATA_PHY_P0_PARAM2_RX_EQ_MASK	GENMASK(20, 18)
>> +
>> +#define SATA_PHY_P0_PARAM3		0x20C
>> +#define SATA_PHY_SSC_EN			0x8
>> +#define SATA_PHY_P0_PARAM4		0x210
>> +#define SATA_PHY_REF_SSP_EN		0x2
>> +#define SATA_PHY_RESET			0x1
>> +
>> +static inline void qcom_ipq806x_sata_delay_us(unsigned int delay)
>> +{
>> +	/* sleep for max. 50us more to combine processor wakeups */
>> +	usleep_range(delay, delay + 50);
>> +}
>> +
>> +static int qcom_ipq806x_sata_phy_init(struct phy *generic_phy)
>> +{
>> +	struct qcom_ipq806x_sata_phy *phy = phy_get_drvdata(generic_phy);
>> +	u32 reg = 0;
>> +
>> +	/* Setting SSC_EN to 1 */
>> +	reg = readl_relaxed(phy->mmio + SATA_PHY_P0_PARAM3);
> 
> Why readl_relaxed?

because there is no need for readl’s memory barriers here.

>> +	reg = reg | SATA_PHY_SSC_EN;
>> +	writel_relaxed(reg, phy->mmio + SATA_PHY_P0_PARAM3);
>> +
>> +	reg = readl_relaxed(phy->mmio + SATA_PHY_P0_PARAM0) &
>> +			~(SATA_PHY_P0_PARAM0_P0_TX_PREEMPH_GEN3_MASK |
>> +			  SATA_PHY_P0_PARAM0_P0_TX_PREEMPH_GEN2_MASK |
>> +			  SATA_PHY_P0_PARAM0_P0_TX_PREEMPH_GEN1_MASK);
>> +	reg |= SATA_PHY_P0_PARAM0_P0_TX_PREEMPH_GEN3(0xf);
>> +	writel_relaxed(reg, phy->mmio + SATA_PHY_P0_PARAM0);
>> +
>> +	reg = readl_relaxed(phy->mmio + SATA_PHY_P0_PARAM1) &
>> +			~(SATA_PHY_P0_PARAM1_P0_TX_AMPLITUDE_GEN3_MASK |
>> +			  SATA_PHY_P0_PARAM1_P0_TX_AMPLITUDE_GEN2_MASK |
>> +			  SATA_PHY_P0_PARAM1_P0_TX_AMPLITUDE_GEN1_MASK);
>> +	reg |= SATA_PHY_P0_PARAM1_P0_TX_AMPLITUDE_GEN3(0x55) |
>> +		SATA_PHY_P0_PARAM1_P0_TX_AMPLITUDE_GEN2(0x55) |
>> +		SATA_PHY_P0_PARAM1_P0_TX_AMPLITUDE_GEN1(0x55);
>> +	writel_relaxed(reg, phy->mmio + SATA_PHY_P0_PARAM1);
>> +
>> +	reg = readl_relaxed(phy->mmio + SATA_PHY_P0_PARAM2) &
>> +		~SATA_PHY_P0_PARAM2_RX_EQ_MASK;
>> +	reg |= SATA_PHY_P0_PARAM2_RX_EQ(0x3);
>> +	writel_relaxed(reg, phy->mmio + SATA_PHY_P0_PARAM2);
>> +
>> +	/* Setting PHY_RESET to 1 */
>> +	reg = readl_relaxed(phy->mmio + SATA_PHY_P0_PARAM4);
>> +	reg = reg | SATA_PHY_RESET;
>> +	writel_relaxed(reg, phy->mmio + SATA_PHY_P0_PARAM4);
>> +
>> +	/* Setting REF_SSP_EN to 1 */
>> +	reg = readl_relaxed(phy->mmio + SATA_PHY_P0_PARAM4);
>> +	reg = reg | SATA_PHY_REF_SSP_EN | SATA_PHY_RESET;
>> +	writel_relaxed(reg, phy->mmio + SATA_PHY_P0_PARAM4);
>> +	mb();
>> +	qcom_ipq806x_sata_delay_us(20);
>> +
>> +	/* Clearing PHY_RESET to 0 */
>> +	reg = readl_relaxed(phy->mmio + SATA_PHY_P0_PARAM4);
>> +	reg = reg & ~SATA_PHY_RESET;
>> +	writel_relaxed(reg, phy->mmio + SATA_PHY_P0_PARAM4);
>> +
>> +	return 0;
>> +}
>> +
>> +static int qcom_ipq806x_sata_phy_exit(struct phy *generic_phy)
>> +{
>> +	struct qcom_ipq806x_sata_phy *phy = phy_get_drvdata(generic_phy);
>> +	u32 reg = 0;
>> +
>> +	/* Setting PHY_RESET to 1 */
>> +	reg = readl_relaxed(phy->mmio + SATA_PHY_P0_PARAM4);
>> +	reg = reg | SATA_PHY_RESET;
>> +	writel_relaxed(reg, phy->mmio + SATA_PHY_P0_PARAM4);
>> +
>> +	return 0;
>> +}
>> +
>> +static struct phy_ops qcom_ipq806x_sata_phy_ops = {
>> +	.init		= qcom_ipq806x_sata_phy_init,
>> +	.exit		= qcom_ipq806x_sata_phy_exit,
>> +	.owner		= THIS_MODULE,
>> +};
>> +
>> +static int qcom_ipq806x_sata_phy_probe(struct platform_device *pdev)
>> +{
>> +	struct qcom_ipq806x_sata_phy *phy;
>> +	struct device *dev = &pdev->dev;
>> +	struct resource *res;
>> +	struct phy_provider *phy_provider;
>> +	struct phy *generic_phy;
>> +	int ret;
>> +
>> +	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
>> +	if (!phy) {
>> +		dev_err(dev, "%s: failed to allocate phy\n", __func__);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	phy->mmio = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(phy->mmio)) {
>> +		dev_err(dev, "%s: phy mmio get resource failed\n", __func__);
>> +		return PTR_ERR(phy->mmio);
>> +	}
>> +
>> +	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
>> +	if (IS_ERR(phy_provider)) {
>> +		dev_err(dev, "%s: failed to register phy\n", __func__);
>> +		return PTR_ERR(phy_provider);
>> +	}
> 
> phy_provider_register should be the last step. Move it after phy_set_drvdata().

will fix

> 
> Thanks
> Kishon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

