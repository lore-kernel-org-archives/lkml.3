Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab3EWCos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 22:44:48 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:53247 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757378Ab3EWCom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 22:44:42 -0400
Message-ID: <519D8287.5020004@marvell.com>
Date: Thu, 23 May 2013 10:44:23 +0800
From: Xiaoguang Chen <chenxg@marvell.com>
Organization: Marvell
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ning Jiang <njiang1@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Zhoujie Wu <zjwu@marvell.com>
Subject: Re: [PATCH] cpufreq: fix governor start/stop race condition
References: <1368442050-16548-1-git-send-email-chenxg@marvell.com> <51947935.50607@marvell.com> <CAKohpokR0igX3Z4P9eyoJikmBwnG90eN003wAaJW-Ynu7zU7Aw@mail.gmail.com>
In-Reply-To: <CAKohpokR0igX3Z4P9eyoJikmBwnG90eN003wAaJW-Ynu7zU7Aw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 04:46 PM, Viresh Kumar wrote:
> Sorry for being late buddy..
>
> On 16 May 2013 11:44, Xiaoguang Chen <chenxg@marvell.com> wrote:
>> On 05/13/2013 06:47 PM, Xiaoguang Chen wrote:
> Why is the mail came this way.. You forwarded it?
I didn't see your reponse, So I once replied this mail once.:)
>
>>> cpufreq governor stop and start should be kept in sequence.
>>> If not, there will be unexpected behavior, for example:
>>>
>>> we have 4 cpus and policy->cpu=cpu0, cpu1/2/3 are linked to cpu0.
>>> the normal sequence is as below:
>>>
>>> 1) Current governor is userspace, one application tries to set
>>> governor to ondemand. it will call __cpufreq_set_policy in which it
>>> will stop userspace governor and then start ondemand governor.
>>>
>>> 2) Current governor is userspace, now cpu0 hotplugs in cpu3, it will
>>> call cpufreq_add_policy_cpu. on which it first stops userspace
>>> governor, and then starts userspace governor.
>>>
>>> Now if the sequence of above two cases interleaves, it becames
>>> below sequence:
>>>
>>> 1) application stops userspace governor
>>> 2)                                      hotplug stops userspace governor
>>> 3) application starts ondemand governor
>>> 4)                                      hotplug starts a governor
>>>
>>> in step 4, hotplug is supposed to start userspace governor, but now
>>> the governor has been changed by application to ondemand, so hotplug
>>> starts ondemand governor again !!!!
>>>
>>> The solution is as below:
>>> cpufreq policy has a rwsem to protect the read and write of policy.
>>> make the scope of the rwsem to contain cpufreq governor stop/start
>>> sequence, so that after the stop governor has started, other threads
>>> will not stop governor, they have to wait the current thread starts
>>> the governor and then do their job.
>>>
>>> Change-Id: I054bb52789fc8abdcf80bdcc1caebd429c182bb0
>>> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
>>> ---
>>>    drivers/cpufreq/cpufreq.c | 19 ++++++++-----------
>>>    1 file changed, 8 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>>> index 1b8a48e..935f750 100644
>>> --- a/drivers/cpufreq/cpufreq.c
>>> +++ b/drivers/cpufreq/cpufreq.c
>>> @@ -811,14 +811,14 @@ static int cpufreq_add_policy_cpu(unsigned int cpu,
>>> unsigned int sibling,
>>>          int ret = 0, has_target = !!cpufreq_driver->target;
>>>          unsigned long flags;
>>>    +     lock_policy_rwsem_write(sibling);
>>> +
>>>          policy = cpufreq_cpu_get(sibling);
>>>          WARN_ON(!policy);
>>>          if (has_target)
>>>                  __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> We can't have locks are GOV_STOP earlier.. And now we can't have it
> across *_EXIT.. Check latest code... As this gives some circular dependency
> to locking and it fails.
Do you mean my patch will cause deadlock? I once tried to add another lock
to protect the GOV_STOP/START sequence instead of using the rwsem in 
this patch.
But I saw deadlock indeed.
In cpufreq_add_policy_cpu, the lock has to be added before the rwsem 
since GOV_STOP is
before lock_policy_rwsem_write, but in cpufreq_update_policy, it will 
first get the rwsem, and then
call __cpufreq_set_policy which will contain GOV_STOP again, if we add 
the new lock before this GOV_STOP,
then we may get deadlock in below sequence:
1) hotplug in one cpu by calling cpufreq_add_policy_cpu in which new 
lock is locked first then rwsem is locked.
2) governor change in cpufreq_update_policy in which rwsem is locked 
first then new lock is locked.
this is a deadlock issue if above two steps interleaves



-- 
Thanks
Xiaoguang

