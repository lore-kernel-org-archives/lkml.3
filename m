Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab3DOSBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 14:01:33 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:55998 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab3DOSBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 14:01:30 -0400
Message-ID: <516C4076.7070605@gmail.com>
Date: Mon, 15 Apr 2013 11:01:26 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Nathan Zimmer <nzimmer@sgi.com>
Subject: Re: linux-next: Tree for Apr 9 [cpufreq: NULL pointer deref]
References: <CA+icZUU_K9PiFMqMsOEk1+c2DX8LrUojZptPiRVarv4dcB2qFA@mail.gmail.com> <CA+icZUUsAqJ3kyCZivYeTpY7n=EDMv1UcC2VNwQro4h7NHDWag@mail.gmail.com> <CA+icZUW+TB3q58bL+d=A355S4vtRhwMq8AV+tqjv6MgDtHRCaA@mail.gmail.com> <1923819.6Nb81T2TR8@vostro.rjw.lan> <CA+icZUXUGOjGUAFxgQk0780pcBB-YjiujDLXF+gJFegi+pd+dA@mail.gmail.com> <516C25AE.4050503@intel.com> <CAKohpo=OOPBYCD_K6RLw2YrJxhMokwrOww4QM2t2T4SnGObyQQ@mail.gmail.com> <CA+icZUVk1_Dw5Kb8uWwk7xjrgx6jPOfP8BZdFXQ9bqgmdckHuQ@mail.gmail.com>
In-Reply-To: <CA+icZUVk1_Dw5Kb8uWwk7xjrgx6jPOfP8BZdFXQ9bqgmdckHuQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 10:51 AM, Sedat Dilek wrote:
> On Mon, Apr 15, 2013 at 7:22 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> On 15 April 2013 21:37, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
>>> If the intel_pstate driver is being used __cpufreq_governor() should NOT be
>>> called intel_pstate does not implement the target() callback.
>>>
>>> Nathan's commit 5800043b2 changed the fence around the call to
>>> __cpufreq_governor() in __cpufreq_remove_dev() here is the relevant hunk.
>>
>> No it isn't.
>>
>>> +       if (has_target)
>>>                  __cpufreq_governor(data, CPUFREQ_GOV_STOP);
>>
>> As it has taken care of this limitation.
>>
>> BUT some of my earlier patches haven't. :(
>> Here is the fix (Sedat please try this and give your tested-by, use the attached
>> patch as gmail might break what i am copying in mail)..
>>
>> Sorry for being late in fixing this issue, i am still down with Tonsil infection
>> and fever.. Today only i got some power to fix it after seeing Dirk's mail.
>>
>> Your tested-by may help me to recover quickly :)
>>
>
> Hehe.
> Me myself and I was today chez-mon-docteur... Let's see the results on Thursday.
> Again, get well soon.
>
> Tested against...
>
>   "BROKEN" Linux-Next (next-20130411) with attached patchset (incl.
> your cpufreq-next-fixes).
>
> Test-Case...
>
> CONFIG_X86_INTEL_PSTATE=y
>
> root# echo 0 > /sys/devices/system/cpu/cpu3/online
>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
>
> ...did not test on-reboot-case.
>
> ( Dirk promised to test as well... )
>

Tested with:
  while true
  do
  echo 0 > online
  echo 1 > online
  done
For several minutes and rebooting several times seems to have fixed the
issue.

Nathan, Sorry for calling out your patch erroneously I should have paid closer
attention.

Viresh you can add my Tested-by:

Thanks
--Dirk
> - Sedat -
>
>> @Rafael: I will probably be down for one more week and so not doing any
>> reviews for now... I do check important mails sent directly to me though.
>>
>> ------------x----------------------x------------------
>>
>> From: Viresh Kumar <viresh.kumar@linaro.org>
>> Date: Mon, 15 Apr 2013 22:43:57 +0530
>> Subject: [PATCH] cpufreq: Don't call __cpufreq_governor() for drivers without
>>   target()
>>
>> Some cpufreq drivers implement their own governor and so don't need us to call
>> generic governors interface via __cpufreq_governor(). Few recent commits haven't
>> obeyed this law well and we saw some regressions.
>>
>> This patch tries to fix this issue.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>   drivers/cpufreq/cpufreq.c | 18 +++++++++++++-----
>>   1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 3564947..a6f6595 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -858,13 +858,18 @@ static int cpufreq_add_policy_cpu(unsigned int
>> cpu, unsigned int sibling,
>>                                    struct device *dev)
>>   {
>>          struct cpufreq_policy *policy;
>> -       int ret = 0;
>> +       int ret = 0, has_target = 0;
>>          unsigned long flags;
>>
>>          policy = cpufreq_cpu_get(sibling);
>>          WARN_ON(!policy);
>>
>> -       __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>> +       rcu_read_lock();
>> +       has_target = !!rcu_dereference(cpufreq_driver)->target;
>> +       rcu_read_unlock();
>> +
>> +       if (has_target)
>> +               __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>>
>>          lock_policy_rwsem_write(sibling);
>>
>> @@ -877,8 +882,10 @@ static int cpufreq_add_policy_cpu(unsigned int
>> cpu, unsigned int sibling,
>>
>>          unlock_policy_rwsem_write(sibling);
>>
>> -       __cpufreq_governor(policy, CPUFREQ_GOV_START);
>> -       __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
>> +       if (has_target) {
>> +               __cpufreq_governor(policy, CPUFREQ_GOV_START);
>> +               __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
>> +       }
>>
>>          ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
>>          if (ret) {
>> @@ -1146,7 +1153,8 @@ static int __cpufreq_remove_dev(struct device
>> *dev, struct subsys_interface *sif
>>
>>          /* If cpu is last user of policy, free policy */
>>          if (cpus == 1) {
>> -               __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
>> +               if (has_target)
>> +                       __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
>>
>>                  lock_policy_rwsem_read(cpu);
>>                  kobj = &data->kobj;

