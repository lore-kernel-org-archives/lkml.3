Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaHAK1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:27:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbaHAK1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:27:19 -0400
Message-ID: <53DB6B81.6050400@redhat.com>
Date: Fri, 01 Aug 2014 06:27:13 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lenny Szubowicz <lszubowi@redhat.com>, linux-pm@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
References: <1406634362-811-1-git-send-email-prarit@redhat.com> <2066166.pXm4lKLOID@vostro.rjw.lan> <53DA8389.80804@redhat.com> <1917362.abr2Y4p7vh@vostro.rjw.lan> <53DA8A41.2030601@redhat.com> <53DAA60B.6040802@codeaurora.org> <53DAA749.5080506@redhat.com> <53DAA95B.2040505@codeaurora.org> <53DAB038.3050007@redhat.com> <53DABFA6.6090503@codeaurora.org> <53DACA26.1000908@redhat.com> <53DAE592.2030909@codeaurora.org>
In-Reply-To: <53DAE592.2030909@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/31/2014 08:55 PM, Saravana Kannan wrote:
> On 07/31/2014 03:58 PM, Prarit Bhargava wrote:
>>
>>
>> On 07/31/2014 06:13 PM, Saravana Kannan wrote:
>>> On 07/31/2014 02:08 PM, Prarit Bhargava wrote:
>>>>
>>>>
>>>> On 07/31/2014 04:38 PM, Saravana Kannan wrote:
>>>>> On 07/31/2014 01:30 PM, Prarit Bhargava wrote:
>>>>>>
>>>>>>
>>>>>> On 07/31/2014 04:24 PM, Saravana Kannan wrote:
>>>>>>>
>>>>>>> Prarit,
>>>>>>>
>>>>>>> I'm not an expert on sysfs locking, but I would think the specific sysfs
>>>>>>> lock
>>>>>>> would depend on the file/attribute group. So, can you please try to
>>>>>>> hotplug a
>>>>>>> core in/out (to trigger the POLICY_EXIT) and then read a sysfs file
>>>>>>> exported by
>>>>>>> the governor? scaling_governor doesn't cut it since that file is not
>>>>>>> removed on
>>>>>>> policy exit event to governor. If it's ondemand, try reading/write it's
>>>>>>> sampling
>>>>>>> rate file.
>>>>>>
>>>>>> Thanks Saravana -- will do.  I will get back to you shortly on this.
>>>>>>
>>>>>
>>>>> Thanks. Btw, in case you weren't already aware of it. You'll have to hoplug
>>>>> out
>>>>> all the CPUs in a cluster to trigger a POLICY_EXIT for that cluster/policy.
>>>>
>>>> Yep -- the affected_cpus file should show all the cpus in the policy IIRC.  One
>>>> of the systems I have has 1 cpu/policy and has 48 threads so the POLICY_EXIT is
>>>> called.
>>>>
>>>> I'll put something like
>>>>
>>>> while [1];
>>>> do
>>>> echo ondemand > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
>>>> cat /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
>>>> echo 20000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
>>>> cat /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
>>>> echo 0 > /sys/devices/system/cpu/cpu1/online
>>>> sleep 1
>>>> echo 1 > /sys/devices/system/cpu/cpu1/online
>>>> sleep 1
>>>> done
>>>>
>>>
>>> The actual race can only happen with 2 threads. I'm just trying to trigger a
>>> lockdep warning here.
>>
>> I ran the above in two separate terminals with cpuset -c 0 and cpuset -c 1 to
>> multi-thread it all.  No deadlock or LOCKDEP trace after about 1/2 hour, so I
>> think we're in the clear on that concern.
>>
> 
> I wasn't convinced. So, I took some help from Stephen to test it.
> 
> It's been a while, so I didn't remember the original issue clearly when I gave
> you some test suggestions. Now that I looked at the code more closely, I have a
> proper way to reproduce the original issue.
> 
> Nack for this patch for 2 reasons:
> 1. You seem to have accidentally removed a GOV_STOP in your patch. We definitely
> can't do that. This broke changing governors and that's why your patch didn't
> cause any issues. Because all your governor echos were failing.
> 2. When we fixed that and actually tried a proper test (not the one I gave you),
> we reproduced the original issue.
> 
> To reproduce original issue:
> Preconditions:
> * lockdep is enabled
> * governor per policy is enabled
> 
> Steps:
> 1. Set governor to ondemand.
> 2. Cat one of the ondemand sysfs files.
> 3. Change governor to conservative.

Can you send me the test and the trace of the deadlock?  I'm not creating it with:

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6f02485..fa11a7d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2200,9 +2200,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *polic
        /* end old governor */
        if (old_gov) {
                __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
-               up_write(&policy->rwsem);
                __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
-               down_write(&policy->rwsem);
        }

        /* start new governor */
@@ -2211,9 +2209,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *polic
                if (!__cpufreq_governor(policy, CPUFREQ_GOV_START))
                        goto out;

-               up_write(&policy->rwsem);
                __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
-               down_write(&policy->rwsem);
        }

        /* new governor failed, so re-start old one */

> 
> When you do that, there's an AB, BA dead lock issue with one thread trying to
> cat a governor sysfs file and another thread trying to change governors.
> 



> -Saravana
> 
