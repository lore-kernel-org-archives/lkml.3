Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab3AWCf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 21:35:28 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:36032 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab3AWCf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 21:35:26 -0500
Date: Tue, 22 Jan 2013 19:35:23 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
Message-ID: <20130123023523.GC1590@obsidianresearch.com>
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
 <50FD8D07.5030908@linaro.org>
 <20130122195701.GH30647@obsidianresearch.com>
 <50FEF505.60504@linaro.org>
 <20130123002610.GA814@obsidianresearch.com>
 <50FF31D6.3090304@linaro.org>
 <20130123013710.GA1046@obsidianresearch.com>
 <50FF42CD.6010203@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FF42CD.6010203@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 05:54:21PM -0800, John Stultz wrote:

> >>complicated part. Additionally, there may be cases where the
> >>timekeeping clocksource is one clocksource and the suspend
> >>clocksource is another. So I think to properly integrate this sort
> >Does the difference matter? The clocksource to use is detected at
> >runtime, if the timekeeping clocksource is no good for suspend time
> >keeping then it just won't be used. With a distinct
> >read_persistent_clock API then they are already seperate??
> 
> Not sure I'm following you here.  I still think the selection of
> which clocksource to use for suspend timing is problematic
> (especially if its not the active timekeeping clocksource).  So I
> think instead of complicating the generic timekeeping code with the
> logic, I'd rather push it off to new read_presistent_clock api.

Well, where do you see the complication?

My thought was to save the cycle_t from *all* the clock sources during
suspend, and then on resume look for the highest priority one where
the driver reports it continued to tick the whole time. The active
timekeeping clock source doesn't seem to come into the equation??

Add
      int (*active_during_suspend)(struct clocksource *cs);
      cycle_t value_before_suspend;
To struct clocksource.

Before suspend:
  foreach(cs,all clocksources) {
      if (cs->active_during_suspend)
            cs->value_before_suspend = cs->read(cs);
  }

After resume:
  cycle_t best_delta = 0;
  struct clocksource *best_cs = NULL;
  foreach(cs,all clocksources) {
      if (cs->active_during_suspend &&
          (best_cs == NULL || cs->rating > best_cs->rating) &&
          cs->active_during_suspend(cs)) {
            best_delta = cs->read(cs) - cs->value_before_suspend;
            best_cs = cs;
      }
  }

Update the TSC driver to set the function pointer
active_during_suspend when the CPU supports non-stop TSC. Have it
return true if S3 was the deepest sleep entered during the last
suspend/resume cycle, false otherwise. Ditto for that ARM case.

This seems reasonably simple, compared to adding a new API, new
drivers, new function pointer multiplexors to arches...

Jason
