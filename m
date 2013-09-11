Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab3IKK0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:26:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51925 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3IKK0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:26:01 -0400
Message-ID: <1378895123.5476.83.camel@marge.simpson.net>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, ethan.kernel@gmail.com,
        rjw@sisk.pl, daniel.lezcano@linaro.org, linux-pm@vger.kernel.org,
        lenb@kernel.org
Date: Wed, 11 Sep 2013 12:25:23 +0200
In-Reply-To: <20130911085643.GS26785@twins.programming.kicks-ass.net>
References: <24EECBCC-F655-404F-8946-73CC36095A5F@gmail.com>
	 <1378362989.18435.2.camel@marge.simpson.net>
	 <20130905111428.GB23362@gmail.com>
	 <1378386697.6567.9.camel@marge.simpson.net>
	 <20130905133750.GA26637@gmail.com>
	 <1378445942.5434.31.camel@marge.simpson.net>
	 <20130909122325.GX31370@twins.programming.kicks-ass.net>
	 <1378730538.5586.30.camel@marge.simpson.net>
	 <20130909133044.GB31370@twins.programming.kicks-ass.net>
	 <20130909134635.GB26785@twins.programming.kicks-ass.net>
	 <20130911085643.GS26785@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:DkocL5eBc3Q9SHRfw5PyPGID+M262PvHj58yuMgFK3c
 Mr5bJ9jVVBqq5F8zTXr83/tPLn4duSXpAM8hW6d8TTkALDlszQ
 wc53fiYr5V+G7azpS9jO/MMrONawqhtDw1rcOVMlavRGFn1V3d
 1Pdaf36g37mvLskAB0ekwxhw1h/wWNLGa1nidWwpydWLHBvnCo
 KzOujC5RkPubz/yDETTEJ1hll46A1gSbwrXO4qSY6yLhdCuxkC
 2MFqxyaRxmQv2ynflcXQB93kf74jC48ykbKLAY8hLyFRiNqfei
 RglMfvGyH00dzWP6RyhRdazp6Dpl1c6PWEYCiuv2Tn1KR2uYDi
 VRZZiP7FQaXxOq5axtPZy9qQ1KUfCv1Ks/Ge/uCmcVLagD9PiW
 KSuvpJveiYyLQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-11 at 10:56 +0200, Peter Zijlstra wrote: 
> On Mon, Sep 09, 2013 at 03:46:35PM +0200, Peter Zijlstra wrote:
> > On Mon, Sep 09, 2013 at 03:30:44PM +0200, Peter Zijlstra wrote:
> > > diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> > > index fa6964d..486c0ba 100644
> > > --- a/drivers/idle/intel_idle.c
> > > +++ b/drivers/idle/intel_idle.c
> > > @@ -359,6 +359,14 @@ static int intel_idle(struct cpuidle_device *dev,
> > >  	if (!(lapic_timer_reliable_states & (1 << (cstate))))
> > >  		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
> > >  
> > > +	current_thread_into()->status |= TS_POLLING;
> > > +
> > > +	/*
> > > +	 * Order against setting of TS_POLLING against the reading of
> > > +	 * NEED_RESCHED, matched by resched_task().
> > > +	 */
> > > +	smp_mb();
> > > +
> > >  	if (!need_resched()) {
> > >  
> > >  		__monitor((void *)&current_thread_info()->flags, 0, 0);
> > > @@ -367,6 +375,8 @@ static int intel_idle(struct cpuidle_device *dev,
> > >  			__mwait(eax, ecx);
> > >  	}
> > >  
> > > +	current_thread_into()->status &= ~TS_POLLING;
> > > +
> > >  	if (!(lapic_timer_reliable_states & (1 << (cstate))))
> > >  		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
> > 
> > Hmm, arguably it would be better to set this from
> > intel_idle_cpuidle_driver_init() and clear it whenever this goes away.
> > Not sure how all that works, the cpuidle driver framework seems 'weird'.
> 
> OK, so I went over the idle stuff again, and we do set TS_POLLING like
> stuff, it got hidden in current_{clr,set}_polling().
> 
> Still if that patch causes extra IPIs its bound to be broken in some
> creative way.. I'll prod.

(thanks, when I get a break from testing/poking this'n'that, I'll take a
peek too...  well, good_intentions++ anyway;)

