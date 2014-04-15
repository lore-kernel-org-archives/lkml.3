Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaDOMqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:46:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:58086 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbaDOMpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:45:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Anders Berg <anders.berg@lsi.com>, olof@lixom.net, mturquette@linaro.org,
        mark.rutland@arm.com, dbaryshkov@gmail.com, linus.walleij@linaro.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ARM: dts: Device tree for AXM55xx.
Date: Tue, 15 Apr 2014 14:45:48 +0200
Message-ID: <8344066.GP0Bf5lvlE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <02c006a6fc64131df82981abbc1c71c7af52254e.1397552154.git.anders.berg@lsi.com>
References: <cover.1397552154.git.anders.berg@lsi.com> <02c006a6fc64131df82981abbc1c71c7af52254e.1397552154.git.anders.berg@lsi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:xC/EcE84HJrqmq6b6firi1uhCxh+z5H/3iBGdSCsuiz
 J5UNqiPNMbD5i+TgE0z+l0ap5LB5zgAUgcmJrhGGCqXkXNZDo3
 jpisT8cUghPMvn4C0OQ82yeIXcqF3EJb2f3EyNE9h96JUOn0kW
 BoE6HZn/dtBehI5Mqg+3t4ejXI8YUa1rQk/asfEu8lsxQTCo0n
 /co3/OPKoLYGIdex7YT2V6hQLFv0xjtkbdtmV/vCPnHjGjqCfl
 vbgdNdxj7j4Pd2GeNta+HE9xCt+ERn0KgIFbCVLXwWWPv4xC1N
 9SLes8kPCeqay9x13p+jrRDp5ithZdD8AcC5jWGRWwWI6LTDMh
 B00pg6mnH6zf/a51ySXw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 April 2014 14:06:11 Anders Berg wrote:
> diff --git a/arch/arm/boot/dts/axm5516-amarillo.dts b/arch/arm/boot/dts/axm5516-amarillo.dts
> new file mode 100644
> index 0000000..1760d6c
> --- /dev/null
> +++ b/arch/arm/boot/dts/axm5516-amarillo.dts
> @@ -0,0 +1,51 @@
> +/*
> + * arch/arm/boot/dts/axm5516-amarillo.dts
> + *
> + * Copyright (C) 2013 LSI
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */

It's better to use a permissive license such as the BSD license for dts files,
so they can be shared with other OSs.

The situation with the clocks is still very strange: either the bindings
are all in need of update, or you got all devices wrong:

> +			serial0: uart@2010080000 {
> +				compatible = "arm,pl011", "arm,primecell";
> +				reg = <0x20 0x10080000 0 0x1000>;
> +				interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clk_per>, <&clk_per>;
> +				clock-names = "uartclk", "apb_pclk";
> +				status = "disabled";
> +			};

"uartclk" is not a valid string for pl011, as per binding:

| - clocks:  When present, must refer to exactly one clock named
|           "apb_pclk"

I do see that a lot of platforms do the same thing you have here, not
sure who is wrong.

> +			timer0: timer@2010091000 {
> +				compatible = "arm,sp804", "arm,primecell";
> +				reg = <0x20 0x10091000 0 0x1000>;
> +				interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clk_per>, <&clk_per>;
> +				clock-names = "timclken1", "apb_pclk";

Citing the binding:

| - clocks: clocks driving the dual timer hardware. This list should be 1 or 3
|        clocks. With 3 clocks, the order is timer0 clock, timer1 clock,
|        apb_pclk. A single clock can also be specified if the same clock is
|        used for all clock inputs.

I think you only want to have one clock here and make that the "apb_pclk".

> +			gpio0: gpio@2010092000 {
> +				#gpio-cells = <2>;
> +				compatible = "arm,pl061", "arm,primecell";
> +				gpio-controller;
> +				reg = <0x20 0x10092000 0x00 0x1000>;
> +				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
> +					     <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks = <&clk_per>;
> +				clock-names = "apb_pclk";
> +				status = "disabled";

The pl061 binding does not specify any clocks at all. Do we need to update
that?

	Arnd
