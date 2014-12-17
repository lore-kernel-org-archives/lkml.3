Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaLQH4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 02:56:37 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:56939 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaLQH4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 02:56:35 -0500
MIME-Version: 1.0
In-Reply-To: <1417529192-11579-4-git-send-email-morten.rasmussen@arm.com>
References: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com> <1417529192-11579-4-git-send-email-morten.rasmussen@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 17 Dec 2014 08:56:14 +0100
Message-ID: <CAKfTPtAXGQRPGNBkAinzeR65xF0-WRr6wtTqf2-XtGzXGM5LNA@mail.gmail.com>
Subject: Re: [RFC PATCH 03/10] cpufreq: Architecture specific callback for
 frequency changes
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Michael Turquette <mturquette@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 December 2014 at 15:06, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> From: Morten Rasmussen <Morten.Rasmussen@arm.com>
>
> Architectures that don't have any other means for tracking cpu frequency
> changes need a callback from cpufreq to implement a scaling factor to
> enable scale-invariant per-entity load-tracking in the scheduler.
>
> To compute the scale invariance correction factor the architecture would
> need to know both the max frequency and the current frequency. This
> patch defines weak functions for setting both from cpufreq.
>
> Related architecture specific functions use weak function definitions.
> The same approach is followed here.
>
> These callbacks can be used to implement frequency scaling of cpu
> capacity later.
>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> ---
>  drivers/cpufreq/cpufreq.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 644b54e..1b17608 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -278,6 +278,10 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
>  }
>  #endif
>
> +void __weak arch_scale_set_curr_freq(int cpu, unsigned long freq) {}
> +
> +void __weak arch_scale_set_max_freq(int cpu, unsigned long freq) {}
> +
>  static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
>                 struct cpufreq_freqs *freqs, unsigned int state)
>  {
> @@ -315,6 +319,7 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
>                 pr_debug("FREQ: %lu - CPU: %lu\n",
>                          (unsigned long)freqs->new, (unsigned long)freqs->cpu);
>                 trace_cpu_frequency(freqs->new, freqs->cpu);
> +               arch_scale_set_curr_freq(freqs->cpu, freqs->new);

You must ensure that arch_scale_set_curr_freq will be called at least
once per CPU in order to ensure that you have a defined current
frequency.

If cpufreq don't have to change the frequency of a CPU, you will never
set the current frequency and the notification handler will never be
called. A typical example is a CPU booting at max frequency and we use
the performance governor; The CPU frequency is already the right one
so cpufreq will not change it and you will never call
arch_scale_set_curr_freq. The current frequency will be at least
undefined or set to 0 for ARM platform (according to patch 04) and the
arch_scale_freq_capacity will return 0

Regards,
Vincent

>                 srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
>                                 CPUFREQ_POSTCHANGE, freqs);
>                 if (likely(policy) && likely(policy->cpu == freqs->cpu))
> @@ -2164,7 +2169,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
>                                 struct cpufreq_policy *new_policy)
>  {
>         struct cpufreq_governor *old_gov;
> -       int ret;
> +       int ret, cpu;
>
>         pr_debug("setting new policy for CPU %u: %u - %u kHz\n",
>                  new_policy->cpu, new_policy->min, new_policy->max);
> @@ -2202,6 +2207,9 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
>         policy->min = new_policy->min;
>         policy->max = new_policy->max;
>
> +       for_each_cpu(cpu, policy->cpus)
> +               arch_scale_set_max_freq(cpu, policy->max);
> +
>         pr_debug("new min and max freqs are %u - %u kHz\n",
>                  policy->min, policy->max);
>
> --
> 1.9.1
>
>
