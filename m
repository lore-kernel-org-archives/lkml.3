Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaAVHue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 02:50:34 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:64078 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaAVHud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 02:50:33 -0500
MIME-Version: 1.0
In-Reply-To: <1390376734-6800-1-git-send-email-vincent.guittot@linaro.org>
References: <CAPM31RLjHnn=Ma7peuDUqK75bANw7Mb-UT-1QmzG0c8LAObQ8g@mail.gmail.com>
 <1390376734-6800-1-git-send-email-vincent.guittot@linaro.org>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 22 Jan 2014 08:50:12 +0100
Message-ID: <CAKfTPtAaHSkao2MAXiqwKMYB5MfaF_Ah6Rik26isi5d35duOtg@mail.gmail.com>
Subject: Re: [PATCH] Revert "sched: Fix sleep time double accounting in
 enqueue entity"
To: Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Benjamin Segall <bsegall@google.com>, Alex Shi <alex.shi@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

I let you send a patch that will add comment and move the "if (wakeup) logic" ?

Regards
Vincent

On 22 January 2014 08:45, Vincent Guittot <vincent.guittot@linaro.org> wrote:
> This reverts commit 282cf499f03ec1754b6c8c945c9674b02631fb0f.
>
> With the current implementation, the load average statistics of a sched entity
> change according to other activity on the CPU even if this activity is done
> between the running window of the sched entity and have no influence on the
> running duration of the task.
>
> When a task wakes up on the same CPU, we currently update last_runnable_update
> with the return  of __synchronize_entity_decay without updating the
> runnable_avg_sum and runnable_avg_period accordingly. In fact, we have to sync
> the load_contrib of the se with the rq's blocked_load_contrib before removing
> it from the latter (with __synchronize_entity_decay) but we must keep
> last_runnable_update unchanged for updating runnable_avg_sum/period during the
> next update_entity_load_avg.
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>
> ---
>  kernel/sched/fair.c |    8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e64b079..6d61f20 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2365,13 +2365,7 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
>                 }
>                 wakeup = 0;
>         } else {
> -               /*
> -                * Task re-woke on same cpu (or else migrate_task_rq_fair()
> -                * would have made count negative); we must be careful to avoid
> -                * double-accounting blocked time after synchronizing decays.
> -                */
> -               se->avg.last_runnable_update += __synchronize_entity_decay(se)
> -                                                       << 20;
> +               __synchronize_entity_decay(se);
>         }
>
>         /* migrated tasks did not contribute to our blocked load */
> --
> 1.7.9.5
>
