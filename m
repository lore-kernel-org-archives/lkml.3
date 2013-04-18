Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936574Ab3DRUJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 16:09:44 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50527 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935906Ab3DRUJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 16:09:42 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19KG9HOMvwq7NtqppPy1t+h
Date: Thu, 18 Apr 2013 13:09:36 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: b-cousson@ti.com, nm@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        paul@pwsan.com, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] ARM: dts: omap4-panda: Add USB Host support
Message-ID: <20130418200935.GD10155@atomide.com>
References: <1366015721-25608-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366015721-25608-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130415 01:53]:
> Provide the RESET and Power regulators for the USB PHY,
> the USB Host port mode and the PHY device.
> 
> The USB PHY needs AUXCLK3 to operate. Provide this information
> as well.
> 
> Also provide pin multiplexer information for the USB host
> pins.
> 
> This patch depends on OMAP clock binding introduced in
> https://lkml.org/lkml/2013/4/12/407

Cool looks like EHCI works with this on my panda with linux
next booting with DT. One comment below.

Regards,

Tony

 
> CC: Benoît Cousson <b-cousson@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/boot/dts/omap4-panda-common.dtsi |   58 +++++++++++++++++++++++++++++
>  arch/arm/boot/dts/omap4.dtsi              |    5 ++
>  2 files changed, 63 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
> index 03bd60d..628f744 100644
> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
> @@ -54,6 +54,38 @@
>  			"AFML", "Line In",
>  			"AFMR", "Line In";
>  	};
> +
> +	/* HS USB Port 1 RESET */
> +	hsusb1_reset: hsusb1_reset_reg {
> +		compatible = "regulator-fixed";
> +		regulator-name = "hsusb1_reset";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio2 30 0>;	/* gpio_62 */
> +		startup-delay-us = <70000>;
> +		enable-active-high;
> +	};
> +
> +	/* HS USB Port 1 Power */
> +	hsusb1_power: hsusb1_power_reg {
> +		compatible = "regulator-fixed";
> +		regulator-name = "hsusb1_vbus";
> +		regulator-min-microvolt = <3300000>;
> +		regulator-max-microvolt = <3300000>;
> +		gpio = <&gpio1 1 0>;	/* gpio_1 */
> +		startup-delay-us = <70000>;
> +		enable-active-high;
> +	};
> +
> +	/* HS USB Host PHY on PORT 1 */
> +	hsusb1_phy: hsusb1_phy {
> +		compatible = "usb-nop-xceiv";
> +		reset-supply = <&hsusb1_reset>;
> +		vcc-supply = <&hsusb1_power>;
> +		clocks = <&auxclk3>;
> +		clock-names = "main_clk";
> +		clock-frequency = <19200000>;
> +	};
>  };
>  
>  &omap4_pmx_core {
> @@ -64,6 +96,7 @@
>  			&mcbsp1_pins
>  			&dss_hdmi_pins
>  			&tpd12s015_pins
> +			&hsusbb1_pins
>  	>;
>  
>  	twl6040_pins: pinmux_twl6040_pins {
> @@ -108,6 +141,23 @@
>  		>;
>  	};
>  
> +	hsusbb1_pins: pinmux_hsusbb1_pins {
> +		pinctrl-single,pins = <
> +			0x82 0x10C	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_clk INPUT | PULLDOWN */
> +			0x84 0x4	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_stp OUTPUT */
> +			0x86 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dir INPUT | PULLDOWN */
> +			0x88 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_nxt INPUT | PULLDOWN */
> +			0x8a 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat0 INPUT | PULLDOWN */
> +			0x8c 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat1 INPUT | PULLDOWN */
> +			0x8e 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat2 INPUT | PULLDOWN */
> +			0x90 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat3 INPUT | PULLDOWN */
> +			0x92 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat4 INPUT | PULLDOWN */
> +			0x94 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat5 INPUT | PULLDOWN */
> +			0x96 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat6 INPUT | PULLDOWN */
> +			0x98 0x104	/* USBB1_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat7 INPUT | PULLDOWN */
> +		>;
> +	};
> +
>  	i2c1_pins: pinmux_i2c1_pins {
>  		pinctrl-single,pins = <
>  			0xe2 0x118        /* i2c1_scl PULLUP | INPUTENABLE | MODE0 */

Looks like your comments are wrong above, it's not PULLDOWN? Also
the naming should be mode0name.modename to be consistent. Here's
what I dumped out, please check and replace spaces with tabs:

                        0x82 0x10c      /* usbb1_ulpitll_clk.usbb1_ulpiphy_clk gpio84 INPUT_PULLDOWN | MODE4 */
                        0x84 0x4        /* usbb1_ulpitll_stp.usbb1_ulpiphy_stp gpio85 OUTPUT | MODE4 */
                        0x86 0x104      /* usbb1_ulpitll_dir.usbb1_ulpiphy_dir gpio86 INPUT | MODE4 */
                        0x88 0x104      /* usbb1_ulpitll_nxt.usbb1_ulpiphy_nxt gpio87 INPUT | MODE4 */
                        0x8a 0x104      /* usbb1_ulpitll_dat0.usbb1_ulpiphy_dat0 gpio88 INPUT | MODE4 */
                        0x8c 0x104      /* usbb1_ulpitll_dat1.usbb1_ulpiphy_dat1 gpio89 INPUT | MODE4 */
                        0x8e 0x104      /* usbb1_ulpitll_dat2.usbb1_ulpiphy_dat2 gpio90 INPUT | MODE4 */
                        0x90 0x104      /* usbb1_ulpitll_dat3.usbb1_ulpiphy_dat3 gpio91 INPUT | MODE4 */
                        0x92 0x104      /* usbb1_ulpitll_dat4.usbb1_ulpiphy_dat4 gpio92 INPUT | MODE4 */
                        0x94 0x104      /* usbb1_ulpitll_dat5.usbb1_ulpiphy_dat5 gpio93 INPUT | MODE4 */
                        0x96 0x104      /* usbb1_ulpitll_dat6.usbb1_ulpiphy_dat6 gpio94 INPUT | MODE4 */
                        0x98 0x104      /* usbb1_ulpitll_dat7.usbb1_ulpiphy_dat7 gpio95 INPUT | MODE4 */

Then at some point soon we can just replace the mode value with DT
preprocessor automatically.

> @@ -249,3 +299,11 @@
>  	mode = <3>;
>  	power = <50>;
>  };
> +
> +&usbhshost {
> +	port1-mode = "ehci-phy";
> +};
> +
> +&usbhsehci {
> +	phys = <&hsusb1_phy>;
> +};
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index 2a56428..bd6036e 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -660,5 +660,10 @@
>  			ram-bits = <12>;
>  			ti,has-mailbox;
>  		};
> +
> +		auxclk3: auxclk3 {
> +			#clock-cells = <0>;
> +			compatible = "ti,omap-clock";
> +		};
>  	};
>  };
> -- 
> 1.7.4.1
> 
