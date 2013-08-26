Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3HZMHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:07:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35418 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab3HZMHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:07:34 -0400
Date: Mon, 26 Aug 2013 14:07:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 07/10] sched, fair: Optimize find_busiest_queue()
Message-ID: <20130826120715.GK31370@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
 <20130819160425.527872672@infradead.org>
 <CAPM31RKTZYsZ6V6qjBNwZfE0i0Tk3fgeH_rxnDoG=pM24-TG_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RKTZYsZ6V6qjBNwZfE0i0Tk3fgeH_rxnDoG=pM24-TG_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 03:33:59AM -0700, Paul Turner wrote:
> On Mon, Aug 19, 2013 at 9:01 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > +++ b/kernel/sched/fair.c
> > @@ -4977,7 +4977,7 @@ static struct rq *find_busiest_queue(str
> >         unsigned long busiest_load = 0, busiest_power = SCHED_POWER_SCALE;
> >         int i;
> >
> > -       for_each_cpu(i, sched_group_cpus(group)) {
> > +       for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
> >                 unsigned long power = power_of(i);
> >                 unsigned long capacity = DIV_ROUND_CLOSEST(power,
> >                                                            SCHED_POWER_SCALE);
> > @@ -4986,9 +4986,6 @@ static struct rq *find_busiest_queue(str
> >                 if (!capacity)
> >                         capacity = fix_small_capacity(env->sd, group);
> >
> > -               if (!cpumask_test_cpu(i, env->cpus))
> > -                       continue;
> > -
> >                 rq = cpu_rq(i);
> >                 wl = weighted_cpuload(i);
> 
> There's no need to actually do the divisions immediately below this also.
> 
> e.g.
>   unsigned long max_load_power = SCHED_POWER_SCALE;
>   ...
>   if (wl * max_load_power > max_load * power) {
>    max_load = wl;
>    max_load_power = power;
>    ...
> 
> This would actually end up being a little more accurate even.
> 
> [ Alternatively without caching max_load_power we could compare wl *
> power vs max_load * SCHED_POWER_SCALE. ]

You've got me confused again. You're talking about something like the
below?

I suppose the problem with that is that we could keep selecting the
busiest rq with an unmovable task due to:

move_tasks():
		if ((load / 2) > env->imbalance)
			goto next;

That said, the condition in fbq() should at least be modified to match
this. Now the entire capacity crap comes from:

  bdb94aa sched: Try to deal with low capacity

But thinking a little more about it, if power drops that low imbalance
is likely to be _huge_ and we'd not meet that condition. Now if only I
wrote a more comprehensive Changelog and explained why that wouldn't be
the case. /me kicks himself.

---
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4990,28 +4990,12 @@ static struct sched_group *find_busiest_
 static struct rq *find_busiest_queue(struct lb_env *env,
 				     struct sched_group *group)
 {
-	struct rq *busiest = NULL, *rq;
 	unsigned long busiest_load = 0, busiest_power = 1;
+	struct rq *busiest = NULL;
 	int i;
 
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
-		unsigned long power = power_of(i);
-		unsigned long capacity = DIV_ROUND_CLOSEST(power,
-							   SCHED_POWER_SCALE);
-		unsigned long wl;
-
-		if (!capacity)
-			capacity = fix_small_capacity(env->sd, group);
-
-		rq = cpu_rq(i);
-		wl = weighted_cpuload(i);
-
-		/*
-		 * When comparing with imbalance, use weighted_cpuload()
-		 * which is not scaled with the cpu power.
-		 */
-		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
-			continue;
+		unsigned long wl = weighted_cpuload(i);
 
 		/*
 		 * For the load comparisons with the other cpu's, consider
@@ -5027,7 +5011,7 @@ static struct rq *find_busiest_queue(str
 		if (wl * busiest_power > busiest_load * power) {
 			busiest_load = wl;
 			busiest_power = power;
-			busiest = rq;
+			busiest = cpu_rq(i);
 		}
 	}
 

