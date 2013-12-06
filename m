Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab3LFLMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:12:07 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52625 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757771Ab3LFLMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:12:03 -0500
Message-ID: <52A1B0F7.2050501@ti.com>
Date: Fri, 6 Dec 2013 16:41:51 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <kyungmin.park@samsung.com>, <t.figa@samsung.com>,
        <s.nawrocki@samsung.com>, <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>,
        <yulgon.kim@samsung.com>, <p.paneri@samsung.com>,
        <av.tikhomirov@samsung.com>, <jg1.han@samsung.com>,
        <galak@codeaurora.org>, <matt.porter@linaro.org>
Subject: Re: [PATCH v4 5/9] usb: s3c-hsotg: Use the new Exynos USB phy driver
 with the generic phy framework
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com> <1386246579-25141-6-git-send-email-k.debski@samsung.com>
In-Reply-To: <1386246579-25141-6-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 05 December 2013 05:59 PM, Kamil Debski wrote:
> Change the used phy driver to the new Exynos USB phy driver that uses the
> generic phy framework.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/usb/samsung-hsotg.txt      |    4 ++++
>  drivers/usb/gadget/s3c-hsotg.c                     |   11 ++++++-----
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/usb/samsung-hsotg.txt b/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
> index b83d428..9340d06 100644
> --- a/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
> +++ b/Documentation/devicetree/bindings/usb/samsung-hsotg.txt
> @@ -24,6 +24,8 @@ Required properties:
>      - first entry: must be "otg"
>  - vusb_d-supply: phandle to voltage regulator of digital section,
>  - vusb_a-supply: phandle to voltage regulator of analog section.
> +- phys: from general PHY binding: phandle to the PHY device
> +- phy-names: from general PHY binding: should be "usb2-phy"

are you sure it's usb2-phy. The example below seems to have a different value.

Thanks
Kishon

>  
>  Example
>  -----
> @@ -36,5 +38,7 @@ Example
>  		clock-names = "otg";
>  		vusb_d-supply = <&vusb_reg>;
>  		vusb_a-supply = <&vusbdac_reg>;
> +		phys = <&usb2phy 0>;
> +		phy-names = "device";
>  	};
>  
> diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
> index eccb147..db096fd 100644
> --- a/drivers/usb/gadget/s3c-hsotg.c
> +++ b/drivers/usb/gadget/s3c-hsotg.c
> @@ -31,6 +31,7 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
> +#include <linux/phy/phy.h>
>  
>  #include <linux/usb/ch9.h>
>  #include <linux/usb/gadget.h>
> @@ -162,7 +163,7 @@ struct s3c_hsotg_ep {
>  struct s3c_hsotg {
>  	struct device		 *dev;
>  	struct usb_gadget_driver *driver;
> -	struct usb_phy		*phy;
> +	struct phy		 *phy;
>  	struct s3c_hsotg_plat	 *plat;
>  
>  	spinlock_t              lock;
> @@ -2905,7 +2906,7 @@ static void s3c_hsotg_phy_enable(struct s3c_hsotg *hsotg)
>  	dev_dbg(hsotg->dev, "pdev 0x%p\n", pdev);
>  
>  	if (hsotg->phy)
> -		usb_phy_init(hsotg->phy);
> +		phy_power_on(hsotg->phy);
>  	else if (hsotg->plat->phy_init)
>  		hsotg->plat->phy_init(pdev, hsotg->plat->phy_type);
>  }
> @@ -2922,7 +2923,7 @@ static void s3c_hsotg_phy_disable(struct s3c_hsotg *hsotg)
>  	struct platform_device *pdev = to_platform_device(hsotg->dev);
>  
>  	if (hsotg->phy)
> -		usb_phy_shutdown(hsotg->phy);
> +		phy_power_off(hsotg->phy);
>  	else if (hsotg->plat->phy_exit)
>  		hsotg->plat->phy_exit(pdev, hsotg->plat->phy_type);
>  }
> @@ -3529,7 +3530,7 @@ static void s3c_hsotg_delete_debug(struct s3c_hsotg *hsotg)
>  static int s3c_hsotg_probe(struct platform_device *pdev)
>  {
>  	struct s3c_hsotg_plat *plat = dev_get_platdata(&pdev->dev);
> -	struct usb_phy *phy;
> +	struct phy *phy;
>  	struct device *dev = &pdev->dev;
>  	struct s3c_hsotg_ep *eps;
>  	struct s3c_hsotg *hsotg;
> @@ -3544,7 +3545,7 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> +	phy = devm_phy_get(&pdev->dev, "usb2-phy");
>  	if (IS_ERR(phy)) {
>  		/* Fallback for pdata */
>  		plat = dev_get_platdata(&pdev->dev);
> 

