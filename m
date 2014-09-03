Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbaICMWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:22:10 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52968 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaICMWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:22:06 -0400
Message-ID: <540707D9.4040208@linux.vnet.ibm.com>
Date: Wed, 03 Sep 2014 17:51:45 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>
CC: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [QUERY] Confusing usage of rq->nr_running in load balancing
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090312-0928-0000-0000-000004884682
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are places in kernel/sched/fair.c in the load balancing part where
rq->nr_running is used as against cfs_rq->nr_running. At least I could
not make out why the former was used in the following scenarios.
It looks to me that it can very well lead to incorrect load balancing.
Also I did not pay attention to the numa balancing part of the code
while skimming through this file to catch this scenario. There are a
couple of places there too which need to be scrutinized.

1. load_balance(): The check (busiest->nr_running > 1)
The load balancing would be futile if there are tasks of other
scheduling classes, wouldn't it?

2. active_load_balance_cpu_stop(): A similar check and a similar
consequence as 1 here.

3. nohz_kick_needed() : We check for more than one task on the runqueue
and hence trigger load balancing even if there are rt-tasks.

4. cpu_avg_load_per_task(): This stands out among the rest as an
incorrect usage of rq->nr_running in place of cfs_rq->nr_running. We
divide the load associated with the cfs_rq by the number of tasks on the
rq. This will make the cfs_rq load look smaller.

5. task_hot() : I am not too sure about the consequences of using
rq->nr_running here.

6. update_sg_lb_stats(): sgs->sum_nr_running is the sum of
rq->nr_running and propogates thus throughout the load balancing code path.

7. sg_capacity_factor(): Returns the capacity factor measured against
the cpu capacity available to fair tasks. We then compare this with the
rq->nr_running in update_sg_lb_stats(), update_sd_pick_busiest() and
calculate_imbalance()

8. find_busiest_queue(): This anomaly shows up when we filter against
rq->nr_running == 1 and imbalance cannot be taken care of by the
existing task on this rq.

Did I miss something or is it true that the usage of rq->nr_running in
the above places is incorrect?

Thanks

Regards
Preeti U Murthy

