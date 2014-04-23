Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbaDWOhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:37:38 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:64669 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356AbaDWObd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:31:33 -0400
MIME-Version: 1.0
In-Reply-To: <1394739386-22260-1-git-send-email-venkateshs@google.com>
References: <1394739386-22260-1-git-send-email-venkateshs@google.com>
Date: Wed, 23 Apr 2014 16:31:32 +0200
Message-ID: <CABPqkBRm8Ux15UY2+hF1TZdVsgVbYV+9XPiuh9m497Mr3oJ0Wg@mail.gmail.com>
Subject: Re: [PATCH] perf/x86/intel: Use rdmsrl_safe when initializing RAPL PMU.
From: Stephane Eranian <eranian@google.com>
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 8:36 PM, Venkatesh Srinivas
<venkateshs@google.com> wrote:
> CPUs which should support the RAPL counters according to
> Family/Model/Stepping may still issue #GP when attempting to access
> the RAPL MSRs. This may happen when Linux is running under KVM and
> we are passing-through host F/M/S data, for example. Use rdmsrl_safe
> to first access the RAPL_POWER_UNIT MSR; if this fails, do not
> attempt to use this PMU.
>
> Signed-off-by: Venkatesh Srinivas <venkateshs@google.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_rapl.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
> index 5ad35ad..95700e5 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
> @@ -511,6 +511,7 @@ static int rapl_cpu_prepare(int cpu)
>         struct rapl_pmu *pmu = per_cpu(rapl_pmu, cpu);
>         int phys_id = topology_physical_package_id(cpu);
>         u64 ms;
> +       u64 msr_rapl_power_unit_bits;
>
>         if (pmu)
>                 return 0;
> @@ -518,6 +519,9 @@ static int rapl_cpu_prepare(int cpu)
>         if (phys_id < 0)
>                 return -1;
>
> +       if (!rdmsrl_safe(MSR_RAPL_POWER_UNIT, &msr_rapl_power_unit_bits))
> +               return -1;
> +
I have a problem with this patch on native hardware. This
rdmsrl_safe() systematically
fails when I know the MSR is perfectly valid on the CPU. Consequently, RAPL PMU
is disabled when I tried on IvyBridge and Haswell CPUs.

I don't know the internals of rdmsrl_safe(). Maybe it is invoked too
early in the boot process.

Please fix this.

>         pmu = kzalloc_node(sizeof(*pmu), GFP_KERNEL, cpu_to_node(cpu));
>         if (!pmu)
>                 return -1;
> @@ -531,8 +535,7 @@ static int rapl_cpu_prepare(int cpu)
>          *
>          * we cache in local PMU instance
>          */
> -       rdmsrl(MSR_RAPL_POWER_UNIT, pmu->hw_unit);
> -       pmu->hw_unit = (pmu->hw_unit >> 8) & 0x1FULL;
> +       pmu->hw_unit = (msr_rapl_power_unit_bits >> 8) & 0x1FULL;
>         pmu->pmu = &rapl_pmu_class;
>
>         /*
> @@ -649,7 +652,9 @@ static int __init rapl_pmu_init(void)
>         get_online_cpus();
>
>         for_each_online_cpu(cpu) {
> -               rapl_cpu_prepare(cpu);
> +               ret = rapl_cpu_prepare(cpu);
> +               if (ret)
> +                       goto out;
>                 rapl_cpu_init(cpu);
>         }
>
> @@ -672,6 +677,7 @@ static int __init rapl_pmu_init(void)
>                 hweight32(rapl_cntr_mask),
>                 ktime_to_ms(pmu->timer_interval));
>
> +out:
>         put_online_cpus();
>
>         return 0;
> --
> 1.9.0.279.gdc9e3eb
>
