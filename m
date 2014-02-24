Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaBXIlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:41:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:34896 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaBXIlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:41:44 -0500
Message-ID: <a7536f7b5a03fe287aaf1974db74ba64.squirrel@www.codeaurora.org>
In-Reply-To: <CAKohpok-8_JV8hRDiWnRLYqEqyvD60cyn5Hs1HcZTSEPZjLvOQ@mail.gmail.com>
References: <1393225072-3997-1-git-send-email-skannan@codeaurora.org>
    <530AF7E4.5080806@linux.vnet.ibm.com>
    <CAKohpok-8_JV8hRDiWnRLYqEqyvD60cyn5Hs1HcZTSEPZjLvOQ@mail.gmail.com>
Date: Mon, 24 Feb 2014 08:41:43 -0000
Subject: Re: [PATCH] cpufreq: Set policy to non-NULL only after all hotplug
 online work is done
From: skannan@codeaurora.org
To: "Viresh Kumar" <viresh.kumar@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Saravana Kannan" <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
User-Agent: SquirrelMail/1.4.22-3.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Viresh Kumar wrote:
> On 24 February 2014 13:12, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> On 02/24/2014 12:27 PM, Saravana Kannan wrote:
>>> The existing code sets the per CPU policy to a non-NULL value before
>>> all
>>> the steps performed during the hotplug online path is done.
>>> Specifically,
>>> this is done before the policy min/max, governors, etc are initialized
>>> for
>>> the policy.  This in turn means that calls to cpufreq_cpu_get() return
>>> a
>>> non-NULL policy before the policy/CPU is ready to be used.
>>>
>>> To fix this, move the update of per CPU policy to a valid value after
>>> all
>>> the initialization steps for the policy are completed.
>>>
>>> Example kernel panic without this fix:
>>> [  512.146185] Unable to handle kernel NULL pointer dereference at
>>> virtual address 00000020
>>> [  512.146195] pgd = c0003000
>>> [  512.146213] [00000020] *pgd=80000000004003, *pmd=00000000
>>> [  512.146228] Internal error: Oops: 206 [#1] PREEMPT SMP ARM
>>> <snip>
>>> [  512.146297] PC is at __cpufreq_governor+0x10/0x1ac
>>> [  512.146312] LR is at cpufreq_update_policy+0x114/0x150
>>> <snip>
>>> [  512.149740] ---[ end trace f23a8defea6cd706 ]---
>>> [  512.149761] Kernel panic - not syncing: Fatal exception
>>> [  513.152016] CPU0: stopping
>>> [  513.154710] CPU: 0 PID: 7136 Comm: mpdecision Tainted: G      D W
>>> 3.10.0-gd727407-00074-g979ede8 #396
>>> <snip>
>>> [  513.317224] [<c0afe180>] (notifier_call_chain+0x40/0x68) from
>>> [<c02a23ac>] (__blocking_notifier_call_chain+0x40/0x58)
>>> [  513.327809] [<c02a23ac>] (__blocking_notifier_call_chain+0x40/0x58)
>>> from [<c02a23d8>] (blocking_notifier_call_chain+0x14/0x1c)
>>> [  513.339182] [<c02a23d8>] (blocking_notifier_call_chain+0x14/0x1c)
>>> from [<c0803c68>] (cpufreq_set_policy+0xd4/0x2b8)
>>> [  513.349594] [<c0803c68>] (cpufreq_set_policy+0xd4/0x2b8) from
>>> [<c0803e7c>] (cpufreq_init_policy+0x30/0x98)
>>> [  513.359231] [<c0803e7c>] (cpufreq_init_policy+0x30/0x98) from
>>> [<c0805a18>] (__cpufreq_add_dev.isra.17+0x4dc/0x7a4)
>>> [  513.369560] [<c0805a18>] (__cpufreq_add_dev.isra.17+0x4dc/0x7a4)
>>> from [<c0805d38>] (cpufreq_cpu_callback+0x58/0x84)
>>> [  513.379978] [<c0805d38>] (cpufreq_cpu_callback+0x58/0x84) from
>>> [<c0afe180>] (notifier_call_chain+0x40/0x68)
>>> [  513.389704] [<c0afe180>] (notifier_call_chain+0x40/0x68) from
>>> [<c02812dc>] (__cpu_notify+0x28/0x44)
>>> [  513.398728] [<c02812dc>] (__cpu_notify+0x28/0x44) from [<c0aeed90>]
>>> (_cpu_up+0xf4/0x1dc)
>>> [  513.406797] [<c0aeed90>] (_cpu_up+0xf4/0x1dc) from [<c0aeeed4>]
>>> (cpu_up+0x5c/0x78)
>>> [  513.414357] [<c0aeeed4>] (cpu_up+0x5c/0x78) from [<c0aec808>]
>>> (store_online+0x44/0x74)
>>> [  513.422253] [<c0aec808>] (store_online+0x44/0x74) from [<c03a40f4>]
>>> (sysfs_write_file+0x108/0x14c)
>>> [  513.431195] [<c03a40f4>] (sysfs_write_file+0x108/0x14c) from
>>> [<c03517d4>] (vfs_write+0xd0/0x180)
>>> [  513.439958] [<c03517d4>] (vfs_write+0xd0/0x180) from [<c0351ca8>]
>>> (SyS_write+0x38/0x68)
>>> [  513.447947] [<c0351ca8>] (SyS_write+0x38/0x68) from [<c0205de0>]
>>> (ret_fast_syscall+0x0/0x30)
>>>
>>> In this specific case, CPU0 set's CPU1's policy->governor in
>>> cpufreq_init_policy() to NULL while CPU1 is using the policy->governor
>>> in
>>> __cpufreq_governor().
>>>
>>
>> Whoa! That's horrible! Can you please explain how exactly you
>> triggered this? I'm curious...
>
> :)
>
> Actually I didn't understood his problem very well until now. I couldn't
> get from his trace that which pointer was actually set to NULL here?
> And hence what caused this crash?
>
> Also, what Saravana just wrote here didn't looked like relevant at all.
> i.e.:  policy->governor being set to NULL.
>
> So what? It was set to NULL with a reason and it shouldn't cause
> any crashes I hope. And also its sort of wrong to say that CPU0
> has set governor for CPU1, as governor was set for a policy and
> both CPUs were part of the same policy.
>
>>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>>> ---
>>>  drivers/cpufreq/cpufreq.c | 10 +++++-----
>>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>>> index cb003a6..d5ceb43 100644
>>> --- a/drivers/cpufreq/cpufreq.c
>>> +++ b/drivers/cpufreq/cpufreq.c
>>> @@ -1109,11 +1109,6 @@ static int __cpufreq_add_dev(struct device *dev,
>>> struct subsys_interface *sif,
>>>               goto err_set_policy_cpu;
>>>       }
>>>
>>> -     write_lock_irqsave(&cpufreq_driver_lock, flags);
>>> -     for_each_cpu(j, policy->cpus)
>>> -             per_cpu(cpufreq_cpu_data, j) = policy;
>>> -     write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>>> -
>>>       if (cpufreq_driver->get) {
>>>               policy->cur = cpufreq_driver->get(policy->cpu);
>>
>> If you move the per-cpu init further down, then what happens to the
>> cpufreq_generic_get() that gets invoked here by some of the drivers?
>> It will almost always fail (because policy will be NULL) and hence
>> CPU online will be unsuccessful
>
> Thanks, I was about to point that as well.
>
>> (though you wont observe it because
>> the error code is not bubbled up to the CPU hotplug core; perhaps we
>> should).
>
> Don't know :)
>
>> IMHO, we should fix the synchronization in cpufreq_init_policy().
>> I notice cpufreq_update_policy() as well as __cpufreq_governor() in
>> your stack trace, which means cpufreq_set_policy() was involved.
>> cpufreq_update_policy() takes the policy->rwsem for write, whereas
>> cpufreq_init_policy() doesn't take that lock at all, which is clearly
>> wrong.
>>
>> My guess is that, if we fix that locking, everything will be fine and
>> you won't hit the bug. Would you like to give that a shot?
>
> I am not sure about that guess as well. I first want to know what
> went bad exactly..
>

I just replied to the other email. I think I answered both your questions
there. Sorry about mixing up CPU and policy. In my case, each CPU is
independently scalable -- so for now take CPU == policy. I'll fix it up
once we agree on the fix.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

