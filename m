Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3HPW0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:26:20 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22764 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751301Ab3HPW0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:26:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18nucoYm3rtu3F76XxnfD5X34ym7h1cm8o=
Date: Fri, 16 Aug 2013 16:48:31 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 5/5] ARM: mvebu: add board init for Armada 1500
Message-ID: <20130816204831.GX13964@titan.lakedaemon.net>
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376682098-10580-6-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376682098-10580-6-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 09:41:38PM +0200, Sebastian Hesselbarth wrote:
> This adds initial setup for the Marvell Armada 1500 SoCs. The code
> is fairly straight-forward, but especially _timer_and_clk_init()
> can be simplified by using default arch hooks. I will have some time
> until mach-mvebu is prepared for other SoCs moving over, so I can
> catch up with latest machine simplifications.
> 
> I am not so sure about the .map_io but I didn't yet fully understand
> the mapping requirement. Anyway, it is required for iomap and friends
> to work and basically remaps physical register addressed onto the same
> virtual addresses.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-mvebu/Kconfig       |   15 +++++++++
>  arch/arm/mach-mvebu/Makefile      |   13 ++++----
>  arch/arm/mach-mvebu/armada-1500.c |   63 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 85 insertions(+), 6 deletions(-)
>  create mode 100644 arch/arm/mach-mvebu/armada-1500.c
> 
> diff --git a/arch/arm/mach-mvebu/Kconfig b/arch/arm/mach-mvebu/Kconfig
> index 9eb63d7..e2e93ed 100644
> --- a/arch/arm/mach-mvebu/Kconfig
> +++ b/arch/arm/mach-mvebu/Kconfig
> @@ -36,6 +36,21 @@ config MACH_ARMADA_370
>  	  Say 'Y' here if you want your kernel to support boards based
>  	  on the Marvell Armada 370 SoC with device tree.
>  
> +config MACH_ARMADA_1500
> +	bool "Marvell Armada 1500 boards"
> +	select ARMADA_1500_CLK
> +	select ARM_GIC

nit, alpha.

> +	select CACHE_L2X0
> +	select CPU_PJ4B
> +	select DW_APB_TIMER_OF

> +	select LOCAL_TIMERS if SMP
> +	select HAVE_ARM_TWD if LOCAL_TIMERS

alpha.

> +	select HAVE_SMP
> +	select PINCTRL_ARMADA_1500
> +	help
> +	  Say 'Y' here if you want your kernel to support boards based
> +	  on the Marvell Armada 1500 SoC with device tree.
> +
>  config MACH_ARMADA_XP
>  	bool "Marvell Armada XP boards"
>  	select ARMADA_XP_CLK
> diff --git a/arch/arm/mach-mvebu/Makefile b/arch/arm/mach-mvebu/Makefile
> index 2d04f0e..2e10b4a 100644
> --- a/arch/arm/mach-mvebu/Makefile
> +++ b/arch/arm/mach-mvebu/Makefile
> @@ -1,10 +1,11 @@
>  ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include \
>  	-I$(srctree)/arch/arm/plat-orion/include
>  
> -AFLAGS_coherency_ll.o		:= -Wa,-march=armv7-a
> +AFLAGS_coherency_ll.o			:= -Wa,-march=armv7-a
>  
> -obj-y				 += system-controller.o
> -obj-$(CONFIG_MACH_ARMADA_370_XP) += armada-370-xp.o
> -obj-$(CONFIG_ARCH_MVEBU)	 += coherency.o coherency_ll.o pmsu.o
> -obj-$(CONFIG_SMP)                += platsmp.o headsmp.o
> -obj-$(CONFIG_HOTPLUG_CPU)        += hotplug.o
> +obj-y					+= system-controller.o
> +obj-$(CONFIG_MACH_ARMADA_370_XP)	+= armada-370-xp.o
> +obj-$(CONFIG_MACH_ARMADA_1500)		+= armada-1500.o

guess what?  :)

I swear I had a more substantive comment when I started this.  But after
a suitable application of gray matter, these nits were all that were
left. :(

thx,

Jason.

> +obj-$(CONFIG_ARCH_MVEBU)		+= coherency.o coherency_ll.o pmsu.o
> +obj-$(CONFIG_SMP)			+= platsmp.o headsmp.o
> +obj-$(CONFIG_HOTPLUG_CPU)		+= hotplug.o
> diff --git a/arch/arm/mach-mvebu/armada-1500.c b/arch/arm/mach-mvebu/armada-1500.c
> new file mode 100644
> index 0000000..b7c556b
> --- /dev/null
> +++ b/arch/arm/mach-mvebu/armada-1500.c
> @@ -0,0 +1,63 @@
> +/*
> + * Device Tree support for Armada 1500 platforms.
> + *
> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/clk-provider.h>
> +#include <linux/clocksource.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/of_platform.h>
> +#include <asm/hardware/cache-l2x0.h>
> +#include <asm/mach/arch.h>
> +#include <asm/mach/map.h>
> +#include <asm/mach/time.h>
> +#include "common.h"
> +#include "coherency.h"
> +
> +#define ARMADA_1500_REG_BASE_VIRT	0xf6000000
> +#define ARMADA_1500_REG_BASE_SIZE	0x03000000
> +
> +static struct map_desc armada_1500_io_desc[] __initdata = {
> +	{
> +		.virtual	= ARMADA_1500_REG_BASE_VIRT,
> +		.pfn		= __phys_to_pfn(ARMADA_1500_REG_BASE_VIRT),
> +		.length		= ARMADA_1500_REG_BASE_SIZE,
> +		.type		= MT_DEVICE,
> +	},
> +};
> +
> +static void __init armada_1500_map_io(void)
> +{
> +	iotable_init(armada_1500_io_desc, ARRAY_SIZE(armada_1500_io_desc));
> +}
> +
> +static void __init armada_1500_timer_and_clk_init(void)
> +{
> +	of_clk_init(NULL);
> +	clocksource_of_init();
> +}
> +
> +static void __init armada_1500_dt_init(void)
> +{
> +	l2x0_of_init(0x70c00000, 0xfeffffff);
> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +}
> +
> +static const char * const armada_1500_dt_compat[] = {
> +	"marvell,armada-1500",
> +	NULL,
> +};
> +
> +DT_MACHINE_START(ARMADA_1500_DT, "Marvell Armada 1500")
> +	.init_machine	= armada_1500_dt_init,
> +	.map_io		= armada_1500_map_io,
> +	.init_time	= armada_1500_timer_and_clk_init,
> +	.dt_compat	= armada_1500_dt_compat,
> +MACHINE_END
> -- 
> 1.7.10.4
> 
