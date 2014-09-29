Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaI2K3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:29:01 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:52520 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362AbaI2K26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:28:58 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
Message-ID: <542933E1.8010809@smartplayin.com>
Date: Mon, 29 Sep 2014 15:56:41 +0530
From: Kiran Padwal <kiran.padwal@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        broonie@kernel.org, lee.jones@linaro.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@sonymobile.com
Subject: Re: [PATCH 3/4] ARM: DT: apq8064: Add USB OTG support
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org> <1411982127-8048-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1411982127-8048-1-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srinivas,

Some review are comments inline.

On Monday 29 September 2014 02:45 PM, Srinivas Kandagatla wrote:
> This patch adds USB OTG support on USB1 of APQ8064 SOC.
> Tested on IFC6410 with ethernet gadget.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
>  arch/arm/boot/dts/qcom-apq8064-ifc6410.dts | 14 +++++++++
>  arch/arm/boot/dts/qcom-apq8064.dtsi        | 46 ++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
> index d6036b8..f41fb39 100644
> --- a/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
> +++ b/arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
> @@ -40,6 +40,11 @@
>  			};
>  		};
>  
> +		/* OTG */
> +		usb1_phy:phy@12500000 {
> +			status = "ok";

Its canonical value is "okay" (although in practice anything
other than "disabled" should work).

> +		};
> +
>  		usb3_phy:phy@12520000 {
>  			status = "ok";
>  		};
> @@ -48,6 +53,15 @@
>  			status = "ok";
>  		};
>  
> +		gadget1:gadget@12500000 {
> +			status = "ok";
> +		};
> +
> +		/* OTG */
> +		usb1: usb@12500000 {
> +			status = "ok";
> +		};
> +
>  		usb3: usb@12520000 {
>  			status = "ok";
>  		};
> diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
> index 491a136..38d3efa 100644
> --- a/arch/arm/boot/dts/qcom-apq8064.dtsi
> +++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
> @@ -284,6 +284,16 @@
>  				qcom,boot-load = <50000>;
>  			};
>  
> +			pm8921_l4: pm8921-l4 {
> +				compatible	= "qcom,rpm-pm8921-pldo";
> +				reg		= <QCOM_RPM_PM8921_LDO4>;
> +
> +				regulator-min-microvolt = <1000000>;
> +				regulator-max-microvolt = <1800000>;
> +				regulator-always-on;
> +				qcom,boot-load = <50000>;
> +			};
> +
>  			pm8921_l23: pm8921-l23 {
>  				compatible	= "qcom,rpm-pm8921-pldo";
>  				reg		= <QCOM_RPM_PM8921_LDO23>;
> @@ -296,6 +306,25 @@
>  
>  		};
>  
> +		usb1_phy:phy@12500000 {
> +			compatible	= "qcom,usb-otg-ci";
> +			reg		= <0x12500000 0x400>;
> +			interrupts	= <0 100 0>;

The trailing 0 might be IRQ_TYPE_NONE?

> +			status		= "disabled";

Usually the status property goes first.


> +			dr_mode		= "host";
> +
> +			clocks		= <&gcc USB_HS1_XCVR_CLK>,
> +					  <&gcc USB_HS1_H_CLK>;
> +			clock-names	= "core", "iface";
> +
> +			vddcx-supply	= <&pm8921_s3>;
> +			v3p3-supply	= <&pm8921_l3>;
> +			v1p8-supply	= <&pm8921_l4>;
> +
> +			resets		= <&gcc USB_HS1_RESET>;
> +			reset-names	= "link";
> +		};
> +
>  		usb3_phy:phy@12520000 {
>  			compatible	= "qcom,usb-otg-ci";
>  			reg		= <0x12520000 0x400>;
> @@ -334,6 +363,23 @@
>  			reset-names	= "link";
>  		};
>  
> +		gadget1:gadget@12500000 {
> +			compatible	= "qcom,ci-hdrc";
> +			reg		= <0x12500000 0x400>;
> +			status		= "disabled";
> +			dr_mode		= "peripheral";
> +			interrupts	= <0 100 0>;
> +			usb-phy		= <&usb1_phy>;
> +		};
> +
> +		usb1: usb@12500000 {
> +			compatible	= "qcom,ehci-host";
> +			reg		= <0x12500000 0x400>;
> +			interrupts	= <0 100 0>;
> +			status		= "disabled";
> +			usb-phy		= <&usb1_phy>;
> +		};
> +
>  		usb3: usb@12520000 {
>  			compatible	= "qcom,ehci-host";
>  			reg		= <0x12520000 0x400>;
> 

