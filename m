Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab3FZP3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:29:46 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:44720 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab3FZP3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:29:44 -0400
Message-ID: <1372260541.6211.12.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [RFC/PATCH 11/11] ARM: msm: Move MSM's DT based hardware to
 multi-platform support
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Date: Wed, 26 Jun 2013 18:29:01 +0300
In-Reply-To: <1371600281-6118-12-git-send-email-sboyd@codeaurora.org>
References: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
	 <1371600281-6118-12-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen, 

On Tue, 2013-06-18 at 17:04 -0700, Stephen Boyd wrote:
> The DT based MSM platforms can join the multi-platform builds, so
> introduce a DT based ARCH_MSM option. This option allows DT based
> MSM platforms to be built into the multi-platform kernel. Also
> introduce a hidden ARCH_MSM config that both the DT and non-DT
> platform support code select to avoid churn in places that depend
> on CONFIG_ARCH_MSM.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> RFC because this has problems with msm_sdcc and usb_otg using
> mach specific APIs. See the cover letter for more details.
> 

You probably already know, but this patch causes compile error:

arch/arm/mach-msm/board-dt-8660.c:20:24: fatal error: mach/board.h: No such file or directory

I have fixed it locally like this:

--- a/arch/arm/mach-msm/board-dt-8660.c
+++ b/arch/arm/mach-msm/board-dt-8660.c
@@ -17,14 +17,8 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
-#include <mach/board.h>
 #include "common.h"
 
-static void __init msm8x60_init_late(void)
-{
-	smd_debugfs_init();
-}
-
 static struct of_dev_auxdata msm_auxdata_lookup[] __initdata = {
 	{}
 };
@@ -45,6 +39,5 @@ DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.smp = smp_ops(msm_smp_ops),
 	.map_io = debug_ll_io_init,
 	.init_machine = msm8x60_dt_init,
-	.init_late = msm8x60_init_late,
 	.dt_compat = msm8x60_fluid_match,
 MACHINE_END


Regards, 
Ivan

>  arch/arm/Kconfig          |  3 ++-
>  arch/arm/mach-msm/Kconfig | 55 +++++++++++++++++++++++++++++------------------
>  2 files changed, 36 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 430c922..22d4fff 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -618,8 +618,9 @@ config ARCH_PXA
>  	help
>  	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
>  
> -config ARCH_MSM
> +config ARCH_MSM_NODT
>  	bool "Qualcomm MSM"
> +	select ARCH_MSM
>  	select ARCH_REQUIRE_GPIOLIB
>  	select CLKDEV_LOOKUP
>  	select CLKSRC_OF if OF
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index 614e41e..09f996a 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -1,12 +1,42 @@
> +config ARCH_MSM
> +	bool
> +
> +config ARCH_MSM_DT
> +	bool "Qualcomm MSM DT support" if ARCH_MULTI_V7
> +	select ARCH_MSM
> +	select ARCH_REQUIRE_GPIOLIB
> +	select CLKSRC_OF if OF
> +	select GENERIC_CLOCKEVENTS
> +	help
> +	  Support for Qualcomm's DT-based MSM systems.
> +
>  if ARCH_MSM
>  
> -comment "Qualcomm MSM SoC Type"
> -	depends on (ARCH_MSM8X60 || ARCH_MSM8960)
> +menu "MSM options"
> +	depends on ARCH_MSM_DT
> +
> +config ARCH_MSM8X60
> +	bool "Enable support for MSM8X60"
> +	select ARM_GIC
> +	select CPU_V7
> +	select GPIO_MSM_V2
> +	select HAVE_SMP
> +	select MSM_SCM if SMP
> +
> +config ARCH_MSM8960
> +	bool "Enable support for MSM8960"
> +	select ARM_GIC
> +	select CPU_V7
> +	select HAVE_SMP
> +	select GPIO_MSM_V2
> +	select MSM_SCM if SMP
> +
> +endmenu
>  
>  choice
>  	prompt "Qualcomm MSM SoC Type"
>  	default ARCH_MSM7X00A
> -	depends on !(ARCH_MSM8X60 || ARCH_MSM8960)
> +	depends on ARCH_MSM_NODT
>  
>  config ARCH_MSM7X00A
>  	bool "MSM7x00A / MSM7x01A"
> @@ -42,24 +72,6 @@ config ARCH_QSD8X50
>  
>  endchoice
>  
> -config ARCH_MSM8X60
> -	bool "MSM8X60"
> -	select ARM_GIC
> -	select CPU_V7
> -	select GPIO_MSM_V2
> -	select HAVE_SMP
> -	select MSM_SCM if SMP
> -	select USE_OF
> -
> -config ARCH_MSM8960
> -	bool "MSM8960"
> -	select ARM_GIC
> -	select CPU_V7
> -	select HAVE_SMP
> -	select GPIO_MSM_V2
> -	select MSM_SCM if SMP
> -	select USE_OF
> -
>  config MSM_HAS_DEBUG_UART_HS
>  	bool
>  
> @@ -75,6 +87,7 @@ config  MSM_VIC
>  	bool
>  
>  menu "Qualcomm MSM Board Type"
> +	depends on ARCH_MSM_NODT
>  
>  config MACH_HALIBUT
>  	depends on ARCH_MSM


