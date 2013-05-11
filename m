Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3EKWVv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 18:21:51 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:62309 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab3EKWVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 18:21:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130511092807.GB10045@amd.pavel.ucw.cz>
References: <1368221329-1841-1-git-send-email-zoran.markovic@linaro.org>
	<1368221329-1841-3-git-send-email-zoran.markovic@linaro.org>
	<20130511092807.GB10045@amd.pavel.ucw.cz>
Date: Sat, 11 May 2013 15:21:48 -0700
X-Google-Sender-Auth: JzcXBSmbUZ60U3FOAiHHRBrio94
Message-ID: <CAMbhsRTcB6U5ctxWUy2ODOCGaYd_NdYZvWyxCOqcHiZPKGAv5w@mail.gmail.com>
Subject: Re: [RFC PATCHv2 2/2] PM: compile-time configuration of device
 suspend/resume watchdogs.
From: Colin Cross <ccross@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        Benoit Goby <benoit@android.com>, John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 2:28 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> Power management debug option to configure device suspend/resume watchdogs.
>> Available options are:
>>   1. Enable/disable the feature.
>>   2. Select triggered watchdog action between:
>>         - system panic (default)
>>         - dump stacktrace
>>         - log event
>>   3. Select timeout value for the watchdog(s).
>
> People disliked the previous behaviour, so you add 10 config
> options... with different behaviours. Also 1 second timeout is not
> acceptable for endusers (will break the system), so it should not be
> offered. In fact, remove that option, too. People doing that kind of
> debugging can modify the sources, right?

Greg KH asked for more configurable options.  I agree this may be a
little too far (I would replace the action choice with a simple "panic
on timeout?"), but its better than it was before.  Also, a 1 second
timeout is perfectly reasonable, especially if you configure it to
dump a stack trace but not panic.  Mobile devices normally finish
suspending within a few hundred ms.

> (Maybe it would make sense to do same action regular watchdog does,
> but...)
>
> That's not the way to go. If "panic" is right behaviour, just go with
> panic.

I can see uses for both panic and stack trace.  If you have a driver
that takes too long, but eventually suspends, then a panic is
unnecessary and a stack trace that you can see in the logs is better,
especially for a short timeout.

>> @@ -402,13 +422,9 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
>>  static void dpm_wd_handler(unsigned long data)
>>  {
>>       struct dpm_watchdog *wd = (void *)data;
>> -     struct device *dev      = wd->dev;
>> -     struct task_struct *tsk = wd->tsk;
>> -
>> -     dev_emerg(dev, "**** DPM device timeout ****\n");
>> -     show_stack(tsk, NULL);
>>
>> -     BUG();
>> +     dev_emerg(wd->dev, "**** DPM device timeout ****\n");
>> +     dpm_wd_action(wd);
>>  }
>>
>>  /**
>
> And merge this to previous patch. Introducing the code then redoing it
> in next patch does not help review.
>
>                                                                         Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
