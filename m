Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbaHAS2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 14:28:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39901 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHAS2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:28:45 -0400
Date: Fri, 1 Aug 2014 11:28:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140801182837.GI4784@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140801141144.GA30293@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801141144.GA30293@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080118-6688-0000-0000-000003B55579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 04:11:44PM +0200, Oleg Nesterov wrote:
> On 07/31, Paul E. McKenney wrote:
> >
> > +/* Lists of tasks that we are still waiting for during this grace period. */
> > +static LIST_HEAD(rcu_tasks_holdouts);

Good point, fixed!

> This can be local var in rcu_tasks_kthread()
> 
> > +		while (!list_empty(&rcu_tasks_holdouts)) {
> > +			schedule_timeout_interruptible(HZ / 10);
> > +			flush_signals(current);
> 
> Still can't undestand why your paranoia wants flush_signals ;)
> This is unneeded and confusing. If you think we can have a bug here,
> then we should ot hide it, WARN_ON(signal_pending) would be better.
> And if you think signal_pending(current) is possible, why do you
> check this only after schedule_interruptible() ?

I can live with WARN_ON(signal_pending(current)).  Fixed!

> > +		synchronize_sched();
> > +
> > +		/* Invoke the callbacks. */
> > +		while (list) {
> > +			next = list->next;
> > +			local_bh_disable();
> > +			list->func(list);
> > +			local_bh_enable();
> > +			list = next;
> > +			cond_resched();
> > +		}
> 
> Not sure this makes any sense, but perhaps we can check for the new
> callbacks and start the next gp. IOW, the main loop roughly does
> 
> 	for (;;) {
> 		list = rcu_tasks_cbs_head;
> 		rcu_tasks_cbs_head = NULL;
> 
> 		if (!list)
> 			sleep();
> 
> 		synchronize_sched();
> 
> 		wait_for_rcu_tasks_holdout();
> 
> 		synchronize_sched();
> 
> 		process_callbacks(list);
> 	}
> 
> we can "join" 2 synchronize_sched's and do
> 
> 	ready_list = NULL;
> 	for (;;) {
> 		list = rcu_tasks_cbs_head;
> 		rcu_tasks_cbs_head = NULL;
> 
> 		if (!list && !ready_list)
> 			sleep();
> 
> 		synchronize_sched();
> 
> 		if (ready_list) {
> 			process_callbacks(ready_list);
> 			ready_list = NULL;
> 		}
> 
> 		if (!list)
> 			continue;
> 
> 		wait_for_rcu_tasks_holdout();
> 		ready_list = list;
> 	}

The lack of barriers for the updates I am checking mean that I really
do need a synchronize_sched() on either side of the grace-period wait.
The grace period needs to guarantee that anything that happened on any
CPU before the start of the grace period happens before anything that
happens on any CPU after the end of the grace period.  If I leave off
either synchronize_sched(), we lose this guarantee.

							Thanx, Paul

> Oleg.
> 

