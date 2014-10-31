Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaJaQmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:42:37 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46761 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaJaQmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:42:35 -0400
Date: Fri, 31 Oct 2014 09:42:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com,
        Clark Williams <clark.williams@gmail.com>
Subject: Re: [PATCH tip/core/rcu 4/7] rcu: Unify boost and kthread priorities
Message-ID: <20141031164229.GY5718@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141028222224.GA28263@linux.vnet.ibm.com>
 <1414534982-29203-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1414534982-29203-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20141029110146.GA3337@twins.programming.kicks-ass.net>
 <20141029161602.GT5718@linux.vnet.ibm.com>
 <20141031162210.GV23531@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031162210.GV23531@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14103116-0009-0000-0000-000005FE8B7C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 05:22:10PM +0100, Peter Zijlstra wrote:
> On Wed, Oct 29, 2014 at 09:16:02AM -0700, Paul E. McKenney wrote:
> 
> > > Also, should we look at running this stuff as deadline in order to
> > > provide interference guarantees etc.. ?
> > 
> > Excellent question!  I have absolutely no idea what the answer might be.
> > 
> > Taking the two sets of kthreads separately...
> > 
> > rcub/N:	This is for RCU priority boosting.  In the preferred common case,
> > 	these never wake up ever.  When they do wake up, all they do is
> > 	cause blocked RCU readers to get priority boosted.   I vaguely
> > 	recall something about inheritance of deadlines, which might
> > 	work here.  One concern is what happens if the deadline is
> > 	violated, as this isn't really necessarily an error condition
> > 	in this case -- we don't know how long the RCU read-side critical
> > 	section will run once awakened.
> 
> Yea, this one is 'hard'. How is this used today? From the previous email
> we've learnt that the default is FIFO-1, iow. it will preempt
> SCHED_OTHER but not much more. How is this used in RT systems, what are
> the criteria for actually changing this?

The old way is to update CONFIG_RCU_BOOST_PRIO and rebuild your kernel,
but a recent commit from Clark Williams provides a boot parameter that
allows this priority to be changed more conveniently.

> Increase until RCU stops spilling stalled warns, but not so far that
> your workload fails?

Well, you are supposed to determine the highest RT priority at which
your workload might run CPU-bound tasks, and set the boost priority
at some level above that.  My model of RCU priority boosting is that
it should be used to make inadvertent high-priority infinite loops
easier to debug, but others might have different approaches.

> Not quite sure how to translate that into dl speak :-), the problem of
> course is that if a DL task starts to trigger the stalls we need to do
> something.

Indeed!  ;-)

> > rcuc/N: This is the softirq replacement in -rt, but in mainline all it
> > 	does is invoke RCU callbacks.	It might make sense to give it a
> > 	deadline of something like a few milliseconds, but we would need
> > 	to temper that if there were huge numbers of callbacks pending.
> > 	Or perhaps have it claim that its "unit of work" was some fixed
> > 	number of callbacks or emptying the list, whichever came first.
> > 	Or maybe have its "unit of work" also depend on the number of
> > 	callbacks pending.
> 
> Right, so the problem is if we give it insufficient time it will never
> catch up on running the callbacks, ie. more will come in than we can
> process and get out.

Yep, which can result in OOM.

> So if it works by splicing a callback list to a local list, then runs
> until completion and then either immediately starts again if there's
> new work, or goes to sleep waiting for more, _then_ we can already
> assign it DL parameters with the only caveat being the above issue.
> 
> The advantage being indeed that if there are 'many' callbacks pending,
> we'd only run a few, sleep, run a few more, etc.. due to the CBS until
> we're done. This smooths out peak interference at the 'cost' of
> additional delays in actually running the callbacks.
> 
> We should be able to detect the case where more and work piles on and
> the actual running does not appear to catch up, but I'm not sure what to
> do about it, seeing how system stability is at risk.

I could imagine having a backup SCHED_FIFO task that handled the
case where callbacks were piling up, but synchronizing it with the
SCHED_DEADLINE task while avoiding callback misordering could be a bit
"interesting".  (Recall that callback misordering messes up rcu_barrier().)

> Certainly something to think about..

No argument here!  ;-)

							Thanx, Paul

