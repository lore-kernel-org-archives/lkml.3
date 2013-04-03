Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415Ab3DCQhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:37:07 -0400
Received: from relay1.sgi.com ([192.48.179.29]:36664 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762370Ab3DCQhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:37:04 -0400
Message-ID: <515C5AB6.5090109@sgi.com>
Date: Wed, 3 Apr 2013 11:37:10 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@sisk.pl>, <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: convert the cpufreq_driver to use the rcu
References: <AKohpo=Um9LGhGtMB0z9C2jxmS3oHwV7i_Gmsq5rR80ZcGYyLw@mail.gmail.com> <1365001386-29970-1-git-send-email-nzimmer@sgi.com> <CAKohpon1QiCfJhWBi_f7U1EU410JMGHq+QnpEPJ+rdiUjsKsQA@mail.gmail.com>
In-Reply-To: <CAKohpon1QiCfJhWBi_f7U1EU410JMGHq+QnpEPJ+rdiUjsKsQA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 10:32 AM, Viresh Kumar wrote:
> Please always mention Version number and history. Not everybody
> remembers what changed after last version.
Your right.  I was rushing and forgot.
I need to develop the habit of adding some history to my git commits 
when I amend them.

>
> On 3 April 2013 20:33, Nathan Zimmer <nzimmer@sgi.com> wrote:
>> We eventually would like to remove the rwlock cpufreq_driver_lock or convert
>> it back to a spinlock and protect the read sections with RCU.  The first step in
> Why do we want to convert it back to spinlock?
Documentation/spinlocks.txt:84
I am not sure why but there is the directive I am following.
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>>   bool have_governor_per_policy(void)
>>   {
>> -       return cpufreq_driver->have_governor_per_policy;
>> +       bool have_governor;
> Name it have_governor_per_policy, it looks wrong otherwise.
>
>> +       rcu_read_lock();
>> +       have_governor = rcu_dereference(cpufreq_driver)->have_governor_per_policy;
>> +       rcu_read_unlock();
>> +       return have_governor;
>>   }
Will do.
>>   static ssize_t show_scaling_driver(struct cpufreq_policy *policy, char *buf)
>>   {
>> -       return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n", cpufreq_driver->name);
>> +       char *name;
>> +       rcu_read_lock();
>> +       name = rcu_dereference(cpufreq_driver)->name;
>> +       rcu_read_unlock();
>> +       return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n", name);
>>   }
> This is the definition of struct cpufreq_driver:
>
> struct cpufreq_driver {
> 	struct module           *owner;
> 	char			name[CPUFREQ_NAME_LEN];
>
>         ...
> };
>
> Purpose of rcu read_lock/unlock are to define the rcu critical section
> after which rcu layer is free to free the memory allocated to earlier
> instance of cpufreq_driver.
>
> So, after the unlock() call you _should_not_ use the memory allocated to
> cpufreq_driver instance. And here, you are using memory allocated to name[]
> after the unlock() call.
Ok I'll fix this spot.

> Which looks to be wrong... I left other parts of driver upto you to fix for this
> "rule of thumb".
In places like show_bios_limit and cpufreq_add_dev_interface we know 
that the memory will still
be there since the cpufreq_driver->owner is held.

> Sorry for not pointing this earlier but rcu is as new to me as it is
> to you. I know
> you must be frustrated with so many versions of this patch, and everytime we
> get a new problem to you... Don't get disheartened with it.. Keep the good work
> going :)
Making a learners mistake isn't really discouraging to me, even when I 
do it twice.

> --
> viresh

