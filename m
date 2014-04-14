Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaDNM20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:28:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49569 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbaDNM2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:28:23 -0400
Message-ID: <534BD447.1080909@ti.com>
Date: Mon, 14 Apr 2014 17:57:51 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <kgene.kim@samsung.com>,
        <t.figa@samsung.com>, <k.debski@samsung.com>, <jg1.han@samsung.com>,
        <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH V4 1/5] phy: Add new Exynos5 USB 3.0 PHY driver
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com> <1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 08 April 2014 08:06 PM, Vivek Gautam wrote:
> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
> The new driver uses the generic PHY framework and will interact
> with DWC3 controller present on Exynos5 series of SoCs.
> Thereby, removing old phy-samsung-usb3 driver and related code
> used untill now which was based on usb/phy framework.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  .../devicetree/bindings/phy/samsung-phy.txt        |   42 ++
>  drivers/phy/Kconfig                                |   11 +
>  drivers/phy/Makefile                               |    1 +
>  drivers/phy/phy-exynos5-usbdrd.c                   |  668 ++++++++++++++++++++
>  4 files changed, 722 insertions(+)
>  create mode 100644 drivers/phy/phy-exynos5-usbdrd.c
> 
> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> index 28f9edb..6d99ba9 100644
> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> @@ -74,3 +74,45 @@ phy-consumer@12340000 {
>  
>  Refer to DT bindings documentation of particular PHY consumer devices for more
>  information about required PHYs and the way of specification.
> +
> +Samsung Exynos5 SoC series USB DRD PHY controller
> +--------------------------------------------------
> +
> +Required properties:
> +- compatible : Should be set to one of the following supported values:
> +	- "samsung,exynos5250-usbdrd-phy" - for exynos5250 SoC,
> +	- "samsung,exynos5420-usbdrd-phy" - for exynos5420 SoC.
> +- reg : Register offset and length of USB DRD PHY register set;
> +- clocks: Clock IDs array as required by the controller
> +- clock-names: names of clocks correseponding to IDs in the clock property;
> +	       Required clocks:
> +	- phy: main PHY clock (same as USB DRD controller i.e. DWC3 IP clock),
> +	       used for register access.
> +	- ref: PHY's reference clock (usually crystal clock), associated by
> +	       phy name, used to determine bit values for clock settings
> +	       register.
> +	Additional clock required for Exynos5420:
> +	- usb30_sclk_100m: Additional special clock used for PHY operation
> +			   depicted as 'sclk_usbphy30' in CMU of Exynos5420.
> +- samsung,syscon-phandle: phandle for syscon interface, which is used to
> +			  control pmu registers for power isolation.
> +- samsung,pmu-offset: phy power control register offset to pmu-system-controller
> +		      base.
> +- #phy-cells : from the generic PHY bindings, must be 1;
> +
> +For "samsung,exynos5250-usbdrd-phy" and "samsung,exynos5420-usbdrd-phy"
> +compatible PHYs, the second cell in the PHY specifier identifies the
> +PHY id, which is interpreted as follows:
> +  0 - UTMI+ type phy,
> +  1 - PIPE3 type phy,
> +
> +Example:
> +	usb3_phy: usbphy@12100000 {
> +		compatible = "samsung,exynos5250-usbdrd-phy";
> +		reg = <0x12100000 0x100>;
> +		clocks = <&clock 286>, <&clock 1>;
> +		clock-names = "phy", "usb3phy_refclk";
> +		samsung,syscon-phandle = <&pmu_syscon>;
> +		samsung,pmu-offset = <0x704>;
> +		#phy-cells = <1>;
> +	};
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 8d3c49c..d955a05 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -166,4 +166,15 @@ config PHY_XGENE
>  	help
>  	  This option enables support for APM X-Gene SoC multi-purpose PHY.
>  
> +config PHY_EXYNOS5_USBDRD
> +	tristate "Exynos5 SoC series USB DRD PHY driver"
> +	depends on ARCH_EXYNOS5 && OF
> +	depends on HAS_IOMEM
> +	select GENERIC_PHY
> +	select MFD_SYSCON

Lets try to avoid select in Kconfig. We've got enough problems with that.
> +	help
> +	  Enable USB DRD PHY support for Exynos 5 SoC series.
> +	  This driver provides PHY interface for USB 3.0 DRD controller
> +	  present on Exynos5 SoC series.
> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 2faf78e..31baa0c 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -18,3 +18,4 @@ obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
>  obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
> +obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+= phy-exynos5-usbdrd.o
> diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
> new file mode 100644
> index 0000000..ff54a7c
> --- /dev/null
> +++ b/drivers/phy/phy-exynos5-usbdrd.c
> @@ -0,0 +1,668 @@
> +/*
> + * Samsung EXYNOS5 SoC series USB DRD PHY driver
> + *
> + * Phy provider for USB 3.0 DRD controller on Exynos5 SoC series
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.

2014 already ;-)
> + * Author: Vivek Gautam <gautam.vivek@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
.
.
<sniip>
.
.

> +
> +/*
> + * Sets the pipe3 phy's clk as EXTREFCLK (XXTI) which is internal clock
> + * from clock core. Further sets multiplier values and spread spectrum
> + * clock settings for SuperSpeed operations.
> + */
> +static unsigned int
> +exynos5_usbdrd_pipe3_set_refclk(struct phy_usb_instance *inst)
> +{
> +	static u32 reg;
> +	struct exynos5_usbdrd_phy *phy_drd = to_usbdrd_phy(inst);
> +
> +	/* restore any previous reference clock settings */
> +	reg = phy_drd->refclk_reg;

Why don't we just read back from the register instead?
> +
> +	/* Use EXTREFCLK as ref clock */
> +	reg &= ~PHYCLKRST_REFCLKSEL_MASK;
> +	reg |=	PHYCLKRST_REFCLKSEL_EXT_REFCLK;
> +
> +	/* FSEL settings corresponding to reference clock */
> +	reg &= ~PHYCLKRST_FSEL_PIPE_MASK |
> +		PHYCLKRST_MPLL_MULTIPLIER_MASK |
> +		PHYCLKRST_SSC_REFCLKSEL_MASK;
> +	switch (phy_drd->extrefclk) {
> +	case EXYNOS5_FSEL_50MHZ:
> +		reg |= (PHYCLKRST_MPLL_MULTIPLIER_50M_REF |
> +			PHYCLKRST_SSC_REFCLKSEL(0x00));
> +		break;
> +	case EXYNOS5_FSEL_24MHZ:
> +		reg |= (PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF |
> +			PHYCLKRST_SSC_REFCLKSEL(0x88));
> +		break;
> +	case EXYNOS5_FSEL_20MHZ:
> +		reg |= (PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF |
> +			PHYCLKRST_SSC_REFCLKSEL(0x00));
> +		break;
> +	case EXYNOS5_FSEL_19MHZ2:
> +		reg |= (PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF |
> +			PHYCLKRST_SSC_REFCLKSEL(0x88));
> +		break;
> +	default:
> +		dev_dbg(phy_drd->dev, "unsupported ref clk\n");
> +		break;
> +	}
> +
> +	/* save refclk settings for multiple phy inits */
> +	phy_drd->refclk_reg = reg;
> +
> +	return reg;
> +}
> +
> +/*
> + * Sets the utmi phy's clk as EXTREFCLK (XXTI) which is internal clock
> + * from clock core. Further sets the FSEL values for HighSpeed operations.
> + */
> +static unsigned int
> +exynos5_usbdrd_utmi_set_refclk(struct phy_usb_instance *inst)
> +{
> +	static u32 reg;
> +	struct exynos5_usbdrd_phy *phy_drd = to_usbdrd_phy(inst);
> +
> +	reg = phy_drd->refclk_reg;

same here..

Thanks
Kishon
