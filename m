Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbaICQ6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:58:37 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:59503 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743AbaICQ6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:58:35 -0400
MIME-Version: 1.0
In-Reply-To: <540707D9.4040208@linux.vnet.ibm.com>
References: <540707D9.4040208@linux.vnet.ibm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 3 Sep 2014 18:58:14 +0200
Message-ID: <CAKfTPtD7rzOONDeBL7ZBXQMkX_fh2wwOeLt6bA7rTQVzUVwjKw@mail.gmail.com>
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

On 3 September 2014 14:21, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> Hi,

Hi Preeti,

>
> There are places in kernel/sched/fair.c in the load balancing part where
> rq->nr_running is used as against cfs_rq->nr_running. At least I could
> not make out why the former was used in the following scenarios.
> It looks to me that it can very well lead to incorrect load balancing.
> Also I did not pay attention to the numa balancing part of the code
> while skimming through this file to catch this scenario. There are a
> couple of places there too which need to be scrutinized.
>
> 1. load_balance(): The check (busiest->nr_running > 1)
> The load balancing would be futile if there are tasks of other
> scheduling classes, wouldn't it?

agree with you

>
> 2. active_load_balance_cpu_stop(): A similar check and a similar
> consequence as 1 here.

agree with you

>
> 3. nohz_kick_needed() : We check for more than one task on the runqueue
> and hence trigger load balancing even if there are rt-tasks.

I can see one potentiel reason why rq->nr_running is interesting that
is the group capacity might have changed because of non cfs tasks
since last load balance. So we need to monitor the change of the
groups' capacity to ensure that the average load of each group is
still in the same level

>
> 4. cpu_avg_load_per_task(): This stands out among the rest as an
> incorrect usage of rq->nr_running in place of cfs_rq->nr_running. We
> divide the load associated with the cfs_rq by the number of tasks on the
> rq. This will make the cfs_rq load look smaller.

This one is solved in the consolidation of cpu_capacity patchset

>
> 5. task_hot() : I am not too sure about the consequences of using
> rq->nr_running here.

IIUC, the goal is to check if other tasks are running on the dst_rq so
rq->nr_running is the good one

>
> 6. update_sg_lb_stats(): sgs->sum_nr_running is the sum of
> rq->nr_running and propogates thus throughout the load balancing code path.

This one is solved in the consolidation of cpu_capacity patchset
>
> 7. sg_capacity_factor(): Returns the capacity factor measured against
> the cpu capacity available to fair tasks. We then compare this with the
> rq->nr_running in update_sg_lb_stats(), update_sd_pick_busiest() and
> calculate_imbalance()

This one is removed with the consolidation of cpu_capacity patchset

>
> 8. find_busiest_queue(): This anomaly shows up when we filter against
> rq->nr_running == 1 and imbalance cannot be taken care of by the
> existing task on this rq.

agree with you even if the test with wl should prevent wrong decision
as a wl will be null if no cfs task are present

Regards
Vincent
>
> Did I miss something or is it true that the usage of rq->nr_running in
> the above places is incorrect?
>
> Thanks
>
> Regards
> Preeti U Murthy
>
