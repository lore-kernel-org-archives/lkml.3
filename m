Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbaGVN2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:28:03 -0400
Received: from relay.parallels.com ([195.214.232.42]:46035 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbaGVNUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:20:52 -0400
Message-ID: <1406035239.3526.66.camel@tkhai>
Subject: Re: [PATCH 2/5] sched: Teach scheduler to understand ONRQ_MIGRATING
 state
From: Kirill Tkhai <ktkhai@parallels.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        <tkhai@yandex.ru>, Oleg Nesterov <oleg@redhat.com>
Date: Tue, 22 Jul 2014 17:20:39 +0400
In-Reply-To: <20140722082510.0086dd67@gandalf.local.home>
References: <20140722102425.29682.24086.stgit@tkhai>
	 <1406028616.3526.20.camel@tkhai>
	 <20140722114542.GG20603@laptop.programming.kicks-ass.net>
	 <20140722082510.0086dd67@gandalf.local.home>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вт, 22/07/2014 в 08:25 -0400, Steven Rostedt пишет:
> On Tue, 22 Jul 2014 13:45:42 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
>  
> > > @@ -1491,10 +1491,14 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
> > >  static void
> > >  ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
> > >  {
> > > -	check_preempt_curr(rq, p, wake_flags);
> > >  	trace_sched_wakeup(p, true);
> > >  
> > >  	p->state = TASK_RUNNING;
> > > +
> > > +	if (!task_queued(p))
> > > +		return;
> > 
> > How can this happen? we're in the middle of a wakeup, we're just added
> > the task to the rq and are still holding the appropriate rq->lock.
> 
> I believe it can be in the migrating state. A comment would be useful
> here.

Sure, I'll update. Stupid question: should I resend all series or one message
in this thread is enough?

> 
> > > @@ -4623,9 +4629,14 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
> > >  	struct rq *rq;
> > >  	unsigned int dest_cpu;
> > >  	int ret = 0;
> > > -
> > > +again:
> > >  	rq = task_rq_lock(p, &flags);
> > >  
> > > +	if (unlikely(p->on_rq) == ONRQ_MIGRATING) {
> > > +		task_rq_unlock(rq, p, &flags);
> > > +		goto again;
> > > +	}
> > > +
> > >  	if (cpumask_equal(&p->cpus_allowed, new_mask))
> > >  		goto out;
> > >  
> > 
> > That looks like a non-deterministic spin loop, 'waiting' for the
> > migration to finish. Not particularly nice and something I think we
> > should avoid for it has bad (TM) worst case behaviour.
> 
> As this patch doesn't introduce the MIGRATING getting set yet, I'd be
> interested in this too. I'm assuming that the MIGRATING flag is only
> set and then cleared within an interrupts disabled section, such that
> the time is no more than a spinlock being taken.
> 
> I would also add a cpu_relax() there too.

Sadly, I did't completely understand what you mean. Could you please explain
what has to be changed?

(I see wrong unlikely() place. It's an error. Is the other thing that there
is no task_migrating() method?)


Thanks,
Kirill

