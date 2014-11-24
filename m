Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaKXI1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 03:27:12 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65111 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685AbaKXI1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 03:27:11 -0500
MIME-Version: 1.0
In-Reply-To: <547128D8.6040500@gmail.com>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-6-git-send-email-vincent.guittot@linaro.org>
 <20141002165745.GA28662@e103034-lin> <CAKfTPtA5XTwT0fTqXZJWWwfUQ8SfVxiqmQwSWqFKpbb1XpriRw@mail.gmail.com>
 <20141003093546.GB28662@e103034-lin> <CAKfTPtAA1thOXR7tRzMQrnyzuoEysqwmBP_mQ+RSh1yOAG7Jpg@mail.gmail.com>
 <547128D8.6040500@gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 24 Nov 2014 09:26:49 +0100
Message-ID: <CAKfTPtAwgOA0kutv7W5ZPGyzQo8vkrA=OjRz3qd0pM=62k4F+Q@mail.gmail.com>
Subject: Re: [PATCH v6 5/6] sched: replace capacity_factor by usage
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 November 2014 at 01:22, Wanpeng Li <kernellwp@gmail.com> wrote:
> Hi Vincent,
>
> On 10/3/14, 8:50 PM, Vincent Guittot wrote:
>>
>> On 3 October 2014 11:35, Morten Rasmussen <morten.rasmussen@arm.com>
>> wrote:
>>>
>>> On Fri, Oct 03, 2014 at 08:24:23AM +0100, Vincent Guittot wrote:
>>>>
>>>> On 2 October 2014 18:57, Morten Rasmussen <morten.rasmussen@arm.com>
>>>> wrote:
>>>>>
>>>>> On Tue, Sep 23, 2014 at 05:08:04PM +0100, Vincent Guittot wrote:
>>>>>>
>>>>>> Below are two examples to illustrate the problem that this patch
>>>>>> solves:
>>>>>>
>>>>>> 1 - capacity_factor makes the assumption that max capacity of a CPU is
>>>>>> SCHED_CAPACITY_SCALE and the load of a thread is always is
>>>>>> SCHED_LOAD_SCALE. It compares the output of these figures with the sum
>>>>>> of nr_running to decide if a group is overloaded or not.
>>>>>>
>>>>>> But if the default capacity of a CPU is less than SCHED_CAPACITY_SCALE
>>>>>> (640 as an example), a group of 3 CPUS will have a max capacity_factor
>>>>>> of 2 ( div_round_closest(3x640/1024) = 2) which means that it will be
>>>>>> seen as overloaded if we have only one task per CPU.
>>>>>
>>>>> I did some testing on TC2 which has the setup you describe above on the
>>>>> A7 cluster when the clock-frequency property is set in DT. The two A15s
>>>>> have max capacities above 1024. When using sysbench with five threads I
>>>>> still get three tasks on the two A15s and two tasks on the three A7
>>>>> leaving one cpu idle (on average).
>>>>>
>>>>> Using cpu utilization (usage) does correctly identify the A15 cluster
>>>>> as
>>>>> overloaded and it even gets as far as selecting the A15 running two
>>>>> tasks as the source cpu in load_balance(). However, load_balance()
>>>>> bails
>>>>> out without pulling the task due to calculate_imbalance() returning a
>>>>> zero imbalance. calculate_imbalance() bails out just before the hunk
>>>>> you
>>>>> changed due to comparison of the sched_group avg_loads. sgs->avg_load
>>>>> is
>>>>> basically the sum of load in the group divided by its capacity. Since
>>>>> load isn't scaled the avg_load of the overloaded A15 group is slightly
>>>>> _lower_ than the partially idle A7 group. Hence calculate_imbalance()
>>>>> bails out, which isn't what we want.
>>>>>
>>>>> I think we need to have a closer look at the imbalance calculation code
>>>>> and any other users of sgs->avg_load to get rid of all code making
>>>>> assumptions about cpu capacity.
>>>>
>>>> We already had this discussion during the review of a previous version
>>>> https://lkml.org/lkml/2014/6/3/422
>>>> and my answer has not changed; This patch is necessary to solve the 1
>>>> task per CPU issue of the HMP system but is not enough. I have a patch
>>>> for solving the imbalance calculation issue and i have planned to send
>>>> it once this patch will be in a good shape for being accepted by
>>>> Peter.
>>>>
>>>> I don't want to mix this patch and the next one because there are
>>>> addressing different problem: this one is how evaluate the capacity of
>>>> a system and detect when a group is overloaded and the next one will
>>>> handle the case when the balance of the system can't rely on the
>>>> average load figures of the group because we have a significant
>>>> capacity difference between groups. Not that i haven't specifically
>>>> mentioned HMP for the last patch because SMP system can also take
>>>> advantage of it
>>>
>>> You do mention 'big' and 'little' cores in your commit message and quote
>>> example numbers with are identical to the cpu capacities for TC2. That
>>
>> By last patch, i mean the patch about imbalance that i haven't sent
>> yet, but it's not related with this patch
>>
>>> lead me to believe that this patch would address the issues we see for
>>> HMP systems. But that is clearly wrong. I would suggest that you drop
>>
>> This patch addresses one issue: correctly detect how much capacity we
>> have and correctly detect when the group is overloaded; HMP system
>
>
> What's the meaning of "HMP system"?

Heterogeneous Multi Processor  system are system that gathers
processors with different micro architecture and/or different max
frequency. The main result is that processors don't have the same
maximum capacity and the same DMIPS/W efficiency

Regards,
Vincent
>
> Regards,
> Wanpeng Li
>
>> clearly falls in this category but not only.
>> This is the only purpose of this patch and not the "1 task per CPU
>> issue" that you mentioned.
>>
>> The second patch is about correctly balance the tasks on system where
>> the capacity of a group is significantly less than another group. It
>> has nothing to do in capacity computation and overload detection but
>> it will use these corrected/new metrics to make a better choice.
>>
>> Then, there is the "1 task per CPU issue on HMP" that you mentioned
>> and this latter will be solved thanks to these 2 patchsets but this is
>> not the only/main target of these patchsets so i don't want to reduce
>> them into: "solve an HMP issue"
>>
>>> mentioning big and little cores and stick to only describing cpu
>>> capacity reductions due to rt tasks and irq to avoid any confusion about
>>> the purpose of the patch. Maybe explicitly say that non-default cpu
>>> capacities (capacity_orig) isn't addressed yet.
>>
>> But they are addressed by this patchset. you just mixed various goal
>> together (see above)
>>
>>> I think the two problems you describe are very much related. This patch
>>> set is half the solution of the HMP balancing problem. We just need the
>>> last bit for avg_load and then we can add scale-invariance on top.
>>
>> i don't see the link between scale invariance and a bad load-balancing
>> choice. The fact that the current load balancer puts more tasks than
>> CPUs in a group on HMP system should not influence or break the scale
>> invariance load tracking. Isn't it ?
>>
>> Now, i could send the other patchset but i'm afraid that this will
>> generate more confusion than help in the process review.
>>
>> Regards,
>> Vincent
>>
>>> IMHO, it would be good to have all the bits and pieces for cpu capacity
>>> scaling and scaling of per-entity load-tracking on the table so we fit
>>> things together. We only have patches for parts of the solution posted
>>> so far.
>>>
>>> Morten
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
