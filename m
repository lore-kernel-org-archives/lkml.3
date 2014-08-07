Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbaHGKM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 06:12:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbaHGKM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 06:12:57 -0400
Message-ID: <53E35122.3040806@redhat.com>
Date: Thu, 07 Aug 2014 06:12:50 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
References: <53DB6B81.6050400@redhat.com> <53DBCBE8.6010809@codeaurora.org> <53DBE764.8050109@redhat.com> <53DBEC27.7050803@codeaurora.org> <CAKohpombG3Gj4mbm02vPNnAxzaRvQP7rb=iQ14dCFH4_+71H3w@mail.gmail.com> <53E0B657.4070007@redhat.com> <CAKohponxBdYEgY2oYuzmdaqfSRS8Uq8bZOzcb1QDmKO-z5ZBFQ@mail.gmail.com> <53E1556B.5070304@codeaurora.org> <CAKohpoky1-hj7cwnKc58svh8Z1Yas1=q4uJEK8mWcb56uqAcng@mail.gmail.com> <53E1FEE5.80305@redhat.com> <20140806150831.GB32301@codeaurora.org> <CAKohponBRn9mwpPMinsjqpHe3wTFj6aNpYk5gZaWDKht3bd5NQ@mail.gmail.com>
In-Reply-To: <CAKohponBRn9mwpPMinsjqpHe3wTFj6aNpYk5gZaWDKht3bd5NQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/07/2014 02:36 AM, Viresh Kumar wrote:
> On 6 August 2014 20:38, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> On 08/06, Prarit Bhargava wrote:
>>> Are you sure you're not seeing another lockdep warning?  That was my problem --
>>> there was an xfs related lockdep warning which then resulted in lockdep being
>>> disabled from that point on.
> 
> There is a fair chance that I might be doing something really really stupid,
> but I couldn't get the lockdep warning..
> 
>> Are we talking about the lockdep splat or the crash that started
>> this thread or something else? For the lockdep splat you need the
>> corrected patch in this thread and the per policy governor flag.
>> I'm not sure how to recreate the crash that started this thread.
> 
> We are talking about the lockdep splat that would happen if we don't
> drop locking around EXIT..
> 
> This is my full diff over mainline and my .config is attached.
> Please enlighten me on what am I missing :)

That should have done it.  What are your CPUFREQ configs?

P.

> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 6f02485..fa11a7d 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -2200,9 +2200,7 @@ static int cpufreq_set_policy(struct
> cpufreq_policy *policy,
>         /* end old governor */
>         if (old_gov) {
>                 __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> -               up_write(&policy->rwsem);
>                 __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
> -               down_write(&policy->rwsem);
>         }
> 
>         /* start new governor */
> @@ -2211,9 +2209,7 @@ static int cpufreq_set_policy(struct
> cpufreq_policy *policy,
>                 if (!__cpufreq_governor(policy, CPUFREQ_GOV_START))
>                         goto out;
> 
> -               up_write(&policy->rwsem);
>                 __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
> -               down_write(&policy->rwsem);
>         }
> 
>         /* new governor failed, so re-start old one */
> diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
> index 1e0ec57..027b6f7 100644
> --- a/drivers/cpufreq/exynos-cpufreq.c
> +++ b/drivers/cpufreq/exynos-cpufreq.c
> @@ -139,7 +139,7 @@ static int exynos_cpufreq_cpu_init(struct
> cpufreq_policy *policy)
>  }
> 
>  static struct cpufreq_driver exynos_driver = {
> -       .flags          = CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
> +       .flags          = CPUFREQ_STICKY |
> CPUFREQ_NEED_INITIAL_FREQ_CHECK | CPUFREQ_HAVE_GOVERNOR_PER_POLICY,
>         .verify         = cpufreq_generic_frequency_table_verify,
>         .target_index   = exynos_target,
>         .get            = cpufreq_generic_get,
> 
