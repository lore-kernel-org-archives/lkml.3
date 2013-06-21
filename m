Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946248Ab3FUW66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 18:58:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40960 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946172Ab3FUW65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 18:58:57 -0400
Date: Fri, 21 Jun 2013 15:58:55 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: msm: Add support for MSM8974
Message-ID: <20130621225855.GC14575@codeaurora.org>
References: <1371841835-29514-1-git-send-email-rvaswani@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371841835-29514-1-git-send-email-rvaswani@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21, Rohit Vaswani wrote:
> diff --git a/arch/arm/boot/dts/msm8974.dts b/arch/arm/boot/dts/msm8974.dts
> new file mode 100644
> index 0000000..d9c10d4
> --- /dev/null
> +++ b/arch/arm/boot/dts/msm8974.dts
> @@ -0,0 +1,23 @@
> +/dts-v1/;
> +
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	model = "Qualcomm MSM8974";
> +	compatible = "qcom,msm8974";
> +	interrupt-parent = <&intc>;
> +
> +	intc: interrupt-controller@f9000000 {
> +		compatible = "qcom,msm-qgic2";
> +		interrupt-controller;
> +		#interrupt-cells = <3>;
> +		reg = < 0xf9000000 0x1000 >,
> +		      < 0xf9002000 0x1000 >;
> +	};
> +
> +	timer {
> +		compatible = "arm,armv7-timer";
> +		interrupts = <1 2 0 1 3 0>;
> +		clock-frequency = <19200000>;
> +	};

Please specify all the interrupts similar to how the binding
says to.

	<1 2 0>,
	<1 3 0>,
	<1 4 0>,
	<1 5 0>;

Also, add irq flags?

> +};
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index 614e41e..580e89b 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -46,7 +46,6 @@ config ARCH_MSM8X60
>  	bool "MSM8X60"
>  	select ARM_GIC
>  	select CPU_V7
> -	select GPIO_MSM_V2
>  	select HAVE_SMP
>  	select MSM_SCM if SMP
>  	select USE_OF

Looks unrelated. Can you drop this?

> @@ -60,14 +59,37 @@ config ARCH_MSM8960
>  	select MSM_SCM if SMP
>  	select USE_OF
>  
> +config ARCH_MSM8974
> +	bool "MSM8974"
> +	select ARCH_MSM_KRAITMP
> +	select ARM_GIC
> +	select CPU_V7
> +	select HAVE_ARM_ARCH_TIMER
> +	select USE_OF
> +	select MSM_SCM if SMP

Please sort these selects alphabetically.

> +
> +config ARCH_MSM_DT
> +	def_bool y
> +	depends on (ARCH_MSM8X60 || ARCH_MSM8960 || ARCH_MSM8974)
> +
>  config MSM_HAS_DEBUG_UART_HS
>  	bool
>  
>  config MSM_SOC_REV_A
>  	bool
>  
> +config ARCH_MSM_KRAIT
> +	bool
> +	select ARM_L1_CACHE_SHIFT_6

This is the default for CPU_V7 and so is unnnecessary.

> +
> +config ARCH_MSM_KRAITMP
> +	select ARCH_MSM_KRAIT
> +	select HAVE_SMP
> +	bool

And this is not doing much besides enabling SMP. So I would just
drop this for now or merge it with the 8974 kconfig.

> diff --git a/arch/arm/mach-msm/board-dt-8974.c b/arch/arm/mach-msm/board-dt-8974.c
> +#include <linux/irqchip.h>
> +#include <linux/of_platform.h>

These two aren't needed?

> +#include <asm/mach/arch.h>
> +
> +static const char * const msm8974_dt_match[] __initconst = {
> +	"qcom,msm8974",
> +	NULL
> +};
> +
> +DT_MACHINE_START(MSM8974_DT, "Qualcomm MSM (Flattened Device Tree)")
> +	.dt_compat = msm8974_dt_match,
> +MACHINE_END

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
