Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3AVOJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:09:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35145 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab3AVOJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:09:53 -0500
Message-ID: <50FE9DA6.4030507@ti.com>
Date: Tue, 22 Jan 2013 16:09:42 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <tony@atomide.com>, <balbi@ti.com>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v1 4/6] drivers: usb: musb: omap: make use of the new
 PHY lib APIs
References: <1358848694-20145-1-git-send-email-kishon@ti.com> <1358848694-20145-5-git-send-email-kishon@ti.com>
In-Reply-To: <1358848694-20145-5-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 11:58 AM, Kishon Vijay Abraham I wrote:
> New PHY lib APIs like usb_add_phy_dev() and devm_usb_get_phy_dev() are
> used in MUSB (OMAP), in order to make use of the binding information
> provided in the board file (of OMAP platforms).
> All the platforms should be modified similar to this to add and get the
> PHY.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/musb/omap2430.c   |    2 +-
>  drivers/usb/otg/twl4030-usb.c |    3 ++-
>  drivers/usb/phy/omap-usb2.c   |    3 ++-
>  3 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index bf6cfe0..1a8cf6d 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -345,7 +345,7 @@ static int omap2430_musb_init(struct musb *musb)
>  	 * up through ULPI.  TWL4030-family PMICs include one,
>  	 * which needs a driver, drivers aren't always needed.
>  	 */
> -	musb->xceiv = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> +	musb->xceiv = devm_usb_get_phy_dev(dev, 0);
>  	if (IS_ERR_OR_NULL(musb->xceiv)) {
>  		pr_err("HS USB OTG: no transceiver configured\n");
>  		return -ENODEV;
> diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
> index 0a70193..a994715 100644
> --- a/drivers/usb/otg/twl4030-usb.c
> +++ b/drivers/usb/otg/twl4030-usb.c
> @@ -610,6 +610,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
>  	twl->phy.dev		= twl->dev;
>  	twl->phy.label		= "twl4030";
>  	twl->phy.otg		= otg;
> +	twl->phy.type		= USB_PHY_TYPE_USB2;

What is the need to set phy.type? I think this should be deprecated along with the old API.

>  	twl->phy.set_suspend	= twl4030_set_suspend;
>  
>  	otg->phy		= &twl->phy;
> @@ -624,7 +625,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev, "ldo init failed\n");
>  		return err;
>  	}
> -	usb_add_phy(&twl->phy, USB_PHY_TYPE_USB2);
> +	usb_add_phy_dev(&twl->phy);
>  
>  	platform_set_drvdata(pdev, twl);
>  	if (device_create_file(&pdev->dev, &dev_attr_vbus))
> diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb2.c
> index 4b59b39..b5c759c 100644
> --- a/drivers/usb/phy/omap-usb2.c
> +++ b/drivers/usb/phy/omap-usb2.c
> @@ -143,6 +143,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
>  	phy->phy.label		= "omap-usb2";
>  	phy->phy.set_suspend	= omap_usb2_suspend;
>  	phy->phy.otg		= otg;
> +	phy->phy.type		= USB_PHY_TYPE_USB2;

same here.

>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>  
> @@ -168,7 +169,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
>  	}
>  	clk_prepare(phy->wkupclk);
>  
> -	usb_add_phy(&phy->phy, USB_PHY_TYPE_USB2);
> +	usb_add_phy_dev(&phy->phy);
>  
>  	platform_set_drvdata(pdev, phy);
>  
> 

--
cheers,
-roger

