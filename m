Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3JXPwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:52:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36487 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab3JXPwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:52:34 -0400
Message-ID: <52694238.7050607@ti.com>
Date: Thu, 24 Oct 2013 21:22:24 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: <devicetree@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <kyungmin.park@samsung.com>, <t.figa@samsung.com>,
        <sw0312.kim@samsung.com>, <inki.dae@samsung.com>,
        <rahul.sharma@samsung.com>, <kgene.kim@samsung.com>,
        <s.nawrocki@samsung.com>, <thomas.abraham@linaro.org>,
        <mturquette@linaro.org>
Subject: Re: [RFC 04/12] phy: Add simple-phy driver
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com> <1382365111-6533-5-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1382365111-6533-5-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 21 October 2013 07:48 PM, Tomasz Stanislawski wrote:
> Add simple-phy driver to support a single register
> PHY interfaces present on Exynos4 SoC.

How are these PHY interfaces modelled in the SoC? Where does the register
actually reside?
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>  drivers/phy/Kconfig      |    5 ++
>  drivers/phy/Makefile     |    1 +
>  drivers/phy/phy-simple.c |  128 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 134 insertions(+)
>  create mode 100644 drivers/phy/phy-simple.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index ac239ac..619c657 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -38,4 +38,9 @@ config TWL4030_USB
>  	  This transceiver supports high and full speed devices plus,
>  	  in host mode, low speed.
>  
> +config PHY_SIMPLE
> +	tristate "Simple PHY driver"

This is too generic a name to be used. Lets name it something specific to what
it is used for (EXYNOS/HDMI.. ?).
> +	help
> +	  Support for PHY controllers configured using single register.
> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 0dd8a98..3d68e19 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -5,3 +5,4 @@
>  obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
>  obj-$(CONFIG_OMAP_USB2)		+= phy-omap-usb2.o
>  obj-$(CONFIG_TWL4030_USB)	+= phy-twl4030-usb.o
> +obj-$(CONFIG_PHY_SIMPLE)	+= phy-simple.o
> diff --git a/drivers/phy/phy-simple.c b/drivers/phy/phy-simple.c
> new file mode 100644
> index 0000000..4a28af7
> --- /dev/null
> +++ b/drivers/phy/phy-simple.c
> @@ -0,0 +1,128 @@
> +/*
> + * Simple PHY driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Author: Tomasz Stanislawski <t.stanislaws@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
> +
> +struct simple_phy {
> +	spinlock_t slock;
> +	u32 on_value;
> +	u32 off_value;
> +	u32 mask;
> +	void __iomem *regs;
> +};
> +
> +static int sphy_set(struct simple_phy *sphy, bool on)
> +{
> +	u32 reg;
> +
> +	spin_lock(&sphy->slock);

Lets add spin_lock only when it is absolutely necessary. When your PHY provider
implements only a single PHY, it is not needed. phy_power_on and phy_power_off
is already protected by the framework.
> +
> +	reg = readl(sphy->regs);
> +	reg &= ~sphy->mask;
> +	reg |= sphy->mask & (on ? sphy->on_value : sphy->off_value);
> +	writel(reg, sphy->regs);
> +
> +	spin_unlock(&sphy->slock);
> +
> +	return 0;
> +}
> +
> +static int simple_phy_power_on(struct phy *phy)
> +{
> +	return sphy_set(phy_get_drvdata(phy), 1);
> +}
> +
> +static int simple_phy_power_off(struct phy *phy)
> +{
> +	return sphy_set(phy_get_drvdata(phy), 0);
> +}
> +
> +static struct phy_ops simple_phy_ops = {
> +	.power_on	= simple_phy_power_on,
> +	.power_off	= simple_phy_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int simple_phy_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct simple_phy *sphy;
> +	struct resource *res;
> +	struct phy_provider *phy_provider;
> +	struct phy *phy;
> +
> +	sphy = devm_kzalloc(dev, sizeof(*sphy), GFP_KERNEL);
> +	if (!sphy)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +	sphy->regs = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(sphy->regs)) {
> +		dev_err(dev, "failed to ioremap registers\n");
> +		return PTR_ERR(sphy->regs);
> +	}
> +
> +	spin_lock_init(&sphy->slock);
> +
> +	phy_provider = devm_of_phy_provider_register(dev, NULL);

pass 'of_phy_simple_xlate' instead of NULL.
> +	if (IS_ERR(phy_provider)) {
> +		dev_err(dev, "failed to register PHY provider\n");
> +		return PTR_ERR(phy_provider);
> +	}
> +
> +	phy = devm_phy_create(dev, &simple_phy_ops, NULL);
> +	if (IS_ERR(phy)) {
> +		dev_err(dev, "failed to create PHY\n");
> +		return PTR_ERR(phy);
> +	}
> +
> +	sphy->mask = 1;
> +	sphy->on_value = ~0;
> +	sphy->off_value = 0;
> +
> +	of_property_read_u32(dev->of_node, "mask", &sphy->mask);

This means your driver will depend on dt data to describe how the register
should look like. Not a good idea.
> +	of_property_read_u32(dev->of_node, "on-value", &sphy->on_value);
> +	of_property_read_u32(dev->of_node, "off-value", &sphy->off_value);
> +
> +	phy_set_drvdata(phy, sphy);
> +
> +	dev_info(dev, "probe successful\n");
Lets not make the boot noisy.

Thanks
Kishon
