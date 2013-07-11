Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3GKODm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:03:42 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:49066 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab3GKODk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:03:40 -0400
MIME-Version: 1.0
In-Reply-To: <51DE4F44.6060506@linux.vnet.ibm.com>
References: <51C08370.4050906@gmx.de>
	<CAKohpok1gThXL925Yz5UgC54vTVQgymBA1cLGER_g-dgZu0JLA@mail.gmail.com>
	<51CF1E53.6060902@gmx.de>
	<8029836.CFiJCXmRQ0@vostro.rjw.lan>
	<51D05DF4.50704@linux.vnet.ibm.com>
	<51D06556.7080204@gmx.de>
	<51D07E7F.2030709@linux.vnet.ibm.com>
	<51DDC8FA.4020609@gmx.de>
	<51DDE067.2020106@linux.vnet.ibm.com>
	<CAOLK0pwr03reaMWAEeaUs-6H2URoisFEJ3J4r83Rm1eTs1hU5w@mail.gmail.com>
	<51DE4F44.6060506@linux.vnet.ibm.com>
Date: Thu, 11 Jul 2013 22:03:39 +0800
Message-ID: <CAOLK0pyJ=MoE20adyg8oUP-bTiwvXobRNX4ayA5eGRH0UGbpgw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Fix cpufreq regression after suspend/resume
From: Lan Tianyu <lantianyu1986@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>, tianyu.lan@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/11 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>:
> On 07/11/2013 11:10 AM, Lan Tianyu wrote:
>> 2013/7/11 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>:
> Oops! You are right. Hmm, this looks quite difficult to get right :(
> There are multiple challenges here:

If I understand correctly, the most concern is how to deal with per cpus'
cpufreq_policy structure. If something wrong , please correct me.

>
> 1. The sysfs files must not be removed during cpu_down, and not initialized
>
>    during cpu_up. That would help us preserve the file permissions.

For this case, cpufreq_policy must be reserved since all related cpufreq data
and kobj is also store into it. We can't release it.

> 2. But we should ensure that we really do the cpufreq-core parts of the cpu
>    initialization during cpu_up. If we fail to free some of the data-structures
>    during cpu_down, the cpu_up callback will think that a full-init is not
>    required and not do its job. That will make cpufreq behave erratically after
>    suspend/resume and take us back to square one.
>

cpufreq_add_dev() checks whether the cpu has been attached cpufreq_cpu_data
and associated kobj has been created. If yes, it would try to release it by
cpufreq_cpu_put() and return directly. This seems to be conflicted
with the above.

> 3. A full re-init in the cpu_up callback also involves memory allocations.
>    So if we don't release the memory in the cpu_down callback, we'll end up
>    in a memory leak.
>

Even we remove the previous check, cpu scaling driver's init()  also will change
some data of struct cpufreq_policy and this is also what we don't like to see.

> I tried to address all these in this patch, but you found yet another serious
> loop-hole. I guess I'm out of ideas now... if anybody has any thoughts on how
> to get this right, then I'm all ears. Else, we'll just revert the original
> commit like Rafael suggested and leave it upto userspace to save and restore
> the permissions across suspend/resume if it wants ;-(
>

How about implement scaling driver's suspend/resume callback()? Although this
needs to be dealt with case by case. If one's callbacks hasn't been implemented,
it would have to follow current rule.

>>> +                       unlock_policy_rwsem_read(cpu);
>>> +                       kobject_put(kobj);
>>> +
>>> +                       pr_debug("waiting for dropping of refcount\n");
>>> +                       wait_for_completion(cmp);
>>> +                       pr_debug("wait complete\n");
>>> +               }
>>> +
>>>         } else if (cpufreq_driver->target) {
>>>                 __cpufreq_governor(data, CPUFREQ_GOV_START);
>>>                 __cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
>>> @@ -1221,7 +1230,7 @@ static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
>>>         if (cpu_is_offline(cpu))
>>>                 return 0;
>>>
>>> -       retval = __cpufreq_remove_dev(dev, sif);
>>> +       retval = __cpufreq_remove_dev(dev, sif, true);
>>>         return retval;
>>>  }
>
> Regards,
> Srivatsa S. Bhat
>



-- 
Best regards
Tianyu Lan
