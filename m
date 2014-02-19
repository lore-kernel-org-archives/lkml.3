Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaBSQRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:17:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34628 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaBSQRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:17:06 -0500
Date: Wed, 19 Feb 2014 17:16:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: fair: NULL ptr deref in check_preempt_wakeup
Message-ID: <20140219161657.GO15586@twins.programming.kicks-ass.net>
References: <52FFF7F8.2070801@oracle.com>
 <5301C41D.5000009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5301C41D.5000009@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 04:11:09PM +0800, Michael wang wrote:
> > While fuzzing with trinity inside a KVM tools guest running latest -next
> > kernel, I've
> > stumbled on the following:
> 
> I've reproduced the same issue with tip/master, and below patch fixed the
> problem on my box along with some rcu stall info disappeared, would you
> like to have a try?
> 
> BTW, I reproduced it by steps:
> 1. change current to RT
> 2. move to a different depth cpu-cgroup
> 3. change it back to FAIR
> 
> Seems like it was caused by that RT has no task_move_group() implemented
> which could maintain depth, and that lead to a wrong depth after switched
> back to FAIR...
> 
> Regards,
> Michael Wang
> 
> 
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 235cfa7..4445e56 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -7317,7 +7317,11 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
>   */
>  static void switched_to_fair(struct rq *rq, struct task_struct *p)
>  {
> -	if (!p->se.on_rq)
> +	struct sched_entity *se = &p->se;
> +#ifdef CONFIG_FAIR_GROUP_SCHED
> +	se->depth = se->parent ? se->parent->depth + 1 : 0;
> +#endif
> +	if (!se->on_rq)
>  		return;
>  
>  	/*


Michael, do you think you can send a proper patch for this?
