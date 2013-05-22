Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab3EVIqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:46:36 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:60755 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3EVIqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:46:25 -0400
MIME-Version: 1.0
In-Reply-To: <51947935.50607@marvell.com>
References: <1368442050-16548-1-git-send-email-chenxg@marvell.com>
	<51947935.50607@marvell.com>
Date: Wed, 22 May 2013 14:16:24 +0530
Message-ID: <CAKohpokR0igX3Z4P9eyoJikmBwnG90eN003wAaJW-Ynu7zU7Aw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: fix governor start/stop race condition
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg@marvell.com>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ning Jiang <njiang1@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Zhoujie Wu <zjwu@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for being late buddy..

On 16 May 2013 11:44, Xiaoguang Chen <chenxg@marvell.com> wrote:
> On 05/13/2013 06:47 PM, Xiaoguang Chen wrote:
>>

Why is the mail came this way.. You forwarded it?

>> cpufreq governor stop and start should be kept in sequence.
>> If not, there will be unexpected behavior, for example:
>>
>> we have 4 cpus and policy->cpu=cpu0, cpu1/2/3 are linked to cpu0.
>> the normal sequence is as below:
>>
>> 1) Current governor is userspace, one application tries to set
>> governor to ondemand. it will call __cpufreq_set_policy in which it
>> will stop userspace governor and then start ondemand governor.
>>
>> 2) Current governor is userspace, now cpu0 hotplugs in cpu3, it will
>> call cpufreq_add_policy_cpu. on which it first stops userspace
>> governor, and then starts userspace governor.
>>
>> Now if the sequence of above two cases interleaves, it becames
>> below sequence:
>>
>> 1) application stops userspace governor
>> 2)                                      hotplug stops userspace governor
>> 3) application starts ondemand governor
>> 4)                                      hotplug starts a governor
>>
>> in step 4, hotplug is supposed to start userspace governor, but now
>> the governor has been changed by application to ondemand, so hotplug
>> starts ondemand governor again !!!!
>>
>> The solution is as below:
>> cpufreq policy has a rwsem to protect the read and write of policy.
>> make the scope of the rwsem to contain cpufreq governor stop/start
>> sequence, so that after the stop governor has started, other threads
>> will not stop governor, they have to wait the current thread starts
>> the governor and then do their job.
>>
>> Change-Id: I054bb52789fc8abdcf80bdcc1caebd429c182bb0
>> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
>> ---
>>   drivers/cpufreq/cpufreq.c | 19 ++++++++-----------
>>   1 file changed, 8 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 1b8a48e..935f750 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -811,14 +811,14 @@ static int cpufreq_add_policy_cpu(unsigned int cpu,
>> unsigned int sibling,
>>         int ret = 0, has_target = !!cpufreq_driver->target;
>>         unsigned long flags;
>>   +     lock_policy_rwsem_write(sibling);
>> +
>>         policy = cpufreq_cpu_get(sibling);
>>         WARN_ON(!policy);
>>         if (has_target)
>>                 __cpufreq_governor(policy, CPUFREQ_GOV_STOP);

We can't have locks are GOV_STOP earlier.. And now we can't have it
across *_EXIT.. Check latest code... As this gives some circular dependency
to locking and it fails.
