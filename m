Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbaGXSMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:12:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58463 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759574AbaGXSM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:12:29 -0400
Date: Thu, 24 Jul 2014 11:12:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/16] rcu: Check for spurious wakeup using return value
Message-ID: <20140724181223.GO11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-12-git-send-email-bobby.prani@gmail.com>
 <20140723122608.GL11241@linux.vnet.ibm.com>
 <CAJhHMCC7_GLmBroGhKWMJJKuWqhojQGf=9So1_x4nb2adQvqFg@mail.gmail.com>
 <20140724034315.GJ11241@linux.vnet.ibm.com>
 <CAJhHMCDhwnKF5tiWvHyGrz3KhCab+QUnAfEmkzjsBrNn5O3gyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCDhwnKF5tiWvHyGrz3KhCab+QUnAfEmkzjsBrNn5O3gyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072418-0928-0000-0000-000003A46B6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 12:03:34AM -0400, Pranith Kumar wrote:
> On Wed, Jul 23, 2014 at 11:43 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Jul 23, 2014 at 10:36:19PM -0400, Pranith Kumar wrote:
> >> On Wed, Jul 23, 2014 at 8:26 AM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> > On Wed, Jul 23, 2014 at 01:09:48AM -0400, Pranith Kumar wrote:
> >> >> When the gp_kthread wakes up from the wait event, it returns 0 if the wake up is
> >> >> due to the condition having been met. This commit checks this return value
> >> >> for a spurious wake up before calling rcu_gp_init().
> >> >>
> >> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> >> >
> >> > How does this added check help?  I don't see that it does.  If the flag
> >> > is set, we want to wake up.  If we get a spurious wakeup, but then the
> >> > flag gets set before we actually wake up, we still want to wake up.
> >>
> >> So I took a look at the docs again, and using the return value is the
> >> recommended way to check for spurious wakeups.
> >>
> >> The condition in wait_event_interruptible() is checked when the task
> >> is woken up (either due to stray signals or explicitly) and it returns
> >> true if condition evaluates to true.
> 
> this should be returns '0' if the condition evaluates to true.

Ah, but if the condition changes while wait_event_interruptible() is in
the process of returning, it is quite possible that the answer will be
different afterwards.  For example, consider this scenario:

o	wait_event_interruptible() decides to return spuriously for
	whatever reason, and thus returns a non-zero value.

o	An invocation of (say) rcu_start_gp_advanced() sets ->gp_flags
	to RCU_GP_FLAG_INIT, thus requesting that a new grace period
	start.

o	At this point, the return value says that we should not start
	a new grace period, but the ->gp_flags value says that we
	should.

Because it is the ->gp_flags value that really knows, the current code
ignores wait_event_interruptible()'s return value and just checks
the ->gp_flags value.

> >> In the current scenario, if we get a spurious wakeup, we take the
> >> costly path of checking this condition again (with a barrier and lock)
> >> before going back to wait.
> >>
> >> The scenario of getting an actual wakeup after getting a spurious
> >> wakeup exists even today, this is the window after detecting a
> >> spurious wakeup and before going back to wait. I am not sure if using
> >> the return value enlarges that window as we are going back to sleep
> >> immediately.
> >>
> >> Thoughts?
> >
> > If the flag is set, why should we care whether or not the wakeup was
> > spurious?  If the flag is not set, why should we care whether or not
> > wait_event_interruptible() thought that the wakeup was not spurious?
> 
> A correction about the return value above: return will be 0 if the
> condition is true, in this case if the flag is set.
> 
> If the flag is set, ret will be 0 and we will go ahead with
> rcu_gp_init(). (no change wrt current behavior)

Sorry, this is not always correct.  RCU is highly concurrent, so you do
need to start thinking in terms of concurrency.  Your reasoning above
is a symptom of single-threaded thinking.  Please see my scenario above
showing how the return can be non-zero even though ->gp_flags is set.

> If the flag is not set, currently we go ahead and call rcu_gp_init()
> from where we check if the flag is set (after a lock+barrier) and
> return.

True enough.  Is that really a problem?  If so, exactly why is it a
problem?

> If we care about what wait_event_interruptible() returns, we can go
> back and wait for an actual wakeup much earlier without the additional
> overhead of calling rcu_gp_init().

The key phrase here is "If we care".  Should we care?  If so, why?

I suggest running some random benchmark and counting how many times
rcu_gp_init() is called and how many times rcu_gp_init() returns
because ->gp_flags is not set.  If rcu_gp_init() returns because
->gp_flags is not set a significant fraction of the time, then this
-might- be worth worrying about.  (Extra credit: Under what conditions
would it be worth worrying about, and how would you go about checking
to see whether those conditions hold?)

							Thanx, Paul

