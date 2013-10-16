Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432Ab3JPNET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:04:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42755 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934103Ab3JPNER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:04:17 -0400
Message-ID: <525E8E93.9010503@ti.com>
Date: Wed, 16 Oct 2013 16:03:15 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <grant.likely@linaro.org>,
        <s.nawrocki@samsung.com>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] usb: dwc3: get "usb_phy" only if the platform
 indicates the presence of PHY's
References: <1381866857-3861-1-git-send-email-kishon@ti.com> <1381866857-3861-2-git-send-email-kishon@ti.com>
In-Reply-To: <1381866857-3861-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 10/15/2013 10:54 PM, Kishon Vijay Abraham I wrote:
> There can be systems which does not have a external usb_phy, so get
> usb_phy only if dt data indicates the presence of PHY in the case of dt boot or
> if platform_data indicates the presence of PHY. Also remove checking if
> return value is -ENXIO since it's now changed to always enable usb_phy layer.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
> In usb_get_phy_by_phandle, index 0 always refers to usb2 phy and index 1 always
> refers to usb3 phy. Since we've lived so long with this, this patch will make
> an assumption that if only one entry is populated in *usb-phy* property, it will
> be usb2 phy and the next entry will be usb3 phy.
> 
>  drivers/usb/dwc3/Kconfig         |    1 +
>  drivers/usb/dwc3/core.c          |   72 ++++++++++++++++++++------------------
>  drivers/usb/dwc3/platform_data.h |    2 ++
>  3 files changed, 41 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> index 70fc430..8e385b4 100644
> --- a/drivers/usb/dwc3/Kconfig
> +++ b/drivers/usb/dwc3/Kconfig
> @@ -1,6 +1,7 @@
>  config USB_DWC3
>  	tristate "DesignWare USB3 DRD Core Support"
>  	depends on (USB || USB_GADGET) && HAS_DMA
> +	select USB_PHY
>  	select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
>  	help
>  	  Say Y or M here if your system has a Dual Role SuperSpeed
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 474162e..cb91d70 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -354,6 +354,7 @@ static int dwc3_probe(struct platform_device *pdev)
>  	struct device_node	*node = dev->of_node;
>  	struct resource		*res;
>  	struct dwc3		*dwc;
> +	int			count;
>  
>  	int			ret = -ENOMEM;
>  
> @@ -387,16 +388,49 @@ static int dwc3_probe(struct platform_device *pdev)
>  	if (node) {
>  		dwc->maximum_speed = of_usb_get_maximum_speed(node);
>  
> -		dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
> -		dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
> +		count = of_count_phandle_with_args(node, "usb-phy", NULL);
> +		switch (count) {
> +		case 2:
> +			dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev,
> +				"usb-phy", 1);
> +			if (IS_ERR(dwc->usb3_phy)) {
> +				dev_err(dev, "usb3 phy not found\n");
> +				return PTR_ERR(dwc->usb3_phy);
> +			}
> +		case 1:
> +			dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev,
> +				"usb-phy", 0);
> +			if (IS_ERR(dwc->usb2_phy)) {
> +				dev_err(dev, "usb2 phy not found\n");
> +				return PTR_ERR(dwc->usb2_phy);
> +			}
> +			break;

In the Exynos case, there is only 1 phy and it is the USB3 phy. This code
will wrongly treat it as usb2_phy.


> +		default:
> +			dev_err(dev, "usb phy nodes not configured\n");
> +		}
>  
>  		dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
>  		dwc->dr_mode = of_usb_get_dr_mode(node);
>  	} else if (pdata) {
>  		dwc->maximum_speed = pdata->maximum_speed;
>  
> -		dwc->usb2_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> -		dwc->usb3_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
> +		if (pdata->usb2_phy) {
> +			dwc->usb2_phy = devm_usb_get_phy(dev,
> +				USB_PHY_TYPE_USB2);
> +			if (IS_ERR(dwc->usb2_phy)) {
> +				dev_err(dev, "usb2 phy not found\n");
> +				return PTR_ERR(dwc->usb2_phy);
> +			}
> +		}
> +
> +		if (pdata->usb3_phy) {
> +			dwc->usb3_phy = devm_usb_get_phy(dev,
> +				USB_PHY_TYPE_USB3);
> +			if (IS_ERR(dwc->usb3_phy)) {
> +				dev_err(dev, "usb3 phy not found\n");
> +				return PTR_ERR(dwc->usb3_phy);
> +			}
> +		}

This part looks fine to me.
>  
>  		dwc->needs_fifo_resize = pdata->tx_fifo_resize;
>  		dwc->dr_mode = pdata->dr_mode;
> @@ -409,36 +443,6 @@ static int dwc3_probe(struct platform_device *pdev)
>  	if (dwc->maximum_speed == USB_SPEED_UNKNOWN)
>  		dwc->maximum_speed = USB_SPEED_SUPER;
>  
> -	if (IS_ERR(dwc->usb2_phy)) {
> -		ret = PTR_ERR(dwc->usb2_phy);
> -
> -		/*
> -		 * if -ENXIO is returned, it means PHY layer wasn't
> -		 * enabled, so it makes no sense to return -EPROBE_DEFER
> -		 * in that case, since no PHY driver will ever probe.
> -		 */
> -		if (ret == -ENXIO)
> -			return ret;
> -
> -		dev_err(dev, "no usb2 phy configured\n");
> -		return -EPROBE_DEFER;
> -	}
> -
> -	if (IS_ERR(dwc->usb3_phy)) {
> -		ret = PTR_ERR(dwc->usb3_phy);
> -
> -		/*
> -		 * if -ENXIO is returned, it means PHY layer wasn't
> -		 * enabled, so it makes no sense to return -EPROBE_DEFER
> -		 * in that case, since no PHY driver will ever probe.
> -		 */
> -		if (ret == -ENXIO)
> -			return ret;
> -
> -		dev_err(dev, "no usb3 phy configured\n");
> -		return -EPROBE_DEFER;
> -	}
> -
>  	dwc->xhci_resources[0].start = res->start;
>  	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
>  					DWC3_XHCI_REGS_END;
> diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
> index 7db34f0..49ffa6d 100644
> --- a/drivers/usb/dwc3/platform_data.h
> +++ b/drivers/usb/dwc3/platform_data.h
> @@ -24,4 +24,6 @@ struct dwc3_platform_data {
>  	enum usb_device_speed maximum_speed;
>  	enum usb_dr_mode dr_mode;
>  	bool tx_fifo_resize;
> +	bool usb2_phy;
> +	bool usb3_phy;
>  };
> 


cheers,
-roger
