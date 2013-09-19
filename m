Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3ISMuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:50:46 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:54420 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab3ISMup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:50:45 -0400
Message-ID: <523AF22F.1010909@linux.vnet.ibm.com>
Date: Thu, 19 Sep 2013 18:16:39 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: Regression on cpufreq in v3.12-rc1
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com> <45987104.t6r4hvPgQn@vostro.rjw.lan>
In-Reply-To: <45987104.t6r4hvPgQn@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091912-3864-0000-0000-00000A259206
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 04:11 AM, Rafael J. Wysocki wrote:
> On Wednesday, September 18, 2013 11:21:45 PM Linus Walleij wrote:
>> Hi Rafael, Viresh,
>>
>> I'm seeing this problem and maybe you can help me out fixing it
>> properly:
>>
>> On some machines like the StrongARM SA1100 it seems that
>> cpufreq_get() can be called before the cpufreq driver and thus the
>> policy is set, resulting in a crash like this:
> 
> Did you try the current linux-next branch from my tree?
> 
> Rafael
> 
> 
>> ------------[ cut here ]------------
>> kernel BUG at /home/linus/linux/drivers/cpufreq/cpufreq.c:80!
>> Internal error: Oops - BUG: 0 [#1] ARM
>> Modules linked in:
>> CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc1-00001-g1266dae-dirty #17
>> task: c1830000 ti: c1832000 task.ti: c1832000
>> (...)
>> Backtrace:
>> [<c01ea1a4>] (lock_policy_rwsem_read+0x0/0x48) from [<c01eb5c8>]
>> (cpufreq_get+0x34/0x68)
>> [<c01eb594>] (cpufreq_get+0x0/0x68) from [<c0185908>]
>> (sa1100fb_activate_var+0xdc/0x3ac)
>>  r5:00000003 r4:0000000a
>> [<c018582c>] (sa1100fb_activate_var+0x0/0x3ac) from [<c0185c78>]
>> (sa1100fb_set_par+0xa0/0xa8)
>> [<c0185bd8>] (sa1100fb_set_par+0x0/0xa8) from [<c0180418>]
>> (fbcon_init+0x444/0x4a8)
>>  r4:c1803200
>> [<c017ffd4>] (fbcon_init+0x0/0x4a8) from [<c019a8b4>] (visual_init+0x78/0xc8)
>> [<c019a83c>] (visual_init+0x0/0xc8) from [<c01a0010>]
>> (do_bind_con_driver+0x160/0x310)
>>
>> This bug comes from the framebuffer but I first encountered it
>> in the PCMCIA driver, and both seem to cause the bug.
>>
>> In the past I think things worked smoothly: the consumers
>> calling cpufreq_get() too early would just get 0 back.
>> (Or so it seems to me.)
>>
>> The BUG() statement causing it is in the lock_policy_rwsem_##mode(int cpu)
>> macro.
>>
>> Applying a patch like this seems to fix the issue:
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 43c24aa..4977b4b 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -70,7 +70,8 @@ static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
>>  static int lock_policy_rwsem_##mode(int cpu)                           \
>>  {                                                                      \
>>         struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu); \
>> -       BUG_ON(!policy);                                                \
>> +       if(!policy)                                                     \
>> +               return 0;                                               \
>>         down_##mode(&per_cpu(cpu_policy_rwsem, policy->cpu));           \
>>                                                                         \
>>         return 0;                                                       \
>> @@ -83,7 +84,8 @@ lock_policy_rwsem(write, cpu);
>>  static void unlock_policy_rwsem_##mode(int cpu)
>>          \
>>  {                                                                      \
>>         struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu); \
>> -       BUG_ON(!policy);                                                \
>> +       if(!policy)                                                     \
>> +               return;                                                 \
>>         up_##mode(&per_cpu(cpu_policy_rwsem, policy->cpu));             \
>>  }
>>
>> @@ -1423,6 +1425,9 @@ static unsigned int __cpufreq_get(unsigned int cpu)
>>         struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
>>         unsigned int ret_freq = 0;
>>
>> +       if (!policy)
>> +               return ret_freq;
>> +
>>         if (!cpufreq_driver->get)
>>                 return ret_freq;
>>
>> I don't really know if this is the right solution at all, so please
>> help me out here... if you want that patch I can send it once
>> I understand this properly.
>>

IIRC, recent kernels didn't return 0 or any error code when the !policy
condition was matched. So can you check whether this problem occurs with
3.11 or 3.10 as well?

In case the problem is unique to 3.12-rc1, I guess some recent commit changed
the ordering somewhere, which lead to premature invocations of cpufreq_get().
So I think we should first identify (bisect?) and understand what caused that
particular change and then we will be in a position to evaluate whether the
patch you proposed would be the right fix or not.

Regards,
Srivatsa S. Bhat

