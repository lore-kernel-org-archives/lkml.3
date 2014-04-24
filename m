Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaDXHac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:30:32 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:46973 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaDXHa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:30:28 -0400
MIME-Version: 1.0
In-Reply-To: <5357DBA5.1010106@arm.com>
References: <1397209481-28542-1-git-send-email-vincent.guittot@linaro.org>
 <1397209481-28542-6-git-send-email-vincent.guittot@linaro.org>
 <5357A802.1030804@arm.com> <CAKfTPtDnw-OZZekdE3oNGS11m6dfpS4veMNZ_Bezs-Lm7zn6QQ@mail.gmail.com>
 <5357DBA5.1010106@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 24 Apr 2014 09:30:07 +0200
Message-ID: <CAKfTPtAOZqnP=sWeJuqFAqrGT8vLQZKj+tpqiwOTG37paXoGjg@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] sched: ARM: create a dedicated scheduler topology table
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 April 2014 17:26, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> On 23/04/14 15:46, Vincent Guittot wrote:
>> On 23 April 2014 13:46, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>>> Hi,
>>>

[snip]

>> You  have an inconsistency in your topology description:
>
> That's true functional-wise but I think that this is not the reason why
> the code in get_group()/build_sched_groups() isn't working correctly any
> more with this set-up.
>
> Like I said above the cpu_cpupower_flags() is just bogus and I only
> added it to illustrate the issue (Shouldn't have used
> SD_SHARE_POWERDOMAIN in the first place).

More than the flag that is used for the example, it's about the
cpumask which are inconsistent across CPUs for the same level and the
build_sched_domain sequence rely on this consistency to build
sched_group

> Essentially what I want to do is bind an SD_SHARE_*FOO* flag to the GDIE
> related sd's of CPU2/3/4 and not to the DIE related sd's of CPU0/1.
>
> I thought so far that I can achieve that by getting rid of GDIE sd level
> for CPU0/1 simply by choosing the cpu_foo_mask() function in such a way
> that it returns the same cpu mask as its child sd level (MC) and of DIE
> sd level for CPU2/3/4 because it returns the same cpu mask as its child
> sd level (GDIE) related cpu mask function. This will let sd degenerate
> do it's job of folding sd levels which it does. The only problem I have
> is that the groups are not created correctly any more.
>
> I don't see right now how the flag SD_SHARE_FOO affects the code in
> get_group()/build_sched_groups().
>
> Think of SD_SHARE_FOO of something I would like to have for all sd's of
> CPU's of cluster 1 (CPU2/3/4) and not on cluster 0 (CPU0/1) in the sd
> level where each CPU sees two groups (group0 containing CPU0/1 and
> group1 containing CPU2/3/4 or vice versa) (GDIE/DIE) .

I'm not sure that's it's feasible because it's not possible from a
topology pov to have different flags if the span include all cpus.
Could you give us more details about what you want to achieve with
this flag ?

Vincent

>
> -- Dietmar
>
>>
>> At GDIE level:
>> CPU1 cpu_cpupower_mask=0-1
>> but
>> CPU2 cpu_cpupower_mask=0-4
>>
>> so CPU2 says that it shares power domain with CPU0 but CPU1 says the opposite
>>
>> Regards
>> Vincent
>>
>>>
>>> Firstly, I had to get rid of the cpumask_equal(cpu_map,
>>> sched_domain_span(sd)) condition in build_sched_domains() to allow that
>>> I can have two sd levels which span CPU 0-4 (for CPU2/3/4).
>>>
>>> But it still doesn't work correctly:
>>>
>>> dmesg snippet 2:
>>>
>>> CPU0 attaching sched-domain:
>>>  domain 0: span 0-1 level MC
>>>   groups: 0 1
>>>   domain 1: span 0-4 level DIE     <-- error (there's only one group)
>>>    groups: 0-4 (cpu_power = 2048)
>>> ...
>>> CPU2 attaching sched-domain:
>>>  domain 0: span 2-4 level MC
>>>   groups: 2 3 4
>>>   domain 1: span 0-4 level GDIE
>>> ERROR: domain->groups does not contain CPU2
>>>    groups:
>>> ERROR: domain->cpu_power not set
>>>
>>> ERROR: groups don't span domain->span
>>> ...
>>>

[snip]

>>>>
>>>
>>>
>>
>
>
