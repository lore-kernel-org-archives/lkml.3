Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3FLInN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:43:13 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:64172 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3FLInI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:43:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpok2AEe3bL=mPAoxbenEBaWU=WjkRckbvcnzjnUwFZgnuA@mail.gmail.com>
References: <1371021986-20985-1-git-send-email-chenxg@marvell.com>
	<CAKohpok2AEe3bL=mPAoxbenEBaWU=WjkRckbvcnzjnUwFZgnuA@mail.gmail.com>
Date: Wed, 12 Jun 2013 16:43:05 +0800
Message-ID: <CAFgnuDcs7AC7ZmF0xjCYsfj8R_X_cvhNR4V+bduPNhjHR3KQpQ@mail.gmail.com>
Subject: Re: [PATCH v3] cpufreq: fix governor start/stop race condition
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

2013/6/12 Viresh Kumar <viresh.kumar@linaro.org>:
> On 12 June 2013 12:56, Xiaoguang Chen <chenxg@marvell.com> wrote:
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
>> The solution is: do not allow stop one policy's governor multi-times
>> Governor stop should only do once for one policy, after it is stopped,
>> no other governor stop should be executed.
>>
>> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
>> ---
>>  drivers/cpufreq/cpufreq.c | 9 +++++++++
>>  include/linux/cpufreq.h   | 1 +
>>  2 files changed, 10 insertions(+)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 2d53f47..b4a2c94 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1562,6 +1562,11 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>>
>>         pr_debug("__cpufreq_governor for CPU %u, event %u\n",
>>                                                 policy->cpu, event);
>> +
>> +       if ((!policy->governor_enabled && (event == CPUFREQ_GOV_STOP)) ||
>> +           (policy->governor_enabled && (event == CPUFREQ_GOV_START)))
>> +               return 0;
>
> Few things:
> - because __cpufreq_governor() isn't protected by locks, both calls for
> stopping governor can reach to this point and race can still happen. So,
> both may stop governor.

Ok, I'll think about how to protect this.

> - Returning zero doesn't seems to be the right thing, as this may cause
> STOP called by one user and START called by another. For example,
> STOP happened due to governor change. STOP called for hotplug and
> 0 is returned. START called by hotplug as STOP was successful. :)
>
> Maybe -EBUSY would make more sense here.

I thought about return one error code before. but I checked the code
and found that
most of the governor stop/start operations don't check the return
value. I can add error code
here, I think the checking of return value is also needed. May be
another patch can do this.

Thanks
Xiaoguang
