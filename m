Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaAON2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:28:10 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:49589 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaAON2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:28:06 -0500
Message-ID: <52D68CE2.3030009@linaro.org>
Date: Wed, 15 Jan 2014 14:28:02 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Michael wang <wangyun@linux.vnet.ibm.com>
CC: raistlin@linux.it, juri.lelli@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
References: <52D64676.4040000@linaro.org> <52D65423.2070706@linux.vnet.ibm.com> <20140115113015.GB31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140115113015.GB31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 12:30 PM, Peter Zijlstra wrote:
> On Wed, Jan 15, 2014 at 05:25:55PM +0800, Michael wang wrote:
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 0326c06..bf4a6ed 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -3464,6 +3464,10 @@ int sched_setscheduler(struct task_struct *p, int
>> policy,
>>                  .sched_policy   = policy,
>>                  .sched_priority = param->sched_priority
>>          };
>> +
>> +       if (fair_policy(policy))
>> +               attr.sched_nice = PRIO_TO_NICE(attr.sched_priority);
>> +
>>          return __sched_setscheduler(p, &attr, true);
>>   }
>>   EXPORT_SYMBOL_GPL(sched_setscheduler);
>> @@ -3494,6 +3498,10 @@ int sched_setscheduler_nocheck(struct task_struct
>> *p, int policy,
>>                  .sched_policy   = policy,
>>                  .sched_priority = param->sched_priority
>>          };
>> +
>> +       if (fair_policy(policy))
>> +               attr.sched_nice = PRIO_TO_NICE(attr.sched_priority);
>> +
>>          return __sched_setscheduler(p, &attr, false);
>>   }
>
> That seems wrong; the manpage confirms, from sched_setscheduler(2):
>
>         For processes scheduled under one of the normal scheduling
>         policies (SCHED_OTHER, SCHED_IDLE, SCHED_BATCH), sched_priority
>         is not used in scheduling decisions (it must  be  speci‐ fied as
>         0).
>
> That said; we should probably preserve the nice value, which with the
> current code we reset to 0.

I tried this patch also but it does not solve the issue.


> ---
>   kernel/sched/core.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 0326c06953eb..f3abbb7dae62 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3462,7 +3462,8 @@ int sched_setscheduler(struct task_struct *p, int policy,
>   {
>   	struct sched_attr attr = {
>   		.sched_policy   = policy,
> -		.sched_priority = param->sched_priority
> +		.sched_priority = param->sched_priority,
> +		.sched_nice	= PRIO_TO_NICE(p->static_prio),
>   	};
>   	return __sched_setscheduler(p, &attr, true);
>   }
> @@ -3492,7 +3493,8 @@ int sched_setscheduler_nocheck(struct task_struct *p, int policy,
>   {
>   	struct sched_attr attr = {
>   		.sched_policy   = policy,
> -		.sched_priority = param->sched_priority
> +		.sched_priority = param->sched_priority,
> +		.sched_nice	= PRIO_TO_NICE(p->static_prio),
>   	};
>   	return __sched_setscheduler(p, &attr, false);
>   }
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

