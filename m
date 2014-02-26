Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaBZUEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:04:49 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60882 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaBZUEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:04:47 -0500
Message-ID: <530E48DD.5090108@codeaurora.org>
Date: Wed, 26 Feb 2014 12:04:45 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] cpufreq: stats: Remove redundant cpufreq_cpu_get()
 call
References: <1789244.B5CzWbcp6h@vostro.rjw.lan> <1393385915-19138-1-git-send-email-skannan@codeaurora.org> <CAKohponAnGn-C7-3T6JWZBb0PxtY1pE+o9SAKP-xC6GOrVE02Q@mail.gmail.com>
In-Reply-To: <CAKohponAnGn-C7-3T6JWZBb0PxtY1pE+o9SAKP-xC6GOrVE02Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 09:06 PM, Viresh Kumar wrote:
> On 26 February 2014 09:08, Saravana Kannan <skannan@codeaurora.org> wrote:
>> __cpufreq_stats_create_table always gets pass the valid and real policy
>> struct. So, there's no need to call cpufreq_cpu_get() to get the policy
>> again.
>>
>> Change-Id: I0136b3e67018ee3af2335906407f55d8c6219f71
>
> ??
>
>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>> ---
>>
>> Viresh/Rafael,
>>
>> These 3 patches is the approximate code I have in mind.
>>
>> Approximate because:
>> * I inserted one question as a comment into the code.
>> * If the patch doesn't have any bugs, the plan is to remove
>>    cpufreq_generic_get() and references to it.
>>
>> This takes care of the "don't advertise before it's ready for use" rule.
>>
>> Viresh,
>>
>> I think the locking updates needs to be done in addition to this.
>>
>> Regards,
>> Saravana
>>
>>   drivers/cpufreq/cpufreq_stats.c | 12 +-----------
>>   1 file changed, 1 insertion(+), 11 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
>> index 5793e14..e4bd27f 100644
>> --- a/drivers/cpufreq/cpufreq_stats.c
>> +++ b/drivers/cpufreq/cpufreq_stats.c
>> @@ -185,7 +185,6 @@ static int __cpufreq_stats_create_table(struct cpufreq_policy *policy,
>>   {
>>          unsigned int i, j, count = 0, ret = 0;
>>          struct cpufreq_stats *stat;
>> -       struct cpufreq_policy *current_policy;
>>          unsigned int alloc_size;
>>          unsigned int cpu = policy->cpu;
>>          if (per_cpu(cpufreq_stats_table, cpu))
>> @@ -194,13 +193,7 @@ static int __cpufreq_stats_create_table(struct cpufreq_policy *policy,
>>          if ((stat) == NULL)
>>                  return -ENOMEM;
>>
>> -       current_policy = cpufreq_cpu_get(cpu);
>> -       if (current_policy == NULL) {
>> -               ret = -EINVAL;
>> -               goto error_get_fail;
>> -       }
>> -
>> -       ret = sysfs_create_group(&current_policy->kobj, &stats_attr_group);
>> +       ret = sysfs_create_group(&policy->kobj, &stats_attr_group);
>>          if (ret)
>>                  goto error_out;
>>
>> @@ -243,11 +236,8 @@ static int __cpufreq_stats_create_table(struct cpufreq_policy *policy,
>>          stat->last_time = get_jiffies_64();
>>          stat->last_index = freq_table_get_index(stat, policy->cur);
>>          spin_unlock(&cpufreq_stats_lock);
>> -       cpufreq_cpu_put(current_policy);
>>          return 0;
>>   error_out:
>> -       cpufreq_cpu_put(current_policy);
>> -error_get_fail:
>>          kfree(stat);
>>          per_cpu(cpufreq_stats_table, cpu) = NULL;
>>          return ret;
>
> I was damn sure that this wasn't a waste of time. This was some meaningful
> code when I visited it earlier. And we absolutely required a new
> cpufreq_cpu_get()..
>
> Reason: Earlier tables were created for this notifier: CPUFREQ_NOTIFY and
> it used to come with another changed copy of 'policy' and so we were required
> to get the real copy of policy to get to the right kobj.
>
> But recently I have simplified stuff there and these tables are now added with
> CPUFREQ_CREATE_POLICY and so this replication isn't required anymore.

Agreed. I already knew it had a good reason. :) Just that it's not 
needed anymore.

> So, Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks.

>
> While you are at it please get this part into __cpufreq_stats_create_table()
> routine:
>
> table = cpufreq_frequency_get_table(cpu);
> if (!table)
>      return 0;
>
> As it is replicated at two places currently.
>

Doing it as a separate patch since it's technically unrelated to these 
changes.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
