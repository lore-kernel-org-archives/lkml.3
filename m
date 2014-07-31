Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaGaQeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:34:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaGaQeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:34:13 -0400
Date: Thu, 31 Jul 2014 18:31:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 01/10] rcu: Add call_rcu_tasks()
Message-ID: <20140731163138.GA15228@redhat.com>
References: <20140731003914.GA3872@linux.vnet.ibm.com> <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com> <53D9F084.7000706@cn.fujitsu.com> <20140731160924.GR11241@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731160924.GR11241@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, sorry, I didn't read the patches yet, just noticed your discussion...

On 07/31, Paul E. McKenney wrote:
>
> On Thu, Jul 31, 2014 at 03:30:12PM +0800, Lai Jiangshan wrote:
>
> > > +				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
> > > +				t->rcu_tasks_holdout = 1;
> > > +				list_add(&t->rcu_tasks_holdout_list,
> > > +					 &rcu_tasks_holdouts);
> >
> > I think get_task_struct() is needed here to avoid the task disappears.
>
> Hmmm...  Let's see...
>
> Looks like get_task_struct() does a blind atomic increment of ->usage.
> And put_task_struct() does an atomic_dec_and_test().  So one question
> is "what prevents us from doing get_task_struct() after the final
> put_task_struct() has pushed ->usage down to zero?"
>
> Hopefully there is a grace period in there somewhere, otherwise it will
> be necessary to take the task-list lock, which I would like to avoid.
>
> Looks like the call_rcu() of delayed_put_task_struct() in release_task()
> might be doing this.

Yes, exactly, so get_task_struct() is always fine as long as task_struct
itself is protected by RCU.

But can't we avoid get_task_struct()? This can pin a lot of task_struct's.
Can't we just add list_del_rcu(holdout_list) into __unhash_process() ?

We only need to ensure that list_add() above can't race with that list_del(),
perhaps we can tolerate lock_task_sighand() ?

Oleg.

