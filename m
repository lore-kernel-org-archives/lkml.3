Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3ELAbQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 20:31:16 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:44310 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab3ELAbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 20:31:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCHv2 1/2] drivers: power: Add watchdog timer to catch drivers which lockup during suspend/resume.
Date: Sun, 12 May 2013 02:39:44 +0200
Message-ID: <29127567.mTXaJOMILH@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAMbhsRS+fNo19srma9WqcHutJnv8driOMnpM1-yW=pduJMo63g@mail.gmail.com>
References: <1368221329-1841-1-git-send-email-zoran.markovic@linaro.org> <1368221329-1841-2-git-send-email-zoran.markovic@linaro.org> <CAMbhsRS+fNo19srma9WqcHutJnv8driOMnpM1-yW=pduJMo63g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 10, 2013 11:13:27 PM Colin Cross wrote:
> On Fri, May 10, 2013 at 2:28 PM, Zoran Markovic
> <zoran.markovic@linaro.org> wrote:
> > From: Benoit Goby <benoit@android.com>
> >
> > Below is a patch from android kernel that detects a driver suspend/resume
> > lockup and captures dump in the kernel log. Please review and provide
> > comments.
> 
> This paragraph should go below the --- line so it doesn't end up in
> the final commit message.
> 
> > Rather than hard-lock the kernel, dump the suspend/resume thread stack and
> > BUG() when a driver takes too long to suspend/resume.

And how exactly is that different from hanging the kernel?

> > The timeout is set to 12 seconds to be longer than the usbhid 10
> > second timeout.

Which is kind of arbitrary.

> > Exclude from the watchdog the time spent waiting for children that
> > are resumed asynchronously and time every device, whether or not they
> > resumed synchronously.

What about changing the code to use wait_for_completion_timeout() instead
of wait_for_completion() and actually trying to recover if one of them times
out?  [It could try to unregister the device in question and if *that* hangs
indefinitely, *then* commit a panic() or something similar, but if it succeeds,
abort the ongoing suspend or complete the resume without that device.]

Of course, that would involve changing things not to depend on async, but
might be better than slapping a timer on top.

> > This patch is targeted for mobile devices where a suspend/resume lockup
> > could cause a system reboot and catch user's attention. Information
> > about failing device can later be retrieved from captured log in
> > subsequent boot session.
> 
> I would take out the phrase "catch user's attention", the intention of
> this patch is actually the opposite - get the system back to working
> normally as fast as possible, while still putting enough information
> to debug the problem into the log.
> 
> > The hardware watchdog timer is likely suspended during this time and
> > couldn't be relied upon. The soft-lockup detector would eventually tell
> > that tasks are not scheduled, but would provide little context as to why.
> > The patch hence uses system timer and assumes it is still active while the
> > devices are suspended/resumed.

I must say I'm not particularly impressed by this patch series.  I understand
the motivation, but I'm wondering if that's the best we can do.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
