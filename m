Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaJHGHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 02:07:20 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63468 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaJHGHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 02:07:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Morten Rasmussen <morten.rasmussen@arm.com>, peterz@infradead.org,
        mingo@redhat.com
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1411403047-32010-3-git-send-email-morten.rasmussen@arm.com>
Cc: dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        "Morten Rasmussen" <morten.rasmussen@arm.com>,
        tuukka.tikkanen@linaro.org
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
 <1411403047-32010-3-git-send-email-morten.rasmussen@arm.com>
Message-ID: <20141008060712.4379.42509@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 2/7] cpufreq: Architecture specific callback for frequency changes
Date: Tue, 07 Oct 2014 23:07:12 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Morten Rasmussen (2014-09-22 09:24:02)
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
> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> ---
>  drivers/cpufreq/cpufreq.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index d9fdedd..e911f6b 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -278,6 +278,10 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
>  }
>  #endif
>  
> +void __weak arch_scale_set_curr_freq(int cpu, unsigned long freq) {}
> +
> +void __weak arch_scale_set_max_freq(int cpu, unsigned long freq) {}

Hi Morten,

This approach assumes a single implementation for an architecture, which
probably will not scale across the myriad platforms we have merged in
mainline today. For ARM there could be any number of methods for
determining a cpus capacity, including use of CPUfreq or some other
platform-specific method.

I am vaguely aware of Intel-based platforms that do not implement ACPI,
so for that architecture I assume that an arch hook that assumes ACPI is
similarly restrictive.

I'll reply to this thread with a pair of patches that try to generalize
the functions you created in patches #2-4 of this series. I'm currently
hacking on a Chromebook 2 using the arm_big_little CPUfreq driver, so
you'll notice that is where I decided to implement the ops. Of course
those could be implemented in arch code, or some other driver.

Regards,
Mike

> +
>  static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
>                 struct cpufreq_freqs *freqs, unsigned int state)
>  {
> @@ -315,6 +319,7 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
>                 pr_debug("FREQ: %lu - CPU: %lu\n",
>                          (unsigned long)freqs->new, (unsigned long)freqs->cpu);
>                 trace_cpu_frequency(freqs->new, freqs->cpu);
> +               arch_scale_set_curr_freq(freqs->cpu, freqs->new);
>                 srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
>                                 CPUFREQ_POSTCHANGE, freqs);
>                 if (likely(policy) && likely(policy->cpu == freqs->cpu))
> @@ -2135,7 +2140,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
>                                 struct cpufreq_policy *new_policy)
>  {
>         struct cpufreq_governor *old_gov;
> -       int ret;
> +       int ret, cpu;
>  
>         pr_debug("setting new policy for CPU %u: %u - %u kHz\n",
>                  new_policy->cpu, new_policy->min, new_policy->max);
> @@ -2173,6 +2178,9 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
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
> 1.7.9.5
> 
> 
