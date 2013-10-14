Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab3JNOdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:33:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46949 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939Ab3JNOdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:33:13 -0400
Date: Mon, 14 Oct 2013 15:33:00 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: George Cherian <george.cherian@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>, "balbi@ti.com" <balbi@ti.com>,
        "kishon@ti.com" <kishon@ti.com>, "rob@landley.net" <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH] phy: omap: Adapt phy-omap-usb2 for AM437x
Message-ID: <20131014143259.GD31708@e106331-lin.cambridge.arm.com>
References: <1381754603-11581-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381754603-11581-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 01:43:23PM +0100, George Cherian wrote:
> This patch adds a compatible for AM437x "ti,am43xx-usb2" to
> reuse the same phy-omap-usb2 driver.
> 
> Also updated the documentation to add the new compatible.
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  Documentation/devicetree/bindings/usb/usb-phy.txt |  2 +-
>  drivers/phy/phy-omap-usb2.c                       | 13 ++++++++++---
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
> index c0245c8..d5a7f21 100644
> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
> @@ -3,7 +3,7 @@ USB PHY
>  OMAP USB2 PHY
>  
>  Required properties:
> - - compatible: Should be "ti,omap-usb2"
> + - compatible: Should be "ti,omap-usb2" or "ti,am437x-usb2"

In case this needs to be modified in future, it might be best to split
this up one per line, with a brief description of when it applies:

- compatible: Should contain one of:
  * "ti,omap-usb2" for ____ systems
  * "ti,am437x-usb2" for ____ systems

>   - reg : Address and length of the register set for the device.
>   - #phy-cells: determine the number of cells that should be given in the
>     phandle while referencing this phy.
> diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
> index bfc5c33..0529c83 100644
> --- a/drivers/phy/phy-omap-usb2.c
> +++ b/drivers/phy/phy-omap-usb2.c
> @@ -29,6 +29,7 @@
>  #include <linux/delay.h>
>  #include <linux/usb/omap_control_usb.h>
>  #include <linux/phy/phy.h>
> +#include <linux/of.h>
>  #include <linux/of_platform.h>
>  
>  /**
> @@ -172,7 +173,10 @@ static int omap_usb2_probe(struct platform_device *pdev)
>  	phy->dev		= &pdev->dev;
>  
>  	phy->phy.dev		= phy->dev;
> -	phy->phy.label		= "omap-usb2";
> +	if (of_device_is_compatible(node, "ti,am437x-usb2"))
> +		phy->phy.label		= "am437x-usb2";
> +	else
> +		phy->phy.label		= "omap-usb2";

Instead of having this check here, you could put together a struct
containing the data applying to a particular compatible string, and
associate it with the compatible string using of_device_id::data.

That means we don't need to duplicate the compatible strings, and it's
easier to extend in future.

>  	phy->phy.set_suspend	= omap_usb2_suspend;
>  	phy->phy.otg		= otg;
>  	phy->phy.type		= USB_PHY_TYPE_USB2;
> @@ -201,8 +205,10 @@ static int omap_usb2_probe(struct platform_device *pdev)
>  
>  	otg->set_host		= omap_usb_set_host;
>  	otg->set_peripheral	= omap_usb_set_peripheral;
> -	otg->set_vbus		= omap_usb_set_vbus;
> -	otg->start_srp		= omap_usb_start_srp;
> +	if (of_device_is_compatible(node, "ti,omap-usb2")) {
> +		otg->set_vbus		= omap_usb_set_vbus;
> +		otg->start_srp		= omap_usb_start_srp;
> +	}

Similarly here.

Cheers,
Mark.
