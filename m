Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaDYKyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:54:54 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:33416 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbaDYKyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:54:50 -0400
MIME-Version: 1.0
In-Reply-To: <535911DC.9050109@linaro.org>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org>
	<1398342291-16322-3-git-send-email-daniel.lezcano@linaro.org>
	<CAP245DX9wewQFhcyGj5ZuNE7hHC4fRn90POC32HLF6ugja6nJg@mail.gmail.com>
	<535911DC.9050109@linaro.org>
Date: Fri, 25 Apr 2014 16:24:49 +0530
Message-ID: <CAP245DXFRfARtEfj70XD8D8OiAT_1i_5G2zao+y0DT0Lg_YFJA@mail.gmail.com>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 7:00 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
>
> On 04/24/2014 03:13 PM, Amit Kucheria wrote:
>>
>> On Thu, Apr 24, 2014 at 5:54 PM, Daniel Lezcano
>> <daniel.lezcano@linaro.org <mailto:daniel.lezcano@linaro.org>> wrote:
>>
>>     This patch adds a sysctl schedule balance option to choose against:
>>
>>       * auto        (0)
>>       * performance (1)
>>       * power       (2)
>>
>>     It relies on the recently added notifier to monitor the power supply
>>     changes.
>>     If the scheduler balance option is set to 'auto', then when the
>>     system switches
>>     to battery, the balance option change to 'power' and when it goes
>>     back to AC, it
>>     switches to 'performance'.
>>
>>     The default value is 'auto'.
>>
>>     If the kernel is compiled without the CONFIG_POWER_SUPPLY option,
>>     then any call
>>     to the 'auto' option will fail and the scheduler will use the
>>     'performance'
>>     option as default.
>>
>>     Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org
>>     <mailto:daniel.lezcano@linaro.org>>
>>
>>     ---
>>       include/linux/sched/sysctl.h |   14 +++++++
>>       kernel/sched/fair.c          |   92
>>     +++++++++++++++++++++++++++++++++++++++++-
>>       kernel/sysctl.c              |   11 +++++
>>       3 files changed, 115 insertions(+), 2 deletions(-)
>>
>>     diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
>>     index 8045a55..f8507bf 100644
>>     --- a/include/linux/sched/sysctl.h
>>     +++ b/include/linux/sched/sysctl.h
>>     @@ -44,6 +44,20 @@ enum sched_tunable_scaling {
>>       };
>>       extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
>>
>>     +#ifdef CONFIG_SMP
>>     +enum sched_balance_option {
>>
>>
>> What do you think of s/option/bias/g ?
>>
>> It is essentially biasing the scheduler towards performance or power
>
>
> Yes, could be more adequate.
>
>
>>     +       SCHED_BALANCE_OPTION_PERFORMANCE,
>>     +       SCHED_BALANCE_OPTION_POWER,
>>     +       SCHED_BALANCE_OPTION_AUTO,
>>     +       SCHED_BALANCE_OPTION_END,
>>     +};
>>
>>
>>     +extern enum sched_balance_option sysctl_sched_balance_option;
>>     +
>>     +int sched_proc_balance_option_handler(struct ctl_table *table, int
>>     write,
>>     +               void __user *buffer, size_t *length,
>>     +               loff_t *ppos);
>>     +#endif
>>     +
>>       extern unsigned int sysctl_numa_balancing_scan_delay;
>>       extern unsigned int sysctl_numa_balancing_scan_period_min;
>>       extern unsigned int sysctl_numa_balancing_scan_period_max;
>>     diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>     index 7570dd9..7b8e93d 100644
>>     --- a/kernel/sched/fair.c
>>     +++ b/kernel/sched/fair.c
>>     @@ -29,7 +29,7 @@
>>       #include <linux/mempolicy.h>
>>       #include <linux/migrate.h>
>>       #include <linux/task_work.h>
>>     -
>>     +#include <linux/power_supply.h>
>>       #include <trace/events/sched.h>
>>
>>       #include "sched.h"
>>     @@ -61,6 +61,24 @@ unsigned int normalized_sysctl_sched_latency =
>>     6000000ULL;
>>       enum sched_tunable_scaling sysctl_sched_tunable_scaling
>>              = SCHED_TUNABLESCALING_LOG;
>>
>>     +#ifdef CONFIG_SMP
>>     +/*
>>     + * Scheduler balancing policy:
>>     + *
>>     + * Options are:
>>     + * SCHED_BALANCE_OPTION_PERFORMANCE - full performance
>>     + * SCHED_BALANCE_OPTION_POWER - power saving aggressive
>>     + * SCHED_BALANCE_OPTION_AUTO - switches to 'performance' when plugged
>>     + *                             on or 'power' on battery
>>     + */
>>     +enum sched_balance_option sysctl_sched_balance_option
>>     +       = SCHED_BALANCE_OPTION_AUTO;
>>     +
>>     +static int sched_current_balance_option
>>     +       = SCHED_BALANCE_OPTION_PERFORMANCE;
>>     +
>>     +#endif
>>     +
>>       /*
>>        * Minimal preemption granularity for CPU-bound tasks:
>>        * (default: 0.75 msec * (1 + ilog(ncpus)), units: nanoseconds)
>>     @@ -555,6 +573,76 @@ static struct sched_entity
>>     *__pick_next_entity(struct sched_entity *se)
>>              return rb_entry(next, struct sched_entity, run_node);
>>       }
>>
>>     +#ifdef CONFIG_SMP
>>     +static int sched_balance_option_update(void)
>>     +{
>>     +       int ret;
>>     +
>>     +       /*
>>     +        * Copy the current balance option
>>     +        */
>>     +       if (sysctl_sched_balance_option != SCHED_BALANCE_OPTION_AUTO) {
>>     +               sched_current_balance_option =
>>     sysctl_sched_balance_option;
>>     +               return 0;
>>     +       }
>>     +
>>     +       /*
>>     +        * This call may fail if the kernel is not compiled with
>>     +        * the POWER_SUPPLY option.
>>     +        */
>>     +       ret = power_supply_is_system_supplied();
>>     +       if (ret < 0) {
>>     +               sysctl_sched_balance_option =
>>     sched_current_balance_option;
>>     +               return ret;
>>     +       }
>>     +
>>     +       /*
>>     +        * When in 'auto' mode, switch to 'performance if the system
>>     +        * is plugged on the wall, to 'power' if we are on battery
>>     +        */
>>     +       sched_current_balance_option = ret ?
>>     +               SCHED_BALANCE_OPTION_PERFORMANCE :
>>     +               SCHED_BALANCE_OPTION_POWER;
>>     +
>>     +       return 0;
>>     +}
>>     +
>>
>>
>> I understand that this is only meant to kick off discussions and other
>> criteria besides power being plugged in to bias the scheduler
>> performance could be added later. But does it make sense to hardcode the
>> power supply assumption into the scheduler?
>>
>> Can't we instead make sched_balance_option_update() a function pointer
>> (with a default implementation that you've provided) that provide
>> platforms the ability to override that with their own implementation?
>
>
> I agree if that really hurts, it could be placed somewhere else, for example in a new file:
>         kernel/sched/energy.c
>
> But concerning the callback, I don't see the point to create a specific platform ops for that as the current code is generic. Do you have any use case in mind ?
>

I had a offline conversation with Daniel about this since there are
other triggers - thermal constraints and game-like apps being examples
- that might want to override the system policy. He intended
"performance" mode to mean the existing code paths and "power" mode to
mean *additional* new heuristics for energy-efficiency. The power
supply assumption is just the first one of those heuristics.

In that case, "performance" should be the default so we don't change
existing system behavior. And perhaps we want to keep these energy
heuristics in a separate file, at least until we've gotten them right.

While we're at it, can we attempt to replace power with energy since
that is what we're trying to save in most cases?
