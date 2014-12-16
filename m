Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaLPQhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:37:21 -0500
Received: from h1943130.stratoserver.net ([81.169.133.216]:48148 "EHLO
	studio-punkt.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaLPQhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:37:17 -0500
Date: Tue, 16 Dec 2014 17:37:14 +0100
From: Evgeni Dobrev <evgeni@studio-punkt.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Subject: Re: [PATCH 2/2] ARM: dts: kirkwood: add dts support for Seagate
 BlackArmor NAS220
Message-ID: <20141216163714.GE20170@anne>
References: <20141215203855.GA28940@anne>
 <20141216085645.GB1450@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216085645.GB1450@lunn.ch>
X-PGP-Key: http://evgeni.studio-punkt.com/pub.asc
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Dec 16, 2014 at 09:56:45AM +0100, Andrew Lunn wrote:
> On Mon, Dec 15, 2014 at 09:38:55PM +0100, Evgeni Dobrev wrote:
> > This patch adds support for Seagate BlackArmor NAS220.
> 
> Hi Evgeni
> 
> Thanks for the patch. It looks good apart from a few minor comments.
> 
> Please could you also Cc: the mvebu maintainers, otherwise you patch
> might net be seen by the right people. I added them.
> 

Thank you!

> > 
> > The Seagate BlackArmor NAS 220 is a NAS system based on Marvell 88f6192. It has 32MB NAND and 128MB DRAM. It has two SATA slots, one Gigabit Ethernet port, two USB 2.0 ports, two buttons and three LEDs. There is a serial port available on the CN5 connector on the board (1 - TX, 4 - RX, 6 - GND).
> > 
> 
> > The only functionality still not implemented is the bi-color led on
> > the front panel (status). Pins mpp22 and mpp23 control this
> > led. Setting mpp22 to high and mpp23 to low results in orange
> > color. Setting mpp22 to low and mpp23 to high results in blue color.
> 
> Any thoughts how you are going to handle this? Can you have both blue
> and orange at the same time be setting both high? Or are both then
> off?
> 

The LED can be either one of the two colors or off. Swapping the polarity 
on the two LED pins changes the color.

I am currently playing with the idea to create a multicolor LED kernel 
driver which is being controlled via GPIOs, but I still have not found 
the proper abstraction for it. The point is, that even though this 
functionality must currently be handled by user space (some
combination of sysfs writes and a shell script) at the moment, the rest
of the system is usable.

> > The third led is wired to show the SATA activity on the two drives.
> > 
> > Signed-off-by: Evgeni Dobrev <evgeni@studio-punkt.com>
> > ---
> >  arch/arm/boot/dts/Makefile            |    1 +
> >  arch/arm/boot/dts/kirkwood-nas220.dts |  182 +++++++++++++++++++++++++++++++++
> >  2 files changed, 183 insertions(+)
> >  create mode 100644 arch/arm/boot/dts/kirkwood-nas220.dts
> > 
> > diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> > index 38c89ca..8b9ad1d 100644
> > --- a/arch/arm/boot/dts/Makefile
> > +++ b/arch/arm/boot/dts/Makefile
> > @@ -132,6 +132,7 @@ dtb-$(CONFIG_MACH_KIRKWOOD) += kirkwood-b3.dtb \
> >  	kirkwood-lsxhl.dtb \
> >  	kirkwood-mplcec4.dtb \
> >  	kirkwood-mv88f6281gtw-ge.dtb \
> > +	kirkwood-nas220.dtb \
> >  	kirkwood-net2big.dtb \
> >  	kirkwood-net5big.dtb \
> >  	kirkwood-netgear_readynas_duo_v2.dtb \
> > diff --git a/arch/arm/boot/dts/kirkwood-nas220.dts b/arch/arm/boot/dts/kirkwood-nas220.dts
> > new file mode 100644
> > index 0000000..1de2ac3
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/kirkwood-nas220.dts
> > @@ -0,0 +1,182 @@
> > +/*
> > + * Device Tree file for Seagate BlackArmor NAS220
> > + *
> > + * Copyright (C) 2014 Evgeni Dobrev <evgeni@studio-punkt.com>
> > + *
> > + * Licensed under GPLv2 or later.
> > + */
> 
> Gregory is in the process of changing the license for the Marvell
> Armada SoCs. He is adding X11 license as well, so making it easier for
> other systems to reuse the DT blob. I want to see how easy it goes
> with Armada, but we may also do the same for Kirkwood sometime in the
> future. So maybe you can think about this and follow the discussion.
> 

I will do that.

> > +
> > +/dts-v1/;
> > +
> > +#include <dt-bindings/gpio/gpio.h>
> > +#include <dt-bindings/input/input.h>
> > +#include "kirkwood.dtsi"
> > +#include "kirkwood-6192.dtsi"
> > +
> > +/ {
> > +	model = "Seagate NAS 220";
> > +	compatible = "seagate,nas220", "marvell,kirkwood-88f6192", "marvell,kirkwood";
> > +
> > +	memory { /* 128 MB */
> > +		device_type = "memory";
> > +		reg = <0x00000000 0x8000000>;
> > +	};
> > +
> > +        chosen {
> > +                bootargs = "console=ttyS0,115200n8";
> > +		stdout-path = &uart0;
> > +        };
> 
> It looks like there is a mix of spaces and tabs. Please only use tabs
> in this file.
> 

I will fix this.

> > +
> > +	ocp@f1000000 {
> > +		pinctrl: pin-controller@10000 {
> > +			pinctrl-0 = < &pmx_uart0
> > +				&pmx_button_reset
> > +				&pmx_button_power
> > +				>;
> > +			pinctrl-names = "default";
> > +
> > +                        pmx_act_sata0: pmx-act-sata0 {
> > +                                marvell,pins = "mpp15";
> > +                                marvell,function = "sata0";
> > +                        };
> > +                        pmx_act_sata1: pmx-act-sata1 {
> > +                                marvell,pins = "mpp16";
> > +                                marvell,function = "sata1";
> > +                        };
> > +                        pmx_power_sata0: pmx-power-sata0 {
> > +                                marvell,pins = "mpp24";
> > +                                marvell,function = "gpio";
> > +                        };
> > +                        pmx_power_sata1: pmx-power-sata1 {
> > +                                marvell,pins = "mpp28";
> > +                                marvell,function = "gpio";
> > +                        };
> > +                        pmx_button_reset: pmx-button-reset {
> > +                                marvell,pins = "mpp29";
> > +                                marvell,function = "gpio";
> > +                        };
> > +                        pmx_button_power: pmx-button-power {
> > +                                marvell,pins = "mpp26";
> > +                                marvell,function = "gpio";
> > +                        };
> > +		};
> > +
> > +		serial@12000 {
> > +			status = "okay";
> > +		};
> > +
> > +                sata@80000 {
> > +                        nr-ports = <2>;
> > +                        status = "okay";
> > +                };
> > +
> > +		i2c@11000 {
> > +			status = "okay";
> > +			adt7476: adt7476a@2e {
> > +				compatible = "adi,adt7476";
> > +				reg = <0x2e>;
> > +			};
> > +		};
> > +	};
> > +
> > +	gpio_poweroff {
> > +		compatible = "gpio-poweroff";
> > +		gpios = <&gpio0 14 GPIO_ACTIVE_LOW>;
> > +	};
> > +
> > +	gpio_keys {
> > +		compatible = "gpio-keys";
> > +
> > +		button@1{
> > +			label = "Reset push button";
> > +			linux,code = <KEY_POWER>;
> > +			gpios = <&gpio0 29 GPIO_ACTIVE_HIGH>;
> > +		};
> > +		button@2{
> > +			label = "Power push button";
> > +			linux,code = <KEY_SLEEP>;
> > +			gpios = <&gpio0 26 GPIO_ACTIVE_LOW>;
> > +		};
> > +	};
> > +
> > +	gpio-leds {
> > +		compatible = "gpio-leds";
> > +
> > +		blue-power {
> > +			label = "nas220:blue:power";
> > +			gpios = <&gpio0 12 GPIO_ACTIVE_HIGH>;
> > +			linux,default-trigger = "default-on";
> > +		};
> > +	};
> > +
> > +        regulators {
> > +                compatible = "simple-bus";
> > +                #address-cells = <1>;
> > +                #size-cells = <0>;
> > +                pinctrl-0 = <&pmx_power_sata0 &pmx_power_sata1>;
> > +                pinctrl-names = "default";
> > +
> > +                sata0_power: regulator@1 {
> > +                        compatible = "regulator-fixed";
> > +                        reg = <1>;
> > +                        regulator-name = "SATA0 Power";
> > +                        regulator-min-microvolt = <5000000>;
> > +                        regulator-max-microvolt = <5000000>;
> > +                        enable-active-high;
> > +                        regulator-always-on;
> > +                        regulator-boot-on;
> > +                        gpio = <&gpio0 24 0>;
> > +                };
> > +
> > +                sata1_power: regulator@2 {
> > +                        compatible = "regulator-fixed";
> > +                        reg = <2>;
> > +                        regulator-name = "SATA1 Power";
> > +                        regulator-min-microvolt = <5000000>;
> > +                        regulator-max-microvolt = <5000000>;
> > +                        enable-active-high;
> > +                        regulator-always-on;
> > +                        regulator-boot-on;
> > +                        gpio = <&gpio0 28 0>;
> > +                };
> > +        };
> > +};
> > +
> > +&nand {
> > +	status = "okay";
> > +	partition@0 {
> > +		label = "uboot";
> > +		reg = <0x0 0xa0000>;
> > +		read-only;
> > +	};
> > +
> > +	partition@a0000 {
> > +		label = "env";
> > +		reg = <0xa0000 0x010000>;
> > +	};
> 
> Is there supposed to be a gap here?
> 

I mirror the layout of the stock firmware here. Actually I was not sure
how to handle the NAND layout. On one hand it has some merit if I keep
the original layout (and a lot of the *plug device trees do it), 
so that the system can be booted with it. On the other hand one can
pass the NAND layout relevant to his installation via the bootloader 
(either updating the DT blob, or via cmdline). Now that you ask I would 
prefer to remove the layout and leave it for the user to decide.

What would you recommend?

> > +
> > +	partition@c0000 {
> > +		label = "uimage";
> > +		reg = <0xc0000 0x500000>;
> > +	};
> > +
> > +	partition@5c0000 {
> > +		label = "rootfs";
> > +		reg = <0x5c0000 0x1a40000>;
> > +	};
> > +};
> > +
> > +&mdio {
> > +        status = "okay";
> > +        ethphy0: ethernet-phy@8 {
> > +                reg = <8>;
> > +        };
> > +};
> > +
> > +&eth0 {
> > +        status = "okay";
> > +        ethernet0-port@0 {
> > +                phy-handle = <&ethphy0>;
> > +        };
> > +};
> > +
> > -- 
> 
>   Andrew
> --

Thanks for reviewing!

evgeni

