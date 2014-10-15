Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaJOPKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:10:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaJOPKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:10:11 -0400
Date: Wed, 15 Oct 2014 17:06:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH RFC] sched: Revert delayed_put_task_struct() and fix
	use after free
Message-ID: <20141015150641.GA2755@redhat.com>
References: <1413376300.24793.55.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413376300.24793.55.camel@tkhai>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15, Kirill Tkhai wrote:
>
> This WARN_ON_ONCE() placed into __schedule() triggers warning:
>
> @@ -2852,6 +2852,7 @@ static void __sched __schedule(void)
>
>  	if (likely(prev != next)) {
>  		rq->nr_switches++;
> +		WARN_ON_ONCE(atomic_read(&prev->usage) == 1);

I think you know this, but let me clarify just in case that this WARN()
is wrong, prev->usage == 1 is fine if the task does its last schedule()
and it was already (auto)reaped.

> This means the final put_task_struct() happens against RCU rules.

Well, yes, it doesn't use delayed_put_pid(). But this should be fine,
this drops the extra reference created by dup_task_struct().

However,

> Regarding to scheduler this may be a reason of use-after-free.
>
>     task_numa_compare()                    schedule()
>         rcu_read_lock()                        ...
>         cur = ACCESS_ONCE(dst_rq->curr)        ...
>             ...                                rq->curr = next;
>             ...                                    context_switch()
>             ...                                        finish_task_switch()
>             ...                                            put_task_struct()
>             ...                                                __put_task_struct()
>             ...                                                    free_task_struct()
>             task_numa_assign()                                     ...
>                 get_task_struct()                                  ...

Agreed. I don't understand this code (will try to take another look later),
but at first glance this looks wrong.

At least the code like

	rcu_read_lock();
	get_task_struct(foreign_rq->curr);
	rcu_read_unlock();

is certainly wrong. And _probably_ the problem should be fixed here. Perhaps
we can add try_to_get_task_struct() which does atomic_inc_not_zero() ...

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1854,11 +1854,12 @@ extern void free_task(struct task_struct *tsk);
>  #define get_task_struct(tsk) do { atomic_inc(&(tsk)->usage); } while(0)
>
>  extern void __put_task_struct(struct task_struct *t);
> +extern void __put_task_struct_cb(struct rcu_head *rhp);
>
>  static inline void put_task_struct(struct task_struct *t)
>  {
>  	if (atomic_dec_and_test(&t->usage))
> -		__put_task_struct(t);
> +		call_rcu(&t->rcu, __put_task_struct_cb);
>  }
>
>  #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 5d30019..326eae7 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -159,15 +159,15 @@ static void __exit_signal(struct task_struct *tsk)
>  	}
>  }
>
> -static void delayed_put_task_struct(struct rcu_head *rhp)
> +void __put_task_struct_cb(struct rcu_head *rhp)
>  {
>  	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
>
>  	perf_event_delayed_put(tsk);
>  	trace_sched_process_free(tsk);
> -	put_task_struct(tsk);
> +	__put_task_struct(tsk);
>  }
> -
> +EXPORT_SYMBOL_GPL(__put_task_struct_cb);
>
>  void release_task(struct task_struct *p)
>  {
> @@ -207,7 +207,7 @@ void release_task(struct task_struct *p)
>
>  	write_unlock_irq(&tasklist_lock);
>  	release_thread(p);
> -	call_rcu(&p->rcu, delayed_put_task_struct);
> +	put_task_struct(p);
>
>  	p = leader;
>  	if (unlikely(zap_leader))
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 9b7d746..4d3ac3c 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -249,7 +249,6 @@ void __put_task_struct(struct task_struct *tsk)
>  	if (!profile_handoff_task(tsk))
>  		free_task(tsk);
>  }
> -EXPORT_SYMBOL_GPL(__put_task_struct);
>
>  void __init __weak arch_task_cache_init(void) { }

Hmm. I am not sure I understand how this patch can actually fix this problem.
It seems that it is still possible that get_task_struct() can be called after
call_rcu(__put_task_struct_cb) ? But perhaps I misread this patch.

And I think it adds another problem. Suppose we have a zombie which already
called schedule() in TASK_DEAD state. IOW, its ->usage == 1, its parent will
free this task when it calls sys_wait().

With this patch the code like

	rcu_read_lock();
	for_each_process(p) {
		if (pred(p) {
			get_task_struct(p);
			return p;
		}
	}
	rcu_read_unlock();

becomes unsafe: we can race with release_task(p) and get_task_struct() can
can be called when prev->usage is already 0 and this task_struct can be freed
omce you drop rcu_read_lock().

Oleg.

