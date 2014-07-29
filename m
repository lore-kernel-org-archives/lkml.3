Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaG2Qg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:36:57 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44324 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaG2Qg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:36:56 -0400
Date: Tue, 29 Jul 2014 09:36:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140729163647.GS11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140729081211.GP20603@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729081211.GP20603@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072916-1344-0000-0000-000003202269
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 10:12:11AM +0200, Peter Zijlstra wrote:
> On Mon, Jul 28, 2014 at 03:56:12PM -0700, Paul E. McKenney wrote:
> > +		/*
> > +		 * Each pass through the following loop scans the list
> > +		 * of holdout tasks, removing any that are no longer
> > +		 * holdouts.  When the list is empty, we are done.
> > +		 */
> > +		while (!list_empty(&rcu_tasks_holdouts)) {
> > +			schedule_timeout_interruptible(HZ / 10);
> > +			flush_signals(current);
> > +			rcu_read_lock();
> > +			list_for_each_entry_rcu(t, &rcu_tasks_holdouts,
> > +						rcu_tasks_holdout_list) {
> > +				if (smp_load_acquire(&t->rcu_tasks_holdout))
> > +					continue;
> > +				list_del_init(&t->rcu_tasks_holdout_list);
> > +				/* @@@ need to check for usermode on CPU. */
> > +			}
> > +			rcu_read_unlock();
> > +		}
> 
> That's a potential CPU runtime sink.. imagine having to scan 100k tasks
> 10 times a second. Polling O(nr_tasks) is not good.

This only scans those tasks that are blocking the RCU-tasks grace period,
and this list should get shorter reasonably quickly as each task does
a voluntary context switch.

Of course, there is the do_each_thread() / while_each_thread() loop
that builds this list, and yes, that does look at each and every task,
as does the subsequent loop that waits for pre-existing partially exited
tasks to disappear from the list.  As noted in an earlier email, I am
taking Steven at his word when he said that updates are very infrequent
and that he doesn't care about the latency and overhead of the updates.

							Thanx, Paul

