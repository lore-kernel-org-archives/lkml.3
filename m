Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762150Ab3IDHKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:10:08 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:2263 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab3IDHKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:10:06 -0400
Message-ID: <1378278601.3004.60.camel@j-VirtualBox>
Subject: Re: [RFC][PATCH v4 3/3] sched: Periodically decay max cost of idle
 balance
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        pjt@google.com, preeti@linux.vnet.ibm.com, akpm@linux-foundation.org,
        mgorman@suse.de, riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com
Date: Wed, 04 Sep 2013 00:10:01 -0700
In-Reply-To: <20130830101817.GE10002@twins.programming.kicks-ass.net>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
	 <1377806736-3752-4-git-send-email-jason.low2@hp.com>
	 <20130830101817.GE10002@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-30 at 12:18 +0200, Peter Zijlstra wrote:
> On Thu, Aug 29, 2013 at 01:05:36PM -0700, Jason Low wrote:
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 58b0514..bba5a07 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -1345,7 +1345,7 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
> >  
> >  	if (rq->idle_stamp) {
> >  		u64 delta = rq_clock(rq) - rq->idle_stamp;
> > -		u64 max = 2*rq->max_idle_balance_cost;
> > +		u64 max = 2*(sysctl_sched_migration_cost + rq->max_idle_balance_cost);
> 
> You re-introduce sched_migration_cost here because max_idle_balance_cost
> can now drop down to 0 again?

Yes it was so that max_idle_balance_cost would be at least sched_migration_cost
and that we would still skip idle_balance if avg_idle < sched_migration_cost.

I also initially thought that adding sched_migration_cost would also account for
the extra "costs" of idle balancing that are not accounted for in the time spent
on each newidle load balance. Come to think of it though, sched_migration_cost
might be too large when used in that context considering we're already using the
max cost.

