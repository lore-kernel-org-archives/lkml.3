Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbaEIPcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:32:13 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34044 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236AbaEIPcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:32:10 -0400
Date: Fri, 9 May 2014 16:32:06 +0100
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
        Chander Kashyap <k.chander@samsung.com>
Subject: Re: [Patch v4 5/5] mcpm: exynos: populate suspend and powered_up
 callbacks
Message-ID: <20140509153206.GB5040@e102568-lin.cambridge.arm.com>
References: <1399278444-8312-3-git-send-email-chander.kashyap@linaro.org>
 <1399282040-8995-1-git-send-email-chander.kashyap@linaro.org>
 <1399282040-8995-6-git-send-email-chander.kashyap@linaro.org>
MIME-Version: 1.0
In-Reply-To: <1399282040-8995-6-git-send-email-chander.kashyap@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 09 May 2014 15:32:15.0571 (UTC) FILETIME=[DB058A30:01CF6B9B]
X-MC-Unique: 114050916320803401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 10:27:20AM +0100, Chander Kashyap wrote:
> In order to support cpuidle through mcpm, suspend and powered-up
> callbacks are required in mcpm platform code.
> Hence populate the same callbacks.
> 
> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> ---
> Changes in v4: None
> Changes in v3:
> 	1. Removed coherancy enablement after suspend failure.

coherency

> 	2. Use generic function to poweron cpu.
> changes in v2:
> 	1. Fixed typo: enynos_pmu_cpunr to exynos_pmu_cpunr
>  arch/arm/mach-exynos/mcpm-exynos.c |   34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/arch/arm/mach-exynos/mcpm-exynos.c b/arch/arm/mach-exynos/mcpm-exynos.c
> index d0f7461..6d4a907 100644
> --- a/arch/arm/mach-exynos/mcpm-exynos.c
> +++ b/arch/arm/mach-exynos/mcpm-exynos.c
> @@ -256,10 +256,44 @@ static int exynos_power_down_finish(unsigned int cpu, unsigned int cluster)
>  	return -ETIMEDOUT; /* timeout */
>  }
>  
> +void exynos_powered_up(void)

static ?

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

If I were to be picky, I would compute these values only if they
are needed, ie move the computation after exynos_power_down().

There is another quite horrible issue here. We know this code works
because the processors A15/A7 hit the caches with C bit in SCTLR cleared.

On processors where this is not true, this sequence would explode
if power down fails (in case core is gated but L2 is still powered on,
the stack is stuck in L2) since it is going to read stack data that is
in L2 but can't be read.

It is not related to this sequence only, but it is an issue in general
and wanted to mention that on the lists for public awareness.

The gist of what I am saying is, please add a comment to that extent,
here and it should be added in exynos_power_down() too.

> +	__raw_writel(virt_to_phys(mcpm_entry_point), ns_sram_base_addr + 0x1c);

No magic numbers please (0x1c). You can add a macro/wrapper, as TC2 does.

> +	exynos_power_down();
> +
> +	/*
> +	 * Execution reaches here only if cpu did not power down.
> +	 * Hence roll back the changes done in exynos_power_down function.
> +	*/
> +	exynos_cpu_powerup(cpunr);

Please be aware that if this function returns MCPM will soft reboot, and
the CPUidle driver will have no way to detect a state entry failure.

I am just flagging this up, since fixing this behaviour is not easy, and
honestly, since power down failure should be the exception not the rule,
the idle stats should not be affected much.

I think this is the proper way of implementing the sequence but please
all keep in mind what I wrote above.

Lorenzo

> +}
> +
>  static const struct mcpm_platform_ops exynos_power_ops = {
>  	.power_up		= exynos_power_up,
>  	.power_down		= exynos_power_down,
>  	.power_down_finish	= exynos_power_down_finish,
> +	.suspend		= exynos_suspend,
> +	.powered_up		= exynos_powered_up,
>  };
>  
>  static void __init exynos_mcpm_usage_count_init(void)
> -- 
> 1.7.9.5
> 
> 

