Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaJRTgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 15:36:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:37574 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaJRTgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 15:36:17 -0400
Date: Sat, 18 Oct 2014 21:36:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Oleg Nesterov <oleg@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
Message-ID: <20141018193612.GC23531@worktop.programming.kicks-ass.net>
References: <1413376300.24793.55.camel@tkhai>
 <20141017213641.GB32576@redhat.com>
 <4323181413620101@web21o.yandex.ru>
 <1011271413621207@web30j.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1011271413621207@web30j.yandex.ru>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 12:33:27PM +0400, Kirill Tkhai wrote:
> How about this?
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index b78280c..d46427e 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1165,7 +1165,21 @@ static void task_numa_compare(struct task_numa_env *env,
>  
>  	rcu_read_lock();
>  	cur = ACCESS_ONCE(dst_rq->curr);
> -	if (cur->pid == 0) /* idle */
> +	/*
> +	 * No need to move the exiting task, and this ensures that ->curr
> +	 * wasn't reaped and thus get_task_struct() in task_numa_assign()
> +	 * is safe; note that rcu_read_lock() can't protect from the final
> +	 * put_task_struct() after the last schedule().
> +	 */
> +	if (is_idle_task(cur) || (cur->flags & PF_EXITING))
> +		cur = NULL;
> +	/*
> +	 * Check once again to be sure curr is still on dst_rq. Even if
> +	 * it points on a new task, which is using the memory of freed
> +	 * cur, it's OK, because we've locked RCU before
> +	 * delayed_put_task_struct() callback is called to put its struct.
> +	 */
> +	if (cur != ACCESS_ONCE(dst_rq->curr))
>  		cur = NULL;
>  
>  	/*

So you worry about the refcount doing 0->1 ? In which case the above is
still wrong and we should be using atomic_inc_not_zero() in order to
acquire the reference count.
