Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaHMOH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:07:59 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57685 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaHMOH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:07:57 -0400
Date: Wed, 13 Aug 2014 07:07:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v5 tip/core/rcu 14/16] rcu: Remove redundant
 preempt_disable() from rcu_note_voluntary_context_switch()
Message-ID: <20140813140751.GT4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-14-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813105618.GI9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813105618.GI9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081314-1344-0000-0000-0000036F90DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 12:56:18PM +0200, Peter Zijlstra wrote:
> On Mon, Aug 11, 2014 at 03:49:03PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > In theory, synchronize_sched() requires a read-side critical section to
> > order against.  In practice, preemption can be thought of as being
> > disabled across every machine instruction.  So this commit removes
> > the redundant preempt_disable() from rcu_note_voluntary_context_switch().
> 
> >  #define rcu_note_voluntary_context_switch(t) \
> >  	do { \
> > -		preempt_disable(); /* Exclude synchronize_sched(); */ \
> >  		if (ACCESS_ONCE((t)->rcu_tasks_holdout)) \
> >  			ACCESS_ONCE((t)->rcu_tasks_holdout) = 0; \
> > -		preempt_enable(); \
> >  	} while (0)
> 
> But that's more than 1 instruction.

Yeah, the commit log could use some help.  The instruction in question
is the store.  The "if" is just an optimization.

So suppose that this sequence is preempted between the "if" and the store,
and that the synchronize_sched() (and quite a bit more besides!) takes
place during this preemption.  The task is still in a quiescent state
at the time of the store, so the store is still legitimate.

That said, it might be better to just leave preemption disabled, as that
certainly makes things simpler.  Thoughts?

							Thanx, Paul

