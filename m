Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbbAZNnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:43:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53898 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbbAZNnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:43:07 -0500
Date: Mon, 26 Jan 2015 14:43:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        trivial@kernel.org
Subject: Re: Change behaviour when tracing ... nasty trap (was Re: [PATCH]
 PM/Trace: get rid of synchronous resume limit during PM trace)
Message-ID: <20150126134304.GA7889@amd>
References: <54C5CB77.4000109@linux.intel.com>
 <27240C0AC20F114CBF8149A2696CBE4A01F1AD6A@SHSMSX101.ccr.corp.intel.com>
 <20150126110516.GA2028@amd>
 <2718950.eck1siDzqK@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2718950.eck1siDzqK@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document pm_tracing actually affecting suspend in non-trivial way.


Signed-off-by: Pavel Machek <pavel@ucw.cz>

---

On Mon 2015-01-26 14:41:02, Rafael J. Wysocki wrote:
> On Monday, January 26, 2015 12:05:16 PM Pavel Machek wrote:
> > On Mon 2015-01-26 10:39:04, Liu, Chuansheng wrote:

> > > > > @@ -517,8 +517,7 @@ static int device_resume_noirq(struct device *dev,
> > > > pm_message_t state, bool asyn
> > > > >
> > > > >  static bool is_async(struct device *dev)
> > > > >  {
> > > > > -	return dev->power.async_suspend && pm_async_enabled
> > > > > -		&& !pm_trace_is_enabled();
> > > > > +	return dev->power.async_suspend && pm_async_enabled;
> > > > >  }
> > > > >
> > > > 
> > > > Actually... whoever did the original patch was evil person. Changing
> > > > behaviour when tracing is requested is evil, evil, evil. Git blame
> > > > tells me
> > > > 
> > > > Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> > > > 
> > > > went to the dark side.
> > > 
> > > Although I didn't get where is something wrong, but the is_async() is not created by my commit,
> > > it is from commit (PM: Start asynchronous resume threads upfront), I just moved it ahead.
> > > 
> > > And like other phases, I added it into resum/suspend_noirq()...
> > 
> > I see, blame blamed wrong person. It looks like Rafael is evil:
> > 
> > commit 97df8c12995c5bac73e3bfeea4c5be155c1f4401
> > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > Date:   Sat Jan 23 22:25:31 2010 +0100
> > 
> >     PM: Start asynchronous resume threads upfront
> 
> This only means we won't use asyc suspend/resume at all when the RTC-based
> resume debug is enabled, because it wouldn't make sense (the RTC-based
> debug requires strict ordering of callbacks between devices or we may find
> that device A hanged the resume while actually device B that was running in
> parallel with A did that).
> 
> And I shouldn't even need to explain this ...  Sad.

Well, I forgot that pm_trace_is_enabled() is the simple, RTC based
one, and believe it would be worth a comment...

diff --git a/Documentation/power/s2ram.txt b/Documentation/power/s2ram.txt
index 1bdfa04..4685aee 100644
--- a/Documentation/power/s2ram.txt
+++ b/Documentation/power/s2ram.txt
@@ -69,6 +69,10 @@ Reason for this is that the RTC is the only reliably available piece of
 hardware during resume operations where a value can be set that will
 survive a reboot.
 
+pm_trace is not compatible with asynchronous suspend, so it turns
+asynchronous suspend off (which may work around timing or
+ordering-sensitive bugs).
+
 Consequence is that after a resume (even if it is successful) your system
 clock will have a value corresponding to the magic number instead of the
 correct date/time! It is therefore advisable to use a program like ntp-date


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
