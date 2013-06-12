Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab3FLHKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:10:14 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:64516 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab3FLHKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:10:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpon+-bhn1OkPF24qciQBf=jHMaXsBbF0t6veZdAWYpw0QQ@mail.gmail.com>
References: <1370764205-3933-1-git-send-email-chenxg@marvell.com>
	<CAKohpon+-bhn1OkPF24qciQBf=jHMaXsBbF0t6veZdAWYpw0QQ@mail.gmail.com>
Date: Wed, 12 Jun 2013 15:10:05 +0800
Message-ID: <CAFgnuDej5dKqvLGYjHuo5q0o-=+UkrWpTd464A_+_FmT_8+JYQ@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: fix governor start/stop race condition
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

2013/6/10 Viresh Kumar <viresh.kumar@linaro.org>:
> On 9 June 2013 13:20, Xiaoguang Chen <chenxg@marvell.com> wrote:
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
>> The solution is: do not allow stop governor multi-times
>> Governor stop should only do once, after it is stopped,
>> no other governor stop should be executed.
>>
>> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
>> ---
>>  drivers/cpufreq/cpufreq.c | 10 +++++++++-
>>  include/linux/cpufreq.h   |  1 +
>>  2 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 2d53f47..c8d7cb2 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1562,6 +1562,11 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>>
>>         pr_debug("__cpufreq_governor for CPU %u, event %u\n",
>>                                                 policy->cpu, event);
>> +
>> +       if ((!policy->governor->enabled && (event == CPUFREQ_GOV_STOP)) ||
>> +           (policy->governor->enabled && (event == CPUFREQ_GOV_START)))
>> +               return 0;
>> +
>>         ret = policy->governor->governor(policy, event);
>>
>>         if (!ret) {
>> @@ -1569,6 +1574,10 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>>                         policy->governor->initialized++;
>>                 else if (event == CPUFREQ_GOV_POLICY_EXIT)
>>                         policy->governor->initialized--;
>> +               else if (event == CPUFREQ_GOV_STOP)
>> +                       policy->governor->enabled = 0;
>> +               else if (event == CPUFREQ_GOV_START)
>> +                       policy->governor->enabled = 1;
>>         }
>>
>>         /* we keep one module reference alive for
>> @@ -1581,7 +1590,6 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>>         return ret;
>>  }
>>
>> -
>>  int cpufreq_register_governor(struct cpufreq_governor *governor)
>>  {
>>         int err;
>> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
>> index 037d36a..16c5b70 100644
>> --- a/include/linux/cpufreq.h
>> +++ b/include/linux/cpufreq.h
>> @@ -199,6 +199,7 @@ struct cpufreq_governor {
>>                         will fallback to performance governor */
>>         struct list_head        governor_list;
>>         struct module           *owner;
>> +       int enabled;
>>  };
>
> This isn't sufficient.
>
> If there are two groups of clk-sharing-cpus, i.e. if we have multiple
> policies and they are using same governor, then these functions
> gets called twice for governor x. And you will return 0 for the second
> policy.

So this enable flag should be per policy, right?
I'll modify this patch

Thanks
Xiaoguang
