Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392Ab3EADg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 23:36:28 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:37141 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761334Ab3EADgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 23:36:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130430233031.GA32310@kroah.com>
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
	<20130430233031.GA32310@kroah.com>
Date: Tue, 30 Apr 2013 20:36:21 -0700
X-Google-Sender-Auth: DewYo_qrpLFdCf_Jb1RQ7vp5EXo
Message-ID: <CAMbhsRSV+om7w2f1ht6hLmK_BrgjjQZ91iBJzR5ySTytQdndBg@mail.gmail.com>
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

On Tue, Apr 30, 2013 at 4:30 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Apr 30, 2013 at 03:28:33PM -0700, Zoran Markovic wrote:
>> From: Benoit Goby <benoit@android.com>
>>
>> Below is a patch from android kernel that detects a driver suspend
>> lockup and captures dump in the kernel log. Please review and provide
>> comments.
>
> There's this really cool thing called a watchdog driver that does stuff
> like this :)

If the watchdog driver worked in this case this patch wouldn't exist.

>> Rather than hard-lock the kernel, dump the suspend thread stack and
>> BUG() when a driver takes too long to suspend.  The timeout is set to
>> 12 seconds to be longer than the usbhid 10 second timeout.
>>
>> Exclude from the watchdog the time spent waiting for children that
>> are resumed asynchronously and time every device, whether or not they
>> resumed synchronously.
>
> No, don't add a driver-core-only timer, use the existing watchdog timers
> if you are worried about the kernel locking up.

The watchdog timers are useless here.  For one, they generally stop
when their driver suspend op is called, so you may not even have one
running when you lock up.  More importantly, the purpose of this patch
is to tell you which driver locked up and hopefully why, and the
watchdog driver will usually result in a silent reset.  This patch
will cause a stack trace of the driver suspend op that is blocking
suspend progress, even if that call does not happen in the suspend
thread.
