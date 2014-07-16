Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbaGPTe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:34:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60643 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaGPTeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:34:25 -0400
Message-ID: <53C6D3BE.5070505@codeaurora.org>
Date: Wed, 16 Jul 2014 12:34:22 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 2/2] cpufreq: Simplify and fix mutual exclusion with
 hotplug
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org> <1405464473-3916-3-git-send-email-skannan@codeaurora.org> <CAKohpomuo-=fox=1rNZOgvy+COyWYexcP2J9NRFJqmTK6MLOjA@mail.gmail.com>
In-Reply-To: <CAKohpomuo-=fox=1rNZOgvy+COyWYexcP2J9NRFJqmTK6MLOjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 01:48 AM, Viresh Kumar wrote:
> On 16 July 2014 04:17, Saravana Kannan <skannan@codeaurora.org> wrote:
>
> Again, just too many things in a single patch. That's not acceptable.
> Few of these might be bug fixes, which must go in before any other updates.
> And so it must have been added as first patch.
>
> Even the other stuff you are trying to fix (by checking policy->cpus) should go
> before 1/2, otherwise 1/2 will actually break things inbetween, i.e. show values
> even when no CPUs of a cluster are online.

Well, it's no worse that what it does today. The existing code actually 
causes a crash when you try to show while hotplugging a CPU. I'm keeping 
the 1/2 as small as possible. You clearly want to smaller, so I don't 
want to add this to that.

Also, the current add/remove path is complicated with many cases. So, 
I'm not comfortable saying I'm sure policy->cpus check would be 
sufficient. I'm willing to throw out this change if you think this is 
still wrong when it comes after 1/2.

>> Since we no longer alloc and destroy/freeze policy and sysfs nodes during
>> hotplug and suspend, we don't need to lock sysfs with hotplug. We can
>> achieve the same effect by checking if policy->cpus is empty.
>
> Are you talking about the changes in store()?

Yes.

>
>> Hotplug mutual exclusion was only done for sysfs writes. But reads need the
>> same protection too.  So, this patch adds that too.
>
> How? How is checking for policy->cpus enough?

Because when all the CPUs in a policy are hotplugged off, the 
policy->cpus would be empty? So, it's functionally the same without 
having to get hotplug lock. This way, CPUs of other policies could be 
hotplugged while your are show/store on one policy.

But I'm sure you already understood this. So, not sure what you are 
really asking.

>
>> Also, cpufreq driver (un)register can race with hotplug since CPU online
>> state can change between adding/removing the currently online devices and
>> registering/unregistering for hotplug notifiers. So, fix that by
>> registering for hotplug notifiers first before adding devices and
>> unregistering from hotplug notifiers first before removing devices.
>
> Couldn't get it, tell us an example race and what will go wrong due to it.
> Also this should have had a separate patch for itself.

I assumed we go a lot of down_write()s and that would cause a 
down_read_trylock() to fail. But we really do that only for cpufreq 
driver register/unregister. So, my previous statement is not really a 
very useful/common.

But I do hate that we do "trylock". It always makes one wonder if it 
will silently fail (since we return NULL, which is same as policy with 
"offline" policy). Technically, we could do down_read(), but lockdep is 
throwing warnings when it's really not an issue (doing down read twice). 
So, I'm guessing all these trylocks are just to keep lockdep happy?


>
>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>> ---
>>   drivers/cpufreq/cpufreq.c | 44 ++++++++++++++++++++------------------------
>>   1 file changed, 20 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index a0a2ec2..f72b2b7 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -748,17 +748,18 @@ static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
>>   {
>>          struct cpufreq_policy *policy = to_policy(kobj);
>>          struct freq_attr *fattr = to_attr(attr);
>> -       ssize_t ret;
>> +       ssize_t ret = -EINVAL;
>>
>>          if (!down_read_trylock(&cpufreq_rwsem))
>> -               return -EINVAL;
>> -
>> +               return ret;
>>          down_read(&policy->rwsem);
>>
>> -       if (fattr->show)
>> -               ret = fattr->show(policy, buf);
>> -       else
>> -               ret = -EIO;
>> +       if (!cpumask_empty(policy->cpus)) {
>> +               if (fattr->show)
>> +                       ret = fattr->show(policy, buf);
>> +               else
>> +                       ret = -EIO;
>> +       }
>
> Makes sense upto this point.
>
>>          up_read(&policy->rwsem);
>>          up_read(&cpufreq_rwsem);
>> @@ -773,26 +774,19 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
>>          struct freq_attr *fattr = to_attr(attr);
>>          ssize_t ret = -EINVAL;
>>
>> -       get_online_cpus();
>> -
>> -       if (!cpu_online(policy->cpu))
>> -               goto unlock;
>> -
>
> @Srivatsa: what do you say?
>
>>          if (!down_read_trylock(&cpufreq_rwsem))
>> -               goto unlock;
>> -
>> +               return ret;
>>          down_write(&policy->rwsem);
>>
>> -       if (fattr->store)
>> -               ret = fattr->store(policy, buf, count);
>> -       else
>> -               ret = -EIO;
>> +       if (!cpumask_empty(policy->cpus)) {
>> +               if (fattr->store)
>> +                       ret = fattr->store(policy, buf, count);
>> +               else
>> +                       ret = -EIO;
>> +       }
>>
>>          up_write(&policy->rwsem);
>> -
>>          up_read(&cpufreq_rwsem);
>> -unlock:
>> -       put_online_cpus();
>>
>>          return ret;
>>   }
>> @@ -2270,6 +2264,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>>                  }
>>          }
>>
>> +       register_hotcpu_notifier(&cpufreq_cpu_notifier);
>> +
>>          ret = subsys_interface_register(&cpufreq_interface);
>>          if (ret)
>>                  goto err_boost_unreg;
>> @@ -2293,13 +2289,13 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>>                  }
>>          }
>>
>> -       register_hotcpu_notifier(&cpufreq_cpu_notifier);
>>          pr_debug("driver %s up and running\n", driver_data->name);
>>
>>          return 0;
>>   err_if_unreg:
>>          subsys_interface_unregister(&cpufreq_interface);
>>   err_boost_unreg:
>> +       unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
>>          if (cpufreq_boost_supported())
>>                  cpufreq_sysfs_remove_file(&boost.attr);
>>   err_null_driver:
>> @@ -2327,12 +2323,12 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
>>
>>          pr_debug("unregistering driver %s\n", driver->name);
>>
>> +       unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
>> +
>>          subsys_interface_unregister(&cpufreq_interface);
>>          if (cpufreq_boost_supported())
>>                  cpufreq_sysfs_remove_file(&boost.attr);
>>
>> -       unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
>> -
>>          down_write(&cpufreq_rwsem);
>>          write_lock_irqsave(&cpufreq_driver_lock, flags);
>
> Normally the order of register/unregister should be just opposite.
> Isn't that true here? Yeah, it was broken earlier as well...

Generally agreed, but as explained in the commit text, we need to keep 
it this way to avoid races with hotplug/unregister.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
