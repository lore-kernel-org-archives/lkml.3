Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740AbaGAN6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:58:54 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:59429 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaGAN6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:58:53 -0400
Date: Tue, 1 Jul 2014 15:59:15 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zhihui Zhang <zzhsuny@gmail.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [sched] Don't account time after deadline twice
Message-Id: <20140701155915.55de01236e0540e1f0754560@gmail.com>
In-Reply-To: <20140701130816.GR6758@twins.programming.kicks-ass.net>
References: <1404091570-5041-1-git-send-email-zzhsuny@gmail.com>
	<20140701130816.GR6758@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014 15:08:16 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, Jun 29, 2014 at 09:26:10PM -0400, Zhihui Zhang wrote:
> > Unless we want to double-penalize an overrun task, the time after the deadline
> > and before the current time is already accounted in the negative dl_se->runtime
> > value. So we can leave it as is in the case of dmiss && rorun.
> 
> Juri?
> 
> > Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
> > ---
> >  kernel/sched/deadline.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> > index fc4f98b1..67df0d6 100644
> > --- a/kernel/sched/deadline.c
> > +++ b/kernel/sched/deadline.c
> > @@ -579,10 +579,8 @@ int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
> >  	 * the next instance. Thus, if we do not account that, we are
> >  	 * stealing bandwidth from the system at each deadline miss!
> >  	 */
> > -	if (dmiss) {
> > -		dl_se->runtime = rorun ? dl_se->runtime : 0;

If we didn't return 0 before, we are going to throttle (or replenish)
the entity, and you want runtime to be <=0. So, this is needed. 

> > -		dl_se->runtime -= rq_clock(rq) - dl_se->deadline;
> > -	}

A little pessimism in some cases, due to the fact that we use both
rq_clock and rq_clock_task (for the budget).

Thanks,

- Juri

> > +	if (dmiss && !rorun)
> > +		dl_se->runtime = dl_se->deadline - rq_clock(rq);
> >  
> >  	return 1;
> >  }
> > -- 
> > 1.8.1.2
> > 
