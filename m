Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab3CGPtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:49:16 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46485 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab3CGPtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:49:15 -0500
Date: Thu, 7 Mar 2013 07:49:07 -0800
From: Tejun Heo <tj@kernel.org>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: linux-kernel@vger.kernel.org, leiwen@marvell.com, wwang27@marvell.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: workqueue panic in 3.4 kernel
Message-ID: <20130307154907.GB29601@htj.dyndns.org>
References: <CALZhoSR0+SzPLHzJafmny=o8PJ2d7MaH9N6_6s0QZ_oCQm43Xg@mail.gmail.com>
 <20130305163228.GA12795@htj.dyndns.org>
 <CALZhoSRyjRYVcKpq9cECHWgKkci6V+O_zn2CkiwqnFo57tZDfQ@mail.gmail.com>
 <20130306191408.GN1227@htj.dyndns.org>
 <CALZhoSTPBNjhUP4R=vX0Ot7eAA8POTAy8K5Cd3KRe_y8PzjfFA@mail.gmail.com>
 <CALZhoSRJ+HV93tDJo-57M-SdXi8Z6qW_bRV9FzSfGWuz8j-t8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZhoSRJ+HV93tDJo-57M-SdXi8Z6qW_bRV9FzSfGWuz8j-t8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Thomas, hi!)

Hello,

Lei is seeing a problem where a delayed_work item gets corrupted (its
work->data gets cleared while still queued on the timer).  He thinks
what's going on is that del_timer() is returning 1 but the timer
function still gets executed.

On Thu, Mar 07, 2013 at 11:22:40PM +0800, Lei Wen wrote:
> >> If del_timer() happens after the timer starts running, del_timer()
> >> would return NULL and try_to_grab_pending() will be called which will
> >> return >=0 iff if successfully steals the PENDING bit (ie. it's the
> >> sole owner of the work item).  If del_timer() happens before the timer
> >> starts running, the timer function would never run.
> >
> > If del_timer() happen before __run_timers() is called, while timer irq
> > already happen,
> > would it return 1 for the timer is still not detached in __run_timers()?
> > If it is possible, then we would call try_to_grab_pending(), so that
> > work->data would
> > be cleared in this way.
> >
> >>
> >> clear_work_data() happens iff the work item is confirmed to be idle.
> >> At this point, I'm pretty skeptical this is a bug in workqueue itself
> >> and strongly suggest looking at the crashing workqueue user.
> >
> > Also I am not very familiar with workqueue mechanism, how many place
> > in kernel would
> > clear the work->data beside the clear_work_data()?

Work item initialization and clear_work_data() are the only places and
from the looks of it you definitely seem to be hitting
clear_work_data().

> > From the memory, I cannot find any hint for work structure being destroyed.
> > So the only possible seems to me is the work->data be set by someone on purpose.
> >
> > crash> struct delayed_work 0xbf03d544 -x
> > struct delayed_work {
> >   work = {
> >     data = {
> >       counter = 0x300
> >     },
> >     entry = {
> >       next = 0xbf03d548,
> >       prev = 0xbf03d548
> >     },
> >     func = 0xbf014b00
> >   },
> >   timer = {
> >     entry = {
> >       next = 0x0,
> >       prev = 0x200200
> >     },
> >     expires = 0x12b638b,
> >     base = 0xc0844e01,
> >     function = 0xc014c7a0 <delayed_work_timer_fn>,
> >     data = 0xbf03d544,
> >     slack = 0xffffffff,
> >     start_pid = 0xffffffff,
> >     start_site = 0x0,
> >     start_comm = "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
> >   }
> > }
> 
> I captured a trace log, which shows my previous suspicion is true:
> __cancel_work_timer is called before delayed_work_timer_fn, so that
> work->data is cleared.
> 
> And when __cancel_work_timer is called, the timer is still pending,
> so del_timer would return 1, thus no try_to_grab_pending would be called.
> 
> But it is very strange that in __run_timers, it still get the same timer.
> Then its callback, delayed_work_timer_fn, would be called, which cause
> the issue.
> 
> The detach_timer in __cancel_work_timer should already move the timer
> from all list, am I right?

Yes.

> Could it happen for the timer_list be queued twice, like queue over two cpu?
> If not, how could it happen?

I can't see how something like that would happen and still find it
quite unlikely this would be a generic problem in either timer or
workqueue given how widely those are used and your case is the only
similar case that came up till now (and 3.4 is a long time ago).
Thomas, any ideas?

Thanks.

-- 
tejun
