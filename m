Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935490AbaH0Re5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:34:57 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:59249 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933914AbaH0Re4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:34:56 -0400
Message-ID: <1409160893.31379.24.camel@j-VirtualBox>
Subject: Re: [PATCH v2] sched: Reduce contention in
 update_cfs_rq_blocked_load
From: Jason Low <jason.low2@hp.com>
To: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Ben Segall <bsegall@google.com>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 27 Aug 2014 10:34:53 -0700
In-Reply-To: <CAPM31RJcYakzwo9mByoadw6DGcg5SfYDOdX79NPo08hBP5PGjA@mail.gmail.com>
References: <1409094682.29189.23.camel@j-VirtualBox>
	 <CAPM31RJcYakzwo9mByoadw6DGcg5SfYDOdX79NPo08hBP5PGjA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-26 at 16:24 -0700, Paul Turner wrote:
> On Tue, Aug 26, 2014 at 4:11 PM, Jason Low <jason.low2@hp.com> wrote:
> > Based on perf profiles, the update_cfs_rq_blocked_load function constantly
> > shows up as taking up a noticeable % of system run time. This is especially
> > apparent on larger numa systems.
> >
> > Much of the contention is in __update_cfs_rq_tg_load_contrib when we're
> > updating the tg load contribution stats. However, it was noticed that the
> > values often don't get modified by much. In fact, much of the time, they
> > don't get modified at all. However, the update can always get attempted due
> > to force_update.
> >
> > In this patch, we remove the force_update in only the
> > __update_cfs_rq_tg_load_contrib. Thus the tg load contrib stats now get
> > modified only if the delta is large enough (in the current code, they get
> > updated when the delta is larger than 12.5%). This is a way to rate-limit
> > the updates while largely keeping the values accurate.
> >
> > When testing this change with AIM7 workloads, we found that it was able to
> > reduce the overhead of the function by up to a factor of 20x.
> 
> Looks reasonable.
> 
> >
> > Cc: Yuyang Du <yuyang.du@intel.com>
> > Cc: Waiman Long <Waiman.Long@hp.com>
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: Aswin Chandramouleeswaran <aswin@hp.com>
> > Cc: Chegu Vinod <chegu_vinod@hp.com>
> > Cc: Scott J Norton <scott.norton@hp.com>
> > Signed-off-by: Jason Low <jason.low2@hp.com>
> > ---
> >  kernel/sched/fair.c |   10 ++++------
> >  1 files changed, 4 insertions(+), 6 deletions(-)
> >
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index fea7d33..7a6e18b 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -2352,8 +2352,7 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
> >  }
> >
> >  #ifdef CONFIG_FAIR_GROUP_SCHED
> > -static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
> > -                                                int force_update)
> > +static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq)
> >  {
> >         struct task_group *tg = cfs_rq->tg;
> >         long tg_contrib;
> > @@ -2361,7 +2360,7 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
> >         tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
> >         tg_contrib -= cfs_rq->tg_load_contrib;
> >
> > -       if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
> 
> Another option with slightly higher accuracy would be to increase the
> sensitivity here when force_update == 1.
> 
> E.g.:
>     abs(tg_contrib) > cfs_rq->tg_load_contrib / (8 * (1 + force_update))) { ...
> 
> Alternatively we could bound total inaccuracy:
>    int divisor = force_update ? NR_CPUS : 8;
>    if (abs(tg_contrib) > cfs_rq->tg_load_contrib / divisor) { ...
> 
> 
> [ And probably rename force_update to want_update ]

Out of the 2 additional options, I think the first one is better. The
other option of using NR_CPUS looks like we're increasing the update
rate as the system gets larger, and its the larger systems that are
typically more affected by the contention.

Do you prefer either of the 2 other options over this v2 patch? If so, I
can test and send out a new patch, otherwise, I'll keep this current v2
patch.

Thanks.

