Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaDQOzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:55:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56262 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750882AbaDQOzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:55:33 -0400
Date: Thu, 17 Apr 2014 16:55:29 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: at91/dt: define sam9x5 clocks
Message-ID: <20140417145529.GN2813@piout.net>
References: <1397464994-27267-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397464994-27267-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397464994-27267-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/2014 at 10:43:12 +0200, Boris Brezillon wrote :
> Define sam9x5 clocks in sam9x5 dt files and make use of them in peripheral
> definitions.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  arch/arm/boot/dts/at91sam9x5.dtsi        | 355 ++++++++++++++++++++++++++++++-
>  arch/arm/boot/dts/at91sam9x5_can.dtsi    |  31 +++
>  arch/arm/boot/dts/at91sam9x5_isi.dtsi    |  26 +++
>  arch/arm/boot/dts/at91sam9x5_lcd.dtsi    |  26 +++
>  arch/arm/boot/dts/at91sam9x5_macb0.dtsi  |  11 +
>  arch/arm/boot/dts/at91sam9x5_macb1.dtsi  |  11 +
>  arch/arm/boot/dts/at91sam9x5_usart3.dtsi |  11 +
>  7 files changed, 470 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/at91sam9x5_can.dtsi
>  create mode 100644 arch/arm/boot/dts/at91sam9x5_isi.dtsi
>  create mode 100644 arch/arm/boot/dts/at91sam9x5_lcd.dtsi
> 
> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
> index fc13c92..723daf6 100644
> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> @@ -14,6 +14,7 @@
>  #include <dt-bindings/pinctrl/at91.h>
>  #include <dt-bindings/interrupt-controller/irq.h>
>  #include <dt-bindings/gpio/gpio.h>
> +#include <dt-bindings/clk/at91.h>
>  
>  / {
>  	model = "Atmel AT91SAM9x5 family SoC";
> @@ -51,6 +52,24 @@
>  		reg = <0x20000000 0x10000000>;
>  	};
>  
> +	slow_xtal: slow_xtal {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <0>;
> +	};
> +
> +	main_xtal: main_xtal {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <0>;
> +	};
> +
> +	adc_op_clk: adc_op_clk{
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <5000000>;
> +	};
> +
>  	ahb {
>  		compatible = "simple-bus";
>  		#address-cells = <1>;
> @@ -77,8 +96,272 @@
>  			};
>  
>  			pmc: pmc@fffffc00 {
> -				compatible = "atmel,at91rm9200-pmc";
> +				compatible = "atmel,at91sam9x5-pmc";
>  				reg = <0xfffffc00 0x100>;
> +				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				interrupt-controller;
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				#interrupt-cells = <1>;
> +
> +				main_rc_osc: main_rc_osc {
> +					compatible = "atmel,at91sam9x5-clk-main-rc-osc";
> +					#clock-cells = <0>;
> +					interrupts-extended = <&pmc AT91_PMC_MOSCRCS>;
> +					clock-frequency = <12000000>;
> +					clock-accuracy = <50000000>;
> +				};
> +
> +				main_osc: main_osc {
> +					compatible = "atmel,at91sam9x5-clk-main-osc";

I know I acked the patch but after having a closer look, I think you are
using a compatible string that doesn't exist at all here.

> +					#clock-cells = <0>;
> +					interrupts-extended = <&pmc AT91_PMC_MOSCS>;
> +					clocks = <&main_xtal>;
> +				};
> +
> +				main: mainck {
> +					compatible = "atmel,at91sam9x5-clk-main";
> +					#clock-cells = <0>;
> +					interrupts-extended = <&pmc AT91_PMC_MOSCSELS>;
> +					clocks = <&main_rc_osc>, <&main_osc>;
> +				};
> +
> +				plla: pllack {
> +					compatible = "atmel,at91rm9200-clk-pll";
> +					#clock-cells = <0>;
> +					interrupts-extended = <&pmc AT91_PMC_LOCKA>;
> +					clocks = <&main>;
> +					reg = <0>;
> +					atmel,clk-input-range = <2000000 32000000>;
> +					#atmel,pll-clk-output-range-cells = <4>;
> +					atmel,pll-clk-output-ranges = <745000000 800000000 0 0
> +								       695000000 750000000 1 0
> +								       645000000 700000000 2 0
> +								       595000000 650000000 3 0
> +								       545000000 600000000 0 1
> +								       495000000 555000000 1 1
> +								       445000000 500000000 1 2
> +								       400000000 450000000 1 3>;
> +				};
> +
> +				plladiv: plladivck {
> +					compatible = "atmel,at91sam9x5-clk-plldiv";
> +					#clock-cells = <0>;
> +					clocks = <&plla>;
> +				};
> +
> +				utmi: utmick {
> +					compatible = "atmel,at91sam9x5-clk-utmi";
> +					#clock-cells = <0>;
> +					interrupts-extended = <&pmc AT91_PMC_LOCKU>;
> +					clocks = <&main>;
> +				};
> +
> +				mck: masterck {
> +					compatible = "atmel,at91sam9x5-clk-master";
> +					#clock-cells = <0>;
> +					interrupts-extended = <&pmc AT91_PMC_MCKRDY>;
> +					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>;
> +					atmel,clk-output-range = <0 133333333>;
> +					atmel,clk-divisors = <1 2 4 3>;
> +					atmel,master-clk-have-div3-pres;
> +				};
> +
> +				usb: usbck {
> +					compatible = "atmel,at91sam9x5-clk-usb";
> +					#clock-cells = <0>;
> +					clocks = <&plladiv>, <&utmi>;
> +				};
> +
> +				prog: progck {
> +					compatible = "atmel,at91sam9x5-clk-programmable";
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +					interrupt-parent = <&pmc>;
> +					clocks = <&clk32k>, <&main>, <&plladiv>, <&utmi>, <&mck>;
> +
> +					prog0: prog0 {
> +						#clock-cells = <0>;
> +						reg = <0>;
> +						interrupts = <AT91_PMC_PCKRDY(0)>;
> +					};
> +
> +					prog1: prog1 {
> +						#clock-cells = <0>;
> +						reg = <1>;
> +						interrupts = <AT91_PMC_PCKRDY(1)>;
> +					};
> +				};
> +
> +				smd: smdclk {
> +					compatible = "atmel,at91sam9x5-clk-smd";
> +					#clock-cells = <0>;
> +					clocks = <&plladiv>, <&utmi>;
> +				};
> +
> +				systemck {
> +					compatible = "atmel,at91rm9200-clk-system";
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +
> +					ddrck: ddrck {
> +						#clock-cells = <0>;
> +						reg = <2>;
> +						clocks = <&mck>;
> +					};
> +
> +					smdck: smdck {
> +						#clock-cells = <0>;
> +						reg = <4>;
> +						clocks = <&smd>;
> +					};
> +
> +					uhpck: uhpck {
> +						#clock-cells = <0>;
> +						reg = <6>;
> +						clocks = <&usb>;
> +					};
> +
> +					udpck: udpck {
> +						#clock-cells = <0>;
> +						reg = <7>;
> +						clocks = <&usb>;
> +					};
> +
> +					pck0: pck0 {
> +						#clock-cells = <0>;
> +						reg = <8>;
> +						clocks = <&prog0>;
> +					};
> +
> +					pck1: pck1 {
> +						#clock-cells = <0>;
> +						reg = <9>;
> +						clocks = <&prog1>;
> +					};
> +				};
> +
> +				periphck {
> +					compatible = "atmel,at91sam9x5-clk-peripheral";
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +					clocks = <&mck>;
> +
> +					pioAB_clk: pioAB_clk {
> +						#clock-cells = <0>;
> +						reg = <2>;
> +					};
> +
> +					pioCD_clk: pioCD_clk {
> +						#clock-cells = <0>;
> +						reg = <3>;
> +					};
> +
> +					smd_clk: smd_clk {
> +						#clock-cells = <0>;
> +						reg = <4>;
> +					};
> +
> +					usart0_clk: usart0_clk {
> +						#clock-cells = <0>;
> +						reg = <5>;
> +					};
> +
> +					usart1_clk: usart1_clk {
> +						#clock-cells = <0>;
> +						reg = <6>;
> +					};
> +
> +					usart2_clk: usart2_clk {
> +						#clock-cells = <0>;
> +						reg = <7>;
> +					};
> +
> +					twi0_clk: twi0_clk {
> +						reg = <9>;
> +						#clock-cells = <0>;
> +					};
> +
> +					twi1_clk: twi1_clk {
> +						#clock-cells = <0>;
> +						reg = <10>;
> +					};
> +
> +					twi2_clk: twi2_clk {
> +						#clock-cells = <0>;
> +						reg = <11>;
> +					};
> +
> +					mci0_clk: mci0_clk {
> +						#clock-cells = <0>;
> +						reg = <12>;
> +					};
> +
> +					spi0_clk: spi0_clk {
> +						#clock-cells = <0>;
> +						reg = <13>;
> +					};
> +
> +					spi1_clk: spi1_clk {
> +						#clock-cells = <0>;
> +						reg = <14>;
> +					};
> +
> +					uart0_clk: uart0_clk {
> +						#clock-cells = <0>;
> +						reg = <15>;
> +					};
> +
> +					uart1_clk: uart1_clk {
> +						#clock-cells = <0>;
> +						reg = <16>;
> +					};
> +
> +					tcb0_clk: tcb0_clk {
> +						#clock-cells = <0>;
> +						reg = <17>;
> +					};
> +
> +					pwm_clk: pwm_clk {
> +						#clock-cells = <0>;
> +						reg = <18>;
> +					};
> +
> +					adc_clk: adc_clk {
> +						#clock-cells = <0>;
> +						reg = <19>;
> +					};
> +
> +					dma0_clk: dma0_clk {
> +						#clock-cells = <0>;
> +						reg = <20>;
> +					};
> +
> +					dma1_clk: dma1_clk {
> +						#clock-cells = <0>;
> +						reg = <21>;
> +					};
> +
> +					uhphs_clk: uhphs_clk {
> +						#clock-cells = <0>;
> +						reg = <22>;
> +					};
> +
> +					udphs_clk: udphs_clk {
> +						#clock-cells = <0>;
> +						reg = <23>;
> +					};
> +
> +					mci1_clk: mci1_clk {
> +						#clock-cells = <0>;
> +						reg = <26>;
> +					};
> +
> +					ssc0_clk: ssc0_clk {
> +						#clock-cells = <0>;
> +						reg = <28>;
> +					};
> +				};
>  			};
>  
>  			rstc@fffffe00 {
> @@ -95,18 +378,47 @@
>  				compatible = "atmel,at91sam9260-pit";
>  				reg = <0xfffffe30 0xf>;
>  				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				clocks = <&mck>;
> +			};
> +
> +			sckc@fffffe50 {
> +				compatible = "atmel,at91sam9x5-sckc";
> +				reg = <0xfffffe50 0x4>;
> +
> +				slow_osc: slow_osc {
> +					compatible = "atmel,at91sam9x5-clk-slow-osc";
> +					#clock-cells = <0>;
> +					clocks = <&slow_xtal>;
> +				};
> +
> +				slow_rc_osc: slow_rc_osc {
> +					compatible = "atmel,at91sam9x5-clk-slow-rc-osc";
> +					#clock-cells = <0>;
> +					clock-frequency = <32768>;
> +					clock-accuracy = <50000000>;
> +				};
> +
> +				clk32k: slck {
> +					compatible = "atmel,at91sam9x5-clk-slow";
> +					#clock-cells = <0>;
> +					clocks = <&slow_rc_osc>, <&slow_osc>;
> +				};
>  			};
>  
>  			tcb0: timer@f8008000 {
>  				compatible = "atmel,at91sam9x5-tcb";
>  				reg = <0xf8008000 0x100>;
>  				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 0>;
> +				clocks = <&tcb0_clk>;
> +				clock-names = "t0_clk";
>  			};
>  
>  			tcb1: timer@f800c000 {
>  				compatible = "atmel,at91sam9x5-tcb";
>  				reg = <0xf800c000 0x100>;
>  				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 0>;
> +				clocks = <&tcb0_clk>;
> +				clock-names = "t0_clk";
>  			};
>  
>  			dma0: dma-controller@ffffec00 {
> @@ -114,6 +426,8 @@
>  				reg = <0xffffec00 0x200>;
>  				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
>  				#dma-cells = <2>;
> +				clocks = <&dma0_clk>;
> +				clock-names = "dma_clk";
>  			};
>  
>  			dma1: dma-controller@ffffee00 {
> @@ -121,6 +435,8 @@
>  				reg = <0xffffee00 0x200>;
>  				interrupts = <21 IRQ_TYPE_LEVEL_HIGH 0>;
>  				#dma-cells = <2>;
> +				clocks = <&dma1_clk>;
> +				clock-names = "dma_clk";
>  			};
>  
>  			pinctrl@fffff400 {
> @@ -453,6 +769,7 @@
>  					gpio-controller;
>  					interrupt-controller;
>  					#interrupt-cells = <2>;
> +					clocks = <&pioAB_clk>;
>  				};
>  
>  				pioB: gpio@fffff600 {
> @@ -464,6 +781,7 @@
>  					#gpio-lines = <19>;
>  					interrupt-controller;
>  					#interrupt-cells = <2>;
> +					clocks = <&pioAB_clk>;
>  				};
>  
>  				pioC: gpio@fffff800 {
> @@ -474,6 +792,7 @@
>  					gpio-controller;
>  					interrupt-controller;
>  					#interrupt-cells = <2>;
> +					clocks = <&pioCD_clk>;
>  				};
>  
>  				pioD: gpio@fffffa00 {
> @@ -485,6 +804,7 @@
>  					#gpio-lines = <22>;
>  					interrupt-controller;
>  					#interrupt-cells = <2>;
> +					clocks = <&pioCD_clk>;
>  				};
>  			};
>  
> @@ -497,6 +817,8 @@
>  				dma-names = "tx", "rx";
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
> +				clocks = <&ssc0_clk>;
> +				clock-names = "pclk";
>  				status = "disabled";
>  			};
>  
> @@ -507,6 +829,8 @@
>  				dmas = <&dma0 1 AT91_DMA_CFG_PER_ID(0)>;
>  				dma-names = "rxtx";
>  				pinctrl-names = "default";
> +				clocks = <&mci0_clk>;
> +				clock-names = "mci_clk";
>  				#address-cells = <1>;
>  				#size-cells = <0>;
>  				status = "disabled";
> @@ -519,6 +843,8 @@
>  				dmas = <&dma1 1 AT91_DMA_CFG_PER_ID(0)>;
>  				dma-names = "rxtx";
>  				pinctrl-names = "default";
> +				clocks = <&mci1_clk>;
> +				clock-names = "mci_clk";
>  				#address-cells = <1>;
>  				#size-cells = <0>;
>  				status = "disabled";
> @@ -530,6 +856,8 @@
>  				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_dbgu>;
> +				clocks = <&mck>;
> +				clock-names = "usart";
>  				status = "disabled";
>  			};
>  
> @@ -539,6 +867,8 @@
>  				interrupts = <5 IRQ_TYPE_LEVEL_HIGH 5>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_usart0>;
> +				clocks = <&usart0_clk>;
> +				clock-names = "usart";
>  				status = "disabled";
>  			};
>  
> @@ -548,6 +878,8 @@
>  				interrupts = <6 IRQ_TYPE_LEVEL_HIGH 5>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_usart1>;
> +				clocks = <&usart1_clk>;
> +				clock-names = "usart";
>  				status = "disabled";
>  			};
>  
> @@ -557,6 +889,8 @@
>  				interrupts = <7 IRQ_TYPE_LEVEL_HIGH 5>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_usart2>;
> +				clocks = <&usart2_clk>;
> +				clock-names = "usart";
>  				status = "disabled";
>  			};
>  
> @@ -571,6 +905,7 @@
>  				#size-cells = <0>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_i2c0>;
> +				clocks = <&twi0_clk>;
>  				status = "disabled";
>  			};
>  
> @@ -585,6 +920,7 @@
>  				#size-cells = <0>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_i2c1>;
> +				clocks = <&twi1_clk>;
>  				status = "disabled";
>  			};
>  
> @@ -599,6 +935,7 @@
>  				#size-cells = <0>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_i2c2>;
> +				clocks = <&twi2_clk>;
>  				status = "disabled";
>  			};
>  
> @@ -608,6 +945,8 @@
>  				interrupts = <15 IRQ_TYPE_LEVEL_HIGH 5>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_uart0>;
> +				clocks = <&uart0_clk>;
> +				clock-names = "usart";
>  				status = "disabled";
>  			};
>  
> @@ -617,6 +956,8 @@
>  				interrupts = <16 IRQ_TYPE_LEVEL_HIGH 5>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_uart1>;
> +				clocks = <&uart1_clk>;
> +				clock-names = "usart";
>  				status = "disabled";
>  			};
>  
> @@ -626,6 +967,9 @@
>  				compatible = "atmel,at91sam9260-adc";
>  				reg = <0xf804c000 0x100>;
>  				interrupts = <19 IRQ_TYPE_LEVEL_HIGH 0>;
> +				clocks = <&adc_clk>,
> +					 <&adc_op_clk>;
> +				clock-names = "adc_clk", "adc_op_clk";
>  				atmel,adc-use-external-triggers;
>  				atmel,adc-channels-used = <0xffff>;
>  				atmel,adc-vref = <3300>;
> @@ -673,6 +1017,8 @@
>  				dma-names = "tx", "rx";
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_spi0>;
> +				clocks = <&spi0_clk>;
> +				clock-names = "spi_clk";
>  				status = "disabled";
>  			};
>  
> @@ -687,6 +1033,8 @@
>  				dma-names = "tx", "rx";
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_spi1>;
> +				clocks = <&spi1_clk>;
> +				clock-names = "spi_clk";
>  				status = "disabled";
>  			};
>  
> @@ -805,6 +1153,9 @@
>  			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
>  			reg = <0x00600000 0x100000>;
>  			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
> +			clocks = <&usb>, <&uhphs_clk>, <&udphs_clk>,
> +				 <&uhpck>;
> +			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
>  			status = "disabled";
>  		};
>  
> @@ -812,6 +1163,8 @@
>  			compatible = "atmel,at91sam9g45-ehci", "usb-ehci";
>  			reg = <0x00700000 0x100000>;
>  			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
> +			clocks = <&usb>, <&uhphs_clk>, <&uhpck>;
> +			clock-names = "usb_clk", "ehci_clk", "uhpck";
>  			status = "disabled";
>  		};
>  	};
> diff --git a/arch/arm/boot/dts/at91sam9x5_can.dtsi b/arch/arm/boot/dts/at91sam9x5_can.dtsi
> new file mode 100644
> index 0000000..f44ab77
> --- /dev/null
> +++ b/arch/arm/boot/dts/at91sam9x5_can.dtsi
> @@ -0,0 +1,31 @@
> +/*
> + * at91sam9x5_macb0.dtsi - Device Tree Include file for AT91SAM9x5 SoC with 1
> + * Ethernet interface.
> + *
> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * Licensed under GPLv2.
> + */
> +
> +#include <dt-bindings/pinctrl/at91.h>
> +#include <dt-bindings/interrupt-controller/irq.h>
> +
> +/ {
> +	ahb {
> +		apb {
> +			pmc: pmc@fffffc00 {
> +				periphck {
> +					can0_clk: can0_clk {
> +						#clock-cells = <0>;
> +						reg = <29>;
> +					};
> +
> +                                        can1_clk: can1_clk {
> +                                                #clock-cells = <0>;
> +                                                reg = <30>;
> +                                        };
> +				};
> +			};
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/at91sam9x5_isi.dtsi b/arch/arm/boot/dts/at91sam9x5_isi.dtsi
> new file mode 100644
> index 0000000..98bc877
> --- /dev/null
> +++ b/arch/arm/boot/dts/at91sam9x5_isi.dtsi
> @@ -0,0 +1,26 @@
> +/*
> + * at91sam9x5_isi.dtsi - Device Tree Include file for AT91SAM9x5 SoC with an
> + * Image Sensor Interface.
> + *
> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * Licensed under GPLv2.
> + */
> +
> +#include <dt-bindings/pinctrl/at91.h>
> +#include <dt-bindings/interrupt-controller/irq.h>
> +
> +/ {
> +	ahb {
> +		apb {
> +			pmc: pmc@fffffc00 {
> +				periphck {
> +					isi_clk: isi_clk {
> +						#clock-cells = <0>;
> +						reg = <25>;
> +					};
> +				};
> +			};
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/at91sam9x5_lcd.dtsi b/arch/arm/boot/dts/at91sam9x5_lcd.dtsi
> new file mode 100644
> index 0000000..485302e
> --- /dev/null
> +++ b/arch/arm/boot/dts/at91sam9x5_lcd.dtsi
> @@ -0,0 +1,26 @@
> +/*
> + * at91sam9x5_lcd.dtsi - Device Tree Include file for AT91SAM9x5 SoC with an
> + * LCD controller.
> + *
> + * Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
> + *
> + * Licensed under GPLv2.
> + */
> +
> +#include <dt-bindings/pinctrl/at91.h>
> +#include <dt-bindings/interrupt-controller/irq.h>
> +
> +/ {
> +	ahb {
> +		apb {
> +			pmc: pmc@fffffc00 {
> +				periphck {
> +					lcdc_clk: lcdc_clk {
> +						#clock-cells = <0>;
> +						reg = <25>;
> +					};
> +				};
> +			};
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/at91sam9x5_macb0.dtsi b/arch/arm/boot/dts/at91sam9x5_macb0.dtsi
> index 55731ff..57e89d1 100644
> --- a/arch/arm/boot/dts/at91sam9x5_macb0.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5_macb0.dtsi
> @@ -43,12 +43,23 @@
>  				};
>  			};
>  
> +			pmc: pmc@fffffc00 {
> +				periphck {
> +					macb0_clk: macb0_clk {
> +						#clock-cells = <0>;
> +						reg = <24>;
> +					};
> +				};
> +			};
> +
>  			macb0: ethernet@f802c000 {
>  				compatible = "cdns,at32ap7000-macb", "cdns,macb";
>  				reg = <0xf802c000 0x100>;
>  				interrupts = <24 IRQ_TYPE_LEVEL_HIGH 3>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_macb0_rmii>;
> +				clocks = <&macb0_clk>, <&macb0_clk>;
> +				clock-names = "hclk", "pclk";
>  				status = "disabled";
>  			};
>  		};
> diff --git a/arch/arm/boot/dts/at91sam9x5_macb1.dtsi b/arch/arm/boot/dts/at91sam9x5_macb1.dtsi
> index 77425a6..663676c 100644
> --- a/arch/arm/boot/dts/at91sam9x5_macb1.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5_macb1.dtsi
> @@ -31,12 +31,23 @@
>  				};
>  			};
>  
> +			pmc: pmc@fffffc00 {
> +				periphck {
> +					macb1_clk: macb1_clk {
> +						#clock-cells = <0>;
> +						reg = <27>;
> +					};
> +				};
> +			};
> +
>  			macb1: ethernet@f8030000 {
>  				compatible = "cdns,at32ap7000-macb", "cdns,macb";
>  				reg = <0xf8030000 0x100>;
>  				interrupts = <27 IRQ_TYPE_LEVEL_HIGH 3>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_macb1_rmii>;
> +				clocks = <&macb1_clk>, <&macb1_clk>;
> +				clock-names = "hclk", "pclk";
>  				status = "disabled";
>  			};
>  		};
> diff --git a/arch/arm/boot/dts/at91sam9x5_usart3.dtsi b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
> index 6801106..140217a5 100644
> --- a/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5_usart3.dtsi
> @@ -42,12 +42,23 @@
>  				};
>  			};
>  
> +			pmc: pmc@fffffc00 {
> +				periphck {
> +					usart3_clk: usart3_clk {
> +						#clock-cells = <0>;
> +						reg = <8>;
> +					};
> +				};
> +			};
> +
>  			usart3: serial@f8028000 {
>  				compatible = "atmel,at91sam9260-usart";
>  				reg = <0xf8028000 0x200>;
>  				interrupts = <8 IRQ_TYPE_LEVEL_HIGH 5>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_usart3>;
> +				clocks = <&usart3_clk>;
> +				clock-names = "usart";
>  				status = "disabled";
>  			};
>  		};
> -- 
> 1.8.3.2
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
