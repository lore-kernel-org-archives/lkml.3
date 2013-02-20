Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab3BTIqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:46:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44141 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3BTIqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:46:32 -0500
Message-ID: <1361349985.10155.1.camel@laptop>
Subject: Re: [PATCH] sched: Skip looking at skip if next or last is set
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>
Date: Wed, 20 Feb 2013 09:46:25 +0100
In-Reply-To: <20130218130146.GA7472@linux.vnet.ibm.com>
References: <20130218130146.GA7472@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 18:31 +0530, Srikar Dronamraju wrote:
> pick_next_entity() prefers next, then last. However code checks if the
> left entity can be skipped even if next / last is set.
> 
> Check if left entity should be skipped only if next/last is not set.

You fail to explain why its a problem and continue to make a horrid mess
of the code..

> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
>  kernel/sched/fair.c |   31 +++++++++++++++----------------
>  1 files changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index fdee793..cc97b12 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1900,27 +1900,26 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
>  	struct sched_entity *left = se;
>  
>  	/*
> -	 * Avoid running the skip buddy, if running something else can
> -	 * be done without getting too unfair.
> +	 * Someone really wants next to run. If it's not unfair, run it.
>  	 */
> -	if (cfs_rq->skip == se) {
> -		struct sched_entity *second = __pick_next_entity(se);
> +	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
> +		se = cfs_rq->next;
> +	} else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1) {
> +		/*
> +		 * Prefer last buddy, try to return the CPU to a preempted
> +		 * task.
> +		 */
> +		se = cfs_rq->last;
> +	} else if (cfs_rq->skip == left) {
> +		/*
> +		 * Avoid running the skip buddy, if running something else
> +		 * can be done without getting too unfair.
> +		 */
> +		struct sched_entity *second = __pick_next_entity(left);
>  		if (second && wakeup_preempt_entity(second, left) < 1)
>  			se = second;
>  	}
>  
> -	/*
> -	 * Prefer last buddy, try to return the CPU to a preempted task.
> -	 */
> -	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
> -		se = cfs_rq->last;
> -
> -	/*
> -	 * Someone really wants this to run. If it's not unfair, run it.
> -	 */
> -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
> -		se = cfs_rq->next;
> -
>  	clear_buddies(cfs_rq, se);
>  
>  	return se;
> 


