Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952AbaJ3PBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:01:12 -0400
Received: from relay.parallels.com ([195.214.232.42]:36565 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760505AbaJ3PBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:01:11 -0400
Message-ID: <1414681265.8574.83.camel@tkhai>
Subject: Re: [PATCH v2 1/6] sched/rt: check if curr can be pushed/pulled
 somewhere else in advance
From: Kirill Tkhai <ktkhai@parallels.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@arm.com>, <juri.lelli@gmail.com>,
        <linux-kernel@vger.kernel.org>
Date: Thu, 30 Oct 2014 18:01:05 +0300
In-Reply-To: <1414678623-13576-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1414678623-13576-1-git-send-email-wanpeng.li@linux.intel.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

В Чт, 30/10/2014 в 22:16 +0800, Wanpeng Li пишет:
> This patch checks if current can be pushed/pulled somewhere else 
> in advance to make logic clear, the same behavior as rt class.
> 
> - If current can't be migrated, useless to reschedule, let's hope 
>   task can move out.
> - If task is migratable, so let's not schedule it and see if it 
>   can be pushed or pulled somewhere else.

No functional changes, are they? So I'd suggest to change subject
on something connected with "cleanup".

Also, the description confuses. Please, write that code was cleaned
up, and that comments were added.

> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  kernel/sched/rt.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index d024e6c..a0b51aa 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1351,16 +1351,22 @@ out:
>  
>  static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
>  {
> -	if (rq->curr->nr_cpus_allowed == 1)
> +	/*
> +	 * Current can't be migrated, useless to reschedule,
> +	 * let's hope p can move out.
> +	 */
> +	if (rq->curr->nr_cpus_allowed == 1 ||
> +		!cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
>  		return;

All conditions of multi-line if() should be aligned the same:

+	if (rq->curr->nr_cpus_allowed == 1 ||
+	    !cpupri_find(&rq->rd->cpupri, rq->curr, NULL))

>  
> +	/*
> +	 * p is migratable, so let's not schedule it and
> +	 * see if it is pushed or pulled somewhere else.
> +	 */
>  	if (p->nr_cpus_allowed != 1
>  	    && cpupri_find(&rq->rd->cpupri, p, NULL))
>  		return;
>  
> -	if (!cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
> -		return;
> -
>  	/*
>  	 * There appears to be other cpus that can accept
>  	 * current and none to run 'p', so lets reschedule

Thanks,
Kirill


