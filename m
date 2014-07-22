Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaGVMZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:25:22 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:40044 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754184AbaGVMZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:25:19 -0400
Date: Tue, 22 Jul 2014 08:25:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        tkhai@yandex.ru, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/5] sched: Teach scheduler to understand ONRQ_MIGRATING
 state
Message-ID: <20140722082510.0086dd67@gandalf.local.home>
In-Reply-To: <20140722114542.GG20603@laptop.programming.kicks-ass.net>
References: <20140722102425.29682.24086.stgit@tkhai>
	<1406028616.3526.20.camel@tkhai>
	<20140722114542.GG20603@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014 13:45:42 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

 
> > @@ -1491,10 +1491,14 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
> >  static void
> >  ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
> >  {
> > -	check_preempt_curr(rq, p, wake_flags);
> >  	trace_sched_wakeup(p, true);
> >  
> >  	p->state = TASK_RUNNING;
> > +
> > +	if (!task_queued(p))
> > +		return;
> 
> How can this happen? we're in the middle of a wakeup, we're just added
> the task to the rq and are still holding the appropriate rq->lock.

I believe it can be in the migrating state. A comment would be useful
here.

> 
> > @@ -4623,9 +4629,14 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
> >  	struct rq *rq;
> >  	unsigned int dest_cpu;
> >  	int ret = 0;
> > -
> > +again:
> >  	rq = task_rq_lock(p, &flags);
> >  
> > +	if (unlikely(p->on_rq) == ONRQ_MIGRATING) {
> > +		task_rq_unlock(rq, p, &flags);
> > +		goto again;
> > +	}
> > +
> >  	if (cpumask_equal(&p->cpus_allowed, new_mask))
> >  		goto out;
> >  
> 
> That looks like a non-deterministic spin loop, 'waiting' for the
> migration to finish. Not particularly nice and something I think we
> should avoid for it has bad (TM) worst case behaviour.

As this patch doesn't introduce the MIGRATING getting set yet, I'd be
interested in this too. I'm assuming that the MIGRATING flag is only
set and then cleared within an interrupts disabled section, such that
the time is no more than a spinlock being taken.

I would also add a cpu_relax() there too.

> 
> Also, why only this site and not all task_rq_lock() sites?

I'm assuming that its because set_cpus_allowed_ptr() is suppose to
return with the task already migrated to the CPUs it is allowed on, and
not before.

-- Steve
