Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbaAUNxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:53:43 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41332 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaAUNxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:53:37 -0500
Message-ID: <52DE7BC5.90001@ti.com>
Date: Tue, 21 Jan 2014 15:53:09 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <george.cherian@ti.com>,
        <heikki.krogerus@linux.intel.com>, <balbi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: dwc3: core: continue probing if usb phy library
 returns -ENODEV/-ENXIO
References: <1385373690-12170-1-git-send-email-kishon@ti.com> <1390299099-14764-1-git-send-email-kishon@ti.com>
In-Reply-To: <1390299099-14764-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 12:11 PM, Kishon Vijay Abraham I wrote:
> Since PHYs for dwc3 is optional (not all SoCs that have DWC3 use PHYs),
> do not return from probe if the USB PHY library returns -ENODEV as that
> indicates the platform does not have PHY.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Reviewed-by: Roger Quadros <rogerq@ti.com>

cheers,
-roger

> ---
>  drivers/usb/dwc3/core.c |   34 ++++++++++++++--------------------
>  1 file changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index a49217a..e009d4e 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -411,32 +411,26 @@ static int dwc3_probe(struct platform_device *pdev)
>  
>  	if (IS_ERR(dwc->usb2_phy)) {
>  		ret = PTR_ERR(dwc->usb2_phy);
> -
> -		/*
> -		 * if -ENXIO is returned, it means PHY layer wasn't
> -		 * enabled, so it makes no sense to return -EPROBE_DEFER
> -		 * in that case, since no PHY driver will ever probe.
> -		 */
> -		if (ret == -ENXIO)
> +		if (ret == -ENXIO || ret == -ENODEV) {
> +			dwc->usb2_phy = NULL;
> +		} else if (ret == -EPROBE_DEFER) {
>  			return ret;
> -
> -		dev_err(dev, "no usb2 phy configured\n");
> -		return -EPROBE_DEFER;
> +		} else {
> +			dev_err(dev, "no usb2 phy configured\n");
> +			return ret;
> +		}
>  	}
>  
>  	if (IS_ERR(dwc->usb3_phy)) {
>  		ret = PTR_ERR(dwc->usb3_phy);
> -
> -		/*
> -		 * if -ENXIO is returned, it means PHY layer wasn't
> -		 * enabled, so it makes no sense to return -EPROBE_DEFER
> -		 * in that case, since no PHY driver will ever probe.
> -		 */
> -		if (ret == -ENXIO)
> +		if (ret == -ENXIO || ret == -ENODEV) {
> +			dwc->usb3_phy = NULL;
> +		} else if (ret == -EPROBE_DEFER) {
>  			return ret;
> -
> -		dev_err(dev, "no usb3 phy configured\n");
> -		return -EPROBE_DEFER;
> +		} else {
> +			dev_err(dev, "no usb3 phy configured\n");
> +			return ret;
> +		}
>  	}
>  
>  	dwc->xhci_resources[0].start = res->start;
> 

