Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbaEOSNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:13:17 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:59607 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbaEOSNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:13:15 -0400
MIME-Version: 1.0
In-Reply-To: <25738681139c04272b6d2ebeff244c6d36c893f7.1400133090.git.viresh.kumar@linaro.org>
References: <25738681139c04272b6d2ebeff244c6d36c893f7.1400133090.git.viresh.kumar@linaro.org>
Date: Thu, 15 May 2014 11:13:14 -0700
X-Google-Sender-Auth: PkLg05WJJIr1kGbf3Rk9p6sFgCQ
Message-ID: <CAD=FV=WktXavbpf0zN4=2KyF1uWXrysaRRQpAtAzqVhfDOJB5A@mail.gmail.com>
Subject: Re: [RFC] cpufreq: send notifications for intermediate (stable) frequencies
From: Doug Anderson <dianders@chromium.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        arvind.chauhan@arm.com, Stephen Warren <swarren@nvidia.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh,

On Wed, May 14, 2014 at 10:56 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Douglas Anderson, recently pointed out an interesting problem due to which his
> udelay() was expiring earlier than it should:
> https://lkml.org/lkml/2014/5/13/766
>
> While transitioning between frequencies few platforms may temporarily switch to
> a stable frequency, waiting for the main PLL to stabilize.
>
> For example: When we transition between very low frequencies on exynos, like
> between 200MHz and 300MHz, we may temporarily switch to a PLL running at 800MHz.
> No CPUFREQ notification is sent for that. That means there's a period of time
> when we're running at 800MHz but loops_per_jiffy is calibrated at between 200MHz
> and 300MHz. And so udelay behaves badly.
>
> To get this fixed in a generic way, lets introduce another callback safe_freq()
> for the cpufreq drivers.
>
> safe_freq() should return a stable intermediate frequency a platform might want
> to switch to, before jumping to the frequency corresponding to 'index'. Core
> will send the 'PRE' notification for this 'stable' frequency and 'POST' for the
> 'target' frequency. Though if ->target_index() fails, it will handle POST for
> 'stable' frequency only.
>
> Drivers must send 'POST' notification for 'stable' freq and 'PRE' for 'target'
> freq. If they can't switch to target frequency, they don't need to send any
> notification.

This will have the side effect of sending twice as many notifications.
 ...however it does allow for people registering for CPUFREQ
notifications to be more generic...

Thinking about it, I think you're right that this is the way to go.
The majority of the registrants of CPUFREQ that I see really ought to
be moved to common clock notifications (they are dealing with the fact
that a peripheral clock will get scaled as a side effect of CPUFREQ).
What's left is only a very small number of cases that would most
cleanly be dealt with by just seeing the extra notification.


> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Doug/Stephen,
>
> If this doesn't look too ugly, then I would need patches from you to fix your
> platforms as I am not well aware of clk hierarchy of your platforms.

It probably makes sense to wait until Thomas Abraham's patch lands,
since he's redoing exynos cpufreq to use cpufreq-cpu0.  ...and maybe
Thomas would be willing to write this patch?


>  drivers/cpufreq/cpufreq.c | 13 +++++++++++--
>  include/linux/cpufreq.h   | 18 ++++++++++++++++++
>  2 files changed, 29 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index a05c921..8d1cb4f 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1874,11 +1874,17 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>
>                 if (notify) {
>                         freqs.old = policy->cur;
> -                       freqs.new = freq_table[index].frequency;
> +                       /* Switch to some safe intermediate freq */
> +                       if (cpufreq_driver->safe_freq)

What do you think about calling this get_safe_freq().  It took me a
little while before I realized that this function didn't perform the
transition to the safe frequency--it just returned it.

...the comment adds extra confusion since it makes it sound like the
switch happens right here.


> +                               freqs.new = cpufreq_driver->safe_freq(policy,
> +                                                                     index);
> +                       else
> +                               freqs.new = freq_table[index].frequency;
>                         freqs.flags = 0;
>
>                         pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
> -                                __func__, policy->cpu, freqs.old, freqs.new);
> +                                __func__, policy->cpu, freqs.old,
> +                                freq_table[index].frequency);
>
>                         cpufreq_freq_transition_begin(policy, &freqs);
>                 }
> @@ -1887,6 +1893,9 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>                 if (retval)
>                         pr_err("%s: Failed to change cpu frequency: %d\n",
>                                __func__, retval);
> +               else
> +                       /* Send POST notification for the target frequency */
> +                       freqs.new = freq_table[index].frequency;

Don't you need to set freqs.old to the safe_freq?

-Doug
