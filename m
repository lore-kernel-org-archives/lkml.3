Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3JYPyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:54:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37305 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab3JYPyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:54:05 -0400
Message-ID: <526A9414.6070000@ti.com>
Date: Fri, 25 Oct 2013 21:23:56 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm@vger.kernel.org>, <kyungmin.park@samsung.com>,
        <t.figa@samsung.com>, <s.nawrocki@samsung.com>,
        <m.szyprowski@samsung.com>, <gautam.vivek@samsung.com>,
        <mat.krawczuk@gmail.com>
Subject: Re: [PATCH 5/5] usb: s3c-hsotg: Use the new Exynos USB phy driver
 with the generic phy framework
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com> <1382710529-12082-6-git-send-email-k.debski@samsung.com>
In-Reply-To: <1382710529-12082-6-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 October 2013 07:45 PM, Kamil Debski wrote:
> Change the used phy driver to the new Exynos USB phy driver that uses the
> generic phy framework.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/usb/gadget/s3c-hsotg.c |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
> index 7705c41..2ce84a5 100644
> --- a/drivers/usb/gadget/s3c-hsotg.c
> +++ b/drivers/usb/gadget/s3c-hsotg.c
> @@ -29,6 +29,7 @@
>  #include <linux/slab.h>
>  #include <linux/clk.h>
>  #include <linux/regulator/consumer.h>
> +#include <linux/phy/phy.h>
>  
>  #include <linux/usb/ch9.h>
>  #include <linux/usb/gadget.h>
> @@ -131,6 +132,7 @@ struct s3c_hsotg_ep {
>  /**
>   * struct s3c_hsotg - driver state.
>   * @dev: The parent device supplied to the probe function
> +

empty blank line.
>   * @driver: USB gadget driver
>   * @phy: The otg phy transceiver structure for phy control.
>   * @plat: The platform specific configuration data. This can be removed once
> @@ -154,7 +156,7 @@ struct s3c_hsotg_ep {
>  struct s3c_hsotg {
>  	struct device		 *dev;
>  	struct usb_gadget_driver *driver;
> -	struct usb_phy		*phy;
> +	struct phy		 *phy;
>  	struct s3c_hsotg_plat	 *plat;
>  
>  	spinlock_t              lock;
> @@ -2858,9 +2860,10 @@ static void s3c_hsotg_phy_enable(struct s3c_hsotg *hsotg)
>  	dev_dbg(hsotg->dev, "pdev 0x%p\n", pdev);
>  
>  	if (hsotg->phy)
> -		usb_phy_init(hsotg->phy);
> +		phy_power_on(hsotg->phy);
>  	else if (hsotg->plat->phy_init)
>  		hsotg->plat->phy_init(pdev, hsotg->plat->phy_type);
> +
>  }
>  
>  /**
> @@ -2875,7 +2878,7 @@ static void s3c_hsotg_phy_disable(struct s3c_hsotg *hsotg)
>  	struct platform_device *pdev = to_platform_device(hsotg->dev);
>  
>  	if (hsotg->phy)
> -		usb_phy_shutdown(hsotg->phy);
> +		phy_power_off(hsotg->phy);
>  	else if (hsotg->plat->phy_exit)
>  		hsotg->plat->phy_exit(pdev, hsotg->plat->phy_type);
>  }
> @@ -3485,7 +3488,7 @@ static void s3c_hsotg_delete_debug(struct s3c_hsotg *hsotg)
>  static int s3c_hsotg_probe(struct platform_device *pdev)
>  {
>  	struct s3c_hsotg_plat *plat = pdev->dev.platform_data;
> -	struct usb_phy *phy;
> +	struct phy *phy;
>  	struct device *dev = &pdev->dev;
>  	struct s3c_hsotg_ep *eps;
>  	struct s3c_hsotg *hsotg;
> @@ -3500,7 +3503,7 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> +	phy = devm_phy_get(&pdev->dev, "device");
>  	if (IS_ERR(phy)) {
>  		/* Fallback for pdata */
>  		plat = pdev->dev.platform_data;

Apart from that one minor comment, this patch looks good.

Thanks
Kishon
