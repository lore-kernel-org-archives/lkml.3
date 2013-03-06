Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab3CFOaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:30:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:54653 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882Ab3CFOaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:30:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,795,1355126400"; 
   d="scan'208";a="300107177"
Date: Wed, 6 Mar 2013 22:29:14 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v3 5/5] timekeeping: utilize the suspend-nonstop
 clocksource to count suspended time
Message-ID: <20130306142914.GA25790@feng-snb>
References: <1362554271-22382-1-git-send-email-feng.tang@intel.com>
 <1362554271-22382-6-git-send-email-feng.tang@intel.com>
 <alpine.LFD.2.02.1303061512110.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1303061512110.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 03:15:49PM +0100, Thomas Gleixner wrote:
> On Wed, 6 Mar 2013, Feng Tang wrote:
> 
> > There are some new processors whose TSC clocksource won't stop during
> > suspend. Currently, after system resumes, kernel will use persistent
> > clock or RTC to compensate the sleep time, but for those new types of
> > clocksources, we could skip the special compensation from external
> > sources, and just use current clocksource for time recounting.
> > 
> > This can solve some time drift bugs caused by some not-so-accurate or
> > error-prone RTC devices.
> > 
> > The current way to count suspened time is first try to use the persistent
> > clock, and then try the rtc if persistent clock can't be used. This
> > patch will change the trying order to:
> > 	suspend-nonstop clocksource -> persistent clock -> rtc
> > 
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > ---
> >  kernel/time/timekeeping.c |   42 ++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 34 insertions(+), 8 deletions(-)
> > -	read_persistent_clock(&ts);
> > +	ts_delta.tv_sec = 0;
> > +	read_persistent_clock(&ts_new);
> >  
> >  	clockevents_resume();
> >  	clocksource_resume();
> >  
> >  	write_seqlock_irqsave(&tk->lock, flags);
> >  
> > -	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
> > -		ts = timespec_sub(ts, timekeeping_suspend_time);
> > -		__timekeeping_inject_sleeptime(tk, &ts);
> > -	}
> > -	/* re-base the last cycle value */
> > -	tk->clock->cycle_last = tk->clock->read(tk->clock);
> > +	/*
> > +	 * After system resumes, we need to calculate the suspended time and
> > +	 * compensate it for the OS time. There are 3 sources that could be
> > +	 * used: Nonstop clocksource during suspend, persistent clock and rtc
> > +	 * device.
> > +	 *
> > +	 * One specific platform may have 1 or 2 or all of them, and the
> > +	 * preference will be:
> > +	 *	suspend-nonstop clocksource -> persistent clock -> rtc
> > +	 * The less preferred source will only be tried if there is no better
> > +	 * usable source. The rtc part is handled separately in rtc core code.
> > +	 */
> > +	cycle_now = clock->read(clock);
> > +	if ((clock->flags & CLOCK_SOURCE_SUSPEND_NONSTOP) &&
> > +		cycle_now > clock->cycle_last) {
> > +
> > +		cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> > +		nsec = clocksource_cyc2ns(cycle_delta, clock->mult,
> > +							clock->shift);
> > +		ts_delta = ns_to_timespec(nsec);
> > +	} else if (timespec_compare(&ts_new, &timekeeping_suspend_time) > 0)
> > +		ts_delta = timespec_sub(ts_new, timekeeping_suspend_time);
> > +
> > +	if (ts_delta.tv_sec >= 1)
> > +		__timekeeping_inject_sleeptime(tk, &ts_delta);
> 
> If the suspend time measured by the nonstop clocksource is 0.999 sec
> then we throw it away and then let the RTC code inject inaccurate
> sleep time? Brilliant design, really.

Emm, I wrote the code with an assumption that the sleep itself and the
enter/exit processes will be longer than 1 second.

I can initialize the ts_delta to (0, 0} and change the check condition
to 
	if (ts_delta.tv_sec || ts_delta.tv_nsec)
