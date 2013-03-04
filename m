Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab3CDJOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:14:00 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:34083 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab3CDJN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:13:56 -0500
MIME-Version: 1.0
In-Reply-To: <1362032762-20827-1-git-send-email-namhyung@kernel.org>
References: <1362032762-20827-1-git-send-email-namhyung@kernel.org>
From: Paul Turner <pjt@google.com>
Date: Mon, 4 Mar 2013 22:13:24 +1300
Message-ID: <CAPM31R+q3ent9uqvCWJ_41b7CmAamFtT7uDZ93=Oeji8dcH_yA@mail.gmail.com>
Subject: Re: [PATCH] sched: Fix calc_cfs_shares() to consider blocked_load_avg also
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I'm still in New Zealand and won't be on regular email until March
6th, but I just saw this and wanted to comment quickly)

On Thu, Feb 28, 2013 at 7:26 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> The calc_tg_weight() and calc_cfs_shares() used cfs_rq->load.weight
> but this is no longer valid for per-entity load tracking since
> cfs_rq->tg_load_contrib consists of runnable_load_avg and blocked_
> load_avg.  Simply using load.weight here will lose blocked_load_avg
> part so will result in an inaccurate share.
>
> Cc: Paul Turner <pjt@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/sched/fair.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7a33e5986fc5..add7440bd02f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1032,13 +1032,13 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
>         long tg_weight;
>
>         /*
> -        * Use this CPU's actual weight instead of the last load_contribution
> -        * to gain a more accurate current total weight. See
> -        * update_cfs_rq_load_contribution().
> +        * Use this CPU's actual load instead of the last load_contribution
> +        * to gain a more accurate current total load. See
> +        * __update_cfs_rq_tg_load_contrib().
>          */
>         tg_weight = atomic64_read(&tg->load_avg);
>         tg_weight -= cfs_rq->tg_load_contrib;
> -       tg_weight += cfs_rq->load.weight;
> +       tg_weight += cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;

No -- we _really_ do want to use the instantaneous weight, the
maintained averages are back-wards looking and do not always predict
future usage.  We played with allocation strategies like the above
during this development and it ends up being a big loss for latency.

In particular:
  tasks with a low runnable averages are almost always going to be
_under_ their fair share; using the current runnable average here then
harshly penalizes their ability to pre-empt when the calculated weight
is subsequently used for emplacement.  Stronger:  Such tasks are
typically interactive (having to wait for us slow humans and all).
Consider what the above would do to a while(1) versus interactive
thread in the same cgroup; the cpu holding the while(1) thread is
always going to wholly dominate share allocation.

>         return tg_weight;
>  }
> @@ -1048,7 +1048,7 @@ static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
>         long tg_weight, load, shares;
>
>         tg_weight = calc_tg_weight(tg, cfs_rq);
> -       load = cfs_rq->load.weight;
> +       load = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
>
>         shares = (tg->shares * load);
>         if (tg_weight)
> --
> 1.7.11.7
>
