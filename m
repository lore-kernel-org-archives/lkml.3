Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbaIOEQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 00:16:58 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59009 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaIOEQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 00:16:57 -0400
Message-ID: <5416682F.6020304@linux.vnet.ibm.com>
Date: Mon, 15 Sep 2014 09:46:47 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [QUERY] Confusing usage of rq->nr_running in load balancing
References: <540707D9.4040208@linux.vnet.ibm.com> <CAKfTPtD7rzOONDeBL7ZBXQMkX_fh2wwOeLt6bA7rTQVzUVwjKw@mail.gmail.com>
In-Reply-To: <CAKfTPtD7rzOONDeBL7ZBXQMkX_fh2wwOeLt6bA7rTQVzUVwjKw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091504-3532-0000-0000-0000049FC578
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, Vincent,

On 09/03/2014 10:28 PM, Vincent Guittot wrote:
> On 3 September 2014 14:21, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> Hi,
> 
> Hi Preeti,
> 
>>
>> There are places in kernel/sched/fair.c in the load balancing part where
>> rq->nr_running is used as against cfs_rq->nr_running. At least I could
>> not make out why the former was used in the following scenarios.
>> It looks to me that it can very well lead to incorrect load balancing.
>> Also I did not pay attention to the numa balancing part of the code
>> while skimming through this file to catch this scenario. There are a
>> couple of places there too which need to be scrutinized.
>>
>> 1. load_balance(): The check (busiest->nr_running > 1)
>> The load balancing would be futile if there are tasks of other
>> scheduling classes, wouldn't it?
> 
> agree with you
> 
>>
>> 2. active_load_balance_cpu_stop(): A similar check and a similar
>> consequence as 1 here.
> 
> agree with you
> 
>>
>> 3. nohz_kick_needed() : We check for more than one task on the runqueue
>> and hence trigger load balancing even if there are rt-tasks.
> 
> I can see one potentiel reason why rq->nr_running is interesting that
> is the group capacity might have changed because of non cfs tasks
> since last load balance. So we need to monitor the change of the
> groups' capacity to ensure that the average load of each group is
> still in the same level

I tried a patch which changes nr_running to cfs.h_nr_running in the
above three scenarios and found that the performance of the workload
*drops significantly*. The workload that I ran was ebizzy with a few
threads running at rt priority and few running at normal priority and
running in parallel. This was tried on a 16 core SMT-8 machine. The drop
in the performance was around 18% with the patch across different number
of threads.

I figured that it was because if we consider only cfs.h_nr_running in
the above cases, we reduce load balancing attempts even when the
capacity of the cpus to run fair tasks is significantly reduced. For
example if the cpu is running two rt tasks and one fair task, we skip
load balancing altogether with the patch. Besides this, we may end up
doing active load balancing too often.

So I think we are good with nr_running although that may mean
unnecessary load balancing attempts when only rt tasks are running on
the cpus. But evaluating on nr_running in the above three scenarios
when there is a mix of rt and fair tasks is better so as to see if the
cpus have enough capacity to handle the one fair task that they can
possibly be running (If there are more fair tasks, we load balance anyway).

As for the usage of nr_running in find_busiest_queue(), we are good
there as Vincent pointed out as below.

"
>
> 8. find_busiest_queue(): This anomaly shows up when we filter against
> rq->nr_running == 1 and imbalance cannot be taken care of by the
> existing task on this rq.

agree with you even if the test with wl should prevent wrong decision
as a wl will be null if no cfs task are present

"

So the only changes we require around this is the change of nr_running
to cfs.h_nr_running in update_sg_lb_stats() and cpu_avg_load_per_task()
which is being done by Vincent already in the consolidation of
cpu_capacity patches and I did not see regressions there during my tests.

Thanks

Regards
Preeti U Murthy

