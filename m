Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaHOKHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 06:07:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57441 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaHOKHM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 06:07:12 -0400
Date: Fri, 15 Aug 2014 11:07:04 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Juri Lelli <Juri.Lelli@arm.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <Will.Deacon@arm.com>, Chao Xie <chao.xie@marvell.com>,
        Stephen Warren <swarren@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Chao Xie Linux <xiechao.mail@gmail.com>,
        Juri Lelli <juri.lelli@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] cpuidle/cpuidle-big_little: fix reading cpu id part
 number
Message-ID: <20140815100704.GA4580@e102568-lin.cambridge.arm.com>
References: <1408004865-27525-1-git-send-email-juri.lelli@arm.com>
MIME-Version: 1.0
In-Reply-To: <1408004865-27525-1-git-send-email-juri.lelli@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 15 Aug 2014 10:07:08.0148 (UTC) FILETIME=[AC2C8340:01CFB870]
X-MC-Unique: 114081511070805301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 09:27:45AM +0100, Juri Lelli wrote:
> Commit af040ffc9ba1 ("ARM: make it easier to check the CPU part number
> correctly") changed ARM_CPU_PART_X masks, and the way they are returned and
> checked against. Usage of read_cpuid_part_number() is now deprecated, and
> calling places updated accordingly. This actually broke cpuidle-big_little
> initialization, as bl_idle_driver_init() performs a check using an hardcoded
> mask on cpu_id.
> 
> Create an interface to perform the check (that is now even easier to read).
> Define also a proper mask (ARM_CPU_PART_MASK) that makes this kind of checks
> cleaner and helps preventing bugs in the future. Update usage accordingly.

If Russell does not have any additional comments you can send it to his
patch system.

Thanks,
Lorenzo

> Signed-off-by: Juri Lelli <juri.lelli@arm.com>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Chao Xie <chao.xie@marvell.com>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Jonathan Austin <Jonathan.Austin@arm.com>
> Cc: Chao Xie Linux <xiechao.mail@gmail.com>
> Cc: Juri Lelli <juri.lelli@gmail.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/include/asm/cputype.h       |  3 ++-
>  arch/arm/include/asm/smp_plat.h      | 15 +++++++++++++++
>  drivers/cpuidle/cpuidle-big_little.c | 13 +++----------
>  3 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
> index 963a251..819777d 100644
> --- a/arch/arm/include/asm/cputype.h
> +++ b/arch/arm/include/asm/cputype.h
> @@ -74,6 +74,7 @@
>  #define ARM_CPU_PART_CORTEX_A12		0x4100c0d0
>  #define ARM_CPU_PART_CORTEX_A17		0x4100c0e0
>  #define ARM_CPU_PART_CORTEX_A15		0x4100c0f0
> +#define ARM_CPU_PART_MASK		0xff00fff0
>  
>  #define ARM_CPU_XSCALE_ARCH_MASK	0xe000
>  #define ARM_CPU_XSCALE_ARCH_V1		0x2000
> @@ -179,7 +180,7 @@ static inline unsigned int __attribute_const__ read_cpuid_implementor(void)
>   */
>  static inline unsigned int __attribute_const__ read_cpuid_part(void)
>  {
> -	return read_cpuid_id() & 0xff00fff0;
> +	return read_cpuid_id() & ARM_CPU_PART_MASK;
>  }
>  
>  static inline unsigned int __attribute_const__ __deprecated read_cpuid_part_number(void)
> diff --git a/arch/arm/include/asm/smp_plat.h b/arch/arm/include/asm/smp_plat.h
> index a252c0b..0ad7d49 100644
> --- a/arch/arm/include/asm/smp_plat.h
> +++ b/arch/arm/include/asm/smp_plat.h
> @@ -8,6 +8,7 @@
>  #include <linux/cpumask.h>
>  #include <linux/err.h>
>  
> +#include <asm/cpu.h>
>  #include <asm/cputype.h>
>  
>  /*
> @@ -25,6 +26,20 @@ static inline bool is_smp(void)
>  #endif
>  }
>  
> +/**
> + * smp_cpuid_part() - return part id for a given cpu
> + * @cpu:	logical cpu id.
> + *
> + * Return: part id of logical cpu passed as argument.
> + */
> +static inline unsigned int smp_cpuid_part(int cpu)
> +{
> +	struct cpuinfo_arm *cpu_info = &per_cpu(cpu_data, cpu);
> +
> +	return is_smp() ? cpu_info->cpuid & ARM_CPU_PART_MASK :
> +			  read_cpuid_part();
> +}
> +
>  /* all SMP configurations have the extended CPUID registers */
>  #ifndef CONFIG_MMU
>  #define tlb_ops_need_broadcast()	0
> diff --git a/drivers/cpuidle/cpuidle-big_little.c b/drivers/cpuidle/cpuidle-big_little.c
> index 344d79fa..ef94c3b 100644
> --- a/drivers/cpuidle/cpuidle-big_little.c
> +++ b/drivers/cpuidle/cpuidle-big_little.c
> @@ -138,25 +138,18 @@ static int bl_enter_powerdown(struct cpuidle_device *dev,
>  	return idx;
>  }
>  
> -static int __init bl_idle_driver_init(struct cpuidle_driver *drv, int cpu_id)
> +static int __init bl_idle_driver_init(struct cpuidle_driver *drv, int part_id)
>  {
> -	struct cpuinfo_arm *cpu_info;
>  	struct cpumask *cpumask;
> -	unsigned long cpuid;
>  	int cpu;
>  
>  	cpumask = kzalloc(cpumask_size(), GFP_KERNEL);
>  	if (!cpumask)
>  		return -ENOMEM;
>  
> -	for_each_possible_cpu(cpu) {
> -		cpu_info = &per_cpu(cpu_data, cpu);
> -		cpuid = is_smp() ? cpu_info->cpuid : read_cpuid_id();
> -
> -		/* read cpu id part number */
> -		if ((cpuid & 0xFFF0) == cpu_id)
> +	for_each_possible_cpu(cpu)
> +		if (smp_cpuid_part(cpu) == part_id)
>  			cpumask_set_cpu(cpu, cpumask);
> -	}
>  
>  	drv->cpumask = cpumask;
>  
> -- 
> 2.0.4
> 

