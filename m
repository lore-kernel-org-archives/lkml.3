Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058Ab3FSBUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:20:45 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:43828 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934030Ab3FSBUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:20:42 -0400
MIME-Version: 1.0
In-Reply-To: <1912850.KuRKhn87Nf@vostro.rjw.lan>
References: <1371114118-19488-1-git-send-email-chenxg@marvell.com>
	<1912850.KuRKhn87Nf@vostro.rjw.lan>
Date: Wed, 19 Jun 2013 09:20:38 +0800
Message-ID: <CAFgnuDe1bUub92uE1H9Fc9U7AJCYL=WKdyDe2bg00yEr=kMEbQ@mail.gmail.com>
Subject: Re: [PATCH v5] cpufreq: fix governor start/stop race condition
From: Xiaoguang Chen <chenxg.marvell@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Xiaoguang Chen <chenxg@marvell.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        njiang1@marvell.com, zjwu@marvell.com, ylmao@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/19 Rafael J. Wysocki <rjw@sisk.pl>:
> On Thursday, June 13, 2013 05:01:58 PM Xiaoguang Chen wrote:
>> cpufreq governor stop and start should be kept in sequence.
>> If not, there will be unexpected behavior, for example:
>>
>> we have 4 cpus and policy->cpu=cpu0, cpu1/2/3 are linked to cpu0.
>
> Please spell cpus as "CPUs".  And please start sequences from capitals.

Ok, thanks for the remind

>
> [Yes, it *really* is a problem.]
>
>> the normal sequence is as below:
>>
>> 1) Current governor is userspace, one application tries to set
>> governor to ondemand. it will call __cpufreq_set_policy in which it
>> will stop userspace governor and then start ondemand governor.
>
> Do I think correctly that this is for all CPUs?

>From current code design, it is for all CPUs.

>
>> 2) Current governor is userspace, now cpu0 hotplugs in cpu3, it will
>
> Can you please tell me what the above is supposed to mean?  Is it supposed to
> mean "the online of cpu3 is being run on cpu0" or something different?  If
> something different, then what?
>
>> call cpufreq_add_policy_cpu. on which it first stops userspace
>> governor, and then starts userspace governor.
>>
>> Now if the sequence of above two cases interleaves, it becames
>> below sequence:
>>
>> 1) application stops userspace governor
>> 2)                                      hotplug stops userspace governor
>
> The problem is already here, right?  The governor shouldn't be stopped twice?

Yes, we should make sure governor is started before it is stopped.

>
>> 3) application starts ondemand governor
>> 4)                                      hotplug starts a governor
>>
>> in step 4, hotplug is supposed to start userspace governor, but now
>> the governor has been changed by application to ondemand, so hotplug
>> starts ondemand governor again !!!!
>>
>> The solution is: do not allow stop one policy's governor multi-times
>> Governor stop should only do once for one policy, after it is stopped,
>> no other governor stop should be executed. also add one mutext to
>> protect __cpufreq_governor so governor operation can be kept in sequence.
>
> One more request. ->
>
>> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
>> ---
>>  drivers/cpufreq/cpufreq.c | 24 ++++++++++++++++++++++++
>>  include/linux/cpufreq.h   |  1 +
>>  2 files changed, 25 insertions(+)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 2d53f47..b51473e 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -46,6 +46,7 @@ static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
>>  static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>>  #endif
>>  static DEFINE_RWLOCK(cpufreq_driver_lock);
>> +static DEFINE_MUTEX(cpufreq_governor_lock);
>>
>>  /*
>>   * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
>> @@ -1562,6 +1563,21 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>>
>>       pr_debug("__cpufreq_governor for CPU %u, event %u\n",
>>                                               policy->cpu, event);
>> +
>> +     mutex_lock(&cpufreq_governor_lock);
>> +     if ((!policy->governor_enabled && (event == CPUFREQ_GOV_STOP)) ||
>> +         (policy->governor_enabled && (event == CPUFREQ_GOV_START))) {
>> +             mutex_unlock(&cpufreq_governor_lock);
>> +             return -EBUSY;
>> +     }
>> +
>> +     if (event == CPUFREQ_GOV_STOP)
>> +             policy->governor_enabled = 0;
>> +     else if (event == CPUFREQ_GOV_START)
>> +             policy->governor_enabled = 1;
>> +
>> +     mutex_unlock(&cpufreq_governor_lock);
>> +
>>       ret = policy->governor->governor(policy, event);
>>
>>       if (!ret) {
>> @@ -1569,6 +1585,14 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>>                       policy->governor->initialized++;
>>               else if (event == CPUFREQ_GOV_POLICY_EXIT)
>>                       policy->governor->initialized--;
>> +     } else {
>> +             /* Restore original values */
>> +             mutex_lock(&cpufreq_governor_lock);
>> +             if (event == CPUFREQ_GOV_STOP)
>> +                     policy->governor_enabled = 1;
>> +             else if (event == CPUFREQ_GOV_START)
>> +                     policy->governor_enabled = 0;
>> +             mutex_unlock(&cpufreq_governor_lock);
>>       }
>>
>>       /* we keep one module reference alive for
>> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
>> index 037d36a..c12db73 100644
>> --- a/include/linux/cpufreq.h
>> +++ b/include/linux/cpufreq.h
>> @@ -107,6 +107,7 @@ struct cpufreq_policy {
>>       unsigned int            policy; /* see above */
>>       struct cpufreq_governor *governor; /* see below */
>>       void                    *governor_data;
>> +     int                     governor_enabled; /* governor start/stop flag */
>
> -> Please use bool here and true/false instead of 1/0 above.
>
Ok, I'll change it to bool.

>>
>>       struct work_struct      update; /* if update_policy() needs to be
>>                                        * called, but you're in IRQ context */
>
> Thanks,
> Rafael
>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
