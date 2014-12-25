Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaLYNIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 08:08:22 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63526 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaLYNIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 08:08:17 -0500
Message-ID: <549C0C3C.8060601@gmail.com>
Date: Thu, 25 Dec 2014 14:08:12 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
To: Evgeni Dobrev <evgeni@studio-punkt.com>, devicetree@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 1/1] add support for Seagate BlackArmor NAS220
References: <20141215203855.GA28940@anne> <20141222125750.GA29163@anne>
In-Reply-To: <20141222125750.GA29163@anne>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.12.2014 13:57, Evgeni Dobrev wrote:
> This patch adds support for Seagate BlackArmor NAS220.
>
> The Seagate BlackArmor NAS 220 is a NAS system based on Marvell 88f6192. It has
> 32MB NAND and 128MB DRAM. It has two SATA slots, one Gigabit Ethernet port, two
> USB 2.0 ports, two buttons and three LEDs. There is a serial port available on
> the CN5 connector on the board (1 - TX, 4 - RX, 6 - GND).
>
> The only functionality still not implemented is the bi-color led on the front
> panel (status). Pins mpp22 and mpp23 control this led. Setting mpp22 to high and
> mpp23 to low results in orange color. Setting mpp22 to low and mpp23 to high
> results in blue color.
>
> The third led is wired to show the SATA activity on the two drives.
>
> Signed-off-by: Evgeni Dobrev <evgeni@studio-punkt.com>

Evgeni,

sorry for the late review, but I do have some nits that should
remove some inconsistencies. If we don't do it now, we'd never
change that later.

> ---
>   arch/arm/boot/dts/Makefile            |    1 +
>   arch/arm/boot/dts/kirkwood-nas220.dts |  166 +++++++++++++++++++++++++++++++++
>   2 files changed, 167 insertions(+)
>   create mode 100644 arch/arm/boot/dts/kirkwood-nas220.dts
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 38c89ca..8b9ad1d 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -132,6 +132,7 @@ dtb-$(CONFIG_MACH_KIRKWOOD) += kirkwood-b3.dtb \
>   	kirkwood-lsxhl.dtb \
>   	kirkwood-mplcec4.dtb \
>   	kirkwood-mv88f6281gtw-ge.dtb \
> +	kirkwood-nas220.dtb \

I am not too happy with choosing "nas220" as the base name for the
board. Can we make it a little bit more specific like
"seagate-nas220" or "blackarmor-nas220" ?

>   	kirkwood-net2big.dtb \
>   	kirkwood-net5big.dtb \
>   	kirkwood-netgear_readynas_duo_v2.dtb \
> diff --git a/arch/arm/boot/dts/kirkwood-nas220.dts b/arch/arm/boot/dts/kirkwood-nas220.dts
> new file mode 100644
> index 0000000..8175f3d
> --- /dev/null
> +++ b/arch/arm/boot/dts/kirkwood-nas220.dts
> @@ -0,0 +1,166 @@
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

model = "Seagate BlackArmor NAS220";

i.e. choose the same spelling in comment above and model name here.

> +	compatible = "seagate,nas220","marvell,kirkwood-88f6192","marvell,kirkwood";

compatible should reflect the chosen base name above.

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

v3.19 should already have a label for the common pinctrl node.
Please do not replay the bus structure but use a node reference
like &nand and friends below.

> +			pinctrl-0 = <&pmx_uart0
> +				     &pmx_button_reset
> +				     &pmx_button_power>;
> +			pinctrl-names = "default";
> +
> +			pmx_act_sata0: pmx-act-sata0 {
> +				marvell,pins = "mpp15";
> +				marvell,function = "sata0";
> +			};

Insert a blank line between each of the pmx_foo nodes?

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
> +

Remove extra blank line.

> +		/*
> +		 * Serial port routed to connector CN5
> +		 *
> +		 * pin 1 - TX
> +		 * pin 4 - RX
> +		 * pin 6 - GND
> +		 */

Nice! Can you also clarify if TX/RX are as seen from the SoC or
remote end?

> +		serial@12000 {

Please use node references where possible, IIRC v3.19 should have
labels for serial, sata, and i2c. Avoid to replay the bus structure.

> +			status = "okay";
> +		};
> +
> +		sata@80000 {
> +			status = "okay";
> +			nr-ports = <2>;

I need some update from the other mvebu guys here: Do we have SATA
PHY nodes in v3.19 for Kirkwood already? If so, please update to the
new binding.

> +		};
> +
> +		i2c@11000 {
> +			status = "okay";
> +			adt7476: adt7476a@2e {

I know we have a lot of bad examples, but: node names should reflect
device function, not device name, i.e.

adt7476: thermal@2e {
	...
};

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

Add a blank line between nodes.

> +		button@1{
> +			label = "Reset push button";

Reduce label to "Reset" and "Power" below.

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

Add a blank line between nodes.

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

Hmm, do you need "regulator-always-on" when it is GPIO controlled?
Also, gpio property could use GPIO_ACTIVE_HIGH/LOW here too.

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

ditto.

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

Remove extra space before brace.

> +};
> +
> +&eth0 {
> +	status = "okay";
> +	ethernet0-port@0 {
> +		phy-handle = <&ethphy0>;
> +	};
> +};
>

Overall, this look fine to me, with the nits taken care of

Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Thanks!

