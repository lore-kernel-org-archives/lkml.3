Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaKMBhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 20:37:25 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58407 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbaKMBhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 20:37:24 -0500
Date: Thu, 13 Nov 2014 02:37:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] PM / Sleep: Timer quiesce in freeze state
Message-ID: <20141113013707.GQ29390@twins.programming.kicks-ass.net>
References: <5446787E.60202@linux.intel.com>
 <20141024153656.GM12706@worktop.programming.kicks-ass.net>
 <544DE5CF.9040501@linux.intel.com>
 <20141027074419.GE10501@worktop.programming.kicks-ass.net>
 <544F4B31.7050308@linux.intel.com>
 <20141028082503.GN3337@twins.programming.kicks-ass.net>
 <5450253B.5020802@linux.intel.com>
 <20141029082432.GV3337@twins.programming.kicks-ass.net>
 <5451A94F.1090200@linux.intel.com>
 <alpine.DEB.2.11.1411121558280.3935@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411121558280.3935@nanos>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 10:09:47PM +0100, Thomas Gleixner wrote:
> On Thu, 30 Oct 2014, Li, Aubrey wrote:
> 
> > Freeze is a general power saving state that processes are frozen, devices
> > are suspended and CPUs are in idle state. However, when the system enters
> > freeze state, there are a few timers keep ticking and hence consumes more
> > power unnecessarily. The observed timer events in freeze state are:
> > - tick_sched_timer
> > - watchdog lockup detector
> > - realtime scheduler period timer
> > 
> > The system power consumption in freeze state will be reduced significantly
> > if we quiesce these timers.
> 
> So the obvious question is why dont we quiesce these timers by telling
> the subsystems which manage these timers to shut them down?
> 
> I really want a proper answer for this in the first place, but let me
> look at the proposed "solution" as well.

Two arguments here:

 1) the current suspend modes don't care, so if this suspend mode starts
 to care, its likely to 'break' in the future simply because people
 never cared about timers.

 2) there could be userland timers, userland is frozen but they'll still
 have their timers set and those can and will fire.

But sure, we can add suspend notifiers to stuff to shut down timers; I
should have a patch for at least one of the offenders somewhere. But I
really think that we should not be looking at the individual timers for
this, none of the other suspend modes care about active timers.

> But before we do that we want a proper explanation why the interrupt
> fires at all. The lack of explanation cleary documents that this is a
> 'hacked it into submission' approach.

>From what I remember its the waking interrupt that ends up in the
timekeeping code, Li should have a backtrace somwhere.

> > +#include "../time/tick-internal.h"
> > +#include "../time/timekeeping_internal.h"
> 
> Eew.

I knew you'd love that :-)

> So you export the world and some more from timekeeping and the tick
> code and fiddle with it randomly just to do:
> 
> 1) Suspend clock event devices
> 2) Suspend timekeeping
> 3) Resume timekeeping
> 4) Resume clock event devices

Sure, we can add some exports and clean that up, but..

> stomp_machine() is in 99% of all use cases a clear indicator for a
> complete design failure.

>    So the generic idle task needs a check like this:
> 
>    if (idle_should_freeze())
>       	frozen_idle();

So that is adding extra code to fairly common/hot paths just for this
one extra special case. I tried to avoid doing that.

But I suppose we can try and merge that with the offline case and guard
both special cases with a single variable or so.
