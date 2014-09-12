Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaILQ3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:29:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19604 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaILQ3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:29:03 -0400
X-AuditID: cbfee61b-f79f86d00000144c-78-54131f4c241f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dinguyen@opensource.altera.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, balbi@ti.com,
        dinh.linux@gmail.com, swarren@wwwdotorg.org, matthijs@stdin.nl,
        r.baldyga@samsung.com, jg1.han@samsung.com, sachin.kamat@linaro.org,
        ben-linux@fluff.org, dianders@chromium.org, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 08/12] usb: dwc2: gadget: Do not fail probe if there
 isn't a clock node
Date: Fri, 12 Sep 2014 18:28:58 +0200
Message-id: <3825627.ZuOPzBNWiB@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1409070003-21195-9-git-send-email-dinguyen@opensource.altera.com>
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com>
 <1409070003-21195-9-git-send-email-dinguyen@opensource.altera.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t9jAV0feeEQg/kr9C0O3q+3mLTuAJPF
	2WUH2SxWfVrDbLHypLZF8+L1bBaXF15itdg2/SeQtWsOm8WiZa3MFgtfX2Ox2D5lOpPFg8M7
	2S1O/ulltHh1sI3Fgd9jdsNFFo+/q14we+ycdZfd4861PWwe++euYffovzaJ3ePvrP0sHn1b
	VjF6fPnxj8Vjy/7PjB7Hb2xn8vi8Sc5j49zQAN4oLpuU1JzMstQifbsEroxd7YvYC3apVLy/
	vZq5gfGAbBcjJ4eEgInEpnldLBC2mMSFe+vZuhi5OIQEFjFKrJ84jxHCaWGSuHnwCiNIFZuA
	lcTE9lVgtoiAkkTvqpcsIEXMAmeZJFbsWssMkhAWiJeY//kFE4jNIqAqcbvxBdgKXgFNiSet
	q8FsUQFPiR3bV7KB2JwC/hITzuxkhtg2mVHi4qLvUA2CEj8m3wOzmQXkJfbtn8oKYetI7G+d
	xjaBUWAWkrJZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Cp9J72Bc1WBx
	iFGAg1GJh7eSRTBEiDWxrLgy9xCjBAezkgivoqhwiBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHe
	g63WgUIC6YklqdmpqQWpRTBZJg5OqQZGjRN+fDK2CW/PT1b4ZyltwfXihsDy6TzXSg9VPNty
	6Tjfa71upZTrTOGLHMtmNq+5/8lC64FiTVbIlZ8cYp9uSNeeWtGZyue6V/u277kNv0USJzhH
	bl8Sef2PnF39xQUpVbPn6iTP1RF5fVB3vsFCey/2kpOsJ9Y/aH+h1P14GZuY8Sa9zE3KSizF
	GYmGWsxFxYkAjVT7wr4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added linux-kernel ML to cc: ]

Hi,

On Tuesday, August 26, 2014 11:19:59 AM dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Since the dwc2 hcd driver is currently not looking for a clock node during
> init, we should not completely fail if there isn't a clock provided.
> Add a check for a valid clock before calling clock functions.

This doesn't look correct at least for the case when we are really missing
the clock and USB_DWC2_PERIPHERAL=y (moreover it just looks wrong to access
gadget functionalities when clock is disabled). It seems that it would be
better to just disable gadget functionality on dwc2_gadget_init() failure
in hcd and not call gadget functions later from hcd if gadget functionality
is disabled.

> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> ---
>  drivers/usb/dwc2/gadget.c | 36 ++++++++++++++++++++++--------------
>  1 file changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> index a1c93bf..aab1b45 100644
> --- a/drivers/usb/dwc2/gadget.c
> +++ b/drivers/usb/dwc2/gadget.c
> @@ -2852,7 +2852,8 @@ static int s3c_hsotg_udc_start(struct usb_gadget *gadget,
>  	hsotg->gadget.dev.of_node = hsotg->dev->of_node;
>  	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
>  
> -	clk_enable(hsotg->clk);
> +	if (!IS_ERR(hsotg->clk))
> +		clk_enable(hsotg->clk);
>  
>  	ret = regulator_bulk_enable(ARRAY_SIZE(hsotg->supplies),
>  				    hsotg->supplies);
> @@ -2903,7 +2904,8 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
>  	regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies),
>  				hsotg->supplies);
>  
> -	clk_disable(hsotg->clk);
> +	if (!IS_ERR(hsotg->clk))
> +		clk_disable(hsotg->clk);
>  
>  	return 0;
>  }
> @@ -2936,10 +2938,12 @@ static int s3c_hsotg_pullup(struct usb_gadget *gadget, int is_on)
>  	spin_lock_irqsave(&hsotg->lock, flags);
>  	if (is_on) {
>  		s3c_hsotg_phy_enable(hsotg);
> -		clk_enable(hsotg->clk);
> +		if (!IS_ERR(hsotg->clk))
> +			clk_enable(hsotg->clk);
>  		s3c_hsotg_core_init(hsotg);
>  	} else {
> -		clk_disable(hsotg->clk);
> +		if (!IS_ERR(hsotg->clk))
> +			clk_disable(hsotg->clk);
>  		s3c_hsotg_phy_disable(hsotg);
>  	}
>  
> @@ -3410,16 +3414,15 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
>  	}
>  
>  	hsotg->clk = devm_clk_get(dev, "otg");
> -	if (IS_ERR(hsotg->clk)) {
> -		dev_err(dev, "cannot get otg clock\n");
> -		return PTR_ERR(hsotg->clk);
> -	}
> +	if (IS_ERR(hsotg->clk))
> +		dev_warn(dev, "cannot get otg clock\n");
>  
>  	hsotg->gadget.max_speed = USB_SPEED_HIGH;
>  	hsotg->gadget.ops = &s3c_hsotg_gadget_ops;
>  	hsotg->gadget.name = dev_name(dev);
>  
> -	clk_prepare_enable(hsotg->clk);
> +	if (!IS_ERR(hsotg->clk))
> +		clk_prepare_enable(hsotg->clk);
>  
>  	/* regulators */
>  
> @@ -3452,7 +3455,8 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
>  			dev_name(dev), hsotg);
>  	if (ret < 0) {
>  		s3c_hsotg_phy_disable(hsotg);
> -		clk_disable_unprepare(hsotg->clk);
> +		if (!IS_ERR(hsotg->clk))
> +			clk_disable_unprepare(hsotg->clk);
>  		regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies),
>  				       hsotg->supplies);
>  		dev_err(dev, "cannot claim IRQ\n");
> @@ -3521,7 +3525,8 @@ err_ep_mem:
>  err_supplies:
>  	s3c_hsotg_phy_disable(hsotg);
>  err_clk:
> -	clk_disable_unprepare(hsotg->clk);
> +	if (!IS_ERR(hsotg->clk))
> +		clk_disable_unprepare(hsotg->clk);
>  
>  	return ret;
>  }
> @@ -3541,7 +3546,8 @@ int s3c_hsotg_remove(struct dwc2_hsotg *hsotg)
>  		usb_gadget_unregister_driver(hsotg->driver);
>  	}
>  
> -	clk_disable_unprepare(hsotg->clk);
> +	if (!IS_ERR(hsotg->clk))
> +		clk_disable_unprepare(hsotg->clk);
>  
>  	return 0;
>  }
> @@ -3568,7 +3574,8 @@ static int s3c_hsotg_suspend(struct dwc2_hsotg *hsotg)
>  
>  		ret = regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies),
>  					     hsotg->supplies);
> -		clk_disable(hsotg->clk);
> +		if (!IS_ERR(hsotg->clk))
> +			clk_disable(hsotg->clk);
>  	}
>  
>  	return ret;
> @@ -3583,7 +3590,8 @@ static int s3c_hsotg_resume(struct dwc2_hsotg *hsotg)
>  		dev_info(hsotg->dev, "resuming usb gadget %s\n",
>  			 hsotg->driver->driver.name);
>  
> -		clk_enable(hsotg->clk);
> +		if (!IS_ERR(hsotg->clk))
> +			clk_enable(hsotg->clk);
>  		ret = regulator_bulk_enable(ARRAY_SIZE(hsotg->supplies),
>  					   hsotg->supplies);
>  	}

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

