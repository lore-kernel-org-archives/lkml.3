Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaKFHZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:25:50 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59003 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaKFHZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:25:48 -0500
Message-ID: <545B2273.2010709@ti.com>
Date: Thu, 6 Nov 2014 12:55:39 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "balbi@ti.com" <balbi@ti.com>
CC: Vivek Gautam <gautam.vivek@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <andrew.kim@intel.com>
Subject: Re: [PATCHv4 6/6] usb: dwc3: host: convey the PHYs to xhci
References: <1413556756-5050-1-git-send-email-heikki.krogerus@linux.intel.com> <1413556756-5050-7-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1413556756-5050-7-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Friday 17 October 2014 08:09 PM, Heikki Krogerus wrote:
> On some platforms a PHY may need to be handled also in the
> host controller driver. Exynos5420 SoC requires some "PHY
> tuning" based on the USB speed. This patch delivers dwc3's
> PHYs to the xhci platform device when it's created.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Felipe Balbi <balbi@ti.com>

Already see you acked-by, so I'm queueing this in my linux-phy tree.

Thanks
Kishon
> ---
>  drivers/usb/dwc3/host.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
> index dcb8ca0..12bfd3c 100644
> --- a/drivers/usb/dwc3/host.c
> +++ b/drivers/usb/dwc3/host.c
> @@ -29,8 +29,7 @@ int dwc3_host_init(struct dwc3 *dwc)
>  	xhci = platform_device_alloc("xhci-hcd", PLATFORM_DEVID_AUTO);
>  	if (!xhci) {
>  		dev_err(dwc->dev, "couldn't allocate xHCI device\n");
> -		ret = -ENOMEM;
> -		goto err0;
> +		return -ENOMEM;
>  	}
>  
>  	dma_set_coherent_mask(&xhci->dev, dwc->dev->coherent_dma_mask);
> @@ -60,22 +59,33 @@ int dwc3_host_init(struct dwc3 *dwc)
>  		goto err1;
>  	}
>  
> +	phy_create_lookup(dwc->usb2_generic_phy, "usb2-phy",
> +			  dev_name(&xhci->dev));
> +	phy_create_lookup(dwc->usb3_generic_phy, "usb3-phy",
> +			  dev_name(&xhci->dev));
> +
>  	ret = platform_device_add(xhci);
>  	if (ret) {
>  		dev_err(dwc->dev, "failed to register xHCI device\n");
> -		goto err1;
> +		goto err2;
>  	}
>  
>  	return 0;
> -
> +err2:
> +	phy_remove_lookup(dwc->usb2_generic_phy, "usb2-phy",
> +			  dev_name(&xhci->dev));
> +	phy_remove_lookup(dwc->usb3_generic_phy, "usb3-phy",
> +			  dev_name(&xhci->dev));
>  err1:
>  	platform_device_put(xhci);
> -
> -err0:
>  	return ret;
>  }
>  
>  void dwc3_host_exit(struct dwc3 *dwc)
>  {
> +	phy_remove_lookup(dwc->usb2_generic_phy, "usb2-phy",
> +			  dev_name(&dwc->xhci->dev));
> +	phy_remove_lookup(dwc->usb3_generic_phy, "usb3-phy",
> +			  dev_name(&dwc->xhci->dev));
>  	platform_device_unregister(dwc->xhci);
>  }
> 
