Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbbA1UcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:32:10 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:34662 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759901AbbA1UcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:32:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Jan 2015 10:55:23 +0100
From: Stefan Agner <stefan@agner.ch>
To: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Cc: mark.rutland@arm.com, shawn.guo@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, broonie@kernel.org,
        B44548@freescale.com, Li.Xiubo@freescale.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH 2/7] ARM: vf-colibri: add SPI support and enable MCP2515
 CAN
In-Reply-To: <1422356244-15629-3-git-send-email-bhuvanchandra.dv@toradex.com>
References: <1422356244-15629-1-git-send-email-bhuvanchandra.dv@toradex.com>
 <1422356244-15629-3-git-send-email-bhuvanchandra.dv@toradex.com>
Message-ID: <47943ef82a880a0c681ccd0b9fd22eda@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-27 11:57, Bhuvanchandra DV wrote:
> MCP2515 CAN controller is available on Colibri Evaluation board.
> Hence enable MCP2515 CAN.
> 
> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
> ---
>  arch/arm/boot/dts/vf-colibri-eval-v3.dtsi | 31 +++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/vf-colibri.dtsi         | 15 +++++++++++++++
>  2 files changed, 46 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
> b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
> index 36cafbf..69364b0 100644
> --- a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
> +++ b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
> @@ -12,6 +12,12 @@
>  		bootargs = "console=ttyLP0,115200";
>  	};
>  
> +	clk16m: clk16m {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <16000000>;
> +	};
> +
>  	regulators {
>  		compatible = "simple-bus";
>  		#address-cells = <1>;
> @@ -47,6 +53,21 @@
>  	status  = "okay";
>  };
>  
> +&dspi1 {
> +	status = "okay";
> +
> +	can2: mcp2515@0 {


The device tree usage website states (devicetree.org): "nodes are named
according to what kind of device it represents"...

You can use the label to specify the type, e.g. I would suggest to use
something like:


	mcp2515can: can@0 {
...




> +		compatible = "microchip,mcp2515";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_can_int>;
> +		reg = <0>;
> +		clocks = <&clk16m>;
> +		spi-max-frequency = <10000000>;
> +		interrupt-parent = <&gpio2>;

The interrupt line of the MCP2515 is connected to SODIMM 73, which is
PORT1[11] on Vybrid. My recent renaming of the GPIO's has been merged
already:
https://lkml.org/lkml/2015/1/16/419

Hence, this should be updated to gpio1.


> +		interrupts = <11 GPIO_ACTIVE_LOW>;
> +	};
> +};
> +
>  &esdhc1 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_esdhc1>;
> @@ -94,3 +115,13 @@
>  &usbh1 {
>  	vbus-supply = <&usbh_vbus_reg>;
>  };
> +
> +&iomuxc {
> +	vf610-colibri {
> +		pinctrl_can_int: can_int {
> +			fsl,pins = <
> +				VF610_PAD_PTB21__GPIO_43	0x22ed
> +			>;
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/vf-colibri.dtsi
> b/arch/arm/boot/dts/vf-colibri.dtsi
> index 5c2b732..fbef082 100644
> --- a/arch/arm/boot/dts/vf-colibri.dtsi
> +++ b/arch/arm/boot/dts/vf-colibri.dtsi
> @@ -23,6 +23,12 @@
>  	status = "okay";
>  };
>  
> +&dspi1 {
> +	bus-num = <1>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_dspi1>;
> +};
> +
>  &edma0 {
>  	status = "okay";
>  };
> @@ -107,6 +113,15 @@
>  			>;
>  		};
>  
> +		pinctrl_dspi1: dspi1grp {
> +			fsl,pins = <
> +				VF610_PAD_PTD5__DSPI1_CS0		0x33e2
> +				VF610_PAD_PTD6__DSPI1_SIN		0x33e1
> +				VF610_PAD_PTD7__DSPI1_SOUT		0x33e2
> +				VF610_PAD_PTD8__DSPI1_SCK		0x33e2
> +			>;
> +		};
> +
>  		pinctrl_esdhc1: esdhc1grp {
>  			fsl,pins = <
>  				VF610_PAD_PTA24__ESDHC1_CLK	0x31ef


The rest looks good, thx.

--
Stefan
