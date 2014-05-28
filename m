Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaE1SlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:41:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbaE1SlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:41:15 -0400
Date: Wed, 28 May 2014 11:44:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Satish Patel <satish.patel@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        rob@landley.net, tony@atomide.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Subject: Re: [PATCH v3 2/5] misc: tda8026: Add NXP TDA8026 PHY driver
Message-ID: <20140528184450.GD30031@kroah.com>
References: <1401267437-22489-1-git-send-email-satish.patel@ti.com>
 <1401267437-22489-3-git-send-email-satish.patel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401267437-22489-3-git-send-email-satish.patel@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 02:27:14PM +0530, Satish Patel wrote:
> TDA8026 is a SmartCard PHY from NXP.
> 
> The PHY interfaces with the main processor over the
> I2C interface and acts as a slave device.
> 
> The driver also exposes the phy interface
> (defined@include/linux/sc_phy.h) for SmartCard controller.
> Controller uses this interface to communicate with smart card
> inserted to the phy's slot.
> 
> Note: gpio irq is not validated as I do not have device with that.
> I have validated interrupt with dedicated interrupt line on my device.
> 
> Signed-off-by: Satish Patel <satish.patel@ti.com>
> ---
>  Documentation/devicetree/bindings/misc/tda8026.txt |   19 +
>  drivers/misc/Kconfig                               |    7 +
>  drivers/misc/Makefile                              |    1 +
>  drivers/misc/tda8026.c                             | 1258 ++++++++++++++++++++
>  4 files changed, 1285 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/misc/tda8026.txt
>  create mode 100644 drivers/misc/tda8026.c
> 
> diff --git a/Documentation/devicetree/bindings/misc/tda8026.txt b/Documentation/devicetree/bindings/misc/tda8026.txt
> new file mode 100644
> index 0000000..f115c9c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/tda8026.txt
> @@ -0,0 +1,19 @@
> +TDA8026 smart card slot interface
> +
> +This is an i2c based smart card interface device forming the electrical
> +interface between a microcontroller and smart cards. This device supports
> +asynchronous cards (micro controller-based IC cards) as well as synchronous
> +cards (mainly memory cards)
> +
> +Required properties:
> +- compatible: "nxp,tda8026"
> +- shutdown-gpio = GPIO pin mapping for SDWNN pin
> +- reg = i2c interface address
> +
> +
> +Example:
> +tda8026: tda8026@48 {
> +		 compatible = "nxp,tda8026";
> +		 reg = <0x48>;
> +		 shutdown-gpio = <&gpio5 19 GPIO_ACTIVE_HIGH>;/* Bank5, pin19 */
> +	 };
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 8baff0e..80b21d7 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -515,6 +515,13 @@ config SRAM
>  	  the genalloc API. It is supposed to be used for small on-chip SRAM
>  	  areas found on many SoCs.
>  
> +config NXP_TDA8026_PHY
> +        tristate "NXP PHY Driver for Smart Card PHY"
> +        depends on I2C=y
> +        help
> +          If you say yes here you get support for the TDA8026 Smart card PHY
> +	  with I2C interface.
> +
>  source "drivers/misc/c2port/Kconfig"
>  source "drivers/misc/eeprom/Kconfig"
>  source "drivers/misc/cb710/Kconfig"
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 7eb4b69..f262c0b 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -55,3 +55,4 @@ obj-$(CONFIG_SRAM)		+= sram.o
>  obj-y				+= mic/
>  obj-$(CONFIG_GENWQE)		+= genwqe/
>  obj-$(CONFIG_ECHO)		+= echo/
> +obj-$(CONFIG_NXP_TDA8026_PHY)	+= tda8026.o
> diff --git a/drivers/misc/tda8026.c b/drivers/misc/tda8026.c
> new file mode 100644
> index 0000000..38df33e
> --- /dev/null
> +++ b/drivers/misc/tda8026.c
> @@ -0,0 +1,1258 @@
> +/*
> + * tda8026.c - TDA8026 PHY driver for NXP Smart card PHY
> + *
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/interrupt.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/gpio.h>
> +#include <linux/i2c.h>
> +#include <linux/mfd/core.h>
> +#include <linux/notifier.h>
> +#include <linux/sc_phy.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_device.h>
> +#include <linux/delay.h>

I think you just broke the build if this driver is enabled now right?

Not good :(

