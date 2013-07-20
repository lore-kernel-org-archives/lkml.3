Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3GTImU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 04:42:20 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:52543 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3GTImJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 04:42:09 -0400
Date: Sat, 20 Jul 2013 10:42:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 2/2] watchdog: update watchdog_tresh properly
Message-ID: <20130720084205.GA17251@dhcp22.suse.cz>
References: <1374224699-13255-1-git-send-email-mhocko@suse.cz>
 <1374224699-13255-2-git-send-email-mhocko@suse.cz>
 <20130719160852.GM126784@redhat.com>
 <20130719163750.GC9759@dhcp22.suse.cz>
 <20130719180530.GO126784@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719180530.GO126784@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 19-07-13 14:05:30, Don Zickus wrote:
> On Fri, Jul 19, 2013 at 06:37:50PM +0200, Michal Hocko wrote:
> > On Fri 19-07-13 12:08:52, Don Zickus wrote:
> > > On Fri, Jul 19, 2013 at 11:04:59AM +0200, Michal Hocko wrote:
> > > > watchdog_tresh controls how often nmi perf event counter checks per-cpu
> > > > hrtimer_interrupts counter and blows up if the counter hasn't changed
> > > > since the last check. The counter is updated by per-cpu watchdog_hrtimer
> > > > hrtimer which is scheduled with 2/5 watchdog_thresh period which
> > > > guarantees that hrtimer is scheduled 2 times per the main period. Both
> > > > hrtimer and perf event are started together when the watchdog is
> > > > enabled.
> > > > 
> > > > So far so good. But...
> > > > 
> > > > But what happens when watchdog_thresh is updated from sysctl handler?
> > > > 
> > > > proc_dowatchdog will set a new sampling period and hrtimer callback
> > > > (watchdog_timer_fn) will use the new value in the next round.
> > > > The problem, however, is that nobody tells the perf event that the
> > > > sampling period has changed so it is ticking with the period configured
> > > > when it has been set up.
> > > > 
> > > > This might result in an ear riping dissonance between perf and hrtimer
> > > > parts if the watchdog_thresh is increased. And even worse it might lead
> > > > to KABOOM if the watchdog is configured to panic on such a spurious
> > > > lockup.
> > > 
> > > Heh.  Good point.
> > > 
> > > What if we keep it simpler.
> > > 
> > > if (old_thresh != watchdog_thresh)
> > >   watchdog_disable_all_cpus()
> > >   wathcdog_enable_all_cpus()
> > 
> > Those would do nothing because of watchdog_disabled checks. It is also
> 
> I guess I am missing something because I don't see the watchdog_disabled
> checks getting in the way. 

You are not missing anything. I should read more carefully.

> If the watchdog is already enabled, then the disable/enable approach
> should work correctly, no?  The watchdog_disabled only blocks from
> re-disabling or re-enabling the watchdog IIUC.

Yes, you are right.
 
> > much more heavy than necessary. I hope we can get a perf API which just
> > update the perf event period directly and we do not have to call even
> > watchdog_nmi_{en,dis}able
> 
> Well the reason for the heaviness is, even with the proposed API you
> suggest, there is a problem with the softlockup's hrtimer.  If you set the
> watchdog_thresh high like say 60 seconds, then the hrtimer fires every 12
> seconds or so (while the nmi watchdog fires every 60 seconds or so).

True. I was so focused on the particular bug I was dealing with that I
didn't consider the other direction. My bad and thanks for pointing it
out.
You even do not have to play with setting the value high and then
low. It is sufficient to set the value to lower than 4 (from default 10)
and you have the same problem.

> Now lets adjust the theshold down to 10 seconds.  The current code doesn't
> reset the hrtimer to the new value until it goes off again (which at worse
> case is 12 seconds).  The API you propose would allow the nmi_watchdog to
> fire in 10 seconds.  As a result you would have a potential to cause a
> panic on a false lockup.
> 
> So if you are going to adjust the nmi_watchdog, you have to adjust the
> softlockup value too.  Hence the heavy-ness.
> 
> Unless you have another solution for the above problem?

We can cancel and restart the hrtimer, I guess. I will look into it on
Monday.

Thanks!
-- 
Michal Hocko
SUSE Labs
