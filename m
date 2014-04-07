Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaDGIQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 04:16:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39486 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaDGIQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:16:54 -0400
Date: Mon, 7 Apr 2014 10:16:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Sasha Levin <sasha.levin@oracle.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mgorman@suse.com, akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [tip:sched/core] sched/numa: Move task_numa_free() to
 __put_task_struct()
Message-ID: <20140407081644.GD11096@twins.programming.kicks-ass.net>
References: <1393568591.6018.27.camel@marge.simpson.net>
 <tip-156654f491dd8d52687a5fbe1637f472a52ce75b@git.kernel.org>
 <5341A84C.4050902@oracle.com>
 <1396848585.5218.27.camel@marge.simpson.net>
 <1396855830.28539.10.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396855830.28539.10.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 09:30:30AM +0200, Mike Galbraith wrote:
> -	double_lock(&my_grp->lock, &grp->lock);
> +	BUG_ON(irqs_disabled());
> +	double_lock_irq(&my_grp->lock, &grp->lock);

So either make this:

	local_irq_disable();
	double_lock();

or

>  
>  	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
>  		my_grp->faults[i] -= p->numa_faults_memory[i];
> @@ -1692,6 +1693,7 @@ static void task_numa_group(struct task_
>  
>  	spin_unlock(&my_grp->lock);
>  	spin_unlock(&grp->lock);
> +	local_irq_enable();

use:
	spin_unlock()
	spin_unlock_irq()

or so, but this imbalance is making my itch :-)


>  
>  	rcu_assign_pointer(p->numa_group, grp);
>  
