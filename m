Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaHDLu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:50:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60097 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaHDLuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:50:55 -0400
Date: Mon, 4 Aug 2014 04:50:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140804115043.GA31903@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53DEE1CD.4000705@cn.fujitsu.com>
 <20140804074620.GH9918@twins.programming.kicks-ass.net>
 <53DF41ED.2020508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DF41ED.2020508@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080411-1542-0000-0000-000003BDD2A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 04:18:53PM +0800, Lai Jiangshan wrote:
> On 08/04/2014 03:46 PM, Peter Zijlstra wrote:
> > On Mon, Aug 04, 2014 at 09:28:45AM +0800, Lai Jiangshan wrote:
> >> On 08/01/2014 05:55 AM, Paul E. McKenney wrote:
> >>> +		rcu_read_lock();
> >>> +		for_each_process_thread(g, t) {
> >>> +			if (t != current && ACCESS_ONCE(t->on_rq) &&
> >>> +			    !is_idle_task(t)) {
> >>> +				get_task_struct(t);
> >>> +				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
> >>> +				ACCESS_ONCE(t->rcu_tasks_holdout) = 1;
> >>> +				list_add(&t->rcu_tasks_holdout_list,
> >>> +					 &rcu_tasks_holdouts);
> >>
> >> This loop will collect all the runnable tasks.  It is too much tasks.
> >> Is it possible to collect only on_cpu tasks or PREEMPT_ACTIVE tasks?
> >> It seems hard to achieve it.
> > 
> > Without taking the rq->lock you cannot do that race-free. And we're not
> > going to be taking rq->lock here.
> 
> It is because we can't fetch task->on_cpu and preempt_count atomically
> so that rq->lock is required.
> 
> 3 bleeding solutions:
> 
> 1) Allocate one bit in preempt_count to stand for not_on_cpu ( = !task->on_cpu)
> 2) allocate one bit in nvcsw to stand for on_scheduled (or not_on_scheduled, see next)
> 3) introduce task->on_scheduled whose semantics is between on_cpu and on_rq,
>    on_scheduled = scheduled on cpu or preempted, (not voluntary scheduled out)
> 
> But the scheduler doesn't need neither of such things.  So these is still no hope.

OK, I will bite...

What kinds of tasks are on a runqueue, but neither ->on_cpu nor
PREEMPT_ACTIVE?

							Thanx, Paul

