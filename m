Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbaCEHHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:07:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47560 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbaCEHHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:07:52 -0500
Message-ID: <5316CD20.3030909@ti.com>
Date: Wed, 5 Mar 2014 12:37:12 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <s.nawrocki@samsung.com>, <tony@atomide.com>,
        <gregkh@linuxfoundation.org>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>
Subject: Re: [PATCH 2/3] phy: omap-usb2: Provide workaround for USB2PHY false
 disconnect
References: <1393841424-27656-1-git-send-email-george.cherian@ti.com> <1393842174-29868-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1393842174-29868-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 03 March 2014 03:52 PM, George Cherian wrote:
> From: Austin Beam <austinbeam@ti.com>
>
> Enable the dra7x errata workaround for false disconnect problem
> with USB2PHY. False disconnects were detected with some of the devices.
> Reduce the sensitivity of the disconnect logic within the USB2PHY subsystem
> to enusre these false disconnects are not registered.
>
> [george.cherian@ti.com]
> While at that, pass proper flags for each SoC's. This is a common driver
> used across OMAP4,OMAP5,DRA7xx and AM437x USB2PHY.
>
> False disconnect workaround is currently applicable for only DRA7x.
>
> Update the Documentation also to add new comaptible.
>
> Signed-off-by: Austin Beam <austinbeam@ti.com>
> Signed-off-by: George Cherian <george.cherian@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>   Documentation/devicetree/bindings/usb/usb-phy.txt |  3 +-
>   drivers/phy/phy-omap-usb2.c                       | 48 +++++++++++++++++++++++
>   include/linux/usb/omap_usb.h                      |  3 ++
>   3 files changed, 53 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
> index b3fa409..03de61a5 100644
> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
> @@ -4,7 +4,8 @@ OMAP USB2 PHY
>
>   Required properties:
>    - compatible: Should be either of
> -	* "ti,omap-usb2" for OMAP4, OMAP5, DRA7
> +	* "ti,omap-usb2" for OMAP4 and OMAP5
> +	* "ti,dra7x-usb2" for DRA7
>   	* "ti,am437x-usb2" for AM437x
>    - reg : Address and length of the register set for the device.
>    - #phy-cells: determine the number of cells that should be given in the
> diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
> index d54f24b..80ba7f0 100644
> --- a/drivers/phy/phy-omap-usb2.c
> +++ b/drivers/phy/phy-omap-usb2.c
> @@ -31,6 +31,9 @@
>   #include <linux/phy/phy.h>
>   #include <linux/of_platform.h>
>
> +#define USB2PHY_DISCON_BYP_LATCH (1 << 31)
> +#define USB2PHY_ANA_CONFIG1 0x4c
> +
>   /**
>    * omap_usb2_set_comparator - links the comparator present in the sytem with
>    *	this phy
> @@ -138,7 +141,30 @@ static int omap_usb_power_on(struct phy *x)
>   	return 0;
>   }
>
> +static int omap_usb_init(struct phy *x)
> +{
> +	struct omap_usb *phy = phy_get_drvdata(x);
> +	u32 val;
> +
> +	if (phy->flags & OMAP_USB2_CALIBRATE_FALSE_DISCONNECT) {
> +		/*
> +		 *
> +		 * Reduce the sensitivity of internal PHY by enabling the
> +		 * DISCON_BYP_LATCH of the USB2PHY_ANA_CONFIG1 register. This
> +		 * resolves issues with certain devices which can otherwise
> +		 * be prone to false disconnects.
> +		 *
> +		 */
> +		val = omap_usb_readl(phy->phy_base, USB2PHY_ANA_CONFIG1);
> +		val |= USB2PHY_DISCON_BYP_LATCH;
> +		omap_usb_writel(phy->phy_base, USB2PHY_ANA_CONFIG1, val);
> +	}
> +
> +	return 0;
> +}
> +
>   static struct phy_ops ops = {
> +	.init		= omap_usb_init,
>   	.power_on	= omap_usb_power_on,
>   	.power_off	= omap_usb_power_off,
>   	.owner		= THIS_MODULE,
> @@ -150,6 +176,11 @@ static const struct usb_phy_data omap_usb2_data = {
>   	.flags = OMAP_USB2_HAS_START_SRP | OMAP_USB2_HAS_SET_VBUS,
>   };
>
> +static const struct usb_phy_data dra7x_usb2_data = {
> +	.label = "dra7x_usb2",
> +	.flags = OMAP_USB2_CALIBRATE_FALSE_DISCONNECT,
> +};
> +
>   static const struct usb_phy_data am437x_usb2_data = {
>   	.label = "am437x_usb2",
>   	.flags =  0,
> @@ -161,6 +192,10 @@ static const struct of_device_id omap_usb2_id_table[] = {
>   		.data = &omap_usb2_data,
>   	},
>   	{
> +		.compatible = "ti,dra7x-usb2",
> +		.data = &dra7x_usb2_data,
> +	},
> +	{
>   		.compatible = "ti,am437x-usb2",
>   		.data = &am437x_usb2_data,
>   	},
> @@ -173,6 +208,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
>   {
>   	struct omap_usb	*phy;
>   	struct phy *generic_phy;
> +	struct resource *res;
>   	struct phy_provider *phy_provider;
>   	struct usb_otg *otg;
>   	struct device_node *node = pdev->dev.of_node;
> @@ -208,6 +244,18 @@ static int omap_usb2_probe(struct platform_device *pdev)
>   	phy->phy.otg		= otg;
>   	phy->phy.type		= USB_PHY_TYPE_USB2;
>
> +	if (phy_data->flags & OMAP_USB2_CALIBRATE_FALSE_DISCONNECT) {
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +		if (!res) {
> +			dev_err(&pdev->dev, "memory resource not available\n");
> +			return -ENODEV;
> +		}

You can remove the error check here and..
> +		phy->phy_base = devm_request_and_ioremap(&pdev->dev, res);

use devm_ioremap_resource instead.

Thanks
Kishon
