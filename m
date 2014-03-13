Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbaCMKhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:37:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39464 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbaCMKhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:37:37 -0400
Message-ID: <53218A57.4020502@ti.com>
Date: Thu, 13 Mar 2014 12:37:11 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <kishon@ti.com>, <rob@landley.net>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>, <tony@atomide.com>,
        <anatol.pomozov@gmail.com>, <bcousson@baylibre.com>
Subject: Re: [PATCH v3 3/5] ARM: dts: AM4372: Add USB nodes
References: <1394193422-18242-1-git-send-email-george.cherian@ti.com> <1394193422-18242-4-git-send-email-george.cherian@ti.com>
In-Reply-To: <1394193422-18242-4-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 01:57 PM, George Cherian wrote:
> Add nodes for 2 instances each of
> 	- ocp2scp
> 	- USB PHY control module
> 	- USB PHY
> 	- dwc3_omap
> 	- USB
> 
> for AM43xx.
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> Acked-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/boot/dts/am4372.dtsi | 95 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 95 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
> index 5a7cc38..fdcdf1b 100644
> --- a/arch/arm/boot/dts/am4372.dtsi
> +++ b/arch/arm/boot/dts/am4372.dtsi
> @@ -698,6 +698,101 @@
>  			       <&edma 11>;
>  			dma-names = "tx", "rx";
>  		};
> +
> +		am43xx_control_usb2phy1: control-phy@44e10620 {
> +			compatible = "ti,control-phy-usb2-am437";
> +			reg = <0x44e10620 0x4>;
> +			reg-names = "power";
> +		};
> +
> +		am43xx_control_usb2phy2: control-phy@0x44e10628 {
> +			compatible = "ti,control-phy-usb2-am437";
> +			reg = <0x44e10628 0x4>;
> +			reg-names = "power";
> +		};
> +
> +		ocp2scp0: ocp2scp@483a8000 {
> +			compatible = "ti,omap-ocp2scp";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
> +			ti,hwmods = "ocp2scp0";
> +
> +			usb2_phy1: phy@483a8000 {
> +				compatible = "ti,am437x-usb2";
> +				reg = <0x483a8000 0x8000>;
> +				ctrl-module = <&am43xx_control_usb2phy1>;
> +				clocks = <&clk_32768_ck>,

shouldn't the PHY wakeup clock be "usb_phy0_always_on_clk32k"?

> +					 <&usb_otg_ss0_refclk960m>;
> +				clock-names = "wkupclk", "refclk";
> +				#phy-cells = <0>;
> +				status = "disabled";
> +			};
> +		};
> +
> +		ocp2scp1: ocp2scp@483e8000 {
> +			compatible = "ti,omap-ocp2scp";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges;
> +			ti,hwmods = "ocp2scp1";
> +
> +			usb2_phy2: phy@483e8000 {
> +				compatible = "ti,am437x-usb2";
> +				reg = <0x483e8000 0x8000>;
> +				ctrl-module = <&am43xx_control_usb2phy2>;
> +				clocks = <&clk_32768_ck>,

&usb_phy1_always_on_clk32k here?

> +					 <&usb_otg_ss1_refclk960m>;
> +				clock-names = "wkupclk", "refclk";
> +				#phy-cells = <0>;
> +				status = "disabled";
> +			};
> +		};
> +
> +		dwc3_1: omap_dwc3@48380000 {
> +			compatible = "ti,am437x-dwc3";
> +			ti,hwmods = "usb_otg_ss0";
> +			reg = <0x48380000 0x10000>;
> +			interrupts = <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			utmi-mode = <1>;
> +			ranges;
> +
> +			usb1: usb@48390000 {
> +				compatible = "synopsys,dwc3";
> +				reg = <0x48390000 0x17000>;
> +				interrupts = <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>;
> +				phys = <&usb2_phy1>;
> +				phy-names = "usb2-phy";
> +				maximum-speed = "high-speed";
> +				dr_mode = "otg";
> +				status = "disabled";
> +			};
> +		};
> +
> +		dwc3_2: omap_dwc3@483c0000 {
> +			compatible = "ti,am437x-dwc3";
> +			ti,hwmods = "usb_otg_ss1";
> +			reg = <0x483c0000 0x10000>;
> +			interrupts = <GIC_SPI 178 IRQ_TYPE_LEVEL_HIGH>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			utmi-mode = <1>;
> +			ranges;
> +
> +			usb2: usb@483d0000 {
> +				compatible = "synopsys,dwc3";
> +				reg = <0x483d0000 0x17000>;
> +				interrupts = <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>;
> +				phys = <&usb2_phy2>;
> +				phy-names = "usb2-phy";
> +				maximum-speed = "high-speed";
> +				dr_mode = "otg";
> +				status = "disabled";
> +			};
> +		};
> +
>  	};
>  };
>  
> 

cheers,
-roger
