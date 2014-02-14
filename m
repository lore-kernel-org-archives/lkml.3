Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaBNMnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 07:43:51 -0500
Received: from relay.parallels.com ([195.214.232.42]:33078 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaBNMnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 07:43:50 -0500
Message-ID: <1392381841.5384.43.camel@tkhai>
Subject: Re: [PATCH] sched/core: Create new task with twice disabled
 preemption
From: Kirill Tkhai <ktkhai@parallels.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, <tkhai@yandex.ru>
Date: Fri, 14 Feb 2014 16:44:01 +0400
In-Reply-To: <20140214123536.GA12304@arm.com>
References: <1392306716.5384.3.camel@tkhai> <20140214123536.GA12304@arm.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Птн, 14/02/2014 в 12:35 +0000, Catalin Marinas пишет:
> On Thu, Feb 13, 2014 at 07:51:56PM +0400, Kirill Tkhai wrote:
> > Preemption state on enter in finish_task_switch() is different
> > in cases of context_switch() and schedule_tail().
> > 
> > In the first case we have it twice disabled: at the start of
> > schedule() and during spin locking. In the second it is only
> > once: the value which was set in init_task_preempt_count().
> > 
> > For archs without __ARCH_WANT_UNLOCKED_CTXSW set this means
> > that all newly created tasks execute finish_arch_post_lock_switch()
> > and post_schedule() with preemption enabled.
> > 
> > It seems there is possible a problem in rare situations on arm64,
> > when one freshly created thread preempts another before
> > finish_arch_post_lock_switch() has finished. If mm is the same,
> > then TIF_SWITCH_MM on the second won't be set.
> > 
> > The second rare but possible issue is zeroing of post_schedule()
> > on a wrong cpu.
> > 
> > So, lets fix this and unify preempt_count state.
> 
> An alternative to your patch:

It looks better, than the initial.

You may add my Acked-by if you want.

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b46131ef6aab..b932b6a4c716 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2210,6 +2210,10 @@ asmlinkage void schedule_tail(struct task_struct *prev)
>  {
>  	struct rq *rq = this_rq();
>  
> +#ifndef __ARCH_WANT_UNLOCKED_CTXSW
> +	/* In this case, finish_task_switch reenables preemption */
> +	preempt_disable();
> +#endif
>  	finish_task_switch(rq, prev);
>  
>  	/*
> @@ -2218,10 +2222,7 @@ asmlinkage void schedule_tail(struct task_struct *prev)
>  	 */
>  	post_schedule(rq);
>  
> -#ifdef __ARCH_WANT_UNLOCKED_CTXSW
> -	/* In this case, finish_task_switch does not reenable preemption */
>  	preempt_enable();
> -#endif
>  	if (current->set_child_tid)
>  		put_user(task_pid_vnr(current), current->set_child_tid);
>  }
> 


