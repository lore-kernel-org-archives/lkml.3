Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaLQIWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:22:53 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:43113 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaLQIWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:22:52 -0500
MIME-Version: 1.0
In-Reply-To: <1417529192-11579-10-git-send-email-morten.rasmussen@arm.com>
References: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com> <1417529192-11579-10-git-send-email-morten.rasmussen@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 17 Dec 2014 09:22:31 +0100
Message-ID: <CAKfTPtD6ShGQtNygfmEaiE4t7AWFh_avobmvnNsoX8nJ9Y91TQ@mail.gmail.com>
Subject: Re: [RFC PATCH 09/10] sched: Include blocked utilization in usage tracking
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Michael Turquette <mturquette@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 December 2014 at 15:06, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> Add the blocked utilization contribution to group sched_entity
> utilization (se->avg.utilization_avg_contrib) and to get_cpu_usage().
> With this change cpu usage now includes recent usage by currently
> non-runnable tasks, hence it provides a more stable view of the cpu
> usage. It does, however, also mean that the meaning of usage is changed:
> A cpu may be momentarily idle while usage >0. It can no longer be
> assumed that cpu usage >0 implies runnable tasks on the rq.
> cfs_rq->utilization_load_avg or nr_running should be used instead to get
> the current rq status.

if CONFIG_FAIR_GROUP_SCHED is not set, the blocked utilization of idle
CPUs will never be updated and their utilization will stay at last
value just before going idle. So you can have an CPU which became idle
a long time ago but its utilization remains high.

You have to periodically decay and update the blocked utilization of idle CPUs

>
> cc: Ingo Molnar <mingo@redhat.com>
> cc: Peter Zijlstra <peterz@infradead.org>
>
> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> ---
>  kernel/sched/fair.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index adf64df..bd950b2 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2764,7 +2764,8 @@ static long __update_entity_utilization_avg_contrib(struct sched_entity *se)
>                 __update_task_entity_utilization(se);
>         else
>                 se->avg.utilization_avg_contrib =
> -                                       group_cfs_rq(se)->utilization_load_avg;
> +                               group_cfs_rq(se)->utilization_load_avg +
> +                               group_cfs_rq(se)->utilization_blocked_avg;
>
>         return se->avg.utilization_avg_contrib - old_contrib;
>  }
> @@ -4827,11 +4828,12 @@ static int select_idle_sibling(struct task_struct *p, int target)
>  static int get_cpu_usage(int cpu)
>  {
>         unsigned long usage = cpu_rq(cpu)->cfs.utilization_load_avg;
> +       unsigned long blocked = cpu_rq(cpu)->cfs.utilization_blocked_avg;
>
> -       if (usage >= SCHED_LOAD_SCALE)
> +       if (usage + blocked >= SCHED_LOAD_SCALE)
>                 return capacity_orig_of(cpu);
>
> -       return usage;
> +       return usage + blocked;
>  }
>
>  /*
> --
> 1.9.1
>
>
