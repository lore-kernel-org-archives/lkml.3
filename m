Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab3KLESA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 23:18:00 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:37824 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3KLERv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 23:17:51 -0500
MIME-Version: 1.0
In-Reply-To: <1383831828-15501-2-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com> <1383831828-15501-2-git-send-email-juri.lelli@gmail.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 11 Nov 2013 20:17:20 -0800
Message-ID: <CAPM31R+=zRB7WJTSkYCLmo1cvPLV-6ZuedJLts+vb5r4hKJhYg@mail.gmail.com>
Subject: Re: [PATCH 01/14] sched: add sched_class->task_dead.
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        LKML <linux-kernel@vger.kernel.org>, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, Dhaval Giani <dhaval.giani@gmail.com>,
        hgu1972@gmail.com, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        Vincent Guittot <vincent.guittot@linaro.org>,
        bruce.ashfield@windriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 5:43 AM, Juri Lelli <juri.lelli@gmail.com> wrote:
> From: Dario Faggioli <raistlin@linux.it>
>
> Add a new function to the scheduling class interface. It is called
> at the end of a context switch, if the prev task is in TASK_DEAD state.
>
> It might be useful for the scheduling classes that want to be notified
> when one of their task dies, e.g. to perform some cleanup actions.

We could also usefully use this within SCHED_FAIR to remove a task's
load contribution when it completes.

>
> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> ---
>  kernel/sched/core.c  |    3 +++
>  kernel/sched/sched.h |    1 +
>  2 files changed, 4 insertions(+)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 5ac63c9..850a02c 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1890,6 +1890,9 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>         if (mm)
>                 mmdrop(mm);
>         if (unlikely(prev_state == TASK_DEAD)) {
> +               if (prev->sched_class->task_dead)
> +                       prev->sched_class->task_dead(prev);
> +
>                 /*
>                  * Remove function-return probe instances associated with this
>                  * task and put them back on the free list.
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index b3c5653..64eda5c 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -992,6 +992,7 @@ struct sched_class {
>         void (*set_curr_task) (struct rq *rq);
>         void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
>         void (*task_fork) (struct task_struct *p);
> +       void (*task_dead) (struct task_struct *p);
>
>         void (*switched_from) (struct rq *this_rq, struct task_struct *task);
>         void (*switched_to) (struct rq *this_rq, struct task_struct *task);

Reviewed-by: Paul Turner <pjt@google.com>

> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
