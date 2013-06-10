Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3FJVZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:25:24 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:60230 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3FJVZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:25:21 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1306061006070.1069-100000@iolanthe.rowland.org>
References: <CAME+o4mkBknj0jiUW=Z77fG1bJYy1jHF7=shNQ_ixeL_oJDjFg@mail.gmail.com>
	<Pine.LNX.4.44L0.1306061006070.1069-100000@iolanthe.rowland.org>
Date: Mon, 10 Jun 2013 14:25:20 -0700
X-Google-Sender-Auth: v0M-NcOi37pRRDNThOfFi26Icak
Message-ID: <CAMbhsRRyEa-dCnVQg5bDFFC3O6Zyz_YXAH05-Ju49Ug2V_fvxw@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/2] drivers: power: Add watchdog timer to catch
 drivers which lockup during suspend/resume.
From: Colin Cross <ccross@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 7:12 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 5 Jun 2013, Zoran Markovic wrote:
>
>> > It does block in my environment, AFAICS. Looking a bit further in the
>> > code, it looks like dpm_suspend() does an async_synchronize_full()
>> > which would wait for all async tasks to complete. This is a
>> > show-stopper because (under the circumstances) the assumption that
>> > every async suspend routine eventually completes doesn't hold.
>> >
>> > We could possibly select which async tasks to wait for, but this would
>> > add unnecessary complexity to a feature targeted for debugging. It
>> > seems that this approach - although sounding reasonable - needs to
>> > wait until we have a mechanism to cancel an async task.
>>
>> Looks like the implementation of proposal for an async suspend +
>> wait_for_completion_timeout is quite complex due to above limitations.
>> How do we proceed from here? We have the following options:
>> 1. Give up on the idea of having a suspend/resume watchdog.
>> 2. Use the timer implementation (with possible modifications).
>> 3. Wait for the implementation of (or implement) killing of an already
>> running async work.
>>
>> Are there any other ideas floating around?
>
> In general, the kernel is not designed to operate when kernel threads
> get killed at random times.  It's also not designed to operate normally
> while in the middle of a system suspend.
>
> This means there is basically no hope of recovering from a hung async
> suspend task.  (In much the same way, there is no hope of recovering
> from any hung kernel thread.)  The best you can accomplish is to store
> some useful information somewhere and either panic or force a reboot.
>
> Given that the usual storage media may be inaccessible, it may not be
> easy to find a place to store the information.
>
> (By the way, what do you do if a _synchronous_ suspend routine hangs?
> The two problems are fairly similar.)

This is why the original patch dumped a stack trace of the offending
task and panic'd.  There is nothing else useful you can do.
