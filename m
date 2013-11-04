Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3KDRWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:22:32 -0500
Received: from benson.vm.bytemark.co.uk ([212.110.190.137]:39048 "EHLO
	benson.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab3KDRWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:22:31 -0500
X-Greylist: delayed 1724 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Nov 2013 12:22:31 EST
Message-ID: <1383583997.8826.123.camel@kazak.uk.xensource.com>
Subject: Re: [linux-sunxi] [PATCH 2/2] ARM: sun6i: Add SMP support for the
 Allwinner A31
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-sunxi@googlegroups.com
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Date: Mon, 04 Nov 2013 16:53:17 +0000
In-Reply-To: <1383471013-21695-3-git-send-email-maxime.ripard@free-electrons.com>
References: <1383471013-21695-1-git-send-email-maxime.ripard@free-electrons.com>
	 <1383471013-21695-3-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not a comment on the patch, or even A31, but a question about how the
SMP boot process works on sunxi generally...

On Sun, 2013-11-03 at 10:30 +0100, Maxime Ripard wrote:
> The A31 is a quad Cortex-A7. Add the logic to use the IPs used to
> control the CPU configuration and the CPU power so that we can bring up
> secondary CPUs at boot.
> [...]
> +	/* Set CPU boot address */
> +	writel(virt_to_phys(sun6i_secondary_startup),
> +	       cpucfg_membase + CPUCFG_PRIVATE0_REG);

Does the secondary CPU jump straight here from the lowlevel firmware or
does it go through the bootloader which reads the reg and does the jump?
I can't see any reference to this reg in u-boot so I guess the former?

I'm trying to work out if we can make this work with the requirement
which both Xen and KVM have to enter the kernel in NS-HYP mode.

The way this works on e.g. vexpress is (roughly) that u-boot wakes up
the secondary CPUs from the lowlevel firmware and places them into its
own holding pen, which has the same wake up protocol as the firmware so
the kernel can just use the same code. If u-boot never gets to run on
secondary CPUs that isn't going to help much. 

My concern is that the sequence here appears to involve resetting the
secondary CPU, which I figure will probably defeat that strategy by
kicking the CPU back into the lowlevel firmware in the reset state,
meaning it can't be done by a u-boot only change.

Hrm, what to do ... perhaps a DT driven selection between this mechanism
and sev to kick a wfe loop reading the private register?

Ian.

> +
> +	/* Assert the CPU core in reset */
> +	writel(0, cpucfg_membase + CPUCFG_CPU_RST_CTRL_REG(cpu));
> +
> +	/* Assert the L1 cache in reset */
> +	reg = readl(cpucfg_membase + CPUCFG_GEN_CTRL_REG);
> +	writel(reg & ~BIT(cpu), cpucfg_membase + CPUCFG_GEN_CTRL_REG);
> +
> +	/* Disable external debug access */
> +	reg = readl(cpucfg_membase + CPUCFG_DBG_CTL1_REG);
> +	writel(reg & ~BIT(cpu), cpucfg_membase + CPUCFG_DBG_CTL1_REG);
> +
> +	/* Power up the CPU */
> +	for (i = 0; i <= 8; i++)
> +		writel(0xff >> i, prcm_membase + PRCM_CPU_PWR_CLAMP_REG(cpu));
> +	mdelay(10);
> +
> +	/* Clear CPU power-off gating */
> +	reg = readl(prcm_membase + PRCM_CPU_PWROFF_REG);
> +	writel(reg & ~BIT(cpu), prcm_membase + PRCM_CPU_PWROFF_REG);
> +	mdelay(1);
> +
> +	/* Deassert the CPU core reset */
> +	writel(3, cpucfg_membase + CPUCFG_CPU_RST_CTRL_REG(cpu));
> +
> +	/* Enable back the external debug accesses */
> +	reg = readl(cpucfg_membase + CPUCFG_DBG_CTL1_REG);
> +	writel(reg | BIT(cpu), cpucfg_membase + CPUCFG_DBG_CTL1_REG);
> +
> +	spin_unlock(&cpu_lock);
> +
> +	return 0;
> +}
> +
> +struct smp_operations sun6i_smp_ops __initdata = {
> +	.smp_prepare_cpus	= sun6i_smp_prepare_cpus,
> +	.smp_boot_secondary	= sun6i_smp_boot_secondary,
> +};
> diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
> index f184f6c2fa33..b2e570253a8f 100644
> --- a/arch/arm/mach-sunxi/sunxi.c
> +++ b/arch/arm/mach-sunxi/sunxi.c
> @@ -26,6 +26,8 @@
>  #include <asm/mach/map.h>
>  #include <asm/system_misc.h>
>  
> +#include "common.h"
> +
>  #define SUN4I_WATCHDOG_CTRL_REG		0x00
>  #define SUN4I_WATCHDOG_CTRL_RESTART		BIT(0)
>  #define SUN4I_WATCHDOG_MODE_REG		0x04
> @@ -147,6 +149,7 @@ DT_MACHINE_START(SUN6I_DT, "Allwinner sun6i (A31) Family")
>  	.init_time	= sunxi_timer_init,
>  	.dt_compat	= sun6i_board_dt_compat,
>  	.restart	= sun6i_restart,
> +	.smp		= smp_ops(sun6i_smp_ops),
>  MACHINE_END
>  
>  static const char * const sun7i_board_dt_compat[] = {
> -- 
> 1.8.4
> 


