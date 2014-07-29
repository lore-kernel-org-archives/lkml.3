Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaG2Mid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:38:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33558 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaG2Mic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:38:32 -0400
Date: Tue, 29 Jul 2014 14:38:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>, linux-kernel@vger.kernel.org,
        nicolas.pitre@linaro.org, pjt@google.com, oleg@redhat.com,
        rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        tim.c.chen@linux.intel.com, mingo@kernel.org
Subject: Re: [PATCH v2 2/5] sched: Teach scheduler to understand
 ONRQ_MIGRATING state
Message-ID: <20140729123825.GB3935@laptop>
References: <20140726145508.6308.69121.stgit@localhost>
 <20140726145912.6308.32554.stgit@localhost>
 <20140728080122.GL6758@twins.programming.kicks-ass.net>
 <1406538338.23175.12.camel@tkhai>
 <1406627582.3600.9.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406627582.3600.9.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 01:53:02PM +0400, Kirill Tkhai wrote:
> From: Kirill Tkhai <ktkhai@parallels.com>
> 
>     sched: Teach scheduler to understand ONRQ_MIGRATING state
>     
>     This is new on_rq state for the cases when task is migrating
>     from one src_rq to another dst_rq, and there is no necessity
>     to have both RQs locked at the same time.
>     
>     We will use the state this way:
>     
>     	raw_spin_lock(&src_rq->lock);
>     	dequeue_task(src_rq, p, 0);
>     	p->on_rq = ONRQ_MIGRATING;
>     	set_task_cpu(p, dst_cpu);
>     	raw_spin_unlock(&src_rq->lock);
>     
>     	raw_spin_lock(&dst_rq->lock);
>     	p->on_rq = ONRQ_QUEUED;
>     	enqueue_task(dst_rq, p, 0);
>     	raw_spin_unlock(&dst_rq->lock);
>     
>     The profit is that double_rq_lock() is not needed now,
>     and this may reduce the latencies in some situations.

You forgot to explain how the spinning on task_migrated() is bounded and
thus doesn't make your beginning and end contradict itself.

>     Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 26aa7bc..00d7bcc 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -333,7 +333,8 @@ static inline struct rq *__task_rq_lock(struct task_struct *p)
>  	for (;;) {
>  		rq = task_rq(p);
>  		raw_spin_lock(&rq->lock);
> -		if (likely(rq == task_rq(p)))
> +		if (likely(rq == task_rq(p) &&
> +			   !task_migrating(p)))
>  			return rq;
>  		raw_spin_unlock(&rq->lock);
>  	}

I would prefer an extra spin-loop like so, that avoids us spinning on
the rq-lock, which serves no purpose.

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2676866b4394..1e65a0bdbbc3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -331,9 +331,12 @@ static inline struct rq *__task_rq_lock(struct task_struct *p)
 	lockdep_assert_held(&p->pi_lock);
 
 	for (;;) {
+		while (task_migrating(p))
+			cpu_relax();
+
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p) && !task_migrating(p)))
 			return rq;
 		raw_spin_unlock(&rq->lock);
 	}

> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index e5a9b6d..f6773d7 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -17,6 +17,7 @@ struct rq;
>  
>  /* .on_rq states of struct task_struct: */

The 'normal' way to write that is: task_struct::on_rq

>  #define ONRQ_QUEUED	1
> +#define ONRQ_MIGRATING	2
>  
>  extern __read_mostly int scheduler_running;
>  
