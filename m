Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab3FMHT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 03:19:27 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:64966 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab3FMHTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 03:19:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpom0-Z+s4G+OOhVZJn=HK7NVKHCXS-_0FJd07K+L5DwgHA@mail.gmail.com>
References: <1371028189-15758-1-git-send-email-chenxg@marvell.com>
	<CAKohponeWuaXPah4s9GjO-fLwQNuyKidUFosN1iE+e7bngDPdQ@mail.gmail.com>
	<CAFgnuDeeU5qALyqN4Akpi5SoHRXPWaq_PLYSSmjxkq9V5N=qag@mail.gmail.com>
	<CAKohpom0-Z+s4G+OOhVZJn=HK7NVKHCXS-_0FJd07K+L5DwgHA@mail.gmail.com>
Date: Thu, 13 Jun 2013 15:19:22 +0800
Message-ID: <CAFgnuDdSKDS_P2qRvCZmQzhxketojm0tQb6COuk2gnuQfs-Ztw@mail.gmail.com>
Subject: Re: [PATCH v4] cpufreq: fix governor start/stop race condition
From: Xiaoguang Chen <chenxg.marvell@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Xiaoguang Chen <chenxg@marvell.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        njiang1@marvell.com, zjwu@marvell.com, ylmao@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/13 Viresh Kumar <viresh.kumar@linaro.org>:
> On 13 June 2013 11:10, Xiaoguang Chen <chenxg.marvell@gmail.com> wrote:
>> 2013/6/12 Viresh Kumar <viresh.kumar@linaro.org>:
>>> On 12 June 2013 14:39, Xiaoguang Chen <chenxg@marvell.com> wrote:
>>>
>>>>         ret = policy->governor->governor(policy, event);
>>>
>>> We again reached to the same problem. We shouldn't call
>>> this between taking locks, otherwise recursive locks problems
>>> would be seen again.
>>
>> But this is not the same lock as the deadlock case, it is a new lock,
>> and only used in this function. no other functions use this lock.
>> I don't know how can we get dead lock again?
>
> I believe I have seen the recursive lock issue with different locks but
> I am not sure. Anyway, I believe the implementation can be simpler than
> that.
>
> Check below patch (attached too):
>
> ------------x------------------x----------------
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 2d53f47..80b9798 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -46,6 +46,7 @@ static DEFINE_PER_CPU(struct cpufreq_policy *,
> cpufreq_cpu_data);
>  static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>  #endif
>  static DEFINE_RWLOCK(cpufreq_driver_lock);
> +static DEFINE_MUTEX(cpufreq_governor_lock);
>
>  /*
>   * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
> @@ -1541,7 +1542,6 @@ static int __cpufreq_governor(struct
> cpufreq_policy *policy,
>  #else
>         struct cpufreq_governor *gov = NULL;
>  #endif
> -
>         if (policy->governor->max_transition_latency &&
>             policy->cpuinfo.transition_latency >
>             policy->governor->max_transition_latency) {
> @@ -1562,6 +1562,21 @@ static int __cpufreq_governor(struct
> cpufreq_policy *policy,
>
>         pr_debug("__cpufreq_governor for CPU %u, event %u\n",
>                                                 policy->cpu, event);
> +
> +       mutex_lock(&cpufreq_governor_lock);
> +       if ((!policy->governor_enabled && (event == CPUFREQ_GOV_STOP)) ||
> +           (policy->governor_enabled && (event == CPUFREQ_GOV_START))) {
> +               mutex_unlock(&cpufreq_governor_lock);
> +               return -EBUSY;
> +       }
> +
> +       if (event == CPUFREQ_GOV_STOP)
> +               policy->governor_enabled = 0;
> +       else if (event == CPUFREQ_GOV_START)
> +               policy->governor_enabled = 1;
> +
> +       mutex_unlock(&cpufreq_governor_lock);
> +
>         ret = policy->governor->governor(policy, event);
>
>         if (!ret) {
> @@ -1569,6 +1584,14 @@ static int __cpufreq_governor(struct
> cpufreq_policy *policy,
>                         policy->governor->initialized++;
>                 else if (event == CPUFREQ_GOV_POLICY_EXIT)
>                         policy->governor->initialized--;
> +       } else {
> +               /* Restore original values */
> +               mutex_lock(&cpufreq_governor_lock);
> +               if (event == CPUFREQ_GOV_STOP)
> +                       policy->governor_enabled = 1;
> +               else if (event == CPUFREQ_GOV_START)
> +                       policy->governor_enabled = 0;
> +               mutex_unlock(&cpufreq_governor_lock);
>         }
>
>         /* we keep one module reference alive for
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 037d36a..c12db73 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -107,6 +107,7 @@ struct cpufreq_policy {
>         unsigned int            policy; /* see above */
>         struct cpufreq_governor *governor; /* see below */
>         void                    *governor_data;
> +       int                     governor_enabled; /* governor start/stop flag */
>
>         struct work_struct      update; /* if update_policy() needs to be
>                                          * called, but you're in IRQ context */

Thanks
So you add the return value checking, I was about to do it in another patch :)
this patch is simpler than my previous patch,  it is ok for me.
Do I need to submit it again or it can be merged?

Thanks
Xiaoguang
