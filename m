Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab3FZGsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:48:30 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:49418 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FZGs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:48:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130625161935.GA10208@jshin-Toonie>
References: <51C87ADC.4070409@canonical.com>
	<CAKohponCrC93D88Fgg_3LKsLG0KMeCVKsTEoy-N3jsdUQdgWvA@mail.gmail.com>
	<20130625161935.GA10208@jshin-Toonie>
Date: Wed, 26 Jun 2013 12:18:27 +0530
Message-ID: <CAKohpomSa0FRviZHkkJOeUUxubbzueVb3yyP5G8ASwpRB6wANQ@mail.gmail.com>
Subject: Re: od_set_powersave_bias: NULL pointer dereference
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 June 2013 21:49, Jacob Shin <jacob.shin@amd.com> wrote:
> Yes, so sorry about that, it looks like I failed to test with:

No problem, it happens :)

> CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_X86_AMD_FREQ_SENSITIVITY=m
>
> The following patch fixes this, Tim, could you please test ? :
>
> ---8<---
>
> From 3c727b1f775448599e67c5fb2121d79448e80c90 Mon Sep 17 00:00:00 2001
> From: Jacob Shin <jacob.shin@amd.com>
> Date: Tue, 25 Jun 2013 10:40:54 -0500
> Subject: [PATCH 1/1] cpufreq: fix NULL pointer deference at
>  od_set_powersave_bias()
>
> When initializing the default powersave_bias value, we need to first
> make sure that this policy is running the ondemand governor.
>
> Reported-by: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  drivers/cpufreq/cpufreq_ondemand.c |   17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index 4b9bb5d..93eb5cb 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -47,6 +47,8 @@ static struct od_ops od_ops;
>  static struct cpufreq_governor cpufreq_gov_ondemand;
>  #endif
>
> +static unsigned int default_powersave_bias;
> +
>  static void ondemand_powersave_bias_init_cpu(int cpu)
>  {
>         struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
> @@ -543,7 +545,7 @@ static int od_init(struct dbs_data *dbs_data)
>
>         tuners->sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR;
>         tuners->ignore_nice = 0;
> -       tuners->powersave_bias = 0;
> +       tuners->powersave_bias = default_powersave_bias;
>         tuners->io_is_busy = should_io_be_busy();
>
>         dbs_data->tuners = tuners;
> @@ -585,6 +587,7 @@ static void od_set_powersave_bias(unsigned int powersave_bias)
>         unsigned int cpu;
>         cpumask_t done;
>
> +       default_powersave_bias = powersave_bias;

Why are the above three changes required? And in case they are, then
they must have been commited separately.

>         cpumask_clear(&done);
>
>         get_online_cpus();
> @@ -593,11 +596,17 @@ static void od_set_powersave_bias(unsigned int powersave_bias)
>                         continue;
>
>                 policy = per_cpu(od_cpu_dbs_info, cpu).cdbs.cur_policy;
> -               dbs_data = policy->governor_data;
> -               od_tuners = dbs_data->tuners;
> -               od_tuners->powersave_bias = powersave_bias;
> +               if (!policy)
> +                       continue;

I am not sure if this is enough. What if we had ondemand as the
governor initially, then we changed it to something else. Now also
cur_policy contains a address and isn't zero.

>                 cpumask_or(&done, &done, policy->cpus);
> +
> +               if (policy->governor != &cpufreq_gov_ondemand)
> +                       continue;
> +
> +               dbs_data = policy->governor_data;
> +               od_tuners = dbs_data->tuners;
> +               od_tuners->powersave_bias = default_powersave_bias;
>         }
>         put_online_cpus();
>  }
> --
> 1.7.9.5
>
>
