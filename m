Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbbAHPWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:22:43 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:57074 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbbAHPWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:22:42 -0500
Date: Thu, 8 Jan 2015 07:22:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu 01/14] rcu: Protect rcu_boost() lockless
 accesses with ACCESS_ONCE()
Message-ID: <20150108152230.GL5280@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150107173215.GA897@linux.vnet.ibm.com>
 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20150108094102.GD29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108094102.GD29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010815-0013-0000-0000-000007BB3DDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 10:41:02AM +0100, Peter Zijlstra wrote:
> On Wed, Jan 07, 2015 at 09:32:20AM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > This commit prevents random compiler optimizations by applying
> > ACCESS_ONCE() to lockless accesses.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcu/tree_plugin.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index 3ec85cb5d544..d59913ef8360 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -1127,7 +1127,8 @@ static int rcu_boost(struct rcu_node *rnp)
> >  	struct task_struct *t;
> >  	struct list_head *tb;
> >  
> > -	if (rnp->exp_tasks == NULL && rnp->boost_tasks == NULL)
> > +	if (ACCESS_ONCE(rnp->exp_tasks) == NULL &&
> > +	    ACCESS_ONCE(rnp->boost_tasks) == NULL)
> >  		return 0;  /* Nothing left to boost. */
> 
> Didn't we just obsolete ACCESS_ONCE with that {READ,WRITE}_ONCE stuff?

Indeed we did!  But that was after I did this commit back on October 29th.

I am planning a bulk change to READ_ONCE() and ASSIGN_ONCE() either as
the last patch for 3.20 or as the first one for 3.21.  Probably as the
first for 3.21 to minimize rebasing hassles with any needed 3.20 fixes.

							Thanx, Paul

