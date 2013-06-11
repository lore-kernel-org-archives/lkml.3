Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab3FKIlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:41:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52414 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab3FKIkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:40:40 -0400
Message-ID: <51B6E282.9030400@ti.com>
Date: Tue, 11 Jun 2013 14:10:34 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ravi Babu <ravibabu@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [PATCH v2 2/7] usb: phy: dsps: adding usbphy driver for am33xx
 platform
References: <1370935072-21056-1-git-send-email-ravibabu@ti.com> <1370935072-21056-3-git-send-email-ravibabu@ti.com>
In-Reply-To: <1370935072-21056-3-git-send-email-ravibabu@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 11 June 2013 12:47 PM, Ravi Babu wrote:
> Adds usb-phy driver support for am33xx platform, the host/device
> peripheral controller shall get this phy object to control the phy
> operations.
>
> Signed-off-by: Ravi Babu <ravibabu@ti.com>
> ---
>   drivers/usb/phy/Kconfig        |    9 ++
>   drivers/usb/phy/Makefile       |    1 +
>   drivers/usb/phy/phy-dsps-usb.c |  236 ++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 246 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/usb/phy/phy-dsps-usb.c
>
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index 372db48..b55c265 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -85,6 +85,15 @@ config OMAP_USB3
>   	  This driver interacts with the "OMAP Control USB Driver" to power
>   	  on/off the PHY.
>
> +config DSPS_USB2PHY
> +	tristate "DSPS USB2 PHY Driver"
> +	depends on SOC_AM33XX
> +	help
> +	  Enable this to support the transceiver that is part of SOC. This
> +	  phy supports all LS/FS/HS speed and also supports OTG functionality.
> +	  The USB OTG controller communicates with this phy through stand UTMI
> +	  interface.
> +
>   config SAMSUNG_USBPHY
>   	tristate "Samsung USB PHY Driver"
>   	help
> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index 33863c0..0b16fb3 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_NOP_USB_XCEIV)		+= phy-nop.o
>   obj-$(CONFIG_OMAP_CONTROL_USB)		+= phy-omap-control.o
>   obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
>   obj-$(CONFIG_OMAP_USB3)			+= phy-omap-usb3.o
> +obj-$(CONFIG_DSPS_USB2PHY)		+= phy-dsps-usb.o
>   obj-$(CONFIG_SAMSUNG_USBPHY)		+= phy-samsung-usb.o
>   obj-$(CONFIG_SAMSUNG_USB2PHY)		+= phy-samsung-usb2.o
>   obj-$(CONFIG_SAMSUNG_USB3PHY)		+= phy-samsung-usb3.o
> diff --git a/drivers/usb/phy/phy-dsps-usb.c b/drivers/usb/phy/phy-dsps-usb.c
> new file mode 100644
> index 0000000..aae97b3
> --- /dev/null
> +++ b/drivers/usb/phy/phy-dsps-usb.c
> @@ -0,0 +1,236 @@
> +/*
> + * phy-dsps-usb.c - TI gs70 based usb phy driver used by usb controller
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
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
> +#include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/io.h>
> +#include <linux/usb/omap_usb.h>
> +#include <linux/usb/phy_companion.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/delay.h>
> +#include <linux/usb/phy.h>
> +
> +struct dsps_phy {
> +	struct usb_phy phy;
> +	struct device *dev;
> +	struct platform_device *pdev;
> +	void __iomem *phy_ctrl;
> +	void __iomem *phy_wkup;
> +	u8	is_suspended:1;
> +	int	id;
> +};
> +
> +#define DSPS_USBPHY_CM_PWRDN		(1 << 0)
> +#define DSPS_USBPHY_OTG_PWRDN		(1 << 1)
> +#define DSPS_USBPHY_OTGVDET_EN		(1 << 19)
> +#define DSPS_USBPHY_OTGSESSEND_EN	(1 << 20)
> +#define DSPS_USB0_WKUP_CTRL_ENABLE	(1 << 0)
> +#define DSPS_USB1_WKUP_CTRL_ENABLE	(1 << 8)
> +#define phy_to_dspsphy(x)	container_of((x), struct dsps_phy, phy)
> +
> +static void dsps_usbphy_power(struct usb_phy *phy, bool is_on)
> +{
> +	struct dsps_phy *dsps_phy = phy_to_dspsphy(phy);
> +	u32 val;
> +
> +	val = readl(dsps_phy->phy_ctrl);
> +
> +	if (is_on) {
> +		val &= ~(DSPS_USBPHY_CM_PWRDN | DSPS_USBPHY_OTG_PWRDN);
> +		val |= DSPS_USBPHY_OTGVDET_EN |
> +			DSPS_USBPHY_OTGSESSEND_EN;
> +	} else
> +		val |= DSPS_USBPHY_CM_PWRDN | DSPS_USBPHY_OTG_PWRDN;
> +
> +	writel(val, dsps_phy->phy_ctrl);
> +}
> +
> +static void dsps_usbphy_wakeup(struct usb_phy *phy, bool enable)
> +{
Where is this function called from?
> +	struct dsps_phy *dsps_phy = phy_to_dspsphy(phy);
> +	int id = dsps_phy->id;
> +	u32 val, wkup_flag;
> +
> +	val = readl(dsps_phy->phy_wkup);
> +	wkup_flag = id ? DSPS_USB1_WKUP_CTRL_ENABLE :
> +			DSPS_USB0_WKUP_CTRL_ENABLE;
> +
> +	if (enable)
> +		val |= wkup_flag;
> +	else
> +		val &= ~wkup_flag;
> +
> +	writel(val, dsps_phy->phy_wkup);
> +}
> +
> +static int dsps_usbphy_suspend(struct usb_phy *x, int suspend)
> +{
> +	struct dsps_phy *dsps_phy = phy_to_dspsphy(x);
> +
> +	if (suspend) {
> +		if (!pm_runtime_suspended(&dsps_phy->pdev->dev))
> +			pm_runtime_put(&dsps_phy->pdev->dev);
> +	} else if (!suspend)
> +		pm_runtime_get(&dsps_phy->pdev->dev);
> +
> +	return 0;
> +}
> +
> +static int dsps_usbphy_init(struct usb_phy *phy)
> +{
> +	/* enable the phy */
> +	dsps_usbphy_power(phy, 1);
> +
> +	return 0;
> +}
> +
> +static void dsps_usbphy_shutdown(struct usb_phy *phy)
> +{
> +	/* disable the phy */
> +	dsps_usbphy_power(phy, 0);
> +}
> +
> +static int dsps_usbphy_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct dsps_phy	*phy;
> +	struct usb_otg *otg;
> +	struct resource *res;
> +
> +	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
> +	if (!phy) {
> +		dev_err(&pdev->dev, "unable to allocate memory for USB2 PHY\n");
> +		return -ENOMEM;
> +	}
> +
> +	otg = devm_kzalloc(&pdev->dev, sizeof(*otg), GFP_KERNEL);
> +	if (!otg) {
> +		dev_err(&pdev->dev, "unable to allocate memory for USB OTG\n");
> +		return -ENOMEM;
> +	}
> +
> +	phy->dev		= &pdev->dev;
> +	phy->pdev		= pdev;
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy_ctrl");
> +	phy->phy_ctrl = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(phy->phy_ctrl))
> +		return PTR_ERR(phy->phy_ctrl);
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "phy_wkup");
> +	phy->phy_wkup = ioremap(res->start, resource_size(res));

devm_ioremap?
> +	if (IS_ERR(phy->phy_wkup))
> +		return PTR_ERR(phy->phy_wkup);
> +
> +	if (np)
> +		of_property_read_u32(np, "id", &phy->id);

Is this property documented somewhere?
> +
> +	phy->phy.dev		= phy->dev;
> +	phy->phy.label		= "dsps-usbphy";
> +	phy->phy.otg		= otg;
> +	phy->phy.type		= USB_PHY_TYPE_USB2;
> +	phy->phy.init		= dsps_usbphy_init;
> +	phy->phy.shutdown	= dsps_usbphy_shutdown;
> +	phy->phy.set_suspend	= dsps_usbphy_suspend;
> +	otg->phy		= &phy->phy;
> +
> +	usb_add_phy_dev(&phy->phy);
> +
> +	platform_set_drvdata(pdev, phy);
> +
> +	pm_runtime_enable(phy->dev);
> +
> +	return 0;
> +}
> +
> +static int dsps_usbphy_remove(struct platform_device *pdev)
> +{
> +	struct dsps_phy	*phy = platform_get_drvdata(pdev);
> +
> +	dsps_usbphy_power(&phy->phy, 0);
> +	iounmap(phy->phy_wkup);
> +	usb_remove_phy(&phy->phy);
> +
> +	if (!pm_runtime_suspended(&pdev->dev))
> +		pm_runtime_put(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_RUNTIME
> +
> +static int dsps_usbphy_runtime_suspend(struct device *dev)
> +{
> +	struct dsps_phy	*dsps_phy = dev_get_drvdata(dev);
> +
> +	/* suspend usb-phy */
> +	dsps_usbphy_power(&dsps_phy->phy, 0);
> +	dsps_phy->is_suspended = 1;

Are you using this "is_suspended" anywhere else?

Thanks
Kishon
