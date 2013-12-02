Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3LBSWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:22:18 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56673 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752721Ab3LBSWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:22:15 -0500
Date: Mon, 2 Dec 2013 18:22:04 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] usb: phy-generic: Add ULPI VBUS support
Message-ID: <20131202182204.GQ12952@e106331-lin.cambridge.arm.com>
References: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <1385967919-13258-4-git-send-email-chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385967919-13258-4-git-send-email-chris.ruehl@gtsys.com.hk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 07:05:19AM +0000, Chris Ruehl wrote:
> usb: phy-generic: Add ULPI VBUS support
> 
> Some platforms need to set the VBUS parameters of the ULPI
> like ISP1504 which interact with overcurrent protection and
> power switch MIC2575. Therefore it requires to set
> * DRVVBUS
> * DRVVBUS_EXT
> * EXTVBUSIND
> * CHRGVBUS
> of the ULPI.
> This patch add support for it.

Could you elaborate on when we need to do this and why?

> 
> Devicetree configuration example:
> 
> usbphy0: usbphy@0x10024170 {
>  compatible = "usb-nop-xceiv";
>  reg = <0x10024170 0x4>; /* ULPI Viewport OTG */
>  clocks = <&clks 75>;
>  clock-names = "main_clk";
> };
> 
> &usbphy0 {
>         reset-gpios = <&gpio1 31 1>;
>         pinctrl-names = "default";
>         pinctrl-0 = <&pinctrl_usbphy0 &pinctrl_usbotg1>;
>         ulpi_set_vbus = <0x0f>;
> };
> 
> Please refer to the phy-bindings.txt for the value of ulpi_set_vbus commit
> with this patch.
> 
> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> ---
>  .../devicetree/bindings/phy/phy-bindings.txt       |   15 ++++++
>  drivers/usb/phy/phy-generic.c                      |   50 +++++++++++++++++++-
>  drivers/usb/phy/phy-generic.h                      |    3 ++
>  3 files changed, 67 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/phy/phy-bindings.txt b/Documentation/devicetree/bindings/phy/phy-bindings.txt
> index 8ae844f..b109b2f 100644
> --- a/Documentation/devicetree/bindings/phy/phy-bindings.txt
> +++ b/Documentation/devicetree/bindings/phy/phy-bindings.txt
> @@ -34,6 +34,18 @@ phys : the phandle for the PHY device (used by the PHY subsystem)
>  phy-names : the names of the PHY corresponding to the PHYs present in the
>  	    *phys* phandle
>  
> +Optional Properties:
> +reset-gpios :	GPIO used to reset ULPI like ISP1504 with
> +		0 = reset active high ; 1 = reset active low.

The format of the gpio-specifier doesn't matter here.

Why do you need to mention the ISP1504? Either this is generic, or it
doesn't belong here.

Perhaps we need a ulpi-phy binding document. This and the rest of the
patch is strongly tied to ULPI.

> +cs-gpios :	GPIO used to activate a ULPI like ISP1504 with
> +		0 = reset acitive high; 1 = reset active low.

Again, the format of the gpio-specifier is not a concern here. I'm also
a little confused as to the name "cs-gpios" for something that activates
the ULPI.

> +ulpi_set_vbus :	ULPI configuation parameter to program the VBUS signaling of 
> +		ISP1504 or similar chipsets.

Could you elaborate on this? Is this applicable to any ULPI PHY? The
description implies that it's somewhat tied to ISP1504 (if it's not,
drop the mention of ISP1504).

Why exactly do we need this, and why should it live in the DT?

Why can se not figure this out automatically, or have defaults that work
in more places?

Also, s/_/-/ on property names please.

> +		Set the parameter:
> +		DRVVBUS = (1) DRVVBUS_EXT = (1<<1) EXTVBUSIND = (1<<2) CHRGVBUS = (1<<3)
> +		eg: DRVVBUS | DRVVBUS_EXT = 0x03
> +		    ulpi_set_vbus = <0x03>

I don't like putting arbitrary bitfields like this in DT. They're
illegible and easy to abuse.

Boolean properties are nicer for flags.

What exactly do these flags mean?

[...]

> @@ -253,14 +284,15 @@ static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
>  
>  	if (dev->of_node) {
>  		struct device_node *node = dev->of_node;
> +		struct resource	*res;
>  		enum of_gpio_flags flags;
>  		enum of_gpio_flags csflags;
> +		u32 ulpi_vbus;
>  
>  		if (of_property_read_u32(node, "clock-frequency", &clk_rate))
>  			clk_rate = 0;
>  
>  		needs_vcc = of_property_read_bool(node, "vcc-supply");
> -
>  		nop->gpio_reset = of_get_named_gpio_flags(node, "reset-gpios",
>  								0, &flags);

Why the random line deletion?

>  
> @@ -274,6 +306,22 @@ static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
>  		if (gpio_is_valid(nop->gpio_chipselect))
>  			nop->cs_active_low = csflags & OF_GPIO_ACTIVE_LOW;
>  
> +		err = of_property_read_u32(node, "ulpi_set_vbus",&ulpi_vbus);
> +		if (err) {
> +			nop->ulpi_vbus = -1;
> +			nop->viewport = NULL;
> +			ulpi_vbus = 0;
> +		} else {
> +			dev_dbg(dev,"ULPI ulpi_set_vbus 0x%02x",ulpi_vbus);
> +			nop->ulpi_vbus = ulpi_vbus;
> +			res = platform_get_resource(pdev, IORESOURCE_MEM, 0);

This wasn't described in the binding document, and it's ULPI specific. I
think we need a separate ulpi-phy binding that builds upon the generic
one.

Thanks,
Mark.
