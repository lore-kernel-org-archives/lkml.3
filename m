Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaLETEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:04:09 -0500
Received: from smtprelay.synopsys.com ([198.182.60.111]:59503 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaLETEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:04:07 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Yunzhi Li <lyz@rock-chips.com>, "heiko@sntech.de" <heiko@sntech.de>,
        "dianders@chromium.org" <dianders@chromium.org>
CC: "olof@lixom.net" <olof@lixom.net>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "ulrich.prinz@googlemail.com" <ulrich.prinz@googlemail.com>,
        "zyw@rock-chips.com" <zyw@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 3/5] usb: dwc2: Add generic PHY framework support for
 dwc2 usb controler platform driver.
Thread-Topic: [PATCH v2 3/5] usb: dwc2: Add generic PHY framework support
 for dwc2 usb controler platform driver.
Thread-Index: AQHQEIqcG5EhzbPG0kaiAXphivO/SpyBV0kA
Date: Fri, 5 Dec 2014 19:04:01 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844FFB50@US01WEMBX2.internal.synopsys.com>
References: <1417783941-2418-1-git-send-email-lyz@rock-chips.com>
 <1417783941-2418-4-git-send-email-lyz@rock-chips.com>
In-Reply-To: <1417783941-2418-4-git-send-email-lyz@rock-chips.com>
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
> Sent: Friday, December 05, 2014 4:52 AM
> 
> Get PHY parameters from devicetree and power off usb PHY during
> system suspend.
> 
> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
> ---
> 
>  drivers/usb/dwc2/gadget.c   | 33 ++++++++++++---------------------
>  drivers/usb/dwc2/platform.c | 34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 46 insertions(+), 21 deletions(-)
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

You have changed the behavior here. Previously, the driver would work
even if there were no phys or pdata defined. Now it will return
-EPROBE_DEFER instead. Are you sure that won't break any existing
platforms?

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
> index 6a795aa..739d14f 100644
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
> @@ -233,6 +253,14 @@ static int __maybe_unused dwc2_suspend(struct device *dev)
> 
>  	if (dwc2_is_device_mode(dwc2))
>  		ret = s3c_hsotg_suspend(dwc2);
> +	else {

Kernel style says that both branches of the if() should have braces
here.

> +		if (dwc2->lx_state == DWC2_L0)
> +			return 0;
> +		if (dwc2->phy) {
> +			phy_exit(dwc2->phy);
> +			phy_power_off(dwc2->phy);
> +		}

Minor nit: no need to test dwc2->phy for NULL here, the phy functions
handle a NULL pointer just fine.

> +	}
>  	return ret;
>  }
> 
> @@ -243,6 +271,12 @@ static int __maybe_unused dwc2_resume(struct device *dev)
> 
>  	if (dwc2_is_device_mode(dwc2))
>  		ret = s3c_hsotg_resume(dwc2);
> +	else {

Braces.

> +		if (dwc2->phy) {
> +			phy_power_on(dwc2->phy);
> +			phy_init(dwc2->phy);
> +		}
> +	}
>  	return ret;
>  }
> 

-- 
Paul

