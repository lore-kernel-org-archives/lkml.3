Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbaLHUzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:55:37 -0500
Received: from smtprelay2.synopsys.com ([198.182.60.111]:41757 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaLHUzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:55:35 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Yunzhi Li <lyz@rock-chips.com>, "heiko@sntech.de" <heiko@sntech.de>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "romain.perier@gmail.com" <romain.perier@gmail.com>
CC: "olof@lixom.net" <olof@lixom.net>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "zyw@rock-chips.com" <zyw@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 3/5] usb: dwc2: add generic PHY framework support for
 dwc2 usb controler platform driver.
Thread-Topic: [PATCH v3 3/5] usb: dwc2: add generic PHY framework support
 for dwc2 usb controler platform driver.
Thread-Index: AQHQEsvvfvHuMjfBaU+xWBrKe0kq5pyGLF5Q
Date: Mon, 8 Dec 2014 20:55:29 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304845002B7@US01WEMBX2.internal.synopsys.com>
References: <1418031988-2700-1-git-send-email-lyz@rock-chips.com>
 <1418031988-2700-4-git-send-email-lyz@rock-chips.com>
In-Reply-To: <1418031988-2700-4-git-send-email-lyz@rock-chips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Yunzhi Li [mailto:lyz@rock-chips.com]
> Sent: Monday, December 08, 2014 1:46 AM
> 
> Get PHY parameters from devicetree and power off usb PHY during
> system suspend.
> 
> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
> 
> ---
> 
> Changes in v3:
> - Fix coding style: both branches of the if() which only one
>   branch of the conditional statement is a single statement should
>   have braces.
> - No need to test dwc2->phy for NULL before calling generic phy
>   APIs.
> 
>  drivers/usb/dwc2/gadget.c   | 33 ++++++++++++---------------------
>  drivers/usb/dwc2/platform.c | 36 ++++++++++++++++++++++++++++++++++--
>  2 files changed, 46 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> index 200168e..2601c61 100644
> --- a/drivers/usb/dwc2/gadget.c
> +++ b/drivers/usb/dwc2/gadget.c
> @@ -3410,8 +3410,6 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
>  {
>  	struct device *dev = hsotg->dev;
>  	struct s3c_hsotg_plat *plat = dev->platform_data;
> -	struct phy *phy;
> -	struct usb_phy *uphy;
>  	struct s3c_hsotg_ep *eps;
>  	int epnum;
>  	int ret;
> @@ -3421,30 +3419,23 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
>  	hsotg->phyif = GUSBCFG_PHYIF16;
> 
>  	/*
> -	 * Attempt to find a generic PHY, then look for an old style
> -	 * USB PHY, finally fall back to pdata
> +	 * If platform probe couldn't find a generic PHY or an old style
> +	 * USB PHY, fall back to pdata
>  	 */
> -	phy = devm_phy_get(dev, "usb2-phy");
> -	if (IS_ERR(phy)) {
> -		uphy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> -		if (IS_ERR(uphy)) {
> -			/* Fallback for pdata */
> -			plat = dev_get_platdata(dev);
> -			if (!plat) {
> -				dev_err(dev,
> -				"no platform data or transceiver defined\n");
> -				return -EPROBE_DEFER;
> -			}
> -			hsotg->plat = plat;
> -		} else
> -			hsotg->uphy = uphy;
> -	} else {
> -		hsotg->phy = phy;
> +	if (IS_ERR_OR_NULL(hsotg->phy) && IS_ERR_OR_NULL(hsotg->uphy)) {
> +		plat = dev_get_platdata(dev);
> +		if (!plat) {
> +			dev_err(dev,
> +			"no platform data or transceiver defined\n");
> +			return -EPROBE_DEFER;
> +		}
> +		hsotg->plat = plat;
> +	} else if (hsotg->phy) {
>  		/*
>  		 * If using the generic PHY framework, check if the PHY bus
>  		 * width is 8-bit and set the phyif appropriately.
>  		 */
> -		if (phy_get_bus_width(phy) == 8)
> +		if (phy_get_bus_width(hsotg->phy) == 8)
>  			hsotg->phyif = GUSBCFG_PHYIF8;
>  	}
> 
> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
> index 6a795aa..ae095f0 100644
> --- a/drivers/usb/dwc2/platform.c
> +++ b/drivers/usb/dwc2/platform.c
> @@ -155,6 +155,8 @@ static int dwc2_driver_probe(struct platform_device *dev)
>  	struct dwc2_core_params defparams;
>  	struct dwc2_hsotg *hsotg;
>  	struct resource *res;
> +	struct phy *phy;
> +	struct usb_phy *uphy;
>  	int retval;
>  	int irq;
> 
> @@ -212,6 +214,24 @@ static int dwc2_driver_probe(struct platform_device *dev)
> 
>  	hsotg->dr_mode = of_usb_get_dr_mode(dev->dev.of_node);
> 
> +	/*
> +	 * Attempt to find a generic PHY, then look for an old style
> +	 * USB PHY
> +	 */
> +	phy = devm_phy_get(&dev->dev, "usb2-phy");
> +	if (IS_ERR(phy)) {
> +		hsotg->phy = NULL;
> +		uphy = devm_usb_get_phy(&dev->dev, USB_PHY_TYPE_USB2);
> +		if (IS_ERR(uphy))
> +			hsotg->uphy = NULL;
> +		else
> +			hsotg->uphy = uphy;
> +	} else {
> +		hsotg->phy = phy;
> +		phy_power_on(hsotg->phy);
> +		phy_init(hsotg->phy);
> +	}
> +
>  	spin_lock_init(&hsotg->lock);
>  	mutex_init(&hsotg->init_mutex);
>  	retval = dwc2_gadget_init(hsotg, irq);
> @@ -231,8 +251,15 @@ static int __maybe_unused dwc2_suspend(struct device *dev)
>  	struct dwc2_hsotg *dwc2 = dev_get_drvdata(dev);
>  	int ret = 0;
> 
> -	if (dwc2_is_device_mode(dwc2))
> +	if (dwc2_is_device_mode(dwc2)) {
>  		ret = s3c_hsotg_suspend(dwc2);
> +	} else {
> +		if (dwc2->lx_state == DWC2_L0)
> +			return 0;
> +		phy_exit(dwc2->phy);
> +		phy_power_off(dwc2->phy);
> +
> +	}
>  	return ret;
>  }
> 
> @@ -241,8 +268,13 @@ static int __maybe_unused dwc2_resume(struct device *dev)
>  	struct dwc2_hsotg *dwc2 = dev_get_drvdata(dev);
>  	int ret = 0;
> 
> -	if (dwc2_is_device_mode(dwc2))
> +	if (dwc2_is_device_mode(dwc2)) {
>  		ret = s3c_hsotg_resume(dwc2);
> +	} else {
> +		phy_power_on(dwc2->phy);
> +		phy_init(dwc2->phy);
> +
> +	}
>  	return ret;
>  }
> 

Acked-by: Paul Zimmerman <paulz@synopsys.com>

