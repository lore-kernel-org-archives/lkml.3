Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3GNW20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 18:28:26 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39344 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab3GNW2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 18:28:24 -0400
Date: Mon, 15 Jul 2013 01:28:19 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tony Lindgren <tony@atomide.com>, b-cousson@ti.com, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v2] N900: add device tree
Message-ID: <20130714222819.GB3296@blackmetal.musicnaut.iki.fi>
References: <20130613161418.GJ8164@atomide.com>
 <20130613230808.GA14876@amd.pavel.ucw.cz>
 <20130614055629.GM8164@atomide.com>
 <20130614212816.GA31768@atrey.karlin.mff.cuni.cz>
 <20130617111031.GQ20992@atomide.com>
 <20130701211753.GC15318@amd.pavel.ucw.cz>
 <20130704171939.GA27374@blackmetal.musicnaut.iki.fi>
 <20130704202145.GB10752@amd.pavel.ucw.cz>
 <20130704203256.GB27374@blackmetal.musicnaut.iki.fi>
 <20130713121709.GC16473@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130713121709.GC16473@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 13, 2013 at 02:17:09PM +0200, Pavel Machek wrote:
> 
> This adds device tree with neccessary support to boot with functional
> video (on both emulator and real N900 device).
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

You can also add:

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>

Thanks,

A.

> 
> ---
> 
> From v1: Aaro wants just GPLv2, so I did that. I re-enabled parts that
> can be enabled on 3.10, and tested it on that kernel.
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index f0895c5..1950aed 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -141,6 +141,7 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
>  	omap3-devkit8000.dtb \
>  	omap3-beagle-xm.dtb \
>  	omap3-evm.dtb \
> +	omap3-n900.dtb \
>  	omap3-tobi.dtb \
>  	omap3-igep0020.dtb \
>  	omap3-igep0030.dtb \
> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
> new file mode 100644
> index 0000000..fb461bf
> --- /dev/null
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -0,0 +1,92 @@
> +/*
> + * Copyright (C) 2013 Pavel Machek <pavel@ucw.cz>
> + * Copyright 2013 Aaro Koskinen <aaro.koskinen@iki.fi>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +/dts-v1/;
> +
> +/include/ "omap34xx.dtsi"
> +
> +/ {
> +	model = "Nokia N900";
> +	compatible = "nokia,omap3-n900", "ti,omap3";
> +
> +	cpus {
> +		cpu@0 {
> +			cpu0-supply = <&vcc>;
> +		};
> +	};
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x80000000 0x10000000>; /* 256 MB */
> +	};
> +
> +};
> +
> +&i2c1 {
> +	clock-frequency = <2200000>;
> +
> +	twl: twl@48 {
> +		reg = <0x48>;
> +		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
> +		interrupt-parent = <&intc>;
> +	};
> +};
> +
> +/include/ "twl4030.dtsi"
> +
> +&twl_gpio {
> +	ti,pullups	= <0x0>;
> +	ti,pulldowns	= <0x03ff3f>; /* BIT(0..5) | BIT(8..17) */
> +};
> +
> +&i2c2 {
> +	clock-frequency = <400000>;
> +};
> +
> +&i2c3 {
> +	clock-frequency = <100000>;
> +};
> +
> +&mmc1 {
> +	status = "disabled";
> +};
> +
> +&mmc2 {
> +	status = "disabled";
> +};
> +
> +&mmc3 {
> +	status = "disabled";
> +};
> +
> +&mcspi1 {
> +	// For some reason, touchscreen is neccessary for screen to work at 
> +	// all on real hw. It works well without it on emulator.
> +	//
> +	// Also... order in the device tree actually matters here.
> +	tsc2005@0 {
> +		compatible = "tsc2005";
> +		spi-max-frequency = <6000000>;
> +		reg = <0>;
> +	};
> +	mipid@2 {
> +		compatible = "acx565akm";
> +		spi-max-frequency = <6000000>;
> +		reg = <2>;
> +		// turbo_mode = 0,
> +		// cs_per_word = 0
> +	};
> +};
> +
> +&usb_otg_hs {
> +	interface-type = <0>;
> +	usb-phy = <&usb2_phy>;
> +	mode = <2>;
> +	power = <50>;
> +};
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
