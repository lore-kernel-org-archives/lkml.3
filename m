Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab3FQK7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:59:10 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:52470 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715Ab3FQK7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:59:08 -0400
MIME-Version: 1.0
In-Reply-To: <1370589652-24549-9-git-send-email-alex.shi@intel.com>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-9-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 17 Jun 2013 03:58:32 -0700
Message-ID: <CAPM31RJs=A+j5NtSr4TXzQ8sAHMSkz+cNoZjOhsmc2p2HksZNg@mail.gmail.com>
Subject: Re: [patch v8 8/9] sched: consider runnable load average in move_tasks
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 12:20 AM, Alex Shi <alex.shi@intel.com> wrote:
> Except using runnable load average in background, move_tasks is also
> the key functions in load balance. We need consider the runnable load
> average in it in order to the apple to apple load comparison.
>
> Morten had caught a div u64 bug on ARM, thanks!
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index eadd2e7..3aa1dc0 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4178,11 +4178,14 @@ static int tg_load_down(struct task_group *tg, void *data)
>         long cpu = (long)data;
>
>         if (!tg->parent) {
> -               load = cpu_rq(cpu)->load.weight;
> +               load = cpu_rq(cpu)->avg.load_avg_contrib;
>         } else {
> +               unsigned long tmp_rla;
> +               tmp_rla = tg->parent->cfs_rq[cpu]->runnable_load_avg + 1;
> +
>                 load = tg->parent->cfs_rq[cpu]->h_load;
> -               load *= tg->se[cpu]->load.weight;
> -               load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
> +               load *= tg->se[cpu]->avg.load_avg_contrib;
> +               load /= tmp_rla;

Why do we need the temporary here?

>         }
>
>         tg->cfs_rq[cpu]->h_load = load;
> @@ -4208,12 +4211,9 @@ static void update_h_load(long cpu)
>  static unsigned long task_h_load(struct task_struct *p)
>  {
>         struct cfs_rq *cfs_rq = task_cfs_rq(p);
> -       unsigned long load;
> -
> -       load = p->se.load.weight;
> -       load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
>
> -       return load;
> +       return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
> +                       cfs_rq->runnable_load_avg + 1);
>  }
>  #else
>  static inline void update_blocked_averages(int cpu)
> --
> 1.7.12
>
