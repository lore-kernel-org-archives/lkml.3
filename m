Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3JBKUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:20:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54802 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab3JBKUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:20:09 -0400
Message-ID: <524BF332.4080303@ti.com>
Date: Wed, 2 Oct 2013 13:19:30 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <tony@atomide.com>
CC: Roger Quadros <rogerq@ti.com>, <balbi@ti.com>, <bcousson@baylibre.com>,
        <p.zabel@pengutronix.de>, <broonie@kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 03/10] ARM: OMAP2+: omap-usb-host: Get rid of platform_data
 from struct usbhs_phy_data
References: <1380012836-29900-1-git-send-email-rogerq@ti.com> <1380012836-29900-4-git-send-email-rogerq@ti.com>
In-Reply-To: <1380012836-29900-4-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 09/24/2013 11:53 AM, Roger Quadros wrote:
> The platform data bits can be inferred from the other members of
> struct usbhs_phy_data. So get rid of the platform_data member.
> 
> Build the platform data for the PHY device in usbhs_init_phys() instead.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Could you please Ack this if OK?

cheers,
-roger

> ---
>  arch/arm/mach-omap2/board-omap3beagle.c |    6 ------
>  arch/arm/mach-omap2/usb-host.c          |   11 ++++++++++-
>  arch/arm/mach-omap2/usb.h               |    1 -
>  3 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
> index f269184..8b9cd06 100644
> --- a/arch/arm/mach-omap2/board-omap3beagle.c
> +++ b/arch/arm/mach-omap2/board-omap3beagle.c
> @@ -289,18 +289,12 @@ static struct regulator_consumer_supply beagle_vsim_supply[] = {
>  
>  static struct gpio_led gpio_leds[];
>  
> -/* PHY's VCC regulator might be added later, so flag that we need it */
> -static struct usb_phy_gen_xceiv_platform_data hsusb2_phy_data = {
> -	.needs_vcc = true,
> -};
> -
>  static struct usbhs_phy_data phy_data[] = {
>  	{
>  		.port = 2,
>  		.reset_gpio = 147,
>  		.vcc_gpio = -1,		/* updated in beagle_twl_gpio_setup */
>  		.vcc_polarity = 1,	/* updated in beagle_twl_gpio_setup */
> -		.platform_data = &hsusb2_phy_data,
>  	},
>  };
>  
> diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
> index e83a6a4..78ac1c2 100644
> --- a/arch/arm/mach-omap2/usb-host.c
> +++ b/arch/arm/mach-omap2/usb-host.c
> @@ -435,6 +435,7 @@ int usbhs_init_phys(struct usbhs_phy_data *phy, int num_phys)
>  	struct platform_device *pdev;
>  	char *phy_id;
>  	struct platform_device_info pdevinfo;
> +	struct usb_phy_gen_xceiv_platform_data nop_pdata;
>  
>  	for (i = 0; i < num_phys; i++) {
>  
> @@ -455,11 +456,19 @@ int usbhs_init_phys(struct usbhs_phy_data *phy, int num_phys)
>  			return -ENOMEM;
>  		}
>  
> +		/* set platform data */
> +		memset(&nop_pdata, 0, sizeof(nop_pdata));
> +		if (gpio_is_valid(phy->vcc_gpio))
> +			nop_pdata.needs_vcc = true;
> +		if (gpio_is_valid(phy->reset_gpio))
> +			nop_pdata.needs_reset = true;
> +		nop_pdata.type = USB_PHY_TYPE_USB2;
> +
>  		/* create a NOP PHY device */
>  		memset(&pdevinfo, 0, sizeof(pdevinfo));
>  		pdevinfo.name = nop_name;
>  		pdevinfo.id = phy->port;
> -		pdevinfo.data = phy->platform_data;
> +		pdevinfo.data = &nop_pdata;
>  		pdevinfo.size_data =
>  			sizeof(struct usb_phy_gen_xceiv_platform_data);
>  		scnprintf(phy_id, MAX_STR, "usb_phy_gen_xceiv.%d",
> diff --git a/arch/arm/mach-omap2/usb.h b/arch/arm/mach-omap2/usb.h
> index e7261eb..4ba2ae7 100644
> --- a/arch/arm/mach-omap2/usb.h
> +++ b/arch/arm/mach-omap2/usb.h
> @@ -58,7 +58,6 @@ struct usbhs_phy_data {
>  	int reset_gpio;
>  	int vcc_gpio;
>  	bool vcc_polarity;	/* 1 active high, 0 active low */
> -	void *platform_data;
>  };
>  
>  extern void usb_musb_init(struct omap_musb_board_data *board_data);
> 

