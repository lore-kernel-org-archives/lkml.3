Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870Ab3GSQh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:37:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760551Ab3GSQh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:37:56 -0400
Date: Fri, 19 Jul 2013 18:37:50 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 2/2] watchdog: update watchdog_tresh properly
Message-ID: <20130719163750.GC9759@dhcp22.suse.cz>
References: <1374224699-13255-1-git-send-email-mhocko@suse.cz>
 <1374224699-13255-2-git-send-email-mhocko@suse.cz>
 <20130719160852.GM126784@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719160852.GM126784@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 19-07-13 12:08:52, Don Zickus wrote:
> On Fri, Jul 19, 2013 at 11:04:59AM +0200, Michal Hocko wrote:
> > watchdog_tresh controls how often nmi perf event counter checks per-cpu
> > hrtimer_interrupts counter and blows up if the counter hasn't changed
> > since the last check. The counter is updated by per-cpu watchdog_hrtimer
> > hrtimer which is scheduled with 2/5 watchdog_thresh period which
> > guarantees that hrtimer is scheduled 2 times per the main period. Both
> > hrtimer and perf event are started together when the watchdog is
> > enabled.
> > 
> > So far so good. But...
> > 
> > But what happens when watchdog_thresh is updated from sysctl handler?
> > 
> > proc_dowatchdog will set a new sampling period and hrtimer callback
> > (watchdog_timer_fn) will use the new value in the next round.
> > The problem, however, is that nobody tells the perf event that the
> > sampling period has changed so it is ticking with the period configured
> > when it has been set up.
> > 
> > This might result in an ear riping dissonance between perf and hrtimer
> > parts if the watchdog_thresh is increased. And even worse it might lead
> > to KABOOM if the watchdog is configured to panic on such a spurious
> > lockup.
> 
> Heh.  Good point.
> 
> What if we keep it simpler.
> 
> if (old_thresh != watchdog_thresh)
>   watchdog_disable_all_cpus()
>   wathcdog_enable_all_cpus()

Those would do nothing because of watchdog_disabled checks. It is also
much more heavy than necessary. I hope we can get a perf API which just
update the perf event period directly and we do not have to call even
watchdog_nmi_{en,dis}able

-- 
Michal Hocko
SUSE Labs
