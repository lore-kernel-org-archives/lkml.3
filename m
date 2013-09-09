Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3IILte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:49:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48828 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3IILtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:49:32 -0400
Date: Mon, 9 Sep 2013 13:49:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        pjt@google.com, preeti@linux.vnet.ibm.com, akpm@linux-foundation.org,
        mgorman@suse.de, riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH v4 3/3] sched: Periodically decay max cost of idle
 balance
Message-ID: <20130909114919.GS31370@twins.programming.kicks-ass.net>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
 <1377806736-3752-4-git-send-email-jason.low2@hp.com>
 <20130830101817.GE10002@twins.programming.kicks-ass.net>
 <1378278601.3004.60.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378278601.3004.60.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 12:10:01AM -0700, Jason Low wrote:
> On Fri, 2013-08-30 at 12:18 +0200, Peter Zijlstra wrote:
> > On Thu, Aug 29, 2013 at 01:05:36PM -0700, Jason Low wrote:
> > > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > > index 58b0514..bba5a07 100644
> > > --- a/kernel/sched/core.c
> > > +++ b/kernel/sched/core.c
> > > @@ -1345,7 +1345,7 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
> > >  
> > >  	if (rq->idle_stamp) {
> > >  		u64 delta = rq_clock(rq) - rq->idle_stamp;
> > > -		u64 max = 2*rq->max_idle_balance_cost;
> > > +		u64 max = 2*(sysctl_sched_migration_cost + rq->max_idle_balance_cost);
> > 
> > You re-introduce sched_migration_cost here because max_idle_balance_cost
> > can now drop down to 0 again?
> 
> Yes it was so that max_idle_balance_cost would be at least sched_migration_cost
> and that we would still skip idle_balance if avg_idle < sched_migration_cost.
> 
> I also initially thought that adding sched_migration_cost would also account for
> the extra "costs" of idle balancing that are not accounted for in the time spent
> on each newidle load balance. Come to think of it though, sched_migration_cost
> might be too large when used in that context considering we're already using the
> max cost.

Right, so shall we do as Srikar suggests and drop that initial check?
