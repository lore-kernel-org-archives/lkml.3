Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaH2ADe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 20:03:34 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:44799 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaH2ADc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 20:03:32 -0400
MIME-Version: 1.0
In-Reply-To: <1409234816-10802-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
References: <1409234816-10802-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Date: Fri, 29 Aug 2014 05:33:31 +0530
Message-ID: <CAKohpokbYkL=cYQ+9-59vPhBmbAWqhrEz7RBPj5-edDB25DPgw@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: powernv: Set the cpus to nominal frequency
 during reboot/kexec
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 August 2014 19:36, Shilpasri G Bhat
<shilpa.bhat@linux.vnet.ibm.com> wrote:
> This patch ensures the cpus to kexec/reboot at nominal frequency.
> Nominal frequency is the highest cpu frequency on PowerPC at
> which the cores can run without getting throttled.
>
> If the host kernel had set the cpus to a low pstate and then it
> kexecs/reboots to a cpufreq disabled kernel it would cause the target
> kernel to perform poorly. It will also increase the boot up time of
> the target kernel. So set the cpus to high pstate, in this case to
> nominal frequency before rebooting to avoid such scenarios.
>
> The reboot notifier will set the cpus to nominal frequncy.
>
> Changes v1->v2:
> Invoke .target() driver callback to set the cpus to nominal frequency
> in reboot notifier, instead of calling cpufreq_suspend() as suggested
> by Viresh Kumar.
> Modified the commit message.

This changelog will get commited, is this what you want?

> Signed-off-by: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
> Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> ---
>  drivers/cpufreq/powernv-cpufreq.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>
> diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
> index 379c083..ba27c49 100644
> --- a/drivers/cpufreq/powernv-cpufreq.c
> +++ b/drivers/cpufreq/powernv-cpufreq.c
> @@ -26,6 +26,7 @@
>  #include <linux/cpufreq.h>
>  #include <linux/smp.h>
>  #include <linux/of.h>
> +#include <linux/reboot.h>
>
>  #include <asm/cputhreads.h>
>  #include <asm/firmware.h>
> @@ -35,6 +36,7 @@
>  #define POWERNV_MAX_PSTATES    256
>
>  static struct cpufreq_frequency_table powernv_freqs[POWERNV_MAX_PSTATES+1];
> +static bool rebooting;
>
>  /*
>   * Note: The set of pstates consists of contiguous integers, the
> @@ -284,6 +286,15 @@ static void set_pstate(void *freq_data)
>  }
>
>  /*
> + * get_nominal_index: Returns the index corresponding to the nominal
> + * pstate in the cpufreq table
> + */
> +static inline unsigned int get_nominal_index(void)
> +{
> +       return powernv_pstate_info.max - powernv_pstate_info.nominal;
> +}
> +
> +/*
>   * powernv_cpufreq_target_index: Sets the frequency corresponding to
>   * the cpufreq table entry indexed by new_index on the cpus in the
>   * mask policy->cpus
> @@ -293,6 +304,9 @@ static int powernv_cpufreq_target_index(struct cpufreq_policy *policy,
>  {
>         struct powernv_smp_call_data freq_data;
>
> +       if (unlikely(rebooting) && new_index != get_nominal_index())
> +               return -EBUSY;

Have you placed the unlikely only around 'rebooting' intentionally or
should it cover whole if statement?

> +
>         freq_data.pstate_id = powernv_freqs[new_index].driver_data;
>
>         /*
> @@ -317,6 +331,25 @@ static int powernv_cpufreq_cpu_init(struct cpufreq_policy *policy)
>         return cpufreq_table_validate_and_show(policy, powernv_freqs);
>  }
>
> +static int powernv_cpufreq_reboot_notifier(struct notifier_block *nb,
> +                               unsigned long action, void *unused)
> +{
> +       int cpu;
> +       struct cpufreq_policy cpu_policy;
> +
> +       rebooting = true;
> +       for_each_online_cpu(cpu) {
> +               cpufreq_get_policy(&cpu_policy, cpu);
> +               powernv_cpufreq_target_index(&cpu_policy, get_nominal_index());
> +       }
> +
> +       return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block powernv_cpufreq_reboot_nb = {
> +       .notifier_call = powernv_cpufreq_reboot_notifier,
> +};
> +
>  static struct cpufreq_driver powernv_cpufreq_driver = {
>         .name           = "powernv-cpufreq",
>         .flags          = CPUFREQ_CONST_LOOPS,
> @@ -342,12 +375,14 @@ static int __init powernv_cpufreq_init(void)
>                 return rc;
>         }
>
> +       register_reboot_notifier(&powernv_cpufreq_reboot_nb);
>         return cpufreq_register_driver(&powernv_cpufreq_driver);
>  }
>  module_init(powernv_cpufreq_init);
>
>  static void __exit powernv_cpufreq_exit(void)
>  {
> +       unregister_reboot_notifier(&powernv_cpufreq_reboot_nb);
>         cpufreq_unregister_driver(&powernv_cpufreq_driver);
>  }
>  module_exit(powernv_cpufreq_exit);

Looks fine otherwise.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
