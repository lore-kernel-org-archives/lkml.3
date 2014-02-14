Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaBNQJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:09:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48797 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBNQJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:09:33 -0500
Date: Fri, 14 Feb 2014 17:09:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: Subject: Warning in workqueue.c
Message-ID: <20140214160923.GK27965@twins.programming.kicks-ass.net>
References: <52F4F01C.1070800@linux.vnet.ibm.com>
 <20140207165113.GD3304@htj.dyndns.org>
 <52F51E10.8050208@linux.vnet.ibm.com>
 <20140207193604.GA8833@htj.dyndns.org>
 <52F8F0FB.3080206@linux.vnet.ibm.com>
 <20140210231742.GK25350@mtj.dyndns.org>
 <52FB90C6.4010701@linux.vnet.ibm.com>
 <52FC3C83.8020303@cn.fujitsu.com>
 <52FD07B2.5080402@linux.vnet.ibm.com>
 <20140213204102.GC17608@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213204102.GC17608@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 03:41:02PM -0500, Tejun Heo wrote:
> Hello,
> 
> (cc'ing Ingo and Peter)
> 
> On Thu, Feb 13, 2014 at 12:58:10PM -0500, Jason J. Herne wrote:
> > [ 5779.795687] ------------[ cut here ]------------
> > [ 5779.795695] WARNING: at kernel/workqueue.c:2159
> ....
> > [ 5779.795844] XXX: worker->flags=0x1 pool->flags=0x0 cpu=4 pool->cpu=5(1) rescue_wq=          (null)
> > [ 5779.795848] XXX: last_unbind=-44 last_rebind=0 last_rebound_clear=0 nr_exected_after_rebound_clear=0
> > [ 5779.795852] XXX: sleep=-39 wakeup=0
> > [ 5779.795855] XXX: cpus_allowed=5
> > [ 5779.795857] XXX: cpus_allowed_after_rebinding=5
> > [ 5779.795861] XXX: after schedule(), cpu=4
> > 
> > You had asked about reproducing this. This is on the S390 platform,
> > I'm not sure if that makes any difference.
> > 
> > The workload is:
> > 2 processes onlining random cpus in a tight loop by using 'echo 1 > /sys/bus/cpu.../online'
> > 2 processes offlining random cpus in a tight loop by using 'echo 0 > /sys/bus/cpu.../online'
> > Otherwise, fairly idle system. load average: 5.82, 6.27, 6.27
> > 
> > The machine has 10 processors.
> > The warning message some times hits within a few minutes on starting
> > the workload. Other times it takes several hours.
> 
> Ingo, Peter, Jason is reporting workqueue triggering warning because a
> worker is running on the wrong CPU, which is relatively reliably
> reproducible with the above workload on s390. 

Wasn't that a feature of workqueues? You know we've had arguments about
that behaviour -- I'm strongly in favour of flushing and killing workers
on unplug, but you let them run on the wrong cpu.

So strongly in fact, I'd call the current behaviour quite insane and
broken :-)

> The weird thing is that
> everything looks correct from workqueue side.  The worker has proper
> cpus_allowed set and the CPU it's supposed to run on is online and yet
> the worker is on the wrong CPU and even doing explicit schedule()
> after detecting the condition doesn't change the situation.

Yeah, just calling schedule() won't fix placement, you need to actually
block and wake-up. But given you've called things like
set_cpus_allowed_ptr() and such to set the mask back to 5..

You can try something like the below which makes it slightly more
aggressive about moving tasks about.

> Any ideas?

Not really; s390 doesn't have NUMA, so all those changes are out.

---
 kernel/sched/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fb9764fbc537..20bd4de44bb3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4504,7 +4504,8 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 
 	rq = task_rq_lock(p, &flags);
 
-	if (cpumask_equal(&p->cpus_allowed, new_mask))
+	if (cpumask_equal(&p->cpus_allowed, new_mask) && 
+	    cpumask_test_cpu(rq->cpu, &p->cpus_allowed))
 		goto out;
 
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {

