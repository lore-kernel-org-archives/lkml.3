Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbbA0Or2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:47:28 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51469 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932372AbbA0OrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:47:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v3]PM/Sleep: Timer quiesce in freeze state
Date: Tue, 27 Jan 2015 16:10:08 +0100
Message-ID: <11292969.Jn202SnHMu@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54C74651.3020403@linux.intel.com>
References: <54866625.8010406@linux.intel.com> <2137807.aqSxQQCuJ3@vostro.rjw.lan> <54C74651.3020403@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 27, 2015 04:03:29 PM Li, Aubrey wrote:
> On 2015/1/26 22:41, Rafael J. Wysocki wrote:
> > On Monday, January 26, 2015 10:40:24 AM Thomas Gleixner wrote:
> >> On Mon, 26 Jan 2015, Li, Aubrey wrote:
> >>> On 2015/1/22 18:15, Thomas Gleixner wrote:
> > 
> > [...]
> > 
> >>>>> +		/*
> >>>>> +		 * cpuidle_enter will return with interrupt enabled
> >>>>> +		 */
> >>>>> +		cpuidle_enter(drv, dev, next_state);
> >>>>
> >>>> How is that supposed to work?
> >>>>
> >>>> If timekeeping is not yet unfrozen, then any interrupt handling code
> >>>> which calls anything time related is going to hit lala land.
> >>>>
> >>>> You must guarantee that timekeeping is unfrozen before any interrupt
> >>>> is handled. If you cannot guarantee that, you cannot freeze
> >>>> timekeeping ever.
> >>>>
> >>>> The cpu local tick device is less critical, but it happens to work by
> >>>> chance, not by design.
> >>>
> >>> There are two way to guarantee this: the first way is, disable interrupt
> >>> before timekeeping frozen and enable interrupt after timekeeping is
> >>> unfrozen. However, we need to handle wakeup handler before unfreeze
> >>> timekeeping to wake freeze task up from wait queue.
> >>>
> >>> So we have to go the other way, the other way is, we ignore time related
> >>> calls during freeze, like what I added in irq_enter below.
> >>
> >> Groan. You just do not call in irq_enter/exit(), but what prevents any
> >> interrupt handler or whatever to call into the time/timer code after
> >> interrupts got reenabled?
> >>
> >> Nothing. 
> >>
> >>> Or, we need to re-implement freeze wait and wake up mechanism?
> >>
> >> You need to make sure in the low level idle implementation that this
> >> cannot happen.
> >>
> >> tick_freeze()
> >> {
> >> 	raw_spin_lock(&tick_freeze_lock);
> >> 	tick_frozen++;
> >> 	if (tick_frozen == num_online_cpus())
> >> 		timekeeping_suspend();
> >> 	else
> >> 		tick_suspend_local();
> >> 	raw_spin_unlock(&tick_freeze_lock);
> >> }
> >>
> >> tick_unfreeze()
> >> {
> >> 	raw_spin_lock(&tick_freeze_lock);
> >> 	if (tick_frozen == num_online_cpus())
> >> 		timekeeping_resume();
> >> 	else
> >> 		tick_resume_local();
> >> 	tick_frozen--;
> >> 	raw_spin_unlock(&tick_freeze_lock);
> >> }
> >>
> >> idle_freeze()
> >> {
> >> 	local_irq_disable();
> >>
> >> 	tick_freeze();
> >>
> >> 	/* Must keep interrupts disabled! */
> >>        	go_deep_idle()
> >>
> >> 	tick_unfreeze();
> >>
> >> 	local_irq_enable();
> >> }
> >>
> >> That's the only way you can do it proper, everything else will just be
> >> a horrible mess of bandaids and duct tape.
> >>
> >> So that does not need any of the irq_enter/exit conditionals, it does
> >> not need the real_handler hack. It just works.
> > 
> > As long as go_deep_idle() above does not enable interrupts.  This means we won't
> > be able to use some C-states for suspend-to-idle (hald-induced C1 on some x86
> > for one example), but that's not a very big deal.
> 
> Does the legacy ACPI system IO method to enter C2/C3 need interrupt
> enabled as well?
> 
> Do we need some platform ops to cover those legacy platforms? Different
> platform go different branch here.

No, we don't.

I think this needs to be addressed in a different way overall.  If you don't
mind, I'd like to prepare my own version of the patch at this point.  That
likely will be simpler than trying to explain what I'd like to do and I guess
I'll need a few iterations to get something acceptable anyway.

Rafael

