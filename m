Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126AbaC1GMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 02:12:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:27724 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaC1GMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 02:12:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,749,1389772800"; 
   d="scan'208";a="481932045"
Date: Fri, 28 Mar 2014 06:13:20 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "morten.rasmussen@arm.com" <morten.rasmussen@arm.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Cox, Alan" <alan.cox@intel.com>
Subject: Re: [RFC II] Splitting scheduler into two halves
Message-ID: <20140327221320.GA26843@intel.com>
References: <20140326183721.GC24116@intel.com>
 <1395896233.5512.45.camel@marge.simpson.net>
 <20140327072511.GA2555@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140327072511.GA2555@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I should have changed the subject to "Refining the load balancing interfaces".
Spitting does feel brutal or too big a jump for now. But i doubt that would
change your mind anyway.

Overall, I interpret your comment as: calling for substantial stuff. Yay,
working on it.

Thanks,
Yuyang

On Thu, Mar 27, 2014 at 03:25:11PM +0800, Ingo Molnar wrote:
> 
> * Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> 
> > On Thu, 2014-03-27 at 02:37 +0800, Yuyang du wrote: 
> > > Hi all,
> > > 
> > > This is continued after the first RFC about splitting the scheduler. Still
> > > work-in-progress, and call for feedback.
> > > 
> > > The question addressed here is how load balance should be changed. And I think
> > > the question then goes to how to *reuse* common code as much as possible and
> > > meanwhile be able to serve various objectives.
> > > 
> > > So these are the basic semantics needed in current load balance:
> > 
> > I'll probably regret it, but I'm gonna speak my mind.  I think this 
> > two halves concept is fundamentally broken.
> 
> As PeterZ pointed it out in the previous discussion, this approach, 
> besides being fundamentally broken, also gives no valid technical 
> rationale given for the change.
> 
> Firstly, I'd like to stress it that we are not against abstraction and 
> interfaces within the scheduler (at all!) - we already have a 'split' 
> and use interfaces between 'scheduler classes':
> 
> struct sched_class {
> 	const struct sched_class *next;
> 
> 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
> 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
> 	void (*yield_task) (struct rq *rq);
> 	bool (*yield_to_task) (struct rq *rq, struct task_struct *p, bool preempt);
> 
> 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
> 
> 	/*
> 	 * It is the responsibility of the pick_next_task() method that will
> 	 * return the next task to call put_prev_task() on the @prev task or
> 	 * something equivalent.
> 	 *
> 	 * May return RETRY_TASK when it finds a higher prio class has runnable
> 	 * tasks.
> 	 */
> 	struct task_struct * (*pick_next_task) (struct rq *rq,
> 						struct task_struct *prev);
> 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
> 
> #ifdef CONFIG_SMP
> 	int  (*select_task_rq)(struct task_struct *p, int task_cpu, int sd_flag, int flags);
> 	void (*migrate_task_rq)(struct task_struct *p, int next_cpu);
> 
> 	void (*post_schedule) (struct rq *this_rq);
> 	void (*task_waking) (struct task_struct *task);
> 	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
> 
> 	void (*set_cpus_allowed)(struct task_struct *p,
> 				 const struct cpumask *newmask);
> 
> 	void (*rq_online)(struct rq *rq);
> 	void (*rq_offline)(struct rq *rq);
> #endif
> 
> 	void (*set_curr_task) (struct rq *rq);
> 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
> 	void (*task_fork) (struct task_struct *p);
> 	void (*task_dead) (struct task_struct *p);
> 
> 	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
> 	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
> 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
> 			     int oldprio);
> 
> 	unsigned int (*get_rr_interval) (struct rq *rq,
> 					 struct task_struct *task);
> 
> #ifdef CONFIG_FAIR_GROUP_SCHED
> 	void (*task_move_group) (struct task_struct *p, int on_rq);
> #endif
> };
> 
> So where it makes sense we make use of this programming technique, to 
> the extent it is helpful.
> 
> But interfaces and abstraction has a cost, and the justification given 
> in this submission looks very weak to me. There's no justification 
> given in this specific submission, the closest I could find was in the 
> first submission:
> 
> > > With the advent of more cores and heterogeneous architectures, the 
> > > scheduler is required to be more complex (power efficiency) and 
> > > diverse (big.little). For the scheduler to address that challenge 
> > > as a whole, it is costly but not necessary. This proposal argues 
> > > that the scheduler be spitted into two parts: top half (task 
> > > scheduling) and bottom half (load balance). Let the bottom half 
> > > take charge of the incoming requirements.
> 
> That is just way too generic with no specific technical benefits 
> listed. No cost/benefit demonstrated.
> 
> If there's any advantage to a 'split', then it must be expressable via 
> one or more of these positive attributes:
> 
>  - better numbers (better performance, etc.)
>  - reduced code
>  - new features
> 
> A split alone, without making active and convincing use of it, is 
> inadequate.
> 
> So without a much better rationale, demonstrated via actual, real 
> working code that not only does the split but also makes real use of 
> every aspect of the proposed abstraction interfaces, which 
> demonstrates that the proposed 'split' is the most sensible way 
> forward, this specific submission earns a NAK from me.
> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
