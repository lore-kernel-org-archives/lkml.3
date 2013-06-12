Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab3FLWtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 18:49:50 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64290 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab3FLWts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 18:49:48 -0400
Date: Wed, 12 Jun 2013 15:49:52 -0700
From: Olof Johansson <olof@lixom.net>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: mach-moxart: add MOXA ART device tree files
Message-ID: <20130612224952.GB8146@quad.lixom.net>
References: <1371040448-28742-1-git-send-email-jonas.jensen@gmail.com>
 <1371040448-28742-3-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371040448-28742-3-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 02:34:07PM +0200, Jonas Jensen wrote:
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Hi,

You should add a bindings description for the MOXA SoC platforms, similar to
how others do it, under Documentation/devicetree/bindings/arm/.

Same goes for other device bindings below -- they all need to be added to the
bindings documentation. You might be better off removing some of them until you
post and merge the corresponding drivers.


> ---
>  arch/arm/boot/dts/Makefile            |    1 +
>  arch/arm/boot/dts/moxart-uc7112lx.dts |   89 +++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/moxart.dtsi         |   84 +++++++++++++++++++++++++++++++
>  3 files changed, 174 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/moxart-uc7112lx.dts
>  create mode 100644 arch/arm/boot/dts/moxart.dtsi
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 0d1e98b..059e6d3 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -217,6 +217,7 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
>  	wm8750-apc8750.dtb \
>  	wm8850-w70v2.dtb
>  dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb
> +dtb-$(CONFIG_ARCH_MOXART) += moxart-uc7112lx.dtb
>  
>  targets += dtbs
>  targets += $(dtb-y)
> diff --git a/arch/arm/boot/dts/moxart-uc7112lx.dts b/arch/arm/boot/dts/moxart-uc7112lx.dts
> new file mode 100644
> index 0000000..c2bb7dc
> --- /dev/null
> +++ b/arch/arm/boot/dts/moxart-uc7112lx.dts
> @@ -0,0 +1,89 @@
> +/* moxart-uc7112lx.dts - Device Tree file for MOXA UC-7112-LX
> + *
> + * Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
> + *
> + * Licensed under GPLv2 or later. */

*/ on new line


> +
> +/dts-v1/;
> +/include/ "moxart.dtsi"
> +
> +/ {
> +	model = "MOXA UC-7112-LX";
> +	compatible = "moxa,moxart-uc-7112-lx";

Is there a generic board design / eval board that you can have as a fallback
compatible value? That way you won't have to add every board to the table in
the c file.

> +
> +	memory {
> +		reg = <0x00000000 0x02000000>;
> +	};
> +
> +	flash@80000000,0 {
> +		/* JS28F128 J3D75 A9087684 - Numonyx Embedded Flash Memory (J3 v. D) */
> +		compatible = "numonyx,js28f128", "cfi-flash";
> +		reg = <0x80000000 0x01000000>;
> +		bank-width = <2>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		partition@0 {
> +			label = "bootloader";
> +			reg = <0x00000000 0x00040000>;
> +		};
> +		partition@40000 {
> +			label = "linux kernel";
> +			reg = <0x00040000 0x001C0000>;
> +		};
> +		partition@200000 {
> +			label = "root filesystem";
> +			reg = <0x00200000 0x00800000>;
> +		};
> +		partition@a00000 {
> +			label = "user filesystem";
> +			reg = <0x00a00000 0x00600000>;
> +		};
> +	};
> +
> +	mmc@98e00000 {
> +		compatible = "moxa,moxart-mmc";
> +		reg =	<0x98e00000 0x00001000>;
> +		interrupts = <5 0>;
> +		clock-names = "sys_clk";
> +		clocks = <&sys_clk>;
> +	};
> +
> +	mxser@98200040 {
> +		compatible = "moxa,moxart-mxser";
> +		reg =	<0x98200040 0x00000080>,	/* UART "3" base */
> +				<0x982000e4 0x00000080>,	/* UART mode base */
> +				<0x982000c0 0x00000020>;	/* UART interrupt vector */

Are there other registers for other devices inbetween, or could you just do one
large memory area here?

> +		interrupts = <31 1>;
> +	};
> +
> +	mac0: mac@90900000 {
> +		compatible = "moxa,moxart-mac0";
> +		reg =   <0x90900000 0x1000>,
> +				<0x80000050 0x5>;			/* MAC address stored on flash */

This is a pretty unusal way to indicate mac address location. While I suppose
it works, I'd like to get the device tree maintainers in the loop. ADding them
to cc.

Also, there should be a bindings doc for this device (and a driver)

I'm also surprised that you have a 5-byte mac address. 6 bytes is much more
common. :)

Finally, are the two MACs using the same driver? if so, using the same
compatible value makes more sense.

Also, while we're not super-strict about line lengths, please check your
tabbing and try to bring the comments in a bit.

> +		interrupts = <25 0>;
> +	};
> +
> +	mac1: mac@92000000 {
> +		compatible = "moxa,moxart-mac1";
> +		reg =   <0x92000000 0x1000>,
> +				<0x80000056 0x5>;			/* MAC address stored on flash */
> +		interrupts = <27 0>;
> +	};
> +
> +	uart0: uart@98200000 {
> +		compatible = "ns16550a";
> +		reg = <0x98200000 0x20>;
> +		interrupts = <31 0>;
> +		reg-shift = <2>;
> +		reg-io-width = <4>;
> +		clock-frequency = <14745600>;
> +		status = "okay";
> +	};
> +
> +	chosen {
> +		/* uncomment to use on board flash root
> +		bootargs = "console=ttyS0,115200n8 root=/dev/mtdblock2 rootfstype=jffs2 rw";
> +		*/

Just leave that out, I'd say.

> +		bootargs = "console=ttyS0,115200n8 root=/dev/mmcblk0p1 rw rootwait";
> +	};
> +};
> diff --git a/arch/arm/boot/dts/moxart.dtsi b/arch/arm/boot/dts/moxart.dtsi
> new file mode 100644
> index 0000000..debedb7
> --- /dev/null
> +++ b/arch/arm/boot/dts/moxart.dtsi
> @@ -0,0 +1,84 @@
> +/* moxart.dtsi - Device Tree Include file for MOXA ART family SoC
> + *
> + * Copyright (C) 2013 Jonas Jensen <jonas.jensen@gmail.com>
> + *
> + * Licensed under GPLv2 or later. */
> +
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	interrupt-parent = <&intc>;
> +
> +	cpus {
> +		cpu@0 {
> +			compatible = "faraday,fa526";

There are a couple of more properties required here. See recent postings on cpu
bindings.

> +		};
> +	};
> +
> +	clocks {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		osc: oscillator {
> +			#clock-cells = <0>;
> +			compatible = "fixed-clock";
> +			clock-frequency = <24000000>;
> +		};
> +	};
> +
> +	soc {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		reg = <0x90000000 0x10000000>;
> +		ranges;
> +
> +		intc: interrupt-controller@98800000 {
> +			compatible = "moxa,moxart-interrupt-controller";
> +			reg = <0x98800000 0x38>;
> +			interrupt-controller;
> +			#interrupt-cells = <2>;
> +			interrupt-mask = <0x00080000>;		/* single register vector, interrupts 0-31, 1s signify edge */

Very long line, here and below.

> +		};
> +
> +		timer: timer@98400000 {
> +			compatible = "moxa,moxart-timer";
> +			reg = <0x98400000 0x10>;
> +			interrupts = <19 1>;
> +		};
> +
> +		gpio: gpio@98700000 {
> +			compatible = "moxa,moxart-gpio";
> +			reg =	<0x98700000 0x1000>,
> +					<0x98100100 0x4>;			/*	Power Management Unit
> +													enable/disable pin 0-31 (32bit register) */
> +		};
> +
> +		rtc: rtc {
> +			compatible = "moxa,moxart-rtc";
> +		};
> +
> +		dma: dma@90500000 {
> +			compatible = "moxa,moxart-dma";
> +			reg = <0x90500000 0x1000>;
> +			interrupts = <24 0>;
> +		};
> +
> +		watchdog: watchdog@98500000 {
> +			compatible = "moxa,moxart-watchdog";
> +			reg = <0x98500000 0x1000>;
> +		};
> +
> +		pmu: pmu@98100000 {						/* Power Management Unit */
> +			compatible = "moxa,moxart-pmu";
> +			reg = <0x98100000 0x34>;			/* offset mul @ 0x30, val @ 0x0c (2 * 32 bit registers) */
> +			clocks {
> +				sys_clk: sys_clk {
> +					#clock-cells = <0>;
> +					compatible = "moxa,moxart-sysclk";
> +					clock-output-names = "sys_clk";
> +				};
> +			};
> +		};
> +	};
> +};
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
