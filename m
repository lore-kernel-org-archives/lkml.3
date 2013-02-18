Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab3BRI2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 03:28:36 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52614 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3BRI2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:28:35 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-72-5121e6304a9d
Date: Mon, 18 Feb 2013 17:28:43 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 01/15] sched: set initial value for runnable avg of
 sched entities.
Message-ID: <20130218082843.GA10009@lge.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
 <1361164062-20111-2-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361164062-20111-2-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alex.

On Mon, Feb 18, 2013 at 01:07:28PM +0800, Alex Shi wrote:
> We need initialize the se.avg.{decay_count, load_avg_contrib} to zero
> after a new task forked.
> Otherwise random values of above variables cause mess when do new task

I think that these are not random values. In arch_dup_task_struct(),
we do '*dst = *src', so, these values come from parent process. If we use
these value appropriately, we can anticipate child process' load easily.
So to initialize the load_avg_contrib to zero is not good idea for me.

Thanks.

> enqueue:
>     enqueue_task_fair
>         enqueue_entity
>             enqueue_entity_load_avg
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 26058d0..1743746 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1559,6 +1559,8 @@ static void __sched_fork(struct task_struct *p)
>  #if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
>  	p->se.avg.runnable_avg_period = 0;
>  	p->se.avg.runnable_avg_sum = 0;
> +	p->se.avg.decay_count = 0;
> +	p->se.avg.load_avg_contrib = 0;
>  #endif
>  #ifdef CONFIG_SCHEDSTATS
>  	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
> -- 
> 1.7.12
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
