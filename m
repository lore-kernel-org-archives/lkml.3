Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaAaOgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:36:16 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42227 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbaAaOgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:36:14 -0500
Message-ID: <52EBB4BD.8070808@ti.com>
Date: Fri, 31 Jan 2014 09:35:41 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <ivan.khoronzhuk@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: keystone: switch to use runtime pm
References: <1391174426-13773-1-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1391174426-13773-1-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 January 2014 08:20 AM, Grygorii Strashko wrote:
> The Keystone PM management layer has been implemented using PM bus for
> power management clocks. As result, most of Keystone drivers don't need
> to manage clocks directly. They just need to enable runtime PM and use it
> to handle their PM state and clocks.
> 
> Hence, remove clock management code and switch to use runtime PM.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
Please capture why now it allowes us to remove the clock code.
Commit 8a6720e {PM / clock_ops: fix up clk prepare/unprepare count}

Without that information, the change log will be miss-leading

>  drivers/usb/dwc3/dwc3-keystone.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/dwc3/dwc3-keystone.c b/drivers/usb/dwc3/dwc3-keystone.c
> index 1fad161..a810b41 100644
> --- a/drivers/usb/dwc3/dwc3-keystone.c
> +++ b/drivers/usb/dwc3/dwc3-keystone.c
> @@ -23,6 +23,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/io.h>
>  #include <linux/of_platform.h>
> +#include <linux/pm_runtime.h>
>  
>  /* USBSS register offsets */
>  #define USBSS_REVISION		0x0000
> @@ -116,12 +117,10 @@ static int kdwc3_probe(struct platform_device *pdev)
>  	kdwc3_dma_mask = dma_get_mask(dev);
>  	dev->dma_mask = &kdwc3_dma_mask;
>  
> -	kdwc->clk = devm_clk_get(kdwc->dev, "usb");
> -
> -	error = clk_prepare_enable(kdwc->clk);
> +	pm_runtime_enable(dev);
> +	error = pm_runtime_get_sync(dev);
>  	if (error < 0) {
> -		dev_dbg(kdwc->dev, "unable to enable usb clock, err %d\n",
> -			error);
> +		dev_dbg(dev, "unable to enable usb dev, err %d\n", error);
>  		return error;
>  	}
>  
> @@ -152,7 +151,8 @@ static int kdwc3_probe(struct platform_device *pdev)
>  err_core:
>  	kdwc3_disable_irqs(kdwc);
>  err_irq:
> -	clk_disable_unprepare(kdwc->clk);
> +	pm_runtime_put_sync(dev);
> +	pm_runtime_disable(dev);
>  
>  	return error;
>  }
> @@ -172,7 +172,8 @@ static int kdwc3_remove(struct platform_device *pdev)
>  
>  	kdwc3_disable_irqs(kdwc);
>  	device_for_each_child(&pdev->dev, NULL, kdwc3_remove_core);
> -	clk_disable_unprepare(kdwc->clk);
> +	pm_runtime_put_sync(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);
>  	platform_set_drvdata(pdev, NULL);
>  
>  	return 0;
> 

