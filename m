Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaLZJqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:46:08 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:22113 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaLZJqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:46:03 -0500
Message-ID: <549D2E4F.4090705@atmel.com>
Date: Fri, 26 Dec 2014 17:45:51 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] ARM: at91/dt: sama5: move NAND nodes into board dts/dtsi
References: <1417732214-3292-1-git-send-email-boris.brezillon@free-electrons.com> <1417732214-3292-5-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1417732214-3292-5-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Boris

On 12/5/2014 6:30 AM, Boris Brezillon wrote:
> sama5d3 and sama5d4 SoCs provides several CS to interface with external
> memories, and in particular NAND chips.
> The NAND flash controller embedded in the these SoCs can connect to any of
> the available CS (each CS is assigned a memory range, hence the nand@xxx
> you're seeing in the DT), thus the NAND chip definition should be part of
> the board description because we cannot guess at the SoC level which CS
> will be chosen by the board designer.
>
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>   arch/arm/boot/dts/at91-sama5d3_xplained.dts | 18 +++++++++++++++++-
>   arch/arm/boot/dts/at91-sama5d4ek.dts        | 16 +++++++++++++++-
>   arch/arm/boot/dts/sama5d3.dtsi              | 21 ---------------------
>   arch/arm/boot/dts/sama5d3xcm.dtsi           | 18 +++++++++++++++++-
>   arch/arm/boot/dts/sama5d4.dtsi              | 19 -------------------
>   5 files changed, 49 insertions(+), 43 deletions(-)
>
> diff --git a/arch/arm/boot/dts/at91-sama5d3_xplained.dts b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
> index fec1fca..860258b 100644
> --- a/arch/arm/boot/dts/at91-sama5d3_xplained.dts
> +++ b/arch/arm/boot/dts/at91-sama5d3_xplained.dts
> @@ -213,13 +213,29 @@
>   		};
>   
>   		nand0: nand@60000000 {
> +			compatible = "atmel,at91rm9200-nand";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
it would be better to leave this part to the sama5d3.dtsi.

> +			reg = <	0x60000000 0x01000000	/* EBI CS3 */
> +				0xffffc070 0x00000490	/* SMC PMECC regs */
> +				0xffffc500 0x00000100	/* SMC PMECC Error Location regs */
> +				0x00110000 0x00018000	/* ROM code */
> +				>;
> +			interrupts = <5 IRQ_TYPE_LEVEL_HIGH 6>;
ditto.
> +			atmel,nand-addr-offset = <21>;
> +			atmel,nand-cmd-offset = <22>;
> +			atmel,nand-has-dma;
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&pinctrl_nand0_ale_cle>;
> +			atmel,pmecc-lookup-table-offset = <0x0 0x8000>;
ditto.

> +			atmel,nfc = <&nfc>;
>   			nand-bus-width = <8>;
>   			nand-ecc-mode = "hw";
>   			atmel,has-pmecc;
>   			atmel,pmecc-cap = <4>;
>   			atmel,pmecc-sector-size = <512>;
>   			nand-on-flash-bbt;
> -			status = "okay";
>   
>   			at91bootstrap@0 {
>   				label = "at91bootstrap";
> diff --git a/arch/arm/boot/dts/at91-sama5d4ek.dts b/arch/arm/boot/dts/at91-sama5d4ek.dts
> index b5b8400..5de0d2d 100644
> --- a/arch/arm/boot/dts/at91-sama5d4ek.dts
> +++ b/arch/arm/boot/dts/at91-sama5d4ek.dts
> @@ -204,11 +204,25 @@
>   		};
>   
>   		nand0: nand@80000000 {
> +			compatible = "atmel,at91rm9200-nand";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
it would be better to leave this part to the sama5d4.dtsi.

> +			reg = <	0x80000000 0x08000000	/* EBI CS3 */
> +				0xfc05c070 0x00000490	/* SMC PMECC regs */
> +				0xfc05c500 0x00000100	/* SMC PMECC Error Location regs */
> +				>;
> +			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 6>;
ditto.

> +			atmel,nand-addr-offset = <21>;
> +			atmel,nand-cmd-offset = <22>;
> +			atmel,nand-has-dma;
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&pinctrl_nand>;
> +			atmel,nfc = <&nfc>;
>   			nand-bus-width = <8>;
>   			nand-ecc-mode = "hw";
>   			nand-on-flash-bbt;
>   			atmel,has-pmecc;
> -			status = "okay";
>   
>   			at91bootstrap@0 {
>   				label = "at91bootstrap";
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index 1749853..0a944e0 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -1397,27 +1397,6 @@
>   			status = "disabled";
>   		};
>   
> -		nand0: nand@60000000 {
> -			compatible = "atmel,at91rm9200-nand";
> -			#address-cells = <1>;
> -			#size-cells = <1>;
> -			ranges;
> -			reg = <	0x60000000 0x01000000	/* EBI CS3 */
> -				0xffffc070 0x00000490	/* SMC PMECC regs */
> -				0xffffc500 0x00000100	/* SMC PMECC Error Location regs */
> -				0x00110000 0x00018000	/* ROM code */
> -				>;
> -			interrupts = <5 IRQ_TYPE_LEVEL_HIGH 6>;
> -			atmel,nand-addr-offset = <21>;
> -			atmel,nand-cmd-offset = <22>;
> -			atmel,nand-has-dma;
> -			pinctrl-names = "default";
> -			pinctrl-0 = <&pinctrl_nand0_ale_cle>;
> -			atmel,pmecc-lookup-table-offset = <0x0 0x8000>;
> -			atmel,nfc = <&nfc>;
> -			status = "disabled";
> -		};
> -
>   		nfc: nfc@70000000 {
>   			compatible = "atmel,sama5d3-nfc";
>   			reg = <0x70000000 0x10000000	/* NFC Command Registers */
> diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
> index cfcd200..e6c2aec 100644
> --- a/arch/arm/boot/dts/sama5d3xcm.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
> @@ -76,13 +76,29 @@
>   		};
>   
>   		nand0: nand@60000000 {
> +			compatible = "atmel,at91rm9200-nand";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
it would be better to leave this part to the sama5d3.dtsi.

> +			reg = <	0x60000000 0x01000000	/* EBI CS3 */
> +				0xffffc070 0x00000490	/* SMC PMECC regs */
> +				0xffffc500 0x00000100	/* SMC PMECC Error Location regs */
> +				0x00110000 0x00018000	/* ROM code */
> +				>;
> +			interrupts = <5 IRQ_TYPE_LEVEL_HIGH 6>;
ditto.
> +			atmel,nand-addr-offset = <21>;
> +			atmel,nand-cmd-offset = <22>;
> +			atmel,nand-has-dma;
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&pinctrl_nand0_ale_cle>;
> +			atmel,pmecc-lookup-table-offset = <0x0 0x8000>;
ditto.

> +			atmel,nfc = <&nfc>;
>   			nand-bus-width = <8>;
>   			nand-ecc-mode = "hw";
>   			atmel,has-pmecc;
>   			atmel,pmecc-cap = <4>;
>   			atmel,pmecc-sector-size = <512>;
>   			nand-on-flash-bbt;
> -			status = "okay";
>   
>   			at91bootstrap@0 {
>   				label = "at91bootstrap";
> diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
> index 3b5e9f1..8647eb3 100644
> --- a/arch/arm/boot/dts/sama5d4.dtsi
> +++ b/arch/arm/boot/dts/sama5d4.dtsi
> @@ -265,25 +265,6 @@
>   			cache-level = <2>;
>   		};
>   
> -		nand0: nand@80000000 {
> -			compatible = "atmel,at91rm9200-nand";
> -			#address-cells = <1>;
> -			#size-cells = <1>;
> -			ranges;
> -			reg = <	0x80000000 0x08000000	/* EBI CS3 */
> -				0xfc05c070 0x00000490	/* SMC PMECC regs */
> -				0xfc05c500 0x00000100	/* SMC PMECC Error Location regs */
> -				>;
> -			interrupts = <22 IRQ_TYPE_LEVEL_HIGH 6>;
> -			atmel,nand-addr-offset = <21>;
> -			atmel,nand-cmd-offset = <22>;
> -			atmel,nand-has-dma;
> -			pinctrl-names = "default";
> -			pinctrl-0 = <&pinctrl_nand>;
> -			atmel,nfc = <&nfc>;
> -			status = "disabled";
> -		};
> -
>   		nfc: nfc@90000000 {
>   			compatible = "atmel,sama5d3-nfc";
>   			reg = <0x90000000 0x10000000	/* NFC Command Registers */
Best Regards,
Josh Wu
