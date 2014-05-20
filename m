Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaETQsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:48:23 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:52993 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbaETQsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:48:19 -0400
MIME-Version: 1.0
In-Reply-To: <046e3785229754332de62854439d2a4a17d637b7.1400302114.git.viresh.kumar@linaro.org>
References: <cover.1400302114.git.viresh.kumar@linaro.org>
	<046e3785229754332de62854439d2a4a17d637b7.1400302114.git.viresh.kumar@linaro.org>
Date: Tue, 20 May 2014 09:48:18 -0700
X-Google-Sender-Auth: TB-NyOFT_2OX9DQzOy5yTYV2PqE
Message-ID: <CAD=FV=W3ngSVegSyeN9jRgmw4RBfFcypVDyTBNvzYOZ_XjsQwQ@mail.gmail.com>
Subject: Re: [PATCH V3 2/4] cpufreq: add support for intermediate (stable) frequencies
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

> +1.7 get_intermediate and target_intermediate
> +--------------------------------------------
> +
> +Only for drivers with target_index() and CPUFREQ_ASYNC_NOTIFICATION unset.
> +
> +get_intermediate should return a stable intermediate frequency platform wants to
> +switch to, and target_intermediate() should set CPU to to that frequency, before
> +jumping to the frequency corresponding to 'index'. Core will take care of
> +sending notifications and driver doesn't have to handle them in
> +target_intermediate() or target_index().

Is it worth documenting that if we implement target_intermediate()
that target_index() must not fail?  That means that any failure-prone
things (like setting a regulator) should happen in target_index().


>  2. Frequency Table Helpers
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 9bf12a2..f38f2f2 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1819,27 +1819,50 @@ EXPORT_SYMBOL(cpufreq_unregister_notifier);
>  static int __target_index(struct cpufreq_policy *policy,
>                           struct cpufreq_frequency_table *freq_table, int index)
>  {
> -       struct cpufreq_freqs freqs;
> +       struct cpufreq_freqs freqs = {.old = policy->cur, .flags = 0};
>         int retval = -EINVAL;
>         bool notify;
>
>         notify = !(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION);
> +       if (!notify)
> +               goto skip_notify;

I'm personally not a fan of using goto here.  All you're trying to do
is avoiding a level of indentation?  If it really matters that much
then create a sub function.  IMHO goto should generally be reserved
for error handling.


>
> -       if (notify) {
> -               freqs.old = policy->cur;
> -               freqs.new = freq_table[index].frequency;
> -               freqs.flags = 0;
> +       /* Handle switching to intermediate frequency */
> +       if (cpufreq_driver->get_intermediate) {
> +               freqs.new = cpufreq_driver->get_intermediate(policy, index);

Would it be worth it to change this to?

intermediate = 0
if (cpufreq_driver->get_intermediate)
  intermediate = cpufreq_driver->get_intermediate();
if (intermediate)

...the idea being that a driver may use an intermediate frequency for
some transitions but not for all.  For instance: on tegra if you
happen to change to the exact clock frequency of the intermediate PLL
it just stays there.  There's no need for two notifications in that
case.  There may be other systems that can optimize some transitions
to totally skip the intermediate stage (maybe you've got an
non-glitching divider somewhere so you can optimize a transition from
1.4GHz to 700MHz to go w/ no intermediate jump).


> -               pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
> +               pr_debug("%s: cpu: %d, switching to intermediate freq: oldfreq: %u, intermediate freq: %u\n",
>                                 __func__, policy->cpu, freqs.old, freqs.new);
>
>                 cpufreq_freq_transition_begin(policy, &freqs);
> +               retval = cpufreq_driver->target_intermediate(policy, freqs.new);

It feels like you want to pass in "index" here too, just in case.  A
driver may need to make decisions about other clocks based on the
eventual final frequency.  They could cache it themselves from the
get_intermediate() call, but that seems ugly.


> @@ -2361,7 +2384,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>             !(driver_data->setpolicy || driver_data->target_index ||
>                     driver_data->target) ||
>              (driver_data->setpolicy && (driver_data->target_index ||
> -                   driver_data->target)))
> +                   driver_data->target)) ||
> +            (!!driver_data->get_intermediate ^ !!driver_data->target_intermediate))

I'm OK with the !! trick, but using ^ here seems more confusing.  Why
not use "!="?
  (!!driver_data->get_intermediate != !!driver_data->target_intermediate))

-Doug
