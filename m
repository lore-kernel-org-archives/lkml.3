Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaGPT4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:56:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34049 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaGPT4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:56:30 -0400
Message-ID: <53C6D8EC.1030609@codeaurora.org>
Date: Wed, 16 Jul 2014 12:56:28 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa@MIT.EDU>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 1/2] cpufreq: Don't destroy/realloc policy/sysfs on
 hotplug/suspend
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org>	<1405464473-3916-2-git-send-email-skannan@codeaurora.org> <CAKohpok2hzwDLy77CZJ+7pHV-Nj4XTviJxVeXQYJRYtKXME00w@mail.gmail.com> <53C65F03.1050609@mit.edu>
In-Reply-To: <53C65F03.1050609@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 04:16 AM, Srivatsa S. Bhat wrote:
> On 07/16/2014 01:54 PM, Viresh Kumar wrote:
>> On 16 July 2014 04:17, Saravana Kannan <skannan@codeaurora.org> wrote:
>>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>>

<SNIP>

>>> -static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
>>> -                                 unsigned int cpu, struct device *dev)
>>> +static int cpufreq_change_policy_cpus(struct cpufreq_policy *policy,
>>> +                                 unsigned int cpu, bool add)
>
> [...]
>
>>> -
>>> -       if (!cpufreq_driver->setpolicy)
>>> -               strncpy(per_cpu(cpufreq_cpu_governor, cpu),
>>> -                       policy->governor->name, CPUFREQ_NAME_LEN);
>>
>> Where is this gone? There are several instances of code just being
>> removed, this is the third one. Its really really tough to catch these
>> in this big of a patch. Believe me.
>>
>> You have to break this patch into multiple ones, see this on how to
>> break even simplest of the changes into multiple patches:
>> https://lkml.org/lkml/2013/9/6/400
>>
>> Its just impossible to catch bugs that you might have introduced here due
>> to the size of this patch. And its taking a LOT of time for me to review this.
>> As I have to keep diff in one tab, new cpufreq.c in one and the old cpufreq.c
>> in one and then compare..
>>
>
> True, this is still a pretty huge chunk. Saravana, at this stage, don't worry
> about making cpufreq work properly in each and every patch. Just ensure that
> every patch builds fine; that should be good enough. I hope this will help you
> in splitting up the patches further.

Thanks Srivatsa. This will definitely help split them up into smaller 
chunks.

> One other thing: your changelog contains what we usually write in a cover-
> letter - *very* high-level goals of the patch. Ideally, you should explain
> the subtle details and the non-obvious decisions or trade-offs that you have
> made at various places in the code. Otherwise it becomes very hard to follow
> your thought-flow just by looking at the patch. So please split up the patch
> further and also make the changelogs useful to review the patch :-)

Thanks. Will do.

> The link that Viresh gave above also did a lot of code reorganization in
> cpufreq, so it should give you a good example of how to proceed.
>
> [...]
>
>>>                          __cpufreq_add_dev(dev, NULL);
>>>                          break;
>>>
>>>                  case CPU_DOWN_PREPARE:
>>> -                       __cpufreq_remove_dev_prepare(dev, NULL);
>>> -                       break;
>>> -
>>> -               case CPU_POST_DEAD:
>>> -                       __cpufreq_remove_dev_finish(dev, NULL);
>>> -                       break;
>>> -
>>> -               case CPU_DOWN_FAILED:
>>> -                       __cpufreq_add_dev(dev, NULL);
>>> +                       __cpufreq_remove_dev(dev, NULL);
>>
>> @Srivatsa: You might want to have a look at this, remove sequence was
>> separated for some purpose and I am just not able to concentrate enough
>> to think of that, just too many cases running in my mind :)
>>
>
> Yeah, we had split it into _remove_dev_prepare() and _remove_dev_finish()
> to avoid a few potential deadlocks. We wanted to call _remove_dev_prepare()
> in the DOWN_PREPARE stage and then call _remove_dev_finish() (which waits
> for the kobject refcount to drop) in the POST_DEAD stage. That is, we wanted
> to do the kobject cleanup after releasing the hotplug lock, and POST_DEAD stage
> was well-suited for that.
>
> Commit 1aee40ac9c8 (cpufreq: Invoke __cpufreq_remove_dev_finish() after
> releasing cpu_hotplug.lock) explains this in detail. Saravana, please take a
> look at that reasoning and ensure that your patch doesn't re-introduce those
> deadlock possibilities!

But all of that was needed _because_ we were creating and destroying 
policies and kobjs all the time. We don't do that anymore. So, I don't 
think any of that applies. We only destroy when the cpufreq driver is 
unregistered. That's kinda of the point of this patchset.

Thoughts?

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
