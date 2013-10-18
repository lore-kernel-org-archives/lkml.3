Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab3JRMyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:54:37 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51460 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752210Ab3JRMyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:54:35 -0400
Date: Fri, 18 Oct 2013 13:53:16 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Tarek Dakhran <t.dakhran@samsung.com>
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v2 3/4] ARM: EXYNOS: add Exynos Dual Cluster Support
Message-ID: <20131018125315.GB2315@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 12:29:03PM +0400, Tarek Dakhran wrote:
> On 17.10.2013 19:46, Dave Martin wrote:
> > On Mon, Oct 14, 2013 at 07:08:24PM +0400, Vyacheslav Tyrtov wrote:
> >> From: Tarek Dakhran <t.dakhran@samsung.com>
> >> 
> >> Add EDCS(Exynos Dual Cluster Support) for Samsung Exynos5410 SoC.
> >> This enables all 8 cores, 4 x A7 and 4 x A15 run at the same time.
> >> 
> >> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> >> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> >> ---
> >>   arch/arm/mach-exynos/Makefile |   2 +
> >>   arch/arm/mach-exynos/edcs.c   | 270 ++++++++++++++++++++++++++++++++++++++++++
> >>   2 files changed, 272 insertions(+)
> >>   create mode 100644 arch/arm/mach-exynos/edcs.c
> >> 
> >> diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
> >> index 5369615..ba6efdb 100644
> >> --- a/arch/arm/mach-exynos/Makefile
> >> +++ b/arch/arm/mach-exynos/Makefile
> >> @@ -34,3 +34,5 @@ AFLAGS_exynos-smc.o		:=-Wa,-march=armv7-a$(plus_sec)
> >>   obj-$(CONFIG_MACH_EXYNOS4_DT)		+= mach-exynos4-dt.o
> >>   obj-$(CONFIG_MACH_EXYNOS5_DT)		+= mach-exynos5-dt.o
> >> +
> >> +obj-$(CONFIG_SOC_EXYNOS5410)		+= edcs.o
> >> diff --git a/arch/arm/mach-exynos/edcs.c b/arch/arm/mach-exynos/edcs.c
> >> new file mode 100644
> >> index 0000000..e304bd9
> >> --- /dev/null
> >> +++ b/arch/arm/mach-exynos/edcs.c
> >> @@ -0,0 +1,270 @@
> >> +/*
> >> + * arch/arm/mach-exynos/edcs.c - exynos dual cluster power management support
> >> + *
> >> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> >> + * Author: Tarek Dakhran <t.dakhran@samsung.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> + *
> >> + * EDCS(exynos dual cluster support) for Exynos5410 SoC.
> >> + */
> >> +

> [snip]

> >> +#define EDCS_CORE_STATUS(_nr)		(EDCS_CORE_CONFIGURATION(_nr) + 0x4)
> >> +#define EDCS_CORE_OPTION(_nr)		(EDCS_CORE_CONFIGURATION(_nr) + 0x8)
> >> +
> >> +#define REG_CPU_STATE_ADDR0		(S5P_VA_SYSRAM_NS + 0x28)
> > Is there any reason why S5P_VA_SYSRAM_NS needs to be a static mapping?

> What do you mean by "static mapping"?

See below

> > 
> >> +#define REG_CPU_STATE_ADDR(_nr)		(REG_CPU_STATE_ADDR0 +	\
> >> +						 _nr * EDCS_CPUS_PER_CLUSTER)
> >> +
> >> +static arch_spinlock_t edcs_lock = __ARCH_SPIN_LOCK_UNLOCKED;
> >> +
> >> +static int edcs_use_count[EDCS_CPUS_PER_CLUSTER][EDCS_CLUSTERS];
> >> +static int core_count[EDCS_CLUSTERS];
> >> +
> >> +static void exynos_core_power_control(unsigned int cpu, unsigned int cluster,
> >> +				bool enable)
> >> +{
> >> +	unsigned int offset = cluster * EDCS_CPUS_PER_CLUSTER + cpu;
> >> +	int value = enable ? S5P_CORE_LOCAL_PWR_EN : 0;
> >> +
> >> +	if ((__raw_readl(EDCS_CORE_STATUS(offset)) & 0x3) != value)
> >> +		__raw_writel(value, EDCS_CORE_CONFIGURATION(offset));
> > I think you need to replace all the __raw_readl() / __raw_writel() calls
> > in this file with readl_relaxed() / writel_relaxed().
> > 
> > This ensures little-endian byte order, so that BE8 kernels will work.
> > 
> Will be done.
> >> +}
> >> +
> >> +static void exynos_core_power_up(unsigned int cpu, unsigned int cluster)
> >> +{
> >> +	exynos_core_power_control(cpu, cluster, true);
> >> +}

> [snip]

> >> +
> >> +	edcs_use_count[cpu][cluster]++;
> >> +	if (edcs_use_count[cpu][cluster] == 1) {
> >> +		++core_count[cluster];
> >> +		set_boot_flag(cpu, 0x2);
> > 0x2 looks like a magic number.  Can we have a #define for that?

> Will be done.

Thanks

> > If the boot flag is read by the inbound CPU or by a peripheral then
> > there are memory ordering issues to take into account.  Otherwise, can't
> > the inbound CPU come online and race with the write to the boot flag?

> Inbound CPU doesn't write the boot flag.

Sorry, I didn't explain this clearly.  The scenario I'm thinking about is:

	CPU0 writes 2 to the boot flag

	The write is temporarily held in a write buffer somewhere in the
	memory system.

	CPU0 pokes the power controller to bring CPU1 online

	CPU1 powers up and starts running its boot ROM

	CPU1 reads the boot flag, but misses the value written by CPU0
	because that is still held in a write buffer somewhere, and isn't
	globally visible.

	... and finally ...

	The write to the boot flag drains and becomes globally visible.
	But it's too late now.

There's also the problem that set_boot_flag() and the read by the
boot ROM probably don't use the same memory type (Device versus
Strongly-Ordered for example).  The ARM Architecture doesn't guarantee
full coherency in situations like this.


I believe that a correct solution to this problem is to put a wmb()
between setting the boot flag and poking the power controller.

Putting the wmb() before the writel in exynos_core_power_control()
should do the job.

> > What is the memory type of REG_STATE_ADDR()?
> Same type as S5P_VA_SYSRAM_NS.
> This 4K region is mapped as follows:
> 
> static struct map_desc exynos5410_iodesc[] __initdata = {
> 	{
> 		.virtual	= (unsigned long)S5P_VA_SYSRAM_NS,
> 		.pfn		= __phys_to_pfn(EXYNOS5410_PA_SYSRAM_NS),
> 		.length		= SZ_4K,
> 		.type		= MT_DEVICE,
> 	},
> };

This is what I mean by a static mapping.

If this mapping isn't needed early (i.e., before ioremap works) then
ioremap can be used instead of reserving a specific virtual address.

This isn't a problem for this patch, just nice to have in general.

[...]

> >> +	arch_spin_lock(&edcs_lock);
> >> +	BUG_ON(__mcpm_cluster_state(cluster) != CLUSTER_UP);
> >> +	edcs_use_count[cpu][cluster]--;
> >> +	if (edcs_use_count[cpu][cluster] == 0) {
> >> +		--core_count[cluster];
> >> +		if (core_count[cluster] == 0)
> >> +			last_man = true;
> >> +	} else if (edcs_use_count[cpu][cluster] == 1) {
> >> +		/*
> >> +		 * A power_up request went ahead of us.
> >> +		 * Even if we do not want to shut this CPU down,
> >> +		 * the caller expects a certain state as if the WFI
> >> +		 * was aborted.  So let's continue with cache cleaning.
> >> +		 */
> >> +		skip_wfi = true;
> >> +	} else
> >> +		BUG();
> > For TC2, Lorenzo discovered need to disable the GIC CPU interface, so
> > that no suprious wakeups can happen once the power controller is
> > configured to power the CPU down.
> > 
> > The problem is that a spurious wakeup can trigger a race in the power
> > controller when the last man powers down, where the power controller
> > continues to wait for the cluster to power down, but it never happens.
> > 
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2013-September/200917.html
> > ([PATCH v2] arm: vexpress: tc2: fix hotplug/idle/kexec race on cluster power down)
> > 
> > 
> > This might not be a problem for Exynos5410 -- it depends on the way the
> > power control logic works.
> > 
> > On the other hand, disabling the GIC CPU interface here is cheap to do,
> > even if it's not really needed.

Did you have any further thoughts on this issue?

> >> +
> >> +	if (last_man && __mcpm_outbound_enter_critical(cpu, cluster)) {
> >> +		arch_spin_unlock(&edcs_lock);
> >> +
> >> +		if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A15) {
> >> +			/*
> >> +			 * On the Cortex-A15 we need to disable
> >> +			 * L2 prefetching before flushing the cache.
> >> +			 */
> >> +			asm volatile(
> >> +			"mcr	p15, 1, %0, c15, c0, 3\n\t"
> >> +			"isb\n\t"
> >> +			"dsb"
> >> +			: : "r" (0x400));
> >> +		}
> >> +
> >> +		/*
> >> +		 * We need to disable and flush the whole (L1 and L2) cache.
> >> +		 * Let's do it in the safest possible way i.e. with
> >> +		 * no memory access within the following sequence
> >> +		 * including the stack.
> >> +		 *
> >> +		 * Note: fp is preserved to the stack explicitly prior doing
> >> +		 * this since adding it to the clobber list is incompatible
> >> +		 * with having CONFIG_FRAME_POINTER=y.
> >> +		 */
> >> +		asm volatile(
> >> +		"str	fp, [sp, #-4]!\n\t"
> >> +		"mrc	p15, 0, r0, c1, c0, 0	@ get CR\n\t"
> >> +		"bic	r0, r0, #"__stringify(CR_C)"\n\t"
> >> +		"mcr	p15, 0, r0, c1, c0, 0	@ set CR\n\t"
> >> +		"isb\n\t"
> >> +		"bl	v7_flush_dcache_all\n\t"
> >> +		"clrex\n\t"
> >> +		"mrc	p15, 0, r0, c1, c0, 1	@ get AUXCR\n\t"
> >> +		"bic	r0, r0, #(1 << 6)	@ disable local coherency\n\t"
> >> +		"mcr	p15, 0, r0, c1, c0, 1	@ set AUXCR\n\t"
> >> +		"isb\n\t"
> >> +		"dsb\n\t"
> >> +		"ldr	fp, [sp], #4"
> >> +		: : : "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7",
> >> +			"r9", "r10", "lr", "memory");
> > For these code sequences, please take a look at
> > 
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/205085.html
> > [PATCH] ARM: cacheflush: consolidate single-CPU ARMv7 cache disabling code
> > 
> > The aim is to consolidate on a macro that can be shared between
> > backends.
> Will be done right after Nicolases patch will be applied to the mainline.

OK, keep an eye on it.

> >> +static int __init edcs_init(void)
> >> +{

[...]

> >> +	/*
> >> +	 * Future entries into the kernel can now go
> >> +	 * through the cluster entry vectors.
> >> +	 */
> >> +	__raw_writel(virt_to_phys(mcpm_entry_point),
> >> +				S5P_VA_SYSRAM_NS + 0x1c);
> > It would me more readable to have a #define to describe what
> > S5P_VA_SYSRAM_NS + 0x1c is.
> Will be done.

> > Also, what is the memory type of S5P_VA_SYSRAM_NS?  How is the entry
> > point address value read?  Does the inbound CPU's boot ROM or firmware
> > read it?

> The former (i.e. boot ROM reads it).

OK -- since that write is to device memory, I think we can assume in
practice that it will drain before the first secondary comes online.

If you follow the above advice about adding a wmb() in
exynos_core_power_control(), that should ensure correct ordering for
this too, if I've understood correctly.

Cheers
---Dave
