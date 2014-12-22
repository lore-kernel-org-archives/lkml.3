Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaLVKDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 05:03:45 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:49434 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbaLVKDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 05:03:43 -0500
Date: Mon, 22 Dec 2014 11:02:22 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Evgeni Dobrev <evgeni@studio-punkt.com>
Cc: devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] add support for Seagate BlackArmor NAS220
Message-ID: <20141222100222.GF32716@lunn.ch>
References: <20141215203855.GA28940@anne>
 <20141222080445.GA15292@anne>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141222080445.GA15292@anne>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 09:04:45AM +0100, Evgeni Dobrev wrote:
> This patch adds support for Seagate BlackArmor NAS220.
> 
> The Seagate BlackArmor NAS 220 is a NAS system based on Marvell 88f6192. It has
> 32MB NAND and 128MB DRAM. It has two SATA slots, one Gigabit Ethernet port, two
> USB 2.0 ports, two buttons and three LEDs. There is a serial port available on
> the CN5 connector on the board (1 - TX, 4 - RX, 6 - GND).

Hi Evgeni

This looks good.  I have one minor comment. It would be nice to put
this information about the serial port also in the .dts file, by the
serial node.

       Andrew
> 
> The only functionality still not implemented is the bi-color led on the front
> panel (status). Pins mpp22 and mpp23 control this led. Setting mpp22 to high and
> mpp23 to low results in orange color. Setting mpp22 to low and mpp23 to high
> results in blue color.
> 
> The third led is wired to show the SATA activity on the two drives.
> 
> Signed-off-by: Evgeni Dobrev <evgeni@studio-punkt.com>
> ---
>  arch/arm/boot/dts/Makefile            |    1 +
>  arch/arm/boot/dts/kirkwood-nas220.dts |  158 +++++++++++++++++++++++++++++++++
>  2 files changed, 159 insertions(+)
>  create mode 100644 arch/arm/boot/dts/kirkwood-nas220.dts
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 38c89ca..8b9ad1d 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -132,6 +132,7 @@ dtb-$(CONFIG_MACH_KIRKWOOD) += kirkwood-b3.dtb \
>  	kirkwood-lsxhl.dtb \
>  	kirkwood-mplcec4.dtb \
>  	kirkwood-mv88f6281gtw-ge.dtb \
> +	kirkwood-nas220.dtb \
>  	kirkwood-net2big.dtb \
>  	kirkwood-net5big.dtb \
>  	kirkwood-netgear_readynas_duo_v2.dtb \
> diff --git a/arch/arm/boot/dts/kirkwood-nas220.dts b/arch/arm/boot/dts/kirkwood-nas220.dts
> new file mode 100644
> index 0000000..43c9bbc
> --- /dev/null
> +++ b/arch/arm/boot/dts/kirkwood-nas220.dts
> @@ -0,0 +1,158 @@
> +/*
> + * Device Tree file for Seagate BlackArmor NAS220
> + *
> + * Copyright (C) 2014 Evgeni Dobrev <evgeni@studio-punkt.com>
> + *
> + * Licensed under GPLv2 or later.
> + */
> +
> +/dts-v1/;
> +
> +#include <dt-bindings/gpio/gpio.h>
> +#include <dt-bindings/input/input.h>
> +#include "kirkwood.dtsi"
> +#include "kirkwood-6192.dtsi"
> +
> +/ {
> +	model = "Seagate NAS 220";
> +	compatible = "seagate,nas220","marvell,kirkwood-88f6192","marvell,kirkwood";
> +
> +	memory { /* 128 MB */
> +		device_type = "memory";
> +		reg = <0x00000000 0x8000000>;
> +	};
> +
> +	chosen {
> +		bootargs = "console=ttyS0,115200n8";
> +		stdout-path = &uart0;
> +	};
> +
> +	ocp@f1000000 {
> +		pinctrl: pin-controller@10000 {
> +			pinctrl-0 = <&pmx_uart0
> +				     &pmx_button_reset
> +				     &pmx_button_power>;
> +			pinctrl-names = "default";
> +
> +			pmx_act_sata0: pmx-act-sata0 {
> +				marvell,pins = "mpp15";
> +				marvell,function = "sata0";
> +			};
> +			pmx_act_sata1: pmx-act-sata1 {
> +				marvell,pins = "mpp16";
> +				marvell,function = "sata1";
> +			};
> +			pmx_power_sata0: pmx-power-sata0 {
> +				marvell,pins = "mpp24";
> +				marvell,function = "gpio";
> +			};
> +			pmx_power_sata1: pmx-power-sata1 {
> +				marvell,pins = "mpp28";
> +				marvell,function = "gpio";
> +			};
> +			pmx_button_reset: pmx-button-reset {
> +				marvell,pins = "mpp29";
> +				marvell,function = "gpio";
> +			};
> +			pmx_button_power: pmx-button-power {
> +				marvell,pins = "mpp26";
> +				marvell,function = "gpio";
> +			};
> +		};
> +
> +		serial@12000 {
> +			status = "okay";
> +		};
> +
> +		sata@80000 {
> +			status = "okay";
> +			nr-ports = <2>;
> +		};
> +
> +		i2c@11000 {
> +			status = "okay";
> +			adt7476: adt7476a@2e {
> +				compatible = "adi,adt7476";
> +				reg = <0x2e>;
> +			};
> +		};
> +	};
> +
> +	gpio_poweroff {
> +		compatible = "gpio-poweroff";
> +		gpios = <&gpio0 14 GPIO_ACTIVE_LOW>;
> +	};
> +
> +	gpio_keys {
> +		compatible = "gpio-keys";
> +		button@1{
> +			label = "Reset push button";
> +			linux,code = <KEY_POWER>;
> +			gpios = <&gpio0 29 GPIO_ACTIVE_HIGH>;
> +		};
> +		button@2{
> +			label = "Power push button";
> +			linux,code = <KEY_SLEEP>;
> +			gpios = <&gpio0 26 GPIO_ACTIVE_LOW>;
> +		};
> +	};
> +
> +	gpio-leds {
> +		compatible = "gpio-leds";
> +		blue-power {
> +			label = "nas220:blue:power";
> +			gpios = <&gpio0 12 GPIO_ACTIVE_HIGH>;
> +			linux,default-trigger = "default-on";
> +		};
> +	};
> +
> +	regulators {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		pinctrl-0 = <&pmx_power_sata0 &pmx_power_sata1>;
> +		pinctrl-names = "default";
> +
> +		sata0_power: regulator@1 {
> +			compatible = "regulator-fixed";
> +			reg = <1>;
> +			regulator-name = "SATA0 Power";
> +			regulator-min-microvolt = <5000000>;
> +			regulator-max-microvolt = <5000000>;
> +			enable-active-high;
> +			regulator-always-on;
> +			regulator-boot-on;
> +			gpio = <&gpio0 24 0>;
> +		};
> +
> +		sata1_power: regulator@2 {
> +			compatible = "regulator-fixed";
> +			reg = <2>;
> +			regulator-name = "SATA1 Power";
> +			regulator-min-microvolt = <5000000>;
> +			regulator-max-microvolt = <5000000>;
> +			enable-active-high;
> +			regulator-always-on;
> +			regulator-boot-on;
> +			gpio = <&gpio0 28 0>;
> +		};
> +	};
> +};
> +
> +&nand {
> +	status = "okay";
> +};
> +
> +&mdio {
> +	status = "okay";
> +	ethphy0: ethernet-phy@8 {
> +		 reg = <8>;
> +	 };
> +};
> +
> +&eth0 {
> +	status = "okay";
> +	ethernet0-port@0 {
> +		phy-handle = <&ethphy0>;
> +	};
> +};
> -- 
> 1.7.10.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
