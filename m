Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbaHUBc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 21:32:27 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:57676 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaHUBcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 21:32:25 -0400
Message-ID: <53F54C26.5010000@linaro.org>
Date: Thu, 21 Aug 2014 03:32:22 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 8/9] ARM: zynq: Remove hotplug.c
References: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com> <1408567315-28479-9-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1408567315-28479-9-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 10:41 PM, Soren Brinkmann wrote:
> The hotplug code contains only a single function, which is an SMP
> function. Move that to platsmp.c where all other SMP runctions reside.
> That allows removing hotplug.c and declaring the cpu_die function
> static.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>   arch/arm/mach-zynq/Makefile  |  1 -
>   arch/arm/mach-zynq/common.h  |  3 +--
>   arch/arm/mach-zynq/hotplug.c | 17 -----------------
>   arch/arm/mach-zynq/platsmp.c | 18 ++++++++++++++++++
>   4 files changed, 19 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm/mach-zynq/Makefile b/arch/arm/mach-zynq/Makefile
> index 820dff6e1eba..c85fb3f7d5cd 100644
> --- a/arch/arm/mach-zynq/Makefile
> +++ b/arch/arm/mach-zynq/Makefile
> @@ -6,5 +6,4 @@
>   obj-y				:= common.o slcr.o pm.o
>   CFLAGS_REMOVE_hotplug.o		=-march=armv6k
>   CFLAGS_hotplug.o 		=-Wa,-march=armv7-a -mcpu=cortex-a9
> -obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
>   obj-$(CONFIG_SMP)		+= headsmp.o platsmp.o
> diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
> index c0773e87e83c..e6bb12c50a23 100644
> --- a/arch/arm/mach-zynq/common.h
> +++ b/arch/arm/mach-zynq/common.h
> @@ -39,8 +39,7 @@ extern struct smp_operations zynq_smp_ops __initdata;
>
>   extern void __iomem *zynq_scu_base;
>
> -/* Hotplug */
> -extern void zynq_platform_cpu_die(unsigned int cpu);
> +int zynq_pm_late_init(void);
>
>   int zynq_pm_late_init(void);
>
> diff --git a/arch/arm/mach-zynq/hotplug.c b/arch/arm/mach-zynq/hotplug.c
> index fe44a05677e2..b685c89f11e4 100644
> --- a/arch/arm/mach-zynq/hotplug.c
> +++ b/arch/arm/mach-zynq/hotplug.c
> @@ -12,20 +12,3 @@
>    */
>   #include <asm/proc-fns.h>
>
> -/*
> - * platform-specific code to shutdown a CPU
> - *
> - * Called with IRQs disabled
> - */
> -void zynq_platform_cpu_die(unsigned int cpu)
> -{
> -	zynq_slcr_cpu_state_write(cpu, true);
> -
> -	/*
> -	 * there is no power-control hardware on this platform, so all
> -	 * we can do is put the core into WFI; this is safe as the calling
> -	 * code will have already disabled interrupts
> -	 */
> -	for (;;)
> -		cpu_do_idle();
> -}
> diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
> index f77f7ca4c45b..04e578718aa2 100644
> --- a/arch/arm/mach-zynq/platsmp.c
> +++ b/arch/arm/mach-zynq/platsmp.c
> @@ -132,6 +132,24 @@ static int zynq_cpu_kill(unsigned cpu)
>   	zynq_slcr_cpu_stop(cpu);
>   	return 1;
>   }
> +
> +/*
> + * platform-specific code to shutdown a CPU
> + *
> + * Called with IRQs disabled
> + */
> +static void zynq_platform_cpu_die(unsigned int cpu)
> +{
> +	zynq_slcr_cpu_state_write(cpu, true);
> +
> +	/*
> +	 * there is no power-control hardware on this platform, so all
> +	 * we can do is put the core into WFI; this is safe as the calling
> +	 * code will have already disabled interrupts
> +	 */
> +	for (;;)
> +		cpu_do_idle();

IIUC, the cpu_do_idle() will flush the L1 cache and then call the WFI. 
It makes sense if we are about to power down the core. So I am wondering 
if we can just call wfi() instead.

> +}
>   #endif
>
>   struct smp_operations zynq_smp_ops __initdata = {
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

