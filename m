Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab3APPGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:06:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59310 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab3APPGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:06:04 -0500
Message-ID: <1358348758.4643.42.camel@marge.simpson.net>
Subject: Re: [PATCH -tip] sched: Pair ttwu_activate() with uwtt_deactivate()
From: Mike Galbraith <bitbucket@online.de>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Wed, 16 Jan 2013 16:05:58 +0100
In-Reply-To: <10a81412c1ac7549412b11a9aa0b5c70dac5de37.1358331166.git.agordeev@redhat.com>
References: <10a81412c1ac7549412b11a9aa0b5c70dac5de37.1358331166.git.agordeev@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:xQqTZfzHrWLtZ5ZSJciCC446I9VJoYUMQ1aEW0dKbup
 hoPjM+Hx98144l/Dm/ewmkDuxRHYQvmxQUjDa79fSxcrg4kXwa
 z1d0c0w5MgvhXaZgHrTwS8n6nugPAVgtfiNYFSG6j6gd75CFlL
 vEJ/7mYeW7TavGa7+a8V4AHtB2av5XjTuIfG4nvlkxmCX/FTXz
 +EqLW5xfHHreOgiBNwDyGH0gs/kV94bNFbLmbOiLHyjkOcacPo
 CAuWLzn8zT4qwaNuukYaTBqholN4illdAyPTDU+zgTtlx2h2pU
 Z1HglrDrhaZ7yj50FVxlcio2xJVNhM0r4k2imgv5KaRu4VqOMN
 SdWiBZnXQDZ8Y2uXvBXKU41UCWILg/AiBkYYzGCRk3xCCsJbS3
 mAizGC82wbsfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 11:14 +0100, Alexander Gordeev wrote: 
> Try to make reading of __schedule() bit more easy.

You didn't succeed in doing that for me.  Moving that code away just
obfuscates the special case for worker-bees scheduling off, and while
ttwu is shorthand for try_to_wake_up, uuwt is.. a lysdexic typo.

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  kernel/sched/core.c |   42 ++++++++++++++++++++++++------------------
>  1 files changed, 24 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 38413f6..dd54ded 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1272,6 +1272,27 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
>  		wq_worker_waking_up(p, cpu_of(rq));
>  }
>  
> +static void try_to_wake_up_local(struct task_struct *p);
> +
> +static void uwtt_deactivate(struct rq *rq, struct task_struct *p, int de_flags)
> +{
> +	deactivate_task(rq, p, de_flags);
> +	p->on_rq = 0;
> +
> +	/*
> +	 * If a worker went to sleep, notify and ask workqueue
> +	 * whether it wants to wake up a task to maintain
> +	 * concurrency.
> +	 */
> +	if (p->flags & PF_WQ_WORKER) {
> +		struct task_struct *to_wakeup;
> +
> +		to_wakeup = wq_worker_sleeping(p, cpu_of(rq));
> +		if (to_wakeup)
> +			try_to_wake_up_local(to_wakeup);
> +	}
> +}
> +
>  /*
>   * Mark the task runnable and perform wakeup-preemption.
>   */
> @@ -2907,25 +2928,10 @@ need_resched:
>  
>  	switch_count = &prev->nivcsw;
>  	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
> -		if (unlikely(signal_pending_state(prev->state, prev))) {
> +		if (unlikely(signal_pending_state(prev->state, prev)))
>  			prev->state = TASK_RUNNING;
> -		} else {
> -			deactivate_task(rq, prev, DEQUEUE_SLEEP);
> -			prev->on_rq = 0;
> -
> -			/*
> -			 * If a worker went to sleep, notify and ask workqueue
> -			 * whether it wants to wake up a task to maintain
> -			 * concurrency.
> -			 */
> -			if (prev->flags & PF_WQ_WORKER) {
> -				struct task_struct *to_wakeup;
> -
> -				to_wakeup = wq_worker_sleeping(prev, cpu);
> -				if (to_wakeup)
> -					try_to_wake_up_local(to_wakeup);
> -			}
> -		}
> +		else
> +			uwtt_deactivate(rq, prev, DEQUEUE_SLEEP);
>  		switch_count = &prev->nvcsw;
>  	}
>  
> -- 
> 1.7.7.6
> 
> 


