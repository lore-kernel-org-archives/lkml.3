Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaJHREM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 13:04:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36807 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbaJHREH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 13:04:07 -0400
Message-ID: <54356E91.10804@arm.com>
Date: Wed, 08 Oct 2014 18:04:17 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>
Subject: Re: [PATCH v7 3/7] sched: add utilization_avg_contrib
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org> <1412684017-16595-4-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1412684017-16595-4-git-send-email-vincent.guittot@linaro.org>
X-OriginalArrivalTime: 08 Oct 2014 17:04:03.0086 (UTC) FILETIME=[DC8BA2E0:01CFE319]
X-MC-Unique: 114100818040403801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/14 13:13, Vincent Guittot wrote:
> Add new statistics which reflect the average time a task is running on the CPU
> and the sum of these running time of the tasks on a runqueue. The latter is
> named utilization_avg_contrib.
> 
> This patch is based on the usage metric that was proposed in the 1st
> versions of the per-entity load tracking patchset by Paul Turner
> <pjt@google.com> but that has be removed afterward. This version differs
> from the original one in the sense that it's not linked to task_group.
> 
> The rq's utilization_avg_contrib will be used to check if a rq is overloaded
> or not instead of trying to compute how many task a group of CPUs can handle
> 
> Rename runnable_avg_period into avg_period as it is now used with both
> runnable_avg_sum and running_avg_sum
> 
> Add some descriptions of the variables to explain their differences
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  include/linux/sched.h | 21 +++++++++++++---
>  kernel/sched/debug.c  |  9 ++++---
>  kernel/sched/fair.c   | 70 +++++++++++++++++++++++++++++++++++++++------------
>  kernel/sched/sched.h  |  8 +++++-
>  4 files changed, 84 insertions(+), 24 deletions(-)
> 

[...]

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 9075dee..d6de526 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -678,8 +678,8 @@ void init_task_runnable_average(struct task_struct *p)
> 
>         p->se.avg.decay_count = 0;
>         slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
> -       p->se.avg.runnable_avg_sum = slice;
> -       p->se.avg.runnable_avg_period = slice;
> +       p->se.avg.runnable_avg_sum = p->se.avg.running_avg_sum = slice;
> +       p->se.avg.avg_period = slice;
>         __update_task_entity_contrib(&p->se);

Didn't you miss a call to __update_task_entity_utilization here?

Another thing from the naming perspective: You use the term
'utilization' for 'load' (e.g. existing __update_entity_load_avg_contrib
versus new __update_entity_utilization_avg_contrib) but for the
__update_task_entity_contrib function, you use the term 'utilization'
for 'contrib'. IMHO, kind of hard to grasp.

>  }
>  #else
> @@ -1548,7 +1548,7 @@ static u64 numa_get_avg_runtime(struct task_struct *p, u64 *period)
>                 *period = now - p->last_task_numa_placement;
>         } else {
>                 delta = p->se.avg.runnable_avg_sum;
> -               *period = p->se.avg.runnable_avg_period;
> +               *period = p->se.avg.avg_period;
>         }
> 
>         p->last_sum_exec_runtime = runtime;


