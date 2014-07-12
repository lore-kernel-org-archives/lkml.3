Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbaGLAaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 20:30:12 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:54045 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaGLAaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 20:30:10 -0400
Message-ID: <53C0819E.4000202@cogentembedded.com>
Date: Sat, 12 Jul 2014 04:30:22 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kishon@ti.com
CC: kernel@stlinux.com
Subject: Re: [PATCH v3+1 5/5] ARM: DT: STi: STiH416: Add DT node for MiPHY365x
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org> <1404906074-31992-6-git-send-email-lee.jones@linaro.org> <20140711115406.GB2954@lee--X1>
In-Reply-To: <20140711115406.GB2954@lee--X1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/11/2014 03:54 PM, Lee Jones wrote:

> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> devices. It has 2 ports which it can use for either; both SATA, both
> PCIe or one of each in any configuration.

> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
> index 4e2df66..c3c2ac6 100644
> --- a/arch/arm/boot/dts/stih416-b2020.dts
> +++ b/arch/arm/boot/dts/stih416-b2020.dts
> @@ -12,4 +12,16 @@
>   / {
>   	model = "STiH416 B2020";
>   	compatible = "st,stih416-b2020", "st,stih416";
> +
> +	soc {
> +		miphy365x_phy: miphy365x@fe382000 {
> +			phy_port0: port@fe382000 {

    I don't understand why are you creating the duplicate labels; doesn't 
'dtc' complain about them? You could instead refer to them as:

&miphy365x_phy {
};

> +				st,sata-gen = <3>;
> +			};
> +
> +			phy_port1: port@fe38a000 {
> +				st,pcie-tx-pol-inv;
> +			};
> +		};
> +	};
>   };
[...]
> diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
> index 84758d7..2b98a0a 100644
> --- a/arch/arm/boot/dts/stih416.dtsi
> +++ b/arch/arm/boot/dts/stih416.dtsi
> @@ -9,6 +9,8 @@
>   #include "stih41x.dtsi"
>   #include "stih416-clock.dtsi"
>   #include "stih416-pinctrl.dtsi"
> +
> +#include <dt-bindings/phy/phy-miphy365x.h>
>   #include <dt-bindings/interrupt-controller/arm-gic.h>
>   #include <dt-bindings/reset-controller/stih416-resets.h>
>   / {
> @@ -236,5 +238,25 @@
>   			resets	= <&powerdown STIH416_KEYSCAN_POWERDOWN>,
>   				  <&softreset STIH416_KEYSCAN_SOFTRESET>;
>   		};
> +
> +		miphy365x_phy: miphy365x@fe382000 {

    The ePAPR standard [1] says:

The name of a node should be somewhat generic, reflecting the function of the 
device and not its precise programming model.

> +			compatible      = "st,miphy365x-phy";
> +			st,syscfg  	= <&syscfg_rear>;
> +			#address-cells	= <1>;
> +			#size-cells	= <1>;
> +			ranges;
> +
> +			phy_port0: port@fe382000 {
> +				#phy-cells = <1>;

    If these are PHY devices, they should be named "phy", not "port".

> +				reg = <0xfe382000 0x100>, <0xfe394000 0x100>, <0x824 0x4>;
> +				reg-names = "sata", "pcie", "syscfg";
> +			};
> +
> +			phy_port1: port@fe38a000 {
> +				#phy-cells = <1>;
> +				reg = <0xfe38a000 0x100>, <0xfe804000 0x100>, <0x828 0x4>;
> +				reg-names = "sata", "pcie", "syscfg";
> +			};
> +		};
>   	};
>   };

WBR, Sergei

