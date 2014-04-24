Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaDXI7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:59:38 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:50279
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753049AbaDXI7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:59:35 -0400
Date: Thu, 24 Apr 2014 10:58:58 +0200
From: Anders Berg <anders.berg@lsi.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <olof@lixom.net>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>,
        <dbaryshkov@gmail.com>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] ARM: Add platform support for LSI AXM55xx SoC
Message-ID: <20140424085858.GA32357@swsaberg01>
References: <cover.1397552154.git.anders.berg@lsi.com>
 <80a2523d3e266ed12d5b70ac5518e963e47b27f4.1397552154.git.anders.berg@lsi.com>
 <6049946.vOU2aBg9qY@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6049946.vOU2aBg9qY@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [213.121.150.226]
X-ClientProxiedBy: BY2PR07CA062.namprd07.prod.outlook.com (10.141.251.37) To
 DM2PR07MB382.namprd07.prod.outlook.com (10.141.102.150)
X-Forefront-PRVS: 01917B1794
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(51704005)(199002)(189002)(24454002)(76482001)(19580395003)(80022001)(83506001)(50466002)(85852003)(77982001)(92726001)(92566001)(23726002)(20776003)(47776003)(83072002)(87976001)(4396001)(46102001)(33716001)(33656001)(79102001)(80976001)(83322001)(42186004)(66066001)(54356999)(76176999)(50986999)(31966008)(99396002)(81342001)(46406003)(81542001)(97756001)(74662001)(74502001)(86362001)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR07MB382;H:swsaberg01;FPR:CCAFF1D4.AF229785.7CF99697.C6FB3253.2079A;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 02:30:55PM +0200, Arnd Bergmann wrote:
> On Tuesday 15 April 2014 14:06:10 Anders Berg wrote:
> 
> > diff --git a/arch/arm/mach-axxia/Kconfig b/arch/arm/mach-axxia/Kconfig
> > new file mode 100644
> > index 0000000..336426a
> > --- /dev/null
> > +++ b/arch/arm/mach-axxia/Kconfig
> > @@ -0,0 +1,19 @@
> > +config ARCH_AXXIA
> > +	bool "LSI Axxia platforms" if (ARCH_MULTI_V7 && ARM_LPAE)
> > +	select ARM_GIC
> > +	select HAVE_SMP
> > +	select MFD_SYSCON
> > +	select ARM_AMBA
> > +	select ARCH_WANT_OPTIONAL_GPIOLIB
> > +	select HAVE_ARM_ARCH_TIMER
> > +	select ARM_TIMER_SP804
> > +	select ZONE_DMA
> > +	select ARCH_DMA_ADDR_T_64BIT
> > +	select ARCH_SUPPORTS_BIG_ENDIAN
> > +	select MIGHT_HAVE_PCI
> > +	select PCI_DOMAINS if PCI
> 
> No need to select HAVE_SMP or ARCH_WANT_OPTIONAL_GPIOLIB any more.

OK.

> 
> We should rethink the ARCH_SUPPORTS_BIG_ENDIAN option I guess. It makes
> little sense to select that from one platform in a multiplatform build
> if other platforms don't support it.
> 
> > --- /dev/null
> > +++ b/arch/arm/mach-axxia/Makefile.boot
> > @@ -0,0 +1,2 @@
> > +   zreladdr-y	+= 0x00308000
> > +params_phys-y	:= 0x00300100
> 
> This won't be used, since AUTO_ZRELADDR is set by ARCH_MULTIPLATFORM.

OK.

> 
> > diff --git a/arch/arm/mach-axxia/axxia.c b/arch/arm/mach-axxia/axxia.c
> > new file mode 100644
> > index 0000000..8d85926
> > --- /dev/null
> > +++ b/arch/arm/mach-axxia/axxia.c
> > @@ -0,0 +1,117 @@
> > +/*
> > + * Support for the LSI Axxia SoC devices based on ARM cores.
> > + *
> > + * Copyright (C) 2012 LSI
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#include <linux/amba/bus.h>
> > +#include <linux/device.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/init.h>
> > +#include <linux/io.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/kernel.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/sizes.h>
> > +#include <asm/mach/arch.h>
> > +#include <asm/pmu.h>
> > +#include "axxia.h"
> > +
> > +/*
> > + * The PMU IRQ lines of four cores are wired together into a single interrupt.
> > + * Bounce the interrupt to other cores if it's not ours.
> > + */
> > +static irqreturn_t axxia_pmu_handler(int irq, void *dev, irq_handler_t handler)
> > +{
> > +	irqreturn_t ret = handler(irq, dev);
> > +
> > +	if (ret == IRQ_NONE) {
> > +		int cpu = smp_processor_id();
> > +		int cluster = cpu / CORES_PER_CLUSTER;
> > +		int other;
> > +
> > +		/* Look until we find another cpu that's online. */
> > +		do {
> > +			other = (++cpu % CORES_PER_CLUSTER) +
> > +				(cluster * CORES_PER_CLUSTER);
> > +		} while (!cpu_online(other));
> > +
> > +		irq_set_affinity(irq, cpumask_of(other));
> > +	}
> > +
> > +	/*
> > +	 * We should be able to get away with the amount of IRQ_NONEs we give,
> > +	 * while still having the spurious IRQ detection code kick in if the
> > +	 * interrupt really starts hitting spuriously.
> > +	 */
> > +	return ret;
> > +}
> > +
> > +static struct arm_pmu_platdata pmu_pdata = {
> > +	.handle_irq = axxia_pmu_handler,
> > +};
> > +
> > +static struct of_dev_auxdata axxia_auxdata_lookup[] __initdata = {
> > +	OF_DEV_AUXDATA("arm,cortex-a15-pmu", 0, "pmu", &pmu_pdata),
> > +	{}
> > +};
> 
> This looks similar to what we have in mach-ux500 as db8500_pmu_handler.
> 
> To avoid duplication, I'd prefer moving support for this into the
> perf_event code itself, and get rid of the auxdata.
> 

I'll drop it fow now.

> > +static int
> > +axxia_bus_notifier(struct notifier_block *nb, unsigned long event, void *obj)
> > +{
> > +	struct device *dev = obj;
> > +
> > +	if (event != BUS_NOTIFY_ADD_DEVICE)
> > +		return NOTIFY_DONE;
> > +
> > +	if (!of_property_read_bool(dev->of_node, "dma-coherent"))
> > +		return NOTIFY_DONE;
> > +
> > +	set_dma_ops(dev, &arm_coherent_dma_ops);
> > +
> > +	return NOTIFY_OK;
> > +}
> > +
> > +static struct notifier_block axxia_platform_nb = {
> > +	.notifier_call = axxia_bus_notifier,
> > +};
> > +
> > +static struct notifier_block axxia_amba_nb = {
> > +	.notifier_call = axxia_bus_notifier,
> > +};
> 
> And we definitely want to do this in a generic fashion. That should not be in
> platform specific code.

I'll drop this too. I saw there was some work in progress on this.

> 
> > +static const char *axxia_dt_match[] __initconst = {
> > +	"lsi,axm55xx",
> > +	"lsi,axm55xx-sim",
> > +	"lsi,axm55xx-emu",
> > +	NULL
> > +};
> 
> Please no 'xx' in compatible strings. You can list all the relevant
> model numbers here, or require that machines list a specific model
> as compatible, e.g.
> 
> 	compatible = "lsi,axm5510-sim", "lsi,axm5510", "lsi,axm5502";
> 

Got that. I'll use lsi,axm5516 as the complatible model number.

> > +
> > +DT_MACHINE_START(AXXIA_DT, "LSI Axxia AXM55XX")
> > +	.dt_compat	= axxia_dt_match,
> > +	.smp		= smp_ops(axxia_smp_ops),
> > +	.init_machine	= axxia_dt_init,
> > +MACHINE_END
> 
> Please have a look at how smp ops are hooked up in mach-qcom and see
> if you can do it that way as well.
> 

Yes, that will work nicely.

> > diff --git a/arch/arm/mach-axxia/axxia.h b/arch/arm/mach-axxia/axxia.h
> > new file mode 100644
> > index 0000000..594dd97
> > --- /dev/null
> > +++ b/arch/arm/mach-axxia/axxia.h
> > @@ -0,0 +1,42 @@
> > +/*
> > + * Prototypes for platform functions.
> > + *
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> > + */
> > +#ifndef __AXXIA_H
> > +#define __AXXIA_H
> > +
> > +#define CORES_PER_CLUSTER      4
> > +
> > +#define AXXIA_PERIPH_PHYS      0x2000000000ULL
> > +#define AXXIA_SYSCON_PHYS      0x2010030000ULL
> 
> Remove these -- they have to come from DT.
> 
> > +#if 0
> > +#define AXXIA_UART0_PHYS       0x2010080000ULL
> > +#define AXXIA_UART1_PHYS       0x2010081000ULL
> > +#define AXXIA_UART2_PHYS       0x2010082000ULL
> > +#define AXXIA_UART3_PHYS       0x2010083000ULL
> > +
> > +#ifdef CONFIG_DEBUG_LL
> > +#define AXXIA_DEBUG_UART_VIRT  0xf0080000
> > +#define AXXIA_DEBUG_UART_PHYS  AXXIA_UART0_PHYS
> > +#endif
> > +#endif
> 
> You can put these constants directly into debug code.
> 

Ok.

> 
> > diff --git a/arch/arm/mach-axxia/platsmp.c b/arch/arm/mach-axxia/platsmp.c
> > new file mode 100644
> > index 0000000..fd7f507
> > --- /dev/null
> > +++ b/arch/arm/mach-axxia/platsmp.c
> > @@ -0,0 +1,183 @@
> > +/*
> > + *  linux/arch/arm/mach-axxia/platsmp.c
> > + *
> > + *  Copyright (C) 2012 LSI Corporation
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> 
> Have you considered using PSCI to bring up the secondary CPUs?
> 

The current u-boot is a bit dated... But I agree. I'll push for an update to this.

> > +static int axxia_boot_secondary(unsigned int cpu,
> > +					  struct task_struct *idle)
> > +{
> > +	unsigned long timeout;
> > +
> > +	/* Release the specified core */
> > +	write_pen_release(cpu_logical_map(cpu));
> > +
> > +	/* Send a wakeup event to get the idled cpu out of WFE state */
> > +	dsb_sev();
> > +
> > +	/* Wait for so long, then give up if nothing happens ... */
> > +	timeout = jiffies + (1 * HZ);
> > +	while (time_before(jiffies, timeout)) {
> > +		/* Make sure stores to pen_release have completed */
> > +		smp_rmb();
> > +		if (pen_release == -1)
> > +			break;
> > +		udelay(1);
> > +	}
> > +
> > +	return pen_release != -1 ? -ENOSYS : 0;
> > +}
> 
> This is pretty sad. No hardware support for waking up CPUs?
> 

I'll rework this. There are sw control of the resets to individual cores. And
the holding pen is not needed (too much other platsmp implementations), I will
have the secondary cores released directly into secondary_startup.

> > +static void __init axxia_smp_prepare_cpus(unsigned int max_cpus)
> > +{
> > +	void __iomem *syscon;
> > +	int cpu_count = 0;
> > +	int cpu;
> > +
> > +	syscon = ioremap(AXXIA_SYSCON_PHYS, SZ_64K);
> > +	if (WARN_ON(!syscon))
> > +		return;
> > +
> > +	check_fixup_sev(syscon);
> 
> Please use the syscon driver and regmap. That driver might need a little
> help to get syscon_node_to_regmap() to work before driver initialization,
> but other people need the same thing, and we should just implement it.

Ok, until then... I'll drop the hardcoded address and get the address from the
syscon node.

> 
> > diff --git a/drivers/clk/clk-axxia.c b/drivers/clk/clk-axxia.c
> > new file mode 100644
> > index 0000000..996b8f2
> > --- /dev/null
> > +++ b/drivers/clk/clk-axxia.c
> > @@ -0,0 +1,281 @@
> > +/*
> > + * arch/arm/mach-axxia/clock.c
> 
> This should be a separate patch, and get merged by the clk maintainer.
Ok.

I'll submit a v2 with the corrections.

/Anders

> 
> 	Arnd
> 
> 
