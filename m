Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab3GSQJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:09:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab3GSQJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:09:05 -0400
Date: Fri, 19 Jul 2013 12:08:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 2/2] watchdog: update watchdog_tresh properly
Message-ID: <20130719160852.GM126784@redhat.com>
References: <1374224699-13255-1-git-send-email-mhocko@suse.cz>
 <1374224699-13255-2-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374224699-13255-2-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 11:04:59AM +0200, Michal Hocko wrote:
> watchdog_tresh controls how often nmi perf event counter checks per-cpu
> hrtimer_interrupts counter and blows up if the counter hasn't changed
> since the last check. The counter is updated by per-cpu watchdog_hrtimer
> hrtimer which is scheduled with 2/5 watchdog_thresh period which
> guarantees that hrtimer is scheduled 2 times per the main period. Both
> hrtimer and perf event are started together when the watchdog is
> enabled.
> 
> So far so good. But...
> 
> But what happens when watchdog_thresh is updated from sysctl handler?
> 
> proc_dowatchdog will set a new sampling period and hrtimer callback
> (watchdog_timer_fn) will use the new value in the next round.
> The problem, however, is that nobody tells the perf event that the
> sampling period has changed so it is ticking with the period configured
> when it has been set up.
> 
> This might result in an ear riping dissonance between perf and hrtimer
> parts if the watchdog_thresh is increased. And even worse it might lead
> to KABOOM if the watchdog is configured to panic on such a spurious
> lockup.

Heh.  Good point.

What if we keep it simpler.

if (old_thresh != watchdog_thresh)
  watchdog_disable_all_cpus()
  wathcdog_enable_all_cpus()

The idea is that we are not changing thresholds that often and if we do, we
should probably sync up all the timers and threads again.  Safer to start
from scratch.

Thoughts?

Cheers,
Don
