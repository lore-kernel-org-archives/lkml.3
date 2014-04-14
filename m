Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaDNWsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:48:37 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39900 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaDNWsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:48:22 -0400
Date: Tue, 15 Apr 2014 00:48:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] sched/core: fix formatting issues in
 sched_can_stop_tick()
Message-ID: <20140414224815.GA1877@localhost.localdomain>
References: <6c3484ccb8220d0c58db1cbd9c929fc8d83005fd.1397492119.git.viresh.kumar@linaro.org>
 <20140414183838.GF11182@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414183838.GF11182@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 08:38:38PM +0200, Peter Zijlstra wrote:
> On Mon, Apr 14, 2014 at 09:47:41PM +0530, Viresh Kumar wrote:
> > sched_can_stop_tick() was using 7 spaces instead of 8 spaces or a 'tab' at the
> > beginning of each line. Which doesn't align with the Coding Guidelines.
> > 
> > Also it removes the *rq variable as it was used at only one place and hence we
> > can directly use this_rq() instead.
> > 
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> > I don't think rq = tihs_rq() has to be done before smp_mb(), in case yes sorry
> > for this patch :(
> > 
> >  kernel/sched/core.c | 16 ++++++----------
> >  1 file changed, 6 insertions(+), 10 deletions(-)
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 268a45e..13299c5 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -666,18 +666,14 @@ static inline bool got_nohz_idle_kick(void)
> >  #ifdef CONFIG_NO_HZ_FULL
> >  bool sched_can_stop_tick(void)
> >  {
> > +	/* Make sure rq->nr_running update is visible after the IPI */
> > +	smp_rmb();
> >  
> > +	/* More than one running task need preemption */
> > +	if (this_rq()->nr_running > 1)
> > +		return false;
> >  
> > +	return true;
> >  }
> >  #endif /* CONFIG_NO_HZ_FULL */
> 
> AFAICT the smp_rmb() is entirely spurious, arch interrupts should ensure
> consistency on their own. That is:
> 
>   CPU 0		  CPU 1
> 
> [w] X = 1
>     IPI 1	    <int>
> 		[r] r = X
> 
> Should act as if there was a full memory barrier, making it so that the
> read on CPU1 observes the write on CPU0.

Right, I have a pending patch for that:
https://git.kernel.org/cgit/linux/kernel/git/frederic/linux-dynticks.git/commit/?h=nohz/ipi&id=ca981d9f87fe0f113ad972098cfe181180b3675a
