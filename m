Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3ILNne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:43:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43328 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab3ILNnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:43:32 -0400
Message-ID: <5231C4C4.1000100@ti.com>
Date: Thu, 12 Sep 2013 16:42:28 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] drivers: phy: renamed struct omap_control_usb to
 struct omap_control_phy
References: <1378136591-7463-1-git-send-email-kishon@ti.com> <1378136591-7463-8-git-send-email-kishon@ti.com>
In-Reply-To: <1378136591-7463-8-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/02/2013 06:43 PM, Kishon Vijay Abraham I wrote:
> renamed struct omap_control_usb to struct omap_control_phy since it can
> be used to control PHY of USB, SATA and PCIE. Also moved the driver and
> include files under *phy* and made the corresponding changes in the users
> of phy-omap-control.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/Kconfig                                |   14 +-
>  drivers/phy/Makefile                               |    1 +
>  drivers/{usb => }/phy/phy-omap-control.c           |  164 ++++++++++----------
>  drivers/phy/phy-omap-pipe3.c                       |    8 +-
>  drivers/phy/phy-omap-usb2.c                        |    8 +-
>  drivers/usb/musb/omap2430.c                        |    2 +-
>  drivers/usb/phy/Makefile                           |    1 -
>  .../omap_control_usb.h => phy/omap_control_phy.h}  |   32 ++--
>  8 files changed, 120 insertions(+), 110 deletions(-)
>  rename drivers/{usb => }/phy/phy-omap-control.c (55%)
>  rename include/linux/{usb/omap_control_usb.h => phy/omap_control_phy.h} (69%)
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 5c2e7a0..fd11294 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -15,12 +15,22 @@ config GENERIC_PHY
>  	  phy users can obtain reference to the PHY. All the users of this
>  	  framework should select this config.
>  
> +config OMAP_CONTROL_PHY
> +	tristate "OMAP CONTROL PHY Driver"
> +	depends on ARCH_OMAP2PLUS || COMPILE_TEST
> +	help
> +	  Enable this to add support for the PHY part present in the control
> +	  module. This driver has API to power on the USB2 PHY and to write to
> +	  the mailbox. The mailbox is present only in omap4 and the register to
> +	  power on the USB2 PHY is present in OMAP4 and OMAP5. OMAP5 has
> +	  additional registers to power on PIPE3 PHYs.
> +
>  config OMAP_USB2
>  	tristate "OMAP USB2 PHY Driver"
>  	depends on ARCH_OMAP2PLUS
>  	select GENERIC_PHY
>  	select USB_PHY
> -	select OMAP_CONTROL_USB
> +	select OMAP_CONTROL_PHY
>  	help
>  	  Enable this to support the transceiver that is part of SOC. This
>  	  driver takes care of all the PHY functionality apart from comparator.
> @@ -30,7 +40,7 @@ config OMAP_USB2
>  config OMAP_PIPE3
>  	tristate "OMAP PIPE3 PHY Driver"
>  	select GENERIC_PHY
> -	select OMAP_CONTROL_USB
> +	select OMAP_CONTROL_PHY
>  	help
>  	  Enable this to support the PIPE3 PHY that is part of SOC. This
>  	  driver takes care of all the PHY functionality apart from comparator.
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 48bf9f2..f0127f6 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -3,6 +3,7 @@
>  #
>  
>  obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
> +obj-$(CONFIG_OMAP_CONTROL_PHY)	+= phy-omap-control.o
>  obj-$(CONFIG_OMAP_USB2)		+= phy-omap-usb2.o
>  obj-$(CONFIG_OMAP_PIPE3)	+= phy-omap-pipe3.o
>  obj-$(CONFIG_TWL4030_USB)	+= phy-twl4030-usb.o
> diff --git a/drivers/usb/phy/phy-omap-control.c b/drivers/phy/phy-omap-control.c
> similarity index 55%
> rename from drivers/usb/phy/phy-omap-control.c
> rename to drivers/phy/phy-omap-control.c
> index 1a7e19a..ece3573 100644
> --- a/drivers/usb/phy/phy-omap-control.c
> +++ b/drivers/phy/phy-omap-control.c
> @@ -1,5 +1,5 @@
>  /*
> - * omap-control-usb.c - The USB part of control module.
> + * phy-omap-control.c - The USB part of control module.
>   *
>   * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
>   * This program is free software; you can redistribute it and/or modify
> @@ -24,36 +24,36 @@
>  #include <linux/err.h>
>  #include <linux/io.h>
>  #include <linux/clk.h>
> -#include <linux/usb/omap_control_usb.h>
> +#include <linux/phy/omap_control_phy.h>
>  

<snip>

>  #ifdef CONFIG_OF
>  
> -static const enum omap_control_usb_type omap4_data = OMAP_CTRL_TYPE_OMAP4;
> -static const enum omap_control_usb_type usb2_data = OMAP_CTRL_TYPE_USB2;
> -static const enum omap_control_usb_type usb3_data = OMAP_CTRL_TYPE_USB3;
> -static const enum omap_control_usb_type dra7_data = OMAP_CTRL_TYPE_DRA7;
> +static const enum omap_control_phy_type omap4_data = OMAP_CTRL_TYPE_OMAP4;
> +static const enum omap_control_phy_type usb2_data = OMAP_CTRL_TYPE_USB2;
> +static const enum omap_control_phy_type usb3_data = OMAP_CTRL_TYPE_USB3;
> +static const enum omap_control_phy_type dra7_data = OMAP_CTRL_TYPE_DRA7;
>  
> -static const struct of_device_id omap_control_usb_id_table[] = {
> +static const struct of_device_id omap_control_phy_id_table[] = {
>  	{
>  		.compatible = "ti,omap4-control-usb",
>  		.data = &omap4_data,
> @@ -286,31 +286,31 @@ static const struct of_device_id omap_control_usb_id_table[] = {
>  	},
>  	{},
>  };
> -MODULE_DEVICE_TABLE(of, omap_control_usb_id_table);
> +MODULE_DEVICE_TABLE(of, omap_control_phy_id_table);
>  #endif
>  
> -static struct platform_driver omap_control_usb_driver = {
> -	.probe		= omap_control_usb_probe,
> +static struct platform_driver omap_control_phy_driver = {
> +	.probe		= omap_control_phy_probe,
>  	.driver		= {
>  		.name	= "omap-control-usb",
>  		.owner	= THIS_MODULE,
> -		.of_match_table = of_match_ptr(omap_control_usb_id_table),
> +		.of_match_table = of_match_ptr(omap_control_phy_id_table),
>  	},
>  };
>  
> -static int __init omap_control_usb_init(void)
> +static int __init omap_control_phy_init(void)
>  {
> -	return platform_driver_register(&omap_control_usb_driver);
> +	return platform_driver_register(&omap_control_phy_driver);
>  }
> -subsys_initcall(omap_control_usb_init);
> +subsys_initcall(omap_control_phy_init);

Any specific reason for having this as subsys_initcall?

If not then you can use module_platform_driver().

>  
> -static void __exit omap_control_usb_exit(void)
> +static void __exit omap_control_phy_exit(void)
>  {
> -	platform_driver_unregister(&omap_control_usb_driver);
> +	platform_driver_unregister(&omap_control_phy_driver);
>  }
> -module_exit(omap_control_usb_exit);
> +module_exit(omap_control_phy_exit);
>  
> -MODULE_ALIAS("platform: omap_control_usb");
> +MODULE_ALIAS("platform: omap_control_phy");
>  MODULE_AUTHOR("Texas Instruments Inc.");
>  MODULE_DESCRIPTION("OMAP Control Module USB Driver");
>  MODULE_LICENSE("GPL v2");

cheers,
-roger

