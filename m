Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaHMJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:58:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaHMJ6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:58:24 -0400
Message-ID: <53EB36BA.7050302@redhat.com>
Date: Wed, 13 Aug 2014 05:58:18 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
References: <53DB6B81.6050400@redhat.com> <53DBCBE8.6010809@codeaurora.org> <53DBE764.8050109@redhat.com> <53DBEC27.7050803@codeaurora.org> <CAKohpombG3Gj4mbm02vPNnAxzaRvQP7rb=iQ14dCFH4_+71H3w@mail.gmail.com> <53E0B657.4070007@redhat.com> <CAKohponxBdYEgY2oYuzmdaqfSRS8Uq8bZOzcb1QDmKO-z5ZBFQ@mail.gmail.com> <53E1556B.5070304@codeaurora.org> <CAKohpoky1-hj7cwnKc58svh8Z1Yas1=q4uJEK8mWcb56uqAcng@mail.gmail.com> <53E1FEE5.80305@redhat.com> <20140806150831.GB32301@codeaurora.org> <CAKohponBRn9mwpPMinsjqpHe3wTFj6aNpYk5gZaWDKht3bd5NQ@mail.gmail.com> <53E35122.3040806@redhat.com> <CAKohpokLsqMMxMwh_p+kUL=He9-8cSws6onG6DCBNBVzz1=5TA@mail.gmail.com> <CAKohpokebTdX-Ssdc4N+b09tZ35qkckiErypc0c0Nbe7v+Y5uQ@mail.gmail.com> <53E9FBA4.2080609@redhat.com> <CAKohponqFj5jSpvYbMD5d5zgCJAjCYkNg=_L+BKeMEDmBEWbyg@mail.gmail.com>
In-Reply-To: <CAKohponqFj5jSpvYbMD5d5zgCJAjCYkNg=_L+BKeMEDmBEWbyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/13/2014 03:39 AM, Viresh Kumar wrote:
> On 12 August 2014 17:03, Prarit Bhargava <prarit@redhat.com> wrote:
>> Okay, this is what I have and I can reproduce this *easily* 100% of the time.
>>
>> I've used your above config options and have enabled LOCKDEP.
>>
>> In order to restore the locking, I've applied the following patch to the cpufreq
>> core (sorry for the cut-and-paste):
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index d9fdedd..dfda238 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -2192,9 +2192,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *polic
>>         /* end old governor */
>>         if (old_gov) {
>>                 __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>> -               up_write(&policy->rwsem);
>>                 __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
>> -               down_write(&policy->rwsem);
>>         }
>>
>>         /* start new governor */
>> @@ -2203,9 +2201,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *polic
>>                 if (!__cpufreq_governor(policy, CPUFREQ_GOV_START))
>>                         goto out;
>>
>> -               up_write(&policy->rwsem);
>>                 __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
>> -               down_write(&policy->rwsem);
>>         }
>>
>>         /* new governor failed, so re-start old one */
>>
>>
>> I've modified the acpi-cpufreq driver to include (sorry for the cut-and-paste)
>>
>> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
>> index b0c18ed..97653c3 100644
>> --- a/drivers/cpufreq/acpi-cpufreq.c
>> +++ b/drivers/cpufreq/acpi-cpufreq.c
>> @@ -884,6 +884,9 @@ static struct freq_attr *acpi_cpufreq_attr[] = {
>>  };
>>
>>  static struct cpufreq_driver acpi_cpufreq_driver = {
>> +       .flags                  = CPUFREQ_STICKY |
>> +                                       CPUFREQ_HAVE_GOVERNOR_PER_POLICY |
>> +                                       CPUFREQ_NEED_INITIAL_FREQ_CHECK,
>>         .verify         = cpufreq_generic_frequency_table_verify,
>>         .target_index   = acpi_cpufreq_target,
>>         .bios_limit     = acpi_processor_get_bios_limit,
>>
>> I do a
>>
>> cat /sys/devices/system/cpu/cpu2/cpufreq/conservative/*
>> echo ondemand > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
>>
>> and then I immediately see the stack trace.
> 
> What's your system configuration? How many clusters/cpus/etc..

Anywhere from 2-4 sockets, 8 - 240 cpus (depending on # of sockets), x86 arch.

P.
> 
