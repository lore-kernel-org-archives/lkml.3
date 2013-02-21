Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3BUPdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:33:47 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47591 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab3BUPdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:33:46 -0500
MIME-Version: 1.0
In-Reply-To: <512605A1.8090106@semaphore.gr>
References: <51253715.7080600@semaphore.gr>
	<CAOh2x=mD4DbEH245xsceS1wyhmrRPpB2LeJ9Mh+WGHUA+bZprA@mail.gmail.com>
	<512605A1.8090106@semaphore.gr>
Date: Thu, 21 Feb 2013 21:03:44 +0530
X-Google-Sender-Auth: uyM8XjRGNFla7NtTDqcIljm6b68
Message-ID: <CAOh2x=m82jKMf+xgg+fjnCUHLpCQ_NgYqw4auyAidokt_z=uOw@mail.gmail.com>
Subject: Re: [PATCH v2 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Again,

On Thu, Feb 21, 2013 at 5:01 PM, Stratos Karafotis
<stratosk@semaphore.gr> wrote:

> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -168,16 +174,29 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
>         struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
>         struct dbs_data *dbs_data = policy->governor_data;
>         struct od_dbs_tuners *od_tuners = dbs_data->tuners;
> +       unsigned int prev_load_freq;
>
>         dbs_info->freq_lo = 0;
>
> +       /*
> +        * Calculate the gradient of load_freq. If it is too steep we assume
> +        * that the load will go over up_threshold in next iteration(s) and
> +        * we increase the frequency immediately
> +        */
> +       if (od_tuners->early_demand) {
> +               prev_load_freq = dbs_info->prev_load_freq;
> +               dbs_info->prev_load_freq = load_freq;
> +
> +               if (load_freq > prev_load_freq && (load_freq - prev_load_freq >
> +                   od_tuners->grad_up_threshold * policy->cur)) {
> +                       dbs_freq_increase(dbs_info, policy, policy->max);
> +                       return;
> +               }
> +       }
> +
>         /* Check for frequency increase */
>         if (load_freq > od_tuners->up_threshold * policy->cur) {
> -               /* If switching to max speed, apply sampling_down_factor */
> -               if (policy->cur < policy->max)
> -                       dbs_info->rate_mult =
> -                               od_tuners->sampling_down_factor;
> -               dbs_freq_increase(policy, policy->max);
> +               dbs_freq_increase(dbs_info, policy, policy->max);
>                 return;
>         }

Not really against your implementation, but this is what i thought of how
it should look like (initially when i reviewed your V1)

int boost_freq = 0;

       if (od_tuners->early_demand) {
               if (load_freq > dbs_info->prev_load_freq && (load_freq
- dbs_info->prev_load_freq >
                   od_tuners->grad_up_threshold * policy->cur)) {
                   boost_freq = 1;
               }

               dbs_info->prev_load_freq = load_freq;
       }

        /* Check for frequency increase */
        if (boost_freq || (load_freq > od_tuners->up_threshold * policy->cur)) {
                 increase-freq;


This would get rid of duplicate calls to increase_freq() and also
avoid changing its
prototype.
