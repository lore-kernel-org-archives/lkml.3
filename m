Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab3EAEjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 00:39:48 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:37590 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab3EAEj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 00:39:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130501041731.GA24128@kroah.com>
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
	<20130430233031.GA32310@kroah.com>
	<CAMbhsRSV+om7w2f1ht6hLmK_BrgjjQZ91iBJzR5ySTytQdndBg@mail.gmail.com>
	<20130501041731.GA24128@kroah.com>
Date: Tue, 30 Apr 2013 21:39:27 -0700
X-Google-Sender-Auth: SooDYAnWqRcpazaTKA5fq59BOfI
Message-ID: <CAMbhsRT2eCKCuF1PbYY-NhGLCocE+809eZEkQYZWh42EB+SwBg@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers: power: Add watchdog timer to catch drivers
 which lockup during suspend.
From: Colin Cross <ccross@android.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 9:17 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Apr 30, 2013 at 08:36:21PM -0700, Colin Cross wrote:
>> On Tue, Apr 30, 2013 at 4:30 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Tue, Apr 30, 2013 at 03:28:33PM -0700, Zoran Markovic wrote:
>> >> From: Benoit Goby <benoit@android.com>
>> >>
>> >> Below is a patch from android kernel that detects a driver suspend
>> >> lockup and captures dump in the kernel log. Please review and provide
>> >> comments.
>> >
>> > There's this really cool thing called a watchdog driver that does stuff
>> > like this :)
>>
>> If the watchdog driver worked in this case this patch wouldn't exist.
>
> Great, let's fix the watchdog timer then :)
>
> What's wrong with it?
>
>> >> Rather than hard-lock the kernel, dump the suspend thread stack and
>> >> BUG() when a driver takes too long to suspend.  The timeout is set to
>> >> 12 seconds to be longer than the usbhid 10 second timeout.
>> >>
>> >> Exclude from the watchdog the time spent waiting for children that
>> >> are resumed asynchronously and time every device, whether or not they
>> >> resumed synchronously.
>> >
>> > No, don't add a driver-core-only timer, use the existing watchdog timers
>> > if you are worried about the kernel locking up.
>>
>> The watchdog timers are useless here.  For one, they generally stop
>> when their driver suspend op is called, so you may not even have one
>> running when you lock up.
>
> But you can fix that, right?

Ah, you're talking about the lockup detectors, and not drivers/watchdog.

The hardlockup detector can tell you if timer interrupts are not
firing, which is unaffected by this patch since the timer wouldn't
fire any way.  The softlockup detector could eventually tell you that
tasks were not being scheduled, but not why.  Even panic on softlockup
will only get you the stack trace of the current task, which will be
the locked up task if it is spinning, but is likely to be the idle
task if the suspend task is blocked on a wait_event.  This patch will
give the stack trace of the suspend operation that is blocked, even if
it is an asynchronous suspend callback.

>> More importantly, the purpose of this patch is to tell you which
>> driver locked up and hopefully why, and the watchdog driver will
>> usually result in a silent reset.
>
> I thought it was an option as to what the watchdog does when it
> triggers.
>
>> This patch will cause a stack trace of the driver suspend op that is
>> blocking suspend progress, even if that call does not happen in the
>> suspend thread.
>
> But who can see this, the machine is now dead.

I'm not sure what might still be working in this situation on x86, but
on ARM the machine is dead anyways.  Some random subset of drivers are
suspended, so you probably have no hardware watchdog, no console, no
video.  kexec on panic, kgdb on panic, console messages saved in
pstore, or jtag are the only options I know of.  This patch is very
useful in conjunction with pstore console.
