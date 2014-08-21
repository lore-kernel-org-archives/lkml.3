Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaHULqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:46:13 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:11347
	"EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019AbaHULqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:46:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As8BANja9VM6B/Tj/2dsb2JhbAANTYQ3ryUBAQEGpHkBgSaEewEBBDhAARALDQsJFg8JAwIBAgFFBgEMAQUCAQG0VJYmF4V8iVAHhEwBBJB9hwuMFYQ4jGxagk8BAQE
X-IronPort-AV: E=Sophos;i="5.01,908,1399996800"; 
   d="scan'208";a="242869097"
Message-ID: <53F5DBFD.2020502@uclinux.org>
Date: Thu, 21 Aug 2014 21:46:05 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Daniel Thompson <daniel.thompson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH v9 4/9] arm: ks8695: Migrate debug_ll macros to shared
 directory
References: <1408459715-10151-1-git-send-email-daniel.thompson@linaro.org> <1408461407-10429-1-git-send-email-daniel.thompson@linaro.org> <1408461407-10429-5-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1408461407-10429-5-git-send-email-daniel.thompson@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 20/08/14 01:16, Daniel Thompson wrote:
> As part of the migration a couple of uart definitions have been copied
> from of the platform specific header files.
>
> Note that, in order to keep oldconfig working nicely we must defer the
> removal of arch/arm/mach-ks8695/include/mach/debug-macro.S until
> DEBUG_LL_UART_NONE has been removed.
>
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> ---
>   arch/arm/Kconfig.debug                                         |  8 ++++++++
>   .../include/mach/debug-macro.S => include/debug/ks8695.S}      | 10 +++++++---
>   2 files changed, 15 insertions(+), 3 deletions(-)
>   rename arch/arm/{mach-ks8695/include/mach/debug-macro.S => include/debug/ks8695.S} (80%)
>
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 9c46729..97c3058 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -348,6 +348,13 @@ choice
>   		  Say Y here if you want the debug print routines to direct
>   		  their output to UART1 serial port on KEYSTONE2 devices.
>   
> +	config DEBUG_KS8695_UART
> +		bool "KS8695 Debug UART"
> +		depends on ARCH_KS8695
> +		help
> +		  Say Y here if you want kernel low-level debugging support
> +		  on KS8695.
> +
>   	config DEBUG_MMP_UART2
>   		bool "Kernel low-level debugging message via MMP UART2"
>   		depends on ARCH_MMP
> @@ -1017,6 +1024,7 @@ config DEBUG_LL_INCLUDE
>   				 DEBUG_IMX6Q_UART || \
>   				 DEBUG_IMX6SL_UART || \
>   				 DEBUG_IMX6SX_UART
> +	default "debug/ks8695.S" if DEBUG_KS8695_UART
>   	default "debug/msm.S" if DEBUG_MSM_UART || DEBUG_QCOM_UARTDM
>   	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
>   	default "debug/s3c24xx.S" if DEBUG_S3C24XX_UART
> diff --git a/arch/arm/mach-ks8695/include/mach/debug-macro.S b/arch/arm/include/debug/ks8695.S
> similarity index 80%
> rename from arch/arm/mach-ks8695/include/mach/debug-macro.S
> rename to arch/arm/include/debug/ks8695.S
> index a79e489..961da1f 100644
> --- a/arch/arm/mach-ks8695/include/mach/debug-macro.S
> +++ b/arch/arm/include/debug/ks8695.S
> @@ -1,5 +1,5 @@
>   /*
> - * arch/arm/mach-ks8695/include/mach/debug-macro.S
> + * arch/arm/include/debug/ks8695.S
>    *
>    * Copyright (C) 2006 Ben Dooks <ben@simtec.co.uk>
>    * Copyright (C) 2006 Simtec Electronics
> @@ -11,8 +11,12 @@
>    * published by the Free Software Foundation.
>    */
>   
> -#include <mach/hardware.h>
> -#include <mach/regs-uart.h>
> +#define KS8695_UART_PA	0x03ffe000
> +#define KS8695_UART_VA	0xf00fe000
> +#define KS8695_URTH	(0x04)
> +#define KS8695_URLS	(0x14)
> +#define URLS_URTE	(1 << 6)
> +#define URLS_URTHRE	(1 << 5)

Whats the thinking behind moving these definitions here?
Is there a plan to move/change regs-uart.h?

Regards
Greg


