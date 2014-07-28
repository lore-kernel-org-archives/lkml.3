Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaG1SvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:51:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38222 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaG1SvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:51:03 -0400
Message-ID: <53D69BB3.8040106@arm.com>
Date: Mon, 28 Jul 2014 19:51:31 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/19] ARM64 / ACPI: Introduce arch_fix_phys_package_id()
 for cpu topology
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <1406206825-15590-5-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1406206825-15590-5-git-send-email-hanjun.guo@linaro.org>
X-OriginalArrivalTime: 28 Jul 2014 18:51:00.0963 (UTC) FILETIME=[E027F330:01CFAA94]
X-MC-Unique: 114072819510103901
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/07/14 14:00, Hanjun Guo wrote:
> arch_fix_phys_package_id() will be called in ACPI core to use
> the slot number provided by ACPI to update the physical package
> id, then we can get the right value in the "physical id" field
> of /proc/cpuinfo.
>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>   arch/arm64/include/asm/topology.h |    2 ++
>   arch/arm64/kernel/topology.c      |   14 ++++++++++++++
>   2 files changed, 16 insertions(+)
>
> diff --git a/arch/arm64/include/asm/topology.h b/arch/arm64/include/asm/topology.h
> index 7ebcd31..2b216d4 100644
> --- a/arch/arm64/include/asm/topology.h
> +++ b/arch/arm64/include/asm/topology.h
> @@ -23,11 +23,13 @@ extern struct cpu_topology cpu_topology[NR_CPUS];
>   void init_cpu_topology(void);
>   void store_cpu_topology(unsigned int cpuid);
>   const struct cpumask *cpu_coregroup_mask(int cpu);
> +void arch_fix_phys_package_id(int num, u32 slot);
>
>   #else
>
>   static inline void init_cpu_topology(void) { }
>   static inline void store_cpu_topology(unsigned int cpuid) { }
> +static inline void arch_fix_phys_package_id(int num, u32 slot) { }
>
>   #endif
>
> diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
> index 43514f9..c547885 100644
> --- a/arch/arm64/kernel/topology.c
> +++ b/arch/arm64/kernel/topology.c
> @@ -281,3 +281,17 @@ void __init init_cpu_topology(void)
>   	if (parse_dt_topology())
>   		reset_cpu_topology();
>   }
> +
> +/*
> + * Use the CPU slot number provided by ACPI to update the physical
> + * package id when cpuid_topo->cluster_id is not available, then we
> + * can get the right value in the "physical id" field of /proc/cpuinfo.
> + */

We don't have "physical id" field in /proc/cpuinfo on ARM64.

> +void arch_fix_phys_package_id(int num, u32 slot)
> +{
> +	struct cpu_topology *cpuid_topo = &cpu_topology[num];
> +
> +	if (cpuid_topo->cluster_id == -1)
> +		cpuid_topo->cluster_id = slot;
> +}
> +EXPORT_SYMBOL_GPL(arch_fix_phys_package_id);
>

The ACPI core uses this function to set the package id as read from
_SUN from the device. As per spec, _SUN is used by OSPM UI to identify
slots for the user. Do we know how will this be used on ARM64 ?

If not clear at this time, better to define it or keep it empty. I see
even x86 does nothing in that function.

Regards,
Sudeep

