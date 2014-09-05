Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbaIEM2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:28:04 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:39939 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaIEM2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:28:02 -0400
MIME-Version: 1.0
In-Reply-To: <5409AA64.2010700@linux.vnet.ibm.com>
References: <540707D9.4040208@linux.vnet.ibm.com> <CAKfTPtD7rzOONDeBL7ZBXQMkX_fh2wwOeLt6bA7rTQVzUVwjKw@mail.gmail.com>
 <5409AA64.2010700@linux.vnet.ibm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 5 Sep 2014 14:27:36 +0200
Message-ID: <CAKfTPtDYXeCnYgR0yU2Ed-XBP9ezfk-j1gCgEyiReyQjD5hC6Q@mail.gmail.com>
Subject: Re: [QUERY] Confusing usage of rq->nr_running in load balancing
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 September 2014 14:19, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> Hi Vincent,
>
> On 09/03/2014 10:28 PM, Vincent Guittot wrote:
>> On 3 September 2014 14:21, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>>> Hi,
>>
>> Hi Preeti,
>>
>>>
>>> There are places in kernel/sched/fair.c in the load balancing part where
>>> rq->nr_running is used as against cfs_rq->nr_running. At least I could
>>> not make out why the former was used in the following scenarios.
>>> It looks to me that it can very well lead to incorrect load balancing.
>>> Also I did not pay attention to the numa balancing part of the code
>>> while skimming through this file to catch this scenario. There are a
>>> couple of places there too which need to be scrutinized.
>>>
>>> 1. load_balance(): The check (busiest->nr_running > 1)
>>> The load balancing would be futile if there are tasks of other
>>> scheduling classes, wouldn't it?
>>
>> agree with you
>>
>>>
>>> 2. active_load_balance_cpu_stop(): A similar check and a similar
>>> consequence as 1 here.
>>
>> agree with you
>>
>>>
>>> 3. nohz_kick_needed() : We check for more than one task on the runqueue
>>> and hence trigger load balancing even if there are rt-tasks.
>>
>> I can see one potentiel reason why rq->nr_running is interesting that
>> is the group capacity might have changed because of non cfs tasks
>> since last load balance. So we need to monitor the change of the
>> groups' capacity to ensure that the average load of each group is
>> still in the same level
>>
>>>
>>> 4. cpu_avg_load_per_task(): This stands out among the rest as an
>>> incorrect usage of rq->nr_running in place of cfs_rq->nr_running. We
>>> divide the load associated with the cfs_rq by the number of tasks on the
>>> rq. This will make the cfs_rq load look smaller.
>>
>> This one is solved in the consolidation of cpu_capacity patchset
>
> Sorry, but I don't see where in your patchset you have addressed this
> issue. Can you please point out the patch?

In [PATCH v5 03/12] sched: fix avg_load computation:

static unsigned long cpu_avg_load_per_task(int cpu)
 {
        struct rq *rq = cpu_rq(cpu);
-       unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
+       unsigned long nr_running = ACCESS_ONCE(rq->cfs.h_nr_running);
        unsigned long load_avg = rq->cfs.runnable_load_avg;

Are you referring to another problem than the one above ?

Regards
Vincent

>
> Regards
> Preeti U Murthy
>
