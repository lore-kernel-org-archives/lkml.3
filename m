Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3HVKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 06:25:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50445 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3HVKZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 06:25:21 -0400
Date: Thu, 22 Aug 2013 12:25:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH 01/10] sched: Remove one division operation in
 find_busiest_queue()
Message-ID: <20130822102508.GG31370@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
 <20130819160425.088015040@infradead.org>
 <CAPM31R+2pH9-g6O5EKi1FfgiRjKxAMiN6UW3VO=FpUq463Ji3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31R+2pH9-g6O5EKi1FfgiRjKxAMiN6UW3VO=FpUq463Ji3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 01:58:28AM -0700, Paul Turner wrote:

> >         wl_i / power_i > wl_j / power_j :=
> >         wl_i * power_j > wl_j * power_i
> >
> >         struct rq *busiest = NULL, *rq;
> > -       unsigned long max_load = 0;
> > +       unsigned long busiest_load = 0, busiest_power = SCHED_POWER_SCALE;
> 
> Initializing this to SCHED_POWER_SCALE assigns a meaning that isn't
> really there.  How about just 1?

Right, 1 works, all we really need is for wl to be > 0.

> >         int i;
> >
> >         for_each_cpu(i, sched_group_cpus(group)) {
> > @@ -5049,10 +5049,9 @@ static struct rq *find_busiest_queue(str
> >                  * the load can be moved away from the cpu that is potentially
> >                  * running at a lower capacity.
> >                  */
> > -               wl = (wl * SCHED_POWER_SCALE) / power;
> > -
> > -               if (wl > max_load) {
> > -                       max_load = wl;
> 
> A comment wouldn't hurt here.

Agreed, something like so?

/*
 * Since we're looking for max(wl_i / power_i) crosswise multiplication
 * to rid ourselves of the division works out to:
 * wl_i * power_j > wl_j * power_i;  where j is our previous maximum.
 */

> > +               if (wl * busiest_power > busiest_load * power) {
> > +                       busiest_load = wl;
> > +                       busiest_power = power;
> >                         busiest = rq;
> >                 }
> >         }
> >
> >
