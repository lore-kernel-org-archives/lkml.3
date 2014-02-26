Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaBZCnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 21:43:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.24]:58508 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaBZCnf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 21:43:35 -0500
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Feb 2014 21:43:35 EST
Message-ID: <1393382258.5142.4.camel@marge.simpson.net>
Subject: Re: [PATCH] sched/rt: fix rt timer activation/deactivation
From: Mike Galbraith <bitbucket@online.de>
To: tkhai@yandex.ru
Cc: Juri Lelli <juri.lelli@gmail.com>, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 03:37:38 +0100
In-Reply-To: <1393361805.12438.6.camel@HP-250-G1-Notebook-PC>
References: <1393344328-16653-1-git-send-email-juri.lelli@gmail.com>
	 <1393361805.12438.6.camel@HP-250-G1-Notebook-PC>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:UZp8/FN6ekgPndEwi2RLUFM3y8bDujyKTwDjUMazXCI
 bkZhX2yiz5LJUXvsHG+/UuN1Za1GgE7B4hruAdjHO9uq/cB/a7
 P47xhNsypa2wm4J9sAA2FVUnOCxcK8Z/LYd9rY3ExbGJS2jwYt
 2yWLkj8qE1Tao8CoEcmjG7LvdqU//qIkcq8SFOor0I/gIhkAwW
 N4u+dy3CSPTsT+J1d/PTzjPkIzBoKlhKLpme245xkhFKZhDcjW
 4QT5a9UNKUxZkAzOd3SToTKKwKcho+J7PoGaPFecneOQvIIavg
 +JITsudWnLJGRuFn2wTTG4t9iQdosVLVL6bUTnnaj5G4js7fIA
 5jvgZi8XYaOzPoT/V3ELTdYI4xnZYskCa5ErTkSTQrevCO/aQU
 lJu++2zknBC+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-26 at 00:56 +0400, Kirill Tkhai wrote: 
> On Вт, 2014-02-25 at 17:05 +0100, Juri Lelli wrote:
> > Destroy rt bandwidth timer when rq has no more RT tasks, even when
> > CONFIG_RT_GROUP_SCHED is not set.
> > 
> > Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> > ---
> >  kernel/sched/rt.c |   10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> > index a2740b7..7dba25a 100644
> > --- a/kernel/sched/rt.c
> > +++ b/kernel/sched/rt.c
> > @@ -86,12 +86,12 @@ void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
> >  	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
> >  }
> >  
> > -#ifdef CONFIG_RT_GROUP_SCHED
> >  static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
> >  {
> >  	hrtimer_cancel(&rt_b->rt_period_timer);
> >  }
> >  
> > +#ifdef CONFIG_RT_GROUP_SCHED
> >  #define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
> >  
> >  static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
> > @@ -1011,8 +1011,12 @@ inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
> >  	start_rt_bandwidth(&def_rt_bandwidth);
> >  }
> >  
> > -static inline
> > -void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
> > +static void
> > +dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
> > +{
> > +	if (!rt_rq->rt_nr_running)
> > +		destroy_rt_bandwidth(&def_rt_bandwidth);
> > +}
> 
> The problem is bandwidth timer is not per-cpu. It's only for all
> processors from the span (sched_rt_period_mask()). Other CPUs may
> have enqueued RT tasks. So, it's not possible to do this.

BTW, I noticed you can no longer turn the turn the noisy thing off since
we grew DL.  I added an old SGI boot parameter to tell it to go away.

-Mike

