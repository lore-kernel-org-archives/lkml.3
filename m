Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab3GPRae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:30:34 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:47170 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab3GPRad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:30:33 -0400
Date: Tue, 16 Jul 2013 20:30:25 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Daniel Mack <zonque@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: v3.11-rc1 USB regressions
Message-ID: <20130716173025.GI3296@blackmetal.musicnaut.iki.fi>
References: <20130715225647.GE3296@blackmetal.musicnaut.iki.fi>
 <51E4E922.2040707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E4E922.2040707@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 16, 2013 at 08:33:06AM +0200, Daniel Mack wrote:
> > 	fe4cb0912f8e737f8e4b8b38b9e692f8062f5423
> > 	usb: musb: gadget: remove hcd initialization
> > 	(Reverting this fixes error "cdc_ether: probe of 4-1:1.0 failed
> > 	 with error -110" seen on the host side.)
> 
> Which role does your musb-based hardware have in this case, and which
> MUSB_* config symbols do you set? You should have USB_MUSB_GADGET.

I have USB_MUSB_DUAL_ROLE set. But also with USB_MUSB_GADGET the result
is the same.

The N900/RX-51 board file sets mode to MUSB_PERIPHERAL (see
mach-omap2/board-rx51.c).

> From 5f33d42f2dffb82d22b83a030f14fe2331a935b7 Mon Sep 17 00:00:00 2001
> From: Daniel Mack <zonque@gmail.com>
> Date: Tue, 16 Jul 2013 08:19:49 +0200
> Subject: [PATCH] ARM: omap2: fix musb usage for n8x0
> 
> Commit b7e2e75a8c ("usb: gadget: drop unused USB_GADGET_MUSB_HDRC")
> dropped a config symbol that was unused by the musb core, but it turns
> out that board support code still had references to it.
> 
> As the core now handles both dual role and host-only modes, we can just
> pass MUSB_OTG as mode from board files.

This looks fine, however, I currently cannot test the host mode.

A.

> Signed-off-by: Daniel Mack <zonque@gmail.com>
> ---
>  arch/arm/mach-omap2/board-n8x0.c | 4 ----
>  arch/arm/mach-omap2/usb-musb.c   | 5 +----
>  2 files changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
> index f6eeb87..827d150 100644
> --- a/arch/arm/mach-omap2/board-n8x0.c
> +++ b/arch/arm/mach-omap2/board-n8x0.c
> @@ -122,11 +122,7 @@ static struct musb_hdrc_config musb_config = {
>  };
>  
>  static struct musb_hdrc_platform_data tusb_data = {
> -#ifdef CONFIG_USB_GADGET_MUSB_HDRC
>  	.mode		= MUSB_OTG,
> -#else
> -	.mode		= MUSB_HOST,
> -#endif
>  	.set_power	= tusb_set_power,
>  	.min_power	= 25,	/* x2 = 50 mA drawn from VBUS as peripheral */
>  	.power		= 100,	/* Max 100 mA VBUS for host mode */
> diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
> index 8c4de27..bc89723 100644
> --- a/arch/arm/mach-omap2/usb-musb.c
> +++ b/arch/arm/mach-omap2/usb-musb.c
> @@ -38,11 +38,8 @@ static struct musb_hdrc_config musb_config = {
>  };
>  
>  static struct musb_hdrc_platform_data musb_plat = {
> -#ifdef CONFIG_USB_GADGET_MUSB_HDRC
>  	.mode		= MUSB_OTG,
> -#else
> -	.mode		= MUSB_HOST,
> -#endif
> +
>  	/* .clock is set dynamically */
>  	.config		= &musb_config,
>  
> -- 
> 1.8.1.4
> 

