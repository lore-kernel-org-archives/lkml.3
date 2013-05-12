Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab3ELTPK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 15:15:10 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:41305 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3ELTPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 15:15:08 -0400
MIME-Version: 1.0
In-Reply-To: <29127567.mTXaJOMILH@vostro.rjw.lan>
References: <1368221329-1841-1-git-send-email-zoran.markovic@linaro.org>
	<1368221329-1841-2-git-send-email-zoran.markovic@linaro.org>
	<CAMbhsRS+fNo19srma9WqcHutJnv8driOMnpM1-yW=pduJMo63g@mail.gmail.com>
	<29127567.mTXaJOMILH@vostro.rjw.lan>
Date: Sun, 12 May 2013 12:15:06 -0700
X-Google-Sender-Auth: 5_XanUpfDcmNKYu-nZwQ2AtcBwU
Message-ID: <CAMbhsRSweH-gwq4yettOnw9bDQebYR8A2o71nWRjY4aN=1+++w@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/2] drivers: power: Add watchdog timer to catch
 drivers which lockup during suspend/resume.
From: Colin Cross <ccross@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
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

On Sat, May 11, 2013 at 5:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, May 10, 2013 11:13:27 PM Colin Cross wrote:
>> On Fri, May 10, 2013 at 2:28 PM, Zoran Markovic
>> <zoran.markovic@linaro.org> wrote:
>> > From: Benoit Goby <benoit@android.com>
>> >
>> > Below is a patch from android kernel that detects a driver suspend/resume
>> > lockup and captures dump in the kernel log. Please review and provide
>> > comments.
>>
>> This paragraph should go below the --- line so it doesn't end up in
>> the final commit message.
>>
>> > Rather than hard-lock the kernel, dump the suspend/resume thread stack and
>> > BUG() when a driver takes too long to suspend/resume.
>
> And how exactly is that different from hanging the kernel?

This works best with reboot on panic + pstore ram console, which
results in rebooting to a kernel in a good state that can inspect the
stack trace.

>> > The timeout is set to 12 seconds to be longer than the usbhid 10
>> > second timeout.
>
> Which is kind of arbitrary.

The next patch (which should be squashed into this one) makes this
timeout configurable.

>> > Exclude from the watchdog the time spent waiting for children that
>> > are resumed asynchronously and time every device, whether or not they
>> > resumed synchronously.
>
> What about changing the code to use wait_for_completion_timeout() instead
> of wait_for_completion() and actually trying to recover if one of them times
> out?  [It could try to unregister the device in question and if *that* hangs
> indefinitely, *then* commit a panic() or something similar, but if it succeeds,
> abort the ongoing suspend or complete the resume without that device.]

I don't think this is feasible.  What do you do if userspace was using
the device?  What do you do if the suspend function later starts
running again if the blocking condition clears up, and starts
accessing hardware for an unregistered device?  Trying to unload a
driver that is known to be misbehaving sounds to me like it is going
to result in an even more unstable situation.  The purpose of this
patch is to get the end user's phone back into a usable state as fast
as possible, while still providing the information needed to debug the
issue to power users or developers.

> Of course, that would involve changing things not to depend on async, but
> might be better than slapping a timer on top.
>
>> > This patch is targeted for mobile devices where a suspend/resume lockup
>> > could cause a system reboot and catch user's attention. Information
>> > about failing device can later be retrieved from captured log in
>> > subsequent boot session.
>>
>> I would take out the phrase "catch user's attention", the intention of
>> this patch is actually the opposite - get the system back to working
>> normally as fast as possible, while still putting enough information
>> to debug the problem into the log.
>>
>> > The hardware watchdog timer is likely suspended during this time and
>> > couldn't be relied upon. The soft-lockup detector would eventually tell
>> > that tasks are not scheduled, but would provide little context as to why.
>> > The patch hence uses system timer and assumes it is still active while the
>> > devices are suspended/resumed.
>
> I must say I'm not particularly impressed by this patch series.  I understand
> the motivation, but I'm wondering if that's the best we can do.

This feature is most useful for Android devices, which is why we never
pushed it upstream ourselves.  It has been extremely valuable to us
during development, we have been using it for years and it turns a
class of bugs that is very difficult to debug ("phone is stuck with
screen off", none of the regular debugging tools are useful because
most drivers are suspended) into something that can be trivially
collected out of the logs on the next reboot.
