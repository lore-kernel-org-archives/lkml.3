Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541Ab3K1Ggu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 01:36:50 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:41403 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab3K1Ggp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 01:36:45 -0500
MIME-Version: 1.0
In-Reply-To: <1382226889-11062-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1382226889-11062-1-git-send-email-mark.langsdorf@calxeda.com>
Date: Thu, 28 Nov 2013 12:06:44 +0530
X-Google-Sender-Auth: wpP5GX_IhKY-sI4ruhdJpdKynIo
Message-ID: <CAOh2x=nyUDJz0N0Frz3X4-Omi6kcvQ37GEhXgmdw9bmQuWRZNw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq, highbank: enable ECME thermal notifications
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Sorry for a months delay.. I would suggest adding specific people in --to
field whom you want to review your patches. That's always helpful.

On Sun, Oct 20, 2013 at 5:24 AM, Mark Langsdorf
<mark.langsdorf@calxeda.com> wrote:
> The ECME sends thermal messages with a maximum and minimum allowed
> frequency when the SoC status reaches certain trip points known to the
> ECME. Use a notifier function to capture those messages and pass them
> to a work-queued function that can trigger a policy re-evaluation by
> cpufreq, capping the allowable frequencies.
>
> The core of the policy adjusting code was taken from
> drivers/thermal/cpu_cooling.c.
>
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> ---
>  drivers/cpufreq/highbank-cpufreq.c | 117 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 117 insertions(+)
>
> diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
> index b61b5a3..f0521d3 100644
> --- a/drivers/cpufreq/highbank-cpufreq.c
> +++ b/drivers/cpufreq/highbank-cpufreq.c
> @@ -17,15 +17,32 @@
>  #include <linux/module.h>
>  #include <linux/clk.h>
>  #include <linux/cpu.h>
> +#include <linux/cpufreq.h>

How was this missing earlier :)

>  #include <linux/err.h>
>  #include <linux/of.h>
>  #include <linux/mailbox.h>
>  #include <linux/platform_device.h>
> +#include <linux/cpumask.h>

Please add this after cpu.h to keep them in ascending order..
Also rearrange module and kernel.h to make this list sorted out in the
same patch..

> +#include <linux/workqueue.h>
>
>  #define HB_CPUFREQ_CHANGE_NOTE 0x80000001
> +#define HB_CPUFREQ_HEALTH_NOTE  0x00001001
> +#define HB_CPUFREQ_TPS_REPORT  1
>  #define HB_CPUFREQ_IPC_LEN     7
>  #define HB_CPUFREQ_VOLT_RETRIES        15
>
> +#define NOTIFY_INVALID NULL

Not actually required. Just use NULL everywhere you want this..

> +struct hb_notify_device {
> +       unsigned long max_freq;
> +       unsigned long min_freq;
> +       unsigned long thermal_state;
> +       struct cpumask *allowed_cpus;

Because this is always equal to cpu_possible_mask, you
don't actually need it..

> +};
> +
> +static struct hb_notify_device hb_records, *notify_device = NOTIFY_INVALID;
> +static struct work_struct hb_thermal_wq;
> +
>  static int hb_voltage_change(unsigned int freq)
>  {
>         u32 msg[HB_CPUFREQ_IPC_LEN] = {HB_CPUFREQ_CHANGE_NOTE, freq / 1000000};
> @@ -33,6 +50,89 @@ static int hb_voltage_change(unsigned int freq)
>         return pl320_ipc_transmit(msg);
>  }
>
> +static int hb_thermal_cpufreq_notify(struct notifier_block *nb,
> +                                   unsigned long event, void *data)
> +{
> +       struct cpufreq_policy *policy = data;
> +       unsigned long max_freq = 0, min_freq = 0;
> +
> +       if (event != CPUFREQ_ADJUST || notify_device == NOTIFY_INVALID)

I believe you should check notify_device == NOTIFY_INVALID first and then
value of event.

> +               return 0;
> +
> +       if (cpumask_test_cpu(policy->cpu, notify_device->allowed_cpus)) {

What's your system configuration (Just for my understanding)? How many
CPUs you have? They are sharing clock lines?

And anyway how can policy->cpu be out of cpu_possible_mask ?

> +               max_freq = notify_device->max_freq;
> +               min_freq = notify_device->min_freq;
> +       }
> +
> +       /* Never exceed user_policy.max */
> +       if (max_freq > policy->user_policy.max)
> +               max_freq = policy->user_policy.max;
> +       if (min_freq < policy->user_policy.min)
> +               min_freq = policy->user_policy.min;
> +
> +       if ((policy->max != max_freq) || (policy->min != min_freq))

Probably just call cpufreq_verify_within_limits() directly as we have
similar checks in there, it isn't too heavy ?

> +               cpufreq_verify_within_limits(policy, min_freq, max_freq);
> +
> +       return 0;
> +}
> +
> +static struct notifier_block hb_thermal_cpufreq_nb = {
> +       .notifier_call = hb_thermal_cpufreq_notify,
> +};
> +
> +/*
> + * We can't call cpufreq_adjust_policy from inside a notifier, so
> + * do it from inside a workqueue
> + */

Why exactly? Adding that into comment would be more useful..

> +static void hb_thermal_wq_task(struct work_struct *work)
> +{
> +       unsigned int cpuid;
> +       struct cpumask *mask = hb_records.allowed_cpus;
> +
> +       notify_device = &hb_records;
> +
> +       for_each_cpu(cpuid, mask) {

That's not a optimal solution. We have CPUs in groups normally
(i.e. sharing clock lines) and so each policy structure might be
common for few.. And so we need to do below only for policy->cpu
and no other CPUs from policy->affected_cpus.

> +               struct cpufreq_policy policy;
> +               if (cpufreq_get_policy(&policy, cpuid) == 0) {

Do you expect any CPUs to exist without a policy? If not, then
this check is just not required (Its heavy, memcpy)..

Otherwise, also just call cpufreq_update_policy() and check
return type for -ENODEV, which is returned if there is no
policy associated with it..

> +                       cpufreq_update_policy(cpuid);
> +                       break;
> +               }
> +       }
> +       notify_device = NOTIFY_INVALID;
> +}
