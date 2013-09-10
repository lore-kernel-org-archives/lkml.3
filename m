Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab3IJBkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 21:40:46 -0400
Received: from mout.gmx.net ([212.227.15.15]:56893 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab3IJBkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 21:40:45 -0400
Message-ID: <1378777238.5486.19.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH v4 3/3] sched: Periodically decay max cost of idle
 balance
From: Mike Galbraith <efault@gmx.de>
To: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        preeti@linux.vnet.ibm.com, akpm@linux-foundation.org, mgorman@suse.de,
        riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com
Date: Tue, 10 Sep 2013 03:40:38 +0200
In-Reply-To: <1378760873.10318.20.camel@j-VirtualBox>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
	 <1377806736-3752-4-git-send-email-jason.low2@hp.com>
	 <20130830101817.GE10002@twins.programming.kicks-ass.net>
	 <1378278601.3004.60.camel@j-VirtualBox>
	 <20130909114919.GS31370@twins.programming.kicks-ass.net>
	 <1378760873.10318.20.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:zaW+c8SvA5SMOt00sElUwI+DM6yF2+qmDqlv6FdzzrIuKSVieP9
 aqwFOd9ep7uEcicdHWvPz1Ip5wColAYsmWNr6ulOvUiqpP1Qqk83U9IbE1b05f78MW0fFqR
 lUk4EnJtegFZ0v9smI6sIIlmxrxBWFcrMpc6M5lggfqdeULaGfN76XFiGrDMFRVY3G2BiEC
 QzgyikmMtp6rP2s65LCZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-09 at 14:07 -0700, Jason Low wrote: 
> On Mon, 2013-09-09 at 13:49 +0200, Peter Zijlstra wrote:
> > On Wed, Sep 04, 2013 at 12:10:01AM -0700, Jason Low wrote:
> > > On Fri, 2013-08-30 at 12:18 +0200, Peter Zijlstra wrote:
> > > > On Thu, Aug 29, 2013 at 01:05:36PM -0700, Jason Low wrote:
> > > > > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > > > > index 58b0514..bba5a07 100644
> > > > > --- a/kernel/sched/core.c
> > > > > +++ b/kernel/sched/core.c
> > > > > @@ -1345,7 +1345,7 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
> > > > >  
> > > > >  	if (rq->idle_stamp) {
> > > > >  		u64 delta = rq_clock(rq) - rq->idle_stamp;
> > > > > -		u64 max = 2*rq->max_idle_balance_cost;
> > > > > +		u64 max = 2*(sysctl_sched_migration_cost + rq->max_idle_balance_cost);
> > > > 
> > > > You re-introduce sched_migration_cost here because max_idle_balance_cost
> > > > can now drop down to 0 again?
> > > 
> > > Yes it was so that max_idle_balance_cost would be at least sched_migration_cost
> > > and that we would still skip idle_balance if avg_idle < sched_migration_cost.
> > > 
> > > I also initially thought that adding sched_migration_cost would also account for
> > > the extra "costs" of idle balancing that are not accounted for in the time spent
> > > on each newidle load balance. Come to think of it though, sched_migration_cost
> > > might be too large when used in that context considering we're already using the
> > > max cost.
> > 
> > Right, so shall we do as Srikar suggests and drop that initial check?
> 
> I agree that we can delete the check between avg_idle and max_idle_balance_cost
> so that large costs in higher domains don't cause balancing to be skipped in
> lower domains as Srikar suggested. Should we keep the old
> "if (this_rq->avg_idle < sysctl_sched_migration_cost)" check?

It was put there to allow cross core scheduling to recover as much
overlap as possible, so rapidly switching communicating tasks with only
small recoverable overlap in the first place don't get pounded to pulp
by overhead instead.  If a different way does a better job, whack it.

-Mike

