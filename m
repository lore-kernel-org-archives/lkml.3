Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaKCKz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:55:59 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:40414 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaKCKz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:55:56 -0500
MIME-Version: 1.0
In-Reply-To: <5456E48C.6020800@gmail.com>
References: <1414745252-4895-1-git-send-email-vincent.guittot@linaro.org> <5456E48C.6020800@gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 3 Nov 2014 11:55:34 +0100
Message-ID: <CAKfTPtDmyUBaUQ210w36fuao9iKRGP41MqSRxhhy_3O6k4UNrg@mail.gmail.com>
Subject: Re: [PATCH v8 00/10] sched: consolidation of CPU capacity and usage
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 November 2014 03:12, Wanpeng Li <kernellwp@gmail.com> wrote:
> Hi Vincent,
> On 14/10/31 下午4:47, Vincent Guittot wrote:
>>
>> This patchset consolidates several changes in the capacity and the usage
>> tracking of the CPU. It provides a frequency invariant metric of the usage
>> of
>> CPUs and generally improves the accuracy of load/usage tracking in the
>> scheduler. The frequency invariant metric is the foundation required for
>> the
>> consolidation of cpufreq and implementation of a fully invariant load
>> tracking.
>> These are currently WIP and require several changes to the load balancer
>> (including how it will use and interprets load and capacity metrics) and
>> extensive validation. The frequency invariance is done with
>> arch_scale_freq_capacity and this patchset doesn't provide the backends of
>> the function which are architecture dependent.
>>
>> As discussed at LPC14, Morten and I have consolidated our changes into a
>> single
>> patchset to make it easier to review and merge.
>>
>> During load balance, the scheduler evaluates the number of tasks that a
>> group
>> of CPUs can handle. The current method assumes that tasks have a fix load
>> of
>> SCHED_LOAD_SCALE and CPUs have a default capacity of SCHED_CAPACITY_SCALE.
>> This assumption generates wrong decision by creating ghost cores or by
>
>
> I don't know the history, could you explain what's the meaning of 'ghost
> cores' ?

The capacity_factor gives the number of tasks that can be handled by a
group of CPUs by dividing the group's capacity by SCHED_CAPACITY_SCALE

For a system with SMT, the default capacity of a core is 1178 so the
capacity of each CPU for a dual threads per core is 589.

At CPU level we have a capacity_factor of 1  = div_round_closest(589, 1024)
At core level we still have a capacity_factor of 1  =
div_round_closest(1178, 1024).  This is a intended behavior to promote
1 task per core
Then, if we have 4 cores in a node, the capacity_factor is 5 =
div_round_closest(4712, 1024) whereas we should have 4. So a 5th ghost
core has appeared in the group and the load balancer will not
considered the group as overloaded if there is 5 tasks whereas it
should in order to try to move this 5th task on an idle core (if there
is one)
Patch [0] solves some use cases by ensuring that we will not have more
cores than possible so we can't have more than 4 core for the previous
example.
Now, if some RT tasks are running and using almost 1 core (1024 as an
example), the capacity_factor is still 4 = div_round_closest(3688,
1024) whereas a core is nearly fully used and the capacity_factor
should be 3

[0] https://lkml.org/lkml/2013/8/28/194

Regards,
Vincent

>
> Regards,
> Wanpeng Li
>
>
>> removing real ones when the original capacity of CPUs is different from
>> the
>> default SCHED_CAPACITY_SCALE. With this patch set, we don't try anymore to
>> evaluate the number of available cores based on the group_capacity but
>> instead
>> we evaluate the usage of a group and compare it with its capacity.
>>
>> This patchset mainly replaces the old capacity_factor method by a new one
>> and
>> keeps the general policy almost unchanged. These new metrics will be also
>> used
>> in later patches.
>>

[snip]
