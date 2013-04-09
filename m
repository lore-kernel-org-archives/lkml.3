Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936229Ab3DIHIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:08:11 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:63806 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab3DIHIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:08:09 -0400
MIME-Version: 1.0
In-Reply-To: <1364873008-3169-7-git-send-email-alex.shi@intel.com>
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com>
	<1364873008-3169-7-git-send-email-alex.shi@intel.com>
Date: Tue, 9 Apr 2013 09:08:08 +0200
Message-ID: <CAKfTPtBoV3KoSHuTnZVrvPdCM+5ckFGXfM11oCB1Le_Zmy1hYQ@mail.gmail.com>
Subject: Re: [patch v3 6/8] sched: consider runnable load average in move_tasks
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Paul Turner <pjt@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, rafael.j.wysocki@intel.com,
        jkosina@suse.cz, clark.williams@gmail.com,
        "tony.luck@intel.com" <tony.luck@intel.com>, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 April 2013 05:23, Alex Shi <alex.shi@intel.com> wrote:
> Except using runnable load average in background, move_tasks is also
> the key functions in load balance. We need consider the runnable load
> average in it in order to the apple to apple load comparison.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1f9026e..bf4e0d4 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3966,6 +3966,15 @@ static unsigned long task_h_load(struct task_struct *p);
>
>  static const unsigned int sched_nr_migrate_break = 32;
>
> +static unsigned long task_h_load_avg(struct task_struct *p)
> +{
> +       u32 period = p->se.avg.runnable_avg_period;
> +       if (!period)
> +               return 0;
> +
> +       return task_h_load(p) * p->se.avg.runnable_avg_sum / period;

How do you ensure that runnable_avg_period and runnable_avg_sum are
coherent ? an update of the statistic can occur in the middle of your
sequence.

Vincent

> +}
> +
>  /*
>   * move_tasks tries to move up to imbalance weighted load from busiest to
>   * this_rq, as part of a balancing operation within domain "sd".
> @@ -4001,7 +4010,7 @@ static int move_tasks(struct lb_env *env)
>                 if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
>                         goto next;
>
> -               load = task_h_load(p);
> +               load = task_h_load_avg(p);
>
>                 if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
>                         goto next;
> --
> 1.7.12
>
