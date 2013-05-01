Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848Ab3EALCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 07:02:35 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35175
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756263Ab3EALC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 07:02:27 -0400
Date: Wed, 1 May 2013 13:00:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kosaki.motohiro@gmail.com
Cc: linux-kernel@vger.kernel.org, Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 09/10] sched: task_sched_runtime introduce micro
 optimization
Message-ID: <20130501110047.GD28253@dyad.programming.kicks-ass.net>
References: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com>
 <1367291838-5490-10-git-send-email-kosaki.motohiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367291838-5490-10-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 11:17:17PM -0400, kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> rq lock in task_sched_runtime() is necessary for two reasons. 1)
> accessing se.sum_exec_runtime is inatomic on 32bit and 2)
> do_task_delta_exec() require it.
> 
> And then, 64bit can avoid holds rq lock when add_delta is false.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  kernel/sched/core.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b817e6d..24ba1c6 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2657,6 +2657,12 @@ unsigned long long task_sched_runtime(struct task_struct *p, bool add_delta)
>  	struct rq *rq;
>  	u64 ns = 0;
>  
> +	/* Micro optimization. */

Instead of the above; how about something like:

  /* 64-bit doesn't need locks to atomically read a 64bit value */

> +#ifdef CONFIG_64BIT
> +	if (!add_delta)
> +		return p->se.sum_exec_runtime;
> +#endif
> +
>  	rq = task_rq_lock(p, &flags);
>  	ns = p->se.sum_exec_runtime;
>  	if (add_delta)
> -- 
> 1.7.1
> 
