Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaHLJRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:17:16 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:40986 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbaHLJRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:17:13 -0400
MIME-Version: 1.0
Date: Tue, 12 Aug 2014 14:47:12 +0530
Message-ID: <CAKohponk8Gsr3VwxSXbmfNRX2vDr8m_Tn=_1jUG6W1WcMdZb9w@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] cpufreq: Properly handle physical CPU hot-add/hot-remove
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2014 03:45, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 08/07/2014 04:02 AM, Viresh Kumar wrote:

> For the reasons mentioned in 3/5.
> * Faster suspend/resume
> * Faster hotplug

We haven't started this thread for this. These are additional benefits :)

> * Sysfs file permissions maintained across hotplug

Already there..

> * Policy settings and governor tunables maintained across hotplug

Could have been done easily

> * Cpufreq stats would be maintained across hotplug for all CPUs and can
>   be queried even after CPU goes OFFLINE

Could have been managed otherwise as well..

The bigger purpose was to get rid of the bugs around dropping locks around
EXIT paths and simplifying over complex code..

> Also, logical hotplug happens way more often than physical hot-remove. Just
> because we need to do this during physical hot-remove doesn't mean we should
> do this all the time.
>
> Btw, v5 will have another patch that should allow a lot of code reuse that
> won't be easy with symlink manipulation.

Hmm.. Lets see how it goes..

>>> @@ -1101,9 +1106,6 @@ static int __cpufreq_add_dev(struct device *dev,
>>> struct subsys_interface *sif)
>>>          unsigned long flags;
>>>          bool recover_policy = cpufreq_suspended;
>>>
>>> -       if (cpu_is_offline(cpu))
>>> -               return 0;
>>> -
>>
>>
>> Why?
>
>
> So that when a CPU is physically hot-added again, we create the symlinks
> again.

Will that CPU be offline then at this place? Sure?

Also, I don't know why this cpu_is_offline() is present here at all.. Maybe we
can make it a WARN() for a kernel-release or two and then can remove it
completely..

>>> +               if (sif && !cpumask_test_cpu(cpu, &has_symlink)) {
>>
>>
>> Why check for sif?
>
>
> sif is only set when this is called from hot-add/hot-remove context or
> cpufreq is registered for the first time.

But isn't cpumask_test_cpu() enough alone?

>>> +                       ret = sysfs_create_link(&dev->kobj,
>>> &policy->kobj,
>>> +                                               "cpufreq");
>>> +                       if (!ret)
>>> +                               cpumask_set_cpu(cpu, &has_symlink);
>>> +               }
>>> +
>>
>>
>> Move all this to cpufreq_add_policy_cpu()..
>
>
> The code above is not for online CPUs. So, this can't be added to
> cpufreq_add_policy_cpu().

What do you mean by that? We can reach here for offline CPUs? How?

>> Don't know why we moved it here.. cpufreq_add_dev will only be called for
>> online CPUs..
>
>
> As you said, I just moved it down here. If what you say was true, we
> wouldn't have needed this in the first place.
>
> It's needed because __cpufreq_add_dev() is also called for a present, but
> offline CPU during cpufreq driver register.

I have never tested it, but may be you are right :)

>> This has_symlink thing has made it much more complicated..
>
>
> Actually, I disagree. No, convoluted deduction of what condition this is
> getting called under, etc. It's pretty simple -- if symlink is present, the
> bit is set; else, it's not set.
>
> Btw, I could have make this similar to policy->related_cpus and policy->cpus
> and it might have looked "simpler". But no point in having multiple cpumasks
> when we are just tracking the global presence of symlinks.
>
> Also, whether it's convoluted or not, it's definitely an improvement over
> removing and adding these all the time.

Hmm, I will rethink about this later ..
