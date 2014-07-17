Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaGQGYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:24:16 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:45753 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaGQGYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:24:13 -0400
MIME-Version: 1.0
In-Reply-To: <53C6DFAD.8030109@codeaurora.org>
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org>
	<1405464473-3916-2-git-send-email-skannan@codeaurora.org>
	<CAKohpok2hzwDLy77CZJ+7pHV-Nj4XTviJxVeXQYJRYtKXME00w@mail.gmail.com>
	<53C6DFAD.8030109@codeaurora.org>
Date: Thu, 17 Jul 2014 11:54:12 +0530
Message-ID: <CAKohpom5BQU+-wkohQYD4sdh4D0gZf0hmHgajPF1hDvxX4NBmw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
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

On 17 July 2014 01:55, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 07/16/2014 01:24 AM, Viresh Kumar wrote:
>> Also, its not the duty of this routine to find which one is the policy cpu
>> as
>> that is done by __cpufreq_add_dev(). And so in case we need to make
>> first cpu of a mask as policy->cpu, it should be done in
>> __cpufreq_add_dev()
>> and not here. This one should just follow the orders :)
>
>
> This is a new function. And that split up might have made sense earlier. But
> not so much anymore since I'm sharing a lot of code between
> __cpufreq_add_dev() and __cpufreq_remove_dev(). There's not reason to stick
> with the previous split of up work if it doesn't apply well anymore.
>
> Please give this a second thought. Maybe it'll make more sense after I split
> this up into smaller patches.

Don't worry I am all open to good suggestions :)

So, this is why I see your idea of first cpu in related_cpus is good:
- cpufreq_dev_symlink() is called while adding/removing links now
- And we must know which CPU owns kobj in the first place, as there
is no symlink there.
- To be guaranteed about that, first-cpu logic makes sense and I can see
why you did it this way.
- If we want to do it myway, i.e. using policy->cpu there is a problem.
policy->cpu may change and we have to keep another field like:
policy->sysfs_cpu to track sysfs master. That's bad..

This is what you wanted to hear, isn't it ? :)

But, as usual I have few concerns:
- As we talked in another thread consider this scenario:
- Dual cluster system, 4 CPUs per cluster. Cluser0: cpu0-3, Cluster1: 4-7.
- CPU 4 failed to come online on boot, but it is still the first cpu of
related_cpus. It can still come online later on if we fix things somehow.
- We CAN'T guarantee that first CPU of related_cpus will have a sysfs
directory for itself, as it may have failed to comeup in the first place..
- What can we do now? Go to next CPU? Maybe yes, but then we *have*
to track policy->sysfs_cpu. Isn't it?

If that's the case, lets track sysfs_cpu and lets make it equal to policy->cpu
instead of the first-cpu logic :)

I know you don't like me much by now :) Just kidding.

>> Keep this please, it might be useful while debugging.
>
>
> Reluctant ok. We don't add/remove these files anymore in a common scenario.
> So, it's not going to be very helpful. I'll also have to do a add ? Add :
> Remove blurb for the print.

May still be useful :). For example:
- In IKS (In kernel switcher: which you may use for you b.L implementation), we
can turn IKS on/off at runtime and the only way it works is by
unregistering/registering
cpufreq driver. And this will be useful there. Also we might want to know what
went wrong while porting a cpufreq driver for a platform initially.

>>> +       dev = get_cpu_device(cpumask_first(policy->related_cpus));
>>> +       if (!dev)
>>> +               return -EINVAL;
>>
>>
>> Again, deciding which cpu is policy->cpu here is wrong. Just follow
>> orders of __cpufreq_add_dev().
>
> But that's not what I'm doing here?

Yeah, I misread that earlier. So take my comment for sysfs-cpu here :)

>> Also pcpu can't be < nr_cpu_ids, right?
>
> This is for the case when all CPUs in a cluster have been taken down. We
> don't want to send the notifier at that point. When the mask is empty, the
> function returns a value >= nr_cpu_ids to indicate an error.

I see, probably you can use cpumask_weight() earlier in the code and
reuse it here instead of checking for cpumask_first() to find if we need to do
something. Confusing ? Look at this routine again in your code and you will
come to know what I refer to. :)

>>> @@ -1053,10 +1057,8 @@ static void cpufreq_policy_put_kobj(struct
>>> cpufreq_policy *policy)
>>>          blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>>>                          CPUFREQ_REMOVE_POLICY, policy);
>>>
>>> -       down_read(&policy->rwsem);
>>>          kobj = &policy->kobj;
>>>          cmp = &policy->kobj_unregister;
>>> -       up_read(&policy->rwsem);
>>
>>
>> Why? And also, these are unrelated changes and must be added as separate
>> commits.
>
>
> This is because we call this with policy rwsem read lock held and lockdep
> throws a warning. So, it's related to this patch.

I fail to see that in the final code, Can you please enlighten me with line
numbers please?

>>> @@ -1110,9 +1092,10 @@ static int __cpufreq_add_dev(struct device *dev,
>>> +       if (policy) {
>>> +               cpufreq_change_policy_cpus(policy, cpu, true);
>>
>>
>> This is just a waste of time at boot as ... (see below)
>
> Why? Please explain.

As I said, see below :)

>>>          /* related cpus should atleast have policy->cpus */
>>>          cpumask_or(policy->related_cpus, policy->related_cpus,
>>> policy->cpus);
>>
>>
>> policy->cpus is already updated here.

--------------- HERE -------------------------

>>> -       if (!recover_policy) {
>>> -               policy->user_policy.min = policy->min;
>>> -               policy->user_policy.max = policy->max;
>>> -       }
>>
>> Where did these go? There weren't there for fun.
>
> We are keeping the policy intact. So, why would this be needed anymore?

This code would execute on !recover_policy, i.e. when we aren't recovering
policy. Also at boot.. I forgot exact details, please try 'git blame' ..

> Will do. With Srivatsa point about just making sure every patch compiles, it
> should be easy to break it up. But to answer your original question, it's
> again not needed to save/restore since we don't destroy it.

Again, check why it was required with git bisect.



Okay, another thing which I just figured out. You changed something really
really important.

We don't call ->init()/exit() anymore on suspend/resume or when we move
all CPUs out. I am quite sure this will break platforms, and actually those
which Rafael care about most :)

Again. I still feel this patch was a lot over-engineered. I agree that there
are things which we want to solve, but the first thing to solve is not moving
sysfs nodes. Which can be solved with very basic changes.

Get that right first and send patches for that. Nothing else.

You can send out improvements later once we have your really really
important fix in.

Otherwise, you will just make it tougher for this patchset to get merged.

Look at this (I don't have a link yet, but you are cc'd):
[PATCH V1 Resend 0/4] CPUFreq: Bug fixes & cleanups

A perfect example of how to get the fix in first and then improvements.

Everybody have to follow these, even Maintainers.
