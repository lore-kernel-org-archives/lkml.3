Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125Ab3BMUEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:04:10 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:57846 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab3BMUEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:04:07 -0500
MIME-Version: 1.0
In-Reply-To: <1360675195-4017-1-git-send-email-vincent.guittot@linaro.org>
References: <1360675195-4017-1-git-send-email-vincent.guittot@linaro.org>
From: Paul Turner <pjt@google.com>
Date: Wed, 13 Feb 2013 12:03:35 -0800
Message-ID: <CAPM31RJw619JfYSMth4A+vAddYfC3b6VAc09SPUM_R92x+P09w@mail.gmail.com>
Subject: Re: [PATCH] sched: fix env->src_cpu for active migration
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 5:19 AM, Vincent Guittot
<vincent.guittot@linaro.org> wrote:
> need_active_balance uses env->src_cpu which is set only if there is more
> than 1 task on the run queue.
> We must set the src_cpu field unconditionnally
> otherwise the test "env->src_cpu > env->dst_cpu" will always fail if there is
> only 1 task on the run queue
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 81fa536..32938ea 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5044,6 +5044,10 @@ redo:
>

Aside:  Oh dear, it looks like in all the re-factoring here
update_h_load() has escaped rq->lock?

load_balance()
...
		update_h_load(env.src_cpu);
more_balance:
		local_irq_save(flags);
		double_rq_lock(env.dst_rq, busiest);



>         ld_moved = 0;
>         lb_iterations = 1;
> +
> +       env.src_cpu   = busiest->cpu;
> +       env.src_rq    = busiest;
> +

Hmm -- But shouldn't find_busiest_queue return NULL in this case?

We're admittedly racing but we should have:
  busiest->nr_running == 1
  wl = rq->load.weight > env->imbalance since imbalance < (wl -
this_rq->load.weight / 2)

This would seem specialized to the case when we either
  A) race (fbq is openly racy)
  B) have no capacity

Admittedly when we do race current case this is probably a biased
coinflip depending on whatever was on the stack (src_cpu is
uninitialized); it's also super easy for this to later become a crash
if someone tries to dereference src_rq so we should do something.

The case this seems most important for (and something we should add an
explicit comment regarding) is that we want this case specifically for
CPU_NEW_IDLE to move a single runnable-task to a lower numbered
idle-cpu index in the SD_ASYM case (although I suspect we need to push
this up to fbq also to actually find it...)

In the !SD_ASYM case we'd probably also want to  re-check busiest
nr_running in need_active_balance (or probably better alternative
re-arrange the checks) since this is going to potentially now move a
single large task needlessly to an already loaded rq in balance-failed
case.


>         if (busiest->nr_running > 1) {
>                 /*
>                  * Attempt to move tasks. If find_busiest_group has found
> @@ -5052,8 +5056,6 @@ redo:
>                  * correctly treated as an imbalance.
>                  */
>                 env.flags |= LBF_ALL_PINNED;
> -               env.src_cpu   = busiest->cpu;
> -               env.src_rq    = busiest;
>                 env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
>
>                 update_h_load(env.src_cpu);
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
