Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3ILKgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:36:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41284 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab3ILKgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:36:52 -0400
Message-ID: <52319912.8030203@ti.com>
Date: Thu, 12 Sep 2013 13:36:02 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] usb: dwc3: get "usb_phy" only if the platform indicates
 the presence of PHY
References: <1378136591-7463-1-git-send-email-kishon@ti.com> <1378136591-7463-2-git-send-email-kishon@ti.com>
In-Reply-To: <1378136591-7463-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 09/02/2013 06:43 PM, Kishon Vijay Abraham I wrote:
> There can be systems which does not have a external usb_phy, so get
> usb_phy only if usb-phy property is added in the case of dt boot or if
> platform_data indicates the presence of PHY. Also remove checking if
> return value is -ENXIO since it's now changed to always enable usb_phy layer.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/dwc3/Kconfig         |    1 +
>  drivers/usb/dwc3/core.c          |   60 +++++++++++++++++---------------------
>  drivers/usb/dwc3/platform_data.h |    1 +
>  3 files changed, 28 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> index f969ea2..cfc16dd 100644
> --- a/drivers/usb/dwc3/Kconfig
> +++ b/drivers/usb/dwc3/Kconfig
> @@ -2,6 +2,7 @@ config USB_DWC3
>  	tristate "DesignWare USB3 DRD Core Support"
>  	depends on (USB || USB_GADGET) && GENERIC_HARDIRQS && HAS_DMA
>  	depends on EXTCON
> +	select USB_PHY
>  	select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
>  	help
>  	  Say Y or M here if your system has a Dual Role SuperSpeed
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 474162e..428c29e 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -387,16 +387,38 @@ static int dwc3_probe(struct platform_device *pdev)
>  	if (node) {
>  		dwc->maximum_speed = of_usb_get_maximum_speed(node);
>  
> -		dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
> -		dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
> +		if (of_property_read_bool(node, "usb-phy")) {
> +			dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev,
> +				"usb-phy", 0);
> +			if (IS_ERR(dwc->usb2_phy))
> +				return PTR_ERR(dwc->usb2_phy);
> +			dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev,
> +				"usb-phy", 1);
> +			if (IS_ERR(dwc->usb3_phy))
> +				return PTR_ERR(dwc->usb3_phy);

Some DWC3 instances use only usb2_phy. e.g. on DRA7 the 2nd dwc3 instance doesn't use usb3_phy.
This needs to be a valid case and driver shouldn't error out.

> +		} else {
> +			dwc->usb2_phy = NULL;
> +			dwc->usb3_phy = NULL;
> +		}
>  
>  		dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
>  		dwc->dr_mode = of_usb_get_dr_mode(node);
>  	} else if (pdata) {
>  		dwc->maximum_speed = pdata->maximum_speed;
>  
> -		dwc->usb2_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> -		dwc->usb3_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
> +		if (pdata->has_phy) {
> +			dwc->usb2_phy = devm_usb_get_phy(dev,
> +				USB_PHY_TYPE_USB2);
> +			if (IS_ERR(dwc->usb2_phy))
> +				return PTR_ERR(dwc->usb2_phy);
> +			dwc->usb3_phy = devm_usb_get_phy(dev,
> +				USB_PHY_TYPE_USB3);
> +			if (IS_ERR(dwc->usb3_phy))
> +				return PTR_ERR(dwc->usb3_phy);

same here?

> +		} else {
> +			dwc->usb2_phy = NULL;
> +			dwc->usb3_phy = NULL;
> +		}
>  
>  		dwc->needs_fifo_resize = pdata->tx_fifo_resize;
>  		dwc->dr_mode = pdata->dr_mode;
> @@ -409,36 +431,6 @@ static int dwc3_probe(struct platform_device *pdev)
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
> index 7db34f0..5a5e068 100644
> --- a/drivers/usb/dwc3/platform_data.h
> +++ b/drivers/usb/dwc3/platform_data.h
> @@ -24,4 +24,5 @@ struct dwc3_platform_data {
>  	enum usb_device_speed maximum_speed;
>  	enum usb_dr_mode dr_mode;
>  	bool tx_fifo_resize;
> +	bool has_phy;
>  };
> 

cheers,
-roger
