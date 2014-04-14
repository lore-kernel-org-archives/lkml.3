Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaDNI5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:57:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57015 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751282AbaDNI5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:57:00 -0400
Date: Mon, 14 Apr 2014 10:56:43 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Bo Shen <voice.shen@atmel.com>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: at91/dt: define sam9n12 clocks
Message-ID: <20140414085643.GK2967@piout.net>
References: <1397463399-11771-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397463399-11771-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397463399-11771-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/2014 at 10:16:37 +0200, Boris Brezillon wrote :
> Define sam9n12 clocks and make use of them in peripheral definitions.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  arch/arm/boot/dts/at91sam9n12.dtsi | 350 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 348 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
> index 9f04808..4d036a3 100644
> --- a/arch/arm/boot/dts/at91sam9n12.dtsi
> +++ b/arch/arm/boot/dts/at91sam9n12.dtsi
> @@ -12,6 +12,7 @@
>  #include <dt-bindings/pinctrl/at91.h>
>  #include <dt-bindings/interrupt-controller/irq.h>
>  #include <dt-bindings/gpio/gpio.h>
> +#include <dt-bindings/clk/at91.h>
>  
>  / {
>  	model = "Atmel AT91SAM9N12 SoC";
> @@ -49,6 +50,20 @@
>  		reg = <0x20000000 0x10000000>;
>  	};
>  
> +	clocks {
> +		slow_xtal: slow_xtal {
> +			compatible = "fixed-clock";
> +			#clock-cells = <0>;
> +			clock-frequency = <0>;
> +		};
> +
> +		main_xtal: main_xtal {
> +			compatible = "fixed-clock";
> +			#clock-cells = <0>;
> +			clock-frequency = <0>;
> +		};

You can put those two xtal nodes directly under root, as mentioned by
Mark Rutland:

"A "clocks" container is non-standard, and not guarantee to probe. The
fact these clocks probe currently is an artifact of the current
organisation of Linux rather than any conscious decision."

> +	};
> +
>  	ahb {
>  		compatible = "simple-bus";
>  		#address-cells = <1>;
> @@ -75,8 +90,280 @@
>  			};
>  
>  			pmc: pmc@fffffc00 {
> -				compatible = "atmel,at91rm9200-pmc";
> -				reg = <0xfffffc00 0x100>;
> +				compatible = "atmel,at91sam9n12-pmc";
> +				reg = <0xfffffc00 0x200>;
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
> +					atmel,pll-clk-output-ranges = <745000000 800000000 0 0>,
> +								      <695000000 750000000 1 0>,
> +								      <645000000 700000000 2 0>,
> +								      <595000000 650000000 3 0>,
> +								      <545000000 600000000 0 1>,
> +								      <495000000 555000000 1 1>,
> +								      <445000000 500000000 1 2>,
> +								      <400000000 450000000 1 3>;
> +				};
> +
> +				plladiv: plladivck {
> +					compatible = "atmel,at91sam9x5-clk-plldiv";
> +					#clock-cells = <0>;
> +					clocks = <&plla>;
> +				};
> +
> +				pllb: pllbck {
> +					compatible = "atmel,at91rm9200-clk-pll";
> +					#clock-cells = <0>;
> +					interrupts-extended = <&pmc AT91_PMC_LOCKB>;
> +					clocks = <&main>;
> +					reg = <1>;
> +					atmel,clk-input-range = <2000000 32000000>;
> +					#atmel,pll-clk-output-range-cells = <3>;
> +					atmel,pll-clk-output-ranges = <30000000 100000000 0>;
> +				};
> +
> +				mck: masterck {
> +					compatible = "atmel,at91sam9x5-clk-master";
> +					#clock-cells = <0>;
> +					interrupts-extended = <&pmc AT91_PMC_MCKRDY>;
> +					clocks = <&clk32k>, <&main>, <&plladiv>, <&pllb>;
> +					atmel,clk-output-range = <0 133333333>;
> +					atmel,clk-divisors = <1 2 4 3>;
> +					atmel,master-clk-have-div3-pres;
> +				};
> +
> +				usb: usbck {
> +					compatible = "atmel,at91sam9n12-clk-usb";
> +					#clock-cells = <0>;
> +					clocks = <&pllb>;
> +				};
> +
> +				prog: progck {
> +					compatible = "atmel,at91sam9x5-clk-programmable";
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +					interrupt-parent = <&pmc>;
> +					clocks = <&clk32k>, <&main>, <&plladiv>, <&pllb>, <&mck>;
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
> +					lcdck: lcdck {
> +						#clock-cells = <0>;
> +						reg = <3>;
> +						clocks = <&mck>;
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
> +					fuse_clk: fuse_clk {
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
> +					usart3_clk: usart3_clk {
> +						#clock-cells = <0>;
> +						reg = <8>;
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
> +					tcb_clk: tcb_clk {
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
> +					lcdc_clk: lcdc_clk {
> +						#clock-cells = <0>;
> +						reg = <25>;
> +					};
> +
> +					sha_clk: sha_clk {
> +						#clock-cells = <0>;
> +						reg = <27>;
> +					};
> +
> +					ssc0_clk: ssc0_clk {
> +						#clock-cells = <0>;
> +						reg = <28>;
> +					};
> +
> +					aes_clk: aes_clk {
> +						#clock-cells = <0>;
> +						reg = <29>;
> +					};
> +
> +					trng_clk: trng_clk {
> +						#clock-cells = <0>;
> +						reg = <30>;
> +					};
> +				};
>  			};
>  
>  			rstc@fffffe00 {
> @@ -88,6 +375,7 @@
>  				compatible = "atmel,at91sam9260-pit";
>  				reg = <0xfffffe30 0xf>;
>  				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +				clocks = <&mck>;
>  			};
>  
>  			shdwc@fffffe10 {
> @@ -95,12 +383,38 @@
>  				reg = <0xfffffe10 0x10>;
>  			};
>  
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
> +			};
> +
>  			mmc0: mmc@f0008000 {
>  				compatible = "atmel,hsmci";
>  				reg = <0xf0008000 0x600>;
>  				interrupts = <12 IRQ_TYPE_LEVEL_HIGH 0>;
>  				dmas = <&dma 1 AT91_DMA_CFG_PER_ID(0)>;
>  				dma-names = "rxtx";
> +				clocks = <&mci0_clk>;
> +				clock-names = "mci_clk";
>  				#address-cells = <1>;
>  				#size-cells = <0>;
>  				status = "disabled";
> @@ -110,12 +424,16 @@
>  				compatible = "atmel,at91sam9x5-tcb";
>  				reg = <0xf8008000 0x100>;
>  				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 0>;
> +				clocks = <&tcb_clk>;
> +				clock-names = "t0_clk";
>  			};
>  
>  			tcb1: timer@f800c000 {
>  				compatible = "atmel,at91sam9x5-tcb";
>  				reg = <0xf800c000 0x100>;
>  				interrupts = <17 IRQ_TYPE_LEVEL_HIGH 0>;
> +				clocks = <&tcb_clk>;
> +				clock-names = "t0_clk";
>  			};
>  
>  			dma: dma-controller@ffffec00 {
> @@ -123,6 +441,8 @@
>  				reg = <0xffffec00 0x200>;
>  				interrupts = <20 IRQ_TYPE_LEVEL_HIGH 0>;
>  				#dma-cells = <2>;
> +				clocks = <&dma0_clk>;
> +				clock-names = "dma_clk";
>  			};
>  
>  			pinctrl@fffff400 {
> @@ -392,6 +712,7 @@
>  					gpio-controller;
>  					interrupt-controller;
>  					#interrupt-cells = <2>;
> +					clocks = <&pioAB_clk>;
>  				};
>  
>  				pioB: gpio@fffff600 {
> @@ -402,6 +723,7 @@
>  					gpio-controller;
>  					interrupt-controller;
>  					#interrupt-cells = <2>;
> +					clocks = <&pioAB_clk>;
>  				};
>  
>  				pioC: gpio@fffff800 {
> @@ -412,6 +734,7 @@
>  					gpio-controller;
>  					interrupt-controller;
>  					#interrupt-cells = <2>;
> +					clocks = <&pioCD_clk>;
>  				};
>  
>  				pioD: gpio@fffffa00 {
> @@ -422,6 +745,7 @@
>  					gpio-controller;
>  					interrupt-controller;
>  					#interrupt-cells = <2>;
> +					clocks = <&pioCD_clk>;
>  				};
>  			};
>  
> @@ -431,6 +755,8 @@
>  				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_dbgu>;
> +				clocks = <&mck>;
> +				clock-names = "usart";
>  				status = "disabled";
>  			};
>  
> @@ -443,6 +769,8 @@
>  				dma-names = "tx", "rx";
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
> +				clocks = <&ssc0_clk>;
> +				clock-names = "pclk";
>  				status = "disabled";
>  			};
>  
> @@ -452,6 +780,8 @@
>  				interrupts = <5 IRQ_TYPE_LEVEL_HIGH 5>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_usart0>;
> +				clocks = <&usart0_clk>;
> +				clock-names = "usart";
>  				status = "disabled";
>  			};
>  
> @@ -461,6 +791,8 @@
>  				interrupts = <6 IRQ_TYPE_LEVEL_HIGH 5>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_usart1>;
> +				clocks = <&usart1_clk>;
> +				clock-names = "usart";
>  				status = "disabled";
>  			};
>  
> @@ -470,6 +802,8 @@
>  				interrupts = <7 IRQ_TYPE_LEVEL_HIGH 5>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_usart2>;
> +				clocks = <&usart2_clk>;
> +				clock-names = "usart";
>  				status = "disabled";
>  			};
>  
> @@ -479,6 +813,8 @@
>  				interrupts = <8 IRQ_TYPE_LEVEL_HIGH 5>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_usart3>;
> +				clocks = <&usart3_clk>;
> +				clock-names = "usart";
>  				status = "disabled";
>  			};
>  
> @@ -493,6 +829,7 @@
>  				#size-cells = <0>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_i2c0>;
> +				clocks = <&twi0_clk>;
>  				status = "disabled";
>  			};
>  
> @@ -507,6 +844,7 @@
>  				#size-cells = <0>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_i2c1>;
> +				clocks = <&twi1_clk>;
>  				status = "disabled";
>  			};
>  
> @@ -521,6 +859,8 @@
>  				dma-names = "tx", "rx";
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_spi0>;
> +				clocks = <&spi0_clk>;
> +				clock-names = "spi_clk";
>  				status = "disabled";
>  			};
>  
> @@ -535,6 +875,8 @@
>  				dma-names = "tx", "rx";
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_spi1>;
> +				clocks = <&spi1_clk>;
> +				clock-names = "spi_clk";
>  				status = "disabled";
>  			};
>  
> @@ -554,6 +896,7 @@
>  				reg = <0xf8034000 0x300>;
>  				interrupts = <18 IRQ_TYPE_LEVEL_HIGH 4>;
>  				#pwm-cells = <3>;
> +				clocks = <&pwm_clk>;
>  				status = "disabled";
>  			};
>  		};
> @@ -584,6 +927,9 @@
>  			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
>  			reg = <0x00500000 0x00100000>;
>  			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 2>;
> +			clocks = <&usb>, <&uhphs_clk>, <&udphs_clk>,
> +				 <&uhpck>;
> +			clock-names = "usb_clk", "ohci_clk", "hclk", "uhpck";
>  			status = "disabled";
>  		};
>  	};
> -- 
> 1.8.3.2
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
