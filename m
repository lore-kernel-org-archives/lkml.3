Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101AbaHBW6G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 18:58:06 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49276 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaHBW6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 18:58:04 -0400
Date: Sat, 2 Aug 2014 15:57:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140802225757.GB8101@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140802145616.GA18195@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140802145616.GA18195@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080222-1344-0000-0000-00000336B0A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 04:56:16PM +0200, Oleg Nesterov wrote:
> On 07/31, Paul E. McKenney wrote:
> >
> > +		rcu_read_lock();
> > +		for_each_process_thread(g, t) {
> > +			if (t != current && ACCESS_ONCE(t->on_rq) &&
> > +			    !is_idle_task(t)) {
> 
> I didn't notice this check before, but it is not needed. for_each_process()
> can see the idle threads, there are not on process/thread lists.

Good to know.  Any other important tasks I am missing?

I am guessing that I need to do something like this:

	for_each_process(g) {
		/* Do build step. */
		for_each_thread(g, t) {
			if (g == t)
				continue;
			/* Do build step. */
		}
	}

Or is there a better way to handle this?

> But this doesn't really matter, the main problem is that I still think that
> for_each_process_thread() can't really work anyway.

Your point about exiting tasks I get, and I believe I can solve it.
I am hoping that the above sort of construction takes care of the
idle threads.  I might also need to do something to handle changes in
process/thread hierarchy -- but hopefully without having to read-acquire
the task-list lock.

So what else am I missing?

							Thanx, Paul

