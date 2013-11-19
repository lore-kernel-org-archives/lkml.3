Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab3KSVGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:06:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44718 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab3KSVG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:06:27 -0500
Message-ID: <528BD2AF.2030607@ti.com>
Date: Tue, 19 Nov 2013 15:05:51 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, <balbi@ti.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>
CC: <p.zabel@pengutronix.de>, <broonie@kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 09/10] ARM: dts: omap3-beagle-xm: Add USB Host support
References: <1380012836-29900-1-git-send-email-rogerq@ti.com> <1380012836-29900-10-git-send-email-rogerq@ti.com>
In-Reply-To: <1380012836-29900-10-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/24/2013 03:53 AM, Roger Quadros wrote:
> Provide RESET GPIO and Power regulator for the USB PHY,
> the USB Host port mode and the PHY device for the controller.
> Also provide pin multiplexer information for USB host pins.
> 
> We also relocate omap3_pmx_core pin definations so that they
> are close to omap3_pmx_wkup pin definations.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---

just using this thread, but a question ->

I am kernel * master                                   dec8e46 Merge
tag 'arc-v3.13-rc1-part2' of
git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc

and I see that VAUX2 which supplies USB_1V8[1] is not enabled -> I did
a quick patch and it did seem to work (Usb keyboard, networking, mouse
etc on my ehci ports seems to come up good) - any suggestions how we'd
like to handle this?

--- a/arch/arm/boot/dts/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
@@ -169,6 +169,14 @@
        bus-width = <8>;
 };

+&vaux2 {
+       regulator-name = "HubPower";
+       regulator-min-microvolt = <1800000>;
+       regulator-max-microvolt = <1800000>;
+       regulator-always-on;
+};
+
+

[1]
https://github.com/CircuitCo/BeagleBoard-xM-RevC/blob/master/BeagleBoard-xM_revC_SCH.pdf?raw=true

>  arch/arm/boot/dts/omap3-beagle-xm.dts |   65 ++++++++++++++++++++++++++++-----
>  1 files changed, 56 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
> index afdb164..b081f5a 100644
> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
> @@ -69,6 +69,23 @@
>  		};
>  
>  	};
> +
> +	/* HS USB Port 2 Power */
> +	hsusb2_power: hsusb2_power_reg {
> +		compatible = "regulator-fixed";
> +		regulator-name = "hsusb2_vbus";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&twl_gpio 18 0>;	/* GPIO LEDA */
> +		startup-delay-us = <70000>;
> +	};
> +
> +	/* HS USB Host PHY on PORT 2 */
> +	hsusb2_phy: hsusb2_phy {
> +		compatible = "usb-nop-xceiv";
> +		reset-gpios = <&gpio5 19 GPIO_ACTIVE_LOW>; /* gpio_147 */
> +		vcc-supply = <&hsusb2_power>;
> +	};
>  };
>  
>  &omap3_pmx_wkup {
> @@ -79,6 +96,37 @@
>  	};
>  };
>  
> +&omap3_pmx_core {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <
> +			&hsusbb2_pins
> +	>;
> +
> +	uart3_pins: pinmux_uart3_pins {
> +		pinctrl-single,pins = <
> +			0x16e (PIN_INPUT | PIN_OFF_WAKEUPENABLE | MUX_MODE0) /* uart3_rx_irrx.uart3_rx_irrx */
> +			0x170 (PIN_OUTPUT | MUX_MODE0) /* uart3_tx_irtx.uart3_tx_irtx OUTPUT | MODE0 */
> +		>;
> +	};
> +
> +	hsusbb2_pins: pinmux_hsusbb2_pins {
> +		pinctrl-single,pins = <
> +			0x5c0 (PIN_OUTPUT | MUX_MODE3)		/* etk_d10.hsusb2_clk */
> +			0x5c2 (PIN_OUTPUT | MUX_MODE3)		/* etk_d11.hsusb2_stp */
> +			0x5c4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d12.hsusb2_dir */
> +			0x5c6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d13.hsusb2_nxt */
> +			0x5c8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d14.hsusb2_data0 */
> +			0x5cA (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d15.hsusb2_data1 */
> +			0x1a4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi1_cs3.hsusb2_data2 */
> +			0x1a6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_clk.hsusb2_data7 */
> +			0x1a8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_simo.hsusb2_data4 */
> +			0x1aa (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_somi.hsusb2_data5 */
> +			0x1ac (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs0.hsusb2_data6 */
> +			0x1ae (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs1.hsusb2_data3 */
> +		>;
> +	};
> +};
> +
>  &i2c1 {
>  	clock-frequency = <2600000>;
>  
> @@ -148,15 +196,6 @@
>  	power = <50>;
>  };
>  
> -&omap3_pmx_core {
> -	uart3_pins: pinmux_uart3_pins {
> -		pinctrl-single,pins = <
> -			0x16e (PIN_INPUT | PIN_OFF_WAKEUPENABLE | MUX_MODE0) /* uart3_rx_irrx.uart3_rx_irrx */
> -			0x170 (PIN_OUTPUT | MUX_MODE0) /* uart3_tx_irtx.uart3_tx_irtx OUTPUT | MODE0 */
> -		>;
> -	};
> -};
> -
>  &uart3 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&uart3_pins>;
> @@ -166,3 +205,11 @@
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&gpio1_pins>;
>  };
> +
> +&usbhshost {
> +	port2-mode = "ehci-phy";
> +};
> +
> +&usbhsehci {
> +	phys = <0 &hsusb2_phy>;
> +};
> 


-- 
Regards,
Nishanth Menon
