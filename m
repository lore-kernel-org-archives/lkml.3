Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaBJJY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:24:27 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:33720 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaBJJYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:24:20 -0500
MIME-Version: 1.0
In-Reply-To: <1391728237-4441-3-git-send-email-daniel.lezcano@linaro.org>
References: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org>
	<1391728237-4441-3-git-send-email-daniel.lezcano@linaro.org>
Date: Mon, 10 Feb 2014 14:54:20 +0530
Message-ID: <CAM4v1pMEFTe6pQVDFzaXmqt_A3vw3tyj7Ewqib6zbzH++YzY3w@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] sched: Fix race in idle_balance()
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, alex.shi@linaro.org, LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Daniel,

Isn't the only scenario where another cpu can put an idle task on
our runqueue, in nohz_idle_balance() where only the cpus in
the nohz.idle_cpus_mask are iterated through. But for the case
that this patch is addressing, the cpu in question is not yet a part
of the nohz.idle_cpus_mask right?

Any other case would trigger load balancing on the same cpu, but
we are preempt_disabled and interrupt disabled at this point.

Thanks

Regards
Preeti U Murthy

On Fri, Feb 7, 2014 at 4:40 AM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> The scheduler main function 'schedule()' checks if there are no more tasks
> on the runqueue. Then it checks if a task should be pulled in the current
> runqueue in idle_balance() assuming it will go to idle otherwise.
>
> But the idle_balance() releases the rq->lock in order to lookup in the sched
> domains and takes the lock again right after. That opens a window where
> another cpu may put a task in our runqueue, so we won't go to idle but
> we have filled the idle_stamp, thinking we will.
>
> This patch closes the window by checking if the runqueue has been modified
> but without pulling a task after taking the lock again, so we won't go to idle
> right after in the __schedule() function.
>
> Cc: alex.shi@linaro.org
> Cc: peterz@infradead.org
> Cc: mingo@kernel.org
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched/fair.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 428bc9d..5ebc681 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6589,6 +6589,13 @@ void idle_balance(struct rq *this_rq)
>
>         raw_spin_lock(&this_rq->lock);
>
> +       /*
> +        * While browsing the domains, we released the rq lock.
> +        * A task could have be enqueued in the meantime
> +        */
> +       if (this_rq->nr_running && !pulled_task)
> +               return;
> +
>         if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
>                 /*
>                  * We are going idle. next_balance may be set based on
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
