Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab3GKG05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:26:57 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:43666 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab3GKG0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:26:55 -0400
Message-ID: <51DE4F44.6060506@linux.vnet.ibm.com>
Date: Thu, 11 Jul 2013 11:53:00 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Lan Tianyu <lantianyu1986@gmail.com>
CC: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>, tianyu.lan@intel.com
Subject: Re: [PATCH] cpufreq: Fix cpufreq regression after suspend/resume
References: <51C08370.4050906@gmx.de> <CAKohpok1gThXL925Yz5UgC54vTVQgymBA1cLGER_g-dgZu0JLA@mail.gmail.com> <51CF1E53.6060902@gmx.de>	<8029836.CFiJCXmRQ0@vostro.rjw.lan> <51D05DF4.50704@linux.vnet.ibm.com>	<51D06556.7080204@gmx.de> <51D07E7F.2030709@linux.vnet.ibm.com>	<51DDC8FA.4020609@gmx.de> <51DDE067.2020106@linux.vnet.ibm.com> <CAOLK0pwr03reaMWAEeaUs-6H2URoisFEJ3J4r83Rm1eTs1hU5w@mail.gmail.com>
In-Reply-To: <CAOLK0pwr03reaMWAEeaUs-6H2URoisFEJ3J4r83Rm1eTs1hU5w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071106-5564-0000-0000-000008BE8B68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 11:10 AM, Lan Tianyu wrote:
> 2013/7/11 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>:
>> Hi Toralf,
>>
>> On 07/11/2013 02:20 AM, Toralf Förster wrote:
>>> I tested the patch several times on top of a66b2e5 - the origin issue is
>>> fixed but - erratically another issue now appears : all 4 cores are runs
>>> after wakeup at 2.6 GHz.
>>> The temporary hot fix is to switch between governor performance and
>>> ondemand for all 4 cores.
>>>
>>>
>>
>> Thanks for all your testing efforts. The commit a66b2e5 took a shortcut to
>> achieve its goals but failed subtly in many aspects. Below is a patch (only
>> compile-tested) which tries to achieve the goal (preserve sysfs files) in
>> the proper way, by separating out the cpufreq-core bits from the sysfs bits.
>> You might want to give it a try on current mainline and see if it improves
>> anything.
>>
>> Regards,
>> Srivatsa S. Bhat
>>
>>
>> (Applies on current mainline)
>> ---
>>
>>  drivers/cpufreq/cpufreq.c |  144 ++++++++++++++++++++++++++-------------------
>>  1 file changed, 82 insertions(+), 62 deletions(-)
>>
[...]
>> +/**
>> + * cpufreq_add_dev - add a CPU device
>> + *
>> + * Adds the cpufreq interface for a CPU device.
>> + *
>> + * The Oracle says: try running cpufreq registration/unregistration concurrently
>> + * with with cpu hotplugging and all hell will break loose. Tried to clean this
>> + * mess up, but more thorough testing is needed. - Mathieu
>> + */
>> +static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>> +{
>> +       return __cpufreq_add_dev(dev, sif, true);
>> +}
>> +
>>  static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
>>  {
>>         int j;
>> @@ -1106,7 +1116,7 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
>>   * This routine frees the rwsem before returning.
>>   */
>>  static int __cpufreq_remove_dev(struct device *dev,
>> -               struct subsys_interface *sif)
>> +                               struct subsys_interface *sif, bool remove_sysfs)
>>  {
>>         unsigned int cpu = dev->id, ret, cpus;
>>         unsigned long flags;
>> @@ -1145,9 +1155,9 @@ static int __cpufreq_remove_dev(struct device *dev,
>>                 cpumask_clear_cpu(cpu, data->cpus);
>>         unlock_policy_rwsem_write(cpu);
>>
>> -       if (cpu != data->cpu) {
>> +       if (cpu != data->cpu && remove_sysfs) {
>>                 sysfs_remove_link(&dev->kobj, "cpufreq");
>> -       } else if (cpus > 1) {
>> +       } else if (cpus > 1 && remove_sysfs) {
>>                 /* first sibling now owns the new sysfs dir */
>>                 cpu_dev = get_cpu_device(cpumask_first(data->cpus));
>>                 sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
>> @@ -1184,26 +1194,25 @@ static int __cpufreq_remove_dev(struct device *dev,
>>
>>         /* If cpu is last user of policy, free policy */
>>         if (cpus == 1) {
>> -               lock_policy_rwsem_read(cpu);
>> -               kobj = &data->kobj;
>> -               cmp = &data->kobj_unregister;
>> -               unlock_policy_rwsem_read(cpu);
>> -               kobject_put(kobj);
>> -
>> -               /* we need to make sure that the underlying kobj is actually
>> -                * not referenced anymore by anybody before we proceed with
>> -                * unloading.
>> -                */
>> -               pr_debug("waiting for dropping of refcount\n");
>> -               wait_for_completion(cmp);
>> -               pr_debug("wait complete\n");
>> -
>>                 if (cpufreq_driver->exit)
>>                         cpufreq_driver->exit(data);
>>
>>                 free_cpumask_var(data->related_cpus);
>>                 free_cpumask_var(data->cpus);
>>                 kfree(data);
>> +
>> +               if (remove_sysfs) {
>> +                       lock_policy_rwsem_read(cpu);
>> +                       kobj = &data->kobj;
>> +                       cmp = &data->kobj_unregister;
> 
> This looks no right.  "data" has already been freed but data-> kobj still is
> referenced.
> 

Oops! You are right. Hmm, this looks quite difficult to get right :(
There are multiple challenges here:

1. The sysfs files must not be removed during cpu_down, and not initialized

   during cpu_up. That would help us preserve the file permissions.
2. But we should ensure that we really do the cpufreq-core parts of the cpu
   initialization during cpu_up. If we fail to free some of the data-structures
   during cpu_down, the cpu_up callback will think that a full-init is not
   required and not do its job. That will make cpufreq behave erratically after
   suspend/resume and take us back to square one.

3. A full re-init in the cpu_up callback also involves memory allocations.
   So if we don't release the memory in the cpu_down callback, we'll end up
   in a memory leak.

I tried to address all these in this patch, but you found yet another serious
loop-hole. I guess I'm out of ideas now... if anybody has any thoughts on how
to get this right, then I'm all ears. Else, we'll just revert the original
commit like Rafael suggested and leave it upto userspace to save and restore
the permissions across suspend/resume if it wants ;-(

>> +                       unlock_policy_rwsem_read(cpu);
>> +                       kobject_put(kobj);
>> +
>> +                       pr_debug("waiting for dropping of refcount\n");
>> +                       wait_for_completion(cmp);
>> +                       pr_debug("wait complete\n");
>> +               }
>> +
>>         } else if (cpufreq_driver->target) {
>>                 __cpufreq_governor(data, CPUFREQ_GOV_START);
>>                 __cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
>> @@ -1221,7 +1230,7 @@ static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
>>         if (cpu_is_offline(cpu))
>>                 return 0;
>>
>> -       retval = __cpufreq_remove_dev(dev, sif);
>> +       retval = __cpufreq_remove_dev(dev, sif, true);
>>         return retval;
>>  }

Regards,
Srivatsa S. Bhat

