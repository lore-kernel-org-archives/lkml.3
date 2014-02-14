Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaBNQ0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:26:03 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:53007 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaBNQZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:25:59 -0500
Date: Fri, 14 Feb 2014 11:25:56 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: Subject: Warning in workqueue.c
Message-ID: <20140214162556.GF31544@htj.dyndns.org>
References: <20140207165113.GD3304@htj.dyndns.org>
 <52F51E10.8050208@linux.vnet.ibm.com>
 <20140207193604.GA8833@htj.dyndns.org>
 <52F8F0FB.3080206@linux.vnet.ibm.com>
 <20140210231742.GK25350@mtj.dyndns.org>
 <52FB90C6.4010701@linux.vnet.ibm.com>
 <52FC3C83.8020303@cn.fujitsu.com>
 <52FD07B2.5080402@linux.vnet.ibm.com>
 <20140213204102.GC17608@htj.dyndns.org>
 <20140214160923.GK27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214160923.GK27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Peter.

On Fri, Feb 14, 2014 at 05:09:23PM +0100, Peter Zijlstra wrote:
> > Ingo, Peter, Jason is reporting workqueue triggering warning because a
> > worker is running on the wrong CPU, which is relatively reliably
> > reproducible with the above workload on s390. 
> 
> Wasn't that a feature of workqueues? You know we've had arguments about
> that behaviour -- I'm strongly in favour of flushing and killing workers
> on unplug, but you let them run on the wrong cpu.
> 
> So strongly in fact, I'd call the current behaviour quite insane and
> broken :-)

Hey, we now even keep normal kthreads across cpu down/ups. :)

> Yeah, just calling schedule() won't fix placement, you need to actually
> block and wake-up. But given you've called things like
> set_cpus_allowed_ptr() and such to set the mask back to 5..

Hmmm... I see.  It's kinda weird that the code has been there for so
long and this is the first time it's getting reported.

> You can try something like the below which makes it slightly more
> aggressive about moving tasks about.
> 
> > Any ideas?
> 
> Not really; s390 doesn't have NUMA, so all those changes are out.
> 
> ---
>  kernel/sched/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index fb9764fbc537..20bd4de44bb3 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4504,7 +4504,8 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
>  
>  	rq = task_rq_lock(p, &flags);
>  
> -	if (cpumask_equal(&p->cpus_allowed, new_mask))
> +	if (cpumask_equal(&p->cpus_allowed, new_mask) && 
> +	    cpumask_test_cpu(rq->cpu, &p->cpus_allowed))
>  		goto out;
>  
>  	if (!cpumask_intersects(new_mask, cpu_active_mask)) {

Hmmm... weird, p's rq shouldn't have changed without its cpus_allowed
busted.  Anyways, let's wait for Jason's test results and see whether
this is a regression at all.

Thanks.

-- 
tejun
