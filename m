Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbaFROjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:39:40 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1451 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaFROji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:39:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Jun 2014 07:33:57 -0700
Message-ID: <53A1A4A9.4060301@nvidia.com>
Date: Wed, 18 Jun 2014 07:39:37 -0700
From: Aaron Plattner <aplattner@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] cpufreq: unlock when failing cpufreq_update_policy()
References: <1403050362-20809-1-git-send-email-aplattner@nvidia.com> <CAKohpo=2fpi7GivgNGE+DgD3xPdku3WzKKD8+Ziz4gQ4P6pMxQ@mail.gmail.com>
In-Reply-To: <CAKohpo=2fpi7GivgNGE+DgD3xPdku3WzKKD8+Ziz4gQ4P6pMxQ@mail.gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 12:40 AM, Viresh Kumar wrote:
> On 18 June 2014 05:42, Aaron Plattner <aplattner@nvidia.com> wrote:
>> Commit bd0fa9bb455d introduced a failure path to cpufreq_update_policy() if
>> cpufreq_driver->get(cpu) returns NULL.  However, it jumps to the 'no_policy'
>> label, which exits without unlocking any of the locks the function acquired
>> earlier.  This causes later calls into cpufreq to hang.
>>
>> Fix this by creating a new 'unlock' label and jumping to that instead.
>>
>> Fixes: bd0fa9bb455d ("cpufreq: Return error if ->get() failed in cpufreq_update_policy()")
>> Link: https://devtalk.nvidia.com/default/topic/751903/kernel-3-15-and-nv-drivers-337-340-failed-to-initialize-the-nvidia-kernel-module-gtx-550-ti-/
>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
>> ---
>> I haven't reproduced this problem so I couldn't test it, but the bug and its
>> solution seem obvious enough.
>>
>>   drivers/cpufreq/cpufreq.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index aed2b0cb83dc..5b6d04f3b9ea 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -2264,7 +2264,7 @@ int cpufreq_update_policy(unsigned int cpu)
>>                  new_policy.cur = cpufreq_driver->get(cpu);
>>                  if (WARN_ON(!new_policy.cur)) {
>>                          ret = -EIO;
>> -                       goto no_policy;
>> +                       goto unlock;
>>                  }
>>
>>                  if (!policy->cur) {
>> @@ -2279,6 +2279,7 @@ int cpufreq_update_policy(unsigned int cpu)
>>
>>          ret = cpufreq_set_policy(policy, &new_policy);
>>
>> +unlock:
>>          up_write(&policy->rwsem);
>>
>>          cpufreq_cpu_put(policy);
>
> Hmm, yes we do have a problem here but the code became a bit ugly
> now.. Can you please consider this diff instead?
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index aed2b0c..6caced5 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -2242,10 +2242,8 @@ int cpufreq_update_policy(unsigned int cpu)
>          struct cpufreq_policy new_policy;
>          int ret;
>
> -       if (!policy) {
> -               ret = -ENODEV;
> -               goto no_policy;
> -       }
> +       if (!policy)
> +               return = -ENODEV;

I assume you meant "return -ENODEV"?

>          down_write(&policy->rwsem);
>
> @@ -2279,10 +2277,10 @@ int cpufreq_update_policy(unsigned int cpu)
>
>          ret = cpufreq_set_policy(policy, &new_policy);
>
> +no_policy:

'no_policy' implied to me that policy was NULL, so this label should 
still be renamed to 'unlock'.  I'll send out a v2 that does this.

>          up_write(&policy->rwsem);
>
>          cpufreq_cpu_put(policy);
> -no_policy:
>          return ret;
>   }
>   EXPORT_SYMBOL(cpufreq_update_policy);
>

-- 
Aaron
