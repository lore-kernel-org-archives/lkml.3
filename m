Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaIQAA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 20:00:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40077 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754299AbaIQAAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 20:00:23 -0400
Date: Wed, 17 Sep 2014 01:00:19 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jonathan Richardson <jonathar@broadcom.com>
Cc: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, JD Zheng <jdzheng@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Scott Branden <sbranden@broadcom.com>, Ray Jui <rjui@broadcom.com>
Subject: Re: [PATCH 1/6] ARM: cygnus: Initial support for Broadcom Cygnus SoC
Message-ID: <20140917000018.GI14191@leverpostej>
References: <jonathar@broadcom.com>
 <1410897497-27527-1-git-send-email-jonathar@broadcom.com>
 <1410897497-27527-2-git-send-email-jonathar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410897497-27527-2-git-send-email-jonathar@broadcom.com>
Thread-Topic: [PATCH 1/6] ARM: cygnus: Initial support for Broadcom Cygnus SoC
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 08:58:12PM +0100, Jonathan Richardson wrote:
> Adds initial support for the Cygnus SoC based on Broadcom’s iProc series.
> 
> Reviewed-by: Ray Jui <rjui@broadcom.com>
> Reviewed-by: Desmond Liu <desmondl@broadcom.com>
> Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
> Tested-by: Jonathan Richardson <jonathar@broadcom.com>
> Signed-off-by: Jonathan Richardson <jonathar@broadcom.com>
> ---
>  arch/arm/mach-bcm/Kconfig            |   34 +++++++
>  arch/arm/mach-bcm/Makefile           |    3 +
>  arch/arm/mach-bcm/board_bcm_cygnus.c |  166 ++++++++++++++++++++++++++++++++++

Is Cygnus an SoC or a board?

>  3 files changed, 203 insertions(+)
>  create mode 100644 arch/arm/mach-bcm/board_bcm_cygnus.c
> 
> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
> index fc93800..58e0f20 100644
> --- a/arch/arm/mach-bcm/Kconfig
> +++ b/arch/arm/mach-bcm/Kconfig
> @@ -5,6 +5,40 @@ menuconfig ARCH_BCM
>  
>  if ARCH_BCM
>  
> +config ARCH_BCM_IPROC
> +	bool "Broadcom ARMv7 iProc boards" if ARCH_MULTI_V7
> +	select ARM_GIC
> +	select CACHE_L2X0
> +	select HAVE_ARM_SCU if SMP

I didn't spot any SMP code in this series.

> +	select HAVE_ARM_TWD if LOCAL_TIMERS
> +	select HAVE_CLK
> +	select CLKSRC_OF
> +	select CLKSRC_MMIO
> +	select LOCAL_TIMERS if SMP
> +	select GENERIC_CLOCKEVENTS_BUILD

You don't need to select this.

> +	select GENERIC_CLOCKEVENTS
> +	select ARM_GLOBAL_TIMER
> +	select ARCH_REQUIRE_GPIOLIB
> +	select ARM_AMBA
> +	select PINCTRL
> +	select DEBUG_UART_8250
> +	help
> +	  This enables support for systems based on Broadcom IPROC architected SoCs.
> +	  The IPROC complex contains one or more ARM CPUs along with common
> +	  core periperals. Application specific SoCs are created by adding a
> +	  uArchitecture containing peripherals outside of the IPROC complex.
> +	  Currently supported SoCs are Cygnus.
> +
> +menu "iProc SoC based Machine types"
> +	depends on ARCH_BCM_IPROC
> +
> +	config ARCH_BCM_CYGNUS
> +		bool "Support Broadcom Cygnus board"
> +		select USB_ARCH_HAS_EHCI if USB_SUPPORT
> +		help
> +		  Support for Broadcom Cygnus SoC.
> +endmenu
> +
>  config ARCH_BCM_MOBILE
>  	bool "Broadcom Mobile SoC Support" if ARCH_MULTI_V7
>  	select ARCH_REQUIRE_GPIOLIB
> diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
> index b19a396..dd14a10 100644
> --- a/arch/arm/mach-bcm/Makefile
> +++ b/arch/arm/mach-bcm/Makefile
> @@ -10,6 +10,9 @@
>  # of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  # GNU General Public License for more details.
>  
> +# Cygnus
> +obj-$(CONFIG_ARCH_BCM_CYGNUS) +=  board_bcm_cygnus.o
> +
>  # BCM281XX
>  obj-$(CONFIG_ARCH_BCM_281XX)	+= board_bcm281xx.o
>  
> diff --git a/arch/arm/mach-bcm/board_bcm_cygnus.c b/arch/arm/mach-bcm/board_bcm_cygnus.c
> new file mode 100644
> index 0000000..d67555a
> --- /dev/null
> +++ b/arch/arm/mach-bcm/board_bcm_cygnus.c
> @@ -0,0 +1,166 @@
> +/*
> + * Copyright 2014 Broadcom Corporation.  All rights reserved.
> + *
> + * Unless you and Broadcom execute a separate written software license
> + * agreement governing use of this software, this software is licensed to you
> + * under the terms of the GNU General Public License version 2, available at
> + * http://www.broadcom.com/licenses/GPLv2.php (the "GPL").

Why don't we point at the gnu.org copy as we do elsewhere?

> + */
> +
> +#include <linux/of_address.h>
> +#include <linux/of_platform.h>
> +#include <linux/clocksource.h>
> +#include <linux/clk-provider.h>
> +#include <linux/delay.h>
> +#include <asm/mach/arch.h>
> +#include <asm/mach/map.h>
> +#include <asm/proc-fns.h>
> +#include <asm/hardware/cache-l2x0.h>
> +
> +#define CRMU_MAIL_BOX1      0x03024028

Please don't hard code addresses in board files.

> +#define CRMU_SOFT_RESET_CMD 0xFFFFFFFF
> +
> +/* CRU_RESET register */
> +static void * __iomem crmu_mail_box1_reg;
> +
> +#ifdef CONFIG_NEON
> +
> +#define CRU_BASE                  0x1800e000

Another hard coded address that needs to go.

> +#define CRU_SIZE                  0x34
> +#define CRU_CONTROL_OFFSET        0x0
> +#define CRU_PWRDWN_EN_OFFSET      0x4
> +#define CRU_PWRDWN_STATUS_OFFSET  0x8
> +#define CRU_NEON0_HW_RESET  6
> +#define CRU_CLAMP_ON_NEON0  20
> +#define CRU_PWRONIN_NEON0   21
> +#define CRU_PWRONOUT_NEON0  21
> +#define CRU_PWROKIN_NEON0   22
> +#define CRU_PWROKOUT_NEON0  22
> +#define CRU_STATUS_DELAY_NS 500
> +#define CRU_MAX_RETRY_COUNT 10
> +#define CRU_RETRY_INTVL_US  1
> +
> +/* Power up the NEON/VFPv3 block. */
> +static void bcm_cygnus_powerup_neon(void)
> +{
> +	void * __iomem cru_base = ioremap_nocache(CRU_BASE, CRU_SIZE);

Why not plain ioremap?

> +	u32 reg, i;
> +
> +	BUG_ON(!cru_base);

This seems a little extreme. Can;t we continue without NEON?

> +
> +	/* De-assert the neon hardware block reset */
> +	reg = readl(cru_base + CRU_CONTROL_OFFSET);
> +	reg &= ~(1 << CRU_NEON0_HW_RESET);
> +	writel(reg, cru_base + CRU_CONTROL_OFFSET);
> +
> +	/* Assert the power ON register bit */
> +	reg = readl(cru_base + CRU_PWRDWN_EN_OFFSET);
> +	reg |= (1 << CRU_PWRONIN_NEON0);
> +	writel(reg, cru_base + CRU_PWRDWN_EN_OFFSET);
> +
> +	/*
> +	 * Wait up to 10 usec in 1 usec increments for the
> +	 * status register to acknowledge the power ON assert
> +	 */
> +	for (i = 0; i < CRU_MAX_RETRY_COUNT; i++) {
> +		reg = readl(cru_base + CRU_PWRDWN_STATUS_OFFSET);
> +		if (reg & CRU_PWRONOUT_NEON0)
> +			break;
> +
> +		udelay(CRU_RETRY_INTVL_US);
> +	}
> +
> +	if (i == CRU_MAX_RETRY_COUNT)
> +		panic("NEON power ON register not acknowledged\n");

We can't just disable NEON if we fail to enable the HW block?

[...]

> +static void __init bcm_cygnus_timer_init(void)
> +{
> +	/* Initialize all clocks declared in device tree */
> +	of_clk_init(NULL);
> +
> +	clocksource_of_init();
> +}

If you take a look at time_init in arch/arm/kernel/time.c you'll see
this is redundant.

Get rid of this.

> +
> +static void __init bcm_cygnus_init(void)
> +{
> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +
> +	l2x0_of_init(0, ~0UL);
> +
> +	crmu_mail_box1_reg = ioremap_nocache(CRMU_MAIL_BOX1, SZ_4);

Why not plain ioremap?

> +	BUG_ON(!crmu_mail_box1_reg);

We only use this for reboot later on, so do we need to blow up so
spectacularly in this case?

> +
> +#ifdef CONFIG_NEON
> +	bcm_cygnus_powerup_neon();
> +#endif
> +}
> +
> +/*
> + * Reset the system
> + */
> +void bcm_cygnus_restart(enum reboot_mode mode, const char *cmd)
> +{
> +	/* Send reset command to M0 via Mailbox. */
> +	writel(CRMU_SOFT_RESET_CMD, crmu_mail_box1_reg);
> +	iounmap(crmu_mail_box1_reg);
> +
> +	/* Wait for M0 to reset the chip. */
> +	while (1)
> +		cpu_do_idle();
> +}

This doesn't have to live in the machine descriptor. It could be a
separate driver.

Thanks,
Mark.
