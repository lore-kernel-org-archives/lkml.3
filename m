Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030852AbaGCJur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:50:47 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53664 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030837AbaGCJun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:50:43 -0400
Date: Thu, 3 Jul 2014 11:50:37 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: Zhihui Zhang <zzhsuny@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [sched] Don't account time after deadline twice
Message-Id: <20140703115037.938f4c5dcd5a110529ff0df6@gmail.com>
In-Reply-To: <CADFvMYKzpihC3GLwNFZW0KCrZQY5FDSH5EQd4iLmHLK+hauDWA@mail.gmail.com>
References: <1404091570-5041-1-git-send-email-zzhsuny@gmail.com>
	<20140701130816.GR6758@twins.programming.kicks-ass.net>
	<20140701155915.55de01236e0540e1f0754560@gmail.com>
	<CADFvMYKzpihC3GLwNFZW0KCrZQY5FDSH5EQd4iLmHLK+hauDWA@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014 19:44:04 -0400
Zhihui Zhang <zzhsuny@gmail.com> wrote:

> My point is that rq_clock(rq) - dl_se->deadline is already part of
> dl_se->runtime, which is decremented before calling dl_runtime_exceeded().

But, we decrement dl_se->runtime looking at rq_clock_task(rq), that is
in general <= rq_clock(rq), that we use to handle deadlines. So, if we
do like you suggest, in some cases we could end up stealing some
bandwidth from the system. Indeed, we prefer some pessimism here.

Thanks,

- Juri

> So the following line is not needed in the case of both overrun and missing
> deadline:
> 
>     dl_se->runtime -= rq_clock(rq) - dl_se->deadline;
> 
> Or did I miss anything?
> 
> thanks,
> 
> 
> On Tue, Jul 1, 2014 at 9:59 AM, Juri Lelli <juri.lelli@gmail.com> wrote:
> 
> > On Tue, 1 Jul 2014 15:08:16 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > > On Sun, Jun 29, 2014 at 09:26:10PM -0400, Zhihui Zhang wrote:
> > > > Unless we want to double-penalize an overrun task, the time after the
> > deadline
> > > > and before the current time is already accounted in the negative
> > dl_se->runtime
> > > > value. So we can leave it as is in the case of dmiss && rorun.
> > >
> > > Juri?
> > >
> > > > Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
> > > > ---
> > > >  kernel/sched/deadline.c | 6 ++----
> > > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> > > > index fc4f98b1..67df0d6 100644
> > > > --- a/kernel/sched/deadline.c
> > > > +++ b/kernel/sched/deadline.c
> > > > @@ -579,10 +579,8 @@ int dl_runtime_exceeded(struct rq *rq, struct
> > sched_dl_entity *dl_se)
> > > >      * the next instance. Thus, if we do not account that, we are
> > > >      * stealing bandwidth from the system at each deadline miss!
> > > >      */
> > > > -   if (dmiss) {
> > > > -           dl_se->runtime = rorun ? dl_se->runtime : 0;
> >
> > If we didn't return 0 before, we are going to throttle (or replenish)
> > the entity, and you want runtime to be <=0. So, this is needed.
> >
> > > > -           dl_se->runtime -= rq_clock(rq) - dl_se->deadline;
> > > > -   }
> >
> > A little pessimism in some cases, due to the fact that we use both
> > rq_clock and rq_clock_task (for the budget).
> >
> > Thanks,
> >
> > - Juri
> >
> > > > +   if (dmiss && !rorun)
> > > > +           dl_se->runtime = dl_se->deadline - rq_clock(rq);
> > > >
> > > >     return 1;
> > > >  }
> > > > --
> > > > 1.8.1.2
> > > >
> >
