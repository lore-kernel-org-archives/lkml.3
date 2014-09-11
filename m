Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbaIKPB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:01:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51519 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbaIKPB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:01:27 -0400
Message-ID: <5411B93F.3030405@ti.com>
Date: Thu, 11 Sep 2014 20:31:19 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 6/6] usb: dwc3: host: convey the PHYs to xhci
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com> <1408620803-10464-7-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1408620803-10464-7-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 21 August 2014 05:03 PM, Heikki Krogerus wrote:
> On some platforms a PHY may need to be handled also in the
> host controller driver. Exynos5420 SoC requires some "PHY
> tuning" based on the USB speed. This patch delivers dwc3's
> PHYs to the xhci platform device when it's created.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
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

I don't think create lookup should be in host init. If it's dt boot, the
binding should be in dt data or for other boot modes the bindig should be done
in the board file. This just seems hacky to me.

Thanks
Kishon
