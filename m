Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaGYWsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:48:07 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42877 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaGYWsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:48:04 -0400
Date: Fri, 25 Jul 2014 15:47:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] rcu: Use rcu_gp_kthread_wake() to wake up
 kthreads
Message-ID: <20140725224759.GG11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406264818-2296-1-git-send-email-bobby.prani@gmail.com>
 <20140725144458.GY11241@linux.vnet.ibm.com>
 <CAJhHMCAvcKZ+gnW4GYf5-WNYFHsoAiBFU4vUcR5ifJedVvFtzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCAvcKZ+gnW4GYf5-WNYFHsoAiBFU4vUcR5ifJedVvFtzQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072522-7164-0000-0000-00000363124F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 04:19:43PM -0400, Pranith Kumar wrote:
> On Fri, Jul 25, 2014 at 10:44 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Fri, Jul 25, 2014 at 01:06:58AM -0400, Pranith Kumar wrote:
> >> The rcu_gp_kthread_wake() function checks for three conditions before waking up
> >> grace period kthreads:
> >>
> >> *  Is the thread we are trying to wake up the current thread?
> >> *  Are the gp_flags zero? (all threads wait on non-zero gp_flags condition)
> >> *  Is there no thread created for this flavour, hence nothing to wake up?
> >>
> >> If any one of these condition is true, we do not call wake_up().
> >>
> >> In rcu_report_qs_rsp(), I added a pr_info() call testing if any of the above
> >> conditions is true, in which case we can avoid calling wake_up(). It turns out
> >> that quite a few actually are. Most of the cases where we can avoid is condition 2
> >> above and condition 1 also occurs quite often. Condition 3 never happens.
> >>
> >> I could not test the wake_up() in force_quiescent_state() as that is not
> >> triggered trivially, but I am assuming we can replace wake_up() there too.
> >>
> >> Hence this commit tries to avoid calling wake_up() whenever we can by using
> >> rcu_gp_kthread_wake() function.
> >
> > This one does sound much more plausible than the earlier one.  I have
> > a few more questions that I will ask in your follow-up message.
> >
> >> One concern is the comment which states that we need a memory barrier at that
> >> location which is being implied by the wake_up(). Should we put an smp_mb() and
> >> just not rely on the barrier provided by wake_up()? Thoughts?
> >
> > Let's see...  The memory barriers are unnecessary for your case 1
> > and case 3.  That leaves your case 2, which is all about ->gp_flags.
> > It is quite possible that this case is now fully covered by locking,
> > so that the comment is obsolete.  But why don't you check?
> 
> I checked all the locations where gp_flags is being updated and the
> root node lock is held in all the cases.
> So I guess we can remove the comment too.

And the accesses that matter (for some definition of "that matter") are
also similarly protected?

An example of an access that doesn't matter is one that is followed up
by an access under the appropriate lock.

Anyway, if it is all locked properly, then yes, we should get rid of
the comment -- or replace it with a comment saying that barriers are
not needed due to locking.

							Thanx, Paul

> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> >> ---
> >>  kernel/rcu/tree.c | 6 ++++--
> >>  1 file changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> >> index 72e0b1f..d0e0d6e 100644
> >> --- a/kernel/rcu/tree.c
> >> +++ b/kernel/rcu/tree.c
> >> @@ -1938,7 +1938,8 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
> >>  {
> >>       WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
> >>       raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
> >> -     wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
> >> +     /* Memory barrier implied by wake_up() path. */
> >> +     rcu_gp_kthread_wake(rsp);
> >>  }
> >>
> >>  /*
> >> @@ -2516,7 +2517,8 @@ static void force_quiescent_state(struct rcu_state *rsp)
> >>       ACCESS_ONCE(rsp->gp_flags) =
> >>               ACCESS_ONCE(rsp->gp_flags) | RCU_GP_FLAG_FQS;
> >>       raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
> >> -     wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
> >> +     /* Memory barrier implied by wake_up() path. */
> >> +     rcu_gp_kthread_wake(rsp);
> >>  }
> >>
> >>  /*
> >> --
> >> 2.0.1
> >>
> >
> 
> 
> 
> -- 
> Pranith
> 

