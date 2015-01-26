Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbbAZJlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:41:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:45094 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbbAZJlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:41:14 -0500
Date: Mon, 26 Jan 2015 10:40:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Peter Zijlstra <peterz@infradead.org>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v3]PM/Sleep: Timer quiesce in freeze state
In-Reply-To: <54C5FE6A.9010300@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1501260946390.5526@nanos>
References: <54866625.8010406@linux.intel.com> <54B5B724.4020108@linux.intel.com> <5541724.ryTEJUkIdN@vostro.rjw.lan> <alpine.DEB.2.11.1501221021580.5526@nanos> <54C5FE6A.9010300@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Li, Aubrey wrote:
> On 2015/1/22 18:15, Thomas Gleixner wrote:
> > Can we please stop adding more crap to that notifier thing? I rather
> > see that go away than being expanded.
> 
> Are you referring to FREEZE_PREPARE or remove all of FREEZE staff at all?
> 
> What's the disadvantage of adding more notifier?

clockevents_notify() is not a notifier. Its a multiplex call and I
want to get rid of it and replace it with explicit functions.

> >> +		/*
> >> +		 * cpuidle_enter will return with interrupt enabled
> >> +		 */
> >> +		cpuidle_enter(drv, dev, next_state);
> > 
> > How is that supposed to work?
> > 
> > If timekeeping is not yet unfrozen, then any interrupt handling code
> > which calls anything time related is going to hit lala land.
> > 
> > You must guarantee that timekeeping is unfrozen before any interrupt
> > is handled. If you cannot guarantee that, you cannot freeze
> > timekeeping ever.
> > 
> > The cpu local tick device is less critical, but it happens to work by
> > chance, not by design.
> 
> There are two way to guarantee this: the first way is, disable interrupt
> before timekeeping frozen and enable interrupt after timekeeping is
> unfrozen. However, we need to handle wakeup handler before unfreeze
> timekeeping to wake freeze task up from wait queue.
> 
> So we have to go the other way, the other way is, we ignore time related
> calls during freeze, like what I added in irq_enter below.

Groan. You just do not call in irq_enter/exit(), but what prevents any
interrupt handler or whatever to call into the time/timer code after
interrupts got reenabled?

Nothing. 

> Or, we need to re-implement freeze wait and wake up mechanism?

You need to make sure in the low level idle implementation that this
cannot happen.

tick_freeze()
{
	raw_spin_lock(&tick_freeze_lock);
	tick_frozen++;
	if (tick_frozen == num_online_cpus())
		timekeeping_suspend();
	else
		tick_suspend_local();
	raw_spin_unlock(&tick_freeze_lock);
}

tick_unfreeze()
{
	raw_spin_lock(&tick_freeze_lock);
	if (tick_frozen == num_online_cpus())
		timekeeping_resume();
	else
		tick_resume_local();
	tick_frozen--;
	raw_spin_unlock(&tick_freeze_lock);
}

idle_freeze()
{
	local_irq_disable();

	tick_freeze();

	/* Must keep interrupts disabled! */
       	go_deep_idle()

	tick_unfreeze();

	local_irq_enable();
}

That's the only way you can do it proper, everything else will just be
a horrible mess of bandaids and duct tape.

So that does not need any of the irq_enter/exit conditionals, it does
not need the real_handler hack. It just works.

The only remaining issue might be a NMI calling into
ktime_get_mono_fast_ns() before timekeeping is resumed. Its probably a
non issue on x86/tsc, but it might be a problem on other platforms
which turn off devices, clocks, It's not rocket science to prevent
that.

> It looks like a notifier is unpopular, I was trying to avoid a global
> variable across different kernel modules. But yes, I can change. May I
> know the disadvantage of notifier callback?

You do not need a global variable at all. See above.

> The V2 patch was using stop machine mechanism according to Peter's
> suggestion. This V3 patch, IIRC, clockevents_lock was your suggestion.

A suggestion does not mean that you should follow it blindly. If you
see that the result is horrible and not feasible then you should
notice yourself, think about different approaches and discuss that.

I'm about to post a series which gets rid of clockevents_notify() and
distangles the stuff so the above becomes possible.

Thanks,

	tglx
