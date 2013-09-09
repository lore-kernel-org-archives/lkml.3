Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3IINay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:30:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50767 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3IINaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:30:52 -0400
Date: Mon, 9 Sep 2013 15:30:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, ethan.kernel@gmail.com
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
Message-ID: <20130909133044.GB31370@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de>
 <20130729115701.GD3008@twins.programming.kicks-ass.net>
 <24EECBCC-F655-404F-8946-73CC36095A5F@gmail.com>
 <1378362989.18435.2.camel@marge.simpson.net>
 <20130905111428.GB23362@gmail.com>
 <1378386697.6567.9.camel@marge.simpson.net>
 <20130905133750.GA26637@gmail.com>
 <1378445942.5434.31.camel@marge.simpson.net>
 <20130909122325.GX31370@twins.programming.kicks-ass.net>
 <1378730538.5586.30.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378730538.5586.30.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lets go back to the list with this.. 

On Mon, Sep 09, 2013 at 02:42:18PM +0200, Mike Galbraith wrote:
> On Mon, 2013-09-09 at 14:23 +0200, Peter Zijlstra wrote: 
> > On Fri, Sep 06, 2013 at 07:39:02AM +0200, Mike Galbraith wrote:
> > > The patch takes a large bite out of regressions.  What's left for a
> > > Westmere box is the introduction of reschedule_interrupt overhead
> > > introduced by 7d1a9417 x86: Use generic idle loop. 
> > 
> > How exactly does that commit cause extra IPIs? Did the entire TS_POLLING
> > stuff break or so?
> 
> Seems so.
> 
> > > Core2 eats that,
> > > plus Intel making mwait_idle() go away with no way for them to get to
> > > the remaining mwait_idle_with_hints().
> > 
> > but but but drivers/idle/intel_idle.c still uses mwait.. what's the
> > exact complaint?
> 
> reschedule_interrupt overhead for cross core pipe-test appeared in
> westmere box at 7d1a9417.

So that patch does indeed loose the TS_POLLING stuff for all of x86. I'm
not entirely sure where we want to add it back, but the best place to me
seems the idle loop implementations themselves.

Below a patch that does intel_idle.c which is what your WSM would be
using I suppose. We'll probably want to iterate all idle implementations
and do what needs doing.

---
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index fa6964d..486c0ba 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -359,6 +359,14 @@ static int intel_idle(struct cpuidle_device *dev,
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
+	current_thread_into()->status |= TS_POLLING;
+
+	/*
+	 * Order against setting of TS_POLLING against the reading of
+	 * NEED_RESCHED, matched by resched_task().
+	 */
+	smp_mb();
+
 	if (!need_resched()) {
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
@@ -367,6 +375,8 @@ static int intel_idle(struct cpuidle_device *dev,
 			__mwait(eax, ecx);
 	}
 
+	current_thread_into()->status &= ~TS_POLLING;
+
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
 
