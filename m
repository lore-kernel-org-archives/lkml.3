Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaANRGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:06:39 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:26327 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaANRGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:06:37 -0500
Message-ID: <52D56E9C.9080904@atmel.com>
Date: Tue, 14 Jan 2014 18:06:36 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
CC: <b.brezillon@overkiz.com>, <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/12] at91: dt: sam9261: Basic Device Tree support
 for the at91sam9261ek
References: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com> <1389270709-32662-3-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1389270709-32662-3-git-send-email-jjhiblot@traphandler.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 13:31, Jean-Jacques Hiblot :
> This patch implements a simple DTS to boot a at91sam9261ek with a dt-enabled
> kernel (at91_dt_defconfig).
> Only dbgu, nand and watchdog are described in the DT.
> 
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>  arch/arm/boot/dts/Makefile          |  2 +
>  arch/arm/boot/dts/at91sam9261ek.dts | 75 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 77 insertions(+)
>  create mode 100644 arch/arm/boot/dts/at91sam9261ek.dts
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 772a30e..ece523d 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -11,6 +11,8 @@ dtb-$(CONFIG_ARCH_AT91) += ethernut5.dtb
>  dtb-$(CONFIG_ARCH_AT91) += evk-pro3.dtb
>  dtb-$(CONFIG_ARCH_AT91) += tny_a9260.dtb
>  dtb-$(CONFIG_ARCH_AT91) += usb_a9260.dtb
> +# sam9261
> +dtb-$(CONFIG_ARCH_AT91) += at91sam9261ek.dtb
>  # sam9263
>  dtb-$(CONFIG_ARCH_AT91) += at91sam9263ek.dtb
>  dtb-$(CONFIG_ARCH_AT91) += tny_a9263.dtb
> diff --git a/arch/arm/boot/dts/at91sam9261ek.dts b/arch/arm/boot/dts/at91sam9261ek.dts
> new file mode 100644
> index 0000000..f3d22a9
> --- /dev/null
> +++ b/arch/arm/boot/dts/at91sam9261ek.dts
> @@ -0,0 +1,75 @@
> +/*
> + * at91sam9261ek.dts - Device Tree file for Atmel at91sam9261 reference board
> + *
> + *  Copyright (C) 2013 Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> + *
> + * Licensed under GPLv2 only.
> + */
> +/dts-v1/;
> +#include "at91sam9261.dtsi"
> +
> +/ {
> +	model = "Atmel at91sam9261ek";
> +	compatible = "atmel,at91sam9261ek", "atmel,at91sam9261", "atmel,at91sam9";
> +
> +	chosen {
> +		bootargs = "mem=64M console=ttyS0,115200";

No "mem=" argument, please.

> +	};
> +
> +	memory {
> +		reg = <0x20000000 0x4000000>;

This is where memory is specified.

> +	};
> +
> +	clocks {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		main_clock: clock@0 {
> +			compatible = "atmel,osc", "fixed-clock";
> +			clock-frequency = <18432000>;
> +		};
> +	};
> +
> +	ahb {
> +		apb {
> +			dbgu: serial@fffff200 {
> +				status = "okay";
> +			};
> +
> +			watchdog@fffffd40 {
> +				status = "okay";
> +			};
> +		};
> +
> +		nand0: nand@40000000 {
> +			nand-bus-width = <8>;
> +			nand-ecc-mode = "soft";
> +			nand-on-flash-bbt = <1>;
> +			status = "okay";
> +			at91bootstrap@0 {
> +				label = "at91bootstrap";
> +				reg = <0x0 0x20000>;

Maybe more partitions are needed by default. You may need to align to
the common partition scheme the we use for sama5d3 and:

http://www.at91.com/linux4sam/bin/view/Linux4SAM/GettingStarted#Linux4SAM_NandFlash_demo_Memory

(even if it can be discussed ;-))

> +			};
> +		};
> +	};
> +
> +	leds {
> +		compatible = "gpio-leds";
> +		ds8 {
> +			label = "ds8";
> +			gpios = <&pioA 13 GPIO_ACTIVE_LOW>;
> +			linux,default-trigger = "none";
> +		};
> +		ds7 {
> +			label = "ds7";
> +			gpios = <&pioA 14 GPIO_ACTIVE_LOW>;
> +			linux,default-trigger = "nand-disk";
> +		};
> +		ds1 {
> +			label = "ds1";
> +			gpios = <&pioA 23 GPIO_ACTIVE_LOW>;
> +			linux,default-trigger = "heartbeat";
> +		};
> +	};
> +};
> 


-- 
Nicolas Ferre
