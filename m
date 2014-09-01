Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaIAQU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:20:59 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33058 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaIAQU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:20:57 -0400
Date: Mon, 1 Sep 2014 09:20:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu 11/15] rcu: Break more call_rcu() deadlock
 involving scheduler and perf
Message-ID: <20140901162049.GM5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140828182614.GA23877@linux.vnet.ibm.com>
 <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1409250394-25159-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140901112934.GH27892@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901112934.GH27892@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090116-6688-0000-0000-0000046EB7A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 01:29:34PM +0200, Peter Zijlstra wrote:
> On Thu, Aug 28, 2014 at 11:26:30AM -0700, Paul E. McKenney wrote:
> 
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index b6acb9340192..a1af86099a67 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -2121,16 +2121,23 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
> >  			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
> >  					    TPS("WakeEmpty"));
> >  		} else {
> > -			rdp->nocb_defer_wakeup = true;
> > +			rdp->nocb_defer_wakeup = RCU_NOGP_WAKE;
> >  			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
> >  					    TPS("WakeEmptyIsDeferred"));
> >  		}
> >  		rdp->qlen_last_fqs_check = 0;
> >  	} else if (len > rdp->qlen_last_fqs_check + qhimark) {
> >  		/* ... or if many callbacks queued. */
> > -		wake_nocb_leader(rdp, true);
> > +		if (!irqs_disabled_flags(flags)) {
> > +			wake_nocb_leader(rdp, true);
> > +			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
> > +					    TPS("WakeOvf"));
> > +		} else {
> > +			rdp->nocb_defer_wakeup = RCU_NOGP_WAKE_FORCE;
> > +			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
> > +					    TPS("WakeOvfIsDeferred"));
> > +		}
> >  		rdp->qlen_last_fqs_check = LONG_MAX / 2;
> > -		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeOvf"));
> >  	} else {
> >  		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeNot"));
> >  	}
> 
> Is it possible for the RCU_NOCP_WAKE write to overwrite a WAKE_FORCE ?
> If not, why not? (Would make a good comment thereabouts).

Good point.

So RCU_NOGP_WAKE only happens on the empty-to-non-empty transition,
and that RCU_NOGP_WAKE_FORCE only happens once the queue has a large
number of entries (10,000 by default).  Because this code runs with irqs
disabled (and must because you can do call_rcu() from interrupt handlers),
RCU_NOGP_WAKE_FORCE could overwrite RCU_NOGP_WAKE, but not vice versa.

However, the same effect can be obtained by having the setting of
RCU_NOGP_WAKE_FORCE race with the call to do_nocb_deferred_wakeup().
However, this would require that the call to do_nocb_deferred_wakeup()
was delayed long enough for 9,999 additional callbacks be registered,
and the next 10,000 callbacks will do another RCU_NOGP_WAKE_FORCE.
In addition, the RCU_NOGP_WAKE_FORCE shortens delays in the rcuo kthreads
rather than waking a rcuo kthread that would otherwise sleep indefinitely.
So I didn't see the point of closing this window.

							Thanx, Paul

