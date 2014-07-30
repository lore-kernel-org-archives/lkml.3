Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaG3POP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:14:15 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36477 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbaG3POO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:14:14 -0400
Date: Wed, 30 Jul 2014 08:07:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140730150724.GK11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53D89639.5080405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D89639.5080405@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073015-3532-0000-0000-0000037F2295
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 02:52:41PM +0800, Lai Jiangshan wrote:
> On 07/29/2014 06:56 AM, Paul E. McKenney wrote:
> 
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
> 
> Maybe I missed something. The task @t may already exited and we access to
> the stale memory here if without patch 8/9.

Yep, patch 8/9 is not optional.

							Thanx, Paul

