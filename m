Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaHEWU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 18:20:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbaHEWUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 18:20:55 -0400
Message-ID: <53E158C1.6010701@redhat.com>
Date: Tue, 05 Aug 2014 18:20:49 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
References: <1406634362-811-1-git-send-email-prarit@redhat.com> <2066166.pXm4lKLOID@vostro.rjw.lan> <53DA8389.80804@redhat.com> <1917362.abr2Y4p7vh@vostro.rjw.lan> <53DA8A41.2030601@redhat.com> <53DAA60B.6040802@codeaurora.org> <53DAA749.5080506@redhat.com> <53DAA95B.2040505@codeaurora.org> <53DAB038.3050007@redhat.com> <53DABFA6.6090503@codeaurora.org> <53DACA26.1000908@redhat.com> <53DAE592.2030909@codeaurora.org> <53DB6B81.6050400@redhat.com> <53DBCBE8.6010809@codeaurora.org> <53DBE764.8050109@redhat.com> <53DBEC27.7050803@codeaurora.org> <CAKohpombG3Gj4mbm02vPNnAxzaRvQP7rb=iQ14dCFH4_+71H3w@mail.gmail.com> <53E0B657.4070007@redhat.com> <CAKohponxBdYEgY2oYuzmdaqfSRS8Uq8bZOzcb1QDmKO-z5ZBFQ@mail.gmail.com> <53E1556B.5070304@codeaurora.org>
In-Reply-To: <53E1556B.5070304@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/05/2014 06:06 PM, Saravana Kannan wrote:
> On 08/05/2014 03:53 AM, Viresh Kumar wrote:
>> On 5 August 2014 16:17, Prarit Bhargava <prarit@redhat.com> wrote:
>>> Nope, not a stupid question.  After reproducing (finally!) yesterday I've been
>>> wondering the same thing.
>>
>> Good to know that :)
>>
>>> I've been looking into *exactly* this.  On any platform where
>>> cpu_weight(affected_cpus) == 1 for a particular cpu this lockdep trace should
>>> happen.
>>
>>> That's what I'm wondering too.  I'm going to instrument the code to find out
>>> this morning.  I'm wondering if this comes down to a lockdep class issue
>>> (perhaps lockdep puts globally defined locks like cpufreq_global_kobject in a
>>> different class?).
>>
>> Maybe, I tried this Hack to make this somewhat similar to the other case
>> on my platform with just two CPUs:
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 6f02485..6b4abac 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -98,7 +98,7 @@ static DEFINE_MUTEX(cpufreq_governor_mutex);
>>
>>   bool have_governor_per_policy(void)
>>   {
>> -       return !!(cpufreq_driver->flags & CPUFREQ_HAVE_GOVERNOR_PER_POLICY);
>> +       return !(cpufreq_driver->flags & CPUFREQ_HAVE_GOVERNOR_PER_POLICY);
>>   }
>>   EXPORT_SYMBOL_GPL(have_governor_per_policy);
>>
>>
>> This should result in something similar to setting that per-policy-governor
>> flag (Actually I could have done that too :)), and I couldn't see that crash :(
>>
>> That needs more investigation now, probably we can get some champ of
>> sysfs stuff like Tejun/Greg into discussion now..
> 
> Stephen and I looked into this. This is not a sysfs framework difference. The
> reason we don't have this issue when we use global tunables is because we add
> the attribute group to the cpufreq_global_kobject and that kobject doesn't have
> a kobj_type ops similar to the per policy kobject. So, read/write to those
> attributes do NOT go through the generic show/store ops that wrap every other
> cpufreq framework attribute read/writes.
> 
> So, none of those read/write do any kind of locking. They don't race with
> POLICY_EXIT (because we remove the sysfs group first thing in POLICY_EXIT) but
> might still race with START/STOPs (not sure, haven't looked closely yet).
> 
> For example, writing to sampling_rate of ondemand governor might cause a race in
> update_sampling_rate(). It could race and happen between a STOP and POLICY_EXIT
> (triggered by hotplug, gov change, etc).
> 
> So, this might be a completely separate bug that needs fixing when we don't use
> per policy govs.

Yeah, the show_one & store_one macros don't have any locking in them :/.

Okay ... at least that isn't the issue.  I spent 1/2 the day trying to figure
out why

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index fa11a7d..6297c76 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -745,12 +745,14 @@ static struct attribute *default_attrs[] = {
 #define to_policy(k) container_of(k, struct cpufreq_policy, kobj)
 #define to_attr(a) container_of(a, struct freq_attr, attr)

+/* PRARIT - in the CPUFREQ_HAVE_GOVERNOR_PER_POLICY, this is used */
 static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
 {
        struct cpufreq_policy *policy = to_policy(kobj);
        struct freq_attr *fattr = to_attr(attr);
        ssize_t ret;

+       printk("%s: kobject %p\n", __FUNCTION__, kobj);
        if (!down_read_trylock(&cpufreq_rwsem))
                return -EINVAL;

wasn't printing the kobject line when acpi-cpufreq didn't have the
CPUFREQ_HAVE_GOVERNOR_PER_POLICY flag.  And I agree ... it is a bug.

P.
