Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3CVKZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:25:49 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:35079 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab3CVKZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:25:47 -0400
MIME-Version: 1.0
In-Reply-To: <514C1045.4060406@semaphore.gr>
References: <51366C77.3080309@semaphore.gr>
	<CAKohpokdG2vd5Cp4Lmcnc5ZrLsa-_4Kcy-DvLjG--6SMVsGZkg@mail.gmail.com>
	<51374F8D.9040300@semaphore.gr>
	<8496675.6HLUyC7fMI@vostro.rjw.lan>
	<514C1045.4060406@semaphore.gr>
Date: Fri, 22 Mar 2013 15:55:46 +0530
Message-ID: <CAKohpokiu9hK7D71aaWcVb_VQoK6qp5gzoPKXKvC3_cs2XNbEw@mail.gmail.com>
Subject: Re: [PATCH 3/3 linux-next] cpufreq: conservative: Use an inline
 function to evaluate freq_target
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 March 2013 13:33, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> Use an inline function to evaluate freq_target to avoid duplicate code.
>
> Also, define a macro for the default frequency step.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq_conservative.c | 28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
> index fe17bd3..63499c8 100644
> --- a/drivers/cpufreq/cpufreq_conservative.c
> +++ b/drivers/cpufreq/cpufreq_conservative.c
> @@ -29,11 +29,24 @@
>  /* Conservative governor macros */
>  #define DEF_FREQUENCY_UP_THRESHOLD             (80)
>  #define DEF_FREQUENCY_DOWN_THRESHOLD           (20)
> +#define DEF_FREQUENCY_STEP                     (5)
>  #define DEF_SAMPLING_DOWN_FACTOR               (1)
>  #define MAX_SAMPLING_DOWN_FACTOR               (10)
>
>  static DEFINE_PER_CPU(struct cs_cpu_dbs_info_s, cs_cpu_dbs_info);
>
> +static inline unsigned int get_freq_target(struct cs_dbs_tuners *cs_tuners,
> +                                          struct cpufreq_policy *policy)
> +{
> +       unsigned int freq_target = (cs_tuners->freq_step * policy->max) / 100;
> +
> +       /* max freq cannot be less than 100. But who knows... */
> +       if (unlikely(freq_target == 0))
> +               freq_target = DEF_FREQUENCY_STEP;
> +
> +       return freq_target;
> +}
> +
>  /*
>   * Every sampling_rate, we check, if current idle time is less than 20%
>   * (default), then we try to increase frequency. Every sampling_rate *
> @@ -49,7 +62,6 @@ static void cs_check_cpu(int cpu, unsigned int load)
>         struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
>         struct dbs_data *dbs_data = policy->governor_data;
>         struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
> -       unsigned int freq_target;
>
>         /*
>          * break out if we 'cannot' reduce the speed as the user might
> @@ -66,13 +78,7 @@ static void cs_check_cpu(int cpu, unsigned int load)
>                 if (dbs_info->requested_freq == policy->max)
>                         return;
>
> -               freq_target = (cs_tuners->freq_step * policy->max) / 100;
> -
> -               /* max freq cannot be less than 100. But who knows.... */
> -               if (unlikely(freq_target == 0))
> -                       freq_target = 5;
> -
> -               dbs_info->requested_freq += freq_target;
> +               dbs_info->requested_freq += get_freq_target(cs_tuners, policy);
>                 if (dbs_info->requested_freq > policy->max)
>                         dbs_info->requested_freq = policy->max;
>
> @@ -94,9 +100,7 @@ static void cs_check_cpu(int cpu, unsigned int load)
>                 if (policy->cur == policy->min)
>                         return;
>
> -               freq_target = (cs_tuners->freq_step * policy->max) / 100;
> -
> -               dbs_info->requested_freq -= freq_target;
> +               dbs_info->requested_freq -= get_freq_target(cs_tuners, policy);
>                 if (dbs_info->requested_freq < policy->min)
>                         dbs_info->requested_freq = policy->min;
>
> @@ -323,7 +327,7 @@ static int cs_init(struct dbs_data *dbs_data)
>         tuners->down_threshold = DEF_FREQUENCY_DOWN_THRESHOLD;
>         tuners->sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR;
>         tuners->ignore_nice = 0;
> -       tuners->freq_step = 5;
> +       tuners->freq_step = DEF_FREQUENCY_STEP;
>
>         dbs_data->tuners = tuners;
>         dbs_data->min_sampling_rate = MIN_SAMPLING_RATE_RATIO *
> --
> 1.8.1.4
>
>
