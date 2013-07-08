Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3GHLwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:52:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50770 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3GHLwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:52:16 -0400
Message-ID: <51DAA7E3.3080704@ti.com>
Date: Mon, 8 Jul 2013 17:22:03 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <bigeasy@linutronix.de>
Subject: Re: [PATCH 3/5] phy: phy-amxxxx-usb: Add PHY driver for amxxxx platform
References: <1373280201-31785-1-git-send-email-george.cherian@ti.com> <1373280201-31785-4-git-send-email-george.cherian@ti.com>
In-Reply-To: <1373280201-31785-4-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 08 July 2013 04:13 PM, George Cherian wrote:
> Adds phy driver support for am33xx platform, the host/device
> peripheral controller shall get this phy object to control the phy
> operations.
>
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   drivers/phy/Kconfig          |  12 +++
>   drivers/phy/Makefile         |   1 +
>   drivers/phy/phy-amxxxx-usb.c | 201 +++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 214 insertions(+)
>   create mode 100644 drivers/phy/phy-amxxxx-usb.c
>
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 5f85909..55087ab 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -11,3 +11,15 @@ menuconfig GENERIC_PHY
>   	  devices present in the kernel. This layer will have the generic
>   	  API by which phy drivers can create PHY using the phy framework and
>   	  phy users can obtain reference to the PHY.
> +if GENERIC_PHY
> +
> +config PHY_AMXXXX_USB
> +	tristate "AMXXXX USB2 PHY Driver"
> +	depends on SOC_AM33XX
> +	help
> +	  Enable this to support the transceiver that is part of SOC. This
> +	  phy supports all LS/FS/HS speed and also supports OTG functionality.
> +	  The USB OTG controller communicates with this phy through stand UTMI
> +	  interface.
> +
> +endif
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 9e9560f..471c525 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -3,3 +3,4 @@
>   #
>
>   obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
> +obj-$(CONFIG_PHY_AMXXXX_USB)	+= phy-amxxxx-usb.o
> diff --git a/drivers/phy/phy-amxxxx-usb.c b/drivers/phy/phy-amxxxx-usb.c
> new file mode 100644
> index 0000000..52c48eb
> --- /dev/null
> +++ b/drivers/phy/phy-amxxxx-usb.c
> @@ -0,0 +1,201 @@
> +/*
> + * phy-amxxxx-usb.c - USB PHY, talking to usb controller in AMXXX.
> + *
> + * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com

2013 ;-)
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * Author: George Cherian <george.cherian@ti.com>
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/usb/phy_companion.h>

phy_companion not needed here.
> +#include <linux/clk.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/usb/omap_control_usb.h>
> +#include <linux/phy/phy.h>
> +
> +struct amxxxx_usb {
> +	struct usb_phy	phy;
> +	struct device	*dev;
> +	struct device	*control_dev;
> +	struct clk	*optclk;
> +	u8		id;
> +};
> +
> +#define phy_to_amxxxxphy(x)	container_of((x), struct amxxxx_phy, phy)
> +
> +

Additional blank line.
> +static int amxxxx_usb_power_off(struct phy *x)
> +{
> +	struct amxxxx_usb *phy = phy_get_drvdata(x);
> +
> +	omap_control_am335x_phy_power(phy->control_dev, 0, phy->id);
> +
> +	return 0;
> +}
> +
> +static int amxxxx_usb_power_on(struct phy *x)
> +{
> +	struct amxxxx_usb *phy = phy_get_drvdata(x);
> +
> +	omap_control_am335x_phy_power(phy->control_dev, 1, phy->id);
> +
> +	return 0;
> +}
> +
> +static struct phy_ops ops = {
> +	.power_on	= amxxxx_usb_power_on,
> +	.power_off	= amxxxx_usb_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int amxxxx_usb2_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct amxxxx_usb			*phy;
> +	struct phy			*generic_phy;
> +	struct usb_otg			*otg;
> +	struct phy_provider		*phy_provider;

Alignment is not needed for local variables.
> +
> +	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
> +	if (!phy) {
> +		dev_err(&pdev->dev, "unable to allocate memory for USB2 PHY\n");

remove this dev_err. memory allocation failures will throw some dumps already.
> +		return -ENOMEM;
> +	}
> +
> +	otg = devm_kzalloc(&pdev->dev, sizeof(*otg), GFP_KERNEL);
> +	if (!otg) {
> +		dev_err(&pdev->dev, "unable to allocate memory for USB OTG\n");

ditto.
> +		return -ENOMEM;
> +	}
> +
> +	phy->dev		= &pdev->dev;
> +
> +	if (np)
> +		of_property_read_u8(np, "id", &phy->id);
> +
> +	phy->phy.dev		= phy->dev;
> +	phy->phy.label		= "amxxxx-usb2";
> +	phy->phy.otg		= otg;
> +	phy->phy.type		= USB_PHY_TYPE_USB2;
> +
> +	phy_provider = devm_of_phy_provider_register(phy->dev,
> +			of_phy_simple_xlate);
> +	if (IS_ERR(phy_provider))
> +		return PTR_ERR(phy_provider);
> +
> +	phy->control_dev = omap_get_control_dev();
> +	if (IS_ERR(phy->control_dev)) {
> +		dev_dbg(&pdev->dev, "Failed to get control device\n");
> +		return -ENODEV;
> +	}
> +
> +	omap_control_am335x_phy_power(phy->control_dev, 0, phy->id);
> +
> +	otg->phy		= &phy->phy;
> +
> +	platform_set_drvdata(pdev, phy);
> +	pm_runtime_enable(phy->dev);
> +
> +	generic_phy = devm_phy_create(phy->dev, 0, &ops, "amxxxx-usb2");
> +
blank line..
> +	if (IS_ERR(generic_phy))
> +		return PTR_ERR(generic_phy);
> +
> +	phy_set_drvdata(generic_phy, phy);
> +
> +	phy->optclk = devm_clk_get(phy->dev, "usbotg_fck");
> +
blank line..
> +	if (IS_ERR(phy->optclk))
> +		dev_err(&pdev->dev, "unable to get usbotg_fck\n");
> +	else
> +		clk_prepare(phy->optclk);
> +
> +
blank line..
> +	usb_add_phy_dev(&phy->phy);

Any reason why you are using the old USB PHY APIs. Because of
MUSB?

Thanks
Kishon
