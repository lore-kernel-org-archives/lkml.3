Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab3HBGxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 02:53:40 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52769 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab3HBGxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 02:53:38 -0400
Message-ID: <51FB568B.1040902@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 12:19:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [Update][PATCH] cpufreq: Do not hold driver module references
 for additional policy CPUs
References: <2362640.pUofnXyzOi@vostro.rjw.lan> <51FAC46D.1000703@linux.vnet.ibm.com>	<1757496.qSuJuAun9Z@vostro.rjw.lan> <2298639.F0Qv2QqRnZ@vostro.rjw.lan> <CAKohponru8Z1fod43dVtAODmYuMTGX70+73b8wk4wuGN=Vuh-w@mail.gmail.com>
In-Reply-To: <CAKohponru8Z1fod43dVtAODmYuMTGX70+73b8wk4wuGN=Vuh-w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080206-5140-0000-0000-0000039DDC57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 10:07 AM, Viresh Kumar wrote:
> Wow!! Lot of stuff happened while I was asleep..
> 
> @Srivatsa: Thanks for answering what I would have answered to Rafael :)
> And you should really get some sleep, I would suggest :)

No problem :-) And thank you for your concern :-)

> 
> On 2 August 2013 02:23, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Subject: cpufreq: Do not hold driver module references for additional policy CPUs
> 
> I still have issues with this subject. Why don't we get rid of .owner
> field completely? And stop using a mix of cpufreq_cpu_get() and
> kobject_get()?
>

I guess Rafael's intention is to do one thing at a time - fix the
inconsistency first, and then rework the synchronization on top of
it. And that makes sense to me, since its the logical way of fixing
all these issues.
 
>> The cpufreq core is a little inconsistent in the way it uses the
>> driver module refcount.
>>
>> Namely, if __cpufreq_add_dev() is called for a CPU that doesn't
>> share the policy object with any other CPUs, the driver module
>> refcount it grabs to start with will be dropped by it before
>> returning and will be equal to 0 afterward.
> 
> It wouldn't be zero but 1, this is what it is initialized with probably.
> That's what I can see in my tests.
> 

But lsmod shows 0 for the cpufreq driver right? (Note, your related_cpus
should have only 1 CPU each, for you to see 0. Else, you'll see a non-zero
value due to the very bug/inconsistency that Rafael is fixing in this
patch).

>> However, if the given CPU does share the policy object with other
>> CPUs, either cpufreq_add_policy_cpu() is called to link the new CPU
>> to the existing policy, or cpufreq_add_dev_symlink() is used to link
>> the other CPUs sharing the policy with it to the just created policy
>> object.  In that case, because both cpufreq_add_policy_cpu() and
>> cpufreq_add_dev_symlink() call cpufreq_cpu_get() for the given
>> policy (the latter possibly many times) without the balancing
>> cpufreq_cpu_put() (unless there is an error), the driver module
>> refcount will be left by __cpufreq_add_dev() with a nonzero value.
>>
>> To remove that inconsistency make cpufreq_add_policy_cpu() execute
>> cpufreq_cpu_put() for the given policy before returning, which
>> decrements the driver module refcount so that it will be 0 after
>> __cpufreq_add_dev() returns.  Moreover, remove the cpufreq_cpu_get()
>> call from cpufreq_add_dev_symlink(), since both the policy refcount
>> and the driver module refcount are nonzero when it is called and they
>> don't need to be bumped up by it.
>>
>> Accordingly, drop the cpufreq_cpu_put() from __cpufreq_remove_dev(),
>> since it is only necessary to balance the cpufreq_cpu_get() called
>> by cpufreq_add_policy_cpu() or cpufreq_add_dev_symlink().
>>
>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>  drivers/cpufreq/cpufreq.c |   28 +++++++---------------------
>>  1 file changed, 7 insertions(+), 21 deletions(-)
> 
> So, we can't rmmod the module as soon as it is inserted and so the
> problem stays as is. :(
> 

No, we get one step closer to the solution, since we fix the inconsistency
between refcounts. Next step would be to get rid of refcounts and use
locking like you suggested. Then we can rmmod it easily. I'm assuming
Rafael has the same plan.

(We could have done all this in one-shot, but that would make it difficult
to track regressions etc. So good to have each improvement in a separate
patch).

>> Index: linux-pm/drivers/cpufreq/cpufreq.c
>> ===================================================================
>> --- linux-pm.orig/drivers/cpufreq/cpufreq.c
>> +++ linux-pm/drivers/cpufreq/cpufreq.c
>> @@ -818,14 +818,11 @@ static int cpufreq_add_dev_symlink(struc
>>                         continue;
>>
>>                 pr_debug("Adding link for CPU: %u\n", j);
>> -               cpufreq_cpu_get(policy->cpu);
>>                 cpu_dev = get_cpu_device(j);
>>                 ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
>>                                         "cpufreq");
>> -               if (ret) {
>> -                       cpufreq_cpu_put(policy);
>> -                       return ret;
>> -               }
>> +               if (ret)
>> +                       break;
>>         }
>>         return ret;
>>  }
>> @@ -908,7 +905,8 @@ static int cpufreq_add_policy_cpu(unsign
>>         unsigned long flags;
>>
>>         policy = cpufreq_cpu_get(sibling);
> 
> This can be skipped completely at this place. Caller of
> cpufreq_add_policy_cpu() has got the policy pointer with it and so
> can be passed. I haven't done it earlier as the impression was we need
> to call cpufreq_cpu_get()..
> 

Agreed, that would be a good cleanup.

>> -       WARN_ON(!policy);
>> +       if (WARN_ON_ONCE(!policy))
>> +               return -ENODATA;
>>
>>         if (has_target)
>>                 __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>> @@ -930,16 +928,10 @@ static int cpufreq_add_policy_cpu(unsign
>>         }
>>
>>         /* Don't touch sysfs links during light-weight init */
>> -       if (frozen) {
>> -               /* Drop the extra refcount that we took above */
>> -               cpufreq_cpu_put(policy);
>> -               return 0;
>> -       }
>> -
>> -       ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
>> -       if (ret)
>> -               cpufreq_cpu_put(policy);
>> +       if (!frozen)
>> +               ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
>>
>> +       cpufreq_cpu_put(policy);
> 
> And so this will go away.
> 

Regards,
Srivatsa S. Bhat

