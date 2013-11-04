Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab3KDSit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:38:49 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55474 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3KDSis convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:38:48 -0500
Date: Mon, 4 Nov 2013 19:38:46 +0100
From: Andreas Mohr <andi@lisas.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4/5] sched: Refactor iowait accounting
Message-ID: <20131104183846.GA24826@rhlx01.hs-esslingen.de>
References: <1382195841-6558-5-git-send-email-fweisbec@gmail.com>
 <20131020111006.GA26671@rhlx01.hs-esslingen.de>
 <20131104173421.GH9299@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20131104173421.GH9299@localhost.localdomain>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 06:34:23PM +0100, Frederic Weisbecker wrote:
> On Sun, Oct 20, 2013 at 01:10:06PM +0200, Andreas Mohr wrote:
> > In case of high update traffic of parts guarded by rq->iowait_lock
> > (is that a relevant case?),
> >
> > it might be useful to merely grab all relevant values into helper vars
> > (i.e., establish a consistent "view" on things), now, start, nr_iowait etc. -
> > this would enable us to do ktime_sub(), ktime_add() calculations
> > *once*, after the fact. Drawback would be that this reduces seqlock
> > guard scope (would not be active any more during runtime spent for calculations,
> > i.e. another update may happen during that calculation time),
> > but then that function's purpose merely is to provide a *consistent
> > one-time probe* of a continually updated value anyway, so it does not
> > matter if we happen to return values of one update less
> > than is already available.
> 
> I'm not sure I really understand what you mean here. But I don't think we can do the
> iowait_start/iowait_time probe only once. The retry part is necessary to make
> sure that we have coherent results against a given update sequence. Otherwise we
> need to use pure exclusive locks, like spinlocks. If we find out that there are issues
> wrt. readers starvations or livelocks, may be we'll do this but I believe that won't
> be needed.

Seqlocks are of course a good way to properly guard consistency
while updates ongoing, and such handling *is* required like is being
done here (or, alternatively similar to that).

I was just indicating that it might make sense to draw a minimalist-data
watch "view" from some updated-values area, to enable then doing the final
(and a possibly expensive!) calculation *post-seqlock*, i.e. processing these
stack-local helpers only once values consistency was successfully verified.

In your case here, the extraneous inner-seqlock handling merely consists
of few subtractions/additions, so it quite likely does not make sense
to actively move those values over into stack-local *copies*
(especially since having ongoing update activity occurring
probably won't be a hotpath case),
but for some other cases of seqlock use that might be useful, to minimize
within-seqlock handling overhead.


> I think I'm going to respin this series but move back the iowait time update part to
> the idle code. The update made in io_schedule() doesn't work since we really need it
> to account iowait time when the CPU is idle only: idle time accounting itself depend
> on it, and the callers of get_...time_us() rely on that too. Plus doing the update
> only when the CPU is idle will result in less overhead.

OK, probably (I haven't quite fully analyzed it).
But it would be good to achieve rectifying handling
to make calculation of cumulative I/O wait time of a runqueue element
properly account for the asymmetric case (this-initiating-cpu that-ending-cpu).
And frankly I'm still confused about what kind of valuable property
exactly it is that we're measuring here... (I/O wait time while CPU idle,
especially in the distributed-SMP case). The criteria seem murky.

Hmm, unless... we're talking a truly properly CPU-agnostic "global" accounting
which properly registers the delta which extends
from start-I/O with *all CPUs now idle*
to that I/O being finished (on *whichever* CPU!!),
*and with all intermediate time periods of _any_ CPUs non-idle properly excluded*.

So, from my limited analysis/understanding, a precise implementation of
that accounting
to me seems to have (at least?) the following responsibilities:
- ensure properly isolated *per-runqueue-element attribution*
  of I/O-while-CPUs-fully-idle cumulative time, belonging to *that*
  runqueue element
- ensure an accounting which properly starts attributing *any* ongoing I/O
  activities to idle-time I/O once all CPUs went idle
- ensure an accounting which does proper *exclusion*
  of any intermediate *non-idle* periods (i.e., whenever *even a single CPU*
  exited idle state)

That AFAICS is the only way that this accounting would make sense on a non-UP
system.

Right? Or what exactly would the purpose/justification/implementation
of such idle-CPU I/O wait time accounting be, especially on SMP?

And try to view it in that light:
1. what is the maximally correct way to implement such accounting?
2. how to do that maximally efficiently?
3. with in-kernel handling now perfect,
   how to accommodate existing (potentially mal-defined) user-side APIs?

Andreas Mohr
