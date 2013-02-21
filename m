Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab3BUE7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 23:59:23 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:65190 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3BUE7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 23:59:21 -0500
MIME-Version: 1.0
In-Reply-To: <51253715.7080600@semaphore.gr>
References: <51253715.7080600@semaphore.gr>
Date: Thu, 21 Feb 2013 10:29:16 +0530
X-Google-Sender-Auth: e8If8W2IiqHmpOwsG5gGpHBR7og
Message-ID: <CAOh2x=mD4DbEH245xsceS1wyhmrRPpB2LeJ9Mh+WGHUA+bZprA@mail.gmail.com>
Subject: Re: [PATCH linux-next] cpufreq: ondemand: Calculate gradient of CPU
 load to early increase frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stratos,

On Thu, Feb 21, 2013 at 2:20 AM, Stratos Karafotis
<stratosk@semaphore.gr> wrote:
> Instead of checking only the absolute value of CPU load_freq to increase
> frequency, we detect forthcoming CPU load rise and increase frequency
> earlier.
>
> Every sampling rate, we calculate the gradient of load_freq.
> If it is too steep we assume that the load most probably will
> go over up_threshold in next iteration(s). We reduce up_threshold
> by early_differential to achieve frequency increase in the current
> iteration.
>
> A new tuner early_demand is introduced to enable this functionality
> (disabled by default). Also we use new tuners to control early demand:
>
>         - early_differential: controls the final up_threshold
>         - grad_up_threshold: over this gradient of load we will decrease
>                 up_threshold by early_differential.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>

Sorry for this but i already have a patchset which has changed these files
to some extent. Can you please rebase over them? Actually my patchset
is already accepted, its just that rafael didn't wanted to have them for 3.9.

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-for-3.10

Back to your patch:

Following is what i understood about this patch:
- The only case where this code will come into picture is when load is
below up_threshold.
- And we see a steep rise in the load from previous request..

i.e. (with the default values)

UP_THRESHOLD                           (80)
GRAD_UP_THESHOLD                  (50)
EARLY_DIFFERENTIAL                 (45)

If the load was 10 previously and it went to 80 > load >= 60, we will
make up_threshold as 80-45 = 35. Which is lower than grad_up_threshold :)

Isn't it strange?

So, probably you just don't need this tunable: early_differential.
Rather just increase the frequency without doing this calculation:

if (load_freq > od_tuners.up_threshold * policy->cur) {

> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index f3eb26c..458806f 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -30,6 +30,8 @@
>  #define DEF_FREQUENCY_DOWN_DIFFERENTIAL                (10)
>  #define DEF_FREQUENCY_UP_THRESHOLD             (80)
>  #define DEF_SAMPLING_DOWN_FACTOR               (1)
> +#define DEF_GRAD_UP_THESHOLD                   (50)

s/THESHOLD/THRESHOLD

> @@ -170,11 +175,29 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
>  {
>         struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
>         struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
> +       unsigned int up_threshold = od_tuners.up_threshold;
> +       unsigned int grad;
>
>         dbs_info->freq_lo = 0;
>
> +       /*
> +        * Calculate the gradient of load_freq. If it is too steep we assume
> +        * that the load will go over up_threshold in next iteration(s). We
> +        * reduce up_threshold by early_differential to achieve frequency
> +        * increase earlier
> +        */
> +       if (od_tuners.early_demand) {
> +               if (load_freq > dbs_info->prev_load_freq) {

&& (load_freq < od_tuners.up_threshold * policy->cur) ??

> +                       grad = load_freq - dbs_info->prev_load_freq;
> +
> +                       if (grad > od_tuners.grad_up_threshold * policy->cur)
> +                               up_threshold -= od_tuners.early_differential;
> +               }
> +               dbs_info->prev_load_freq = load_freq;
> +       }
> +
>         /* Check for frequency increase */
> -       if (load_freq > od_tuners.up_threshold * policy->cur) {
> +       if (load_freq > up_threshold * policy->cur) {
>                 /* If switching to max speed, apply sampling_down_factor */
>                 if (policy->cur < policy->max)
>                         dbs_info->rate_mult =
> @@ -438,12 +461,26 @@ static ssize_t store_powersave_bias(struct kobject *a, struct attribute *b,
>         return count;
>  }

> +show_one(od, early_demand, early_demand);

What about making other two tunables rw?
