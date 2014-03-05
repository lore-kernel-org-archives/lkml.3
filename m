Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaCEHnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:43:23 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:32810 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbaCEHnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:43:21 -0500
Date: Wed, 5 Mar 2014 07:42:52 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 3/4] ARM: DT: STi: Add DT node for MiPHY365x
Message-ID: <20140305074252.GF20016@e106331-lin.cambridge.arm.com>
References: <1392377036-12816-1-git-send-email-lee.jones@linaro.org>
 <1392377036-12816-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392377036-12816-3-git-send-email-lee.jones@linaro.org>
Thread-Topic: [PATCH 3/4] ARM: DT: STi: Add DT node for MiPHY365x
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 11:23:55AM +0000, Lee Jones wrote:
> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> devices. It has 2 ports which it can use for either; both SATA, both
> PCIe or one of each in any configuration.
> 
> Cc: devicetree@vger.kernel.org
> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/stih416-b2020-revE.dts |  6 +++++-
>  arch/arm/boot/dts/stih416-b2020.dts      |  6 ++++++
>  arch/arm/boot/dts/stih416.dtsi           | 13 +++++++++++++
>  3 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
> index a874570..dbe67fa 100644
> --- a/arch/arm/boot/dts/stih416-b2020-revE.dts
> +++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
> @@ -32,6 +32,10 @@
>  		ethernet1: ethernet@fef08000 {
>  			snps,reset-gpio 	= <&PIO0 7>;
>  		};
> -	};
>  
> +		miphy365x_phy: miphy365x@0 {

This has registers at 0x0? Or is the unit-address wrong?

> +			st,pcie_tx_pol_inv = <1>;

This is a boolean. The '= <1>' is not required and is confusing.

> +			st,sata_gen = "gen3";

s/"gen3"/<3>/

Both these properties need s/_/-/ applied.

All these apply to the other dts too.

> +		};
> +	};
>  };
> diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
> index 276f28d..fd9cbad 100644
> --- a/arch/arm/boot/dts/stih416-b2020.dts
> +++ b/arch/arm/boot/dts/stih416-b2020.dts
> @@ -13,4 +13,10 @@
>  	model = "STiH416 B2020";
>  	compatible = "st,stih416", "st,stih416-b2020";

This compatible list is the wrong way around. Left to right should go
from most specific to most general / oldest variant.

>  
> +	soc {
> +		miphy365x_phy: miphy365x@0 {

> +			st,pcie_tx_pol_inv = <1>;
> +			st,sata_gen = "gen3";
> +		};
> +	};
>  };
> diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
> index 85b8063..9fd8efb 100644
> --- a/arch/arm/boot/dts/stih416.dtsi
> +++ b/arch/arm/boot/dts/stih416.dtsi
> @@ -9,6 +9,8 @@
>  #include "stih41x.dtsi"
>  #include "stih416-clock.dtsi"
>  #include "stih416-pinctrl.dtsi"
> +
> +#include <dt-bindings/phy/phy-miphy365x.h>
>  #include <dt-bindings/interrupt-controller/arm-gic.h>
>  #include <dt-bindings/reset-controller/stih416-resets.h>
>  / {
> @@ -140,5 +142,16 @@
>  			clocks		= <&CLK_S_ICN_REG_0>;
>  		};
>  
> +		miphy365x_phy: miphy365x@0 {

The unit-address should be fe382000 rather than 0 to match the first reg
entry.

Cheers,
Mark.

> +			compatible      = "st,miphy365x-phy";
> +			reg        	= <0xfe382000 0x100>,
> +					  <0xfe38a000 0x100>,
> +					  <0xfe394000 0x100>,
> +					  <0xfe804000 0x100>;
> +			reg-names  	= "sata0", "sata1", "pcie0", "pcie1";
> +
> +			#phy-cells 	= <2>;
> +			st,syscfg  	= <&syscfg_rear>;
> +		};
>  	};
>  };
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
