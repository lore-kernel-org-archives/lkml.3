Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179AbaGPLSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:18:20 -0400
Received: from dmz-mailsec-scanner-7.mit.edu ([18.7.68.36]:52569 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756792AbaGPLSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:18:16 -0400
X-AuditID: 12074424-f79146d00000067c-fa-53c65f779afc
Message-ID: <53C65F03.1050609@mit.edu>
Date: Wed, 16 Jul 2014 16:46:19 +0530
From: "Srivatsa S. Bhat" <srivatsa@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>
CC: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 1/2] cpufreq: Don't destroy/realloc policy/sysfs on
 hotplug/suspend
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org>	<1405464473-3916-2-git-send-email-skannan@codeaurora.org> <CAKohpok2hzwDLy77CZJ+7pHV-Nj4XTviJxVeXQYJRYtKXME00w@mail.gmail.com>
In-Reply-To: <CAKohpok2hzwDLy77CZJ+7pHV-Nj4XTviJxVeXQYJRYtKXME00w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsUixG6nolsefyzYYMECSYtNj6+xWkzcf5bd
	4vKuOWwWn3uPMFqcOX2J1eLHmW4WiwMXJ7JZnF3ezGax8auHA6fH5b5eJo8Fm0o97lzbw+ax
	eUm9x5ar7SwenzfJBbBFcdmkpOZklqUW6dslcGVsetHIVPDHtKLt5CLmBsanGl2MnBwSAiYS
	u1YvZIGwxSQu3FvP1sXIxSEkMJtJomPuPSYIZyOjxMJNy6Cc7UwSpz49YAVp4RVQk2iYtIcd
	xGYRUJVY9vYOkM3BwSagLbFsoyRIWFQgTqLx+HdGiHJBiZMzn4BtExGIlbi38jXYNmaBtcwS
	D75NA5spLBAj8ev+PnaIZUcYJdYc28wEMpRTIFDi+Fk+EJNZQF1i/TwhkHJmAXmJ7W/nME9g
	FJyFZMUshKpZSKoWMDKvYpRNya3SzU3MzClOTdYtTk7My0st0jXXy80s0UtNKd3ECI4SF5Ud
	jM2HlA4xCnAwKvHwbgg5GizEmlhWXJl7iFGSg0lJlLfD4liwEF9SfkplRmJxRnxRaU5q8SFG
	CQ5mJRFeB3+gHG9KYmVValE+TEqag0VJnPettVWwkEB6YklqdmpqQWoRTFaGg0NJgrcuDqhR
	sCg1PbUiLTOnBCHNxMEJMpwHaLg9SA1vcUFibnFmOkT+FKOilDivfCxQQgAkkVGaB9cLS2Kv
	GMWBXhHmzQZp5wEmQLjuV0CDmYAGl9ccBhlckoiQkmpgZL4jqme2uEnmj8W3gkQGMXeXL23N
	i3bbLii8HHFq3YQ3q39PLBfT3PFA4l++lPiy2+3vNl5kY75bad72k+llqOmtrClzznldZn50
	4ekyT5bcos+TXqR0vs6/KyGWKVTyIq1NaHuVYe6NtkLOlsNznnf/CdvuGr9A2zT+80PexaKz
	f9X8PKlfqcRSnJFoqMVcVJwIAALG3xU9AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 01:54 PM, Viresh Kumar wrote:
> On 16 July 2014 04:17, Saravana Kannan <skannan@codeaurora.org> wrote:
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> 
>> +/* symlink related CPUs */
>> +static int cpufreq_dev_symlink(struct cpufreq_policy *policy, bool add)
>>  {
>> -       unsigned int j;
>> +       unsigned int j, first_cpu = cpumask_first(policy->related_cpus);
> 
> The CPU which came first should get the ownership by default, instead
> of the first one in the mask.
> 
> Normally at boot, all CPUs come up first and then only cpufreq init starts.
> But in case all other CPUs fail to come up, then policy->cpu *might* point
> to a failed cpu.
> 
> And so, we should simply use policy->cpu here instead of finding the
> first one in the mask.
> 
> Also, its not the duty of this routine to find which one is the policy cpu as
> that is done by __cpufreq_add_dev(). And so in case we need to make
> first cpu of a mask as policy->cpu, it should be done in __cpufreq_add_dev()
> and not here. This one should just follow the orders :)
> 
> @Srivatsa: What happens to the sysfs directory if a CPU fails to come up?
> Is it exactly similar to how it happens in hotplug? i.e. we do have a directory
> there?
> 

Short answer: If the sysfs directory has already been created by cpufreq,
then yes, it will remain as it is. However, if the online operation failed
before that, then cpufreq won't know about that CPU at all, and no file will
be created.

Long answer:
The existing cpufreq code does all its work (including creating the sysfs
directories etc) at the CPU_ONLINE stage. This stage is not expected to fail
(in fact even the core CPU hotplug code in kernel/cpu.c doesn't care for
error returns at this point). So if a CPU fails to come up in earlier stages
itself (such as CPU_UP_PREPARE), then cpufreq won't even hear about that CPU,
and hence no sysfs files will be created/linked. However, if the CPU bringup
operation fails during the CPU_ONLINE stage after the cpufreq's notifier has
been invoked, then we do nothing about it and the cpufreq sysfs files will
remain.

>>         int ret = 0;
>>
>> -       for_each_cpu(j, policy->cpus) {
>> +       for_each_cpu(j, policy->related_cpus) {
>>                 struct device *cpu_dev;
>>

[...]

>> @@ -961,60 +967,58 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
>>  }
>>
>>  #ifdef CONFIG_HOTPLUG_CPU
> 
> @Srivatsa: I will try this but you also take care of this. These
> ifdefs might go wrong,
> i.e. we are surely using it in the current patch without HOTPLUG as well. See
> cpufreq_add_dev()..
> 

Yeah, looks suspicious.

> Also, how does suspend/resume work without CONFIG_HOTPLUG_CPU ?
> What's the sequence of events?
> 

Well, CONFIG_SUSPEND doesn't have an explicit dependency on HOTPLUG_CPU, but
SMP systems usually use CONFIG_PM_SLEEP_SMP, which sets CONFIG_HOTPLUG_CPU.
(I guess the reason why CONFIG_SUSPEND doesn't depend on HOTPLUG_CPU is
because suspend is possible even on uniprocessor systems and hence the
Kconfig dependency wasn't really justified).

>> -static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
>> -                                 unsigned int cpu, struct device *dev)
>> +static int cpufreq_change_policy_cpus(struct cpufreq_policy *policy,
>> +                                 unsigned int cpu, bool add)

[...]

>> -
>> -       if (!cpufreq_driver->setpolicy)
>> -               strncpy(per_cpu(cpufreq_cpu_governor, cpu),
>> -                       policy->governor->name, CPUFREQ_NAME_LEN);
> 
> Where is this gone? There are several instances of code just being
> removed, this is the third one. Its really really tough to catch these
> in this big of a patch. Believe me.
> 
> You have to break this patch into multiple ones, see this on how to
> break even simplest of the changes into multiple patches:
> https://lkml.org/lkml/2013/9/6/400
> 
> Its just impossible to catch bugs that you might have introduced here due
> to the size of this patch. And its taking a LOT of time for me to review this.
> As I have to keep diff in one tab, new cpufreq.c in one and the old cpufreq.c
> in one and then compare..
> 

True, this is still a pretty huge chunk. Saravana, at this stage, don't worry
about making cpufreq work properly in each and every patch. Just ensure that
every patch builds fine; that should be good enough. I hope this will help you
in splitting up the patches further.

One other thing: your changelog contains what we usually write in a cover-
letter - *very* high-level goals of the patch. Ideally, you should explain
the subtle details and the non-obvious decisions or trade-offs that you have
made at various places in the code. Otherwise it becomes very hard to follow
your thought-flow just by looking at the patch. So please split up the patch
further and also make the changelogs useful to review the patch :-)

The link that Viresh gave above also did a lot of code reorganization in
cpufreq, so it should give you a good example of how to proceed.

[...]

>>                         __cpufreq_add_dev(dev, NULL);
>>                         break;
>>
>>                 case CPU_DOWN_PREPARE:
>> -                       __cpufreq_remove_dev_prepare(dev, NULL);
>> -                       break;
>> -
>> -               case CPU_POST_DEAD:
>> -                       __cpufreq_remove_dev_finish(dev, NULL);
>> -                       break;
>> -
>> -               case CPU_DOWN_FAILED:
>> -                       __cpufreq_add_dev(dev, NULL);
>> +                       __cpufreq_remove_dev(dev, NULL);
> 
> @Srivatsa: You might want to have a look at this, remove sequence was
> separated for some purpose and I am just not able to concentrate enough
> to think of that, just too many cases running in my mind :)
> 

Yeah, we had split it into _remove_dev_prepare() and _remove_dev_finish()
to avoid a few potential deadlocks. We wanted to call _remove_dev_prepare()
in the DOWN_PREPARE stage and then call _remove_dev_finish() (which waits
for the kobject refcount to drop) in the POST_DEAD stage. That is, we wanted
to do the kobject cleanup after releasing the hotplug lock, and POST_DEAD stage
was well-suited for that.

Commit 1aee40ac9c8 (cpufreq: Invoke __cpufreq_remove_dev_finish() after
releasing cpu_hotplug.lock) explains this in detail. Saravana, please take a
look at that reasoning and ensure that your patch doesn't re-introduce those
deadlock possibilities!

>>                         break;
>>                 }
>>         }
> 
> I am still not sure if everything will work as expected as I seriously doubt
> my reviewing capabilities. There might be corner cases which I am still
> missing.
> 

Regards,
Srivatsa S. Bhat
