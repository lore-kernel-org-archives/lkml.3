Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbaDXN3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:29:42 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:39833 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483AbaDXN3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:29:38 -0400
Message-ID: <535911DC.9050109@linaro.org>
Date: Thu, 24 Apr 2014 15:30:04 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Amit Kucheria <amit.kucheria@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org>	<1398342291-16322-3-git-send-email-daniel.lezcano@linaro.org> <CAP245DX9wewQFhcyGj5ZuNE7hHC4fRn90POC32HLF6ugja6nJg@mail.gmail.com>
In-Reply-To: <CAP245DX9wewQFhcyGj5ZuNE7hHC4fRn90POC32HLF6ugja6nJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 03:13 PM, Amit Kucheria wrote:
> On Thu, Apr 24, 2014 at 5:54 PM, Daniel Lezcano
> <daniel.lezcano@linaro.org <mailto:daniel.lezcano@linaro.org>> wrote:
>
>     This patch adds a sysctl schedule balance option to choose against:
>
>       * auto        (0)
>       * performance (1)
>       * power       (2)
>
>     It relies on the recently added notifier to monitor the power supply
>     changes.
>     If the scheduler balance option is set to 'auto', then when the
>     system switches
>     to battery, the balance option change to 'power' and when it goes
>     back to AC, it
>     switches to 'performance'.
>
>     The default value is 'auto'.
>
>     If the kernel is compiled without the CONFIG_POWER_SUPPLY option,
>     then any call
>     to the 'auto' option will fail and the scheduler will use the
>     'performance'
>     option as default.
>
>     Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org
>     <mailto:daniel.lezcano@linaro.org>>
>     ---
>       include/linux/sched/sysctl.h |   14 +++++++
>       kernel/sched/fair.c          |   92
>     +++++++++++++++++++++++++++++++++++++++++-
>       kernel/sysctl.c              |   11 +++++
>       3 files changed, 115 insertions(+), 2 deletions(-)
>
>     diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
>     index 8045a55..f8507bf 100644
>     --- a/include/linux/sched/sysctl.h
>     +++ b/include/linux/sched/sysctl.h
>     @@ -44,6 +44,20 @@ enum sched_tunable_scaling {
>       };
>       extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
>
>     +#ifdef CONFIG_SMP
>     +enum sched_balance_option {
>
>
> What do you think of s/option/bias/g ?
>
> It is essentially biasing the scheduler towards performance or power

Yes, could be more adequate.

>     +       SCHED_BALANCE_OPTION_PERFORMANCE,
>     +       SCHED_BALANCE_OPTION_POWER,
>     +       SCHED_BALANCE_OPTION_AUTO,
>     +       SCHED_BALANCE_OPTION_END,
>     +};
>
>
>     +extern enum sched_balance_option sysctl_sched_balance_option;
>     +
>     +int sched_proc_balance_option_handler(struct ctl_table *table, int
>     write,
>     +               void __user *buffer, size_t *length,
>     +               loff_t *ppos);
>     +#endif
>     +
>       extern unsigned int sysctl_numa_balancing_scan_delay;
>       extern unsigned int sysctl_numa_balancing_scan_period_min;
>       extern unsigned int sysctl_numa_balancing_scan_period_max;
>     diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>     index 7570dd9..7b8e93d 100644
>     --- a/kernel/sched/fair.c
>     +++ b/kernel/sched/fair.c
>     @@ -29,7 +29,7 @@
>       #include <linux/mempolicy.h>
>       #include <linux/migrate.h>
>       #include <linux/task_work.h>
>     -
>     +#include <linux/power_supply.h>
>       #include <trace/events/sched.h>
>
>       #include "sched.h"
>     @@ -61,6 +61,24 @@ unsigned int normalized_sysctl_sched_latency =
>     6000000ULL;
>       enum sched_tunable_scaling sysctl_sched_tunable_scaling
>              = SCHED_TUNABLESCALING_LOG;
>
>     +#ifdef CONFIG_SMP
>     +/*
>     + * Scheduler balancing policy:
>     + *
>     + * Options are:
>     + * SCHED_BALANCE_OPTION_PERFORMANCE - full performance
>     + * SCHED_BALANCE_OPTION_POWER - power saving aggressive
>     + * SCHED_BALANCE_OPTION_AUTO - switches to 'performance' when plugged
>     + *                             on or 'power' on battery
>     + */
>     +enum sched_balance_option sysctl_sched_balance_option
>     +       = SCHED_BALANCE_OPTION_AUTO;
>     +
>     +static int sched_current_balance_option
>     +       = SCHED_BALANCE_OPTION_PERFORMANCE;
>     +
>     +#endif
>     +
>       /*
>        * Minimal preemption granularity for CPU-bound tasks:
>        * (default: 0.75 msec * (1 + ilog(ncpus)), units: nanoseconds)
>     @@ -555,6 +573,76 @@ static struct sched_entity
>     *__pick_next_entity(struct sched_entity *se)
>              return rb_entry(next, struct sched_entity, run_node);
>       }
>
>     +#ifdef CONFIG_SMP
>     +static int sched_balance_option_update(void)
>     +{
>     +       int ret;
>     +
>     +       /*
>     +        * Copy the current balance option
>     +        */
>     +       if (sysctl_sched_balance_option != SCHED_BALANCE_OPTION_AUTO) {
>     +               sched_current_balance_option =
>     sysctl_sched_balance_option;
>     +               return 0;
>     +       }
>     +
>     +       /*
>     +        * This call may fail if the kernel is not compiled with
>     +        * the POWER_SUPPLY option.
>     +        */
>     +       ret = power_supply_is_system_supplied();
>     +       if (ret < 0) {
>     +               sysctl_sched_balance_option =
>     sched_current_balance_option;
>     +               return ret;
>     +       }
>     +
>     +       /*
>     +        * When in 'auto' mode, switch to 'performance if the system
>     +        * is plugged on the wall, to 'power' if we are on battery
>     +        */
>     +       sched_current_balance_option = ret ?
>     +               SCHED_BALANCE_OPTION_PERFORMANCE :
>     +               SCHED_BALANCE_OPTION_POWER;
>     +
>     +       return 0;
>     +}
>     +
>
>
> I understand that this is only meant to kick off discussions and other
> criteria besides power being plugged in to bias the scheduler
> performance could be added later. But does it make sense to hardcode the
> power supply assumption into the scheduler?
>
> Can't we instead make sched_balance_option_update() a function pointer
> (with a default implementation that you've provided) that provide
> platforms the ability to override that with their own implementation?

I agree if that really hurts, it could be placed somewhere else, for 
example in a new file:
	kernel/sched/energy.c

But concerning the callback, I don't see the point to create a specific 
platform ops for that as the current code is generic. Do you have any 
use case in mind ?

Thanks for the review

   -- Daniel

>     +int sched_proc_balance_option_handler(struct ctl_table *table, int
>     write,
>     +               void __user *buffer, size_t *length,
>     +               loff_t *ppos)
>     +{
>     +       int ret;
>     +
>     +       ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
>     +       if (ret)
>     +               return ret;
>     +
>     +       return sched_balance_option_update();
>     +}
>     +
>     +static int sched_power_supply_notifier(struct notifier_block *b,
>     +                                      unsigned long l, void *v)
>     +{
>     +       sched_balance_option_update();
>     +       return NOTIFY_OK;
>     +}
>     +
>     +static struct notifier_block power_supply_notifier_nb = {
>     +       .notifier_call = sched_power_supply_notifier,
>     +};
>     +
>     +static int sched_balance_option_init(void)
>     +{
>     +       int ret;
>     +
>     +       ret = sched_balance_option_update();
>     +       if (ret)
>     +               return ret;
>     +
>     +       return power_supply_reg_notifier(&power_supply_notifier_nb);
>     +}
>     +#endif
>     +
>       #ifdef CONFIG_SCHED_DEBUG
>       struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
>       {
>     @@ -7695,7 +7783,7 @@ __init void init_sched_fair_class(void)
>       {
>       #ifdef CONFIG_SMP
>              open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
>     -
>     +       sched_balance_option_init();
>       #ifdef CONFIG_NO_HZ_COMMON
>              nohz.next_balance = jiffies;
>              zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
>     diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>     index 74f5b58..e4ecc7d 100644
>     --- a/kernel/sysctl.c
>     +++ b/kernel/sysctl.c
>     @@ -282,6 +282,17 @@ static struct ctl_table kern_table[] = {
>                      .mode           = 0644,
>                      .proc_handler   = proc_dointvec,
>              },
>     +#ifdef CONFIG_SMP
>     +       {
>     +               .procname       = "sched_balance_option",
>     +               .data           = &sysctl_sched_balance_option,
>     +               .maxlen         = sizeof(enum sched_balance_option),
>     +               .mode           = 0644,
>     +               .proc_handler   = sched_proc_balance_option_handler,
>     +               .extra1         = &zero, /* SCHED_BALANCE_OPTION_AUTO */
>     +               .extra2         = &two,  /*
>     SCHED_BALANCE_OPTION_POWER */
>     +       },
>     +#endif
>       #ifdef CONFIG_SCHED_DEBUG
>              {
>                      .procname       = "sched_min_granularity_ns",
>     --
>     1.7.9.5
>
>
>     _______________________________________________
>     linaro-kernel mailing list
>     linaro-kernel@lists.linaro.org <mailto:linaro-kernel@lists.linaro.org>
>     http://lists.linaro.org/mailman/listinfo/linaro-kernel
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

