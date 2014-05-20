Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaETQoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:44:20 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:36525 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaETQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:44:16 -0400
MIME-Version: 1.0
In-Reply-To: <914cddcb07a8aa1a9ec984f436dd2bba69cfd128.1400302114.git.viresh.kumar@linaro.org>
References: <cover.1400302114.git.viresh.kumar@linaro.org>
	<914cddcb07a8aa1a9ec984f436dd2bba69cfd128.1400302114.git.viresh.kumar@linaro.org>
Date: Tue, 20 May 2014 09:44:15 -0700
X-Google-Sender-Auth: 4ISR1rodLhvVR-mmrstEOrJojI4
Message-ID: <CAD=FV=U8Q39qaE8Avk51LJDnBWLBXX_MqyoQV-jjpYUNwpJcrQ@mail.gmail.com>
Subject: Re: [PATCH V3 1/4] cpufreq: handle calls to ->target_index() in
 separate routine
From: Doug Anderson <dianders@chromium.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh,

On Fri, May 16, 2014 at 9:51 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Handling calls to ->target_index() has got complex over time and might become
> more complex. So, its better to take target_index() bits out in another routine
> __target_index() for better code readability. Shouldn't have any functional
> impact.
>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 56 ++++++++++++++++++++++++++++-------------------
>  1 file changed, 33 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index a05c921..9bf12a2 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1816,12 +1816,43 @@ EXPORT_SYMBOL(cpufreq_unregister_notifier);
>   *                              GOVERNORS                            *
>   *********************************************************************/
>
> +static int __target_index(struct cpufreq_policy *policy,
> +                         struct cpufreq_frequency_table *freq_table, int index)
> +{
> +       struct cpufreq_freqs freqs;
> +       int retval = -EINVAL;
> +       bool notify;
> +
> +       notify = !(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION);
> +
> +       if (notify) {
> +               freqs.old = policy->cur;
> +               freqs.new = freq_table[index].frequency;
> +               freqs.flags = 0;
> +
> +               pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
> +                               __func__, policy->cpu, freqs.old, freqs.new);
> +
> +               cpufreq_freq_transition_begin(policy, &freqs);
> +       }
> +
> +       retval = cpufreq_driver->target_index(policy, index);
> +       if (retval)
> +               pr_err("%s: Failed to change cpu frequency: %d\n",
> +                               __func__, retval);
> +
> +       if (notify)
> +               cpufreq_freq_transition_end(policy, &freqs, retval);
> +
> +       return retval;
> +}
> +
>  int __cpufreq_driver_target(struct cpufreq_policy *policy,
>                             unsigned int target_freq,
>                             unsigned int relation)
>  {
> -       int retval = -EINVAL;
>         unsigned int old_target_freq = target_freq;
> +       int retval = -EINVAL;

I'm not sure that this shuffling was really necessary, but I guess it
doesn't hurt.  ...and I guess a CL that's shuffling code anyway is the
place to put it...

Reviewed-by: Doug Anderson <dianders@chromium.org>
