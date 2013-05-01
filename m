Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab3EAQK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:10:58 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:40383 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3EAQKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:10:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130501105630.GA22552@amd.pavel.ucw.cz>
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
	<20130501003058.GB20042@amd.pavel.ucw.cz>
	<CAMbhsRQkYFvOzDDn4zmbZAEsVs6iSy4mPVq5w=MzQ7p9STBDew@mail.gmail.com>
	<20130501105630.GA22552@amd.pavel.ucw.cz>
Date: Wed, 1 May 2013 09:10:49 -0700
X-Google-Sender-Auth: 1kdNXNnCEQOfjcXlCoXmbg-ZBbs
Message-ID: <CAMbhsRTtYSLpAmB0hsanBH3ez4bm8BgbcH1xEBQsZSj4dc069g@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers: power: Add watchdog timer to catch drivers
 which lockup during suspend.
From: Colin Cross <ccross@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 3:56 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> @@ -663,6 +671,30 @@ static bool is_async(struct device *dev)
>> >>  }
>> >>
>> >>  /**
>> >> + *     dpm_drv_timeout - Driver suspend / resume watchdog handler
>> >> + *     @data: struct device which timed out
>> >> + *
>> >> + *     Called when a driver has timed out suspending or resuming.
>> >> + *     There's not much we can do here to recover so
>> >> + *     BUG() out for a crash-dump
>> >> + *
>> >> + */
>> >> +static void dpm_drv_timeout(unsigned long data)
>> >> +{
>> >> +     struct dpm_drv_wd_data *wd_data = (void *)data;
>> >> +     struct device *dev = wd_data->dev;
>> >> +     struct task_struct *tsk = wd_data->tsk;
>> >> +
>> >> +     pr_emerg("**** DPM device timeout: %s (%s)\n", dev_name(dev),
>> >> +             (dev->driver ? dev->driver->name : "no driver"));
>> >> +
>> >> +     pr_emerg("dpm suspend stack:\n");
>> >> +     show_stack(tsk, NULL);
>> >> +
>> >> +     BUG();
>> >> +}
>> >
>> > So you:
>> >
>> > dump stack of the suspend task
>> It dumps the stack of the suspend task if the suspend callback is run
>> synchronously, or the async task if the suspend op is run
>> asynchronously.
>
> Lets call that [a]suspend task.
>
>> > do BUG which
>> >    dumps stack of current task
>> >    kills current task
>> >
>> > Current task may very well be idle task; in such case you kill the
>> > machine. Sounds like you should be doing something else, like kill -9
>> > instead of BUG()?
>>
>> Not much else you can do, you are stuck part way into suspend with a
>> driver's suspend callback half executed.  All userspace tasks are
>> frozen, and the suspend task is blocked indefinitely.
>
> Yes, there's better option. Attempt killing the [a]suspend task,
> instead of killing the current task.

That will leave you in a completely undefined state.  If you just kill
the task, you are likely to kill the synchronous suspend task, which
is the task that would resume your drivers and unfreeze tasks.  That
will leave you with no userspace tasks running, and much of your
hardware suspended.  How is that a useful result?  If you somehow
respawn a resume thread to resume whatever hardware you can and
unfreeze tasks, you still have the hardware that was suspending when
it was killed in a bad state, and probably has locks held, so you're
just going to deadlock or crash soon after.

> Try putting mdelay(100000) into suspend path. Your patch will do the
> wrong thing in that case (actually turning debuggable problem into
> undebuggable one).

I'm not saying this patch as is is right for everyone (it probably at
least needs to be configurable to be turned off, change the delay, and
change the panic to just a stack trace), but from a mobile perspective
this patch is far more debuggable than without this patch.  We work
very hard to make sure that panic's are highly debuggable, in fact we
often prefer panics over any other behavior when the device is in a
bad state, because it immediately gets the user's device working again
while still giving us useful information in our automatic log
collection.

With an mdelay(100000) in the suspend path, users in our debug device
pool are likely to just pull the battery because their screen won't
turn on, in which case I get no debugging information.  With this
patch, the device will automatically reboot due to the panic, and I
will get captured logs after reboot that show a stack trace ending
with
mdelay, which tells me exactly where to look for this mdelay(100000).
