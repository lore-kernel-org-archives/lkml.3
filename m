Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaHRHrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 03:47:03 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:44499 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaHRHrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 03:47:00 -0400
MIME-Version: 1.0
In-Reply-To: <1408015178-21745-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
References: <1408015178-21745-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
Date: Mon, 18 Aug 2014 13:16:59 +0530
Message-ID: <CAKohponDNHYrD9b==cp+pVmAi2ygA9-HcLZWqr4w3DDivB=-Ng@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: powernv: Register the driver with reboot notifier
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 August 2014 16:49, Shilpasri G Bhat
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
> The reboot notifier will suspend the cpufreq governor and enable
> nominal frequency to be set during a reboot/kexec similar to the
> suspend operartion.
>
> Signed-off-by: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
> Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> ---
>  drivers/cpufreq/powernv-cpufreq.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
> index 379c083..e9f3d3a 100644
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
> @@ -314,9 +315,21 @@ static int powernv_cpufreq_cpu_init(struct cpufreq_policy *policy)
>         for (i = 0; i < threads_per_core; i++)
>                 cpumask_set_cpu(base + i, policy->cpus);
>
> +       policy->suspend_freq = pstate_id_to_freq(powernv_pstate_info.nominal);
>         return cpufreq_table_validate_and_show(policy, powernv_freqs);
>  }
>
> +static int powernv_cpufreq_reboot_notifier(struct notifier_block *nb,
> +                               unsigned long action, void *unused)
> +{
> +       cpufreq_suspend();
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
> @@ -325,6 +338,7 @@ static struct cpufreq_driver powernv_cpufreq_driver = {
>         .target_index   = powernv_cpufreq_target_index,
>         .get            = powernv_cpufreq_get,
>         .attr           = powernv_cpu_freq_attr,
> +       .suspend        = cpufreq_generic_suspend,

I couldn't understand why you have added a notifier here. This callback
by itself should be enough. Isn't it?

And then you have called cpufreq_suspend(), which is absolutely wrong,
from that notifier..
