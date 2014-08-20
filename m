Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaHTHwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:52:45 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60758 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaHTHwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:52:43 -0400
Date: Wed, 20 Aug 2014 09:52:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, pjt@google.com,
        oleg@redhat.com, rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        tkhai@yandex.ru, tim.c.chen@linux.intel.com, nicolas.pitre@linaro.org
Subject: Re: [PATCH v4 2/6] sched: Wrapper for checking task_struct::on_rq
Message-ID: <20140820075238.GA28179@gmail.com>
References: <20140806075138.24858.23816.stgit@tkhai>
 <1407312372.8424.36.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407312372.8424.36.camel@tkhai>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kirill Tkhai <ktkhai@parallels.com> wrote:

> 
> Implement task_queued() and use it everywhere instead of on_rq check.
> No functional changes.
> 
> The only exception is we do not use the wrapper in check_for_tasks(),
> because it requires to export task_queued() in global header files.
> Next patch in series would return it back, so it doesn't matter.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> ---
>  kernel/sched/core.c      |   82 +++++++++++++++++++++++-----------------------
>  kernel/sched/deadline.c  |   14 ++++----
>  kernel/sched/fair.c      |   22 ++++++------
>  kernel/sched/rt.c        |   16 ++++-----
>  kernel/sched/sched.h     |    7 ++++
>  kernel/sched/stop_task.c |    2 +
>  6 files changed, 75 insertions(+), 68 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1211575..67e8d1e 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1043,7 +1043,7 @@ void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
>  	 * A queue event has occurred, and we're going to schedule.  In
>  	 * this case, we can save a useless back to back clock update.
>  	 */
> -	if (rq->curr->on_rq && test_tsk_need_resched(rq->curr))
> +	if (task_queued(rq->curr) && test_tsk_need_resched(rq->curr))
>  		rq->skip_clock_update = 1;

> -	p->on_rq = 1;
> +	p->on_rq = ONRQ_QUEUED;

> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -15,6 +15,9 @@
>  
>  struct rq;
>  
> +/* task_struct::on_rq states: */
> +#define ONRQ_QUEUED	1
> +
>  extern __read_mostly int scheduler_running;
>  
>  extern unsigned long calc_load_update;
> @@ -942,6 +945,10 @@ static inline int task_running(struct rq *rq, struct task_struct *p)
>  #endif
>  }
>  
> +static inline int task_queued(struct task_struct *p)
> +{
> +	return p->on_rq == ONRQ_QUEUED;
> +}

So I agree with splitting p->on_rq into more states, but the 
new naming used looks pretty random, we can and should do 
better.

For example 'task_queued()' gives very little clue that it's 
all about the p->on_rq state. The 'ONRQ_QUEUED' name does not 
signal that this is a task's scheduler internal state, etc.

So I'd suggest a more structured naming scheme, something along 
the lines of:

	TASK_ON_RQ_QUEUED
	TASK_ON_RQ_MIGRATING

	task_on_rq_queued()
	task_on_rq_migrating()

etc.

It's a bit longer, but also more logical and thus easier to 
read and maintain.

Thanks,

	Ingo
