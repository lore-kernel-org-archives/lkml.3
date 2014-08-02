Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaHBWuv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 18:50:51 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59112 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaHBWuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 18:50:50 -0400
Date: Sat, 2 Aug 2014 15:50:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140802225043.GA8101@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140801185753.GC10718@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801185753.GC10718@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080222-0928-0000-0000-000003CE161A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 08:57:53PM +0200, Oleg Nesterov wrote:
> On 07/31, Paul E. McKenney wrote:
> >
> > +		rcu_read_lock();
> > +		for_each_process_thread(g, t) {
> > +			if (t != current && ACCESS_ONCE(t->on_rq) &&
> > +			    !is_idle_task(t)) {
> > +				get_task_struct(t);
> > +				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
> > +				ACCESS_ONCE(t->rcu_tasks_holdout) = 1;
> > +				list_add(&t->rcu_tasks_holdout_list,
> > +					 &rcu_tasks_holdouts);
> > +			}
> > +		}
> > +		rcu_read_unlock();
> 
> So let me repeat. for_each_process_thread() above can not (in general) see
> the exiting tasks which have already called exit_notify(), because such a
> task can be removed from rcu lists at any time.
> 
> Now suppose that proc_exit_connector() is probed. Or another function which
> can be called after exit_notify(), this doesn't matter.
> 
> An exiting task T jumps into trampoline and gets the preemption. It can be
> already (auto)reaped and removed from rcu lists.
> 
> synchronize_rcu_tasks() can not see this task, so it can return before T gets
> a chance to resume.

Good catch!!!

So it looks like I will need to hook into do_exit() after all.  Oh well,
can't have everything...

							Thanx, Paul

