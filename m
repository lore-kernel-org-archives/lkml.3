Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaE0K2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 06:28:20 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57736 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaE0K2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 06:28:15 -0400
Message-ID: <538468B5.6090505@linaro.org>
Date: Tue, 27 May 2014 15:58:05 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        mturquette@linaro.org
CC: mark.rutland@arm.com, linux@arm.linux.org.uk, pawel.moll@arm.com,
        t.figa@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        robh+dt@kernel.org, galak@codeaurora.org, grant.likely@linaro.org,
        m.szyprowski@samsung.com
Subject: Re: [PATCH/RFC V6 2/2] clk: Add handling of clk parent and rate assigned
 from DT
References: <1400520171-6698-1-git-send-email-s.nawrocki@samsung.com> <1400520171-6698-3-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1400520171-6698-3-git-send-email-s.nawrocki@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 10:52 PM, Sylwester Nawrocki wrote:
> This patch adds a helper function to configure clock parents and
> rates as specified in clock-parents, clock-rates DT properties
> for a consumer device and a call to it before driver is bound to
> a device.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

[ ... ]

> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 5b47210..f622733 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -23,6 +23,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/idr.h>
>  #include <linux/acpi.h>
> +#include <linux/clk/clk-conf.h>
> 
>  #include "base.h"
>  #include "power/power.h"
> @@ -486,6 +487,10 @@ static int platform_drv_probe(struct device *_dev)
>  	struct platform_device *dev = to_platform_device(_dev);
>  	int ret;
> 
> +	ret = of_clk_set_defaults(_dev->of_node, false);
> +	if (ret < 0)
> +		return ret;
> +

of_clk_set_defaults() is not getting called when the related driver is
not registered through platform_driver_register().

I came across this issue while testing this patch on peach-pit board with
following dts change. max98090 audio codec driver is registered through
module_i2c_driver().

* arch/arm/boot/dts/exynos5420-peach-pit.dts

&hsi2c_7 {

	status = "okay";

	max98090: codec@10 {
		compatible = "maxim,max98090";
		reg = <0x10>;
		interrupts = <2 0>;
		interrupt-parent = <&gpx0>;
		pinctrl-names = "default";
		pinctrl-0 = <&max98090_irq>;
+		clocks = <&pmu_system_controller 0>;
+		clock-names = "mclk";
+		clock-parents = <&clock CLK_FIN_PLL>;
+		clock-rates = <24000000>;
	};
};

-- 
Tushar Behera
