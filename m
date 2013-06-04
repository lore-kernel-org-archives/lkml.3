Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3FDLPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:15:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51696 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3FDLPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:15:18 -0400
Date: Tue, 4 Jun 2013 13:15:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched: fix clear NOHZ_BALANCE_KICK
Message-ID: <20130604111510.GO8923@twins.programming.kicks-ass.net>
References: <1369927385-7801-1-git-send-email-vincent.guittot@linaro.org>
 <20130603224836.GA9388@somewhere>
 <CAKfTPtCB_ftNWjgAM9s79dX_tuS4yevjdD0YxvKfKS4dxz=LLQ@mail.gmail.com>
 <20130604093611.GJ8923@twins.programming.kicks-ass.net>
 <20130604102620.GB14012@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604102620.GB14012@somewhere>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 12:26:22PM +0200, Frederic Weisbecker wrote:
> On Tue, Jun 04, 2013 at 11:36:11AM +0200, Peter Zijlstra wrote:
> > 
> > The best I can seem to come up with is something like the below; but I think
> > its ghastly. Surely we can do something saner with that bit.
> > 
> > Having to clear it at 3 different places is just wrong.
> 
> We could clear the flag early in scheduler_ipi() and set some
> specific value in rq->idle_balance that tells we want nohz idle
> balancing from the softirq, something like this untested:

Yeah, I suppose something like that is a little better.. a few nits
though:

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 58453b8..330136b 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -630,15 +630,14 @@ void wake_up_nohz_cpu(int cpu)
>  		wake_up_idle_cpu(cpu);
>  }
>  
> -static inline bool got_nohz_idle_kick(void)
> +static inline bool got_nohz_idle_kick(int cpu)
>  {
> -	int cpu = smp_processor_id();
> -	return idle_cpu(cpu) && test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
> +	return test_and_clear_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
>  }
>  
>  #else /* CONFIG_NO_HZ_COMMON */
>  
> -static inline bool got_nohz_idle_kick(void)
> +static inline bool got_nohz_idle_kick(int cpu)
>  {
>  	return false;
>  }
> @@ -1393,8 +1392,12 @@ static void sched_ttwu_pending(void)
>  
>  void scheduler_ipi(void)
>  {
> -	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick()
> -	    && !tick_nohz_full_cpu(smp_processor_id()))
> +	int cpu = smp_processor_id();
> +	bool idle_kick = got_nohz_idle_kick(cpu);

This puts an unconditional atomic instruction in the IPI path. 
 if (test) clear();
is lots cheaper, esp. since most IPIs won't have this flag set.

> +
> +	if (!(idle_kick && idle_cpu(cpu))
> +	    && llist_empty(&this_rq()->wake_list)
> +	    && !tick_nohz_full_cpu(cpu)

What's with this weird operator first split style?

>  		return;
>  
>  	/*
  
> +enum idle_balance_type {
> +	IDLE_BALANCE = 1,
> +	IDLE_NOHZ_BALANCE = 2,
> +};

You might want to update the rq->idle_balance assignment in
scheduler_tick() to make sure it uses the right value (it does now, but
there's nothing stopping people from changing the values).
