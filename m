Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaINJNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 05:13:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:41845 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaINJNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 05:13:47 -0400
Date: Sun, 14 Sep 2014 11:13:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        tkhai@yandex.ru
Subject: Re: [PATCH] sched: Do not stop cpu in set_cpus_allowed_ptr() if task
 is not running
Message-ID: <20140914091338.GN346@worktop.programming.kicks-ass.net>
References: <1410519814.3569.7.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410519814.3569.7.camel@tkhai>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 03:03:34PM +0400, Kirill Tkhai wrote:
> 
> If a task is queued but not running on it rq, we can simply migrate
> it without migration thread and switching of context.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> ---
>  kernel/sched/core.c |   47 ++++++++++++++++++++++++++++++++---------------
>  1 file changed, 32 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index d4399b4..dbbba26 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4594,6 +4594,33 @@ void init_idle(struct task_struct *idle, int cpu)
>  }
>  
>  #ifdef CONFIG_SMP
> +/*
> + * move_queued_task - move a queued task to new rq.
> + *
> + * Returns (locked) new rq. Old rq's lock is released.
> + */
> +static struct rq *move_queued_task(struct task_struct *p, int new_cpu)
> +{
> +	struct rq *rq = task_rq(p);
> +
> +	lockdep_assert_held(&rq->lock);
> +
> +	dequeue_task(rq, p, 0);
> +	p->on_rq = TASK_ON_RQ_MIGRATING;
> +	set_task_cpu(p, new_cpu);
> +	raw_spin_unlock(&rq->lock);
> +
> +	rq = cpu_rq(new_cpu);
> +
> +	raw_spin_lock(&rq->lock);
> +	BUG_ON(task_cpu(p) != new_cpu);
> +	p->on_rq = TASK_ON_RQ_QUEUED;
> +	enqueue_task(rq, p, 0);
> +	check_preempt_curr(rq, p, 0);
> +
> +	return rq;
> +}

We have almost that exact code sequence in __migrate_task() could we
share some?
