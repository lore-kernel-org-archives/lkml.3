Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbaDWQDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:03:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45112 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452AbaDWQDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:03:03 -0400
Date: Wed, 23 Apr 2014 17:02:56 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Chander Kashyap <chander.kashyap@linaro.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Chander Kashyap <k.chander@samsung.com>, nicolas.pitre@linaro.org
Subject: Re: [Patch v2 4/4] mcpm: exynos: populate suspend and powered_up
 callbacks
Message-ID: <20140423160256.GA1243@e102568-lin.cambridge.arm.com>
References: <1398080958-21677-5-git-send-email-chander.kashyap@linaro.org>
 <1398245154-18771-1-git-send-email-chander.kashyap@linaro.org>
 <1398245154-18771-5-git-send-email-chander.kashyap@linaro.org>
MIME-Version: 1.0
In-Reply-To: <1398245154-18771-5-git-send-email-chander.kashyap@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 23 Apr 2014 16:03:14.0399 (UTC) FILETIME=[885C2EF0:01CF5F0D]
X-MC-Unique: 114042317030000801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added Nico in CC]

On Wed, Apr 23, 2014 at 10:25:54AM +0100, Chander Kashyap wrote:
> In order to support cpuidle through mcpm, suspend and powered-up
> callbacks are required in mcpm platform code.
> Hence populate the same callbacks.
> 
> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> ---
> changes in v2:
> 	1. Fixed typo: enynos_pmu_cpunr to exynos_pmu_cpunr
> 
>  arch/arm/mach-exynos/mcpm-exynos.c |   53 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/arch/arm/mach-exynos/mcpm-exynos.c b/arch/arm/mach-exynos/mcpm-exynos.c
> index 6c74c82..d53f597 100644
> --- a/arch/arm/mach-exynos/mcpm-exynos.c
> +++ b/arch/arm/mach-exynos/mcpm-exynos.c
> @@ -272,10 +272,63 @@ static int exynos_power_down_finish(unsigned int cpu, unsigned int cluster)
>  	return 0; /* success: the CPU is halted */
>  }
>  
> +static void enable_coherency(void)
> +{
> +	unsigned long v, u;
> +
> +	asm volatile(
> +		"mrc	p15, 0, %0, c1, c0, 1\n"
> +		"orr	%0, %0, %2\n"
> +		"ldr	%1, [%3]\n"
> +		"and	%1, %1, #0\n"
> +		"orr	%0, %0, %1\n"
> +		"mcr	p15, 0, %0, c1, c0, 1\n"
> +		: "=&r" (v), "=&r" (u)
> +		: "Ir" (0x40), "Ir" (S5P_INFORM0)
> +		: "cc");
> +}
> +
> +void exynos_powered_up(void)
> +{
> +	unsigned int mpidr, cpu, cluster;
> +
> +	mpidr = read_cpuid_mpidr();
> +	cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> +	cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
> +
> +	arch_spin_lock(&exynos_mcpm_lock);
> +	if (cpu_use_count[cpu][cluster] == 0)
> +		cpu_use_count[cpu][cluster] = 1;
> +	arch_spin_unlock(&exynos_mcpm_lock);
> +}
> +
> +static void exynos_suspend(u64 residency)
> +{
> +	unsigned int mpidr, cpunr;
> +
> +	mpidr = read_cpuid_mpidr();
> +	cpunr = exynos_pmu_cpunr(mpidr);
> +
> +	__raw_writel(virt_to_phys(mcpm_entry_point), REG_ENTRY_ADDR);
> +
> +	exynos_power_down();
> +
> +	/*
> +	 * Execution reaches here only if cpu did not power down.
> +	 * Hence roll back the changes done in exynos_power_down function.
> +	*/
> +	__raw_writel(EXYNOS_CORE_LOCAL_PWR_EN,
> +			EXYNOS_ARM_CORE_CONFIGURATION(cpunr));
> +	set_cr(get_cr() | CR_C);
> +	enable_coherency();

This is wrong:

1) MCPM would eventually reboot the CPU in question if the suspend call
   returns (and restore SCTLR and ACTLR in cpu_resume), so there is 0 point
   in doing that here.
2) The core would have executed out of coherency for a "while" so the
   tlbs could be stale and you do not invalidate them. But given (1), (2)
   becomes just informational. The register write must be executed
   though (I guess...). Now, on restoring the SMP bit in cpu_resume
   (errata 799270) I need to verify this is safe and get back to you.

Cheers,
Lorenzo

