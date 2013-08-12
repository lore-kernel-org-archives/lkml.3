Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3HLGuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 02:50:10 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:61707 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab3HLGuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 02:50:07 -0400
MIME-Version: 1.0
In-Reply-To: <149222df041360bac7bb58a9f9baa5f5b8277445.1376116345.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
	<149222df041360bac7bb58a9f9baa5f5b8277445.1376116345.git.viresh.kumar@linaro.org>
Date: Mon, 12 Aug 2013 12:20:06 +0530
Message-ID: <CAKohpomw7bamkJ3jyK0WNtduoowmMzq2FzwMPeOJYXzWWP5RbQ@mail.gmail.com>
Subject: Re: [PATCH 44/44] cpufreq: pass suitable index instead of freq to cpufreq_driver->target()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 August 2013 12:14, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> This tries to remove code redundancy from cpufreq driver by moving some common
> part of them to the core. Each driver calls cpufreq_frequency_table_target() to
> get a suitable index for a target frequency and then works on it. Its better to
> do this at core level before calling cpufreq driver and hence passing "index"
> instead of "target_freq and relation" to cpufreq_driver->target() routine.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---

> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 06f8671..4bf023d 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1628,7 +1628,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>                             unsigned int target_freq,
>                             unsigned int relation)
>  {
> -       int retval = -EINVAL;
> +       int retval = -EINVAL, index;
>         unsigned int old_target_freq = target_freq;
>
>         if (cpufreq_disabled())
> @@ -1645,11 +1645,35 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>         pr_debug("target for CPU %u: %u kHz, relation %u, requested %u kHz\n",
>                         policy->cpu, target_freq, relation, old_target_freq);
>
> +       /*
> +        * This might look like a redundant call as we are checking it again
> +        * after finding index. But it is left intentionally for cases where
> +        * same freq is called again and so we can save on few function calls.
> +        */
>         if (target_freq == policy->cur)
>                 return 0;
>
> -       if (cpufreq_driver->target)
> -               retval = cpufreq_driver->target(policy, target_freq, relation);
> +       if (cpufreq_driver->target) {
> +               struct cpufreq_frequency_table *freq_table;
> +
> +               freq_table = cpufreq_frequency_get_table(policy->cpu);
> +               if (unlikely(!freq_table)) {
> +                       pr_err("%s: Unable to find freq_table\n", __func__);
> +                       return retval;
> +               }
> +
> +               retval = cpufreq_frequency_table_target(policy, freq_table,
> +                               target_freq, relation, &index);
> +               if (unlikely(retval)) {
> +                       pr_err("%s: Unable to find matching freq\n", __func__);
> +                       return retval;
> +               }
> +
> +               if (freq_table[index].frequency == policy->cur)
> +                       return 0;
> +
> +               retval = cpufreq_driver->target(policy, index, relation);
> +       }
>
>         return retval;
>  }

Hi Rafael,

This was sent earlier by mistake but lets take advantage of that mistake
now :)

I wanted to discuss what's the right way to get this patch in..

Idea: was to simplify ->target() routines of drivers by finding the right index
prior to calling ->target().. And so the parameters would be changed to:

        int     (*target)       (struct cpufreq_policy *policy,
-                                unsigned int target_freq,
-                                unsigned int relation);
+                                unsigned int index)

Problem: Some drivers that implement ->target() doesn't have a freq table
with them and so they never call cpufreq_frequency_table_target to get
index and so passing Index for them is irrelevant.

What can we do here?
Solution 1: Define two types of ->target() one with above mentioned
prototype and other with the older style, And so drivers can initialize
one of them..

Issues: Two pointers for same work, doesn't look clean enough

Solution 2: Change prototype to something like this:
        int     (*target)       (struct cpufreq_policy *policy,
                                 unsigned int target_freq,
+                                unsigned int index,
                                 unsigned int relation);

Here,
  - target_freq: will have the freq requested (not the freq from table)
  - index: index of table suitable for this freq (for drivers exposing
freq_table)
    and will be -1 for others, like: at32, pcc, unicore2..
  - relation will stay as it is..

Issues: Not all parameters are useful for everybody.. Most of the drivers
wouldn't use target_freq or relation..


Which one do you like?

--
viresh
