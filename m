Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaFWKw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 06:52:26 -0400
Received: from relay.parallels.com ([195.214.232.42]:50049 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaFWKwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 06:52:24 -0400
Message-ID: <1403520738.3462.11.camel@tkhai>
Subject: Re: [PATCH 3/3] sched: Rework check_for_tasks()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        <tkhai@yandex.ru>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "Mike Galbraith" <umgwanakikbuti@gmail.com>,
        Konstantin Khorenko <khorenko@parallels.com>
Date: Mon, 23 Jun 2014 14:52:18 +0400
In-Reply-To: <20140623102457.GW19860@laptop.programming.kicks-ass.net>
References: <20140617130442.29933.54945.stgit@tkhai>
	 <1403011462.27674.46.camel@tkhai>
	 <20140623102457.GW19860@laptop.programming.kicks-ass.net>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Пн, 23/06/2014 в 12:24 +0200, Peter Zijlstra пишет:
> On Tue, Jun 17, 2014 at 05:24:22PM +0400, Kirill Tkhai wrote:
> > 
> > 1)Iterate throw all of threads in the system.
> 
> 	thru

Thanks :)

> 
> >   Check for all threads, not only for group leaders.
> > 
> > 2)Check for p->on_rq instead of p->state and cputime.
> >   Preempted task in !TASK_RUNNING state  OR just
> >   created task may be queued, that we want to be
> >   reported too.
> > 
> > 3)Use read_lock() instead of write_lock().
> >   This function does not change any structures, and
> >   read_lock() is enough.
> > 
> > Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> > CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > CC: Mike Galbraith <umgwanakikbuti@gmail.com>
> > CC: Peter Zijlstra <peterz@infradead.org>
> > CC: Ingo Molnar <mingo@kernel.org>
> > ---
> >  kernel/cpu.c |   33 ++++++++++++++++++++-------------
> >  1 file changed, 20 insertions(+), 13 deletions(-)
> > 
> > diff --git a/kernel/cpu.c b/kernel/cpu.c
> > index a343bde..81e2a38 100644
> > --- a/kernel/cpu.c
> > +++ b/kernel/cpu.c
> > @@ -274,21 +274,28 @@ void clear_tasks_mm_cpumask(int cpu)
> >  	rcu_read_unlock();
> >  }
> >  
> > -static inline void check_for_tasks(int cpu)
> > +static inline void check_for_tasks(int dead_cpu)
> >  {
> > -	struct task_struct *p;
> > -	cputime_t utime, stime;
> > +	struct task_struct *g, *p;
> >  
> > -	write_lock_irq(&tasklist_lock);
> > -	for_each_process(p) {
> > -		task_cputime(p, &utime, &stime);
> > -		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
> > -		    (utime || stime))
> > -			pr_warn("Task %s (pid = %d) is on cpu %d (state = %ld, flags = %x)\n",
> > -				p->comm, task_pid_nr(p), cpu,
> > -				p->state, p->flags);
> > -	}
> > -	write_unlock_irq(&tasklist_lock);
> > +	read_lock_irq(&tasklist_lock);
> > +	do_each_thread(g, p) {
> > +		if (!p->on_rq)
> > +			continue;
> > +		/*
> > +		 * We do the check with unlocked task_rq(p)->lock.
> > +		 * Order the reading to do not warn about a task,
> > +		 * which was running on this cpu in the past, and
> > +		 * it's just been woken on another cpu.
> > +		 */
> > +		rmb();
> 
> 		smp_rmb();
> 
> > +		if (task_cpu(p) != dead_cpu)
> > +			continue;
> 
> But because we don't have rq->lock held, we can be in the middle of a
> wakeup and miss a task.
> 
> Then again, I suppose anything without rq->lock can and will miss tasks.

If we use rq->lock it's possible to move check_for_tasks() to kernel/sched/core.c.

And we can leave TASK_RUNNING check for waking tasks. Maybe something like this?

static inline void check_for_tasks(int dead_cpu)
{
	struct task_struct *g, *p;
	struct rq *rq = cpu_rq(dead_cpu);

	read_lock_irq(&tasklist_lock);
	raw_spin_lock(&rq->lock)

	do_each_thread(g, p) {
		if (!p->on_rq && p->state != TASK_RUNNING)
			continue;
		if (task_cpu(p) != dead_cpu)
			continue;

		pr_warn("Task %s (pid=%d) is on cpu %d (state=%ld, flags=%x)\n",
			p->comm, task_pid_nr(p), dead_cpu, p->state, p->flags);
	} while_each_thread(g, p);

	raw_spin_unlock(&rq->lock)
	read_unlock_irq(&tasklist_lock);
}

It still does not give a 100% guarantee... Should we take p->pi_lock for every task?

> > +		pr_warn("Task %s (pid=%d) is on cpu %d (state=%ld, flags=%x)\n",
> > +			p->comm, task_pid_nr(p), dead_cpu, p->state, p->flags);
> > +	} while_each_thread(g, p);
> > +	read_unlock_irq(&tasklist_lock);
> >  }
> >  
> >  struct take_cpu_down_param {
> > 
> > 
> > 

Regards,
Kirill


