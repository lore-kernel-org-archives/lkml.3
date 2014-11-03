Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127AbaKCGOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 01:14:25 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46882 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaKCGOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 01:14:22 -0500
Date: Mon, 3 Nov 2014 14:14:13 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v5 2/3] ARM: dts: pbab01: enable I2S audio on
 phyFLEX-i.MX6 boards
Message-ID: <20141103061408.GA21210@tiger>
References: <1414590424-25585-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1414590424-25585-3-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414590424-25585-3-git-send-email-d.lavnikevich@sam-solutions.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 04:47:03PM +0300, Dmitry Lavnikevich wrote:
> Audio on phyFLEX boards is presented by tlv320aic3007 codec connected
> over SSI interface.
> 
> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
> ---
>  arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi | 100 ++++++++++++++++++++++++++-
>  arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi |  15 ++++
>  2 files changed, 113 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi b/arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi
> index f1bdcae5b97d..cb8f1b6ec083 100644
> --- a/arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi
> @@ -9,10 +9,73 @@
>   * http://www.gnu.org/copyleft/gpl.html
>   */
>  
> +#include <dt-bindings/sound/fsl-imx-audmux.h>
> +
>  / {
>  	chosen {
>  		linux,stdout-path = &uart4;
>  	};
> +
> +	regulators {
> +		sound_1v8: regulator@2 {
> +			compatible = "regulator-fixed";
> +			reg = <2>;
> +			regulator-name = "i2s-audio-1v8";
> +			regulator-min-microvolt = <1800000>;
> +			regulator-max-microvolt = <1800000>;
> +		};
> +
> +		sound_3v3: regulator@3 {
> +			compatible = "regulator-fixed";
> +			reg = <3>;
> +			regulator-name = "i2s-audio-3v3";
> +			regulator-min-microvolt = <3300000>;
> +			regulator-max-microvolt = <3300000>;
> +		};
> +	};
> +
> +	tlv320_mclk: oscillator {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <19200000>;
> +		clock-output-names = "tlv320-mclk";
> +	};
> +
> +	sound {
> +		compatible = "simple-audio-card";
> +		simple-audio-card,name = "OnboardTLV320AIC3007";
> +		simple-audio-card,format = "i2s";
> +		simple-audio-card,bitclock-master = <&dailink_master>;
> +		simple-audio-card,frame-master = <&dailink_master>;
> +		simple-audio-card,widgets =
> +			"Microphone", "Mic Jack",
> +			"Line", "Line In",
> +			"Line", "Line Out",
> +			"Speaker", "Speaker",
> +			"Headphone", "Headphone Jack";
> +		simple-audio-card,routing =
> +			"Line Out", "LLOUT",
> +			"Line Out", "RLOUT",
> +			"Speaker", "SPOP",
> +			"Speaker", "SPOM",
> +			"Headphone Jack", "HPLOUT",
> +			"Headphone Jack", "HPROUT",
> +			"MIC3L", "Mic Jack",
> +			"MIC3R", "Mic Jack",
> +			"Mic Jack", "Mic Bias",
> +			"LINE1L", "Line In",
> +			"LINE1R", "Line In";
> +
> +		simple-audio-card,cpu {
> +			sound-dai = <&ssi2>;
> +		};
> +
> +		dailink_master: simple-audio-card,codec {
> +			sound-dai = <&codec>;
> +			clocks = <&tlv320_mclk>;
> +		};
> +	};
> +
>  };
>  
>  &fec {
> @@ -27,12 +90,45 @@
>  	status = "okay";
>  };
>  
> +&ssi2 {
> +	status = "okay";
> +};
> +
> +&audmux {

Please sort the nodes alphabetically in label name.

> +	status = "okay";
> +
> +	ssi2 {
> +		fsl,audmux-port = <1>;
> +		fsl,port-config = <
> +			(IMX_AUDMUX_V2_PTCR_TFSDIR |
> +			IMX_AUDMUX_V2_PTCR_TFSEL(4) |
> +			IMX_AUDMUX_V2_PTCR_TCLKDIR |
> +			IMX_AUDMUX_V2_PTCR_TCSEL(4))
> +	                IMX_AUDMUX_V2_PDCR_RXDSEL(4)
> +		>;
> +	};
> +	pins5 {

Have a new line between nodes.

> +		fsl,audmux-port = <4>;
> +		fsl,port-config = <
> +			0x00000000
> +			IMX_AUDMUX_V2_PDCR_RXDSEL(1)
> +		>;
> +	};
> +};
> +
>  &i2c2 {
>  	status = "okay";
>  
> -	tlv320@18 {
> -		compatible = "ti,tlv320aic3x";
> +	codec: tlv320@18 {
> +		compatible = "ti,tlv320aic3007";

Both compatible strings are documented in
Documentation/devicetree/bindings/sound/tlv320aic3x.txt.  But I hope
this change will not cause any DT compatible issues.

> +		#sound-dai-cells = <0>;
>  		reg = <0x18>;
> +		ai3x-micbias-vg = <2>;
> +
> +		AVDD-supply = <&sound_3v3>;
> +		IOVDD-supply = <&sound_3v3>;
> +		DRVDD-supply = <&sound_3v3>;
> +		DVDD-supply = <&sound_1v8>;
>  	};
>  
>  	stmpe@41 {
> diff --git a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
> index aa2275671d2c..d7f34664e008 100644
> --- a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
> @@ -58,6 +58,12 @@
>  	};
>  };
>  
> +&audmux {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_audmux>;
> +	status = "disabled";
> +};
> +
>  &ecspi3 {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_ecspi3>;
> @@ -319,6 +325,15 @@
>  				MX6QDL_PAD_ENET_TXD1__GPIO1_IO29 0x80000000
>  			>;
>  		};
> +
> +		pinctrl_audmux: audmuxgrp {

Please sort the pinctrl entries alphabetically.

Shawn

> +			fsl,pins = <
> +				MX6QDL_PAD_DISP0_DAT16__AUD5_TXC	0x130b0
> +				MX6QDL_PAD_DISP0_DAT18__AUD5_TXFS	0x130b0
> +				MX6QDL_PAD_DISP0_DAT17__AUD5_TXD	0x110b0
> +				MX6QDL_PAD_DISP0_DAT19__AUD5_RXD	0x130b0
> +			>;
> +		};
>  	};
>  };
>  
> -- 
> 2.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
