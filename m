Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaJWILA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:11:00 -0400
Received: from relay.parallels.com ([195.214.232.42]:56894 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbaJWIKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:10:54 -0400
Message-ID: <1414051845.19914.144.camel@tkhai>
Subject: Re: introduce task_rcu_dereference?
From: Kirill Tkhai <ktkhai@parallels.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Thu, 23 Oct 2014 12:10:45 +0400
In-Reply-To: <20141022213041.GA25467@redhat.com>
References: <1413962231.19914.130.camel@tkhai>
	 <20141022213041.GA25467@redhat.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Ср, 22/10/2014 в 23:30 +0200, Oleg Nesterov пишет:
> On 10/22, Kirill Tkhai wrote:
> >
> > Unlocked access to dst_rq->curr in task_numa_compare() is racy.
> > If curr task is exiting this may be a reason of use-after-free:
> 
> Thanks.
> 
> And as you pointed out, there are other examples of unlocked
> foreign_rq->curr usage.
> 
> So, Kirill, Peter, do you think that the patch below can help? Can
> we change task_numa_group() and ->select_task_rq() to do nothing if
> rq_curr_rcu_safe() returns NULL? It seems we can...
> 
> task_numa_compare() can use it too, we can make another patch on
> top of this one.
> 
> 	- Obviously just for the early review. Lacks the changelog
> 	  and the comments (at least).
> 
> 	- Once again, I won't insist on probe_slab_address(). We can
> 	  add SDBR and change task_rcu_dereference() to simply read
> 	  ->sighand.
> 
> 	- Also, I won't argue if you think that we do not need a
> 	  generic helper. In this case we can move this logic into
> 	  rq_curr_rcu_safe() and it will be a bit simpler.
> 
> 	- OTOH, I am not sure we need rq_curr_rcu_safe(). The callers
> 	  can just use task_rcu_dereference() and check IS_ERR_OR_NULL,
> 	  I guess retry doesn't buy too much in this case.
> 
> Or do you think we need something else?
> 
> Oleg.
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 857ba40..0ba420e 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2300,6 +2300,7 @@ extern void block_all_signals(int (*notifier)(void *priv), void *priv,
>  			      sigset_t *mask);
>  extern void unblock_all_signals(void);
>  extern void release_task(struct task_struct * p);
> +extern struct task_struct *task_rcu_dereference(struct task_struct **ptask);
>  extern int send_sig_info(int, struct siginfo *, struct task_struct *);
>  extern int force_sigsegv(int, struct task_struct *);
>  extern int force_sig_info(int, struct siginfo *, struct task_struct *);
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 32c58f7..4aa00c7 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -213,6 +213,37 @@ repeat:
>  		goto repeat;
>  }
>  
> +struct task_struct *task_rcu_dereference(struct task_struct **ptask)
> +{
> +	struct task_struct *task;
> +	struct sighand_struct *sighand;
> +
> +	task = rcu_dereference(*ptask);
> +	if (!task)
> +		return NULL;
> +
> +	/* If it fails the check below must fail too */
> +	probe_slab_address(&task->sighand, sighand);
> +	/*
> +	 * Pairs with atomic_dec_and_test() in put_task_struct(task).
> +	 * If we have read the freed/reused memory, we must see that
> +	 * the pointer was updated. The caller might want to retry in
> +	 * this case.
> +	 */
> +	smp_rmb();
> +	if (unlikely(task != ACCESS_ONCE(*ptask)))
> +		return ERR_PTR(-EAGAIN);
> +
> +	/*
> +	 * release_task(task) was already called; potentially before
> +	 * the caller took rcu_read_lock() and in this case it can be
> +	 * freed before rcu_read_unlock().
> +	 */
> +	if (!sighand)
> +		return ERR_PTR(-EINVAL);
> +	return task;
> +}
> +
>  /*
>   * This checks not only the pgrp, but falls back on the pid if no
>   * satisfactory pgrp is found. I dunno - gdb doesn't work correctly
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 579712f..249c0c1 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -655,6 +655,18 @@ DECLARE_PER_CPU(struct rq, runqueues);
>  #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
>  #define raw_rq()		(&__raw_get_cpu_var(runqueues))
>  
> +static inline struct task_struct *rq_curr_rcu_safe(struct rq *rq)
> +{
> +	for (;;) {
> +		struct task_struct *curr = task_rcu_dereference(&rq->curr);
> +		/* NULL is not possible */
> +		if (likely(!IS_ERR(curr)))
> +			return curr;
> +		if (PTR_ERR(curr) != -EAGAIN)
> +			return NULL;
> +	}
> +}
> +
>  static inline u64 rq_clock(struct rq *rq)
>  {
>  	return rq->clock;
> 

I'm agree generic helper is better. But probe_slab_address() has a sence
if we know that SDBR is worse in our subject area. Less of code is
easier to support :) probe_slab_address() it's not a trivial logic.
Also, if we use mm primitives this increases kernel modularity.

Kirill

