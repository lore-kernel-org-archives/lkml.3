Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbbAICP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 21:15:27 -0500
Received: from smtprelay.synopsys.com ([198.182.60.111]:53997 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbbAICPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 21:15:25 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Yunzhi Li <lyz@rock-chips.com>,
        "Dinh Nguyen (dinguyen@opensource.altera.com)" 
	<dinguyen@opensource.altera.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "jwerner@chromium.org" <jwerner@chromium.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "zyw@rock-chips.com" <zyw@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>
Subject: RE: [PATCH v7 3/5] usb: dwc2: add generic PHY framework support for
 dwc2 usb controler platform driver.
Thread-Topic: [PATCH v7 3/5] usb: dwc2: add generic PHY framework support
 for dwc2 usb controler platform driver.
Thread-Index: AQHQFh27WKp3IndWekWc7l03cD6hbpy3NGmQ
Date: Fri, 9 Jan 2015 02:15:21 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E03048450635E@US01WEMBX2.internal.synopsys.com>
References: <1418396413-27937-1-git-send-email-lyz@rock-chips.com>
 <1418396972-32686-1-git-send-email-lyz@rock-chips.com>
In-Reply-To: <1418396972-32686-1-git-send-email-lyz@rock-chips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.184.20]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Yunzhi Li [mailto:lyz@rock-chips.com]
> Sent: Friday, December 12, 2014 7:10 AM
> 
> Get PHY parameters from devicetree and power off usb PHY during
> system suspend.
> 
> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> 
> ---
> 
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3:
> - Fix coding style: both branches of the if() which only one
>   branch of the conditional statement is a single statement
>   should have braces.
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

Hi Yunzhi,

Testing Felipe's testing/next branch on an Altera SOCFPGA platform,
the driver never loads because it always returns -EPROBE_DEFER here.
Apparently the SOCFPGA platform does not have any platform data
defined, because dev_get_platdata() always returns NULL.

If I remove the -EPROBE_DEFER return and have it continue on, the
driver works. Reverting the patch also makes it work.

I am testing with the driver built-in. I haven't tried it as a module
yet.

Any ideas? Is the -EPROBE_DEFER return really needed here?

-- 
Paul

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
> --
> 2.0.0
> 

