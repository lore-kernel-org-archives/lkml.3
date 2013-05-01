Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654Ab3EAK4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 06:56:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60977 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab3EAK4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 06:56:32 -0400
Date: Wed, 1 May 2013 12:56:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Colin Cross <ccross@android.com>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] drivers: power: Add watchdog timer to catch
 drivers which lockup during suspend.
Message-ID: <20130501105630.GA22552@amd.pavel.ucw.cz>
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
 <20130501003058.GB20042@amd.pavel.ucw.cz>
 <CAMbhsRQkYFvOzDDn4zmbZAEsVs6iSy4mPVq5w=MzQ7p9STBDew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRQkYFvOzDDn4zmbZAEsVs6iSy4mPVq5w=MzQ7p9STBDew@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> @@ -663,6 +671,30 @@ static bool is_async(struct device *dev)
> >>  }
> >>
> >>  /**
> >> + *     dpm_drv_timeout - Driver suspend / resume watchdog handler
> >> + *     @data: struct device which timed out
> >> + *
> >> + *     Called when a driver has timed out suspending or resuming.
> >> + *     There's not much we can do here to recover so
> >> + *     BUG() out for a crash-dump
> >> + *
> >> + */
> >> +static void dpm_drv_timeout(unsigned long data)
> >> +{
> >> +     struct dpm_drv_wd_data *wd_data = (void *)data;
> >> +     struct device *dev = wd_data->dev;
> >> +     struct task_struct *tsk = wd_data->tsk;
> >> +
> >> +     pr_emerg("**** DPM device timeout: %s (%s)\n", dev_name(dev),
> >> +             (dev->driver ? dev->driver->name : "no driver"));
> >> +
> >> +     pr_emerg("dpm suspend stack:\n");
> >> +     show_stack(tsk, NULL);
> >> +
> >> +     BUG();
> >> +}
> >
> > So you:
> >
> > dump stack of the suspend task
> It dumps the stack of the suspend task if the suspend callback is run
> synchronously, or the async task if the suspend op is run
> asynchronously.

Lets call that [a]suspend task.

> > do BUG which
> >    dumps stack of current task
> >    kills current task
> >
> > Current task may very well be idle task; in such case you kill the
> > machine. Sounds like you should be doing something else, like kill -9
> > instead of BUG()?
> 
> Not much else you can do, you are stuck part way into suspend with a
> driver's suspend callback half executed.  All userspace tasks are
> frozen, and the suspend task is blocked indefinitely.

Yes, there's better option. Attempt killing the [a]suspend task,
instead of killing the current task.

Try putting mdelay(100000) into suspend path. Your patch will do the
wrong thing in that case (actually turning debuggable problem into
undebuggable one).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
