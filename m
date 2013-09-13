Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab3IMOlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:41:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56862 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932454Ab3IMOln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:41:43 -0400
Date: Fri, 13 Sep 2013 15:40:50 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: msm: Add support for MSM8974 Dragonboard
Message-ID: <20130913144050.GJ22013@e106331-lin.cambridge.arm.com>
References: <1375743779-24993-1-git-send-email-rvaswani@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375743779-24993-1-git-send-email-rvaswani@codeaurora.org>
Thread-Topic: [PATCH 1/2] ARM: msm: Add support for MSM8974 Dragonboard
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 12:02:58AM +0100, Rohit Vaswani wrote:
> This patch adds basic board support for MSM8974 Dragonboard
> which belongs to the Snapdragon 800 family.
> For now, just support a basic machine with device tree.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  arch/arm/boot/dts/Makefile        |  3 ++-
>  arch/arm/boot/dts/msm8974-db.dts  | 26 ++++++++++++++++++++++++++
>  arch/arm/mach-msm/Kconfig         | 21 ++++++++++++++++++---
>  arch/arm/mach-msm/Makefile        |  1 +
>  arch/arm/mach-msm/board-dt-8974.c | 23 +++++++++++++++++++++++
>  5 files changed, 70 insertions(+), 4 deletions(-)
>  create mode 100644 arch/arm/boot/dts/msm8974-db.dts
>  create mode 100644 arch/arm/mach-msm/board-dt-8974.c
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 641b3c9a..62cea36 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -97,7 +97,8 @@ dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
>  	kirkwood-openblocks_a6.dtb
>  dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
>  dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
> -	msm8960-cdp.dtb
> +	msm8960-cdp.dtb \
> +	msm8974-db.dtb
>  dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
>  	armada-370-mirabox.dtb \
>  	armada-370-rd.dtb \
> diff --git a/arch/arm/boot/dts/msm8974-db.dts b/arch/arm/boot/dts/msm8974-db.dts
> new file mode 100644
> index 0000000..badfc61
> --- /dev/null
> +++ b/arch/arm/boot/dts/msm8974-db.dts
> @@ -0,0 +1,26 @@
> +/dts-v1/;
> +
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	model = "Qualcomm MSM8974 Dragonboard";
> +	compatible = "qcom,msm8974-db", "qcom,msm8974";
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
> +		interrupts = <1 2 0xf08>,
> +			     <1 3 0xf08>,
> +			     <1 4 0xf08>,
> +			     <1 1 0xf08>;
> +		clock-frequency = <19200000>;

Do you actually need this -- does your firmware and/or bootloader not
set CNTFRQ?

It's *far* preferable to set CNTFRQ. Virtualization hosts and guests
may not handle dt and may expect it to have been programmed as per the
ARM ARM.

Thanks,
Mark.

> +	};
> +};
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index 614e41e..343675b 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -1,12 +1,12 @@
>  if ARCH_MSM
>  
>  comment "Qualcomm MSM SoC Type"
> -	depends on (ARCH_MSM8X60 || ARCH_MSM8960)
> +	depends on ARCH_MSM_DT
>  
>  choice
>  	prompt "Qualcomm MSM SoC Type"
>  	default ARCH_MSM7X00A
> -	depends on !(ARCH_MSM8X60 || ARCH_MSM8960)
> +	depends on !ARCH_MSM_DT
>  
>  config ARCH_MSM7X00A
>  	bool "MSM7x00A / MSM7x01A"
> @@ -60,6 +60,19 @@ config ARCH_MSM8960
>  	select MSM_SCM if SMP
>  	select USE_OF
>  
> +config ARCH_MSM8974
> +	bool "MSM8974"
> +	select ARM_GIC
> +	select CPU_V7
> +	select HAVE_ARM_ARCH_TIMER
> +	select HAVE_SMP
> +	select MSM_SCM if SMP
> +	select USE_OF
> +
> +config ARCH_MSM_DT
> +	def_bool y
> +	depends on (ARCH_MSM8X60 || ARCH_MSM8960 || ARCH_MSM8974)
> +
>  config MSM_HAS_DEBUG_UART_HS
>  	bool
>  
> @@ -68,6 +81,7 @@ config MSM_SOC_REV_A
>  
>  config  ARCH_MSM_ARM11
>  	bool
> +
>  config  ARCH_MSM_SCORPION
>  	bool
>  
> @@ -75,6 +89,7 @@ config  MSM_VIC
>  	bool
>  
>  menu "Qualcomm MSM Board Type"
> +	depends on !ARCH_MSM_DT
>  
>  config MACH_HALIBUT
>  	depends on ARCH_MSM
> @@ -121,7 +136,7 @@ config MSM_SMD
>  	bool
>  
>  config MSM_GPIOMUX
> -	depends on !(ARCH_MSM8X60 || ARCH_MSM8960)
> +	depends on !ARCH_MSM_DT
>  	bool "MSM V1 TLMM GPIOMUX architecture"
>  	help
>  	  Support for MSM V1 TLMM GPIOMUX architecture.
> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
> index d257ff4..80e3b15 100644
> --- a/arch/arm/mach-msm/Makefile
> +++ b/arch/arm/mach-msm/Makefile
> @@ -29,5 +29,6 @@ obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
>  obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
>  obj-$(CONFIG_ARCH_MSM8X60) += board-dt-8660.o
>  obj-$(CONFIG_ARCH_MSM8960) += board-dt-8960.o
> +obj-$(CONFIG_ARCH_MSM8974) += board-dt-8974.o
>  obj-$(CONFIG_MSM_GPIOMUX) += gpiomux.o
>  obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o
> diff --git a/arch/arm/mach-msm/board-dt-8974.c b/arch/arm/mach-msm/board-dt-8974.c
> new file mode 100644
> index 0000000..697623e
> --- /dev/null
> +++ b/arch/arm/mach-msm/board-dt-8974.c
> @@ -0,0 +1,23 @@
> +/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/of_platform.h>
> +#include <asm/mach/arch.h>
> +
> +static const char * const msm8974_dt_match[] __initconst = {
> +	"qcom,msm8974-db",
> +	NULL
> +};
> +
> +DT_MACHINE_START(MSM8974_DT, "Qualcomm MSM (Flattened Device Tree)")
> +	.dt_compat = msm8974_dt_match,
> +MACHINE_END
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
