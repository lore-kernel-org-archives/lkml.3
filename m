Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab3FDLLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:11:51 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:65033 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3FDLLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:11:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130604102620.GB14012@somewhere>
References: <1369927385-7801-1-git-send-email-vincent.guittot@linaro.org>
	<20130603224836.GA9388@somewhere>
	<CAKfTPtCB_ftNWjgAM9s79dX_tuS4yevjdD0YxvKfKS4dxz=LLQ@mail.gmail.com>
	<20130604093611.GJ8923@twins.programming.kicks-ass.net>
	<20130604102620.GB14012@somewhere>
Date: Tue, 4 Jun 2013 13:11:47 +0200
Message-ID: <CAKfTPtCLYnhQH3Mcx5dhRi9+9_679fdrhm8iZBSpgyu8VmevYw@mail.gmail.com>
Subject: Re: [PATCH] sched: fix clear NOHZ_BALANCE_KICK
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2013 12:26, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Tue, Jun 04, 2013 at 11:36:11AM +0200, Peter Zijlstra wrote:
>>
>> The best I can seem to come up with is something like the below; but I think
>> its ghastly. Surely we can do something saner with that bit.
>>
>> Having to clear it at 3 different places is just wrong.
>
> We could clear the flag early in scheduler_ipi() and set some
> specific value in rq->idle_balance that tells we want nohz idle
> balancing from the softirq, something like this untested:

I'm not sure that we can have less than 2 places to clear it: cancel
place or acknowledge place otherwise we can face a situation where
idle load balance will be triggered 2 consecutive times because
NOHZ_BALANCE_KICK will be cleared before the idle load balance has
been done and had a chance to migrate tasks.

>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 58453b8..330136b 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -630,15 +630,14 @@ void wake_up_nohz_cpu(int cpu)
>                 wake_up_idle_cpu(cpu);
>  }
>
> -static inline bool got_nohz_idle_kick(void)
> +static inline bool got_nohz_idle_kick(int cpu)
>  {
> -       int cpu = smp_processor_id();
> -       return idle_cpu(cpu) && test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
> +       return test_and_clear_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
>  }
>
>  #else /* CONFIG_NO_HZ_COMMON */
>
> -static inline bool got_nohz_idle_kick(void)
> +static inline bool got_nohz_idle_kick(int cpu)
>  {
>         return false;
>  }
> @@ -1393,8 +1392,12 @@ static void sched_ttwu_pending(void)
>
>  void scheduler_ipi(void)
>  {
> -       if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick()
> -           && !tick_nohz_full_cpu(smp_processor_id()))
> +       int cpu = smp_processor_id();
> +       bool idle_kick = got_nohz_idle_kick(cpu);
> +
> +       if (!(idle_kick && idle_cpu(cpu))
> +           && llist_empty(&this_rq()->wake_list)
> +           && !tick_nohz_full_cpu(cpu)
>                 return;
>
>         /*
> @@ -1417,8 +1420,8 @@ void scheduler_ipi(void)
>         /*
>          * Check if someone kicked us for doing the nohz idle load balance.
>          */
> -       if (unlikely(got_nohz_idle_kick() && !need_resched())) {
> -               this_rq()->idle_balance = 1;
> +           if (unlikely(idle_kick && idle_cpu(cpu) && !need_resched())) {
> +               this_rq()->idle_balance = IDLE_NOHZ_BALANCE;
>                 raise_softirq_irqoff(SCHED_SOFTIRQ);
>         }
>         irq_exit();
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index c61a614..816e7b0 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5577,15 +5577,14 @@ out:
>   * In CONFIG_NO_HZ_COMMON case, the idle balance kickee will do the
>   * rebalancing for all the cpus for whom scheduler ticks are stopped.
>   */
> -static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
> +static void nohz_idle_balance(int this_cpu)
>  {
>         struct rq *this_rq = cpu_rq(this_cpu);
>         struct rq *rq;
>         int balance_cpu;
>
> -       if (idle != CPU_IDLE ||
> -           !test_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu)))
> -               goto end;
> +       if (this_rq->idle_balance != IDLE_NOHZ_BALANCE)
> +               return;
>
>         for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
>                 if (balance_cpu == this_cpu || !idle_cpu(balance_cpu))
> @@ -5612,8 +5611,12 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
>                         this_rq->next_balance = rq->next_balance;
>         }
>         nohz.next_balance = this_rq->next_balance;
> -end:
> -       clear_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu));
> +
> +       /* There could be concurrent updates from irqs but we don't care */
> +       if (idle_cpu(this_cpu))
> +               this_rq->idle_balance = IDLE_BALANCE;
> +       else
> +               this_rq->idle_balance = 0;
>  }
>
>  /*
> @@ -5679,7 +5682,7 @@ need_kick:
>         return 1;
>  }
>  #else
> -static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle) { }
> +static void nohz_idle_balance(int this_cpu) { }
>  #endif
>
>  /*
> @@ -5700,7 +5703,7 @@ static void run_rebalance_domains(struct softirq_action *h)
>          * balancing on behalf of the other idle cpus whose ticks are
>          * stopped.
>          */
> -       nohz_idle_balance(this_cpu, idle);
> +       nohz_idle_balance(this_cpu);
>  }
>
>  static inline int on_null_domain(int cpu)
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index ce39224..e9de976 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -387,6 +387,11 @@ extern struct root_domain def_root_domain;
>
>  #endif /* CONFIG_SMP */
>
> +enum idle_balance_type {
> +       IDLE_BALANCE = 1,
> +       IDLE_NOHZ_BALANCE = 2,
> +};
> +
>  /*
>   * This is the main, per-CPU runqueue data structure.
>   *
> @@ -458,7 +463,7 @@ struct rq {
>
>         unsigned long cpu_power;
>
> -       unsigned char idle_balance;
> +       enum idle_balance_type idle_balance;
>         /* For active balancing */
>         int post_schedule;
>         int active_balance;
