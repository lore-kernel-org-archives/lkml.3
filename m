Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaG2Rbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:31:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44857 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaG2Rbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:31:35 -0400
Date: Tue, 29 Jul 2014 19:31:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140729173121.GL3935@laptop>
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140729075055.GY19379@twins.programming.kicks-ass.net>
 <20140729155747.GO11241@linux.vnet.ibm.com>
 <20140729160754.GW20603@laptop.programming.kicks-ass.net>
 <20140729163312.GR11241@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729163312.GR11241@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 09:33:12AM -0700, Paul E. McKenney wrote:
> > > o	There are no memory barriers, but a synchronize_sched()
> > > 	should take care of that, given that this counter is
> > > 	incremented with interrupts disabled.
> > 
> > Well, there's obviously the actual context switch, which should imply an
> > actual MB such that tasks are self ordered even when execution continues
> > on another cpu etc..
> 
> True enough, except that it appears that the context switch happens
> after the ->nvcsw increment, which means that it doesn't help RCU-tasks
> guarantee that if it has seen the increment, then all prior processing
> has completed.  There might be enough stuff prior the increment, but I
> don't see anything that I feel comfortable relying on.  Am I missing
> some ordering?

There's the smp_mb__before_spinlock() + raw_spin_lock_irq(), but that's
about it I suppose.

> > > So I should be able to snapshot the task_struct structure's ->nvcsw
> > > field and avoid the added code in the fastpaths.
> > > 
> > > Seem plausible, or am I confused about the role of ->nvcsw?
> > 
> > Nope, that's the 'I scheduled to go to sleep' counter.
> 
> I am assuming that the "Nope" goes with "am I confused" rather than
> "Seem plausible" -- if not, please let me know.  ;-)

Yah :-)

> > There is of course the 'polling' issue I raised in a further email...
> 
> Yep, and other flavors of RCU go to lengths to avoid scanning the
> task_struct lists.  Steven said that updates will be rare and that it
> is OK for them to have high latency and overhead.  Thus far, I am taking
> him at his word.  ;-)
> 
> I considered interrupting the task_struct polling loop periodically,
> and would add that if needed.  That said, this requires nailing down the
> task_struct at which the vacation is taken.  Here "nailing down" does not
> simply mean "prevent from being freed", but rather "prevent from being
> removed from the lists traversed by do_each_thread/while_each_thread."
> 
> Of course, if there is some easy way of doing this, please let me know!

Well, one reason I'm not liking this is because its in an anonymous
context (kthread) which makes accounting for it hard.

I feel we're doing far too much async stuff already and it keeps getting
worse and worse. Ideally we'd be able to account every cycle of kernel
'overhead' to a specific user action.

Another reason is that I fundamentally dislike polling stuff.. but yes,
I'm not really seeing how to do this differently, partly because I'm not
entirely sure why we need this to begin with. I'm not sure what problem
we're solving.
