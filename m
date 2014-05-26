Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaEZPy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:54:59 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:39907 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbaEZPy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:54:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAKfTPtA4mvor+NOrA6=WdaLenNUiUo3uRHamQP6r7wc84TLcHQ@mail.gmail.com>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <53830D09.4010209@linux.vnet.ibm.com> <CAKfTPtA4mvor+NOrA6=WdaLenNUiUo3uRHamQP6r7wc84TLcHQ@mail.gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 26 May 2014 17:54:37 +0200
Message-ID: <CAKfTPtDZKmnWfSsmBJY5RrnP_9bE-7dX_yhU5mZSuahUfiQ5rQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] sched: consolidation of cpu_power
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Preeti,

I have done ebizzy tests on my platforms but doesn't have similar
results than you (my results below). It seems to be linked to SMT. I'm
going to look at that part more deeply and try to find a more suitable
HW for tests.

ebizzy -t N -S 20
Quad cores
 N  tip                 +patchset
 1  100.00% (+/- 0.30%)  97.00% (+/- 0.42%)
 2  100.00% (+/- 0.80%) 100.48% (+/- 0.88%)
 4  100.00% (+/- 1.18%)  99.32% (+/- 1.05%)
 6  100.00% (+/- 8.54%)  98.84% (+/- 1.39%)
 8  100.00% (+/- 0.45%)  98.89% (+/- 0.91%)
10  100.00% (+/- 0.32%)  99.25% (+/- 0.31%)
12  100.00% (+/- 0.15%)  99.20% (+/- 0.86%)
14  100.00% (+/- 0.58%)  99.44% (+/- 0.55%)

Dual cores
 N  tip                 +patchset
 1  100.00% (+/- 1.70%)  99.35% (+/- 2.82%)
 2  100.00% (+/- 2.75%) 100.48% (+/- 1.51%)
 4  100.00% (+/- 2.37%) 102.63% (+/- 2.35%)
 6  100.00% (+/- 3.11%)  97.65% (+/- 1.02%)
 8  100.00% (+/- 0.26%) 103.68% (+/- 5.90%)
10  100.00% (+/- 0.30%) 106.71% (+/- 10.85%)
12  100.00% (+/- 1.18%)  98.95% (+/- 0.75%)
14  100.00% (+/- 1.82%) 102.89% (+/- 2.32%)

Regards,
Vincent

On 26 May 2014 12:04, Vincent Guittot <vincent.guittot@linaro.org> wrote:
> On 26 May 2014 11:44, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> Hi Vincent,
>>
>> I conducted test runs of ebizzy on a Power8 box which had 48 cpus.
>> 6 cores with SMT-8 to be precise. Its a single socket box. The results
>> are as below.
>>
>> On 05/23/2014 09:22 PM, Vincent Guittot wrote:
>>> Part of this patchset was previously part of the larger tasks packing patchset
>>> [1]. I have splitted the latter in 3 different patchsets (at least) to make the
>>> thing easier.
>>> -configuration of sched_domain topology [2]
>>> -update and consolidation of cpu_power (this patchset)
>>> -tasks packing algorithm
>>>
>>> SMT system is no more the only system that can have a CPUs with an original
>>> capacity that is different from the default value. We need to extend the use of
>>> cpu_power_orig to all kind of platform so the scheduler will have both the
>>> maximum capacity (cpu_power_orig/power_orig) and the current capacity
>>> (cpu_power/power) of CPUs and sched_groups. A new function arch_scale_cpu_power
>>> has been created and replace arch_scale_smt_power, which is SMT specifc in the
>>> computation of the capapcity of a CPU.
>>>
>>> During load balance, the scheduler evaluates the number of tasks that a group
>>> of CPUs can handle. The current method assumes that tasks have a fix load of
>>> SCHED_LOAD_SCALE and CPUs have a default capacity of SCHED_POWER_SCALE.
>>> This assumption generates wrong decision by creating ghost cores and by
>>> removing real ones when the original capacity of CPUs is different from the
>>> default SCHED_POWER_SCALE.
>>>
>>> Now that we have the original capacity of a CPUS and its activity/utilization,
>>> we can evaluate more accuratly the capacity of a group of CPUs.
>>>
>>> This patchset mainly replaces the old capacity method by a new one and has kept
>>> the policy almost unchanged whereas we can certainly take advantage of this new
>>> statistic in several other places of the load balance.
>>>
>>> TODO:
>>>  - align variable's and field's name with the renaming [3]
>>>
>>> Tests results:
>>> I have put below results of 2 tests:
>>> - hackbench -l 500 -s 4096
>>> - scp of 100MB file on the platform
>>>
>>> on a dual cortex-A7
>>>                   hackbench        scp
>>> tip/master        25.75s(+/-0.25)  5.16MB/s(+/-1.49)
>>> + patches 1,2     25.89s(+/-0.31)  5.18MB/s(+/-1.45)
>>> + patches 3-10    25.68s(+/-0.22)  7.00MB/s(+/-1.88)
>>> + irq accounting  25.80s(+/-0.25)  8.06MB/s(+/-0.05)
>>>
>>> on a quad cortex-A15
>>>                   hackbench        scp
>>> tip/master        15.69s(+/-0.16)  9.70MB/s(+/-0.04)
>>> + patches 1,2     15.53s(+/-0.13)  9.72MB/s(+/-0.05)
>>> + patches 3-10    15.56s(+/-0.22)  9.88MB/s(+/-0.05)
>>> + irq accounting  15.99s(+/-0.08) 10.37MB/s(+/-0.03)
>>>
>>> The improvement of scp bandwidth happens when tasks and irq are using
>>> different CPU which is a bit random without irq accounting config
>>
>> N -> Number of threads of ebizzy
>>
>> Each 'N' run was for 30 seconds with multiple iterations and averaging them.
>>
>> N          %change in number of records
>>            read after patching
>> ------------------------------------------
>> 1          + 0.0038
>> 4          -17.6429
>> 8          -26.3989
>> 12         -29.5070
>> 16         -38.4842
>> 20         -44.5747
>> 24         -51.9792
>> 28         -34.1863
>> 32         -38.4029
>> 38         -22.2490
>> 42          -7.4843
>> 47         -0.69676
>>
>> Let me profile it and check where the cause of this degradation is.
>
> Hi Preeti,
>
> Thanks for the test and the help to find the root cause of the
> degration. I'm going to run the test on my platforms too and see if i
> have similar results with my platforms
>
> Regards
> Vincent
>>
>>
>> Regards
>> Preeti U Murthy
>>
