Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995AbaJ2QQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:16:10 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:53391 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbaJ2QQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:16:08 -0400
Date: Wed, 29 Oct 2014 09:16:02 -0700
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
Message-ID: <20141029161602.GT5718@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141028222224.GA28263@linux.vnet.ibm.com>
 <1414534982-29203-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1414534982-29203-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20141029110146.GA3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029110146.GA3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102916-0025-0000-0000-000005B4FA0D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 12:01:46PM +0100, Peter Zijlstra wrote:
> On Tue, Oct 28, 2014 at 03:22:59PM -0700, Paul E. McKenney wrote:
> > From: Clark Williams <clark.williams@gmail.com>
> > 
> > Rename CONFIG_RCU_BOOST_PRIO to CONFIG_RCU_KTHREAD_PRIO and use this
> > value for both the per-CPU kthreads (rcuc/N) and the rcu boosting
> > threads (rcub/n).
> > 
> > Also, create the module_parameter rcutree.kthread_prio to be used on
> > the kernel command line at boot to set a new value (rcutree.kthread_prio=N).
> > 
> > Signed-off-by: Clark Williams <clark.williams@gmail.com>
> > [ paulmck: Ported to rcu/dev, applied Paul Bolle feedback. ]
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  Documentation/kernel-parameters.txt                |  6 ++++++
> >  init/Kconfig                                       | 23 +++++++++++-----------
> >  kernel/rcu/tree_plugin.h                           | 20 +++++++++----------
> >  .../selftests/rcutorture/configs/rcu/TREE03        |  2 +-
> >  .../selftests/rcutorture/doc/TREE_RCU-kconfig.txt  |  4 ++--
> >  5 files changed, 31 insertions(+), 24 deletions(-)
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index 7dbe5ec9d9cd..7d3b3328bf5c 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -2922,6 +2922,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  			quiescent states.  Units are jiffies, minimum
> >  			value is one, and maximum value is HZ.
> >  
> > +	rcutree.kthread_prio= 	 [KNL,BOOT]
> > +			Set the SCHED_FIFO priority of the RCU
> > +			per-CPU kthreads (rcuc/N). This value is also
> > +			used for the priority of the RCU boost threads
> > +			(rcub/N). Valid values are 1-99.
> > +
> 
> It would maybe be useful to mention the default?

Good point, fixed.  It now reads as follows:

	rcutree.kthread_prio= 	 [KNL,BOOT]
			Set the SCHED_FIFO priority of the RCU
			per-CPU kthreads (rcuc/N). This value is also
			used for the priority of the RCU boost threads
			(rcub/N). Valid values are 1-99 and the default
			is 1 (the least-favored priority).

> Also, should we look at running this stuff as deadline in order to
> provide interference guarantees etc.. ?

Excellent question!  I have absolutely no idea what the answer might be.

Taking the two sets of kthreads separately...

rcub/N:	This is for RCU priority boosting.  In the preferred common case,
	these never wake up ever.  When they do wake up, all they do is
	cause blocked RCU readers to get priority boosted.   I vaguely
	recall something about inheritance of deadlines, which might
	work here.  One concern is what happens if the deadline is
	violated, as this isn't really necessarily an error condition
	in this case -- we don't know how long the RCU read-side critical
	section will run once awakened.

rcuc/N: This is the softirq replacement in -rt, but in mainline all it
	does is invoke RCU callbacks.	It might make sense to give it a
	deadline of something like a few milliseconds, but we would need
	to temper that if there were huge numbers of callbacks pending.
	Or perhaps have it claim that its "unit of work" was some fixed
	number of callbacks or emptying the list, whichever came first.
	Or maybe have its "unit of work" also depend on the number of
	callbacks pending.

Thoughts?

							Thanx, Paul

