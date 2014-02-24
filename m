Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaBXCLJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 21:11:09 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:64114 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaBXCLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 21:11:07 -0500
MIME-Version: 1.0
In-Reply-To: <tip-vmme4f49psirp966pklm5l9j@git.kernel.org>
References: <tip-vmme4f49psirp966pklm5l9j@git.kernel.org>
Date: Mon, 24 Feb 2014 10:11:05 +0800
Message-ID: <CALZhoSRZT+T-DxJP2QD0na58bsjf7t89_v0+iMxZZMcc_r1cBQ@mail.gmail.com>
Subject: Re: [tip:sched/core] sched, nohz: Exclude isolated cores from load balancing
From: Lei Wen <adrian.wenl@gmail.com>
To: mingo@kernel.org, hpa@zytor.com, mgalbraith@suse.de,
        linux-kernel@vger.kernel.org, peterz@infradead.org, leiwen@marvell.com,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 2:04 AM, tip-bot for Mike Galbraith
<tipbot@zytor.com> wrote:
> Commit-ID:  d987fc7f3228bf94cb6b21313ebab1d64ee637ad
> Gitweb:     http://git.kernel.org/tip/d987fc7f3228bf94cb6b21313ebab1d64ee637ad
> Author:     Mike Galbraith <mgalbraith@suse.de>
> AuthorDate: Mon, 5 Dec 2011 10:01:47 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Sat, 22 Feb 2014 18:17:22 +0100
>
> sched, nohz: Exclude isolated cores from load balancing
>
> The user explicitly disabled load balancing, else this core would not be
> disconnected.  Don't add these to nohz.idle_cpus_mask.
>
> Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Lei Wen <leiwen@marvell.com>
> Link: http://lkml.kernel.org/n/tip-vmme4f49psirp966pklm5l9j@git.kernel.org
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/sched/fair.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7982faf..a3a41c61 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6788,6 +6788,11 @@ out_unlock:
>         return 0;
>  }
>
> +static inline int on_null_domain(struct rq *rq)
> +{
> +       return unlikely(!rcu_dereference_sched(rq->sd));
> +}
> +
>  #ifdef CONFIG_NO_HZ_COMMON
>  /*
>   * idle load balancing details
> @@ -6842,8 +6847,13 @@ static void nohz_balancer_kick(void)
>  static inline void nohz_balance_exit_idle(int cpu)
>  {
>         if (unlikely(test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))) {
> -               cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
> -               atomic_dec(&nohz.nr_cpus);
> +               /*
> +                * Completely isolated CPUs don't ever set, so we must test.
> +                */
> +               if (likely(cpumask_test_cpu(cpu, nohz.idle_cpus_mask))) {
> +                       cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);

How about use the API as cpumask_test_and_clear_cpu?
Then below one line is enough.

 +               if (likely(cpumask_test_and_clear_cpu(cpu,
nohz.idle_cpus_mask))) {

And I am not pretty sure whether we need such test here.
Since if one cpu is set to NULL domain, it would not set NOHZ_TICK_STOPPED.
And it would not enter into this logic.
Unless that cpu is set to NULL domain when it already run after
nohz_balance_enter_idle.
Not sure what status would it be, and whether it could be set NULL
domain then...

> +                       atomic_dec(&nohz.nr_cpus);

> +               }
>                 clear_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
>         }
>  }
> @@ -6897,6 +6907,12 @@ void nohz_balance_enter_idle(int cpu)
>         if (test_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu)))
>                 return;
>
> +       /*
> +        * If we're a completely isolated CPU, we don't play.
> +        */
> +       if (on_null_domain(cpu_rq(cpu)))
> +               return;
> +

Great! it is much better than my previous patch.

>         cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
>         atomic_inc(&nohz.nr_cpus);
>         set_bit(NOHZ_TICK_STOPPED, nohz_flags(cpu));
> @@ -7159,11 +7175,6 @@ static void run_rebalance_domains(struct softirq_action *h)
>         nohz_idle_balance(this_rq, idle);
>  }
>
> -static inline int on_null_domain(struct rq *rq)
> -{
> -       return !rcu_dereference_sched(rq->sd);
> -}
> -
>  /*
>   * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
>   */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
