Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaJXAqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 20:46:32 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64572 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaJXAqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 20:46:30 -0400
Date: Thu, 23 Oct 2014 17:46:25 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com,
        cjf@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v13 4/5] ARM: dts: add main Thermal info to rk3288
Message-ID: <20141024004625.GD9463@dtor-ws>
References: <1414057207-1576-1-git-send-email-caesar.wang@rock-chips.com>
 <1414057207-1576-5-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414057207-1576-5-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Caesar,

On Thu, Oct 23, 2014 at 05:40:06PM +0800, Caesar Wang wrote:
> This patch is depend on rk3288-thermal.dtsi,or
> it will compile error.
> 
> If the temperature over a period of time High,over 120C
> the resulting TSHUT gave CRU module,let it reset
> the entire chip,or via GPIO give PMIC.
> 
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> ---
>  arch/arm/boot/dts/rk3288.dtsi | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index cb18bb4..85fc17a 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -15,6 +15,7 @@
>  #include <dt-bindings/interrupt-controller/arm-gic.h>
>  #include <dt-bindings/pinctrl/rockchip.h>
>  #include <dt-bindings/clock/rk3288-cru.h>
> +#include <dt-bindings/thermal/thermal.h>
>  #include "skeleton.dtsi"
>  
>  / {
> @@ -66,6 +67,7 @@
>  				 216000  900000
>  				 126000  900000
>  			>;
> +			#cooling-cells = <2>; /* min followed by max */
>  			clock-latency = <40000>;
>  			clocks = <&cru ARMCLK>;
>  		};
> @@ -346,6 +348,19 @@
>  		status = "disabled";
>  	};
>  
> +	tsadc: tsadc@ff280000 {
> +		compatible = "rockchip,rk3288-tsadc";
> +		reg = <0xff280000 0x100>;
> +		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
> +		clock-names = "tsadc", "apb_pclk";
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&otp_out>;
> +		#thermal-sensor-cells = <1>;
> +		hw-shut-temp = <120000>;

I do not think this is a good value. You have (in the other DTS file)
passive trip point at 80 and critical (which should result in orderly
shutdown) at 125. But here you define hardware-controlled shutdown at
120C, which is backwards. You should have:

passive <= critical <= hardware

Thanks.

-- 
Dmitry
