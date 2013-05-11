Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3EKJ2L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 05:28:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35701 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab3EKJ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 05:28:09 -0400
Date: Sat, 11 May 2013 11:28:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zoran Markovic <zoran.markovic@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        Colin Cross <ccross@android.com>, Todd Poynor <toddpoynor@google.com>,
        San Mehat <san@google.com>, Benoit Goby <benoit@android.com>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCHv2 2/2] PM: compile-time configuration of device
 suspend/resume watchdogs.
Message-ID: <20130511092807.GB10045@amd.pavel.ucw.cz>
References: <1368221329-1841-1-git-send-email-zoran.markovic@linaro.org>
 <1368221329-1841-3-git-send-email-zoran.markovic@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368221329-1841-3-git-send-email-zoran.markovic@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Power management debug option to configure device suspend/resume watchdogs.
> Available options are:
>   1. Enable/disable the feature.
>   2. Select triggered watchdog action between:
>         - system panic (default)
>         - dump stacktrace
>         - log event
>   3. Select timeout value for the watchdog(s).

People disliked the previous behaviour, so you add 10 config
options... with different behaviours. Also 1 second timeout is not
acceptable for endusers (will break the system), so it should not be
offered. In fact, remove that option, too. People doing that kind of
debugging can modify the sources, right?

(Maybe it would make sense to do same action regular watchdog does,
but...)

That's not the way to go. If "panic" is right behaviour, just go with
panic.

> @@ -402,13 +422,9 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
>  static void dpm_wd_handler(unsigned long data)
>  {
>  	struct dpm_watchdog *wd = (void *)data;
> -	struct device *dev      = wd->dev;
> -	struct task_struct *tsk = wd->tsk;
> -
> -	dev_emerg(dev, "**** DPM device timeout ****\n");
> -	show_stack(tsk, NULL);
>  
> -	BUG();
> +	dev_emerg(wd->dev, "**** DPM device timeout ****\n");
> +	dpm_wd_action(wd);
>  }
>  
>  /**

And merge this to previous patch. Introducing the code then redoing it
in next patch does not help review.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
