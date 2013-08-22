Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab3HVKnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 06:43:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50725 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3HVKnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 06:43:11 -0400
Date: Thu, 22 Aug 2013 12:42:57 +0200
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
Subject: Re: [PATCH 02/10] sched: Factor out code to should_we_balance()
Message-ID: <20130822104257.GH31370@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
 <20130819160425.157603641@infradead.org>
 <CAPM31RJcao-Gx0Ts_ZRPm+ASGBiqRkLm2EFNYJUMHM8PQF=EUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RJcao-Gx0Ts_ZRPm+ASGBiqRkLm2EFNYJUMHM8PQF=EUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 02:58:27AM -0700, Paul Turner wrote:
> On Mon, Aug 19, 2013 at 9:01 AM, Peter Zijlstra <peterz@infradead.org> wrote:

> > +               if (local_group)
> >                         load = target_load(i, load_idx);
> 
> Keep the braces here:
> 
>   if (local_group) {
>     load = target_load(i, load_idx);
>   } else {
>    ...

Right you are, I misplaced that hunk in the next patch.

> > -               } else {
> > +               else {
> >                         load = source_load(i, load_idx);
> >                         if (load > max_cpu_load)
> >                                 max_cpu_load = load;


> > @@ -5123,12 +5120,11 @@ static int load_balance(int this_cpu, st
> >
> >         schedstat_inc(sd, lb_count[idle]);
> >
> > -redo:
> > -       group = find_busiest_group(&env, balance);
> > -
> > -       if (*balance == 0)
> > +       if (!(*should_balance = should_we_balance(&env)))
> >                 goto out_balanced;
> 
> Given we always initialize *should_balance where we care, it might be
> more readable to write this as:

Ah, but we don't actually, idle_balance() doesn't initialize
should_balance -- easy enough to fix though.

> if (!should_we_balance(&env)) {
>   *continue_balancing = 0;
>   goto out_balanced;
> }
> 
> [ With a rename to can_balance ]

You confused me, your code implied
%s/should_balance/continue_balancing/g but now you suggest
%%s/should_balance/can_balance/g ?

I'm fine with either.

> >
> > +redo:
> 
> One behavioral change worth noting here is that in the redo case if a
> CPU has become idle we'll continue trying to load-balance in the
> !new-idle case.
> 
> This could be unpleasant in the case where a package has a pinned busy
> core allowing this and a newly idle cpu to start dueling for load.
> 
> While more deterministically bad in this case now, it could racily do
> this before anyway so perhaps not worth worrying about immediately.

Ah, because the old code would effectively redo the check and find the
idle cpu and thereby our cpu would no longer be the balance_cpu.

Indeed. And I don't think this was an intentional change. I'll go put
the redo back before should_we_balance().

