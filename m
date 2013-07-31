Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab3GaBhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 21:37:02 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:56423 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab3GaBhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 21:37:00 -0400
Message-ID: <51F86A2E.10505@elopez.com.ar>
Date: Tue, 30 Jul 2013 22:36:46 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: sun6i: Enable clock support in the DTSI
References: <1375195462-19566-1-git-send-email-maxime.ripard@free-electrons.com> <1375195462-19566-5-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1375195462-19566-5-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Overall this looks good to me, but I have some small comments:

El 30/07/13 11:44, Maxime Ripard escribió:
> Now that the clock driver has support for the A31 clocks, we can add
> them to the DTSI and start using them in the relevant hardware blocks.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/boot/dts/sun6i-a31.dtsi | 137 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 127 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
> index 0d13dc6..c6a3a91 100644
> --- a/arch/arm/boot/dts/sun6i-a31.dtsi
> +++ b/arch/arm/boot/dts/sun6i-a31.dtsi
> @@ -51,13 +51,130 @@
>  
>  	clocks {
>  		#address-cells = <1>;
> -		#size-cells = <0>;
> +		#size-cells = <1>;
> +		ranges;
>  
> -		osc: oscillator {
> +		osc24M: hosc {

Please use osc24M and osc32k instead of hosc and losc, respectively.

>  			#clock-cells = <0>;
>  			compatible = "fixed-clock";
>  			clock-frequency = <24000000>;

Is osc24M not gatable on A31?

>  		};
> +
> +		osc32k: losc {
> +			#clock-cells = <0>;
> +			compatible = "fixed-clock";
> +			clock-frequency = <32768>;
> +		};
> +
> +		pll1: pll1@01c20000 {
> +			#clock-cells = <0>;
> +			compatible = "allwinner,sun6i-pll1-clk";
> +			reg = <0x01c20000 0x4>;
> +			clocks = <&osc24M>;
> +		};
> +
> +		/*
> +		 * This is a dummy clock, to be used as placeholder on
> +		 * other mux clocks when a specific parent clock is not
> +		 * yet implemented. It should be dropped when the driver
> +		 * is complete.
> +		 */
> +		pll6: pll6 {
> +			#clock-cells = <0>;
> +			compatible = "fixed-clock";
> +			clock-frequency = <0>;
> +		};
> +
> +		cpu: cpu@01c20050 {
> +			#clock-cells = <0>;
> +			compatible = "allwinner,sun4i-cpu-clk";
> +			reg = <0x01c20050 0x4>;
> +			clocks = <&osc32k>, <&osc24M>, <&pll1>, <&pll1>;

Listing pll1 twice doesn't sound correct, but vendor code seems to
indicate so. A comment to clarify it's not a typo would be good I think.

> +		};
> +
> +		axi: axi@01c20050 {
> +			#clock-cells = <0>;
> +			compatible = "allwinner,sun4i-axi-clk";
> +			reg = <0x01c20050 0x4>;
> +			clocks = <&cpu>;
> +		};
> +
> +		ahb1_mux: ahb1_mux@01c20054 {
> +			#clock-cells = <0>;
> +			compatible = "allwinner,sun6i-ahb1-mux-clk";
> +			reg = <0x01c20054 0x4>;
> +			clocks = <&osc32k>, <&osc24M>, <&axi>, <&pll6>;
> +		};
> +
> +		ahb1: ahb1@01c20054 {
> +			#clock-cells = <0>;
> +			compatible = "allwinner,sun4i-ahb-clk";
> +			reg = <0x01c20054 0x4>;
> +			clocks = <&ahb1_mux>;
> +		};

Depending on when this lands, I believe these two above could be merged
into one with the refactoring introduced on my patchset.

> +
> +		ahb1_gates: ahb1_gates@01c20060 {
> +			#clock-cells = <1>;
> +			compatible = "allwinner,sun6i-a31-ahb1-gates-clk";
> +			reg = <0x01c20060 0x8>;
> +			clocks = <&ahb1>;
> +			clock-output-names = "ahb1_mipidsi", "ahb1_ss",
> +					"ahb1_dma", "ahb1_mmc0", "ahb1_mmc1",
> +					"ahb1_mmc2", "ahb1_mmc3", "ahb1_nand1",
> +					"ahb1_nand0", "ahb1_sdram",
> +					"ahb1_gmac", "ahb1_ts", "ahb1_hstimer",
> +					"ahb1_spi0", "ahb1_spi1", "ahb1_spi2",
> +					"ahb1_spi3", "ahb1_otg", "ahb1_ehci0",
> +					"ahb1_ehci1", "ahb1_ohci0",
> +					"ahb1_ohci1", "ahb1_ohci2", "ahb1_ve",
> +					"ahb1_lcd0", "ahb1_lcd1", "ahb1_csi",
> +					"ahb1_hdmi", "ahb1_de0", "ahb1_de1",
> +					"ahb1_fe0", "ahb1_fe1", "ahb1_mp",
> +					"ahb1_gpu", "ahb1_deu0", "ahb1_deu1",
> +					"ahb1_drc0", "ahb1_drc1";
> +		};
> +
> +		apb1: apb1@01c20054 {
> +			#clock-cells = <0>;
> +			compatible = "allwinner,sun4i-apb0-clk";
> +			reg = <0x01c20054 0x4>;
> +			clocks = <&ahb1>;
> +		};
> +
> +		apb1_gates: apb1_gates@01c20060 {
> +			#clock-cells = <1>;
> +			compatible = "allwinner,sun6i-a31-apb1-gates-clk";
> +			reg = <0x01c20068 0x4>;
> +			clocks = <&apb1>;
> +			clock-output-names = "apb1_codec", "apb1_digital_mic",
> +					"apb1_pio", "apb1_daudio0",
> +					"apb1_daudio1";
> +		};
> +
> +		apb2_mux: apb2_mux@01c20058 {
> +			#clock-cells = <0>;
> +			compatible = "allwinner,sun4i-apb1-mux-clk";
> +			reg = <0x01c20058 0x4>;
> +			clocks = <&osc32k>, <&osc24M>, <&pll6>, <&pll6>;
> +		};
> +
> +		apb2: apb2@01c20058 {
> +			#clock-cells = <0>;
> +			compatible = "allwinner,sun6i-apb2-div-clk";
> +			reg = <0x01c20058 0x4>;
> +			clocks = <&apb2_mux>;
> +		};

Ditto for apb2_mux and apb2.

> +
> +		apb2_gates: apb2_gates@01c2006c {
> +			#clock-cells = <1>;
> +			compatible = "allwinner,sun6i-a31-apb2-gates-clk";
> +			reg = <0x01c2006c 0x8>;
> +			clocks = <&apb2>;
> +			clock-output-names = "apb2_i2c0", "apb2_i2c1",
> +					"apb2_i2c2", "apb2_i2c3", "apb2_uart0",
> +					"apb2_uart1", "apb2_uart2", "apb2_uart3",
> +					"apb2_uart4", "apb2_uart5";
> +		};
>  	};
>  
>  	soc@01c20000 {
> @@ -69,7 +186,7 @@
>  			compatible = "allwinner,sun6i-a31-pinctrl";
>  			reg = <0x01c20800 0x400>;
>  			interrupts = <0 11 1>, <0 15 1>, <0 16 1>, <0 17 1>;
> -			clocks = <&osc>;
> +			clocks = <&apb1_gates 5>;
>  			gpio-controller;
>  			interrupt-controller;
>  			#address-cells = <1>;
> @@ -92,7 +209,7 @@
>  				     <0 20 1>,
>  				     <0 21 1>,
>  				     <0 22 1>;
> -			clocks = <&osc>;
> +			clocks = <&osc24M>;
>  		};
>  
>  		wdt1: watchdog@01c20ca0 {
> @@ -106,7 +223,7 @@
>  			interrupts = <0 0 1>;
>  			reg-shift = <2>;
>  			reg-io-width = <4>;
> -			clocks = <&osc>;
> +			clocks = <&apb2_gates 16>;
>  			status = "disabled";
>  		};
>  
> @@ -116,7 +233,7 @@
>  			interrupts = <0 1 1>;
>  			reg-shift = <2>;
>  			reg-io-width = <4>;
> -			clocks = <&osc>;
> +			clocks = <&apb2_gates 17>;
>  			status = "disabled";
>  		};
>  
> @@ -126,7 +243,7 @@
>  			interrupts = <0 2 1>;
>  			reg-shift = <2>;
>  			reg-io-width = <4>;
> -			clocks = <&osc>;
> +			clocks = <&apb2_gates 18>;
>  			status = "disabled";
>  		};
>  
> @@ -136,7 +253,7 @@
>  			interrupts = <0 3 1>;
>  			reg-shift = <2>;
>  			reg-io-width = <4>;
> -			clocks = <&osc>;
> +			clocks = <&apb2_gates 19>;
>  			status = "disabled";
>  		};
>  
> @@ -146,7 +263,7 @@
>  			interrupts = <0 4 1>;
>  			reg-shift = <2>;
>  			reg-io-width = <4>;
> -			clocks = <&osc>;
> +			clocks = <&apb2_gates 20>;
>  			status = "disabled";
>  		};
>  
> @@ -156,7 +273,7 @@
>  			interrupts = <0 5 1>;
>  			reg-shift = <2>;
>  			reg-io-width = <4>;
> -			clocks = <&osc>;
> +			clocks = <&apb2_gates 21>;
>  			status = "disabled";
>  		};
>  
> 

Thanks for working on this!

Emilio
