Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab3EaIzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:55:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57104 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3EaIzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:55:00 -0400
MIME-Version: 1.0
In-Reply-To: <51A7BFA6.3070800@semaphore.gr>
References: <51A7BFA6.3070800@semaphore.gr>
Date: Fri, 31 May 2013 14:24:59 +0530
Message-ID: <CAKohpo=yFV05ON3Dth=6gLMHEVRNVb2J5+8OeLNv2G8VmSXkkQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ondemand: Change the calculation of target frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 May 2013 02:37, Stratos Karafotis <stratosk@semaphore.gr> wrote:

Ahh.. earlier mail got sent without me doing complete review :(

> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> +static void od_check_cpu(int cpu, unsigned int load)
>  {
>         struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
>         struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
> @@ -176,29 +170,17 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
>         dbs_info->freq_lo = 0;
>
>         /* Check for frequency increase */
> -       if (load_freq > od_tuners->up_threshold * policy->cur) {
> +       if (load > od_tuners->up_threshold) {

Chances of this getting hit are minimal now.. I don't know if keeping
this will change anything now :)

>                 /* If switching to max speed, apply sampling_down_factor */
>                 if (policy->cur < policy->max)
>                         dbs_info->rate_mult =
>                                 od_tuners->sampling_down_factor;
>                 dbs_freq_increase(policy, policy->max);
>                 return;
> -       }
> -
> -       /* Check for frequency decrease */
> -       /* if we cannot reduce the frequency anymore, break out early */
> -       if (policy->cur == policy->min)
> -               return;
> -
> -       /*
> -        * The optimal frequency is the frequency that is the lowest that can
> -        * support the current CPU usage without triggering the up policy. To be
> -        * safe, we focus 10 points under the threshold.
> -        */
> -       if (load_freq < od_tuners->adj_up_threshold
> -                       * policy->cur) {
> +       } else {
> +               /* Calculate the next frequency proportional to load */
>                 unsigned int freq_next;
> -               freq_next = load_freq / od_tuners->adj_up_threshold;
> +               freq_next = load * policy->max / 100;

Rafael asked why you believe this is the right formula and I really couldn't
find an appropriate answer to that, sorry :(
